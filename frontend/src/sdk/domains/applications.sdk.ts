import api from '../../api/client'
import type {
  SuccessResponse,
  Application,
  CreateApplicationRequest,
  CommitteeDecisionRequest,
  PaginationParams,
} from '../core/types'

export const applications = {
  list(params?: PaginationParams & { status?: string }) {
    return api.get<SuccessResponse<Application[]> & { pagination?: any }>('/core/applications', { params })
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
}
