/*
 * مستودع تقييمات الاعتماد: تقييم أداء اللجنة
 * وفق معايير الاعتماد المؤسسي.
 */
import { AuditableRepository } from './auditable.repository';

export class AccreditationAssessmentRepository extends AuditableRepository {
  async findByCycle(cycleId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT aa.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as assessor_name,
              COALESCE(
                (SELECT jsonb_agg(jsonb_build_object(
                  'id', aai.id,
                  'standard_version_id', aai.standard_version_id,
                  'code', ac.code,
                  'name_ar', ac.name_ar,
                  'is_met', aai.is_met,
                  'findings', aai.findings,
                  'score', aai.score
                ) ORDER BY ac.sort_order)
                FROM committee.accreditation_assessment_items aai
                JOIN committee.accreditation_standard_versions asv ON aai.standard_version_id = asv.id
                JOIN committee.accreditation_standards ac ON asv.standard_id = ac.id
                WHERE aai.assessment_id = aa.id),
                '[]'::jsonb
              ) as items
       FROM committee.accreditation_assessments aa
       LEFT JOIN security.users u ON aa.assessed_by = u.id
       WHERE aa.cycle_id = $1
       ORDER BY aa.assessed_at DESC`,
      [cycleId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT aa.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as assessor_name,
              COALESCE(
                (SELECT jsonb_agg(jsonb_build_object(
                  'id', aai.id,
                  'standard_version_id', aai.standard_version_id,
                  'code', ac.code,
                  'name_ar', ac.name_ar,
                  'is_met', aai.is_met,
                  'findings', aai.findings,
                  'score', aai.score
                ) ORDER BY ac.sort_order)
                FROM committee.accreditation_assessment_items aai
                JOIN committee.accreditation_standard_versions asv ON aai.standard_version_id = asv.id
                JOIN committee.accreditation_standards ac ON asv.standard_id = ac.id
                WHERE aai.assessment_id = aa.id),
                '[]'::jsonb
              ) as items
       FROM committee.accreditation_assessments aa
       LEFT JOIN security.users u ON aa.assessed_by = u.id
       WHERE aa.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: { cycle_id: number; assessed_by: number; overall_decision: string; overall_justification?: string; items?: any[] }): Promise<any> {
    return this.withTransaction(async (client) => {
      const assessment = await client.query(
        `INSERT INTO committee.accreditation_assessments (cycle_id, assessed_by, overall_decision, overall_justification, assessed_at)
         VALUES ($1, $2, $3, $4, $5) RETURNING *`,
        [data.cycle_id, data.assessed_by, data.overall_decision, data.overall_justification || null, new Date()]
      );
      if (data.items && data.items.length > 0) {
        for (let i = 0; i < data.items.length; i++) {
          const item = data.items[i];
          await client.query(
            `INSERT INTO committee.accreditation_assessment_items (assessment_id, standard_version_id, is_met, findings, score)
             VALUES ($1, $2, $3, $4, $5)`,
            [assessment.rows[0].id, item.standard_version_id, item.is_met || false, item.findings || null, item.score || null]
          );
        }
      }
      return assessment.rows[0];
    });
  }

  async updateItems(assessmentId: number, items: any[]): Promise<any | null> {
    const meta = this.updateMeta();
    return this.withTransaction(async (client) => {
      await client.query(`DELETE FROM committee.accreditation_assessment_items WHERE assessment_id = $1`, [assessmentId]);
      for (const item of items) {
        await client.query(
          `INSERT INTO committee.accreditation_assessment_items (assessment_id, standard_version_id, is_met, findings, score)
           VALUES ($1, $2, $3, $4, $5)`,
          [assessmentId, item.standard_version_id, item.is_met, item.findings || null, item.score || null]
        );
      }
      const updated = await client.query(
        `UPDATE committee.accreditation_assessments SET updated_at = $1 WHERE id = $2 RETURNING *`,
        [meta.updated_at, assessmentId]
      );
      return updated.rows[0] || null;
    });
  }

  async softDelete(id: number): Promise<boolean> {
    const result = await this.query(
      `DELETE FROM committee.accreditation_assessments WHERE id = $1`,
      [id]
    );
    return (result.rowCount ?? 0) > 0;
  }
}
