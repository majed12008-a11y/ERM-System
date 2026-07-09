import { AuditableRepository } from './auditable.repository';

export interface ApprovalCertificateRow {
  id: number;
  application_id: number;
  serial_number: string;
  version_no: number;
  status: string;
  issued_to_user_id: number;
  issued_by_user_id: number;
  issued_at: Date;
  revoked_at: Date | null;
  revoked_by: number | null;
  revocation_reason: string | null;
  superseded_by: number | null;
  generation_error: any;
  metadata: any;
  created_at: Date;
  created_by: number | null;
}

export interface CertificateDocumentRow {
  id: number;
  certificate_id: number;
  document_id: number;
  is_original: boolean;
  generated_at: Date;
}

export interface VerificationLogRow {
  id: number;
  serial_number: string;
  verified_at: Date;
  verified_by_ip: string | null;
  result: string;
  details: any;
}

export interface CertificateVerificationData {
  serialNumber: string;
  status: string;
  certificateType: string;
  issuingAuthority: string;
  issuingAuthorityEn: string;
  committeeName: string;
  committeeNameEn: string;
  researcherName: string;
  projectTitle: string;
  applicationNumber: string;
  institutionName: string;
  issuedAt: string;
  expiresAt: string | null;
  revokedAt?: string;
  revocationReason?: string;
  supersededBySerial?: string;
  verifiedAt: string;
}

