/*
 * Verification engine — pure orchestration. It knows nothing about HTTP,
 * databases, or specific artifact types. Flow:
 *
 *   transport input (string) → resolve() → VerificationRequest
 *                              → provider registry (first canHandle)
 *                              → provider.verify() → VerificationResult
 *
 * Performance: retrieval happens inside providers; the engine performs no I/O.
 */
import type { ArtifactType, VerificationRequest, VerificationResult } from './types';
import type { VerificationResolver } from './resolver';
import type { VerificationProvider } from './provider';

export class VerificationNotFoundError extends Error {
  constructor(reference: string) {
    super(`Verification reference not found: ${reference}`);
    this.name = 'VerificationNotFoundError';
  }
}

export class VerificationEngine {
  private readonly resolvers: VerificationResolver[] = [];
  private readonly providers: VerificationProvider[] = [];

  constructor(resolvers: VerificationResolver[] = [], providers: VerificationProvider[] = []) {
    this.resolvers.push(...resolvers);
    this.providers.push(...providers);
  }

  registerResolver(resolver: VerificationResolver): void {
    this.resolvers.push(resolver);
  }

  registerProvider(provider: VerificationProvider): void {
    this.providers.push(provider);
  }

  /** First resolver whose canResolve() returns true wins. */
  resolve(input: string): VerificationRequest {
    for (const resolver of this.resolvers) {
      if (resolver.canResolve(input)) {
        return resolver.resolve(input);
      }
    }
    throw new VerificationNotFoundError(input);
  }

  async verify(
    input: string | VerificationRequest,
    opts: { ip?: string | null } = {}
  ): Promise<VerificationResult> {
    const base = typeof input === 'string' ? this.resolve(input) : input;
    const request: VerificationRequest = {
      ...base,
      context: { ...(base.context || {}), ip: opts.ip ?? base.context?.ip },
    };

    const provider = this.providers.find((p) => p.canHandle(request));
    if (!provider) {
      throw new VerificationNotFoundError(request.reference);
    }

    const result = await provider.verify(request);
    if (!result) {
      throw new VerificationNotFoundError(request.reference);
    }
    return result;
  }

  /** Introspection helpers for wiring/tests. */
  listArtifactTypes(): ArtifactType[] {
    return this.providers.flatMap((p) => p.artifactTypes);
  }

  listResolverIds(): string[] {
    return this.resolvers.map((r) => r.id);
  }
}
