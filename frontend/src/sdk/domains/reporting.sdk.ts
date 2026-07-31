/*
 * SDK التقارير: دوال إحصائيات لوحة التحكم
 * والتقارير المتنوعة.
 */
import api from '../../api/client'
import type {
  SuccessResponse, PaginatedResponse, DashboardStats,
  ReportApplication, ReportCommittee, StatusSummary, ApplicationTrend,
  ReportApplicationsParams
} from '../core/types'

export const reporting = {
  getDashboardStats() {
    return api.get<SuccessResponse<DashboardStats>>('/reporting/dashboard/stats')
  },

  getApplications(params?: ReportApplicationsParams) {
    return api.get<PaginatedResponse<ReportApplication>>('/reporting/applications', { params })
  },

  getCommittees() {
    return api.get<SuccessResponse<ReportCommittee[]>>('/reporting/committees')
  },

  getStatusSummary() {
    return api.get<SuccessResponse<StatusSummary[]>>('/reporting/status-summary')
  },

  getApplicationsTrend() {
    return api.get<SuccessResponse<ApplicationTrend[]>>('/reporting/applications-trend')
  },

  exportApplications() {
    return api.get<Blob>('/reporting/export/applications', { responseType: 'blob' })
  },
}
