/*
 * خدمة مكتبة النماذج:
 *   - إدارة تعريفات النماذج ومثيلاتها.
 *   - التحقق من صحة الاستجابات مقابل JSON Schema المخزنة
 *     (الحقول المطلوبة، الشروط، الأنواع، المدى).
 *   - حساب الدرجات المحسوبة (computed.mean).
 *   - توليد مستند رسمي من استجابات النموذج عبر محرك المستندات.
 */
import { AuthUser } from '../shared/types';
import { FormDefinitionRepository } from '../repositories/form-definition.repository';
import { FormInstanceRepository, FormInstanceStatus } from '../repositories/form-instance.repository';
import { DocumentRenderService } from './document-render.service';
import { DocumentRenderRepository } from '../repositories/document-render.repository';
import { logger } from '../config/logger';
import crypto from 'crypto';

interface FieldDef {
  name: string;
  label: { ar: string; en?: string };
  type: string;
  required?: boolean;
  options?: { value: string; label: { ar: string; en?: string } }[];
  min?: number;
  max?: number;
  maxLength?: number;
  pattern?: string;
  rows?: number;
  conditional?: { field: string; equals: string };
}

interface SectionDef {
  id: string;
  title: { ar: string; en?: string };
  fields: FieldDef[];
}

interface FormSchema {
  formCode: string;
  version: string;
  sections: SectionDef[];
  computed?: { total_score?: { type: string; fields: string[] } };
}

const CATEGORY_TEMPLATE: Record<string, { templateCode: string; documentType: string }> = {
  SCREENING: { templateCode: 'REVIEW_FORM_DOC', documentType: 'REVIEW_FORM' },
  REVIEW: { templateCode: 'REVIEW_FORM_DOC', documentType: 'REVIEW_FORM' },
  SAFETY: { templateCode: 'SAFETY_REPORT_DOC', documentType: 'SAFETY_REPORT' },
  CLOSURE: { templateCode: 'CLOSURE_REPORT_DOC', documentType: 'CLOSURE_REPORT' },
  MONITORING: { templateCode: 'MONITORING_REPORT_DOC', documentType: 'MONITORING_REPORT' },
  MEETING: { templateCode: 'MEETING_MINUTES_DOC', documentType: 'MEETING_DOCUMENT' },
  POST_APPROVAL: { templateCode: 'PROGRESS_REPORT_DOC', documentType: 'MONITORING_REPORT' },
};

export class FormService {
  constructor(
    private definitionRepo = new FormDefinitionRepository(),
    private instanceRepo = new FormInstanceRepository(),
    private renderService = new DocumentRenderService(),
    private renderRepo = new DocumentRenderRepository(),
  ) {}

  // ── Definitions ────────────────────────────────────────────
  async listDefinitions() {
    return this.definitionRepo.findAllActive();
  }

  async listCategories() {
    return this.definitionRepo.listCategories();
  }

  async getDefinition(code: string) {
    const def = await this.definitionRepo.findActiveByCode(code);
    if (!def) throw Object.assign(new Error(`Form definition ${code} not found`), { status: 404 });
    return def;
  }

  // ── Instances ──────────────────────────────────────────────
  async createInstance(data: { form_code: string; entity_type: string; entity_id: number }, user: AuthUser) {
    const def = await this.definitionRepo.findActiveByCode(data.form_code);
    if (!def) throw Object.assign(new Error(`Form definition ${data.form_code} not found`), { status: 404 });

    const existing = await this.instanceRepo.findLatestForDefinition(data.entity_type, data.entity_id, def.id);
    if (existing && ['DRAFT', 'RETURNED'].includes(existing.status)) {
      return existing;
    }

    return this.instanceRepo.create({
      form_definition_id: def.id,
      entity_type: data.entity_type,
      entity_id: data.entity_id,
    });
  }

  async getInstance(id: number) {
    const instance = await this.instanceRepo.findById(id);
    if (!instance) throw Object.assign(new Error('Form instance not found'), { status: 404 });
    const def = await this.definitionRepo.findById(instance.form_definition_id);
    return { instance, definition: def };
  }

  async listByEntity(entityType: string, entityId: number) {
    return this.instanceRepo.listByEntity(entityType, entityId);
  }

  async listInstances(page: number, limit: number) {
    return this.instanceRepo.listAll(limit, (page - 1) * limit);
  }

