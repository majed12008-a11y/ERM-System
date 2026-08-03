/*
 * خدمة دورة حياة المستندات: واجهة الحالات/الانتقالات القابلة للتكوين.
 *
 * قابلية التوسيع ونقلية النقل (transport-independence):
 *   - سجل معالجات أحداث يُربط بمعرفات الأحداث (action codes) أو يلتقط
 *     الكل ('*'). تُستدعى المعالجات بعد نجاح الانتقال فقط.
 *   - المعالجات دوال async نقية تستقبل سياقاً كاملاً قابل للتسلسل
 *     (JSON-serializable): document، من/إلى الحالات، action، actor،
 *     timestamp، reason، details، correlationId، requestId.
 *   - لا يرتبط التوزيع الحالي بأي ناقل (queue/HTTP/DB). عند الترحيل
 *     المستقبلي إلى طوابير غير متزامنة يكفي استبدال dispatchEvents بمعرّف
 *     يُسلسل السياق ويرسله للطابور دون إعادة تصميم المحرك أو توقيعات
 *     المعالجات.
 *   - فشل أي معالج لا يفشل الانتقال (الجانب الآثري بعد الالتزام بالمعاملة).
 *
 * لا يحتوي المحرك على أي قواعد انتقال مكتوبة برمجياً: كل الانتقالات
 * المسموحة تُشتق حصرياً من جدول document_lifecycle_transitions عبر
 * الدالة documents.fn_document_transition.
 */
import { DocumentLifecycleRepository, LifecycleDocumentSummary, LifecycleTransitionResult } from '../repositories/document-lifecycle.repository';
import { AuthUser } from '../shared/types';
import { getRequestId } from '../middleware/context';
import { logger } from '../config/logger';

export interface LifecycleEventActor {
  id: number;
  username: string;
}

export interface LifecycleEventContext {
  documentId: number;
  document: LifecycleDocumentSummary | null;
  actionCode: string;
  fromCode: string | null;
  toCode: string | null;
  isTerminal: boolean;
  timestamp: string | null;
  reason: string | null;
  details: unknown;
  actor: LifecycleEventActor;
  correlationId: string | null;
  requestId: string | null;
}

export interface LifecycleTransitionOptions {
  correlationId?: string;
  requestId?: string;
}

export type LifecycleEventHandler = (ctx: LifecycleEventContext) => void | Promise<void>;

export class DocumentLifecycleService {
  private readonly handlers = new Map<string, LifecycleEventHandler[]>();

  constructor(private repo = new DocumentLifecycleRepository()) {}

  onAction(actionCode: string, handler: LifecycleEventHandler): void {
    const list = this.handlers.get(actionCode) ?? [];
    list.push(handler);
    this.handlers.set(actionCode, list);
  }

  onAny(handler: LifecycleEventHandler): void {
    this.onAction('*', handler);
  }

  listStates() {
    return this.repo.listStates();
  }

  listTransitions() {
    return this.repo.listTransitions();
  }

  async transition(
    documentId: number,
    actionCode: string,
    reason: string | undefined,
    user: AuthUser,
    details?: unknown,
    opts?: LifecycleTransitionOptions
  ) {
    const requestId = opts?.requestId ?? getRequestId();
    const correlationId = opts?.correlationId ?? requestId;

    const result = await this.repo.applyTransition(documentId, actionCode, user.id, reason, details);
    if (!result.ok) {
      throw Object.assign(new Error(result.message || 'Transition not allowed'), { status: 400 });
    }
    await this.dispatchEvents(documentId, result, user, reason ?? null, details, correlationId, requestId);
    return result;
  }

  private async dispatchEvents(
    documentId: number,
    result: LifecycleTransitionResult,
    user: AuthUser,
    reason: string | null,
    details: unknown,
    correlationId: string,
    requestId: string
  ): Promise<void> {
    const ctx: LifecycleEventContext = {
      documentId,
      document: result.document,
      actionCode: result.action_code,
      fromCode: result.from_code,
      toCode: result.to_code,
      isTerminal: result.is_terminal,
      timestamp: result.timestamp,
      reason,
      details: details ?? null,
      actor: { id: user.id, username: user.username },
      correlationId,
      requestId,
    };

    const handlers = [
      ...(this.handlers.get(result.action_code) ?? []),
      ...(this.handlers.get('*') ?? []),
    ];

    for (const handler of handlers) {
      try {
        await handler(ctx);
      } catch (err: any) {
        logger.error(
          { err, documentId, actionCode: result.action_code },
          'Lifecycle event handler failed (transition already committed)'
        );
      }
    }
  }
}
