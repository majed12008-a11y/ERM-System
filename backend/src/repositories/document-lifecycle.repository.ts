/*
 * مستودع محرك دورة حياة المستندات: قراءة الحالات والانتقالات القابلة
 * للتكوين وتنفيذ الانتقال عبر دالة واحدة SECURITY DEFINER داخل معاملة
 * واحدة، مع إثراء النتيجة بسياق الانتقال (from/to codes + is_terminal)
 * لتمكين معالجات الأحداث المستقبلية (إشعارات، توليد مستندات، مهام،
 * تحديثات وصول، تكاملات) دون إعادة تصميم المحرك.
 */
import { AuditableRepository } from './auditable.repository';

export interface LifecycleState {
  id: number;
  code: string;
  name_ar: string;
  name_en: string | null;
  is_terminal: boolean;
  is_active: boolean;
  sort_order: number;
}

export interface LifecycleTransition {
  id: number;
  from_state_id: number;
  to_state_id: number;
  action_code: string;
  name_ar: string;
  name_en: string | null;
  requires_signatures: boolean;
  is_active: boolean;
  from_code: string;
  to_code: string;
}

export interface LifecycleDocumentSummary {
  id: number;
  document_number: string | null;
  document_uuid: string | null;
  document_title: string | null;
  status: string | null;
  lifecycle_state_id: number | null;
}

export interface LifecycleTransitionResult {
  ok: boolean;
  message: string;
  new_status: string | null;
  document_number: string | null;
  action_code: string;
  from_code: string | null;
  to_code: string | null;
  is_terminal: boolean;
  document: LifecycleDocumentSummary | null;
  timestamp: string | null;
}

export class DocumentLifecycleRepository extends AuditableRepository {
  async listStates(): Promise<LifecycleState[]> {
    const result = await this.query(
      `SELECT id, code, name_ar, name_en, is_terminal, is_active, sort_order
       FROM documents.document_lifecycle_states
       WHERE is_active = TRUE
       ORDER BY sort_order`
    );
    return result.rows as LifecycleState[];
  }

  async listTransitions(): Promise<LifecycleTransition[]> {
    const result = await this.query(
      `SELECT tr.id, tr.from_state_id, tr.to_state_id, tr.action_code,
              tr.name_ar, tr.name_en, tr.requires_signatures, tr.is_active,
              f.code AS from_code, t.code AS to_code
       FROM documents.document_lifecycle_transitions tr
       JOIN documents.document_lifecycle_states f ON f.id = tr.from_state_id
       JOIN documents.document_lifecycle_states t ON t.id = tr.to_state_id
       WHERE tr.is_active = TRUE
       ORDER BY tr.id`
    );
    return result.rows as LifecycleTransition[];
  }

  async applyTransition(
    documentId: number,
    actionCode: string,
    actorId: number,
    reason?: string | null,
    details?: unknown
  ): Promise<LifecycleTransitionResult> {
    return this.withTransaction(async (client) => {
      const fromRes = await this.query(
        `SELECT ls.code AS from_code
         FROM documents.documents d
         JOIN documents.document_lifecycle_states ls ON ls.id = d.lifecycle_state_id
         WHERE d.id = $1`,
        [documentId],
        client
      );

      const res = await this.query(
        `SELECT * FROM documents.fn_document_transition($1, $2, $3, $4, $5)`,
        [documentId, actionCode, actorId, reason ?? null, details !== undefined ? JSON.stringify(details) : null],
        client
      );

      const row = res.rows[0];
      if (!row || !row.ok) {
        return {
          ok: false,
          message: row?.message ?? 'Transition rejected',
          new_status: row?.new_status ?? null,
          document_number: row?.document_number ?? null,
          action_code: actionCode,
          from_code: fromRes.rows[0]?.from_code ?? null,
          to_code: null,
          is_terminal: false,
          document: null,
          timestamp: null,
        };
      }

      const toRes = await this.query(
        `SELECT ls.code AS to_code, ls.is_terminal
         FROM documents.documents d
         JOIN documents.document_lifecycle_states ls ON ls.id = d.lifecycle_state_id
         WHERE d.id = $1`,
        [documentId],
        client
      );

      const docRes = await this.query(
        `SELECT id, document_number, document_uuid, document_title, status, lifecycle_state_id
         FROM documents.documents
         WHERE id = $1`,
        [documentId],
        client
      );

      const auditRes = await this.query(
        `SELECT action_timestamp FROM documents.document_audit
         WHERE document_id = $1
         ORDER BY id DESC LIMIT 1`,
        [documentId],
        client
      );

      return {
        ok: true,
        message: row.message,
        new_status: row.new_status,
        document_number: row.document_number,
        action_code: actionCode,
        from_code: fromRes.rows[0]?.from_code ?? null,
        to_code: toRes.rows[0]?.to_code ?? null,
        is_terminal: toRes.rows[0]?.is_terminal ?? false,
        document: docRes.rows[0] ?? null,
        timestamp: auditRes.rows[0]?.action_timestamp?.toISOString?.() ?? null,
      };
    });
  }
}
