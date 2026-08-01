/*
 * مستودع تعريفات النماذج: استرجاع تعريفات النماذج النشطة
 * حسب الكود أو المعرّف أو الفئة (مع دعم الإصدارات).
 */
import { AuditableRepository } from './auditable.repository';

export class FormDefinitionRepository extends AuditableRepository {
  async findActiveByCode(formCode: string): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM forms.form_definitions
       WHERE form_code = $1 AND is_active = true AND deleted_at IS NULL
       ORDER BY version_no DESC LIMIT 1`,
      [formCode]
    );
    return result.rows[0] || null;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM forms.form_definitions WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findAllActive(): Promise<any[]> {
    const result = await this.query(
      `SELECT id, form_code, form_name_ar, form_name_en, category, workflow_stage,
              version_no, schema_version, renderer, is_active, created_at, updated_at
       FROM forms.form_definitions
       WHERE is_active = true AND deleted_at IS NULL
       ORDER BY category, form_code`
    );
    return result.rows;
  }

  async listCategories(): Promise<any[]> {
    const result = await this.query(
      `SELECT category, COUNT(*) AS form_count
       FROM forms.form_definitions
       WHERE is_active = true AND deleted_at IS NULL
       GROUP BY category ORDER BY category`
    );
    return result.rows;
  }

  async countInstances(formDefinitionId: number): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(*) FROM forms.form_instances WHERE form_definition_id = $1`,
      [formDefinitionId]
    );
    return parseInt(result.rows[0].count, 10);
  }
}
