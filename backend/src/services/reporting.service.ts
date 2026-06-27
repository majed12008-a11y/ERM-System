/*
 * نظام التقارير والإحصائيات: تقارير عن الطلبات،
 * المشاريع، أداء اللجان، وإحصائيات النظام.
 */
import { ReportingRepository } from '../repositories/reporting.repository';

export class ReportingService {
  private repo = new ReportingRepository();

  async getDashboardStats(userId: number) { return this.repo.getDashboardStats(userId); }

  async getApplications(params: {
    status?: string; from?: string; to?: string; search?: string;
    page: number; limit: number;
  }) {
    return this.repo.getApplications(params);
  }

  async getCommittees() { return this.repo.getCommittees(); }

  async getStatusSummary() { return this.repo.getStatusSummary(); }

  async getApplicationsTrend() { return this.repo.getApplicationsTrend(); }

  async getExportData() { return this.repo.getExportData(); }
}
