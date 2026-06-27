/*
 * SDK المرجع: استعلامات المؤسسات والتخصصات
 * والرخص المهنية.
 */
import api from '../../api/client'
import type { SuccessResponse, Institution, Profession, License } from '../core/types'

export const reference = {
  getInstitutions() {
    return api.get<SuccessResponse<Institution[]>>('/reference/institutions-registry')
  },

  getProfessions() {
    return api.get<SuccessResponse<Profession[]>>('/reference/professions')
  },

  getLicenses() {
    return api.get<SuccessResponse<License[]>>('/reference/licenses')
  },
}
