import api from '../../api/client'
import type { SuccessResponse } from '../core/types'

export const reporting = {
  getDashboardStats() {
    return api.get<SuccessResponse<any>>('/reporting/dashboard/stats')
  },

  getApplications() {
    return api.get<SuccessResponse<any[]>>('/reporting/applications')
  },

  getCommittees() {
    return api.get<SuccessResponse<any[]>>('/reporting/committees')
  },

  getStatusSummary() {
    return api.get<SuccessResponse<any>>('/reporting/status-summary')
  },

  getApplicationsTrend() {
    return api.get<SuccessResponse<any[]>>('/reporting/applications-trend')
  },

  exportApplications() {
    return api.get<Blob>('/reporting/export/applications', { responseType: 'blob' })
  },
}
