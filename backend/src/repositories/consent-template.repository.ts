/*
 * مستودع قوالب الموافقة المستنيرة: إنشاء وإدارة
 * قوالب الموافقة المستخدمة في الأبحاث.
 */
import { AuditableRepository } from './auditable.repository';

export class ConsentTemplateRepository extends AuditableRepository {
  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM committee.consent_templates WHERE deleted_at IS NULL ORDER BY name_ar`
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM committee.consent_templates WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: any): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.consent_templates (code, name_ar, name_en, description, consent_type, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [data.code, data.name_ar, data.name_en, data.description || null, data.consent_type,
       meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async update(id: number, data: any): Promise<any | null> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE committee.consent_templates SET
        name_ar = COALESCE($1, name_ar),
        name_en = COALESCE($2, name_en),
        description = COALESCE($3, description),
        consent_type = COALESCE($4, consent_type),
        is_active = COALESCE($5, is_active),
        updated_at = $6, updated_by = $7
       WHERE id = $8 AND deleted_at IS NULL RETURNING *`,
      [data.name_ar, data.name_en, data.description, data.consent_type,
       data.is_active, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async retire(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE committee.consent_templates SET is_active = false, deleted_at = $1, deleted_by = $2
       WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }
}
