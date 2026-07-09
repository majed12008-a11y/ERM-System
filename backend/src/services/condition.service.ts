/*
 * خدمة شروط الموافقة المشروطة: التحقق من انتقالات الحالة،
 * إدارة دورة حياة الشروط، والتحقق المسبق من انتقالات سير العمل.
 *
 * قواعد التحويل المسموح بها:
 *   OPEN → MET | NOT_MET | WAIVED
 *   NOT_MET → MET | WAIVED
 *   MET, WAIVED → (نهائية — لا يمكن تغييرها)
 *
 * جميع التحويلات محظورة ما لم تكن مدرجة أعلاه.
 */
import { AuthUser } from '../shared/types';
import { ConditionRepository, ConditionSummary } from '../repositories/condition.repository';
import { NotificationService } from './notification.service';
import { PoolClient } from 'pg';

export interface ConditionEvaluation {
  total: number;
  open: number;
  met: number;
  notMet: number;
  waived: number;
  allSatisfied: boolean;
  canApprove: boolean;
  canReject: boolean;
  canSubmitEvidence: boolean;
  unmetConditionIds: number[];
  missingEvidenceIds: number[];
}

const ALLOWED_STATUS_TRANSITIONS: Record<string, string[]> = {
  OPEN: ['MET', 'NOT_MET', 'WAIVED'],
  NOT_MET: ['MET', 'WAIVED'],
};

export class ConditionService {
  constructor(private repo: ConditionRepository) {}

  async getConditions(applicationId: number) {
    return this.repo.findByApplication(applicationId);
  }

  async createCondition(
    applicationId: number,
    data: {
      condition_text: string;
      severity?: string;
      category?: string;
      due_date?: string;
    },
    user: AuthUser
  ) {
    const condition = await this.repo.create({
      application_id: applicationId,
      condition_text: data.condition_text,
      severity: data.severity,
      category: data.category,
      due_date: data.due_date,
    });

    const app = await this.repo.getApplicationOwner(applicationId);
    if (app) {
      const notifService = new NotificationService();
      await notifService.send({
        userId: app.submitted_by,
        notificationType: 'CONDITION_CREATED',
        subject: `Condition Created for Application #${applicationId}`,
        messageBody: `A new condition has been added to application #${applicationId}: "${data.condition_text.substring(0, 100)}"`,
        sourceEntityType: 'Application',
        sourceEntityId: applicationId,
      });
    }

    return condition;
  }

  async updateCondition(
    id: number,
    data: {
      condition_text?: string;
      severity?: string;
      category?: string;
      due_date?: string | null;
    },
    user: AuthUser
  ) {
    const condition = await this.repo.findByIdIncludingDeleted(id);
    if (!condition || condition.deleted_at) {
      throw Object.assign(new Error('Condition not found'), { status: 404 });
    }
    return this.repo.update(id, data);
  }

  async resolveCondition(id: number, status: string, user: AuthUser) {
    const condition = await this.repo.findByIdIncludingDeleted(id);
    if (!condition || condition.deleted_at) {
      throw Object.assign(new Error('Condition not found'), { status: 404 });
    }

    const allowedTargets = ALLOWED_STATUS_TRANSITIONS[condition.status];
    if (!allowedTargets || !allowedTargets.includes(status)) {
      throw Object.assign(
        new Error(`Invalid status transition: ${condition.status} → ${status}`),
        { status: 400 }
      );
    }

    const updated = await this.repo.resolveStatus(id, status, user.id);

    const recipientIds = new Set<number>();
    const app = await this.repo.getApplicationOwner(condition.application_id);
    if (app) recipientIds.add(app.submitted_by);

    const committeeId = await this.repo.getApplicationTargetCommittee(condition.application_id);
    if (committeeId) {
      const chair = await this.repo.getCommitteeChair(committeeId);
      if (chair) recipientIds.add(chair);
    }

    const admins = await this.repo.getEthicsAdmins();
    for (const aid of admins) recipientIds.add(aid);

    const notifService = new NotificationService();
    for (const userId of recipientIds) {
      await notifService.send({
        userId,
        notificationType: 'CONDITION_RESOLVED',
        subject: `Condition #${id} Resolved as "${status}"`,
        messageBody: `Condition #${id} for application #${condition.application_id} has been resolved as "${status}".`,
        sourceEntityType: 'ApplicationCondition',
        sourceEntityId: id,
      });
    }

    return updated!;
  }

