/*
 * SDK النظام: دوال إدارة عمليات البحث المحفوظة
 * وإعدادات المستخدمين.
 */
import api from '../../api/client'
import type { SuccessResponse, SavedSearch, SystemConfig } from '../core/types'

export const system = {
  getSavedSearches() {
    return api.get<SuccessResponse<SavedSearch[]>>('/system/saved-searches')
  },

  createSavedSearch(data: { name: string; search_type: string; criteria: any; is_shared?: boolean }) {
    return api.post<SuccessResponse<SavedSearch>>('/system/saved-searches', data)
  },

  updateSavedSearch(id: number, data: Partial<SavedSearch>) {
    return api.put<SuccessResponse<SavedSearch>>(`/system/saved-searches/${id}`, data)
  },

  deleteSavedSearch(id: number) {
    return api.delete<SuccessResponse<null>>(`/system/saved-searches/${id}`)
  },

  getConfig() {
    return api.get<SuccessResponse<SystemConfig[]>>('/system/config')
  },
}
