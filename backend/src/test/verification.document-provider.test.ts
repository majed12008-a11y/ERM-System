import { describe, it, expect, vi, beforeEach } from 'vitest';
import { DocumentVerificationProvider } from '../services/verification';
import { VERIFICATION_SCHEMA_VERSION } from '../services/verification';

function makeRepo() {
  return {
    getVerificationData: vi.fn(),
    findDocumentByReference: vi.fn(),
    getDocumentSignatures: vi.fn().mockResolvedValue([]),
    getDocumentAudit: vi.fn().mockResolvedValue([]),
    getDocumentVersions: vi.fn().mockResolvedValue([]),
    logVerification: vi.fn().mockResolvedValue(undefined),
  };
}

function docRow(overrides: Record<string, any> = {}) {
  return {
    document_number: 'APP-2025-001002',
    document_uuid: 'uuid-1',
    status: 'OFFICIAL',
    document_title: 'Approval Protocol v1',
    document_type: 'اعتماد',
    language: 'ar',
    version_no: 1,
    checksum_sha256: 'abc123',
    issued_at: '2026-01-01T00:00:00.000Z',
    issued_by_name: 'admin',
    template_code: 'protocol',
    template_version: 1,
    superseded_by_number: null,
    revoked_at: null,
    revocation_reason: null,
    entity_type: 'application',
    entity_id: 5,
    ...overrides,
  };
}

describe('DocumentVerificationProvider', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  function setup(row: any, signatures: any[] = [], audit: any[] = [], versions: any[] = []) {
    const repo = makeRepo();
    repo.getVerificationData.mockResolvedValue(row);
    repo.findDocumentByReference.mockResolvedValue({ id: 1 });
    repo.getDocumentSignatures.mockResolvedValue(signatures);
    repo.getDocumentAudit.mockResolvedValue(audit);
    repo.getDocumentVersions.mockResolvedValue(versions);
    return new DocumentVerificationProvider(repo as any);
  }

  it('maps an OFFICIAL document to VALID and populates all sections', async () => {
    const signatures = [
      {
        signer_name: 'alice', signer_title: 'Chair', signature_type: 'APPROVAL',
        signature_order: 1, signature_status: 'SIGNED', signed_at: '2026-01-02T00:00:00.000Z',
        is_required: true, signature_hash: 'h1',
      },
      {
        signer_name: 'bob', signer_title: 'Member', signature_type: 'APPROVAL',
        signature_order: 2, signature_status: 'PENDING', signed_at: null,
        is_required: false, signature_hash: null,
      },
    ];
    const audit = [
      { action_type: 'GENERATE', actor_name: 'admin', action_timestamp: '2026-01-01T00:00:00.000Z', details: '{}' },
    ];
    const versions = [{ version_no: 1, created_at: '2026-01-01T00:00:00.000Z' }];

    const provider = setup(docRow(), signatures, audit, versions);
    const result = await provider.verify({ artifactType: 'generated-document', reference: 'APP-2025-001002', context: { ip: '10.0.0.1' } });
    expect(result).not.toBeNull();
    expect(result!.schemaVersion).toBe(VERIFICATION_SCHEMA_VERSION);
    expect(result!.artifactType).toBe('generated-document');

    expect(result!.identity.documentNumber).toBe('APP-2025-001002');
    expect(result!.identity.title).toBe('Approval Protocol v1');
    expect(result!.identity.language).toBe('ar');
    expect(result!.identity.templateCode).toBe('protocol');
    expect(result!.identity.documentVersion).toBe(1);

    expect(result!.lifecycle.status).toBe('OFFICIAL');
    expect(result!.lifecycle.issuedAt).toBe('2026-01-01T00:00:00.000Z');

    expect(result!.verification.status).toBe('VALID');
    expect(result!.verification.method).toBe('generated-document-reference');

    expect(result!.integrity!.checksumAlgorithm).toBe('sha256');
    expect(result!.integrity!.checksumValue).toBe('abc123');
    expect(result!.integrity!.checksumVerified).toBe(true);

    expect(result!.signatures!.status).toBe('COMPLETE');
    expect(result!.signatures!.requiredCount).toBe(1);
    expect(result!.signatures!.completedCount).toBe(1);
    expect(result!.signatures!.timeline[0].signerName).toBe('alice');
    expect(result!.signatures!.timeline[1].isRequired).toBe(false);

    expect(result!.history!.versions![0].versionNo).toBe(1);
    expect(result!.history!.audit![0].actionType).toBe('GENERATE');

    expect(result!.metadata).toEqual({ document_uuid: 'uuid-1', entity_type: 'application', entity_id: 5 });
    expect(result!.links!.self).toContain('/api/v1/public/verification/verify/APP-2025-001002');
  });

  it('maps lifecycle statuses to verification statuses', async () => {
    const cases: Array<[string, string]> = [
      ['OFFICIAL', 'VALID'],
      ['ISSUED', 'VALID'],
      ['APPROVED', 'VALID'],
      ['REVOKED', 'REVOKED'],
      ['SUPERSEDED', 'SUPERSEDED'],
      ['VOID', 'INVALID'],
      ['DRAFT', 'UNKNOWN'],
    ];
    for (const [docStatus, expected] of cases) {
      vi.clearAllMocks();
      const provider = setup(docRow({ status: docStatus }));
      const result = await provider.verify({ artifactType: 'generated-document', reference: 'REF' });
      expect(result!.verification.status).toBe(expected);
    }
  });

  it('logs NOT_FOUND and returns null for an unknown reference', async () => {
    const repo = makeRepo();
    repo.getVerificationData.mockResolvedValue(null);
    const provider = new DocumentVerificationProvider(repo as any);

    const result = await provider.verify({ artifactType: 'generated-document', reference: 'NOPE' });

    expect(result).toBeNull();
    expect(repo.logVerification).toHaveBeenCalledWith('NOPE', null, 'NOT_FOUND');
  });

  it('exposes superseded-by in history and links', async () => {
    const provider = setup(docRow({
      status: 'SUPERSEDED',
      superseded_by_number: 'APP-2025-001003',
    }));
    const result = await provider.verify({ artifactType: 'generated-document', reference: 'APP-2025-001002' });

    expect(result!.verification.status).toBe('SUPERSEDED');
    expect(result!.history!.supersededBy).toBe('APP-2025-001003');
    expect(result!.links!.supersededBy).toContain('APP-2025-001003');
  });
});
