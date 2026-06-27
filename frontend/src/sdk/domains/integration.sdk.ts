/*
 * SDK التكامل: دوال إدارة الأحداث والتكامل
 * مع الأنظمة الخارجية.
 */
import api from '../../api/client'
import type { SuccessResponse, IntegrationEvent, IntegrationLog } from '../core/types'

export const integration = {
  getEvents() {
    return api.get<SuccessResponse<IntegrationEvent[]>>('/integration/events')
  },

  getLogs() {
    return api.get<SuccessResponse<IntegrationLog[]>>('/integration/logs')
  },
}
