/*
 * مستودع أدلة الاعتماد: إدارة الأدلة والوثائق
 * المقدمة لدعم طلب الاعتماد.
 */
import { AuditableRepository } from './auditable.repository';

export class AccreditationEvidenceRepository extends AuditableRepository {
  async findByCycle(cycleId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ae.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as uploader_name,
              ac.code as standard_code, ac.name_ar as standard_name
       FROM committee.accreditation_evidence ae
       LEFT JOIN security.users u ON ae.uploaded_by = u.id
       LEFT JOIN committee.accreditation_standard_versions asv ON ae.standard_version_id = asv.id
       LEFT JOIN committee.accreditation_standards ac ON asv.standard_id = ac.id
       WHERE ae.cycle_id = $1
        ORDER BY ae.uploaded_at DESC`,
      [cycleId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT ae.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as uploader_name
       FROM committee.accreditation_evidence ae
       LEFT JOIN security.users u ON ae.uploaded_by = u.id
       WHERE ae.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    cycle_id: number; standard_version_id?: number; document_id?: number;
    uploaded_by: number; notes?: string;
  }): Promise<any> {
    const result = await this.query(
      `INSERT INTO committee.accreditation_evidence (cycle_id, standard_version_id, document_id, uploaded_by, notes, status)
       VALUES ($1, $2, $3, $4, $5, 'PENDING') RETURNING *`,
      [data.cycle_id, data.standard_version_id || null, data.document_id || null,
       data.uploaded_by, data.notes || null]
    );
    return result.rows[0];
  }

  async updateStatus(id: number, status: string, _reviewedBy?: number, reviewNotes?: string): Promise<any | null> {
    const result = await this.query(
      `UPDATE committee.accreditation_evidence SET status = $1, notes = COALESCE($2, notes)
       WHERE id = $3 RETURNING *`,
      [status, reviewNotes || null, id]
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const result = await this.query(`DELETE FROM committee.accreditation_evidence WHERE id = $1`, [id]);
    return (result.rowCount ?? 0) > 0;
  }
}
