import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';
import type { IAuditRepository } from '../services/template-version-lifecycle.service';

export class TemplateAuditRepository extends AuditableRepository implements IAuditRepository {
  async log(entry: {
    template_version_id: number;
    action: string;
    actor_id: number;
    previous_status: string | null;
    new_status: string | null;
    comment?: string;
  }, client?: PoolClient): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_version_audit
        (template_version_id, action, actor_id, previous_status, new_status, comment, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, NOW())
       RETURNING *`,
      [
        entry.template_version_id, entry.action, entry.actor_id,
        entry.previous_status, entry.new_status,
        entry.comment || null,
      ],
      client
    );
    return result.rows[0];
  }

  async findByVersionId(versionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_version_audit
       WHERE template_version_id = $1
       ORDER BY created_at ASC`,
      [versionId]
    );
    return result.rows;
  }

  async findAll(params: PaginationParams, filters?: {
    action?: string;
    template_version_id?: number;
  }): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE 1=1';
    const values: any[] = [];
    let idx = 1;

    if (filters?.action) {
      whereClause += ` AND action = $${idx++}`;
      values.push(filters.action);
    }
    if (filters?.template_version_id) {
      whereClause += ` AND template_version_id = $${idx++}`;
      values.push(filters.template_version_id);
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_version_audit ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT * FROM templates.template_version_audit ${whereClause}
       ORDER BY created_at DESC
       LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }
}
