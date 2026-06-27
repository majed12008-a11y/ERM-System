/*
 * SDK الطلبات: دوال إدارة طلبات البحث.
 * إنشاء، عرض، تحديث، وحذف الطلبات.
 */
import api from '../../api/client'
import type {
  SuccessResponse,
  Application,
  CreateApplicationRequest,
  CommitteeDecisionRequest,
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

  updateStatus(id: number, data: { status: string }) {
    return api.patch<SuccessResponse<Application>>(`/core/applications/${id}/status`, data)
  },

  committeeDecision(id: number, data: CommitteeDecisionRequest) {
    return api.post<SuccessResponse<Application>>(`/core/applications/${id}/committee-decision`, data)
  },

  updateDraft(id: number, data: { application_type?: string; target_committee_id?: number; priority_level?: string; remarks?: string }) {
    return api.put<SuccessResponse<Application>>(`/core/applications/${id}`, data)
  },

  submitDraft(id: number, data?: { transition_code?: string; comment?: string }) {
    return api.post<SuccessResponse<Application>>(`/core/applications/${id}/submit`, data || {})
  },
}
