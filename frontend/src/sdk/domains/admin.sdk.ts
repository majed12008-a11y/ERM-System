import api from '../../api/client'
import type { SuccessResponse, AdminStats, AuditLogEntry, PaginationParams } from '../core/types'

export const admin = {
  getStats() {
    return api.get<SuccessResponse<AdminStats>>('/admin/stats')
  },

  getAuditLog(params?: PaginationParams & { action?: string; user_id?: number }) {
    return api.get<SuccessResponse<AuditLogEntry[]> & { pagination?: any }>('/admin/audit-log', { params })
  },

  getDistinctActions() {
    return api.get<SuccessResponse<string[]>>('/admin/audit-log/actions')
  },

  getOnlineUsers() {
    return api.get<SuccessResponse<{ count: number }>>('/admin/online-users')
  },

  getRecentActivity() {
    return api.get<SuccessResponse<any[]>>('/admin/recent-activity')
  },
}
