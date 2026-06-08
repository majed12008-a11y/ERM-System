import api from '../../api/client'
import type { SuccessResponse } from '../core/types'

export const workflow = {
  getDefinitions() {
    return api.get<SuccessResponse<any[]>>('/workflow/definitions')
  },

  getInstance(entityType: string, entityId: number) {
    return api.get<SuccessResponse<any>>(`/workflow/instances/${entityType}/${entityId}`)
  },

  getAvailableTransitions(entityType: string, entityId: number) {
    return api.get<SuccessResponse<any[]>>(`/workflow/available-transitions/${entityType}/${entityId}`)
  },

  executeTransition(data: { entity_type: string; entity_id: number; transition: string; comment?: string }) {
    return api.post<SuccessResponse<any>>('/workflow/execute-transition', data)
  },
}
