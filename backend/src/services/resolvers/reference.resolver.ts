import { BaseResolver } from './base.resolver';
import {
  InstitutionResolveDTO, NotificationResolveDTO, ReviewResolveDTO,
  ReportResolveDTO, CommunicationResolveDTO, SafetyReportResolveDTO,
  ResolveContext, VariableMapping,
} from '../../shared/template-resolver.types';

export class InstitutionResolver extends BaseResolver<InstitutionResolveDTO> {
  protected variableMap = new Map<string, string>([
    ['name_ar', 'name_ar'], ['name_en', 'name_en'], ['code', 'code'],
    ['city', 'city'], ['country', 'country'], ['is_active', 'is_active'],
  ]);

  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'name_ar', fieldPath: 'name_ar', description: 'Institution name in Arabic' },
      { variableCode: 'name_en', fieldPath: 'name_en', description: 'Institution name in English' },
      { variableCode: 'code', fieldPath: 'code', description: 'Institution code' },
      { variableCode: 'city', fieldPath: 'city', description: 'City' },
      { variableCode: 'country', fieldPath: 'country', description: 'Country' },
      { variableCode: 'is_active', fieldPath: 'is_active', description: 'Active status' },
    ];
  }

  get repositoryDependencies(): string[] { return ['InstitutionRepository']; }

  constructor(private repo: { findById(id: number): Promise<InstitutionResolveDTO | null> }) { super('Institution'); }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fp = this.getFieldPath(variableCode);
    if (!fp) this.createRejection(entityId, variableCode, `Unknown "${variableCode}"`);
    const e = await this.repo.findById(entityId);
    if (!e) this.createRejection(entityId, variableCode, `Institution ${entityId} not found`);
    const v = this.field(e, fp);
    if (v === undefined) this.createRejection(entityId, variableCode, `Field "${fp}" not resolved`);
    return v;
  }

  async resolveBatch(ids: number[], vars: string[], _ctx?: ResolveContext): Promise<Map<number, Partial<InstitutionResolveDTO>>> {
    const r = new Map<number, Partial<InstitutionResolveDTO>>();
    for (const id of [...new Set(ids)]) {
      const e = await this.repo.findById(id);
      if (!e) continue;
      const p: Partial<InstitutionResolveDTO> = {};
      for (const vc of vars) { const fp = this.getFieldPath(vc); if (fp) { const v = this.field(e, fp); if (v !== undefined) (p as any)[vc] = v; } }
      r.set(id, p);
    }
    return r;
  }

  private field(o: any, p: string): unknown { return p.includes('.') ? p.split('.').reduce((a, k) => a?.[k], o) : o[p]; }
}

export class NotificationResolver extends BaseResolver<NotificationResolveDTO> {

  protected variableMap = new Map<string, string>([
    ['notification_type', 'notification_type'], ['subject', 'subject'],
    ['message_body', 'message_body'], ['priority_level', 'priority_level'],
    ['user_id', 'user_id'], ['created_at', 'created_at'],
  ]);
  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'notification_type', fieldPath: 'notification_type', description: 'Type of notification' },
      { variableCode: 'subject', fieldPath: 'subject', description: 'Notification subject' },
      { variableCode: 'message_body', fieldPath: 'message_body', description: 'Notification body text' },
      { variableCode: 'priority_level', fieldPath: 'priority_level', description: 'Priority level' },
      { variableCode: 'user_id', fieldPath: 'user_id', description: 'Target user ID' },
      { variableCode: 'created_at', fieldPath: 'created_at', description: 'Creation timestamp' },
    ];
  }
  get repositoryDependencies(): string[] { return ['NotificationRepository']; }

  constructor(private repo: { findById(id: number): Promise<NotificationResolveDTO | null> }) { super('Notification'); }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fp = this.getFieldPath(variableCode);
    if (!fp) this.createRejection(entityId, variableCode, `Unknown "${variableCode}"`);
    const e = await this.repo.findById(entityId);
    if (!e) this.createRejection(entityId, variableCode, `Notification ${entityId} not found`);
    const v = this.field(e, fp);
    if (v === undefined) this.createRejection(entityId, variableCode, `Field "${fp}" not resolved`);
    return v;
  }

  async resolveBatch(ids: number[], vars: string[], _ctx?: ResolveContext): Promise<Map<number, Partial<NotificationResolveDTO>>> {
    const r = new Map<number, Partial<NotificationResolveDTO>>();
    for (const id of [...new Set(ids)]) {
      const e = await this.repo.findById(id);
      if (!e) continue;
      const p: Partial<NotificationResolveDTO> = {};
      for (const vc of vars) { const fp = this.getFieldPath(vc); if (fp) { const v = this.field(e, fp); if (v !== undefined) (p as any)[vc] = v; } }
      r.set(id, p);
    }
    return r;
  }

  private field(o: any, p: string): unknown { return p.includes('.') ? p.split('.').reduce((a, k) => a?.[k], o) : o[p]; }
}

export class ReviewResolver extends BaseResolver<ReviewResolveDTO> {

