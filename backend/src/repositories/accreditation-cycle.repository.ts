/*
 * مستودع دورات الاعتماد: إدارة دورات الاعتماد المؤسسي
 * للجنة الأخلاقيات.
 */
import { AuditableRepository } from './auditable.repository';

export class AccreditationCycleRepository extends AuditableRepository {
  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT ac.*, c.committee_name_ar, i.name_ar as institution_name,
              asv.version_label, asv.effective_from,
              (SELECT COUNT(*) FROM committee.accreditation_assessments aa WHERE aa.cycle_id = ac.id) as assessment_count,
              (SELECT COUNT(*) FROM committee.accreditation_conditions acond WHERE acond.cycle_id = ac.id AND acond.status = 'OPEN') as open_conditions
       FROM committee.accreditation_cycles ac
       JOIN committee.committees c ON ac.committee_id = c.id
       JOIN security.institutions i ON c.institution_id = i.id
       JOIN committee.accreditation_standard_versions asv ON ac.standard_version_id = asv.id
       ORDER BY ac.created_at DESC`
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT ac.*, c.committee_name_ar, i.name_ar as institution_name,
              asv.version_label, asv.effective_from,
              (SELECT jsonb_agg(jsonb_build_object(
                'id', aa.id, 'overall_decision', aa.overall_decision, 'assessed_by', aa.assessed_by,
                'assessor_name', CONCAT(u.first_name_ar, ' ', u.last_name_ar),
                'assessed_at', aa.assessed_at
              )) FROM committee.accreditation_assessments aa
              LEFT JOIN security.users u ON aa.assessed_by = u.id WHERE aa.cycle_id = ac.id) as assessments,
              (SELECT jsonb_agg(jsonb_build_object(
                'id', acond.id, 'condition_text', acond.condition_text,
                'due_date', acond.due_date, 'status', acond.status,
                'severity', acond.severity, 'standard_version_id', acond.standard_version_id,
                'assessment_id', acond.assessment_id
              ) ORDER BY acond.created_at DESC) FROM committee.accreditation_conditions acond WHERE acond.cycle_id = ac.id) as conditions,
              (SELECT jsonb_agg(jsonb_build_object(
                'id', ad.id, 'decision', ad.decision, 'from_status', ad.from_status,
                'to_status', ad.to_status, 'decided_by', ad.decided_by,
                'decider_name', CONCAT(du.first_name_ar, ' ', du.last_name_ar),
                'decision_reason', ad.decision_reason, 'created_at', ad.created_at
              ) ORDER BY ad.created_at DESC) FROM committee.accreditation_decisions ad
              LEFT JOIN security.users du ON ad.decided_by = du.id WHERE ad.cycle_id = ac.id) as decisions
       FROM committee.accreditation_cycles ac
       JOIN committee.committees c ON ac.committee_id = c.id
       JOIN security.institutions i ON c.institution_id = i.id
       JOIN committee.accreditation_standard_versions asv ON ac.standard_version_id = asv.id
       WHERE ac.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByCommittee(committeeId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM committee.accreditation_cycles WHERE committee_id = $1 ORDER BY created_at DESC`,
      [committeeId]
    );
    return result.rows;
  }

  async create(data: { committee_id: number; standard_version_id: number; cycle_number?: number; status?: string }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.accreditation_cycles (committee_id, standard_version_id, cycle_number, status, created_by)
       VALUES ($1, $2, COALESCE($3, (SELECT COALESCE(MAX(cycle_number), 0) + 1 FROM committee.accreditation_cycles WHERE committee_id = $1)), $4, $5)
       RETURNING *`,
      [data.committee_id, data.standard_version_id, data.cycle_number || null, data.status || 'PENDING', meta.created_by]
    );
    return result.rows[0];
  }

  async updateStatus(id: number, fromStatus: string | null, toStatus: string, decision: string, decidedBy: number, reason?: string, notes?: string): Promise<any> {
    const updatedAt = new Date();
    return this.withTransaction(async (client) => {
      const cycle = await client.query(
        `UPDATE committee.accreditation_cycles SET status = $1, updated_at = $2 WHERE id = $3 RETURNING *`,
        [toStatus, updatedAt, id]
      );
      if (!cycle.rows[0]) throw Object.assign(new Error('Cycle not found'), { status: 404 });
      const decisionResult = await client.query(
        `INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, decision_reason, notes)
         VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
        [id, fromStatus, toStatus, decision, decidedBy, reason || null, notes || null]
      );
      return { cycle: cycle.rows[0], decision: decisionResult.rows[0] };
    });
  }

  async softDelete(id: number): Promise<boolean> {
    const result = await this.query(
      `UPDATE committee.accreditation_cycles SET deleted_at = NOW(), status = 'REVOKED' WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async getStandards(): Promise<any[]> {
    const result = await this.query(
      `SELECT asv.*, ac.code, ac.name_ar, ac.name_en, ac.category, ac.description_ar
       FROM committee.accreditation_standard_versions asv
       JOIN committee.accreditation_standards ac ON asv.standard_id = ac.id
       ORDER BY ac.sort_order, asv.version_label DESC`
    );
    return result.rows;
  }

  async getActiveStandards(): Promise<any[]> {
    const result = await this.query(
      `SELECT asv.*, ac.code, ac.name_ar, ac.name_en, ac.category, ac.description_ar
       FROM committee.accreditation_standard_versions asv
       JOIN committee.accreditation_standards ac ON asv.standard_id = ac.id
       WHERE asv.is_active = true
       ORDER BY ac.sort_order`
    );
    return result.rows;
  }

  async findActiveByCommittee(committeeId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM committee.accreditation_cycles
       WHERE committee_id = $1 AND status NOT IN ('EXPIRED','REVOKED') AND deleted_at IS NULL
       ORDER BY created_at DESC LIMIT 1`,
      [committeeId]
    );
    return result.rows[0] || null;
  }
}
