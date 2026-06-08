import api from '../../api/client'
import type { SuccessResponse, RiskRegister, AdverseEvent } from '../core/types'

export const safety = {
  getAdverseEvents() {
    return api.get<SuccessResponse<AdverseEvent[]>>('/safety/adverse-events')
  },

  getSeriousAdverseEvents() {
    return api.get<SuccessResponse<AdverseEvent[]>>('/safety/serious-adverse-events')
  },

  getSafetyReports() {
    return api.get<SuccessResponse<any[]>>('/safety/safety-reports')
  },

  getRiskRegister() {
    return api.get<SuccessResponse<RiskRegister[]>>('/safety/risk-register')
  },

  createRiskEntry(data: { risk_title: string; risk_level: string; description: string }) {
    return api.post<SuccessResponse<RiskRegister>>('/safety/risk-register', data)
  },

  updateRiskEntry(id: number, data: Partial<RiskRegister>) {
    return api.put<SuccessResponse<RiskRegister>>(`/safety/risk-register/${id}`, data)
  },

  deleteRiskEntry(id: number) {
    return api.delete<SuccessResponse<null>>(`/safety/risk-register/${id}`)
  },

  getMitigations(riskId: number) {
    return api.get<SuccessResponse<any[]>>(`/safety/risk-register/${riskId}/mitigations`)
  },

  addMitigation(riskId: number, data: { description: string }) {
    return api.post<SuccessResponse<any>>(`/safety/risk-register/${riskId}/mitigations`, data)
  },

  getIncidents() {
    return api.get<SuccessResponse<any[]>>('/safety/risk-incidents')
  },

  reportIncident(data: { title: string; description: string; severity: string }) {
    return api.post<SuccessResponse<any>>('/safety/risk-incidents', data)
  },

  getCorrectiveActions() {
    return api.get<SuccessResponse<any[]>>('/safety/corrective-actions')
  },

  createCorrectiveAction(data: { incident_id: number; action: string; due_date: string }) {
    return api.post<SuccessResponse<any>>('/safety/corrective-actions', data)
  },
}
