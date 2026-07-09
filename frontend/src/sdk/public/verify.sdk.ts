import api from '../../api/client'

export interface CertificateVerificationData {
  serialNumber: string
  status: string
  certificateType: string
  issuingAuthority: string
  issuingAuthorityEn: string
  committeeName: string
  committeeNameEn: string
  researcherName: string
  projectTitle: string
  applicationNumber: string
  institutionName: string
  issuedAt: string
  expiresAt: string | null
  revokedAt?: string
  revocationReason?: string
  supersededBySerial?: string
  verifiedAt: string
}

export const verify = {
  check(serialNumber: string) {
    return api.get(`/public/certificates/verify/${encodeURIComponent(serialNumber)}`)
  },
}
