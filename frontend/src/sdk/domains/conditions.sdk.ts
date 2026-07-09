import api from '../../api/client'
import type {
  SuccessResponse,
  ApplicationCondition,
  CreateConditionRequest,
  UpdateConditionRequest,
  ResolveConditionRequest,
  ConditionEvaluation,
  Document,
} from '../core/types'

export const conditions = {
  list(applicationId: number) {
    return api.get<SuccessResponse<ApplicationCondition[]>>(`/core/applications/${applicationId}/conditions`)
  },

  create(applicationId: number, data: CreateConditionRequest) {
    return api.post<SuccessResponse<ApplicationCondition>>(`/core/applications/${applicationId}/conditions`, data)
  },

  update(applicationId: number, conditionId: number, data: UpdateConditionRequest) {
    return api.put<SuccessResponse<ApplicationCondition>>(`/core/applications/${applicationId}/conditions/${conditionId}`, data)
  },

  resolve(applicationId: number, conditionId: number, data: ResolveConditionRequest) {
    return api.patch<SuccessResponse<ApplicationCondition>>(`/core/applications/${applicationId}/conditions/${conditionId}/resolve`, data)
  },

  delete(applicationId: number, conditionId: number) {
    return api.delete<SuccessResponse<null>>(`/core/applications/${applicationId}/conditions/${conditionId}`)
  },

  getSummary(applicationId: number) {
    return api.get<SuccessResponse<ConditionEvaluation>>(`/core/applications/${applicationId}/conditions/summary`)
  },

  uploadEvidence(applicationId: number, conditionId: number, formData: FormData) {
    return api.post<SuccessResponse<Document>>(
      `/core/applications/${applicationId}/conditions/${conditionId}/evidence`,
      formData,
      { headers: { 'Content-Type': 'multipart/form-data' } },
    )
  },

  listEvidence(applicationId: number, conditionId: number) {
    return api.get<SuccessResponse<Document[]>>(
      `/core/applications/${applicationId}/conditions/${conditionId}/evidence`,
    )
  },

  deleteEvidence(applicationId: number, conditionId: number, evidenceId: number) {
    return api.delete<SuccessResponse<null>>(
      `/core/applications/${applicationId}/conditions/${conditionId}/evidence/${evidenceId}`,
    )
  },
}
