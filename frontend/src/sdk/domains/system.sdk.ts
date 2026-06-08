import api from '../../api/client'
import type { SuccessResponse } from '../core/types'

export const system = {
  getSavedSearches() {
    return api.get<SuccessResponse<any[]>>('/system/saved-searches')
  },

  createSavedSearch(data: { name: string; query: any; module: string }) {
    return api.post<SuccessResponse<any>>('/system/saved-searches', data)
  },

  updateSavedSearch(id: number, data: Partial<{ name: string; query: any }>) {
    return api.put<SuccessResponse<any>>(`/system/saved-searches/${id}`, data)
  },

  deleteSavedSearch(id: number) {
    return api.delete<SuccessResponse<null>>(`/system/saved-searches/${id}`)
  },

  getConfig() {
    return api.get<SuccessResponse<any>>('/system/config')
  },
}
