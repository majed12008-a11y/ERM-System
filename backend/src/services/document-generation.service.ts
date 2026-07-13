import { TemplateIntegrationService, RenderDocumentResult } from './template-integration.service';
import { v7 as uuidv7 } from 'uuid';

export class ApplicationDocumentService {
  constructor(private integration: TemplateIntegrationService) {}

  async generateSubmissionConfirmation(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderApplicationDocument('submission', variables, applicationId, userId);
  }

  async generateApplicationReceipt(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderApplicationDocument('receipt', variables, applicationId, userId);
  }

  async generateReturnForCorrection(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderApplicationDocument('correction', variables, applicationId, userId);
  }

  async generateApprovalLetter(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    const result = await this.integration.renderApplicationDocument('approval', variables, applicationId, userId);
    await this.integration.linkSnapshotToEntity(result.snapshot.id, 'lifecycle_event', applicationId);
    return result;
  }

  async generateConditionalApproval(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    const result = await this.integration.renderApplicationDocument('conditional', variables, applicationId, userId);
    await this.integration.linkSnapshotToEntity(result.snapshot.id, 'lifecycle_event', applicationId);
    return result;
  }

  async generateRejectionLetter(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    const result = await this.integration.renderApplicationDocument('rejection', variables, applicationId, userId);
    await this.integration.linkSnapshotToEntity(result.snapshot.id, 'lifecycle_event', applicationId);
    return result;
  }

  async generateWithdrawalConfirmation(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderApplicationDocument('withdrawal', variables, applicationId, userId);
  }
}

export class CommitteeDocumentService {
  constructor(private integration: TemplateIntegrationService) {}

  async generateMeetingAgenda(
    meetingId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('meeting.agenda', variables, userId, {
      entityType: 'Meeting',
      entityId: meetingId,
    });
  }

  async generateMeetingMinutes(
    meetingId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    const result = await this.integration.renderModuleDocument('meeting.minutes', variables, userId, {
      entityType: 'Meeting',
      entityId: meetingId,
    });
    await this.integration.linkSnapshotToEntity(result.snapshot.id, 'lifecycle_event', meetingId);
    return result;
  }

  async generateReviewSummary(
    reviewId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('committee.review', variables, userId, {
      entityType: 'Committee',
      entityId: reviewId,
    });
  }

  async generateFinalDecision(
    decisionId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    const result = await this.integration.renderModuleDocument('committee.decision', variables, userId, {
      entityType: 'Committee',
      entityId: decisionId,
    });
    await this.integration.linkSnapshotToEntity(result.snapshot.id, 'approval_step', decisionId);
    return result;
  }
}

export class AccreditationDocumentService {
  constructor(private integration: TemplateIntegrationService) {}

  async generateAccreditationDecision(
    institutionId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('accreditation.decision', variables, userId, {
      entityType: 'Institution',
      entityId: institutionId,
    });
  }

  async generateConditionalAccreditation(
    institutionId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('accreditation.conditional', variables, userId, {
      entityType: 'Institution',
      entityId: institutionId,
    });
  }

  async generateSuspensionNotice(
    institutionId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('accreditation.suspension', variables, userId, {
      entityType: 'Institution',
      entityId: institutionId,
    });
  }

  async generateRevocationNotice(
    institutionId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('accreditation.revocation', variables, userId, {
      entityType: 'Institution',
      entityId: institutionId,
    });
  }

  async generateExpirationNotice(
    institutionId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('accreditation.expiration', variables, userId, {
      entityType: 'Institution',
      entityId: institutionId,
    });
  }

  async generateAccreditationCertificate(
    institutionId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    const result = await this.integration.renderModuleDocument('accreditation.certificate', variables, userId, {
      entityType: 'Institution',
      entityId: institutionId,
    });
    await this.integration.linkSnapshotToEntity(result.snapshot.id, 'pdf_generation', institutionId);
    return result;
  }
}

export class ConsentDocumentService {
  constructor(private integration: TemplateIntegrationService) {}

  async generateConsentForm(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('consent.form', variables, userId, {
      entityType: 'Application',
      entityId: applicationId,
    });
  }
}

export class SafetyDocumentService {
  constructor(private integration: TemplateIntegrationService) {}

  async generateSafetyReport(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('safety.report', variables, userId, {
      entityType: 'Application',
      entityId: applicationId,
    });
  }

  async generateRiskAssessment(
    applicationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('risk.assessment', variables, userId, {
      entityType: 'Application',
      entityId: applicationId,
    });
  }
}

export class NotificationDocumentService {
  constructor(private integration: TemplateIntegrationService) {}

  async generateStatusChangeNotification(
    notificationId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('notification.status', variables, userId, {
      entityType: 'Notification',
      entityId: notificationId,
    });
  }

  async generateGenericEmail(
    committeeId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('email.generic', variables, userId, {
      entityType: 'Committee',
      entityId: committeeId,
    });
  }
}

export class ReportDocumentService {
  constructor(private integration: TemplateIntegrationService) {}

  async generateAnnualReport(
    reportId: number, variables: Record<string, unknown>, userId: number,
  ): Promise<RenderDocumentResult> {
    return this.integration.renderModuleDocument('report.annual', variables, userId, {
      entityType: 'Application',
      entityId: reportId,
    });
  }
}
