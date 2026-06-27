/*
 * مستودع تقييم المخاطر الأخلاقية: تقييم مخاطر
 * الأبحاث، التصنيفات، مستويات المخاطر.
 */
import { AuditableRepository } from './auditable.repository';

export class EthicsRiskRepository extends AuditableRepository {
  async getAssessment(applicationId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT era.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as assessor_name,
        COALESCE(
          (SELECT jsonb_agg(jsonb_build_object(
            'id', eri.id,
            'risk_category_id', eri.risk_category_id,
            'category_code', rc.category_code,
            'category_name', rc.category_name,
            'risk_description', eri.risk_description,
            'probability', eri.probability,
            'severity', eri.severity,
            'risk_score', eri.risk_score,
            'mitigation_plan', eri.mitigation_plan,
            'residual_probability', eri.residual_probability,
            'residual_severity', eri.residual_severity,
            'is_acceptable', eri.is_acceptable,
            'display_order', eri.display_order
          ) ORDER BY eri.display_order),
          '[]'::jsonb
        ) as items
       FROM committee.ethics_risk_assessments era
       LEFT JOIN security.users u ON era.assessed_by = u.id
       LEFT JOIN committee.ethics_risk_items eri ON eri.assessment_id = era.id AND eri.deleted_at IS NULL
       LEFT JOIN safety.risk_categories rc ON eri.risk_category_id = rc.id
       WHERE era.application_id = $1 AND era.deleted_at IS NULL AND era.is_active = true
       GROUP BY era.id, u.first_name_ar, u.last_name_ar
       ORDER BY era.assessment_version DESC LIMIT 1`,
      [applicationId]
    );
    return result.rows[0] || null;
  }

  async getAssessmentById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT era.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as assessor_name
       FROM committee.ethics_risk_assessments era
       LEFT JOIN security.users u ON era.assessed_by = u.id
       WHERE era.id = $1 AND era.deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async getAssessmentsByReviewer(reviewerId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT era.*, a.application_number, p.title_ar as project_title
       FROM committee.ethics_risk_assessments era
       JOIN core.applications a ON era.application_id = a.id
       JOIN core.projects p ON a.project_id = p.id
       WHERE era.assessed_by = $1 AND era.deleted_at IS NULL
       ORDER BY era.assessment_date DESC`,
      [reviewerId]
    );
    return result.rows;
  }

