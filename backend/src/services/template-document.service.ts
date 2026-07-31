import { TemplateIntegrationService } from './template-integration.service';
import { TemplateEngineService } from './template-engine.service';
import { MODULE_DOCUMENTS } from '../shared/template-integration.types';

export class TemplateDocumentService {
  constructor(
    private integrationService: TemplateIntegrationService,
    private engineService: TemplateEngineService,
  ) {}

  async generateApplicationSubmission(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('application.submission', id, variables, userId, locale);
  }

  async generateApplicationReceipt(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('application.receipt', id, variables, userId, locale);
  }

  async generateApplicationCorrection(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('application.correction', id, variables, userId, locale);
  }

  async generateApplicationApproval(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('application.approval', id, variables, userId, locale);
  }

  async generateApplicationConditional(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('application.conditional', id, variables, userId, locale);
  }

  async generateApplicationRejection(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('application.rejection', id, variables, userId, locale);
  }

  async generateApplicationWithdrawal(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('application.withdrawal', id, variables, userId, locale);
  }

  async generateMeetingAgenda(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('meeting.agenda', id, variables, userId, locale);
  }

  async generateMeetingMinutes(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('meeting.minutes', id, variables, userId, locale);
  }

  async generateCommitteeReview(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('committee.review', id, variables, userId, locale);
  }

  async generateCommitteeDecision(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('committee.decision', id, variables, userId, locale);
  }

  async generateAccreditationDecision(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('accreditation.decision', id, variables, userId, locale);
  }

  async generateAccreditationCertificate(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('accreditation.certificate', id, variables, userId, locale);
  }

  async generateConsentForm(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('consent.form', id, variables, userId, locale);
  }

  async generateSafetyReport(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('safety.report', id, variables, userId, locale);
  }

  async generateRiskAssessment(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('risk.assessment', id, variables, userId, locale);
  }

  async generateNotification(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('notification.status', id, variables, userId, locale);
  }

  async generateEmail(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('email.generic', id, variables, userId, locale);
  }

  async generateAnnualReport(id: number, variables: Record<string, unknown>, userId: number, locale?: string) {
    return this.renderByModuleKey('report.annual', id, variables, userId, locale);
  }

  async renderByModuleKey(
    moduleKey: string,
    entityId: number,
    variables: Record<string, unknown>,
    userId: number,
    locale?: string,
  ) {
    const config = MODULE_DOCUMENTS[moduleKey];
    if (!config) {
      throw Object.assign(
        new Error(`No template configuration found for module key "${moduleKey}"`),
        { status: 400 },
      );
    }

    return this.integrationService.renderDocument({
      templateCode: config.templateCode,
      version: config.version,
      variables,
      entityType: config.entityType,
      entityId,
      renderedBy: userId,
      locale: locale || 'ar',
    });
  }

  async previewTemplate(templateCode: string, version: string, variables: Record<string, unknown>, locale?: string) {
    return this.engineService.render({
      templateCode,
      version,
      variables,
      locale: locale || 'ar',
    });
  }

  getModuleDocumentKeys(): string[] {
    return Object.keys(MODULE_DOCUMENTS);
  }

  getModuleDocumentConfig(moduleKey: string) {
    return MODULE_DOCUMENTS[moduleKey] || null;
  }
}
