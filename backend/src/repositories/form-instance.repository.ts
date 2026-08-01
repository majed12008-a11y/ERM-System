/*
 * مستودع مثيلات النماذج: إنشاء/تحديث/إرسال/اعتماد مثيل نموذج
 * مرتبط بكيان (طلب/اجتماع/موقع). يدعم الحفظ التدريجي (مسودة)
 * وحالة دورة الحياة: DRAFT → SUBMITTED → (RETURNED | APPROVED | VOID).
 */
import { AuditableRepository } from './auditable.repository';

export type FormInstanceStatus = 'DRAFT' | 'SUBMITTED' | 'RETURNED' | 'APPROVED' | 'VOID';

export class FormInstanceRepository extends AuditableRepository {
  async create(data: {
    form_definition_id: number;
    entity_type: string;
    entity_id: number;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO forms.form_instances
        (form_definition_id, entity_type, entity_id, status, created_by, created_at)
       VALUES ($1, $2, $3, 'DRAFT', $4, $5) RETURNING *`,
      [data.form_definition_id, data.entity_type, data.entity_id, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM forms.form_instances WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async getApplicationContext(applicationId: number): Promise<{
    committeeNameAr: string;
    committeeNameEn: string;
    institutionNameAr: string;
    institutionNameEn: string;
  } | null> {
    const result = await this.query(
      `SELECT com.committee_name_ar, com.committee_name_en, inst.name_ar, inst.name_en
       FROM core.applications a
       JOIN committee.committees com ON com.id = a.target_committee_id
       JOIN core.projects p ON p.id = a.project_id
       JOIN security.institutions inst ON inst.id = p.institution_id
       WHERE a.id = $1`,
      [applicationId]
    );
    if (!result.rows[0]) return null;
    return {
      committeeNameAr: result.rows[0].committee_name_ar,
      committeeNameEn: result.rows[0].committee_name_en,
      institutionNameAr: result.rows[0].name_ar,
      institutionNameEn: result.rows[0].name_en,
    };
  }

  async findLatestForDefinition(entityType: string, entityId: number, formDefinitionId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM forms.form_instances
       WHERE entity_type = $1 AND entity_id = $2 AND form_definition_id = $3 AND deleted_at IS NULL
       ORDER BY id DESC LIMIT 1`,
      [entityType, entityId, formDefinitionId]
    );
    return result.rows[0] || null;
  }

  async listByEntity(entityType: string, entityId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT fi.*, fd.form_code, fd.form_name_ar, fd.form_name_en, fd.category
       FROM forms.form_instances fi
       JOIN forms.form_definitions fd ON fd.id = fi.form_definition_id
       WHERE fi.entity_type = $1 AND fi.entity_id = $2 AND fi.deleted_at IS NULL
       ORDER BY fi.id DESC`,
      [entityType, entityId]
    );
    return result.rows;
  }

  async listAll(limit: number, offset: number): Promise<{ rows: any[]; total: number }> {
    const countResult = await this.query(
      `SELECT COUNT(*) FROM forms.form_instances WHERE deleted_at IS NULL`
    );
    const total = parseInt(countResult.rows[0].count, 10);
    const result = await this.query(
      `SELECT fi.*, fd.form_code, fd.form_name_ar, fd.form_name_en, fd.category
       FROM forms.form_instances fi
       JOIN forms.form_definitions fd ON fd.id = fi.form_definition_id
       WHERE fi.deleted_at IS NULL
       ORDER BY fi.id DESC
       LIMIT $1 OFFSET $2`,
      [limit, offset]
    );
    return { rows: result.rows, total };
  }

  async saveResponses(id: number, responses: any, status: FormInstanceStatus): Promise<any> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE forms.form_instances
       SET responses = $1, status = $2, updated_at = $3, updated_by = $4
       WHERE id = $5 RETURNING *`,
      [JSON.stringify(responses), status, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async submit(id: number, data: { total_score?: number | null; recommendation?: string | null }): Promise<any> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE forms.form_instances
       SET status = 'SUBMITTED', total_score = $1, recommendation = $2,
           submitted_by = $3, submitted_at = now(), updated_at = $4, updated_by = $5
       WHERE id = $6 AND status IN ('DRAFT','RETURNED') RETURNING *`,
      [data.total_score ?? null, data.recommendation ?? null, meta.updated_by, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async approve(id: number, approvedBy: number): Promise<any> {
    const result = await this.query(
      `UPDATE forms.form_instances
       SET status = 'APPROVED', approved_by = $1, approved_at = now(), updated_at = now(), updated_by = $1
       WHERE id = $2 AND status = 'SUBMITTED' RETURNING *`,
      [approvedBy, id]
    );
    return result.rows[0] || null;
  }

  async returnToDraft(id: number, returnedBy: number): Promise<any> {
    const result = await this.query(
      `UPDATE forms.form_instances
       SET status = 'RETURNED', updated_at = now(), updated_by = $1
       WHERE id = $2 AND status = 'SUBMITTED' RETURNING *`,
      [returnedBy, id]
    );
    return result.rows[0] || null;
  }

  async void(id: number, voidedBy: number): Promise<any> {
    const result = await this.query(
      `UPDATE forms.form_instances
       SET status = 'VOID', updated_at = now(), updated_by = $1
       WHERE id = $2 AND status NOT IN ('APPROVED','VOID') RETURNING *`,
      [voidedBy, id]
    );
    return result.rows[0] || null;
  }
}
