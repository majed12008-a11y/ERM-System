/*
 * SDK المستندات: دوال رفع وتنزيل وإدارة الملفات
 * والمستندات المرتبطة بالطلبات واللجان.
 */
import api from '../../api/client'
import type { SuccessResponse, Document, DocumentSignature, DocumentType, DocumentClassification, Pagination } from '../core/types'

export const documents = {
  list(params?: { page?: number; limit?: number }) {
    return api.get<SuccessResponse<Document[]> & { pagination?: Pagination }>('/documents', { params })
  },

  getById(id: number) {
    return api.get<SuccessResponse<Document>>(`/documents/${id}`)
  },

  getTypes() {
    return api.get<SuccessResponse<DocumentType[]>>('/documents/types')
  },

  upload(formData: FormData) {
    return api.post<SuccessResponse<Document>>('/documents', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    })
  },

  getClassifications() {
    return api.get<SuccessResponse<DocumentClassification[]>>('/documents/classifications')
  },

  getByEntity(entityType: string, entityId: number) {
    return api.get<SuccessResponse<Document[]>>(`/documents/entity/${entityType}/${entityId}`)
  },

  download(id: number) {
    return api.get(`/documents/${id}/download`, { responseType: 'blob' })
  },

  preview(id: number) {
    return api.get(`/documents/${id}/preview`, { responseType: 'blob' })
  },

  delete(id: number) {
    return api.delete<SuccessResponse<{ id: number }>>(`/documents/${id}`)
  },

  restore(id: number) {
    return api.post<SuccessResponse<{ id: number }>>(`/documents/${id}/restore`)
  },

  sign(id: number, signatureType: string = 'ELECTRONIC') {
    return api.post<SuccessResponse<DocumentSignature>>(`/documents/${id}/sign`, { signature_type: signatureType })
  },

  getSignatures(id: number) {
    return api.get<SuccessResponse<DocumentSignature[]>>(`/documents/${id}/signatures`)
  },

  getPendingSignatures() {
    return api.get<SuccessResponse<Document[]>>('/documents/pending-signatures')
  },
}
