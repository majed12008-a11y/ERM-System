import api from '../../api/client'
import type { SuccessResponse } from '../core/types'

export const integration = {
  getEvents() {
    return api.get<SuccessResponse<any[]>>('/integration/events')
  },

  getLogs() {
    return api.get<SuccessResponse<any[]>>('/integration/logs')
  },
}
