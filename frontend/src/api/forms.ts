/*
 * دوال API لمكتبة النماذج: التعريفات، المثيلات،
 * توليد وتنزيل المستندات الرسمية.
 */
import api from './client'
import { FormDefinition, FormInstance, GeneratedDocument } from '../components/forms/types'

export async function listFormDefinitions(): Promise<FormDefinition[]> {
  const res = await api.get('/forms')
  return res.data.data || []
}

export async function listFormCategories(): Promise<string[]> {
  const res = await api.get('/forms/categories')
  return res.data.data || []
}

export async function getFormDefinition(code: string): Promise<FormDefinition> {
  const res = await api.get(`/forms/definitions/${code}`)
  return res.data.data
}

export async function createFormInstance(data: {
  form_code: string
  entity_type: string
  entity_id: number
}): Promise<FormInstance> {
  const res = await api.post('/forms/instances', data)
  return res.data.data
}

export async function getFormInstance(id: number): Promise<{ instance: FormInstance; definition: FormDefinition }> {
  const res = await api.get(`/forms/instances/${id}`)
  return res.data.data
}

export async function listInstanceDocuments(entityType: string, entityId: number): Promise<FormInstance[]> {
  const res = await api.get(`/forms/instances/entity/${entityType}/${entityId}`)
  return res.data.data || []
}

export async function saveFormDraft(id: number, responses: Record<string, any>): Promise<FormInstance> {
  const res = await api.put(`/forms/instances/${id}`, { responses })
  return res.data.data
}

export async function submitForm(id: number, responses: Record<string, any>): Promise<FormInstance> {
  const res = await api.post(`/forms/instances/${id}/submit`, { responses })
  return res.data.data
}

export async function generateFormDocument(id: number, opts: {
  language?: string
  templateCode?: string
  signatories?: { name: string; role: string }[]
  context?: Record<string, any>
}): Promise<GeneratedDocument> {
  const res = await api.post(`/forms/instances/${id}/generate`, opts)
  return res.data.data
}

export function formDocumentDownloadUrl(documentId: number): string {
  return `/api/v1/forms/documents/${documentId}/download`
}

export async function downloadFormDocument(documentId: number, fileName?: string): Promise<void> {
  const res = await api.get(formDocumentDownloadUrl(documentId), { responseType: 'blob' })
  const url = window.URL.createObjectURL(new Blob([res.data]))
  const a = document.createElement('a')
  a.href = url
  a.download = fileName || `form-document-${documentId}.pdf`
  a.click()
  window.URL.revokeObjectURL(url)
}
