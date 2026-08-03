import api from '../../api/client'

export interface DocumentVerificationData {
  document_number: string
  document_uuid: string
  status: string
  document_title: string
  document_type: string
  language: string
  version_no: number
  checksum_sha256: string
  issued_at: string
  issued_by_name: string
  template_code: string
  template_version: number
  superseded_by_number: string | null
  revoked_at: string | null
  revocation_reason: string | null
  entity_type: string
  entity_id: number
}

export const verifyDocument = {
  check(reference: string) {
    return api.get(`/public/documents/verify/${encodeURIComponent(reference)}`)
  },
}
