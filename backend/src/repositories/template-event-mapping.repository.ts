import { AuditableRepository } from './auditable.repository';

export class TemplateEventMappingRepository extends AuditableRepository {
  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.event_template_mapping ORDER BY event_type, template_code`
    );
    return result.rows;
  }

  async findByEventType(eventType: string): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.event_template_mapping
       WHERE event_type = $1 AND is_active = true
       ORDER BY template_code`,
      [eventType]
    );
    return result.rows;
  }

  async create(data: {
    event_type: string; template_code: string;
    locale?: string; output_format?: string; is_active?: boolean;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO templates.event_template_mapping
        (event_type, template_code, locale, output_format, is_active,
         created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [
        data.event_type, data.template_code,
        data.locale || 'ar', data.output_format || 'PDF',
        data.is_active !== false,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    locale: string; output_format: string; is_active: boolean;
  }>): Promise<any | null> {
    const meta = this.updateMeta();
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.locale !== undefined) { sets.push(`locale = $${idx++}`); values.push(data.locale); }
    if (data.output_format !== undefined) { sets.push(`output_format = $${idx++}`); values.push(data.output_format); }
    if (data.is_active !== undefined) { sets.push(`is_active = $${idx++}`); values.push(data.is_active); }

    if (sets.length === 0) {
      const result = await this.query(
        `SELECT * FROM templates.event_template_mapping WHERE id = $1`,
        [id]
      );
      return result.rows[0] || null;
    }

    sets.push(`updated_by = $${idx++}`);
    values.push(meta.updated_by);
    sets.push(`updated_at = $${idx++}`);
    values.push(meta.updated_at);
    values.push(id);

    const result = await this.query(
      `UPDATE templates.event_template_mapping SET ${sets.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async delete(id: number): Promise<boolean> {
    const result = await this.query(
      `DELETE FROM templates.event_template_mapping WHERE id = $1`,
      [id]
    );
    return (result.rowCount ?? 0) > 0;
  }
}