  async createAssessment(data: any, userId: number): Promise<any> {
    const meta = this.createMeta();
    const { application_id, ethics_review_id, scientific_review_id, overall_risk_level, recommendation, summary, items } = data;

    return this.withTransaction(async (client) => {
      const result = await client.query(
        `INSERT INTO committee.ethics_risk_assessments
          (application_id, ethics_review_id, scientific_review_id, overall_risk_level, overall_risk_score, recommendation, assessed_by, assessment_date, summary, created_by, created_at)
         VALUES ($1, $2, $3, $4,
           (SELECT COALESCE(MAX(probability * severity), 0) FROM jsonb_to_recordset($7::jsonb) AS x(probability int, severity int)),
           $5, $6, $8, $9, $10, $11)
         RETURNING *`,
        [application_id, ethics_review_id || null, scientific_review_id || null,
         overall_risk_level, recommendation || null, userId,
         JSON.stringify(items || []), new Date(), summary || null,
         meta.created_by, meta.created_at]
      );
      const assessment = result.rows[0];

      if (items && items.length > 0) {
        for (let i = 0; i < items.length; i++) {
          const item = items[i];
          await client.query(
            `INSERT INTO committee.ethics_risk_items
              (assessment_id, risk_category_id, risk_description, probability, severity,
               mitigation_plan, residual_probability, residual_severity, is_acceptable, display_order,
               created_at)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
            [assessment.id, item.risk_category_id, item.risk_description, item.probability, item.severity,
             item.mitigation_plan || null, item.residual_probability || null, item.residual_severity || null,
             item.is_acceptable || false, i + 1, meta.created_at]
          );
        }
      }

      return assessment;
    });
  }

  async updateAssessment(id: number, data: any): Promise<any | null> {
    const meta = this.updateMeta();
    const { overall_risk_level, recommendation, summary } = data;

    const result = await this.query(
      `UPDATE committee.ethics_risk_assessments SET
        overall_risk_level = COALESCE($1, overall_risk_level),
        recommendation = COALESCE($2, recommendation),
        summary = COALESCE($3, summary),
        updated_at = $4, updated_by = $5
       WHERE id = $6 AND deleted_at IS NULL RETURNING *`,
      [overall_risk_level, recommendation, summary, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async addRiskItem(assessmentId: number, data: any): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.ethics_risk_items
        (assessment_id, risk_category_id, risk_description, probability, severity,
         mitigation_plan, residual_probability, residual_severity, is_acceptable, display_order,
         created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9,
         (SELECT COALESCE(MAX(display_order), 0) + 1 FROM committee.ethics_risk_items WHERE assessment_id = $1 AND deleted_at IS NULL),
         $10, $11)
       RETURNING *`,
      [assessmentId, data.risk_category_id, data.risk_description, data.probability, data.severity,
       data.mitigation_plan || null, data.residual_probability || null, data.residual_severity || null,
       data.is_acceptable || false, meta.created_by, meta.created_at]
    );
    // Recalculate overall_risk_score after adding item
    const updateMeta = this.updateMeta();
    await this.query(
      `UPDATE committee.ethics_risk_assessments SET
        overall_risk_score = (SELECT COALESCE(MAX(risk_score), 0) FROM committee.ethics_risk_items WHERE assessment_id = $1 AND deleted_at IS NULL),
        updated_at = $2, updated_by = $3
       WHERE id = $1`,
      [assessmentId, updateMeta.updated_at, updateMeta.updated_by]
    );
    return result.rows[0];
  }

  async updateRiskItem(id: number, data: any): Promise<any | null> {
    const meta = this.updateMeta();
    const item = await this.query('SELECT assessment_id FROM committee.ethics_risk_items WHERE id = $1', [id]);
    const assessmentId = item.rows[0]?.assessment_id;
    if (!assessmentId) return null;
    const result = await this.query(
      `UPDATE committee.ethics_risk_items SET
        risk_category_id = COALESCE($1, risk_category_id),
        risk_description = COALESCE($2, risk_description),
        probability = COALESCE($3, probability),
        severity = COALESCE($4, severity),
        mitigation_plan = COALESCE($5, mitigation_plan),
        residual_probability = $6,
        residual_severity = $7,
        is_acceptable = COALESCE($8, is_acceptable),
        updated_at = $9, updated_by = $10
       WHERE id = $11 AND deleted_at IS NULL RETURNING *`,
      [data.risk_category_id, data.risk_description, data.probability, data.severity,
       data.mitigation_plan, data.residual_probability ?? null, data.residual_severity ?? null,
       data.is_acceptable, meta.updated_at, meta.updated_by, id]
    );
    if (result.rows[0]) {
      // Recalculate overall_risk_score after item change (risk_score is GENERATED, but overall needs recompute)
      await this.query(
        `UPDATE committee.ethics_risk_assessments SET
          overall_risk_score = (SELECT COALESCE(MAX(risk_score), 0) FROM committee.ethics_risk_items WHERE assessment_id = $1 AND deleted_at IS NULL),
          updated_at = $2, updated_by = $3
         WHERE id = $1`,
        [assessmentId, meta.updated_at, meta.updated_by]
      );
    }
    return result.rows[0] || null;
  }

  async deleteRiskItem(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const item = await this.query('SELECT assessment_id FROM committee.ethics_risk_items WHERE id = $1', [id]);
    const assessmentId = item.rows[0]?.assessment_id;
    if (!assessmentId) return false;
    const result = await this.query(
      `UPDATE committee.ethics_risk_items SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    if ((result.rowCount ?? 0) > 0) {
      const updateMeta = this.updateMeta();
      await this.query(
        `UPDATE committee.ethics_risk_assessments SET
          overall_risk_score = (SELECT COALESCE(MAX(risk_score), 0) FROM committee.ethics_risk_items WHERE assessment_id = $1 AND deleted_at IS NULL),
          updated_at = $2, updated_by = $3
         WHERE id = $1`,
        [assessmentId, updateMeta.updated_at, updateMeta.updated_by]
      );
    }
    return (result.rowCount ?? 0) > 0;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE committee.ethics_risk_assessments SET deleted_at = $1, deleted_by = $2, is_active = false WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async getRiskCategories(): Promise<any[]> {
    const result = await this.query(
      'SELECT id, category_code, category_name, description FROM safety.risk_categories WHERE is_active = true ORDER BY category_code'
    );
    return result.rows;
  }
}
