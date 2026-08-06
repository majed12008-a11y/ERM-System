/*
 * خدمة مكتبة النماذج:
 *   - إدارة تعريفات النماذج ومثيلاتها.
 *   - التحقق من صحة الاستجابات مقابل مخطط JSON المخزن
 *     (الحقول المطلوبة، الشروط، الأنواع، المدى، التبعيات).
 *   - حساب الدرجات المحسوبة (computed: mean/sum/count/count_checked).
 *   - ربط الإرسال بسير العمل عبر الإعداد (schema.workflow) — كل الانتقالات
 *     تُنفَّذ عبر محرك سير العمل (WorkflowService) وليست منطقاً مكتوباً يدوياً.
 *   - توليد مستند رسمي من استجابات النموذج عبر محرك المستندات.
 */
import { AuthUser, FormSchema } from '../shared/types';
import { FormDefinitionRepository } from '../repositories/form-definition.repository';
import { FormInstanceRepository, FormInstanceStatus } from '../repositories/form-instance.repository';
import { DocumentRenderService } from './document-render.service';
import { DocumentRenderRepository } from '../repositories/document-render.repository';
import { DocumentLifecycleService } from './document-lifecycle.service';
import { WorkflowService } from './workflow.service';
import { ApplicationRepository } from '../repositories/application.repository';
import { withTransaction } from '../config/database';
import { broadcastDashboardEvent, NotificationService } from './notification.service';
import { TRANSITION_TO_NOTIFICATION } from './notification-types';
import { logger } from '../config/logger';
import crypto from 'crypto';
import {
  computeComputed,
  isFieldActive,
  isEmpty,
  validateResponses,
} from './form-validation';

const CATEGORY_TEMPLATE: Record<string, { templateCode: string; documentType: string }> = {
  SCREENING: { templateCode: 'REVIEW_FORM_DOC', documentType: 'REVIEW_FORM' },
  REVIEW: { templateCode: 'REVIEW_FORM_DOC', documentType: 'REVIEW_FORM' },
  SAFETY: { templateCode: 'SAFETY_REPORT_DOC', documentType: 'SAFETY_REPORT' },
  CLOSURE: { templateCode: 'CLOSURE_REPORT_DOC', documentType: 'CLOSURE_REPORT' },
  MONITORING: { templateCode: 'MONITORING_REPORT_DOC', documentType: 'MONITORING_REPORT' },
  MEETING: { templateCode: 'MEETING_MINUTES_DOC', documentType: 'MEETING_DOCUMENT' },
  POST_APPROVAL: { templateCode: 'PROGRESS_REPORT_DOC', documentType: 'MONITORING_REPORT' },
  APPLICATION: { templateCode: 'APPLICATION_DOC', documentType: 'APPLICATION' },
};

export class FormService {
  constructor(
    private definitionRepo = new FormDefinitionRepository(),
    private instanceRepo = new FormInstanceRepository(),
    private renderService = new DocumentRenderService(),
    private renderRepo = new DocumentRenderRepository(),
    private workflow = new WorkflowService(),
    private appRepo = new ApplicationRepository(),
    private lifecycle = new DocumentLifecycleService(),
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
    const validated = validateResponses(schema, responses);
    const updated = await this.instanceRepo.saveResponses(id, validated, 'DRAFT');
    return updated;
  }

