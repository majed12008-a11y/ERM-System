import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class TemplateVariableRepository extends AuditableRepository {
  async findAll(params: PaginationParams, search?: string): Promise<{ rows: any[]; total: number }> {
    let whereClause = 'WHERE deleted_at IS NULL';
    const values: any[] = [];
    let idx = 1;

    if (search) {
      whereClause += ` AND (code ILIKE $${idx} OR name_ar ILIKE $${idx} OR name_en ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM templates.template_variables ${whereClause}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    values.push(params.limit);
    values.push((params.page - 1) * params.limit);

    const result = await this.query(
      `SELECT * FROM templates.template_variables ${whereClause} ORDER BY code LIMIT $${idx++} OFFSET $${idx++}`,
      values
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_variables WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCode(code: string): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_variables WHERE code = $1 AND deleted_at IS NULL`,
      [code]
    );
    return result.rows[0] || null;
  }

  async findByTemplateVersionId(templateVersionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT DISTINCT tv.*
       FROM templates.template_variables tv
       JOIN templates.template_versions tvg ON tvg.id = $1
       WHERE tv.deleted_at IS NULL
         AND tv.code IN (
           SELECT jsonb_array_elements_text(
             CASE WHEN jsonb_typeof(tvg.variable_definitions) = 'array'
               THEN tvg.variable_definitions
               ELSE '[]'::jsonb
             END
           )->>'code'
         )
       ORDER BY tv.code`,
      [templateVersionId]
    );
    return result.rows;
  }

  async create(data: {
    code: string; name_ar: string; name_en: string; type: string;
    source_type: string; enum_values?: any; resolver_path?: string;
    resolver_function?: string; resolver_function_args?: any;
    entity_whitelist_root?: string; default_value?: any;
    description_ar?: string; description_en?: string;
    required?: boolean; validation_rules?: any;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.template_variables
        (code, name_ar, name_en, type, source_type, enum_values,
         resolver_path, resolver_function, resolver_function_args,
         entity_whitelist_root, default_value, description_ar,
         description_en, required, validation_rules, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15, $16, $17)
       RETURNING *`,
      [
        data.code, data.name_ar, data.name_en, data.type, data.source_type,
        data.enum_values ? JSON.stringify(data.enum_values) : null,
        data.resolver_path || null, data.resolver_function || null,
        data.resolver_function_args ? JSON.stringify(data.resolver_function_args) : null,
        data.entity_whitelist_root || null,
        data.default_value !== undefined ? JSON.stringify(data.default_value) : null,
        data.description_ar || null, data.description_en || null,
        data.required || false,
        data.validation_rules ? JSON.stringify(data.validation_rules) : null,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    name_ar: string; name_en: string; type: string; source_type: string;
    enum_values: any; resolver_path: string; resolver_function: string;
    resolver_function_args: any; entity_whitelist_root: string;
    default_value: any; description_ar: string; description_en: string;
    required: boolean; validation_rules: any; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name_ar !== undefined) { sets.push(`name_ar = $${idx++}`); values.push(data.name_ar); }
    if (data.name_en !== undefined) { sets.push(`name_en = $${idx++}`); values.push(data.name_en); }
    if (data.type !== undefined) { sets.push(`type = $${idx++}`); values.push(data.type); }
    if (data.source_type !== undefined) { sets.push(`source_type = $${idx++}`); values.push(data.source_type); }
    if (data.enum_values !== undefined) { sets.push(`enum_values = $${idx++}`); values.push(JSON.stringify(data.enum_values)); }
    if (data.resolver_path !== undefined) { sets.push(`resolver_path = $${idx++}`); values.push(data.resolver_path); }
    if (data.resolver_function !== undefined) { sets.push(`resolver_function = $${idx++}`); values.push(data.resolver_function); }
    if (data.resolver_function_args !== undefined) { sets.push(`resolver_function_args = $${idx++}`); values.push(JSON.stringify(data.resolver_function_args)); }
    if (data.entity_whitelist_root !== undefined) { sets.push(`entity_whitelist_root = $${idx++}`); values.push(data.entity_whitelist_root); }
    if (data.default_value !== undefined) { sets.push(`default_value = $${idx++}`); values.push(JSON.stringify(data.default_value)); }
    if (data.description_ar !== undefined) { sets.push(`description_ar = $${idx++}`); values.push(data.description_ar); }
    if (data.description_en !== undefined) { sets.push(`description_en = $${idx++}`); values.push(data.description_en); }
    if (data.required !== undefined) { sets.push(`required = $${idx++}`); values.push(data.required); }
    if (data.validation_rules !== undefined) { sets.push(`validation_rules = $${idx++}`); values.push(JSON.stringify(data.validation_rules)); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) return this.findById(id);

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.template_variables SET ${sets.join(', ')} WHERE id = $${idx} AND deleted_at IS NULL RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE templates.template_variables SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING id`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return result.rows.length > 0;
  }
}
