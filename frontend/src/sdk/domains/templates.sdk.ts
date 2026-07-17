import api from '../../api/client'
import type { SuccessResponse, PaginatedResponse, PaginationParams } from '../core/types'

export interface Template {
  id: number
  category_id: number
  code: string
  name_ar: string
  name_en: string
  description?: string | null
  engine: string
  default_locale: string
  tags: string[]
  usage_count: number
  is_active: boolean
  created_at: string
  updated_at?: string | null
}

export interface TemplateCategory {
  id: number
  code: string
  name_ar: string
  name_en: string
  description?: string | null
  is_active: boolean
}

export interface TemplateVersion {
  id: number
  template_id: number
  version: string
  status: 'DRAFT' | 'REVIEW' | 'APPROVED' | 'DEPRECATED' | 'ARCHIVED'
  content: Record<string, { body: string; [key: string]: any }>
  content_hash: string
  variable_definitions: any[]
  change_summary?: string | null
  effective_from?: string | null
  effective_until?: string | null
  approved_by?: number | null
  approved_at?: string | null
  created_by: number
  created_at: string
}

export interface TemplateSnapshot {
  id: number
  snapshotHash: string
  templateVersionId: number
  contentHash: string
  locale: string
  renderedHtml: string
  renderedAt: string
  renderedBy: number
  correlationId?: string | null
  metadata: Record<string, any>
}

export interface RenderPreviewRequest {
  templateCode: string
  version: string
  variables: Record<string, unknown>
  locale?: string
}

export interface RenderPreviewResult {
  html: string
  renderResult: {
    html: string
    templateCode: string
    version: string
    locale: string
    renderedAt: string
    resolutionTimeMs: number
    cacheHit: boolean
    versionId: number
    contentHash: string
    variableCount: number
  }
}

export interface RenderDocumentRequest extends RenderPreviewRequest {
  entityType?: string
  entityId?: number
}

export interface RenderDocumentResult {
  html: string
  renderResult: RenderPreviewResult['renderResult']
  snapshot: TemplateSnapshot
  snapshotHash: string
  correlationId?: string
}

export interface AuditEntry {
  id: number
  template_version_id: number
  action: string
  actor_id: number
  previous_status: string | null
  new_status: string | null
  comment?: string | null
  created_at: string
}

export interface RollbackRequest {
  templateCode: string
  version: string
  reason?: string
}

export const templates = {
  list(params?: PaginationParams & { q?: string; category_id?: number }) {
    return api.get<PaginatedResponse<Template>>('/templates', { params })
  },

  get(id: number) {
    return api.get<SuccessResponse<Template>>(`/templates/${id}`)
  },

  create(data: {
    category_id: number
    code: string
    name_ar: string
    name_en: string
    description?: string
    engine?: string
    default_locale?: string
    tags?: string[]
    variable_sources?: any
  }) {
    return api.post<SuccessResponse<Template>>('/templates', data)
  },

  update(id: number, data: {
    name_ar?: string
    name_en?: string
    description?: string
    tags?: string[]
    variable_sources?: any
    is_active?: boolean
  }) {
    return api.put<SuccessResponse<Template>>(`/templates/${id}`, data)
  },

  remove(id: number) {
    return api.delete<SuccessResponse<{ deleted: boolean }>>(`/templates/${id}`)
  },

  listVersions(params?: PaginationParams & { template_id?: number; status?: string; code?: string }) {
    return api.get<PaginatedResponse<TemplateVersion>>('/templates/versions', { params })
  },

  getVersion(id: number) {
    return api.get<SuccessResponse<TemplateVersion>>(`/templates/versions/${id}`)
  },

  createVersion(data: {
    template_id: number
    version: string
    content: Record<string, { body: string; [key: string]: any }>
    content_hash?: string
    variable_definitions?: any[]
    change_summary?: string
  }) {
    return api.post<SuccessResponse<TemplateVersion>>('/templates/versions', data)
  },

  updateVersion(id: number, data: {
    content?: Record<string, { body: string; [key: string]: any }>
    content_hash?: string
    variable_definitions?: any[]
    change_summary?: string
  }) {
    return api.put<SuccessResponse<TemplateVersion>>(`/templates/versions/${id}`, data)
  },

  submitVersion(id: number, comment?: string) {
    return api.post<SuccessResponse<TemplateVersion>>(`/templates/versions/${id}/submit`, { comment })
  },

  approveVersion(id: number, comment?: string) {
    return api.post<SuccessResponse<TemplateVersion>>(`/templates/versions/${id}/approve`, { comment })
  },

  rejectVersion(id: number, reason: string) {
    return api.post<SuccessResponse<TemplateVersion>>(`/templates/versions/${id}/reject`, { reason })
  },

  deprecateVersion(id: number, reason?: string) {
    return api.post<SuccessResponse<TemplateVersion>>(`/templates/versions/${id}/deprecate`, { reason })
  },

  archiveVersion(id: number, reason?: string) {
    return api.post<SuccessResponse<TemplateVersion>>(`/templates/versions/${id}/archive`, { reason })
  },

  preview(data: RenderPreviewRequest) {
    return api.post<SuccessResponse<RenderPreviewResult>>('/templates/template-preview', data)
  },

  render(data: RenderDocumentRequest) {
    return api.post<SuccessResponse<RenderDocumentResult>>('/templates/template-render', data)
  },

  getHistory(params: { templateCode: string; version: string }) {
    return api.get<SuccessResponse<AuditEntry[]>>('/templates/template-history', { params })
  },

  getSnapshots(params: { templateVersionId: number }) {
    return api.get<SuccessResponse<TemplateSnapshot[]>>('/templates/template-snapshots', { params })
  },

  getSnapshotByHash(hash: string) {
    return api.get<SuccessResponse<TemplateSnapshot>>(`/templates/template-snapshots/${hash}`)
  },

  verifySnapshot(hash: string) {
    return api.post<SuccessResponse<{ valid: boolean; match: boolean }>>('/templates/template-snapshots/verify', { hash })
  },

  rollback(data: RollbackRequest) {
    return api.post<SuccessResponse<any>>('/templates/template-rollback', data)
  },

  listCategories() {
    return api.get<SuccessResponse<TemplateCategory[]>>('/templates/categories')
  },

  getCategory(id: number) {
    return api.get<SuccessResponse<TemplateCategory>>(`/templates/categories/${id}`)
  },
}