  /**
   * إرسال النموذج: يتحقق، يثبت الحالة SUBMITTED، ثم — إذا كان المخطط يحدد
   * schema.workflow — ينفذ انتقال سير العمل عبر WorkflowService داخل نفس
   * المعاملة ويزامن حالة الكيان الأب (Application).
   */
  async submitInstance(id: number, responses: Record<string, any>, user: AuthUser) {
    const { instance, definition } = await this.getInstance(id);
    this.assertEditable(instance);

    const schema = definition.form_schema as FormSchema;
    const validated = validateResponses(schema, responses);
    const totalScore = computeComputed(schema.computed, validated);
    const recommendation = validated.recommendation || null;

    const wfConfig = schema.workflow;

    const result = await withTransaction(async (client) => {
      const submitted = await this.instanceRepo.submit(
        id,
        { total_score: totalScore, recommendation },
        client
      );
      if (!submitted) {
        throw Object.assign(new Error('Only DRAFT or RETURNED instances can be submitted'), { status: 400 });
      }

      let transitionResult: { to_state: string; from_state: string; transition_code: string } | null = null;
      if (wfConfig?.entity_type && wfConfig.transition_on_submit) {
        const instanceFound = await this.workflow.getInstance(wfConfig.entity_type, instance.entity_id);
        if (!instanceFound) {
          if (!wfConfig.workflow_code) {
            throw Object.assign(
              new Error(
                `No active workflow instance for ${wfConfig.entity_type} #${instance.entity_id}; schema.workflow.workflow_code is required to initialize it`
              ),
              { status: 400 }
            );
          }
          await this.workflow.initWorkflow(wfConfig.workflow_code, wfConfig.entity_type, instance.entity_id, client);
        }
        transitionResult = await this.workflow.executeTransition(
          wfConfig.entity_type,
          instance.entity_id,
          wfConfig.transition_on_submit,
          user,
          undefined,
          client
        );
        if (wfConfig.entity_type === 'Application') {
          await this.appRepo.updateStatus(instance.entity_id, transitionResult.to_state, client);
        }
      }

      return { submitted, transitionResult };
    });

    if (result.transitionResult && wfConfig) {
      broadcastDashboardEvent('dashboard-stats', {});
      const notifType = TRANSITION_TO_NOTIFICATION[wfConfig.transition_on_submit];
      if (notifType) {
        try {
          let targetUserId: number = instance.created_by;
          if (wfConfig.entity_type === 'Application') {
            const app = await this.appRepo.findById(instance.entity_id);
            if (app?.submitted_by) targetUserId = app.submitted_by;
          }
          const notifService = new NotificationService();
          await notifService.send({
            userId: targetUserId,
            notificationType: notifType,
            subject: `${wfConfig.entity_type} #${instance.entity_id}`,
            messageBody: `Your ${wfConfig.entity_type} #${instance.entity_id} has been submitted.`,
            sourceEntityType: wfConfig.entity_type,
            sourceEntityId: instance.entity_id,
          });
        } catch (err: any) {
          logger.error({ err, instanceId: id }, 'Notification after form submit failed');
        }
      }
    }

    logger.info(
      { instanceId: id, form: definition.form_code, score: totalScore, workflow: result.transitionResult?.to_state },
      'Form instance submitted'
    );
    return result.submitted;
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
    watermark?: { code: string; values?: Record<string, string> };
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
    // schema.document override (config-driven per-form) takes precedence.
    const effectiveConfig = schema.document
      ? { templateCode: schema.document.template_code, documentType: schema.document.document_type }
      : categoryConfig;
    const templateCode = opts.templateCode || effectiveConfig.templateCode;

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
      category: effectiveConfig.documentType,
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
      watermark: opts.watermark,
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

  /**
   * إبطال/سحب مستند عبر محرك دورة حياة المستندات (Gate 0)
   * — action: VOID | REVOKE من جدول document_lifecycle_transitions.
   */
  async setDocumentLifecycle(documentId: number, status: 'REVOKED' | 'VOID', reason: string, user: AuthUser) {
    const doc = await this.renderRepo.findDocumentById(documentId);
    if (!doc) throw Object.assign(new Error('Document not found'), { status: 404 });

    const action = status === 'REVOKED' ? 'REVOKE' : 'VOID';
    const result = await this.lifecycle.transition(documentId, action, reason, user);

    logger.info({ documentId, status, action: result.action_code, userId: user.id }, 'Document lifecycle changed');
    return { ok: true, documentId, status };
  }

  // ── Rendering helpers ──────────────────────────────────────
  private buildSections(schema: FormSchema, responses: Record<string, any>, language: 'ar' | 'en') {
    return schema.sections.map((section) => ({
      id: section.id,
      title: section.title[language] || section.title.ar,
      rows: section.fields
        .filter((f) => isFieldActive(f, responses) && !isEmpty(responses[f.name]))
        .map((f) => ({
          label: f.label[language] || f.label.ar,
          value: this.formatValue(f, responses[f.name], language),
        })),
    }));
  }

  private formatValue(field: any, value: any, language: 'ar' | 'en'): string {
    switch (field.type) {
      case 'boolean':
        return typeof value === 'boolean'
          ? (value ? (language === 'ar' ? 'نعم' : 'Yes') : (language === 'ar' ? 'لا' : 'No'))
          : String(value);
      case 'select':
      case 'radio': {
        const option = field.options?.find((o: any) => o.value === value);
        return option ? (option.label[language] || option.label.ar) : String(value);
      }
      case 'checkbox': {
        if (!Array.isArray(value)) return String(value);
        return value
          .map((v: string) => {
            const option = field.options?.find((o: any) => o.value === v);
            return option ? (option.label[language] || option.label.ar) : v;
          })
          .join('، ' + (language === 'ar' ? '' : ', '));
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
