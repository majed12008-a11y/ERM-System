/*
 * Generated-document provider — wraps DocumentRenderRepository and translates
 * internal rows into the public VerificationResult DTO. All artifact behavior
 * lives here; the engine never sees document tables or repository types.
 */
import { env } from '../../../config/env';
import { DocumentRenderRepository } from '../../../repositories/document-render.repository';
import { VERIFICATION_SCHEMA_VERSION } from '../types';
import type { VerificationProvider } from '../provider';
import type {
  VerificationRequest,
  VerificationSignatures,
  VerificationStatus,
  VerificationIdentity,
  VerificationLifecycle,
  VerificationResult,
} from '../types';

const DOCUMENT_STATUS_TO_VERIFICATION: Record<string, VerificationStatus> = {
  OFFICIAL: 'VALID',
  ISSUED: 'VALID',
  APPROVED: 'VALID',
  SUPERSEDED: 'SUPERSEDED',
  REVOKED: 'REVOKED',
  VOID: 'INVALID',
};

export class DocumentVerificationProvider implements VerificationProvider {
  readonly id = 'generated-document';
  readonly artifactTypes = ['generated-document'];

  constructor(private readonly repo = new DocumentRenderRepository()) {}

  canHandle(request: VerificationRequest): boolean {
    return request.artifactType === 'generated-document';
  }

  async verify(request: VerificationRequest): Promise<VerificationResult | null> {
    const ip = request.context?.ip ?? null;
    const data = await this.repo.getVerificationData(request.reference);

    if (!data) {
      await this.repo.logVerification(request.reference, ip, 'NOT_FOUND');
      return null;
    }

    const document = await this.repo.findDocumentByReference(request.reference);
    const [signatures, audit, versions] = document
      ? await Promise.all([
          this.repo.getDocumentSignatures(document.id),
          this.repo.getDocumentAudit(document.id),
          this.repo.getDocumentVersions(document.id),
        ])
      : [[], [], []];

    const status = DOCUMENT_STATUS_TO_VERIFICATION[data.status] ?? 'UNKNOWN';
    const result = this.buildResult(data, { status, signatures, audit, versions }, request.reference);

    await this.repo.logVerification(request.reference, ip, status, {
      artifactType: this.id,
      document_uuid: data.document_uuid,
    });
    return result;
  }

  private buildResult(
    data: Record<string, any>,
    extras: {
      status: VerificationStatus;
      signatures: any[];
      audit: any[];
      versions: any[];
    },
    reference: string
  ): VerificationResult {
    const identity: VerificationIdentity = {
      documentNumber: data.document_number,
      title: data.document_title,
      type: data.document_type,
      language: data.language,
      issuerName: data.issued_by_name,
      templateCode: data.template_code,
      templateVersion: data.template_version,
      documentVersion: data.version_no,
      entityType: data.entity_type,
      entityId: data.entity_id,
    };

    const lifecycle: VerificationLifecycle = {
      status: data.status,
      issuedAt: data.issued_at,
      revokedAt: data.revoked_at,
      revocationReason: data.revocation_reason,
      supersededBy: data.superseded_by_number,
    };

    const now = new Date().toISOString();
    const result: VerificationResult = {
      schemaVersion: VERIFICATION_SCHEMA_VERSION,
      artifactType: this.id,
      reference,
      verifiedAt: now,
      identity,
      lifecycle,
      verification: {
        status: extras.status,
        method: 'generated-document-reference',
        timestamp: now,
      },
      metadata: {
        document_uuid: data.document_uuid,
        entity_type: data.entity_type,
        entity_id: data.entity_id,
      },
      links: {
        self: `/api/v1/public/verification/verify/${encodeURIComponent(reference)}`,
      },
    };

    if (data.checksum_sha256) {
      result.integrity = {
        checksumAlgorithm: env.CHECKSUM_ALGORITHM,
        checksumValue: data.checksum_sha256,
        checksumVerified: true,
      };
    }

    const signatures = this.buildSignatures(extras.signatures);
    if (signatures) {
      result.signatures = signatures;
    }

    const history: NonNullable<VerificationResult['history']> = {};
    if (data.superseded_by_number) {
      history.supersededBy = data.superseded_by_number;
      result.links!.supersededBy = `/api/v1/public/verification/verify/${encodeURIComponent(data.superseded_by_number)}`;
    }
    if (extras.versions.length > 1) {
      history.previousVersion = String(extras.versions[extras.versions.length - 2].version_no);
    }
    if (extras.versions.length > 0) {
      history.versions = extras.versions.map((v) => ({
        versionNo: v.version_no,
        issuedAt: v.created_at ? new Date(v.created_at).toISOString() : undefined,
      }));
    }
    if (extras.audit.length > 0) {
      history.audit = extras.audit.map((a) => ({
        actionType: a.action_type,
        actorName: a.actor_name,
        timestamp: a.action_timestamp ? new Date(a.action_timestamp).toISOString() : undefined,
        details: a.details ?? undefined,
      }));
    }
    if (Object.keys(history).length > 0) {
      result.history = history;
    }

    return result;
  }

  private buildSignatures(rows: any[]): VerificationSignatures | undefined {
    if (!rows || rows.length === 0) return undefined;
    const requiredCount = rows.filter((s) => s.is_required).length;
    const completedCount = rows.filter((s) => s.signature_status === 'SIGNED').length;
    const status: VerificationSignatures['status'] =
      requiredCount > 0 && completedCount >= requiredCount
        ? 'COMPLETE'
        : requiredCount > 0
          ? 'INCOMPLETE'
          : 'NONE';
    return {
      status,
      requiredCount,
      completedCount,
      timeline: rows.map((s) => ({
        signerName: s.signer_name,
        signerTitle: s.signer_title,
        signatureType: s.signature_type,
        isRequired: s.is_required,
        status: s.signature_status,
        signedAt: s.signed_at ? new Date(s.signed_at).toISOString() : null,
        signatureHash: s.signature_hash,
      })),
    };
  }
}
