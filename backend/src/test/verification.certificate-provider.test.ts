import { describe, it, expect, vi, beforeEach } from 'vitest';
import { CertificateVerificationProvider } from '../services/verification';

function makeRepo() {
  return {
    getVerificationData: vi.fn(),
    logVerification: vi.fn().mockResolvedValue(undefined),
  };
}

function certData(overrides: Record<string, any> = {}) {
  return {
    serialNumber: 'CERT-APP-2025-001002-V1',
    status: 'ISSUED',
    certificateType: 'ETHICS_APPROVAL',
    issuingAuthority: 'اللجنة الوطنية للأخلاقيات',
    issuingAuthorityEn: 'National Committee for Ethics',
    committeeName: 'لجنة الأخلاقيات',
    committeeNameEn: 'Ethics Committee',
    researcherName: 'researcher',
    projectTitle: 'Project X',
    applicationNumber: 'APP-2025-001002',
    institutionName: 'Institution',
    issuedAt: '2026-01-01T00:00:00.000Z',
    expiresAt: null,
    revokedAt: undefined,
    revocationReason: undefined,
    supersededBySerial: undefined,
    verifiedAt: '2026-01-01T00:00:00.000Z',
    ...overrides,
  };
}

describe('CertificateVerificationProvider', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('maps an ISSUED certificate to VALID with identity/metadata', async () => {
    const repo = makeRepo();
    repo.getVerificationData.mockResolvedValue(certData());
    const provider = new CertificateVerificationProvider(repo as any);

    const result = await provider.verify({ artifactType: 'approval-certificate', reference: 'CERT-APP-2025-001002-V1', context: { ip: '10.0.0.1' } });

    expect(result).not.toBeNull();
    expect(result!.identity.serialNumber).toBe('CERT-APP-2025-001002-V1');
    expect(result!.identity.subject).toBe('Project X');
    expect(result!.identity.type).toBe('ETHICS_APPROVAL');
    expect(result!.identity.issuerName).toBe('اللجنة الوطنية للأخلاقيات');
    expect(result!.verification.status).toBe('VALID');
    expect(result!.verification.method).toBe('approval-certificate-serial');
    expect(result!.metadata!.projectTitle).toBe('Project X');
    expect(result!.metadata!.applicationNumber).toBe('APP-2025-001002');
    expect(repo.logVerification).toHaveBeenCalledWith(
      'CERT-APP-2025-001002-V1', '10.0.0.1', 'VALID',
      expect.objectContaining({ artifactType: 'approval-certificate' })
    );
  });

  it('maps certificate lifecycle statuses to verification statuses', async () => {
    const cases: Array<[string, string]> = [
      ['REVOKED', 'REVOKED'],
      ['SUPERSEDED', 'SUPERSEDED'],
      ['DRAFT', 'UNKNOWN'],
      ['GENERATING', 'UNKNOWN'],
    ];
    for (const [certStatus, expected] of cases) {
      vi.clearAllMocks();
      const repo = makeRepo();
      repo.getVerificationData.mockResolvedValue(certData({ status: certStatus }));
      const provider = new CertificateVerificationProvider(repo as any);

      const result = await provider.verify({ artifactType: 'approval-certificate', reference: 'CERT-X' });
      expect(result!.verification.status).toBe(expected);
    }
  });

  it('exposes revocation details for REVOKED certificates', async () => {
    const repo = makeRepo();
    repo.getVerificationData.mockResolvedValue(certData({
      status: 'REVOKED',
      revokedAt: '2026-02-01T00:00:00.000Z',
      revocationReason: 'Non-compliance',
    }));
    const provider = new CertificateVerificationProvider(repo as any);

    const result = await provider.verify({ artifactType: 'approval-certificate', reference: 'CERT-X' });

    expect(result!.lifecycle.revokedAt).toBe('2026-02-01T00:00:00.000Z');
    expect(result!.lifecycle.revocationReason).toBe('Non-compliance');
  });

  it('exposes superseded-by in lifecycle, history and links', async () => {
    const repo = makeRepo();
    repo.getVerificationData.mockResolvedValue(certData({
      status: 'SUPERSEDED',
      supersededBySerial: 'CERT-APP-2025-001002-V2',
    }));
    const provider = new CertificateVerificationProvider(repo as any);

    const result = await provider.verify({ artifactType: 'approval-certificate', reference: 'CERT-APP-2025-001002-V1' });

    expect(result!.lifecycle.supersededBy).toBe('CERT-APP-2025-001002-V2');
    expect(result!.history!.supersededBy).toBe('CERT-APP-2025-001002-V2');
    expect(result!.links!.supersededBy).toContain('CERT-APP-2025-001002-V2');
  });

  it('logs NOT_FOUND and returns null for an unknown serial', async () => {
    const repo = makeRepo();
    repo.getVerificationData.mockResolvedValue(null);
    const provider = new CertificateVerificationProvider(repo as any);

    const result = await provider.verify({ artifactType: 'approval-certificate', reference: 'NOPE' });

    expect(result).toBeNull();
    expect(repo.logVerification).toHaveBeenCalledWith('NOPE', null, 'NOT_FOUND');
  });
});
