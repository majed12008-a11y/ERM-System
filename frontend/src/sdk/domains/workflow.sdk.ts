/*
 * SDK سير العمل: دوال إدارة تعريفات workflow
 * وحالات workflow والانتقالات بينها.
 */
import api from '../../api/client'
import type { SuccessResponse, WorkflowDefinition, WorkflowInstance, WorkflowTransition } from '../core/types'

export const workflow = {
  getDefinitions() {
    return api.get<SuccessResponse<WorkflowDefinition[]>>('/workflow/definitions')
  },

  getInstance(entityType: string, entityId: number) {
    return api.get<SuccessResponse<WorkflowInstance>>(`/workflow/instances/${entityType}/${entityId}`)
  },

  getAvailableTransitions(entityType: string, entityId: number) {
    return api.get<SuccessResponse<WorkflowTransition[]>>(`/workflow/available-transitions/${entityType}/${entityId}`)
  },

  executeTransition(data: { entity_type: string; entity_id: number; transition: string; comment?: string }) {
    return api.post<SuccessResponse<WorkflowInstance>>('/workflow/execute-transition', data)
  },
}
