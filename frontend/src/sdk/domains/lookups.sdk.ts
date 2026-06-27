/*
 * SDK البيانات المرجعية: استعلامات التصنيفات
 * البحثية والفئات السكانية والتصنيفات الأخرى.
 */
import api from '../../api/client'
import type { SuccessResponse, ResearchCategory, RiskClassification, VulnerablePopulation } from '../core/types'

export const lookups = {
  getResearchCategories() {
    return api.get<SuccessResponse<ResearchCategory[]>>('/core/research-categories')
  },

  getRiskClassifications() {
    return api.get<SuccessResponse<RiskClassification[]>>('/core/risk-classifications')
  },

  getVulnerablePopulations() {
    return api.get<SuccessResponse<VulnerablePopulation[]>>('/core/vulnerable-populations')
  },

  getResearchPopulationLinks() {
    return api.get<SuccessResponse<{ id: number; category_id: number; population_id: number }[]>>('/core/research-population-links')
  },
}
