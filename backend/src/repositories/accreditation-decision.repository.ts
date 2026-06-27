/*
 * مستودع قرارات الاعتماد: إدارة قرارات منح
 * الاعتماد أو رفضه أو تعليقه.
 */
import { AuditableRepository } from './auditable.repository';

export class AccreditationDecisionRepository extends AuditableRepository {
  async findByCycle(cycleId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ad.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as decider_name
       FROM committee.accreditation_decisions ad
       LEFT JOIN security.users u ON ad.decided_by = u.id
       WHERE ad.cycle_id = $1
       ORDER BY ad.created_at DESC`,
      [cycleId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT ad.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as decider_name
       FROM committee.accreditation_decisions ad
       LEFT JOIN security.users u ON ad.decided_by = u.id
       WHERE ad.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    cycle_id: number; from_status?: string; to_status: string;
    decision: string; decided_by: number; decision_reason?: string; notes?: string;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO committee.accreditation_decisions (cycle_id, from_status, to_status, decision, decided_by, decision_reason, notes)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [data.cycle_id, data.from_status || null, data.to_status, data.decision, data.decided_by,
       data.decision_reason || null, data.notes || null]
    );
    return result.rows[0];
  }

  async getLatestByCycle(cycleId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM committee.accreditation_decisions WHERE cycle_id = $1 ORDER BY created_at DESC LIMIT 1`,
      [cycleId]
    );
    return result.rows[0] || null;
  }
}
