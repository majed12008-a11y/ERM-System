/*
 * مستودع شروط الموافقة المشروطة: إدارة الشروط المرتبطة
 * بحالة AWAITING_CONDITIONS في سير عمل الطلبات.
 */
import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';

export interface ApplicationConditionRow {
  id: number;
  application_id: number;
  condition_text: string;
  severity: string;
  category: string;
  due_date: Date | null;
  status: string;
  resolved_by: number | null;
  resolved_at: Date | null;
  created_at: Date;
  created_by: number;
  updated_at: Date | null;
  updated_by: number | null;
  deleted_at: Date | null;
  deleted_by: number | null;
}

export interface ConditionSummary {
  total: number;
  open: number;
  met: number;
  notMet: number;
  waived: number;
}

export class ConditionRepository extends AuditableRepository {
  async findByApplication(applicationId: number): Promise<ApplicationConditionRow[]> {
    const result = await this.query(
      `SELECT ac.*,
              CONCAT(u.first_name_ar, ' ', u.last_name_ar) as resolved_by_name
       FROM committee.application_conditions ac
       LEFT JOIN security.users u ON ac.resolved_by = u.id
       WHERE ac.application_id = $1
         AND ac.deleted_at IS NULL
       ORDER BY
         CASE ac.severity
           WHEN 'CRITICAL' THEN 3
           WHEN 'MAJOR' THEN 2
           WHEN 'MINOR' THEN 1
         END DESC,
         ac.created_at ASC`,
      [applicationId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<ApplicationConditionRow | null> {
    const result = await this.query(
      `SELECT ac.*,
              CONCAT(u.first_name_ar, ' ', u.last_name_ar) as resolved_by_name
       FROM committee.application_conditions ac
       LEFT JOIN security.users u ON ac.resolved_by = u.id
       WHERE ac.id = $1
         AND ac.deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByIdIncludingDeleted(id: number): Promise<ApplicationConditionRow | null> {
    const result = await this.query(
      `SELECT ac.*,
              CONCAT(u.first_name_ar, ' ', u.last_name_ar) as resolved_by_name
       FROM committee.application_conditions ac
       LEFT JOIN security.users u ON ac.resolved_by = u.id
       WHERE ac.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    application_id: number;
    condition_text: string;
    severity?: string;
    category?: string;
    due_date?: string;
  }): Promise<ApplicationConditionRow> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.application_conditions
        (application_id, condition_text, severity, category, due_date, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [
        data.application_id,
        data.condition_text,
        data.severity || 'MAJOR',
        data.category || 'GENERAL',
        data.due_date || null,
        meta.created_by,
        meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: {
    condition_text?: string;
    severity?: string;
    category?: string;
    due_date?: string | null;
  }): Promise<ApplicationConditionRow | null> {
    const meta = this.updateMeta();
    const fields: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.condition_text !== undefined) {
      fields.push(`condition_text = $${idx++}`);
      values.push(data.condition_text);
    }
    if (data.severity !== undefined) {
      fields.push(`severity = $${idx++}`);
      values.push(data.severity);
    }
    if (data.category !== undefined) {
      fields.push(`category = $${idx++}`);
      values.push(data.category);
    }
    if (data.due_date !== undefined) {
      fields.push(`due_date = $${idx++}`);
      values.push(data.due_date);
    }

    if (fields.length === 0) return null;

    fields.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    fields.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);

    values.push(id);
    const result = await this.query(
      `UPDATE committee.application_conditions
       SET ${fields.join(', ')}
       WHERE id = $${idx}
         AND deleted_at IS NULL
       RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE committee.application_conditions
       SET deleted_at = $1, deleted_by = $2
       WHERE id = $3
         AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async resolveStatus(id: number, status: string, resolvedBy: number, client?: PoolClient): Promise<ApplicationConditionRow | null> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE committee.application_conditions
       SET status = $1, resolved_by = $2, resolved_at = NOW(),
           updated_at = $3, updated_by = $4
       WHERE id = $5
         AND deleted_at IS NULL
       RETURNING *`,
      [status, resolvedBy, meta.updated_at, meta.updated_by, id],
      client
    );
    return result.rows[0] || null;
  }

  async getOpenCount(applicationId: number): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(*) as count
       FROM committee.application_conditions
       WHERE application_id = $1
         AND status = 'OPEN'
         AND deleted_at IS NULL`,
      [applicationId]
    );
    return parseInt(result.rows[0].count);
  }

  async getUnmetConditionIds(applicationId: number): Promise<number[]> {
    const result = await this.query(
      `SELECT id
       FROM committee.application_conditions
       WHERE application_id = $1
         AND status IN ('OPEN', 'NOT_MET')
         AND deleted_at IS NULL
       ORDER BY id`,
      [applicationId]
    );
    return result.rows.map((r: any) => r.id);
  }

  async evaluateEvidenceCoverage(applicationId: number, conditionIds: number[]): Promise<{ condition_id: number; has_evidence: boolean }[]> {
    if (conditionIds.length === 0) return [];
    const result = await this.query(
      `SELECT ac.id as condition_id,
              EXISTS (
                SELECT 1 FROM documents.documents d
                WHERE d.entity_type = 'ApplicationCondition'
                  AND d.entity_id::bigint = ac.id
                  AND d.deleted_at IS NULL
              ) as has_evidence
       FROM committee.application_conditions ac
       WHERE ac.application_id = $1
         AND ac.id = ANY($2::bigint[])
         AND ac.deleted_at IS NULL
       ORDER BY ac.id`,
      [applicationId, conditionIds]
    );
    return result.rows;
  }

  async countByStatus(applicationId: number): Promise<ConditionSummary> {
    const result = await this.query(
      `SELECT
         COUNT(*)::int as total,
         COALESCE(COUNT(*) FILTER (WHERE status = 'OPEN'), 0)::int as open,
         COALESCE(COUNT(*) FILTER (WHERE status = 'MET'), 0)::int as met,
         COALESCE(COUNT(*) FILTER (WHERE status = 'NOT_MET'), 0)::int as not_met,
         COALESCE(COUNT(*) FILTER (WHERE status = 'WAIVED'), 0)::int as waived
       FROM committee.application_conditions
       WHERE application_id = $1
         AND deleted_at IS NULL`,
      [applicationId]
    );
    const row = result.rows[0];
    return {
      total: row.total,
      open: row.open,
      met: row.met,
      notMet: row.not_met,
      waived: row.waived,
    };
  }
}
