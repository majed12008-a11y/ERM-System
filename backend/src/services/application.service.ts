/*
 * إدارة طلبات البحث: إنشاء، تقديم، مراجعة، اعتماد، رفض.
 * تتحقق من صحة البيانات وترسل الإشعارات للمستخدمين المعنيين.
 * تخضع جميع العمليات لسياسات RLS.
 */
import { ApplicationRepository } from '../repositories/application.repository';
import { ApplicationRow } from '../shared/db-types';
import { AuthUser } from '../shared/types';
import { PaginationParams, paginatedResult, PaginatedResult } from '../shared/pagination';
import { createAndNotify, broadcastDashboardEvent } from './notification.service';
import { WorkflowService } from './workflow.service';
import { withTransaction } from '../config/database';

export class ApplicationService {
  constructor(
    private repo = new ApplicationRepository(),
    private workflow = new WorkflowService()
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
    const app = await withTransaction(async (client) => {
      const applicationNumber = await this.repo.generateApplicationNumber(client);

      const newApp = await this.repo.create({
        application_number: applicationNumber,
        project_id: data.project_id,
        application_type: data.application_type,
        submitted_by: user.id,
        target_committee_id: data.target_committee_id,
      }, client);

      if (!data.save_as_draft) {
        await this.workflow.initWorkflow('APP_REVIEW_V1', 'Application', newApp.id, client);
      }

      return newApp;
    });

    broadcastDashboardEvent('dashboard-stats', {});

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
    if (app.current_status !== 'DRAFT') {
      const err = new Error('Only draft applications can be edited') as any;
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

  async submitDraft(
    id: number,
    body: { transition_code?: string; comment?: string },
    user: AuthUser
  ): Promise<ApplicationRow> {
    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }
    if (app.current_status !== 'DRAFT') {
      const err = new Error('Only draft applications can be submitted') as any;
      err.status = 400;
      throw err;
    }
    if (app.submitted_by !== user.id) {
      const err = new Error('Only the owner can submit this draft') as any;
      err.status = 403;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const updated = await this.repo.updateStatus(id, 'SUBMITTED', client);
      if (!updated) {
        const err = new Error('Failed to submit draft') as any;
        err.status = 400;
        throw err;
      }

      await this.workflow.initWorkflow('APP_REVIEW_V1', 'Application', id, client);

      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});
    return updated;
  }

  async updateStatus(
    id: number,
    body: { status?: string; transition_code?: string; comment?: string },
    user: AuthUser
  ): Promise<ApplicationRow> {
    const userRoles: string[] = user.roles;

    if (body.transition_code) {
      const result = await this.workflow.executeTransition(
        'Application', id, body.transition_code, user, body.comment
      );

      const updated = await this.repo.updateStatus(id, result.to_state);
      if (!updated) {
        const err = new Error('Application not found') as any;
        err.status = 404;
        throw err;
      }
      broadcastDashboardEvent('dashboard-stats', {});
      return updated;
    }

    if (!userRoles.some((r: string) => ['ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'].includes(r))) {
      const err = new Error('Not authorized') as any;
      err.status = 403;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const updated = await this.repo.updateStatus(id, body.status!, client);
      if (!updated) {
        const err = new Error('Application not found') as any;
        err.status = 404;
        throw err;
      }

      await this.workflow.autoTransition('Application', id, user.id, client);
      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});
    return updated;
  }

  async committeeDecision(
    id: number,
    decision: string,
    notes: string | undefined,
    user: AuthUser
  ): Promise<ApplicationRow> {
    const validDecisions = ['APPROVED', 'REJECTED', 'CONDITIONAL'];
    if (!validDecisions.includes(decision)) {
      const err = new Error('Invalid decision. Must be APPROVED, REJECTED, or CONDITIONAL') as any;
      err.status = 400;
      throw err;
    }

    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }

    const pending = await this.repo.countPendingReviews(id);
    if (pending > 0) {
      const err = new Error(`${pending} review(s) still pending`) as any;
      err.status = 400;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const updated = await this.repo.updateStatus(id, decision, client);
      if (!updated) {
        const err = new Error('Application not found') as any;
        err.status = 404;
        throw err;
      }

      await this.workflow.autoTransition('Application', id, user.id, client);

      await createAndNotify(
        app.submitted_by,
        'APPLICATION_UPDATE',
        `Application ${app.application_number}: ${decision}`,
        `Your application ${app.application_number} was ${decision}${notes ? '. Notes: ' + notes : ''}`,
        decision === 'APPROVED' ? 'HIGH' : 'MEDIUM',
        client
      );

      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});

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

}
