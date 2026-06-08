import api from '../../api/client'
import type { SuccessResponse, HealthStatus } from '../core/types'

export const monitoring = {
  health() {
    return api.get<SuccessResponse<HealthStatus>>('/monitoring/health')
  },

  getAudit() {
    return api.get<SuccessResponse<any[]>>('/monitoring/audit')
  },

  getConfig() {
    return api.get<SuccessResponse<any>>('/monitoring/config')
  },
}
