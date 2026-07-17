import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class TemplatePartialRepository extends AuditableRepository {
  async findAll(params: PaginationParams, search?: string): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE p.deleted_at IS NULL';
    const values: any[] = [];
    let idx = 1;

    if (search) {
      whereClause += ` AND (p.code ILIKE $${idx} OR p.name_ar ILIKE $${idx} OR p.name_en ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_partials p ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT p.*, t.code as template_code
       FROM templates.template_partials p
       LEFT JOIN templates.templates t ON p.template_id = t.id
       ${whereClause}
       ORDER BY p.code
       LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT p.*, t.code as template_code
       FROM templates.template_partials p
       LEFT JOIN templates.templates t ON p.template_id = t.id
       WHERE p.id = $1 AND p.deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCode(code: string): Promise<any | null> {
    const result = await this.query(
      `SELECT p.*, t.code as template_code
       FROM templates.template_partials p
       LEFT JOIN templates.templates t ON p.template_id = t.id
       WHERE p.code = $1 AND p.deleted_at IS NULL`,
      [code]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    template_id?: number; code: string; name_ar: string; name_en: string;
    engine?: string; content: string; content_hash: string;
    version?: string; depends_on?: string[];
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.template_partials
        (template_id, code, name_ar, name_en, engine, content,
         content_hash, version, depends_on, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [
        data.template_id || null, data.code, data.name_ar, data.name_en,
        data.engine || 'handlebars', data.content, data.content_hash,
        data.version || '1.0.0', data.depends_on || [],
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    name_ar: string; name_en: string; engine: string;
    content: string; content_hash: string; version: string;
    depends_on: string[]; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name_ar !== undefined) { sets.push(`name_ar = $${idx++}`); values.push(data.name_ar); }
    if (data.name_en !== undefined) { sets.push(`name_en = $${idx++}`); values.push(data.name_en); }
    if (data.engine !== undefined) { sets.push(`engine = $${idx++}`); values.push(data.engine); }
    if (data.content !== undefined) { sets.push(`content = $${idx++}`); values.push(data.content); }
    if (data.content_hash !== undefined) { sets.push(`content_hash = $${idx++}`); values.push(data.content_hash); }
    if (data.version !== undefined) { sets.push(`version = $${idx++}`); values.push(data.version); }
    if (data.depends_on !== undefined) { sets.push(`depends_on = $${idx++}`); values.push(data.depends_on); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) return this.findById(id);

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.template_partials SET ${sets.join(', ')} WHERE id = $${idx} AND deleted_at IS NULL RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE templates.template_partials SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING id`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return result.rows.length > 0;
  }
}
