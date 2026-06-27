/*
 * مستودع إصدارات قوالب الموافقة: إدارة إصدارات
 * القوالب وتتبع التغييرات عبر الزمن.
 */
import { AuditableRepository } from './auditable.repository';

export class ConsentVersionRepository extends AuditableRepository {
  async findByTemplate(templateId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ctv.*, ct.name_ar as template_name_ar, ct.name_en as template_name_en
       FROM committee.consent_template_versions ctv
       JOIN committee.consent_templates ct ON ctv.template_id = ct.id
       WHERE ctv.template_id = $1 AND ctv.deleted_at IS NULL
       ORDER BY ctv.version_no DESC, ctv.language`,
      [templateId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT ctv.*, ct.name_ar as template_name_ar, ct.name_en as template_name_en
       FROM committee.consent_template_versions ctv
       JOIN committee.consent_templates ct ON ctv.template_id = ct.id
       WHERE ctv.id = $1 AND ctv.deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(templateId: number, data: any): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.consent_template_versions
        (template_id, version_no, language, title, content, document_id,
         effective_from, change_summary, status, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, 'DRAFT', $9, $10)
       RETURNING *`,
      [templateId, data.version_no, data.language, data.title, data.content || null,
       data.document_id || null, data.effective_from || null, data.change_summary || null,
       meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async update(id: number, data: any): Promise<any | null> {
    const current = await this.findById(id);
    if (!current) return null;
    if (current.status === 'APPROVED') {
      throw new Error('Cannot modify an approved version. Create a new version instead.');
    }
    const hasAssignments = await this.query(
      `SELECT 1 FROM core.application_consents WHERE consent_version_id = $1 AND deleted_at IS NULL LIMIT 1`,
      [id]
    );
    if (hasAssignments.rows.length > 0) {
      throw new Error('Cannot modify a version that is already assigned to applications. Create a new version instead.');
    }
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE committee.consent_template_versions SET
        title = COALESCE($1, title),
        content = COALESCE($2, content),
        document_id = COALESCE($3, document_id),
        effective_from = COALESCE($4, effective_from),
        change_summary = COALESCE($5, change_summary),
        updated_at = $6, updated_by = $7
       WHERE id = $8 AND deleted_at IS NULL RETURNING *`,
      [data.title, data.content, data.document_id, data.effective_from,
       data.change_summary, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async approve(id: number): Promise<any | null> {
    const current = await this.findById(id);
    if (!current) return null;
    if (current.status !== 'DRAFT' && current.status !== 'UNDER_REVIEW') {
      throw new Error(`Cannot approve a version with status '${current.status}'. Only DRAFT or UNDER_REVIEW can be approved.`);
    }
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE committee.consent_template_versions SET
        status = 'APPROVED', effective_from = COALESCE(effective_from, CURRENT_DATE),
        updated_at = $1, updated_by = $2
       WHERE id = $3 AND deleted_at IS NULL RETURNING *`,
      [meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async retire(id: number): Promise<boolean> {
    const current = await this.findById(id);
    if (!current) return false;
    if (current.status === 'RETIRED') return false;
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE committee.consent_template_versions SET
        status = 'RETIRED', retired_at = CURRENT_DATE,
        is_active = false, updated_at = $1, updated_by = $2
       WHERE id = $3 AND deleted_at IS NULL`,
      [meta.updated_at, meta.updated_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async softDelete(id: number): Promise<boolean> {
    const current = await this.findById(id);
    if (!current) return false;
    if (current.status === 'APPROVED') {
      throw new Error('Cannot delete an approved version. Retire it instead.');
    }
    const hasAssignments = await this.query(
      `SELECT 1 FROM core.application_consents WHERE consent_version_id = $1 AND deleted_at IS NULL LIMIT 1`,
      [id]
    );
    if (hasAssignments.rows.length > 0) {
      throw new Error('Cannot delete a version assigned to applications. Retire it instead.');
    }
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE committee.consent_template_versions SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }
}
