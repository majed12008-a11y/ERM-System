/*
 * خدمة دورة حياة المستندات: واجهة الحالات/الانتقالات القابلة للتكوين.
 *
 * قابلية التوسيع: سجل معالجات أحداث (handlers) يُربط بمعرفات الأحداث
 * (action codes) أو يلتقط الكل ('*'). تُستدعى المعالجات بعد نجاح
 * الانتقال فقط، وتتلقى سياقاً غنياً (from/to codes, is_terminal, actor,
 * reason). يمكن إرفاق إشعارات، توليد مستندات، إنشاء مهام، تحديثات وصول،
 * أو تكاملات مستقبلاً دون تعديل محرك الانتقال نفسه. فشل أي معالج لا
 * يفشل الانتقال (الجانب الآثري بعد الالتزام بالمعاملة).
 */
import { DocumentLifecycleRepository, LifecycleTransitionResult } from '../repositories/document-lifecycle.repository';
import { AuthUser } from '../shared/types';
import { logger } from '../config/logger';

export interface LifecycleEventContext {
  documentId: number;
  actionCode: string;
  fromCode: string | null;
  toCode: string | null;
  isTerminal: boolean;
  reason: string | null;
  actorId: number;
  newStatus: string | null;
  documentNumber: string | null;
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
    details?: unknown
  ) {
    const result = await this.repo.applyTransition(documentId, actionCode, user.id, reason, details);
    if (!result.ok) {
      throw Object.assign(new Error(result.message || 'Transition not allowed'), { status: 400 });
    }
    await this.dispatchEvents(documentId, result, user.id, reason);
    return result;
  }

  private async dispatchEvents(
    documentId: number,
    result: LifecycleTransitionResult,
    actorId: number,
    reason?: string | null
  ): Promise<void> {
    const ctx: LifecycleEventContext = {
      documentId,
      actionCode: result.action_code,
      fromCode: result.from_code,
      toCode: result.to_code,
      isTerminal: result.is_terminal,
      reason: reason ?? null,
      actorId,
      newStatus: result.new_status,
      documentNumber: result.document_number,
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
