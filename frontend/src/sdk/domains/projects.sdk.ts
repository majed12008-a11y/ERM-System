import api from '../../api/client'
import type { SuccessResponse, Project, CreateProjectRequest } from '../core/types'

export const projects = {
  list(params?: { page?: number; limit?: number }) {
    return api.get<SuccessResponse<Project[]> & { pagination?: any }>('/core/projects', { params })
  },

  getById(id: number) {
    return api.get<SuccessResponse<Project>>(`/core/projects/${id}`)
  },

  create(data: CreateProjectRequest) {
    return api.post<SuccessResponse<Project>>('/core/projects', data)
  },

  getApplications(id: number) {
    return api.get<SuccessResponse<import('../core/types').Application[]>>(`/core/projects/${id}/applications`)
  },

  getStats(id: number) {
    return api.get<SuccessResponse<any>>(`/core/projects/${id}/stats`)
  },
}