  protected variableMap = new Map<string, string>([
    ['application_id', 'application_id'], ['reviewer_id', 'reviewer_id'],
    ['reviewer_name', 'reviewer_name'], ['decision', 'decision'],
    ['comments', 'comments'], ['submitted_at', 'submitted_at'],
  ]);
  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'application_id', fieldPath: 'application_id', description: 'Reviewed application ID' },
      { variableCode: 'reviewer_id', fieldPath: 'reviewer_id', description: 'Reviewer user ID' },
      { variableCode: 'reviewer_name', fieldPath: 'reviewer_name', description: 'Reviewer display name' },
      { variableCode: 'decision', fieldPath: 'decision', description: 'Review decision' },
      { variableCode: 'comments', fieldPath: 'comments', description: 'Review comments' },
      { variableCode: 'submitted_at', fieldPath: 'submitted_at', description: 'Submission timestamp' },
    ];
  }
  get repositoryDependencies(): string[] { return ['CommitteeRepository']; }

  constructor(private repo: { findById(id: number): Promise<ReviewResolveDTO | null> }) { super('Review'); }

  async resolve(entityId: number, variableCode: string, _context?: ResolveContext): Promise<unknown> {
    const fp = this.getFieldPath(variableCode);
    if (!fp) this.createRejection(entityId, variableCode, `Unknown "${variableCode}"`);
    const e = await this.repo.findById(entityId);
    if (!e) this.createRejection(entityId, variableCode, `Review ${entityId} not found`);
    const v = this.field(e, fp);
    if (v === undefined) this.createRejection(entityId, variableCode, `Field "${fp}" not resolved`);
    return v;
  }

  async resolveBatch(ids: number[], vars: string[], _ctx?: ResolveContext): Promise<Map<number, Partial<ReviewResolveDTO>>> {
    const r = new Map<number, Partial<ReviewResolveDTO>>();
    for (const id of [...new Set(ids)]) {
      const e = await this.repo.findById(id);
      if (!e) continue;
      const p: Partial<ReviewResolveDTO> = {};
      for (const vc of vars) { const fp = this.getFieldPath(vc); if (fp) { const v = this.field(e, fp); if (v !== undefined) (p as any)[vc] = v; } }
      r.set(id, p);
    }
    return r;
  }

  private field(o: any, p: string): unknown { return p.includes('.') ? p.split('.').reduce((a, k) => a?.[k], o) : o[p]; }
}

export class ReportResolver extends BaseResolver<ReportResolveDTO> {

  protected variableMap = new Map<string, string>([
    ['report_type', 'report_type'], ['entity_type', 'entity_type'],
    ['entity_id', 'entity_id'], ['generated_by', 'generated_by'],
    ['generated_at', 'generated_at'], ['status', 'status'],
  ]);
  get supportedVariables(): VariableMapping[] {
    return [
      { variableCode: 'report_type', fieldPath: 'report_type', description: 'Type of report' },
      { variableCode: 'entity_type', fieldPath: 'entity_type', description: 'Related entity type' },
      { variableCode: 'entity_id', fieldPath: 'entity_id', description: 'Related entity ID' },
      { variableCode: 'generated_by', fieldPath: 'generated_by', description: 'Generator user ID' },
      { variableCode: 'generated_at', fieldPath: 'generated_at', description: 'Generation timestamp' },
      { variableCode: 'status', fieldPath: 'status', description: 'Report status' },
    ];
  }
  get repositoryDependencies(): string[] { return ['ReportingRepository']; }

  constructor(private repo: { findById(id: number): Promise<ReportResolveDTO | null> }) { super('Report'); }
  async resolve(entityId: number, variableCode: string, _c?: ResolveContext): Promise<unknown> {
    const fp = this.getFieldPath(variableCode); if (!fp) this.createRejection(entityId, variableCode, `Unknown "${variableCode}"`);
    const e = await this.repo.findById(entityId); if (!e) this.createRejection(entityId, variableCode, `Report ${entityId} not found`);
    const v = this.field(e, fp); if (v === undefined) this.createRejection(entityId, variableCode, `Field "${fp}" not resolved`); return v;
  }
  async resolveBatch(ids: number[], vars: string[], _c?: ResolveContext): Promise<Map<number, Partial<ReportResolveDTO>>> {
    const r = new Map<number, Partial<ReportResolveDTO>>();
    for (const id of [...new Set(ids)]) {
      const e = await this.repo.findById(id); if (!e) continue;
      const p: Partial<ReportResolveDTO> = {};
      for (const vc of vars) { const fp = this.getFieldPath(vc); if (fp) { const v = this.field(e, fp); if (v !== undefined) (p as any)[vc] = v; } }
      r.set(id, p);
    }
    return r;
  }
  private field(o: any, p: string): unknown { return p.includes('.') ? p.split('.').reduce((a, k) => a?.[k], o) : o[p]; }
}

export class CommunicationResolver extends BaseResolver<CommunicationResolveDTO> {

