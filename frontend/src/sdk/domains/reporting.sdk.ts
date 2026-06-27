/*
 * SDK التقارير: دوال إحصائيات لوحة التحكم
 * والتقارير المتنوعة.
 */
import api from '../../api/client'
import type { SuccessResponse, DashboardStats, Application, StatusSummary, ApplicationTrend } from '../core/types'

export const reporting = {
  getDashboardStats() {
    return api.get<SuccessResponse<DashboardStats>>('/reporting/dashboard/stats')
  },

  getApplications() {
    return api.get<SuccessResponse<Application[]>>('/reporting/applications')
  },

  getCommittees() {
    return api.get<SuccessResponse<{ id: number; name_ar: string; member_count: number }[]>>('/reporting/committees')
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
