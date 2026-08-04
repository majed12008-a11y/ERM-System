/*
 * Verification providers — own all artifact-specific behavior. A provider
 * declares which artifact types it serves and implements verify(), returning a
 * public VerificationResult (or null when the reference is not found). New
 * artifact types are added by registering a new provider, never by modifying
 * the engine.
 */
import type { ArtifactType, VerificationRequest, VerificationResult } from './types';

export interface VerificationProvider {
  id: string;
  artifactTypes: ArtifactType[];
  canHandle(request: VerificationRequest): boolean;
  /** Returns null when the reference is not found (provider logs NOT_FOUND). */
  verify(request: VerificationRequest): Promise<VerificationResult | null>;
}
