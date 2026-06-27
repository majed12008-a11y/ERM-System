/*
 * مستودع المراقبة: سجلات التدقيق (Audit Logs)،
 * حالة النظام، وإحصائيات الأداء.
 */
import { AuditableRepository } from './auditable.repository';

export class MonitoringRepository extends AuditableRepository {
  async getAuditLogs(): Promise<any[]> {
    const result = await this.query(
      `SELECT al.id, al.operation_type AS action_type, al.entity_name AS entity_type,
              al.entity_id, al.event_timestamp AS created_at,
              al.user_id, u.username,
              al.source_ip, al.old_values, al.new_values
       FROM audit.audit_logs al
       LEFT JOIN security.users u ON al.user_id = u.id
       ORDER BY al.event_timestamp DESC
       LIMIT 100`
    );
    return result.rows;
  }

  async getSystemConfig(): Promise<any[]> {
    const result = await this.query(
      'SELECT * FROM system.system_config WHERE is_encrypted = FALSE'
    );
    return result.rows;
  }
}
