import { AuditableRepository } from './auditable.repository';

export class TemplateCategoryRepository extends AuditableRepository {
  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.categories WHERE deleted_at IS NULL ORDER BY sort_order, name_ar`
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.categories WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCode(code: string): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.categories WHERE code = $1 AND deleted_at IS NULL`,
      [code]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    code: string; name_ar: string; name_en: string;
    description?: string; parent_category_id?: number;
    required_variables?: any; default_output_format?: string;
    approval_required?: boolean; sort_order?: number;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.categories
        (code, name_ar, name_en, description, parent_category_id,
         required_variables, default_output_format, approval_required,
         sort_order, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [
        data.code, data.name_ar, data.name_en,
        data.description || null, data.parent_category_id || null,
        JSON.stringify(data.required_variables || []),
        data.default_output_format || 'PDF',
        data.approval_required !== false,
        data.sort_order || 0,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    name_ar: string; name_en: string; description: string;
    parent_category_id: number; required_variables: any;
    default_output_format: string; approval_required: boolean;
    sort_order: number; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name_ar !== undefined) { sets.push(`name_ar = $${idx++}`); values.push(data.name_ar); }
    if (data.name_en !== undefined) { sets.push(`name_en = $${idx++}`); values.push(data.name_en); }
    if (data.description !== undefined) { sets.push(`description = $${idx++}`); values.push(data.description); }
    if (data.parent_category_id !== undefined) { sets.push(`parent_category_id = $${idx++}`); values.push(data.parent_category_id); }
    if (data.required_variables !== undefined) { sets.push(`required_variables = $${idx++}`); values.push(JSON.stringify(data.required_variables)); }
    if (data.default_output_format !== undefined) { sets.push(`default_output_format = $${idx++}`); values.push(data.default_output_format); }
    if (data.approval_required !== undefined) { sets.push(`approval_required = $${idx++}`); values.push(data.approval_required); }
    if (data.sort_order !== undefined) { sets.push(`sort_order = $${idx++}`); values.push(data.sort_order); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) return this.findById(id);

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.categories SET ${sets.join(', ')} WHERE id = $${idx} AND deleted_at IS NULL RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE templates.categories SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING id`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return result.rows.length > 0;
  }
}
