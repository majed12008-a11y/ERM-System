import api from '../../api/client'
import type { SuccessResponse, Document, DocumentSignature } from '../core/types'

export const documents = {
  list(params?: { page?: number; limit?: number }) {
    return api.get<SuccessResponse<Document[]> & { pagination?: any }>('/documents', { params })
  },

  getTypes() {
    return api.get<SuccessResponse<any[]>>('/documents/types')
  },

  upload(formData: FormData) {
    return api.post<SuccessResponse<Document>>('/documents', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
  },

  getClassifications() {
    return api.get<SuccessResponse<any[]>>('/documents/classifications')
  },

  getByEntity(entityType: string, entityId: number) {
    return api.get<SuccessResponse<Document[]>>(`/documents/entity/${entityType}/${entityId}`)
  },

  delete(id: number) {
    return api.delete<SuccessResponse<null>>(`/documents/${id}`)
  },

  sign(id: number) {
    return api.post<SuccessResponse<DocumentSignature>>(`/documents/${id}/sign`)
  },

  getSignatures(id: number) {
    return api.get<SuccessResponse<DocumentSignature[]>>(`/documents/${id}/signatures`)
  },

  getPendingSignatures() {
    return api.get<SuccessResponse<Document[]>>('/documents/pending-signatures')
  },
}
