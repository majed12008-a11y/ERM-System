/*
 * Verification resolvers — normalize a raw transport input (a reference string)
 * into a VerificationRequest. Resolvers must not depend on HTTP. The engine
 * asks each resolver canResolve() in registration order and uses the first
 * match. New reference kinds (QR, token, PKI identifier, ...) are added by
 * registering a new resolver, never by modifying the engine.
 */
import type { ArtifactType, VerificationRequest } from './types';

export interface VerificationResolver {
  id: string;
  canResolve(input: string): boolean;
  resolve(input: string): VerificationRequest;
}

/**
 * Reference-prefix heuristic:
 *  - CERT-* / ERC-* → approval certificate serial
 *  - anything else  → generated document (number or UUID)
 */
export class ReferenceResolver implements VerificationResolver {
  readonly id = 'reference';

  canResolve(input: string): boolean {
    return typeof input === 'string' && input.trim().length > 0;
  }

  resolve(input: string): VerificationRequest {
    const artifactType: ArtifactType = /^(CERT|ERC)-/i.test(input.trim())
      ? 'approval-certificate'
      : 'generated-document';
    return { artifactType, reference: input.trim() };
  }
}
