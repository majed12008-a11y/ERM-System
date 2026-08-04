import { describe, it, expect, vi } from 'vitest';
import {
  VerificationEngine,
  VerificationNotFoundError,
  ReferenceResolver,
  VERIFICATION_SCHEMA_VERSION,
} from '../services/verification';
import type { VerificationResult } from '../services/verification';

function makeResult(artifactType: string, reference: string): VerificationResult {
  return {
    schemaVersion: VERIFICATION_SCHEMA_VERSION,
    artifactType,
    reference,
    verifiedAt: '2026-01-01T00:00:00.000Z',
    identity: {},
    lifecycle: {},
    verification: { status: 'VALID', method: 'test', timestamp: '2026-01-01T00:00:00.000Z' },
  };
}

function makeProvider(id: string, artifactType: string) {
  return {
    id,
    artifactTypes: [artifactType],
    canHandle: vi.fn((req: any) => req.artifactType === artifactType),
    verify: vi.fn(async (req: any) => (req.reference === 'MISSING' ? null : makeResult(artifactType, req.reference))),
  };
}

describe('ReferenceResolver', () => {
  const resolver = new ReferenceResolver();

  it('resolves CERT-/ERC- prefixed references to approval-certificate', () => {
    expect(resolver.canResolve('CERT-APP-2025-001002-V1')).toBe(true);
    expect(resolver.resolve('CERT-APP-2025-001002-V1').artifactType).toBe('approval-certificate');
    expect(resolver.resolve('ERC-2024-00000').artifactType).toBe('approval-certificate');
  });

  it('resolves anything else to generated-document', () => {
    expect(resolver.resolve('APP-2025-001002').artifactType).toBe('generated-document');
    expect(resolver.resolve('f46d78db-9f6e-4c11-8370-1b271a075c').artifactType).toBe('generated-document');
  });

  it('rejects empty input', () => {
    expect(resolver.canResolve('')).toBe(false);
  });
});

describe('VerificationEngine', () => {
  const docProvider = makeProvider('generated-document', 'generated-document');
  const certProvider = makeProvider('approval-certificate', 'approval-certificate');

  it('routes a string reference through the resolver to the matching provider', async () => {
    const engine = new VerificationEngine(
      [new ReferenceResolver()],
      [docProvider, certProvider]
    );

    const result = await engine.verify('CERT-APP-2025-001002-V1', { ip: '10.0.0.1' });

    expect(result.artifactType).toBe('approval-certificate');
    expect(certProvider.canHandle).toHaveBeenCalledTimes(1);
    expect(certProvider.verify).toHaveBeenCalledWith(
      expect.objectContaining({
        artifactType: 'approval-certificate',
        reference: 'CERT-APP-2025-001002-V1',
        context: { ip: '10.0.0.1' },
      })
    );
    expect(docProvider.verify).not.toHaveBeenCalled();
  });

  it('handles a full VerificationRequest without re-resolving', async () => {
    const engine = new VerificationEngine([new ReferenceResolver()], [docProvider, certProvider]);

    const result = await engine.verify({ artifactType: 'generated-document', reference: 'APP-2025-001002' });

    expect(result.artifactType).toBe('generated-document');
    expect(docProvider.verify).toHaveBeenCalledTimes(1);
  });

  it('throws VerificationNotFoundError when the provider cannot find the artifact', async () => {
    const engine = new VerificationEngine([new ReferenceResolver()], [docProvider, certProvider]);

    await expect(engine.verify('MISSING')).rejects.toThrow(VerificationNotFoundError);
  });

  it('throws VerificationNotFoundError when no provider can handle the request', async () => {
    const engine = new VerificationEngine([new ReferenceResolver()], [certProvider]);

    await expect(engine.verify('APP-2025-001002')).rejects.toThrow(VerificationNotFoundError);
  });

  it('throws VerificationNotFoundError when no resolver matches the input', async () => {
    const onlyCert = { id: 'cert-only', canResolve: (i: string) => i.startsWith('CERT-'), resolve: (i: string) => ({ artifactType: 'approval-certificate', reference: i }) };
    const engine = new VerificationEngine([onlyCert], [certProvider]);

    await expect(engine.verify('APP-2025-001002')).rejects.toThrow(VerificationNotFoundError);
  });

  it('supports a second provider registering without modifying the engine (quality gate)', async () => {
    const future = makeProvider('future-type', 'pki-certificate');
    const engine = new VerificationEngine([new ReferenceResolver()], [docProvider, certProvider]);
    engine.registerProvider(future);

    const result = await future.verify({ artifactType: 'pki-certificate', reference: 'X509-0001' });

    expect(result).not.toBeNull();
    expect(result!.artifactType).toBe('pki-certificate');
    expect(engine['providers'].length).toBe(3);
  });

  it('propagates a request context ip when a request object is supplied directly', async () => {
    const engine = new VerificationEngine([new ReferenceResolver()], [docProvider, certProvider]);

    await engine.verify({ artifactType: 'approval-certificate', reference: 'CERT-X', context: { ip: '127.0.0.1' } });

    expect(certProvider.verify).toHaveBeenCalledWith(
      expect.objectContaining({ context: { ip: '127.0.0.1' } })
    );
  });
});
