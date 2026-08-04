/*
 * Verification platform — stable public contracts.
 *
 * VerificationRequest and VerificationResult are versioned DTOs that are
 * independent of both the HTTP API and internal database entities. Providers
 * translate internal data into the public DTO; they never leak DB rows.
 */
export const VERIFICATION_SCHEMA_VERSION = '1.0';

export type ArtifactType = string;

/** Overall status of a verification, as shown on the public portal. */
export type VerificationStatus =
  | 'VALID'
  | 'MODIFIED'
  | 'INVALID'
  | 'UNKNOWN'
  | 'REVOKED'
  | 'SUPERSEDED'
  | 'EXPIRED';

/** Normalized request accepted by the verification engine. */
export interface VerificationRequest {
  /** Kind of artifact being verified (resolver-assigned). */
  artifactType: ArtifactType;
  /** Raw reference (document number, serial number, UUID, ...). */
  reference: string;
  /** Non-verifiable context such as the requesting IP (used for audit logs). */
  context?: {
    ip?: string | null;
  };
}

export interface VerificationIdentity {
  documentNumber?: string;
  serialNumber?: string;
  title?: string;
  subject?: string;
  type?: string;
  language?: string;
  issuerName?: string;
  templateCode?: string;
  templateVersion?: number;
  documentVersion?: number;
  entityType?: string;
  entityId?: number | string;
}

export interface VerificationLifecycle {
  /** Raw lifecycle status of the artifact (e.g. OFFICIAL, ISSUED). */
  status?: string;
  issuedAt?: string;
  effectiveAt?: string;
  expiresAt?: string | null;
  revokedAt?: string | null;
  revocationReason?: string | null;
  supersededBy?: string;
  archivedAt?: string | null;
}

export interface VerificationResultVerification {
  status: VerificationStatus;
  /** Identifies how the artifact was verified (provider method). */
  method: string;
  timestamp: string;
}

export interface VerificationIntegrity {
  checksumAlgorithm?: string;
  /** Full checksum value. Consumers should display it truncated. */
  checksumValue?: string;
  /** True when the stored checksum matched the stored record hash. */
  checksumVerified?: boolean;
  qrStatus?: string;
}

export interface VerificationSignatureItem {
  signerName?: string;
  signerTitle?: string;
  role?: string;
  signatureType?: string;
  isRequired?: boolean;
  status?: string;
  signedAt?: string | null;
  signatureHash?: string;
}

export interface VerificationSignatures {
  status: 'COMPLETE' | 'INCOMPLETE' | 'NONE';
  requiredCount: number;
  completedCount: number;
  timeline: VerificationSignatureItem[];
}

export interface VerificationHistoryItem {
  versionNo?: number;
  actionType?: string;
  actorName?: string;
  timestamp?: string;
  details?: unknown;
}

export interface VerificationHistory {
  supersededBy?: string;
  previousVersion?: string;
  versions?: Array<{ versionNo: number; status?: string; issuedAt?: string }>;
  audit?: VerificationHistoryItem[];
}

export interface VerificationLinks {
  self?: string;
  supersededBy?: string;
  download?: string;
}

export interface VerificationResult {
  schemaVersion: string;
  artifactType: ArtifactType;
  reference: string;
  verifiedAt: string;
  identity: VerificationIdentity;
  lifecycle: VerificationLifecycle;
  verification: VerificationResultVerification;
  integrity?: VerificationIntegrity;
  signatures?: VerificationSignatures;
  history?: VerificationHistory;
  /** Free-form, provider-specific data (translated, never raw rows). */
  metadata?: Record<string, unknown>;
  links?: VerificationLinks;
}
