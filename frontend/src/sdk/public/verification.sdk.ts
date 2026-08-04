import api from '../../api/client'

export type VerificationStatus = 'VALID' | 'MODIFIED' | 'INVALID' | 'UNKNOWN' | 'REVOKED' | 'SUPERSEDED' | 'EXPIRED'

export interface VerificationIdentity {
  documentNumber?: string
  serialNumber?: string
  title?: string
  subject?: string
  type?: string
  language?: string
  issuerName?: string
  templateCode?: string
  templateVersion?: number
  documentVersion?: number
  entityType?: string
  entityId?: number | string
}

export interface VerificationLifecycle {
  status?: string
  issuedAt?: string
  effectiveAt?: string
  expiresAt?: string | null
  revokedAt?: string | null
  revocationReason?: string | null
  supersededBy?: string
  archivedAt?: string | null
}

export interface VerificationIntegrity {
  checksumAlgorithm?: string
  checksumValue?: string
  checksumVerified?: boolean
  qrStatus?: string
}

export interface VerificationSignatureItem {
  signerName?: string
  signerTitle?: string
  role?: string
  signatureType?: string
  isRequired?: boolean
  status?: string
  signedAt?: string | null
  signatureHash?: string
}

export interface VerificationSignatures {
  status: 'COMPLETE' | 'INCOMPLETE' | 'NONE'
  requiredCount: number
  completedCount: number
  timeline: VerificationSignatureItem[]
}

export interface VerificationHistoryItem {
  versionNo?: number
  actionType?: string
  actorName?: string
  timestamp?: string
  details?: unknown
}

export interface VerificationHistory {
  supersededBy?: string
  previousVersion?: string
  versions?: Array<{ versionNo: number; status?: string; issuedAt?: string }>
  audit?: VerificationHistoryItem[]
}

export interface VerificationLinks {
  self?: string
  supersededBy?: string
  download?: string
}

export interface VerificationResult {
  schemaVersion: string
  artifactType: string
  reference: string
  verifiedAt: string
  identity: VerificationIdentity
  lifecycle: VerificationLifecycle
  verification: {
    status: VerificationStatus
    method: string
    timestamp: string
  }
  integrity?: VerificationIntegrity
  signatures?: VerificationSignatures
  history?: VerificationHistory
  metadata?: Record<string, unknown>
  links?: VerificationLinks
}

export const verifyReference = {
  check(reference: string) {
    return api.get(`/public/verification/verify/${encodeURIComponent(reference)}`)
  },
}
