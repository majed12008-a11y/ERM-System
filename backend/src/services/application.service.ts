/*
 * إدارة طلبات البحث: إنشاء، تقديم، مراجعة، اعتماد، رفض.
 * تتحقق من صحة البيانات وترسل الإشعارات للمستخدمين المعنيين.
 * تخضع جميع العمليات لسياسات RLS.
 */
import { ApplicationRepository } from '../repositories/application.repository';
import { ApplicationRow } from '../shared/db-types';
import { AuthUser } from '../shared/types';
import { PaginationParams, paginatedResult, PaginatedResult } from '../shared/pagination';
import { broadcastDashboardEvent, NotificationService } from './notification.service';
import { TRANSITION_TO_NOTIFICATION } from './notification-types';
import { WorkflowService } from './workflow.service';
import { ConditionService } from './condition.service';
import { ConditionRepository } from '../repositories/condition.repository';
import { CertificateService } from './certificate.service';
import { CertificateRepository } from '../repositories/certificate.repository';
import { DocumentRepository } from '../repositories/document.repository';
import { withTransaction } from '../config/database';
import { EDITABLE_APPLICATION_STATUSES } from '../shared/application.constants';
import { logger } from '../config/logger';

export class ApplicationService {
  constructor(
    private repo = new ApplicationRepository(),
    private workflow = new WorkflowService(),
    private conditions = new ConditionService(new ConditionRepository()),
    private certificates = new CertificateService(
      new CertificateRepository(),
      new DocumentRepository(),
    ),
  ) {}

  async getAll(
    params: PaginationParams,
    user: AuthUser,
    status?: string
  ): Promise<PaginatedResult<ApplicationRow>> {
    const { rows, total } = await this.repo.findAll(
      params,
      user.id,
      user.roles,
      status
    );
    return paginatedResult(rows, total, params);
  }

