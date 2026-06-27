/*
 * SDK الإدارة: دوال لوحة التحكم، الإحصائيات،
 * سجلات التدقيق، وإعدادات النظام.
 */
import api from '../../api/client'
import type { SuccessResponse, AdminStats, AuditLogEntry, PaginationParams, RecentActivity, Pagination } from '../core/types'

export const admin = {
  getStats() {
    return api.get<SuccessResponse<AdminStats>>('/admin/stats')
  },

  getAuditLog(params?: PaginationParams & { action?: string; user_id?: number }) {
    return api.get<SuccessResponse<AuditLogEntry[]> & { pagination?: Pagination }>('/admin/audit-log', { params })
  },

  getDistinctActions() {
    return api.get<SuccessResponse<string[]>>('/admin/audit-log/actions')
  },

  getOnlineUsers() {
    return api.get<SuccessResponse<{ count: number }>>('/admin/online-users')
  },

  getRecentActivity() {
    return api.get<SuccessResponse<RecentActivity[]>>('/admin/recent-activity')
  },
}
