/*
 * لوحة التحكم: إعدادات النظام، النسخ الاحتياطي،
 * إدارة البيانات المرجعية، ومهام الصيانة.
 */
import { AdminRepository } from '../repositories/admin.repository';
import { PaginationParams } from '../shared/pagination';

export class AdminService {
  private repo = new AdminRepository();

  async getStats() { return this.repo.getStats(); }

  async getAuditLog(params: { page: number; limit: number; action?: string; userId?: number }) {
    const { rows, total } = await this.repo.getAuditLog(params);
    return { rows, total, page: params.page, limit: params.limit };
  }

  async getDistinctActions() { return this.repo.getDistinctActions(); }

  async getOnlineUsers() { return { count: await this.repo.getOnlineUsers() }; }

  async getRecentActivity() { return this.repo.getRecentActivity(); }
}