export class CertificateRepository extends AuditableRepository {
  async findByApplication(applicationId: number): Promise<ApprovalCertificateRow[]> {
    const result = await this.query(
      `SELECT * FROM documents.approval_certificates
       WHERE application_id = $1
       ORDER BY version_no DESC`,
      [applicationId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<ApprovalCertificateRow | null> {
    const result = await this.query(
      `SELECT * FROM documents.approval_certificates WHERE id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findBySerial(serialNumber: string): Promise<ApprovalCertificateRow | null> {
    const result = await this.query(
      `SELECT * FROM documents.approval_certificates WHERE serial_number = $1`,
      [serialNumber]
    );
    return result.rows[0] || null;
  }

  async findActiveByApplication(applicationId: number): Promise<ApprovalCertificateRow | null> {
    const result = await this.query(
      `SELECT * FROM documents.approval_certificates
       WHERE application_id = $1 AND status IN ('ISSUED', 'GENERATING', 'DRAFT')
       LIMIT 1`,
      [applicationId]
    );
    return result.rows[0] || null;
  }

  async findLatestByApplication(applicationId: number): Promise<ApprovalCertificateRow | null> {
    const result = await this.query(
      `SELECT * FROM documents.approval_certificates
       WHERE application_id = $1
       ORDER BY version_no DESC LIMIT 1`,
      [applicationId]
    );
    return result.rows[0] || null;
  }

  async create(data: {
    application_id: number;
    serial_number: string;
    version_no: number;
    status: string;
    issued_to_user_id: number;
    issued_by_user_id: number;
    metadata?: any;
  }): Promise<ApprovalCertificateRow> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO documents.approval_certificates
        (application_id, serial_number, version_no, status, issued_to_user_id, issued_by_user_id, metadata, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING *`,
      [
        data.application_id, data.serial_number, data.version_no, data.status,
        data.issued_to_user_id, data.issued_by_user_id,
        data.metadata ? JSON.stringify(data.metadata) : null,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async updateStatus(id: number, status: string, extra?: {
    generation_error?: any;
  }): Promise<void> {
    const sets: string[] = ['status = $2'];
    const params: any[] = [id, status];
    if (extra?.generation_error !== undefined) {
      sets.push('generation_error = $3');
      params.push(JSON.stringify(extra.generation_error));
    }
    params.push(params.length + 1);
    sets.push(`updated_at = $${params.length}, updated_by = $${params.length + 1}`);
    const num = params.length;
    params.push(new Date(), this.getCurrentUserId());

    await this.query(
      `UPDATE documents.approval_certificates SET ${sets.join(', ')} WHERE id = $1`,
      params
    );
  }

  async markIssued(id: number): Promise<void> {
    await this.query(
      `UPDATE documents.approval_certificates
       SET status = 'ISSUED', issued_at = now(), generation_error = NULL, updated_at = now(), updated_by = $1
       WHERE id = $2`,
      [this.getCurrentUserId(), id]
    );
  }

  async revoke(id: number, reason: string, revokedBy: number): Promise<void> {
    await this.query(
      `UPDATE documents.approval_certificates
       SET status = 'REVOKED', revoked_at = now(), revoked_by = $1, revocation_reason = $2,
           updated_at = now(), updated_by = $1
       WHERE id = $3 AND status = 'ISSUED'`,
      [revokedBy, reason, id]
    );
  }

  async supersede(id: number, supersededById: number): Promise<void> {
    await this.query(
      `UPDATE documents.approval_certificates
       SET status = 'SUPERSEDED', superseded_by = $1, updated_at = now(), updated_by = $2
       WHERE id = $3 AND status = 'ISSUED'`,
      [supersededById, this.getCurrentUserId(), id]
    );
  }

  async getMaxVersion(applicationId: number): Promise<number> {
    const result = await this.query(
      `SELECT COALESCE(MAX(version_no), 0) as max_ver FROM documents.approval_certificates WHERE application_id = $1`,
      [applicationId]
    );
    return parseInt(result.rows[0].max_ver);
  }

  async acquireAdvisoryLock(applicationId: number): Promise<void> {
    await this.query(`SELECT pg_advisory_xact_lock(hashtext('cert_gen_' || $1::text))`, [applicationId]);
  }

  async getVerificationData(serialNumber: string): Promise<CertificateVerificationData | null> {
    const result = await this.query(
      `SELECT * FROM documents.fn_get_certificate_verification($1)`,
       [serialNumber]
     );
     if (!result.rows[0]) return null;

    const row = result.rows[0];
    return {
      serialNumber: row.serial_number,
      status: row.status,
      certificateType: row.certificate_type,
      issuingAuthority: row.issuing_authority,
      issuingAuthorityEn: row.issuing_authority_en,
      committeeName: row.committee_name,
      committeeNameEn: row.committee_name_en,
      researcherName: row.researcher_name,
      projectTitle: row.project_title,
      applicationNumber: row.application_number,
      institutionName: row.institution_name,
      issuedAt: row.issued_at,
      expiresAt: null,
      revokedAt: row.revoked_at ? new Date(row.revoked_at).toISOString() : undefined,
      revocationReason: row.revocation_reason || undefined,
      supersededBySerial: row.superseded_by_serial || undefined,
      verifiedAt: new Date().toISOString(),
    };
  }

  async logVerification(serialNumber: string, ip: string | null, result: string, details?: any): Promise<void> {
    await this.query(
      `INSERT INTO documents.certificate_verification_log (serial_number, verified_by_ip, result, details)
       VALUES ($1, $2, $3, $4)`,
      [serialNumber, ip, result, details ? JSON.stringify(details) : null]
    );
  }

  async linkDocument(certificateId: number, documentId: number, isOriginal: boolean): Promise<CertificateDocumentRow> {
    const result = await this.query(
      `INSERT INTO documents.approval_certificate_documents (certificate_id, document_id, is_original)
       VALUES ($1, $2, $3) RETURNING *`,
      [certificateId, documentId, isOriginal]
    );
    return result.rows[0];
  }

  async getLinkedDocuments(certificateId: number): Promise<CertificateDocumentRow[]> {
    const result = await this.query(
      `SELECT * FROM documents.approval_certificate_documents WHERE certificate_id = $1 ORDER BY generated_at`,
      [certificateId]
    );
    return result.rows;
  }

  async getTemplateContent(templateCode: string): Promise<string | null> {
    const result = await this.query(
      `SELECT template_content FROM documents.templates WHERE template_code = $1`,
      [templateCode]
    );
    return result.rows[0]?.template_content || null;
  }

  async getApplicationBuildContext(applicationId: number): Promise<{
    application_number: string; submitted_by: number; created_by: number | null;
    title_ar: string; institution_id: number;
    researcher_name: string; committee_name: string; committee_name_en: string;
    institution_name: string;
  } | null> {
    const result = await this.query(
      `SELECT
         a.application_number, a.submitted_by, a.created_by,
         p.title_ar, p.institution_id,
         u.username as researcher_name,
          com.committee_name_ar as committee_name, com.committee_name_en as committee_name_en,
         inst.name_ar as institution_name
       FROM core.applications a
       JOIN core.projects p ON p.id = a.project_id
       JOIN security.users u ON u.id = a.submitted_by
        JOIN committee.committees com ON com.id = a.target_committee_id
        JOIN security.institutions inst ON inst.id = p.institution_id
        WHERE a.id = $1`,
       [applicationId]
    );
    return result.rows[0] || null;
  }

  async getBasicApplicationData(applicationId: number): Promise<{ application_number: string; submitted_by: number } | null> {
    const result = await this.query(
      `SELECT application_number, submitted_by FROM core.applications WHERE id = $1`,
      [applicationId]
    );
    return result.rows[0] || null;
  }

  async getEthicsAdmins(): Promise<number[]> {
    const result = await this.query(
      `SELECT ur.user_id FROM security.user_roles ur
       JOIN security.roles r ON ur.role_id = r.id
       WHERE r.name = 'ETHICS_ADMIN' AND ur.is_active = TRUE`
    );
    return result.rows.map(r => r.user_id);
  }
}
