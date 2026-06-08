import { AuditableRepository } from './auditable.repository';

export class MonitoringRepository extends AuditableRepository {
  async getAuditLogs(): Promise<any[]> {
    const result = await this.query(
      `SELECT al.*, u.username
       FROM system.audit_log al
       LEFT JOIN security.users u ON al.performed_by = u.id
       ORDER BY al.performed_at DESC
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
