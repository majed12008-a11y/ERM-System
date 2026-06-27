/*
 * مراقبة أداء النظام: تسجيل مقاييس الأداء
 * ومراقبة صحة الخدمات والاتصالات بقاعدة البيانات.
 */
import { MonitoringRepository } from '../repositories/monitoring.repository';

export class MonitoringService {
  private repo = new MonitoringRepository();

  async getAuditLogs() { return this.repo.getAuditLogs(); }
  async getSystemConfig() { return this.repo.getSystemConfig(); }
}
