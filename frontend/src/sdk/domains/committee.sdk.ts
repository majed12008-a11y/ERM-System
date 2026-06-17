import api from '../../api/client'
import type { SuccessResponse } from '../core/types'

export const committees = {
  listTypes() {
    return api.get<SuccessResponse<any[]>>('/committee/committees/committee-types')
  },

  listRoles() {
    return api.get<SuccessResponse<any[]>>('/committee/committees/committee-roles')
  },

  list() {
    return api.get<SuccessResponse<any[]>>('/committee/committees')
  },

  getById(id: number) {
    return api.get<SuccessResponse<any>>(`/committee/committees/${id}`)
  },

  create(data: { name_ar: string; committee_type_id: number }) {
    return api.post<SuccessResponse<any>>('/committee/committees', data)
  },

  update(id: number, data: any) {
    return api.put<SuccessResponse<any>>(`/committee/committees/${id}`, data)
  },

  deactivate(id: number) {
    return api.delete<SuccessResponse<null>>(`/committee/committees/${id}`)
  },
}

export const meetings = {
  listByCommittee(committeeId: number) {
    return api.get<SuccessResponse<any[]>>(`/committee/meetings/committee/${committeeId}`)
  },

  create(data: { committee_id: number; meeting_date: string; title: string }) {
    return api.post<SuccessResponse<any>>('/committee/meetings', data)
  },

  getById(id: number) {
    return api.get<SuccessResponse<any>>(`/committee/meetings/${id}`)
  },

  update(id: number, data: any) {
    return api.patch<SuccessResponse<any>>(`/committee/meetings/${id}`, data)
  },

  recordQuorum(id: number, data: any) {
    return api.post<SuccessResponse<any>>(`/committee/meetings/${id}/quorum`, data)
  },

  getAgenda(id: number) {
    return api.get<SuccessResponse<any[]>>(`/committee/meetings/${id}/agenda`)
  },

  addAgendaItem(id: number, data: any) {
    return api.post<SuccessResponse<any>>(`/committee/meetings/${id}/agenda`, data)
  },

  addAgendaSubItem(id: number, agendaId: number, data: any) {
    return api.post<SuccessResponse<any>>(`/committee/meetings/${id}/agenda/${agendaId}/items`, data)
  },

  getAttendance(id: number) {
    return api.get<SuccessResponse<any[]>>(`/committee/meetings/${id}/attendance`)
  },

  recordAttendance(id: number, data: any) {
    return api.post<SuccessResponse<any>>(`/committee/meetings/${id}/attendance`, data)
  },

  getMinutes(id: number) {
    return api.get<SuccessResponse<any>>(`/committee/meetings/${id}/minutes`)
  },

  createMinutes(id: number, data: any) {
    return api.post<SuccessResponse<any>>(`/committee/meetings/${id}/minutes`, data)
  },

  approveMinutes(id: number, minutesId: number) {
    return api.patch<SuccessResponse<any>>(`/committee/meetings/${id}/minutes/${minutesId}/approve`)
  },

  getCommitteeMembers(id: number) {
    return api.get<SuccessResponse<any[]>>(`/committee/meetings/${id}/committee-members`)
  },
}

export const members = {
  listByCommittee(committeeId: number) {
    return api.get<SuccessResponse<any[]>>(`/committee/committees/${committeeId}/members`)
  },

  add(committeeId: number, data: { user_id: number; role_id?: number }) {
    return api.post<SuccessResponse<any>>(`/committee/committees/${committeeId}/members`, data)
  },

  updateRole(committeeId: number, memberId: number, data: { role_id: number }) {
    return api.put<SuccessResponse<any>>(`/committee/committees/${committeeId}/members/${memberId}`, data)
  },

  remove(committeeId: number, memberId: number) {
    return api.delete<SuccessResponse<null>>(`/committee/committees/${committeeId}/members/${memberId}`)
  },

  getTerms(memberId: number) {
    return api.get<SuccessResponse<any[]>>(`/committee/members/${memberId}/terms`)
  },

  addTerm(memberId: number, data: any) {
    return api.post<SuccessResponse<any>>(`/committee/members/${memberId}/terms`, data)
  },

  getQualifications(memberId: number) {
    return api.get<SuccessResponse<any[]>>(`/committee/members/${memberId}/qualifications`)
  },

  addQualification(memberId: number, data: any) {
    return api.post<SuccessResponse<any>>(`/committee/members/${memberId}/qualifications`, data)
  },

  getConflicts(memberId: number) {
    return api.get<SuccessResponse<any[]>>(`/committee/members/${memberId}/conflicts`)
  },

  declareConflict(memberId: number, data: any) {
    return api.post<SuccessResponse<any>>(`/committee/members/${memberId}/conflicts`, data)
  },
}
