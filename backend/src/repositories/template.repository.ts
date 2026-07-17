import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';
import type { ITimelineTemplateRepository } from '../services/template-timeline.service';

export class TemplateRepository extends AuditableRepository implements ITimelineTemplateRepository {
  async findIdByCode(code: string): Promise<number | null> {
    const result = await this.query(
      `SELECT id FROM templates.templates WHERE code = $1 AND deleted_at IS NULL`,
      [code]
    );
    return result.rows[0]?.id ?? null;
  }
  async findAll(params: PaginationParams, search?: string): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE t.deleted_at IS NULL';
    const values: any[] = [];
    let idx = 1;

    if (search) {
      whereClause += ` AND (t.code ILIKE $${idx} OR t.name_ar ILIKE $${idx} OR t.name_en ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.templates t ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT t.*, c.name_ar as category_name_ar, c.name_en as category_name_en
       FROM templates.templates t
       LEFT JOIN templates.categories c ON t.category_id = c.id
       ${whereClause}
       ORDER BY t.created_at DESC
       LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT t.*, c.name_ar as category_name_ar, c.name_en as category_name_en
       FROM templates.templates t
       LEFT JOIN templates.categories c ON t.category_id = c.id
       WHERE t.id = $1 AND t.deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCode(code: string): Promise<any | null> {
    const result = await this.query(
      `SELECT t.*, c.name_ar as category_name_ar, c.name_en as category_name_en
       FROM templates.templates t
       LEFT JOIN templates.categories c ON t.category_id = c.id
       WHERE t.code = $1 AND t.deleted_at IS NULL`,
      [code]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    category_id: number; code: string; name_ar: string; name_en: string;
    description?: string; engine?: string; default_locale?: string;
    tags?: string[]; variable_sources?: any;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.templates
        (category_id, code, name_ar, name_en, description, engine,
         default_locale, tags, variable_sources, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [
        data.category_id, data.code, data.name_ar, data.name_en,
        data.description || null, data.engine || 'handlebars',
        data.default_locale || 'ar',
        data.tags || [], JSON.stringify(data.variable_sources || []),
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    name_ar: string; name_en: string; description: string;
    tags: string[]; variable_sources: any; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name_ar !== undefined) { sets.push(`name_ar = $${idx++}`); values.push(data.name_ar); }
    if (data.name_en !== undefined) { sets.push(`name_en = $${idx++}`); values.push(data.name_en); }
    if (data.description !== undefined) { sets.push(`description = $${idx++}`); values.push(data.description); }
    if (data.tags !== undefined) { sets.push(`tags = $${idx++}`); values.push(data.tags); }
    if (data.variable_sources !== undefined) { sets.push(`variable_sources = $${idx++}`); values.push(JSON.stringify(data.variable_sources)); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) return this.findById(id);

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.templates SET ${sets.join(', ')} WHERE id = $${idx} AND deleted_at IS NULL RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE templates.templates SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING id`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return result.rows.length > 0;
  }

  async incrementUsageCount(id: number): Promise<void> {
    await this.query(
      `UPDATE templates.templates SET usage_count = usage_count + 1 WHERE id = $1`,
      [id]
    );
  }

  async getStats(): Promise<{ by_category: any[]; total: number }> {
    const totalResult = await this.query(
      `SELECT COUNT(*) FROM templates.templates WHERE deleted_at IS NULL`
    );
    const total = parseInt(totalResult.rows[0].count);

    const byCategoryResult = await this.query(
      `SELECT c.id, c.name_ar, c.name_en, COUNT(t.id) as template_count
       FROM templates.categories c
       LEFT JOIN templates.templates t ON t.category_id = c.id AND t.deleted_at IS NULL
       WHERE c.deleted_at IS NULL
       GROUP BY c.id, c.name_ar, c.name_en
       ORDER BY c.sort_order, c.name_ar`
    );
    return { by_category: byCategoryResult.rows, total };
  }
}
