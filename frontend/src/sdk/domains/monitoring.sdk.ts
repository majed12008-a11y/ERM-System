/*
 * SDK المراقبة: دوال فحص صحة النظام،
 * سجلات التدقيق، وإعدادات النظام.
 */
import api from '../../api/client'
import type { SuccessResponse, HealthStatus, MonitoringAudit, SystemConfig } from '../core/types'

export const monitoring = {
  health() {
    return api.get<SuccessResponse<HealthStatus>>('/monitoring/health')
  },

  getAudit() {
    return api.get<SuccessResponse<MonitoringAudit[]>>('/monitoring/audit')
  },

  getConfig() {
    return api.get<SuccessResponse<SystemConfig[]>>('/monitoring/config')
  },
}
