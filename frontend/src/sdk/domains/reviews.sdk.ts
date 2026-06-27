/*
 * SDK المراجعات: دوال إدارة مراجعات الطلبات،
 * التعليقات، التصويت، وجلسات التصويت.
 */
import api from '../../api/client'
import type { SuccessResponse, ReviewForm, ReviewQuestion, ReviewAssignment, ReviewRecommendation, ReviewComment, ReviewAnswer, ReviewScore, VotingSession, Vote } from '../core/types'

export const reviews = {
  getMy() {
    return api.get<SuccessResponse<ReviewAssignment[]>>('/committee/reviews/my')
  },

  assign(data: { application_id: number; reviewer_id: number; form_id?: number }) {
    return api.post<SuccessResponse<ReviewAssignment>>('/committee/reviews/assign', data)
  },

  getByApplication(applicationId: number) {
    return api.get<SuccessResponse<ReviewAssignment[]>>(`/committee/reviews/application/${applicationId}`)
  },

  getRecommendations(applicationId: number) {
    return api.get<SuccessResponse<ReviewRecommendation[]>>(`/committee/reviews/application/${applicationId}/recommendations`)
  },

  getComments(applicationId: number) {
    return api.get<SuccessResponse<ReviewComment[]>>(`/committee/reviews/application/${applicationId}/comments`)
  },

  submit(assignmentId: number, data: { recommendation: string; comments?: string; answers?: { question_id: number; answer_value: string }[] }) {
    return api.post<SuccessResponse<ReviewAssignment>>(`/committee/reviews/${assignmentId}/submit`, data)
  },

  getForms() {
    return api.get<SuccessResponse<ReviewForm[]>>('/committee/reviews/forms')
  },

  createForm(data: { form_code: string; title: string }) {
    return api.post<SuccessResponse<ReviewForm>>('/committee/reviews/forms', data)
  },

  getQuestions(formId: number) {
    return api.get<SuccessResponse<ReviewQuestion[]>>(`/committee/reviews/forms/${formId}/questions`)
  },

  addQuestion(formId: number, data: { question_code: string; question_text: string; question_type: string; sort_order?: number }) {
    return api.post<SuccessResponse<ReviewQuestion>>(`/committee/reviews/forms/${formId}/questions`, data)
  },

  deleteQuestion(formId: number, questionId: number) {
    return api.delete<SuccessResponse<null>>(`/committee/reviews/forms/${formId}/questions/${questionId}`)
  },

  getAnswers(assignmentId: number) {
    return api.get<SuccessResponse<ReviewAnswer[]>>(`/committee/reviews/assignment/${assignmentId}/answers`)
  },

  getScore(assignmentId: number) {
    return api.get<SuccessResponse<ReviewScore>>(`/committee/reviews/assignment/${assignmentId}/score`)
  },
}

export const voting = {
  getByMeeting(meetingId: number) {
    return api.get<SuccessResponse<VotingSession[]>>(`/committee/voting/meeting/${meetingId}`)
  },

  createSession(data: { meeting_id: number; voting_type: string }) {
    return api.post<SuccessResponse<VotingSession>>('/committee/voting/sessions', data)
  },

  getSession(id: number) {
    return api.get<SuccessResponse<VotingSession>>(`/committee/voting/sessions/${id}`)
  },

  castVote(sessionId: number, data: { vote_value: string; comments?: string }) {
    return api.post<SuccessResponse<Vote>>(`/committee/voting/sessions/${sessionId}/vote`, data)
  },

  closeSession(sessionId: number) {
    return api.post<SuccessResponse<VotingSession>>(`/committee/voting/sessions/${sessionId}/close`)
  },
}
