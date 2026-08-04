export { VERIFICATION_SCHEMA_VERSION } from './types';
export type {
  ArtifactType,
  VerificationStatus,
  VerificationRequest,
  VerificationResult,
  VerificationIdentity,
  VerificationLifecycle,
  VerificationResultVerification,
  VerificationIntegrity,
  VerificationSignatureItem,
  VerificationSignatures,
  VerificationHistoryItem,
  VerificationHistory,
  VerificationLinks,
} from './types';
export { ReferenceResolver } from './resolver';
export type { VerificationResolver } from './resolver';
export type { VerificationProvider } from './provider';
export { VerificationEngine, VerificationNotFoundError } from './engine';
export { DocumentVerificationProvider } from './providers/document-provider';
export { CertificateVerificationProvider } from './providers/certificate-provider';
export { createVerificationEngine } from './registry';