  async saveInstance(id: number, responses: Record<string, any>, user: AuthUser) {
    const { instance, definition } = await this.getInstance(id);
    this.assertEditable(instance);

    const schema = definition.form_schema as FormSchema;
    const validated = this.validateResponses(schema, responses);
    const updated = await this.instanceRepo.saveResponses(id, validated, 'DRAFT');
    return updated;
  }

  async submitInstance(id: number, responses: Record<string, any>, user: AuthUser) {
    const { instance, definition } = await this.getInstance(id);
    this.assertEditable(instance);

    const schema = definition.form_schema as FormSchema;
    const validated = this.validateResponses(schema, responses);
    const totalScore = this.computeTotalScore(schema, validated);
    const recommendation = validated.recommendation || null;

    const submitted = await this.instanceRepo.submit(id, { total_score: totalScore, recommendation });
    if (!submitted) {
      throw Object.assign(new Error('Only DRAFT or RETURNED instances can be submitted'), { status: 400 });
    }
    logger.info({ instanceId: id, form: definition.form_code, score: totalScore }, 'Form instance submitted');
    return submitted;
  }

  async approveInstance(id: number, user: AuthUser) {
    const updated = await this.instanceRepo.approve(id, user.id);
    if (!updated) throw Object.assign(new Error('Only SUBMITTED instances can be approved'), { status: 400 });
    return updated;
  }

  async returnInstance(id: number, user: AuthUser) {
    const updated = await this.instanceRepo.returnToDraft(id, user.id);
    if (!updated) throw Object.assign(new Error('Only SUBMITTED instances can be returned'), { status: 400 });
    return updated;
  }

  async voidInstance(id: number, user: AuthUser) {
    const updated = await this.instanceRepo.void(id, user.id);
    if (!updated) throw Object.assign(new Error('Instance cannot be voided in its current state'), { status: 400 });
    return updated;
  }

  // ── Document generation ────────────────────────────────────
  async generateDocument(id: number, opts: {
    language?: 'ar' | 'en';
    templateCode?: string;
    committeeNameAr?: string;
    committeeNameEn?: string;
    institutionNameAr?: string;
    institutionNameEn?: string;
    context?: Record<string, any>;
    signatories?: { name: string; role: string }[];
  }, user: AuthUser) {
    const { instance, definition } = await this.getInstance(id);
    if (instance.status === 'DRAFT') {
      throw Object.assign(new Error('Submit the form before generating a document'), { status: 400 });
    }

    const schema = definition.form_schema as FormSchema;
    const language = opts.language || 'ar';
    const sections = this.buildSections(schema, instance.responses || {}, language);
    const totalScore = instance.total_score;

    const committee = await this.resolveCommittee(instance, opts);
    const categoryConfig = CATEGORY_TEMPLATE[definition.category] || {
      templateCode: 'DECISION_LETTER',
      documentType: 'OFFICIAL_LETTER',
    };
    const templateCode = opts.templateCode || categoryConfig.templateCode;

    const titleAr = definition.form_name_ar;
    const titleEn = definition.form_name_en || definition.form_name_ar;

    const context: Record<string, any> = {
      sections,
      totalScore: totalScore != null ? Number(totalScore) : undefined,
      ...(opts.context || {}),
    };

    const result = await this.renderService.render({
      templateCode,
      language,
      category: categoryConfig.documentType,
      entityType: 'Form',
      entityId: instance.id,
      titleAr,
      titleEn,
      context,
      issuedBy: user,
      signatories: opts.signatories,
      committeeNameAr: committee?.committeeNameAr || opts.committeeNameAr,
      committeeNameEn: committee?.committeeNameEn || opts.committeeNameEn,
      institutionNameAr: committee?.institutionNameAr || opts.institutionNameAr,
      institutionNameEn: committee?.institutionNameEn || opts.institutionNameEn,
      versionNotes: `Generated from ${definition.form_code} v${definition.version_no} instance #${instance.id}`,
    });

    logger.info(
      { instanceId: id, documentId: result.documentId, number: result.documentNumber, language },
      'Form document generated'
    );
    return { ...result, instanceId: id, formCode: definition.form_code };
  }

  async getDocumentDownload(documentId: number): Promise<{ storagePath: string; fileName: string } | null> {
    const doc = await this.renderRepo.findDocumentById(documentId);
    if (!doc || !doc.storage_path) return null;
    return { storagePath: doc.storage_path, fileName: doc.file_name };
  }

