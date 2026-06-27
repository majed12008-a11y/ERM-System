/*
 * مستودع شروط الاعتماد: إدارة الشروط المطلوبة
 * لتحقيق الاعتماد المؤسسي.
 */
import { AuditableRepository } from './auditable.repository';

export class AccreditationConditionRepository extends AuditableRepository {
  async findByCycle(cycleId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT acond.*,
              CONCAT(u.first_name_ar, ' ', u.last_name_ar) as resolved_by_name,
              ac.code as standard_code, ac.name_ar as standard_name,
              aa.overall_decision as assessment_decision
       FROM committee.accreditation_conditions acond
       LEFT JOIN security.users u ON acond.resolved_by = u.id
       LEFT JOIN committee.accreditation_standard_versions asv ON acond.standard_version_id = asv.id
       LEFT JOIN committee.accreditation_standards ac ON asv.standard_id = ac.id
       LEFT JOIN committee.accreditation_assessments aa ON acond.assessment_id = aa.id
       WHERE acond.cycle_id = $1
       ORDER BY acond.created_at DESC`,
      [cycleId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT acond.*,
              CONCAT(u.first_name_ar, ' ', u.last_name_ar) as resolved_by_name,
              ac.code as standard_code, ac.name_ar as standard_name
       FROM committee.accreditation_conditions acond
       LEFT JOIN security.users u ON acond.resolved_by = u.id
       LEFT JOIN committee.accreditation_standard_versions asv ON acond.standard_version_id = asv.id
       LEFT JOIN committee.accreditation_standards ac ON asv.standard_id = ac.id
       WHERE acond.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    cycle_id: number; condition_text: string; due_date: string;
    severity?: string; assessment_id?: number; assessment_item_id?: number; standard_version_id?: number;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO committee.accreditation_conditions
       (cycle_id, condition_text, due_date, severity, assessment_id, assessment_item_id, standard_version_id, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, NOW()) RETURNING *`,
      [data.cycle_id, data.condition_text, data.due_date,
       data.severity || 'MAJOR', data.assessment_id || null,
       data.assessment_item_id || null, data.standard_version_id || null]
    );
    return result.rows[0];
  }

  async updateStatus(id: number, status: string, resolvedBy?: number): Promise<any | null> {
    if (status === 'MET' || status === 'WAIVED') {
      const result = await this.query(
        `UPDATE committee.accreditation_conditions SET status = $1, resolved_by = $2, resolved_at = NOW()
         WHERE id = $3 RETURNING *`,
        [status, resolvedBy || null, id]
      );
      return result.rows[0] || null;
    }
    const result = await this.query(
      `UPDATE committee.accreditation_conditions SET status = $1 WHERE id = $2 RETURNING *`,
      [status, id]
    );
    return result.rows[0] || null;
  }
}
