/*
 * SDK الطلبات: دوال إدارة طلبات البحث.
 * إنشاء، عرض، تحديث، وحذف الطلبات.
 */
import api from '../../api/client'
import type {
  SuccessResponse,
  Application,
  CreateApplicationRequest,
  PaginationParams,
  Pagination,
} from '../core/types'

export const applications = {
  list(params?: PaginationParams & { status?: string }) {
    return api.get<SuccessResponse<Application[]> & { pagination?: Pagination }>('/core/applications', { params })
  },

  getById(id: number) {
    return api.get<SuccessResponse<Application>>(`/core/applications/${id}`)
  },

  create(data: CreateApplicationRequest) {
    return api.post<SuccessResponse<Application>>('/core/applications', data)
  },

  updateStatus(id: number, data: { transition_code: string; comment?: string }) {
    return api.patch<SuccessResponse<Application>>(`/core/applications/${id}/status`, data)
  },

  updateDraft(id: number, data: { application_type?: string; target_committee_id?: number; priority_level?: string; remarks?: string }) {
    return api.put<SuccessResponse<Application>>(`/core/applications/${id}`, data)
  },

  withdraw(id: number, data?: { comment?: string }) {
    return api.post<SuccessResponse<Application>>(`/core/applications/${id}/withdraw`, data || {})
  },

  appeal(id: number, data: { comment: string }) {
    return api.post<SuccessResponse<Application>>(`/core/applications/${id}/appeal`, data)
  },

  renew(id: number) {
    return api.post<SuccessResponse<Application>>(`/core/applications/${id}/renewal`)
  },

  getSla(id: number) {
    return api.get<SuccessResponse<{ within_sla: boolean; overdue_by?: number }>>(`/core/applications/${id}/sla`)
  },

  getHistory(id: number) {
    return api.get<SuccessResponse<any[]>>(`/core/applications/${id}/history`)
  },

}