  protected variableMap = new Map<string, string>([
    ['communication_type', 'communication_type'], ['subject', 'subject'],
    ['body', 'body'], ['sender_id', 'sender_id'], ['recipient_id', 'recipient_id'],
    ['sent_at', 'sent_at'],
  ]);
  get supportedVariables(): VariableMapping[] { return [
    { variableCode: 'communication_type', fieldPath: 'communication_type', description: 'Type of communication' },
    { variableCode: 'subject', fieldPath: 'subject', description: 'Communication subject' },
    { variableCode: 'body', fieldPath: 'body', description: 'Communication body' },
    { variableCode: 'sender_id', fieldPath: 'sender_id', description: 'Sender user ID' },
    { variableCode: 'recipient_id', fieldPath: 'recipient_id', description: 'Recipient user ID' },
    { variableCode: 'sent_at', fieldPath: 'sent_at', description: 'Send timestamp' },
  ]; }
  get repositoryDependencies(): string[] { return ['CommunicationRepository']; }
  constructor(private repo: { findById(id: number): Promise<CommunicationResolveDTO | null> }) { super('Communication'); }
  async resolve(entityId: number, variableCode: string, _c?: ResolveContext): Promise<unknown> {
    const fp = this.getFieldPath(variableCode); if (!fp) this.createRejection(entityId, variableCode, `Unknown "${variableCode}"`);
    const e = await this.repo.findById(entityId); if (!e) this.createRejection(entityId, variableCode, `Communication ${entityId} not found`);
    const v = this.field(e, fp); if (v === undefined) this.createRejection(entityId, variableCode, `Field "${fp}" not resolved`); return v;
  }
  async resolveBatch(ids: number[], vars: string[], _c?: ResolveContext): Promise<Map<number, Partial<CommunicationResolveDTO>>> {
    const r = new Map<number, Partial<CommunicationResolveDTO>>();
    for (const id of [...new Set(ids)]) {
      const e = await this.repo.findById(id); if (!e) continue;
      const p: Partial<CommunicationResolveDTO> = {};
      for (const vc of vars) { const fp = this.getFieldPath(vc); if (fp) { const v = this.field(e, fp); if (v !== undefined) (p as any)[vc] = v; } }
      r.set(id, p);
    }
    return r;
  }
  private field(o: any, p: string): unknown { return p.includes('.') ? p.split('.').reduce((a, k) => a?.[k], o) : o[p]; }
}

export class SafetyReportResolver extends BaseResolver<SafetyReportResolveDTO> {

  protected variableMap = new Map<string, string>([
    ['application_id', 'application_id'], ['report_type', 'report_type'],
    ['severity', 'severity'], ['description', 'description'],
    ['reported_by', 'reported_by'], ['reported_at', 'reported_at'],
    ['status', 'status'],
  ]);
  get supportedVariables(): VariableMapping[] { return [
    { variableCode: 'application_id', fieldPath: 'application_id', description: 'Related application ID' },
    { variableCode: 'report_type', fieldPath: 'report_type', description: 'Safety report type' },
    { variableCode: 'severity', fieldPath: 'severity', description: 'Severity level' },
    { variableCode: 'description', fieldPath: 'description', description: 'Incident description' },
    { variableCode: 'reported_by', fieldPath: 'reported_by', description: 'Reporter user ID' },
    { variableCode: 'reported_at', fieldPath: 'reported_at', description: 'Report timestamp' },
    { variableCode: 'status', fieldPath: 'status', description: 'Report status' },
  ]; }
  get repositoryDependencies(): string[] { return ['SafetyRepository']; }
  constructor(private repo: { findById(id: number): Promise<SafetyReportResolveDTO | null> }) { super('SafetyReport'); }
  async resolve(entityId: number, variableCode: string, _c?: ResolveContext): Promise<unknown> {
    const fp = this.getFieldPath(variableCode); if (!fp) this.createRejection(entityId, variableCode, `Unknown "${variableCode}"`);
    const e = await this.repo.findById(entityId); if (!e) this.createRejection(entityId, variableCode, `SafetyReport ${entityId} not found`);
    const v = this.field(e, fp); if (v === undefined) this.createRejection(entityId, variableCode, `Field "${fp}" not resolved`); return v;
  }
  async resolveBatch(ids: number[], vars: string[], _c?: ResolveContext): Promise<Map<number, Partial<SafetyReportResolveDTO>>> {
    const r = new Map<number, Partial<SafetyReportResolveDTO>>();
    for (const id of [...new Set(ids)]) {
      const e = await this.repo.findById(id); if (!e) continue;
      const p: Partial<SafetyReportResolveDTO> = {};
      for (const vc of vars) { const fp = this.getFieldPath(vc); if (fp) { const v = this.field(e, fp); if (v !== undefined) (p as any)[vc] = v; } }
      r.set(id, p);
    }
    return r;
  }
  private field(o: any, p: string): unknown { return p.includes('.') ? p.split('.').reduce((a, k) => a?.[k], o) : o[p]; }
}
