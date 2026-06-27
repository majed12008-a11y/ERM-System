/*
 * SDK السلامة: دوال إدارة المخاطر، الأحداث الضارة،
 * والإجراءات التصحيحية.
 */
import api from '../../api/client'
import type { SuccessResponse, RiskRegister, AdverseEvent, RiskMitigation, RiskIncident, CorrectiveAction } from '../core/types'

export const safety = {
  getAdverseEvents() {
    return api.get<SuccessResponse<AdverseEvent[]>>('/safety/adverse-events')
  },

  getSeriousAdverseEvents() {
    return api.get<SuccessResponse<AdverseEvent[]>>('/safety/serious-adverse-events')
  },

  getSafetyReports() {
    return api.get<SuccessResponse<AdverseEvent[]>>('/safety/safety-reports')
  },

  getRiskRegister() {
    return api.get<SuccessResponse<RiskRegister[]>>('/safety/risk-register')
  },

  createRiskEntry(data: { risk_title: string; risk_level: string; risk_description?: string }) {
    return api.post<SuccessResponse<RiskRegister>>('/safety/risk-register', data)
  },

  updateRiskEntry(id: number, data: Partial<RiskRegister>) {
    return api.put<SuccessResponse<RiskRegister>>(`/safety/risk-register/${id}`, data)
  },

  deleteRiskEntry(id: number) {
    return api.delete<SuccessResponse<null>>(`/safety/risk-register/${id}`)
  },

  getMitigations(riskId: number) {
    return api.get<SuccessResponse<RiskMitigation[]>>(`/safety/risk-register/${riskId}/mitigations`)
  },

  addMitigation(riskId: number, data: { mitigation_plan: string; responsible_party?: number; status?: string }) {
    return api.post<SuccessResponse<RiskMitigation>>(`/safety/risk-register/${riskId}/mitigations`, data)
  },

  getIncidents() {
    return api.get<SuccessResponse<RiskIncident[]>>('/safety/incidents')
  },

  reportIncident(data: { incident_code: string; risk_id: number; incident_date: string; description: string; severity: string }) {
    return api.post<SuccessResponse<RiskIncident>>('/safety/incidents', data)
  },

  getCorrectiveActions() {
    return api.get<SuccessResponse<CorrectiveAction[]>>('/safety/corrective-actions')
  },

  createCorrectiveAction(data: { incident_id: number; action_plan: string; assigned_to: number; due_date?: string }) {
    return api.post<SuccessResponse<CorrectiveAction>>('/safety/corrective-actions', data)
  },
}
