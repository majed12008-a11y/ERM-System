import { AuthUser } from '../shared/types';
import { DocumentRepository } from '../repositories/document.repository';
import { ConditionRepository } from '../repositories/condition.repository';
import { NotificationService } from './notification.service';
import * as fs from 'fs';

export class EvidenceService {
  constructor(
    private documentRepo: DocumentRepository,
    private conditionRepo: ConditionRepository,
  ) {}

  async uploadEvidence(
    applicationId: number,
    conditionId: number,
    file: Express.Multer.File,
    body: { document_title?: string },
    user: AuthUser,
  ) {
    const condition = await this.conditionRepo.findByIdIncludingDeleted(conditionId);
    if (!condition || condition.deleted_at) {
      throw Object.assign(new Error('Condition not found'), { status: 404 });
    }
    if (condition.application_id !== applicationId) {
      throw Object.assign(new Error('Condition does not belong to this application'), { status: 400 });
    }
    if (condition.status !== 'OPEN') {
      throw Object.assign(new Error('Evidence can only be uploaded for OPEN conditions'), { status: 400 });
    }

    const isAdmin = user.roles?.some(r => ['SUPER_ADMIN', 'ETHICS_ADMIN', 'ADMIN', 'SYS_ADMIN'].includes(r));
    if (!isAdmin) {
      const app = await this.conditionRepo.getApplicationOwner(applicationId);
      if (!app || app.submitted_by !== user.id) {
        throw Object.assign(new Error('Only the applicant or an admin can upload evidence'), { status: 403 });
      }
    }

    const document = await this.documentRepo.create({
      entity_type: 'ApplicationCondition',
      entity_id: conditionId,
      document_title: body.document_title || `Evidence for condition #${conditionId}`,
      file_name: file.originalname,
      mime_type: file.mimetype,
      storage_path: file.path,
      file_size_bytes: file.size,
      uploaded_by: user.id,
    });

    const workflowState = await this.conditionRepo.getApplicationStatus(applicationId);
    if (workflowState && ['AWAITING_CONDITIONS', 'EVIDENCE_REJECTED'].includes(workflowState)) {
      const recipientIds = new Set<number>();

      const committeeId = await this.conditionRepo.getApplicationTargetCommittee(applicationId);
      if (committeeId) {
        const members = await this.conditionRepo.getCommitteeMembers(committeeId);
        for (const mid of members) recipientIds.add(mid);
      }

      const admins = await this.conditionRepo.getEthicsAdmins();
      for (const aid of admins) recipientIds.add(aid);

      const notifService = new NotificationService();
      for (const userId of recipientIds) {
        await notifService.send({
          userId,
          notificationType: 'EVIDENCE_UPLOADED',
          subject: `Evidence Uploaded for Application #${applicationId}`,
          messageBody: `New evidence has been uploaded for condition #${conditionId} in application #${applicationId}.`,
          sourceEntityType: 'Application',
          sourceEntityId: applicationId,
        });
      }
    }

    return document;
  }

  async getEvidence(applicationId: number, conditionId: number) {
    const condition = await this.conditionRepo.findByIdIncludingDeleted(conditionId);
    if (!condition || condition.deleted_at) {
      throw Object.assign(new Error('Condition not found'), { status: 404 });
    }
    if (condition.application_id !== applicationId) {
      throw Object.assign(new Error('Condition does not belong to this application'), { status: 400 });
    }
    return this.documentRepo.findByEntity('ApplicationCondition', conditionId);
  }

  async deleteEvidence(applicationId: number, conditionId: number, evidenceId: number, user: AuthUser) {
    const condition = await this.conditionRepo.findByIdIncludingDeleted(conditionId);
    if (!condition || condition.deleted_at) {
      throw Object.assign(new Error('Condition not found'), { status: 404 });
    }
    if (condition.application_id !== applicationId) {
      throw Object.assign(new Error('Condition does not belong to this application'), { status: 400 });
    }

    const workflowState = await this.conditionRepo.getApplicationStatus(applicationId);
    const isTerminal = workflowState && ['APPROVED', 'REJECTED', 'WITHDRAWN', 'ARCHIVED'].includes(workflowState);

    if (isTerminal) {
      throw Object.assign(new Error('Cannot delete evidence in terminal workflow state'), { status: 400 });
    }

    const isAdmin = user.roles?.some(r => ['SUPER_ADMIN', 'ETHICS_ADMIN', 'ADMIN', 'SYS_ADMIN'].includes(r));
    if (!isAdmin) {
      const app = await this.conditionRepo.getApplicationOwner(applicationId);
      if (!app || app.submitted_by !== user.id) {
        throw Object.assign(new Error('Only the applicant or an admin can delete evidence'), { status: 403 });
      }
      const allowedStates = ['AWAITING_CONDITIONS', 'EVIDENCE_REJECTED'];
      if (!allowedStates.includes(workflowState || '')) {
        throw Object.assign(
          new Error('Applicant can only delete evidence in AWAITING_CONDITIONS or EVIDENCE_REJECTED states'),
          { status: 400 }
        );
      }
      if (condition.status !== 'OPEN') {
        throw Object.assign(
          new Error('Applicant can only delete evidence for unresolved conditions'),
          { status: 400 }
        );
      }
    }

    const result = await this.documentRepo.softDelete(evidenceId);
    if (!result.deleted) {
      throw Object.assign(new Error('Evidence not found or already deleted'), { status: 404 });
    }

    if (result.storage_path) {
      try { await fs.promises.unlink(result.storage_path); } catch { }
    }

    return true;
  }
}
