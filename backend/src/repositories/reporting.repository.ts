/*
 * مستودع التقارير: إحصائيات لوحة التحكم،
 * تقارير الطلبات والمشاريع واللجان.
 */
import { AuditableRepository } from './auditable.repository';

export class ReportingRepository extends AuditableRepository {
  async getDashboardStats(userId: number): Promise<Record<string, any>> {
    const result = await this.query(
      `SELECT
         applications.total AS applications_total,
         applications.submitted AS applications_submitted,
         applications.under_review AS applications_under_review,
         applications.approved AS applications_approved,
         applications.rejected AS applications_rejected,
         projects.total AS projects_total,
         upcoming.total AS upcoming_meetings_total,
         pending.pending AS pending_reviews_count
       FROM (
         SELECT COUNT(*)::int AS total,
                COUNT(*) FILTER (WHERE current_status = 'SUBMITTED')::int AS submitted,
                COUNT(*) FILTER (WHERE current_status = 'UNDER_REVIEW')::int AS under_review,
                COUNT(*) FILTER (WHERE current_status = 'APPROVED')::int AS approved,
                COUNT(*) FILTER (WHERE current_status = 'REJECTED')::int AS rejected
         FROM core.applications
       ) applications,
       LATERAL (SELECT COUNT(*)::int AS total FROM core.projects) projects,
       LATERAL (SELECT COUNT(*)::int AS total FROM committee.committee_meetings WHERE meeting_date >= CURRENT_DATE) upcoming,
       LATERAL (
         SELECT COUNT(*)::int AS pending
         FROM core.applications a
         WHERE a.current_status IN ('SUBMITTED', 'UNDER_REVIEW')
           AND EXISTS (
             SELECT 1 FROM committee.review_assignments ra
             WHERE ra.application_id = a.id AND ra.reviewer_id = $1 AND ra.status_code = 'PENDING'
           )
       ) pending`,
      [userId]
    );
    const row = result.rows[0];
    return {
      applications: {
        total: row.applications_total, submitted: row.applications_submitted,
        under_review: row.applications_under_review, approved: row.applications_approved,
        rejected: row.applications_rejected,
      },
      projects: { total: row.projects_total },
      upcomingMeetings: { total: row.upcoming_meetings_total },
      pendingReviews: { pending: row.pending_reviews_count },
    };
  }

  async getApplications(params: {
    status?: string; from?: string; to?: string; search?: string;
    page: number; limit: number;
  }): Promise<{ rows: any[]; total: number }> {
    const conditions: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (params.status) { conditions.push(`a.current_status = $${idx++}`); values.push(params.status); }
    if (params.from) { conditions.push(`a.created_at >= $${idx++}`); values.push(params.from); }
    if (params.to) { conditions.push(`a.created_at <= $${idx++}`); values.push(params.to); }
    if (params.search) {
      conditions.push(`(a.application_number ILIKE $${idx} OR p.title_ar ILIKE $${idx} OR p.title_en ILIKE $${idx})`);
      values.push(`%${params.search}%`);
      idx++;
    }

    const where = conditions.length > 0 ? 'WHERE ' + conditions.join(' AND ') : '';

    const countResult = await this.query(
      `SELECT COUNT(*) FROM core.applications a
       LEFT JOIN core.projects p ON a.project_id = p.id
       ${where}`,
      values
    );
    const total = parseInt(countResult.rows[0].count);

    const offset = (params.page - 1) * params.limit;
    const result = await this.query(
      `SELECT a.id, a.application_number, a.current_status, a.application_type, a.created_at, a.updated_at,
              p.title_ar as project_title, p.title_en as project_title_en, c.committee_name_ar as committee_name
       FROM core.applications a
        LEFT JOIN core.projects p ON a.project_id = p.id
        LEFT JOIN committee.committees c ON a.target_committee_id = c.id
        ${where}
        ORDER BY a.created_at DESC
        LIMIT $${idx} OFFSET $${idx + 1}`,
      [...values, params.limit, offset]
    );

    return { rows: result.rows, total };
  }

  async getCommittees(): Promise<any[]> {
    const result = await this.query(
      `SELECT c.*,
              (SELECT COUNT(*)::int FROM committee.review_assignments ra WHERE ra.application_id IN (SELECT id FROM core.applications WHERE target_committee_id = c.id)) as total_reviews,
              (SELECT COUNT(*)::int FROM committee.committee_meetings cm WHERE cm.committee_id = c.id) as total_meetings
       FROM committee.committees c ORDER BY c.committee_name_ar`
    );
    return result.rows;
  }

  async getStatusSummary(): Promise<any[]> {
    const result = await this.query(
      `SELECT current_status, COUNT(*)::int as count
       FROM core.applications GROUP BY current_status ORDER BY current_status`
    );
    return result.rows;
  }

  async getApplicationsTrend(): Promise<any[]> {
    const result = await this.query(
      `SELECT to_char(created_at, 'YYYY-MM') as month, COUNT(*)::int as count
       FROM core.applications
       WHERE created_at >= now() - interval '12 months'
       GROUP BY month ORDER BY month`
    );
    return result.rows;
  }

  async getExportData(): Promise<any[]> {
    const result = await this.query(
      `SELECT a.application_number, a.current_status, a.application_type, a.created_at,
              p.title_ar as project_title, c.committee_name_ar as committee_name, u.username as submitted_by
       FROM core.applications a
       LEFT JOIN core.projects p ON a.project_id = p.id
       LEFT JOIN committee.committees c ON a.target_committee_id = c.id
       LEFT JOIN security.users u ON a.submitted_by = u.id
       ORDER BY a.created_at DESC`
    );
    return result.rows;
  }
}
