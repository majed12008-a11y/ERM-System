import api from '../../api/client'

export interface ApprovalCertificate {
  id: number
  application_id: number
  serial_number: string
  version_no: number
  status: 'DRAFT' | 'GENERATING' | 'ISSUED' | 'REVOKED' | 'SUPERSEDED' | 'FAILED'
  issued_to_user_id: number
  issued_by_user_id: number
  issued_at: string
  revoked_at: string | null
  revoked_by: number | null
  revocation_reason: string | null
  superseded_by: number | null
  generation_error: any
  metadata: any
  created_at: string
  documents: CertificateDocumentLink[]
}

export interface CertificateDocumentLink {
  id: number
  certificate_id: number
  document_id: number
  is_original: boolean
  generated_at: string
}

export const certificates = {
  list(applicationId: number) {
    return api.get(`/core/applications/${applicationId}/certificates`)
  },

  getById(applicationId: number, certificateId: number) {
    return api.get(`/core/applications/${applicationId}/certificates/${certificateId}`)
  },

  download(applicationId: number, certificateId: number) {
    return api.get(`/core/applications/${applicationId}/certificates/${certificateId}/download`, {
      responseType: 'blob',
    })
  },

  reissue(applicationId: number, certificateId: number) {
    return api.post(`/core/applications/${applicationId}/certificates/${certificateId}/reissue`)
  },

  retry(applicationId: number, certificateId: number) {
    return api.post(`/core/applications/${applicationId}/certificates/${certificateId}/retry`)
  },

  revoke(applicationId: number, certificateId: number, reason: string) {
    return api.post(`/core/applications/${applicationId}/certificates/${certificateId}/revoke`, { reason })
  },
}
