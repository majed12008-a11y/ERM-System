/*
 * مستودع لوحة التحكم: إحصائيات النظام،
 * إدارة المستخدمين، إعدادات النظام.
 */
import { AuditableRepository } from './auditable.repository';

export class AdminRepository extends AuditableRepository {
  async getStats(): Promise<Record<string, any>> {
    const result = await this.query(
      `SELECT
         users.total AS users_total, users.active AS users_active,
         applications.total AS applications_total,
         projects.total AS projects_total,
         committees.total AS committees_total,
         reviews.total AS reviews_total,
         meetings.total AS meetings_total
       FROM (
         SELECT COUNT(*)::int AS total, COUNT(*) FILTER (WHERE status = 'ACTIVE')::int AS active FROM security.users
       ) users,
       LATERAL (SELECT COUNT(*)::int AS total FROM core.applications) applications,
       LATERAL (SELECT COUNT(*)::int AS total FROM core.projects) projects,
       LATERAL (SELECT COUNT(*)::int AS total FROM committee.committees) committees,
       LATERAL (SELECT COUNT(*)::int AS total FROM committee.review_assignments) reviews,
       LATERAL (SELECT COUNT(*)::int AS total FROM committee.committee_meetings) meetings`
    );
    const row = result.rows[0];
    return {
      users: { total: row.users_total, active: row.users_active },
      applications: { total: row.applications_total },
      projects: { total: row.projects_total },
      committees: { total: row.committees_total },
      reviews: { total: row.reviews_total },
      meetings: { total: row.meetings_total },
    };
  }

  async getAuditLog(params: {
    page: number; limit: number; action?: string; userId?: number;
  }): Promise<{ rows: any[]; total: number }> {
    const conditions: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (params.action) { conditions.push(`al.operation_type = $${idx++}`); values.push(params.action); }
    if (params.userId) { conditions.push(`al.user_id = $${idx++}`); values.push(params.userId); }

    const where = conditions.length ? `WHERE ${conditions.join(' AND ')}` : 'WHERE 1=1';

    const countResult = await this.query(`SELECT COUNT(*) FROM audit.audit_logs al ${where}`, values);
    const total = parseInt(countResult.rows[0].count);

    const offset = (params.page - 1) * params.limit;
    const result = await this.query(
      `SELECT al.id, al.operation_type AS action_type, al.entity_name AS entity_type,
              al.entity_id, al.event_timestamp AS created_at,
              al.user_id, u.username,
              al.source_ip, al.old_values, al.new_values
       FROM audit.audit_logs al
       LEFT JOIN security.users u ON al.user_id = u.id
       ${where}
       ORDER BY al.event_timestamp DESC LIMIT $${idx} OFFSET $${idx + 1}`,
      [...values, params.limit, offset]
    );

    return { rows: result.rows, total };
  }

  async getDistinctActions(): Promise<string[]> {
    const result = await this.query(
      `SELECT DISTINCT operation_type FROM audit.audit_logs ORDER BY operation_type`
    );
    return result.rows.map(r => r.operation_type);
  }

  async getOnlineUsers(): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(DISTINCT user_id)::int as count FROM audit.audit_logs
       WHERE event_timestamp >= now() - interval '15 minutes'`
    );
    return result.rows[0].count;
  }

  async getRecentActivity(): Promise<any[]> {
    const result = await this.query(
      `SELECT al.id, al.operation_type AS action_type, al.entity_name AS entity_type,
              al.entity_id, al.event_timestamp AS created_at,
              al.user_id, u.username
       FROM audit.audit_logs al
       LEFT JOIN security.users u ON al.user_id = u.id
       ORDER BY al.event_timestamp DESC LIMIT 20`
    );
    return result.rows;
  }
}
