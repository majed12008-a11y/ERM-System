/*
 * مستودع التصويت: إدارة جلسات التصويت والقرارات.
 */
import { AuditableRepository } from './auditable.repository';

export class VotingRepository extends AuditableRepository {
  async findByMeeting(meetingId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT vs.*, a.application_number, p.title_ar as project_title
       FROM committee.voting_sessions vs
       LEFT JOIN core.applications a ON vs.application_id = a.id
       LEFT JOIN core.projects p ON a.project_id = p.id
       WHERE vs.meeting_id = $1 ORDER BY vs.created_at DESC`,
      [meetingId]
    );
    return result.rows;
  }

  async findSessionById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT vs.*, a.application_number, p.title_ar as project_title
       FROM committee.voting_sessions vs
       LEFT JOIN core.applications a ON vs.application_id = a.id
       LEFT JOIN core.projects p ON a.project_id = p.id
       WHERE vs.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async createSession(data: { application_id: number; meeting_id: number; voting_type: string }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.voting_sessions (application_id, meeting_id, voting_type, voting_start, status_code, created_by, created_at)
       VALUES ($1, $2, $3, now(), 'OPEN', $4, $5) RETURNING *`,
      [data.application_id, data.meeting_id, data.voting_type, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async getVotes(sessionId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT v.*, u.username as voter_name
       FROM committee.votes v
       LEFT JOIN security.users u ON v.voter_id = u.id
       WHERE v.voting_session_id = $1 ORDER BY v.vote_time`,
      [sessionId]
    );
    return result.rows;
  }

  async castVote(sessionId: number, voterId: number, voteValue: string, comments?: string): Promise<any> {
    const result = await this.query(
      `INSERT INTO committee.votes (voting_session_id, voter_id, vote_value, comments)
       VALUES ($1, $2, $3, $4) RETURNING *`,
      [sessionId, voterId, voteValue, comments || null]
    );
    return result.rows[0];
  }

  async closeSession(sessionId: number): Promise<any | null> {
    const result = await this.query(
      `UPDATE committee.voting_sessions SET status_code = 'CLOSED', voting_end = now(), updated_at = now() WHERE id = $1 RETURNING *`,
      [sessionId]
    );
    return result.rows[0] || null;
  }
}
