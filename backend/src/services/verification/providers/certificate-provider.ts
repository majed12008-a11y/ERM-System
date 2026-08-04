/*
 * Approval-certificate provider — second provider proving the platform quality
 * gate: it registers against the same engine without any engine changes. All
 * certificate-specific behavior lives here.
 */
import { CertificateRepository } from '../../../repositories/certificate.repository';
import { VERIFICATION_SCHEMA_VERSION } from '../types';
import type { VerificationProvider } from '../provider';
import type { VerificationRequest, VerificationStatus, VerificationIdentity, VerificationLifecycle, VerificationResult } from '../types';

const CERT_STATUS_TO_VERIFICATION: Record<string, VerificationStatus> = {
  ISSUED: 'VALID',
  REVOKED: 'REVOKED',
  SUPERSEDED: 'SUPERSEDED',
};

export class CertificateVerificationProvider implements VerificationProvider {
  readonly id = 'approval-certificate';
  readonly artifactTypes = ['approval-certificate'];

  constructor(private readonly repo = new CertificateRepository()) {}

  canHandle(request: VerificationRequest): boolean {
    return request.artifactType === 'approval-certificate';
  }

  async verify(request: VerificationRequest): Promise<VerificationResult | null> {
    const ip = request.context?.ip ?? null;
    const data = await this.repo.getVerificationData(request.reference);

    if (!data) {
      await this.repo.logVerification(request.reference, ip, 'NOT_FOUND');
      return null;
    }

    const status = CERT_STATUS_TO_VERIFICATION[data.status] ?? 'UNKNOWN';
    const now = new Date().toISOString();

    const identity: VerificationIdentity = {
      serialNumber: data.serialNumber,
      subject: data.projectTitle,
      type: data.certificateType,
      issuerName: data.issuingAuthority,
    };

    const lifecycle: VerificationLifecycle = {
      status: data.status,
      issuedAt: data.issuedAt,
      expiresAt: data.expiresAt ?? null,
      revokedAt: data.revokedAt ?? null,
      revocationReason: data.revocationReason ?? null,
      supersededBy: data.supersededBySerial,
    };

    const result: VerificationResult = {
      schemaVersion: VERIFICATION_SCHEMA_VERSION,
      artifactType: this.id,
      reference: request.reference,
      verifiedAt: now,
      identity,
      lifecycle,
      verification: {
        status,
        method: 'approval-certificate-serial',
        timestamp: now,
      },
      metadata: {
        projectTitle: data.projectTitle,
        researcherName: data.researcherName,
        applicationNumber: data.applicationNumber,
        committeeName: data.committeeName,
        committeeNameEn: data.committeeNameEn,
        institutionName: data.institutionName,
        issuingAuthorityEn: data.issuingAuthorityEn,
      },
      links: {
        self: `/api/v1/public/verification/verify/${encodeURIComponent(request.reference)}`,
      },
    };

    if (data.supersededBySerial) {
      result.history = { supersededBy: data.supersededBySerial };
      result.links!.supersededBy = `/api/v1/public/verification/verify/${encodeURIComponent(data.supersededBySerial)}`;
    }

    await this.repo.logVerification(request.reference, ip, status, {
      artifactType: this.id,
    });
    return result;
  }
}