  async deleteCondition(id: number, user: AuthUser) {
    const condition = await this.repo.findByIdIncludingDeleted(id);
    if (!condition || condition.deleted_at) {
      throw Object.assign(new Error('Condition not found'), { status: 404 });
    }

    const appStatus = await this.repo.getApplicationStatus(condition.application_id);

    if (appStatus && ['AWAITING_CONDITIONS', 'EVIDENCE_REJECTED'].includes(appStatus)) {
      const openCount = await this.repo.getOpenCount(condition.application_id);
      if (openCount <= 1 && condition.status === 'OPEN') {
        throw Object.assign(
          new Error('Cannot delete the last OPEN condition while application is in conditions review'),
          { status: 409 }
        );
      }
    }

    const deleted = await this.repo.softDelete(id);
    if (!deleted) {
      throw Object.assign(new Error('Condition not found or already deleted'), { status: 404 });
    }
    return true;
  }

  async evaluate(applicationId: number, currentStatus?: string): Promise<ConditionEvaluation> {
    const summary = await this.repo.countByStatus(applicationId);
    const status = currentStatus ?? await this.repo.getApplicationStatus(applicationId);
    const unmetConditionIds = await this.repo.getUnmetConditionIds(applicationId);

    let missingEvidenceIds: number[] = [];
    if (unmetConditionIds.length > 0) {
      const coverage = await this.repo.evaluateEvidenceCoverage(applicationId, unmetConditionIds);
      missingEvidenceIds = coverage.filter(c => !c.has_evidence).map(c => c.condition_id);
    }

    return {
      total: summary.total,
      open: summary.open,
      met: summary.met,
      notMet: summary.notMet,
      waived: summary.waived,
      allSatisfied: summary.open === 0 && summary.notMet === 0,
      canApprove: status === 'AWAITING_CONDITIONS' && summary.open === 0 && summary.notMet === 0,
      canReject: status === 'AWAITING_CONDITIONS' && (summary.open > 0 || summary.notMet > 0),
      canSubmitEvidence: status === 'EVIDENCE_REJECTED' && missingEvidenceIds.length === 0 && unmetConditionIds.length > 0,
      unmetConditionIds,
      missingEvidenceIds,
    };
  }

  async validateTransition(
    transitionCode: string,
    applicationId: number,
    user: AuthUser,
    client?: PoolClient
  ): Promise<void> {
    const evalResult = await this.evaluate(applicationId);

    switch (transitionCode) {
      case 'COMMITTEE_CONDITIONAL':
        if (evalResult.total === 0) {
          throw Object.assign(
            new Error('At least one condition must be specified before conditional approval'),
            { status: 400 }
          );
        }
        break;

      case 'CONDITIONS_MET':
        if (!evalResult.allSatisfied) {
          throw Object.assign(
            new Error('All conditions must be marked MET before approving'),
            { status: 400, details: { unmetConditionIds: evalResult.unmetConditionIds } }
          );
        }
        break;

      case 'CONDITIONS_NOT_MET':
        if (evalResult.open === 0 && evalResult.notMet === 0) {
          throw Object.assign(
            new Error('No unresolved conditions to reject'),
            { status: 400 }
          );
        }
        break;

      case 'SUBMIT_EVIDENCE':
        if (evalResult.missingEvidenceIds.length > 0) {
          throw Object.assign(
            new Error('Evidence required for all unresolved conditions'),
            { status: 400, details: { missingEvidenceIds: evalResult.missingEvidenceIds } }
          );
        }
        break;

      case 'REJECT_CONDITIONS':
        break;

      default:
        break;
    }
  }
}
