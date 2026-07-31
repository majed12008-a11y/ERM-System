/*
 * مستودع اللجان: إدارة بيانات اللجان والأعضاء
 * والاجتماعات والمراجعات والقرارات.
 * يعتبر أكبر مستودع في النظام بسبب تعقيد علاقات اللجان.
 */
import { AuditableRepository } from './auditable.repository';

export interface CommitteeRow {
  id: number;
  committee_code: string;
  committee_name_ar: string;
  committee_name_en: string | null;
  institution_id: number;
  committee_type_id: number;
  is_active: boolean;
}

export class CommitteeRepository extends AuditableRepository {
  async getTypes(): Promise<any[]> {
    const result = await this.query('SELECT * FROM committee.committee_types ORDER BY type_name');
    return result.rows;
  }

  async getRoles(): Promise<any[]> {
    const result = await this.query('SELECT * FROM committee.committee_roles ORDER BY role_name');
    return result.rows;
  }

  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT c.*, i.name_ar as institution_name, ct.type_name as committee_type_name,
              (SELECT COUNT(*) FROM committee.committee_members cm WHERE cm.committee_id = c.id AND cm.is_active = TRUE) as member_count
       FROM committee.committees c
       LEFT JOIN security.institutions i ON c.institution_id = i.id
       LEFT JOIN committee.committee_types ct ON c.committee_type_id = ct.id
       WHERE c.is_active = TRUE
       ORDER BY c.committee_name_ar`
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT c.*, i.name_ar as institution_name, ct.type_name as committee_type_name,
              (SELECT json_agg(json_build_object('user_id', cm.user_id, 'username', u.username, 'role', cr.role_name))
               FROM committee.committee_members cm
               JOIN security.users u ON cm.user_id = u.id
               LEFT JOIN committee.committee_member_roles cmr ON cmr.member_id = cm.id
               LEFT JOIN committee.committee_roles cr ON cmr.role_id = cr.id
               WHERE cm.committee_id = c.id AND cm.is_active = TRUE) as members
       FROM committee.committees c
       LEFT JOIN security.institutions i ON c.institution_id = i.id
       LEFT JOIN committee.committee_types ct ON c.committee_type_id = ct.id
       WHERE c.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    institution_id: number;
    committee_code: string;
    committee_name_ar: string;
    committee_name_en?: string;
    committee_type_id: number;
    is_active?: boolean;
  }): Promise<CommitteeRow> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.committees
        (institution_id, committee_code, committee_name_ar, committee_name_en, committee_type_id, is_active, created_by, created_at)
       VALUES ($1::int, $2, $3, $4, $5::int, $6, $7, $8)
       RETURNING *`,
      [data.institution_id, data.committee_code, data.committee_name_ar, data.committee_name_en || null, data.committee_type_id, data.is_active ?? true, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async update(id: number, data: Record<string, any>): Promise<CommitteeRow | null> {
    const meta = this.updateMeta();
    const allowed = ['committee_name_ar', 'committee_name_en', 'institution_id', 'committee_type_id', 'is_active'];
    const updates = Object.keys(data).filter(k => allowed.includes(k) && data[k] !== undefined);
    if (updates.length === 0) return null;

    const setClauses = updates.map((k, i) => {
      if (k === 'institution_id' || k === 'committee_type_id') return `${k} = COALESCE($${i + 1}::int, ${k})`;
      return `${k} = COALESCE($${i + 1}, ${k})`;
    });
    setClauses.push(`updated_at = $${updates.length + 1}`);
    setClauses.push(`updated_by = $${updates.length + 2}`);
    const vals = updates.map(k => data[k]);
    vals.push(meta.updated_at, meta.updated_by);
    vals.push(id);

    const result = await this.query(
      `UPDATE committee.committees SET ${setClauses.join(', ')} WHERE id = $${vals.length} RETURNING *`,
      vals
    );
    return result.rows[0] || null;
  }

  async deactivate(id: number): Promise<boolean> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE committee.committees SET is_active = FALSE, updated_at = $1, updated_by = $2 WHERE id = $3 AND is_active = TRUE`,
      [meta.updated_at, meta.updated_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE committee.committees SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }
}

export class MemberRepository extends AuditableRepository {
  async findByCommittee(committeeId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT cm.*, u.username, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as display_name,
              cr.role_name, cm.role_id
       FROM committee.committee_members cm
       JOIN security.users u ON cm.user_id = u.id
       LEFT JOIN committee.committee_roles cr ON cm.role_id = cr.id
       WHERE cm.committee_id = $1 AND cm.is_active = true
       ORDER BY u.username`,
      [committeeId]
    );
    return result.rows;
  }

  async add(committeeId: number, data: { user_id: number; role_id?: number }): Promise<any> {
    const result = await this.query(
      `INSERT INTO committee.committee_members (committee_id, user_id, role_id, membership_start_date, is_active)
       VALUES ($1, $2, $3, CURRENT_DATE, TRUE) RETURNING *`,
      [committeeId, data.user_id, data.role_id ?? null]
    );
    return result.rows[0];
  }

  async updateRole(memberId: number, role_id: number): Promise<any> {
    const result = await this.query(
      `UPDATE committee.committee_members SET role_id = $1 WHERE id = $2 AND is_active = true RETURNING *`,
      [role_id, memberId]
    );
    return result.rows[0] || null;
  }

  async remove(memberId: number): Promise<boolean> {
    const result = await this.query(
      `UPDATE committee.committee_members SET is_active = FALSE WHERE id = $1 AND is_active = TRUE`,
      [memberId]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async getTerms(memberId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT mt.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as member_name
       FROM committee.member_terms mt
       JOIN committee.committee_members cm ON mt.member_id = cm.id
       JOIN security.users u ON cm.user_id = u.id
       WHERE mt.member_id = $1 ORDER BY mt.start_date DESC`,
      [memberId]
    );
    return result.rows;
  }

  async createTerm(memberId: number, data: any): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.member_terms (member_id, start_date, end_date, appointment_decision_no, termination_decision_no, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [memberId, data.start_date, data.end_date, data.appointment_decision_no, data.termination_decision_no, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async getQualifications(memberId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT mq.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as member_name
       FROM committee.member_qualifications mq
       JOIN committee.committee_members cm ON mq.member_id = cm.id
       JOIN security.users u ON cm.user_id = u.id
       WHERE mq.member_id = $1 ORDER BY mq.created_at DESC`,
      [memberId]
    );
    return result.rows;
  }

  async createQualification(memberId: number, data: any, verifiedBy: number | null): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.member_qualifications
        (member_id, specialization, academic_degree, institution_name, experience_years, is_verified, verified_by, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *`,
      [memberId, data.specialization, data.academic_degree, data.institution_name, data.experience_years, data.is_verified || false, verifiedBy, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async getConflicts(memberId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT mc.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as member_name
       FROM committee.member_conflicts mc
       JOIN committee.committee_members cm ON mc.member_id = cm.id
       JOIN security.users u ON cm.user_id = u.id
       WHERE mc.member_id = $1 ORDER BY mc.declared_at DESC`,
      [memberId]
    );
    return result.rows;
  }

  async createConflict(memberId: number, data: any, userId: number): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.member_conflicts
        (member_id, entity_type, entity_id, conflict_type, description, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [memberId, data.entity_type, data.entity_id, data.conflict_type, data.description, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }
}

