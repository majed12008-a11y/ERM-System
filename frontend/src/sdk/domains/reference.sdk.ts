import api from '../../api/client'
import type { SuccessResponse } from '../core/types'

export const reference = {
  getInstitutions() {
    return api.get<SuccessResponse<any[]>>('/reference/institutions-registry')
  },

  getProfessions() {
    return api.get<SuccessResponse<any[]>>('/reference/professions')
  },

  getLicenses() {
    return api.get<SuccessResponse<any[]>>('/reference/licenses')
  },
}
