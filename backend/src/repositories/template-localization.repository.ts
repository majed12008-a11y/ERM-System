import { AuditableRepository } from './auditable.repository';

export class TemplateLocalizationRepository extends AuditableRepository {
  async findByVersionId(templateVersionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_localizations
       WHERE template_version_id = $1
       ORDER BY locale ASC`,
      [templateVersionId]
    );
    return result.rows;
  }

  async findByVersionIdAndLocale(templateVersionId: number, locale: string): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_localizations
       WHERE template_version_id = $1 AND locale = $2`,
      [templateVersionId, locale]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    template_version_id: number; locale: string; content: any;
    content_hash: string; is_verified?: boolean;
    verified_by?: number; verified_at?: Date;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO templates.template_localizations
        (template_version_id, locale, content, content_hash,
         is_verified, verified_by, verified_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [
        data.template_version_id, data.locale,
        JSON.stringify(data.content), data.content_hash,
        data.is_verified || false, data.verified_by || null,
        data.verified_at || null,
      ]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<{
    content: any; content_hash: string;
    is_verified: boolean; verified_by: number; verified_at: Date;
  }>): Promise<any | null> {
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.content !== undefined) { sets.push(`content = $${idx++}`); values.push(JSON.stringify(data.content)); }
    if (data.content_hash !== undefined) { sets.push(`content_hash = $${idx++}`); values.push(data.content_hash); }
    if (data.is_verified !== undefined) { sets.push(`is_verified = $${idx++}`); values.push(data.is_verified); }
    if (data.verified_by !== undefined) { sets.push(`verified_by = $${idx++}`); values.push(data.verified_by); }
    if (data.verified_at !== undefined) { sets.push(`verified_at = $${idx++}`); values.push(data.verified_at); }

    if (sets.length === 0) {
      const result = await this.query(
        `SELECT * FROM templates.template_localizations WHERE id = $1`,
        [id]
      );
      return result.rows[0] || null;
    }

    values.push(id);
    const result = await this.query(
      `UPDATE templates.template_localizations SET ${sets.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }
}
