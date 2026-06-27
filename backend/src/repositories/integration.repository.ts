/*
 * مستودع التكامل: إدارة الأحداث الصادرة (Event Outbox)
 * للتكامل مع الأنظمة الخارجية.
 */
import { AuditableRepository } from './auditable.repository';

export class IntegrationRepository extends AuditableRepository {
  async getEvents(): Promise<any[]> {
    const result = await this.query('SELECT * FROM integration.event_outbox ORDER BY created_at DESC LIMIT 100');
    return result.rows;
  }

  async getLogs(): Promise<any[]> {
    const result = await this.query('SELECT * FROM integration.integration_logs ORDER BY created_at DESC LIMIT 100');
    return result.rows;
  }
}
