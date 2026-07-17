import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class TemplateRenderHistoryRepository extends AuditableRepository {
  async create(data: {
    template_version_id: number; template_code: string; version: string;
    locale: string; output_format: string; entity_type: string;
    entity_id: number; generated_by: number; variables_hash: string;
    output_id: number; storage_path: string; checksum_sha256: string;
    rendered_html_hash?: string; duration_ms?: number; status: string;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_render_history
        (template_version_id, template_code, version, locale, output_format,
         entity_type, entity_id, generated_by, variables_hash, rendered_html_hash,
         output_id, storage_path, checksum_sha256, duration_ms, status)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)
       RETURNING *`,
      [
        data.template_version_id, data.template_code, data.version,
        data.locale, data.output_format, data.entity_type,
        data.entity_id, data.generated_by, data.variables_hash,
        data.rendered_html_hash || null, data.output_id,
        data.storage_path, data.checksum_sha256,
        data.duration_ms || null, data.status,
      ]
    );
    return result.rows[0];
  }

  async findByEntity(entityType: string, entityId: number, params?: PaginationParams): Promise<{ rows: any[]; total: number }> {
    const limit = params?.limit || 20;
    const offset = params ? (params.page - 1) * params.limit : 0;

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_render_history
       WHERE entity_type = $1 AND entity_id = $2`,
      [entityType, entityId]
    );
    const total = parseInt(countResult.rows[0].count);

    const result = await this.query(
      `SELECT * FROM templates.template_render_history
       WHERE entity_type = $1 AND entity_id = $2
       ORDER BY generated_at DESC
       LIMIT $3 OFFSET $4`,
      [entityType, entityId, limit, offset]
    );
    return { rows: result.rows, total };
  }

  async findByTemplateCode(templateCode: string, params?: PaginationParams): Promise<{ rows: any[]; total: number }> {
    const limit = params?.limit || 20;
    const offset = params ? (params.page - 1) * params.limit : 0;

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_render_history
       WHERE template_code = $1`,
      [templateCode]
    );
    const total = parseInt(countResult.rows[0].count);

    const result = await this.query(
      `SELECT * FROM templates.template_render_history
       WHERE template_code = $1
       ORDER BY generated_at DESC
       LIMIT $2 OFFSET $3`,
      [templateCode, limit, offset]
    );
    return { rows: result.rows, total };
  }

  async findAll(params: PaginationParams, filters?: {
    status?: string; entity_type?: string;
    template_code?: string; generated_by?: number;
  }): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE 1=1';
    const values: any[] = [];
    let idx = 1;

    if (filters?.status) {
      whereClause += ` AND status = $${idx++}`;
      values.push(filters.status);
    }
    if (filters?.entity_type) {
      whereClause += ` AND entity_type = $${idx++}`;
      values.push(filters.entity_type);
    }
    if (filters?.template_code) {
      whereClause += ` AND template_code = $${idx++}`;
      values.push(filters.template_code);
    }
    if (filters?.generated_by) {
      whereClause += ` AND generated_by = $${idx++}`;
      values.push(filters.generated_by);
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_render_history ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT * FROM templates.template_render_history ${whereClause}
       ORDER BY generated_at DESC
       LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }
}
