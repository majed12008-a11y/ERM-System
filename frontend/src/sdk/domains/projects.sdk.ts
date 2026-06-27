/*
 * SDK المشاريع: دوال إدارة المشاريع البحثية
 * المرتبطة بطلبات البحث.
 */
import api from '../../api/client'
import type { SuccessResponse, Project, CreateProjectRequest, Application, Pagination } from '../core/types'

export const projects = {
  list(params?: { page?: number; limit?: number }) {
    return api.get<SuccessResponse<Project[]> & { pagination?: Pagination }>('/core/projects', { params })
  },

  getById(id: number) {
    return api.get<SuccessResponse<Project>>(`/core/projects/${id}`)
  },

  create(data: CreateProjectRequest) {
    return api.post<SuccessResponse<Project>>('/core/projects', data)
  },

  getApplications(id: number) {
    return api.get<SuccessResponse<Application[]>>(`/core/projects/${id}/applications`)
  },

  getStats(id: number) {
    return api.get<SuccessResponse<{ total_applications: number; approved: number; rejected: number }>>(`/core/projects/${id}/stats`)
  },
}
