import api from '../../api/client'
import type { SuccessResponse } from '../core/types'

export const lookups = {
  getResearchCategories() {
    return api.get<SuccessResponse<any[]>>('/core/research-categories')
  },

  getRiskClassifications() {
    return api.get<SuccessResponse<any[]>>('/core/risk-classifications')
  },

  getVulnerablePopulations() {
    return api.get<SuccessResponse<any[]>>('/core/vulnerable-populations')
  },

  getResearchPopulationLinks() {
    return api.get<SuccessResponse<any[]>>('/core/research-population-links')
  },
}