  // ── Document panel (versions, signatures, audit, lifecycle) ─
  async listDocuments(instanceId: number, user: AuthUser) {
    const { instance } = await this.getInstance(instanceId);
    return this.renderRepo.findDocumentsByEntity('Form', instance.id);
  }

  async getDocumentDetail(documentId: number, user: AuthUser) {
    const doc = await this.renderRepo.findDocumentById(documentId);
    if (!doc) throw Object.assign(new Error('Document not found'), { status: 404 });

    const [versions, audit, signatures] = await Promise.all([
      this.renderRepo.getDocumentVersions(documentId),
      this.renderRepo.getDocumentAudit(documentId),
      this.renderRepo.getDocumentSignatures(documentId),
    ]);

    return { document: doc, versions, audit, signatures };
  }

  async signDocument(documentId: number, user: AuthUser, signatureType: string = 'APPROVER') {
    const doc = await this.renderRepo.findDocumentById(documentId);
    if (!doc) throw Object.assign(new Error('Document not found'), { status: 404 });
    if (['VOID', 'REVOKED', 'SUPERSEDED', 'EXPIRED', 'ARCHIVED'].includes(doc.status)) {
      throw Object.assign(new Error(`Document is ${doc.status} and cannot be signed`), { status: 400 });
    }

    const signatureHash = crypto.createHash('sha256')
      .update(`${doc.document_uuid}:${user.id}:${doc.checksum_sha256}`)
      .digest('hex');

    const signature = await this.renderRepo.signSlot(documentId, user.id, signatureHash);
    if (!signature) {
      throw Object.assign(
        new Error('No pending signature slot for this user on this document'),
        { status: 400 }
      );
    }

    await this.renderRepo.logAudit(documentId, 'SIGNED', user.id, {
      signature_id: signature.id,
      signature_type: signatureType,
    });

    logger.info({ documentId, userId: user.id, signatureType }, 'Document signed');
    return signature;
  }

  async setDocumentLifecycle(documentId: number, status: 'REVOKED' | 'VOID', reason: string, user: AuthUser) {
    const doc = await this.renderRepo.findDocumentById(documentId);
    if (!doc) throw Object.assign(new Error('Document not found'), { status: 404 });
    if (doc.status !== 'OFFICIAL') {
      throw Object.assign(new Error(`Only OFFICIAL documents can be ${status.toLowerCase()}`), { status: 400 });
    }

    const result = await this.renderRepo.setDocumentStatus(documentId, status, reason, user.id);
    if (!result.ok) throw Object.assign(new Error('Document status could not be changed'), { status: 400 });

    await this.renderRepo.logAudit(documentId, status === 'REVOKED' ? 'REVOKED' : 'VOIDED', user.id, {
      reason,
      actor: user.username,
    });

    logger.info({ documentId, status, userId: user.id }, 'Document lifecycle changed');
    return { ok: true, documentId, status };
  }

  // ── Validation ─────────────────────────────────────────────
  private validateResponses(schema: FormSchema, responses: Record<string, any>): Record<string, any> {
    const allowed = new Set<string>();
    const allFields = schema.sections.flatMap((s) => s.fields);
    for (const f of allFields) allowed.add(f.name);

    for (const key of Object.keys(responses)) {
      if (!allowed.has(key)) {
        throw Object.assign(new Error(`Unknown field: ${key}`), { status: 400 });
      }
    }

    const errors: string[] = [];
    const cleaned: Record<string, any> = {};

    for (const field of allFields) {
      const value = responses[field.name];
      const isActive = this.isFieldActive(field, responses);
      const required = Boolean(field.required) && isActive;

      if (required && this.isEmpty(value)) {
        errors.push(`Field "${field.name}" is required`);
        continue;
      }
      if (this.isEmpty(value)) continue;

      const err = this.validateFieldValue(field, value);
      if (err) {
        errors.push(err);
        continue;
      }
      cleaned[field.name] = value;
    }

    if (errors.length > 0) {
      throw Object.assign(new Error(`Validation failed: ${errors.join('; ')}`), {
        status: 400,
        validationErrors: errors,
      });
    }
    return cleaned;
  }

  private isFieldActive(field: FieldDef, responses: Record<string, any>): boolean {
    if (!field.conditional) return true;
    return responses[field.conditional.field] === field.conditional.equals;
  }

  private isEmpty(value: any): boolean {
    return value === undefined || value === null || value === '';
  }