export class MeetingRepository extends AuditableRepository {
  async calculateQuorum(meetingId: number): Promise<any> {
    const result = await this.query('SELECT system.fn_calculate_quorum($1)', [meetingId]);
    return result.rows[0];
  }

  async findByCommittee(committeeId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM committee.committee_meetings
       WHERE committee_id = $1 ORDER BY meeting_date DESC`,
      [committeeId]
    );
    return result.rows;
  }

  async findAll(): Promise<any[]> {
    const result = await this.query(
      `SELECT cm.*, c.committee_name_ar as committee_name
       FROM committee.committee_meetings cm
       LEFT JOIN committee.committees c ON cm.committee_id = c.id
       ORDER BY cm.meeting_date DESC`
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT cm.*, c.committee_name_ar as committee_name, ct.type_name as committee_type
       FROM committee.committee_meetings cm
       LEFT JOIN committee.committees c ON cm.committee_id = c.id
       LEFT JOIN committee.committee_types ct ON c.committee_type_id = ct.id
       WHERE cm.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: { committee_id: number; meeting_date: string; location?: string }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.committee_meetings (committee_id, meeting_number, meeting_date, location, created_by, created_at)
       VALUES ($1::bigint, 'MTG-' || $1::text || '-' || to_char(now(), 'YYYYMMDD'), $2::timestamptz, $3, $4, $5)
       RETURNING *`,
      [data.committee_id, data.meeting_date, data.location || null, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async update(id: number, data: Record<string, any>): Promise<any | null> {
    const meta = this.updateMeta();
    const allowed = ['meeting_date', 'location', 'meeting_status', 'chairperson_id'];
    const updates = Object.keys(data).filter(k => allowed.includes(k));
    if (updates.length === 0) return null;

    const vals: any[] = [];
    const sets = updates.map(k => { vals.push(data[k]); return `${k}=$${vals.length}`; });
    const result = await this.query(
      `UPDATE committee.committee_meetings SET ${sets.join(', ')}, updated_at=$${vals.length + 1}, updated_by=$${vals.length + 2} WHERE id=$${vals.length + 3} RETURNING *`,
      [...vals, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async getAgenda(meetingId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ma.*, json_agg(json_build_object('id',ai.id,'application_id',ai.application_id,'title',ai.title,'item_order',ai.item_order,'discussion_notes',ai.discussion_notes,'app_number',a.application_number) ORDER BY ai.item_order) FILTER (WHERE ai.id IS NOT NULL) as items
       FROM committee.meeting_agendas ma
       LEFT JOIN committee.agenda_items ai ON ai.agenda_id = ma.id
       LEFT JOIN core.applications a ON ai.application_id = a.id
       WHERE ma.meeting_id = $1
       GROUP BY ma.id ORDER BY ma.created_at`,
      [meetingId]
    );
    return result.rows;
  }

  async createAgenda(meetingId: number, data: { title: string; description?: string }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.meeting_agendas (meeting_id, title, description, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [meetingId, data.title, data.description || null, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async addAgendaItem(agendaId: number, data: { application_id: number; title: string }): Promise<any> {
    const maxResult = await this.query(
      `SELECT COALESCE(MAX(item_order),0)+1 as nxt FROM committee.agenda_items WHERE agenda_id=$1`,
      [agendaId]
    );
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.agenda_items (agenda_id, application_id, item_order, title, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [agendaId, data.application_id, maxResult.rows[0].nxt, data.title, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async getAttendance(meetingId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT al.*, u.username
       FROM committee.attendance_logs al
       LEFT JOIN security.users u ON al.user_id = u.id
       WHERE al.meeting_id = $1 ORDER BY al.check_in_time NULLS LAST`,
      [meetingId]
    );
    return result.rows;
  }

  async addAttendance(meetingId: number, data: { user_id: number; attendance_status: string; remarks?: string }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.attendance_logs (meeting_id, user_id, attendance_status, remarks, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [meetingId, data.user_id, data.attendance_status, data.remarks || null, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async getMinutes(meetingId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT mm.*, u.username as approved_by_username, cu.username as created_by_username,
              (SELECT json_agg(json_build_object('id', ds.id, 'signer_id', ds.signer_id, 'signer_name', su.username, 'signed_at', ds.signed_at, 'signature_type', ds.signature_type))
               FROM documents.documents d
               JOIN documents.document_signatures ds ON ds.document_id = d.id
               JOIN security.users su ON ds.signer_id = su.id
               WHERE d.entity_type = 'MeetingMinutes' AND d.entity_id = mm.id
              ) as signatures
       FROM committee.meeting_minutes mm
       LEFT JOIN security.users u ON mm.approved_by = u.id
       LEFT JOIN security.users cu ON mm.created_by = cu.id
       WHERE mm.meeting_id = $1 ORDER BY mm.created_at DESC`,
      [meetingId]
    );
    return result.rows;
  }

  async createMinutes(meetingId: number, minutesText: string, createdBy: number): Promise<any> {
    const result = await this.query(
      `INSERT INTO committee.meeting_minutes (meeting_id, minutes_text, created_by)
       VALUES ($1, $2, $3) RETURNING *`,
      [meetingId, minutesText, createdBy]
    );
    return result.rows[0];
  }

  async approveMinutes(minutesId: number, meetingId: number, approvedBy: number): Promise<any | null> {
    const result = await this.query(
      `UPDATE committee.meeting_minutes SET approved_by = $1, approved_at = now() WHERE id = $2 AND meeting_id = $3 RETURNING *`,
      [approvedBy, minutesId, meetingId]
    );
    return result.rows[0] || null;
  }

  async getCommitteeMembers(committeeId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT cm.id, cm.user_id, cm.role_id, cm.is_active, u.username, cr.role_name
       FROM committee.committee_members cm
       JOIN security.users u ON cm.user_id = u.id
       LEFT JOIN committee.committee_roles cr ON cm.role_id = cr.id
       WHERE cm.committee_id = $1 AND cm.is_active = true
       ORDER BY u.username`,
      [committeeId]
    );
    return result.rows;
  }
}
