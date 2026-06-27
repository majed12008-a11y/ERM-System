/*
 * SDK اللجان: دوال إدارة اللجان، الاجتماعات، الأعضاء،
 * المراجعات، التصويت، والمخاطر الأخلاقية.
 */
import api from '../../api/client'
import type { SuccessResponse, Committee, Meeting, CommitteeMember, AgendaItem, Attendance, Minutes, MemberTerm, MemberQualification, MemberConflict, Pagination } from '../core/types'

export const committees = {
  listTypes() {
    return api.get<SuccessResponse<{ id: number; name_ar: string }[]>>('/committee/committees/committee-types')
  },

  listRoles() {
    return api.get<SuccessResponse<{ id: number; name_ar: string }[]>>('/committee/committees/committee-roles')
  },

  list() {
    return api.get<SuccessResponse<Committee[]> & { pagination?: Pagination }>('/committee/committees')
  },

  getById(id: number) {
    return api.get<SuccessResponse<Committee>>(`/committee/committees/${id}`)
  },

  create(data: { name_ar: string; committee_type_id: number }) {
    return api.post<SuccessResponse<Committee>>('/committee/committees', data)
  },

  update(id: number, data: Partial<Committee>) {
    return api.put<SuccessResponse<Committee>>(`/committee/committees/${id}`, data)
  },

  deactivate(id: number) {
    return api.delete<SuccessResponse<null>>(`/committee/committees/${id}`)
  },
}

export const meetings = {
  listByCommittee(committeeId: number) {
    return api.get<SuccessResponse<Meeting[]> & { pagination?: Pagination }>(`/committee/meetings/committee/${committeeId}`)
  },

  create(data: { committee_id: number; meeting_date: string; meeting_type: string; location?: string }) {
    return api.post<SuccessResponse<Meeting>>('/committee/meetings', data)
  },

  getById(id: number) {
    return api.get<SuccessResponse<Meeting>>(`/committee/meetings/${id}`)
  },

  update(id: number, data: Partial<Meeting>) {
    return api.post<SuccessResponse<Meeting>>(`/committee/meetings/${id}`, data)
  },

  recordQuorum(id: number, data: { total_members: number; present: number }) {
    return api.post<SuccessResponse<{ quorum_met: boolean }>>(`/committee/meetings/${id}/quorum`, data)
  },

  getAgenda(id: number) {
    return api.get<SuccessResponse<AgendaItem[]>>(`/committee/meetings/${id}/agenda`)
  },

  addAgendaItem(id: number, data: { title: string; sort_order?: number }) {
    return api.post<SuccessResponse<AgendaItem>>(`/committee/meetings/${id}/agenda`, data)
  },

  addAgendaSubItem(id: number, agendaId: number, data: { title: string; sort_order?: number }) {
    return api.post<SuccessResponse<AgendaItem>>(`/committee/meetings/${id}/agenda/${agendaId}/items`, data)
  },

  getAttendance(id: number) {
    return api.get<SuccessResponse<Attendance[]>>(`/committee/meetings/${id}/attendance`)
  },

  recordAttendance(id: number, data: { user_id: number; status: string }) {
    return api.post<SuccessResponse<Attendance>>(`/committee/meetings/${id}/attendance`, data)
  },

  getMinutes(id: number) {
    return api.get<SuccessResponse<Minutes>>(`/committee/meetings/${id}/minutes`)
  },

  createMinutes(id: number, data: { content: string }) {
    return api.post<SuccessResponse<Minutes>>(`/committee/meetings/${id}/minutes`, data)
  },

  approveMinutes(id: number, minutesId: number) {
    return api.patch<SuccessResponse<Minutes>>(`/committee/meetings/${id}/minutes/${minutesId}/approve`)
  },

  getCommitteeMembers(id: number) {
    return api.get<SuccessResponse<CommitteeMember[]>>(`/committee/meetings/${id}/committee-members`)
  },
}

export const members = {
  listByCommittee(committeeId: number) {
    return api.get<SuccessResponse<CommitteeMember[]>>(`/committee/committees/${committeeId}/members`)
  },

  add(committeeId: number, data: { user_id: number; role_id?: number }) {
    return api.post<SuccessResponse<CommitteeMember>>(`/committee/committees/${committeeId}/members`, data)
  },

  updateRole(committeeId: number, memberId: number, data: { role_id: number }) {
    return api.put<SuccessResponse<CommitteeMember>>(`/committee/committees/${committeeId}/members/${memberId}`, data)
  },

  remove(committeeId: number, memberId: number) {
    return api.delete<SuccessResponse<null>>(`/committee/committees/${committeeId}/members/${memberId}`)
  },

  getTerms(memberId: number) {
    return api.get<SuccessResponse<MemberTerm[]>>(`/committee/members/${memberId}/terms`)
  },

  addTerm(memberId: number, data: { start_date: string; end_date?: string }) {
    return api.post<SuccessResponse<MemberTerm>>(`/committee/members/${memberId}/terms`, data)
  },

  getQualifications(memberId: number) {
    return api.get<SuccessResponse<MemberQualification[]>>(`/committee/members/${memberId}/qualifications`)
  },

  addQualification(memberId: number, data: { qualification: string }) {
    return api.post<SuccessResponse<MemberQualification>>(`/committee/members/${memberId}/qualifications`, data)
  },

  getConflicts(memberId: number) {
    return api.get<SuccessResponse<MemberConflict[]>>(`/committee/members/${memberId}/conflicts`)
  },

  declareConflict(memberId: number, data: { application_id: number; conflict_type: string }) {
    return api.post<SuccessResponse<MemberConflict>>(`/committee/members/${memberId}/conflicts`, data)
  },
}