  private validateFieldValue(field: FieldDef, value: any): string | null {
    switch (field.type) {
      case 'text':
      case 'textarea':
      case 'date': {
        if (typeof value !== 'string') return `Field "${field.name}" must be a string`;
        if (field.maxLength && value.length > field.maxLength) {
          return `Field "${field.name}" exceeds max length ${field.maxLength}`;
        }
        if (field.pattern && !new RegExp(field.pattern).test(value)) {
          return `Field "${field.name}" does not match required format`;
        }
        return null;
      }
      case 'number': {
        const n = typeof value === 'number' ? value : Number(value);
        if (Number.isNaN(n)) return `Field "${field.name}" must be a number`;
        if (field.min !== undefined && n < field.min) return `Field "${field.name}" below minimum ${field.min}`;
        if (field.max !== undefined && n > field.max) return `Field "${field.name}" exceeds maximum ${field.max}`;
        return null;
      }
      case 'boolean': {
        if (typeof value !== 'boolean') return `Field "${field.name}" must be a boolean`;
        return null;
      }
      case 'scale': {
        const n = typeof value === 'number' ? value : Number(value);
        if (Number.isNaN(n)) return `Field "${field.name}" must be a number`;
        const min = field.min ?? 1;
        const max = field.max ?? 5;
        if (n < min || n > max) return `Field "${field.name}" must be between ${min} and ${max}`;
        return null;
      }
      case 'select':
      case 'radio': {
        if (typeof value !== 'string') return `Field "${field.name}" must be a string`;
        if (field.options && !field.options.some((o) => o.value === value)) {
          return `Field "${field.name}" has an invalid option`;
        }
        return null;
      }
      default:
        return null;
    }
  }

  private computeTotalScore(schema: FormSchema, responses: Record<string, any>): number | null {
    const totalScoreDef = schema.computed?.total_score;
    if (!totalScoreDef || totalScoreDef.type !== 'mean') return null;
    const values = totalScoreDef.fields
      .map((f) => responses[f])
      .filter((v): v is number => typeof v === 'number');
    if (values.length === 0) return null;
    const mean = values.reduce((a, b) => a + b, 0) / values.length;
    return Math.round(mean * 100) / 100;
  }

  // ── Rendering helpers ──────────────────────────────────────
  private buildSections(schema: FormSchema, responses: Record<string, any>, language: 'ar' | 'en') {
    return schema.sections.map((section) => ({
      id: section.id,
      title: section.title[language] || section.title.ar,
      rows: section.fields
        .filter((f) => this.isFieldActive(f, responses) && !this.isEmpty(responses[f.name]))
        .map((f) => ({
          label: f.label[language] || f.label.ar,
          value: this.formatValue(f, responses[f.name], language),
        })),
    }));
  }

  private formatValue(field: FieldDef, value: any, language: 'ar' | 'en'): string {
    switch (field.type) {
      case 'boolean':
        return typeof value === 'boolean'
          ? (value ? (language === 'ar' ? 'نعم' : 'Yes') : (language === 'ar' ? 'لا' : 'No'))
          : String(value);
      case 'select':
      case 'radio': {
        const option = field.options?.find((o) => o.value === value);
        return option ? (option.label[language] || option.label.ar) : String(value);
      }
      default:
        return String(value);
    }
  }

  private async resolveCommittee(
    instance: any,
    opts: { committeeNameAr?: string; committeeNameEn?: string; institutionNameAr?: string; institutionNameEn?: string },
  ): Promise<{ committeeNameAr: string; committeeNameEn: string; institutionNameAr: string; institutionNameEn: string } | null> {
    if (opts.committeeNameAr || opts.institutionNameAr) {
      return {
        committeeNameAr: opts.committeeNameAr || '',
        committeeNameEn: opts.committeeNameEn || '',
        institutionNameAr: opts.institutionNameAr || '',
        institutionNameEn: opts.institutionNameEn || '',
      };
    }
    if (instance.entity_type !== 'Application') return null;
    return this.instanceRepo.getApplicationContext(instance.entity_id);
  }

  private assertEditable(instance: any): void {
    if (!['DRAFT', 'RETURNED'].includes(instance.status)) {
      throw Object.assign(
        new Error(`Form instance is in status ${instance.status} and cannot be edited`),
        { status: 400 }
      );
    }
  }
}

export type { FormInstanceStatus };