  async getById(id: number): Promise<ApplicationRow> {
    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }
    return app;
  }

  async create(data: {
    project_id: number;
    application_type: string;
    target_committee_id: number;
    save_as_draft?: boolean;
  }, user: AuthUser): Promise<ApplicationRow> {
    const saveAsDraft = data.save_as_draft !== false;

    const app = await withTransaction(async (client) => {
      const applicationNumber = await this.repo.generateApplicationNumber(client);

      const newApp = await this.repo.create({
        application_number: applicationNumber,
        project_id: data.project_id,
        application_type: data.application_type,
        submitted_by: user.id,
        target_committee_id: data.target_committee_id,
      }, client);

      if (saveAsDraft) return newApp;

      await this.workflow.initWorkflow('APP_REVIEW_V1', 'Application', newApp.id, client);
      const result = await this.workflow.executeTransition('Application', newApp.id, 'SUBMIT', user, undefined, client);

      const submitted = await this.repo.updateStatus(newApp.id, result.to_state, client);
      if (!submitted) {
        const err = new Error('Failed to submit application') as any;
        err.status = 400;
        throw err;
      }

      return submitted;
    });

    broadcastDashboardEvent('dashboard-stats', {});

    if (!saveAsDraft) {
      const notifService = new NotificationService();
      await notifService.send({
        userId: user.id,
        notificationType: 'APPLICATION_SUBMITTED',
        subject: `Application #${app.id} Submitted`,
        messageBody: 'Your application has been submitted for review.',
        sourceEntityType: 'Application',
        sourceEntityId: app.id,
      });
    }

    return app;
  }

  async updateDraft(
    id: number,
    data: { application_type?: string; target_committee_id?: number; priority_level?: string; remarks?: string },
    user: AuthUser
  ): Promise<ApplicationRow> {
    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }
    if (!EDITABLE_APPLICATION_STATUSES.includes(app.current_status ?? '')) {
      const err = new Error('Only draft or returned applications can be edited') as any;
      err.status = 400;
      throw err;
    }
    if (app.submitted_by !== user.id && !user.roles.some((r: string) => ['SUPER_ADMIN', 'ETHICS_ADMIN'].includes(r))) {
      const err = new Error('Not authorized to edit this draft') as any;
      err.status = 403;
      throw err;
    }

    const updated = await this.repo.update(id, data);
    if (!updated) {
      const err = new Error('Failed to update draft') as any;
      err.status = 400;
      throw err;
    }
    return updated;
  }

  async updateStatus(
    id: number,
    body: { transition_code: string; comment?: string },
    user: AuthUser
  ): Promise<ApplicationRow> {
    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }

    if (body.transition_code === 'SUBMIT' && app.current_status !== 'DRAFT') {
      const err = new Error('SUBMIT is only allowed from DRAFT status') as any;
      err.status = 400;
      throw err;
    }

    if (body.transition_code === 'RESUBMIT' && app.current_status !== 'RETURNED') {
      const err = new Error('RESUBMIT is only allowed from RETURNED status') as any;
      err.status = 400;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const CONDITION_TRANSITIONS = ['COMMITTEE_CONDITIONAL', 'CONDITIONS_MET', 'CONDITIONS_NOT_MET', 'SUBMIT_EVIDENCE'];
      if (CONDITION_TRANSITIONS.includes(body.transition_code)) {
        await this.conditions.validateTransition(body.transition_code, id, user, client);
      }

      if (body.transition_code === 'SUBMIT' && app.current_status === 'DRAFT') {
        await this.workflow.initWorkflow('APP_REVIEW_V1', 'Application', id, client);
      }

      const result = await this.workflow.executeTransition(
        'Application', id, body.transition_code, user, body.comment, client
      );

      const updated = await this.repo.updateStatus(id, result.to_state, client);
      if (!updated) {
        const err = new Error('Application not found') as any;
        err.status = 404;
        throw err;
      }

      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});
    if (updated.current_status === 'APPROVED') {
      this.certificates.generate(id, user).catch(err => {
        logger.error({ err, applicationId: id }, 'Certificate generation failed after approval');
      });
    }

    const notifType = TRANSITION_TO_NOTIFICATION[body.transition_code];
    if (notifType) {
      const notifService = new NotificationService();
      await notifService.send({
        userId: app.submitted_by,
        notificationType: notifType,
        subject: `Application #${id}`,
        messageBody: `Your application #${id} status has been updated.`,
        sourceEntityType: 'Application',
        sourceEntityId: id,
      });
    }

    return updated;
  }

  async softDelete(id: number): Promise<void> {
    const deleted = await this.repo.softDelete(id);
    if (!deleted) {
      const err = new Error('Application not found or already deleted') as any;
      err.status = 404;
      throw err;
    }
  }

  /**
   * سحب الطلب بواسطة الباحث عبر transitions:
   *   DRAFT     → WITHDRAW_DRAFT  (لا يتطلب comment)
   *   SUBMITTED → WITHDRAW        (يتطلب comment)
   *   RETURNED  → WITHDRAW_RETURNED (يتطلب comment)
   */
  async withdrawApplication(
    id: number,
    comment: string | undefined,
    user: AuthUser
  ): Promise<ApplicationRow> {
    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }

    // فقط صاحب الطلب
    if (app.submitted_by !== user.id) {
      const err = new Error('Only the application owner can withdraw it') as any;
      err.status = 403;
      throw err;
    }

    const WITHDRAW_MAP: Record<string, string> = {
      'DRAFT':     'WITHDRAW_DRAFT',
      'SUBMITTED': 'WITHDRAW',
      'RETURNED':  'WITHDRAW_RETURNED',
    };

    const transitionCode = WITHDRAW_MAP[app.current_status];
    if (!transitionCode) {
      const err = new Error(
        `Cannot withdraw application in status: ${app.current_status}`
      ) as any;
      err.status = 400;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const result = await this.workflow.executeTransition(
        'Application', id, transitionCode, user, comment, client
      );

      const updated = await this.repo.updateStatus(id, result.to_state, client);
      if (!updated) {
        const err = new Error('Failed to withdraw application') as any;
        err.status = 400;
        throw err;
      }

      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});

    const notifService = new NotificationService();
    await notifService.send({
      userId: app.submitted_by,
      notificationType: 'APPLICATION_WITHDRAWN',
      subject: `Application #${id} Withdrawn`,
      messageBody: `Your application #${id} has been withdrawn.`,
      sourceEntityType: 'Application',
      sourceEntityId: id,
    });

    return updated;
  }

  /**
   * تقديم استئناف (متاح فقط للطلبات المرفوضة)
   * REJECTED → APPEAL_REVIEW
   * يتطلب comment دائماً (مسوّؿغ الاستئناف)
   */
  async appealDecision(
    id: number,
    comment: string,
    user: AuthUser
  ): Promise<ApplicationRow> {
    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }

    if (app.current_status !== 'REJECTED') {
      const err = new Error('Only rejected applications can be appealed') as any;
      err.status = 400;
      throw err;
    }

    // فقط صاحب الطلب
    if (app.submitted_by !== user.id) {
      const err = new Error('Only the application owner can appeal') as any;
      err.status = 403;
      throw err;
    }

    if (!comment || comment.trim().length < 10) {
      const err = new Error('Appeal must include a justification (min 10 characters)') as any;
      err.status = 400;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const result = await this.workflow.executeTransition(
        'Application', id, 'APPEAL', user, comment, client
      );

      const updated = await this.repo.updateStatus(id, result.to_state, client);
      if (!updated) {
        const err = new Error('Failed to register appeal') as any;
        err.status = 400;
        throw err;
      }

      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});

    const notifService = new NotificationService();
    await notifService.send({
      userId: app.submitted_by,
      notificationType: 'APPLICATION_APPEAL_SUBMITTED',
      subject: `Application #${id} Appeal Submitted`,
      messageBody: `Your appeal for application #${id} has been submitted.`,
      sourceEntityType: 'Application',
      sourceEntityId: id,
    });

    return updated;
  }

  /**
   * بدء دورة التجديد السنوي (ICH-GCP §3.3 — Continuing Review)
   * APPROVED → RENEWAL_REVIEW
   * متاح فقط لـ ETHICS_ADMIN و SUPER_ADMIN
   */
  async initiateRenewal(
    id: number,
    user: AuthUser
  ): Promise<ApplicationRow> {
    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }

    if (app.current_status !== 'APPROVED') {
      const err = new Error('Renewal can only be initiated for approved applications') as any;
      err.status = 400;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const result = await this.workflow.executeTransition(
        'Application', id, 'INITIATE_RENEWAL', user, undefined, client
      );

      const updated = await this.repo.updateStatus(id, result.to_state, client);
      if (!updated) {
        const err = new Error('Failed to initiate renewal') as any;
        err.status = 400;
        throw err;
      }

      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});

    const notifType = TRANSITION_TO_NOTIFICATION['INITIATE_RENEWAL'];
    if (notifType) {
      const notifService = new NotificationService();
      await notifService.send({
        userId: app.submitted_by,
        notificationType: notifType,
        subject: `Application #${id} Renewal Initiated`,
        messageBody: `A renewal has been initiated for application #${id}.`,
        sourceEntityType: 'Application',
        sourceEntityId: id,
      });
    }

    return updated;
  }

}
