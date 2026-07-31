/*
 * SDK اللجان: دوال إدارة اللجان، الاجتماعات، الأعضاء،
 * المراجعات، التصويت، والمخاطر الأخلاقية.
 */
import api from '../../api/client'
import type {
  SuccessResponse,
  Committee,
  CommitteeType,
  CommitteeRole,
  Meeting,
  CommitteeMember,
  AgendaItem,
  AgendaSection,
  Attendance,
  Minutes,
  MemberTerm,
  MemberQualification,
  MemberConflict,
  Pagination,
} from '../core/types'

export const committees = {
  listTypes() {
    return api.get<SuccessResponse<CommitteeType[]>>('/committee/committees/committee-types')
  },

  listRoles() {
    return api.get<SuccessResponse<CommitteeRole[]>>('/committee/committees/committee-roles')
  },

  list() {
    return api.get<SuccessResponse<Committee[]> & { pagination?: Pagination }>('/committee/committees')
  },

  getById(id: number) {
    return api.get<SuccessResponse<Committee>>(`/committee/committees/${id}`)
  },

  create(data: {
    committee_code: string
    committee_name_ar: string
    committee_name_en?: string
    institution_id: number
    committee_type_id: number
    is_active?: boolean
  }) {
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
  listAll() {
    return api.get<SuccessResponse<Meeting[]>>('/committee/meetings')
  },

  listByCommittee(committeeId: number) {
    return api.get<SuccessResponse<Meeting[]> & { pagination?: Pagination }>(`/committee/meetings/committee/${committeeId}`)
  },

  create(data: {
    committee_id: number
    meeting_date: string
    meeting_type: string
    location?: string
    title?: string
  }) {
    return api.post<SuccessResponse<Meeting>>('/committee/meetings', data)
  },

  getById(id: number) {
    return api.get<SuccessResponse<Meeting>>(`/committee/meetings/${id}`)
  },

  update(id: number, data: Partial<Meeting>) {
    return api.post<SuccessResponse<Meeting>>(`/committee/meetings/${id}`, data)
  },

  getAgenda(id: number) {
    return api.get<SuccessResponse<AgendaSection[]>>(`/committee/meetings/${id}/agenda`)
  },

  addAgendaItem(id: number, data: { title: string; description?: string; sort_order?: number }) {
    return api.post<SuccessResponse<AgendaItem>>(`/committee/meetings/${id}/agenda`, data)
  },

  addAgendaSubItem(id: number, agendaId: number, data: { title: string; application_id?: number; sort_order?: number }) {
    return api.post<SuccessResponse<AgendaItem>>(`/committee/meetings/${id}/agenda/${agendaId}/items`, data)
  },

  getAttendance(id: number) {
    return api.get<SuccessResponse<Attendance[]>>(`/committee/meetings/${id}/attendance`)
  },

  recordAttendance(id: number, data: { user_id: number; attendance_status: string; remarks?: string }) {
    return api.post<SuccessResponse<Attendance>>(`/committee/meetings/${id}/attendance`, data)
  },

  getMinutes(id: number) {
    return api.get<SuccessResponse<Minutes[]>>(`/committee/meetings/${id}/minutes`)
  },

  createMinutes(id: number, data: { minutes_text: string }) {
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

  addTerm(memberId: number, data: {
    start_date: string
    end_date?: string
    appointment_decision_no?: string
    termination_decision_no?: string
  }) {
    return api.post<SuccessResponse<MemberTerm>>(`/committee/members/${memberId}/terms`, data)
  },

  getQualifications(memberId: number) {
    return api.get<SuccessResponse<MemberQualification[]>>(`/committee/members/${memberId}/qualifications`)
  },

  addQualification(memberId: number, data: {
    specialization: string
    academic_degree: string
    institution_name?: string
    experience_years?: number
  }) {
    return api.post<SuccessResponse<MemberQualification>>(`/committee/members/${memberId}/qualifications`, data)
  },

  getConflicts(memberId: number) {
    return api.get<SuccessResponse<MemberConflict[]>>(`/committee/members/${memberId}/conflicts`)
  },

  declareConflict(memberId: number, data: {
    entity_type: string
    entity_id: number
    conflict_type: string
    description?: string
  }) {
    return api.post<SuccessResponse<MemberConflict>>(`/committee/members/${memberId}/conflicts`, data)
  },
}
