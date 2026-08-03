/*
 * مستودع محرك المستندات: استرجاع القالب النشط حسب (الرمز، اللغة)،
 * وكتابة نواتج التوليد في: documents.documents,
 * documents.document_versions, documents.generated_documents,
 * documents.document_audit، وإدارة دورة حياة الوثيقة
 * (الإصدارات، السحب، الإبطال) وقراءة سجل التدقيق.
 */
import { AuditableRepository } from './auditable.repository';

export interface TemplateRow {
  id: number;
  template_code: string;
  template_name: string;
  template_type: string;
  template_content: string;
  version_no: number;
  is_active: boolean;
  language: string;
  document_category: string | null;
  is_default: boolean;
}

export interface DocumentInsert {
  document_type_id: number;
  entity_type: string;
  entity_id: number;
  document_title: string;
  file_name: string;
  mime_type: string;
  storage_path: string;
  uploaded_by: number;
  file_size_bytes: number;
  checksum_sha256: string;
  document_number: string;
  document_uuid: string;
  current_version_no: number;
  template_code: string;
  template_version: number;
  language: string;
  supersedes_version_no?: number | null;
  superseded_by_document_id?: number | null;
}

export class DocumentRenderRepository extends AuditableRepository {
  async findActiveTemplate(templateCode: string, language: string): Promise<TemplateRow | null> {
    const result = await this.query(
      `SELECT * FROM documents.templates
       WHERE template_code = $1 AND is_active = true
       ORDER BY (language = $2) DESC, is_default DESC, version_no DESC
       LIMIT 1`,
      [templateCode, language]
    );
    return result.rows[0] || null;
  }

  async findTemplateByCodeVersion(templateCode: string, language: string, versionNo: number): Promise<TemplateRow | null> {
    const result = await this.query(
      `SELECT * FROM documents.templates
       WHERE template_code = $1 AND language = $2 AND version_no = $3
       LIMIT 1`,
      [templateCode, language, versionNo]
    );
    return result.rows[0] || null;
  }

  async findDocumentById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM documents.documents WHERE id = $1 LIMIT 1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findDocumentsByEntity(entityType: string, entityId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT d.*, dt.type_name_ar,
              (SELECT COUNT(*) FROM documents.document_versions v WHERE v.document_id = d.id) AS version_count,
              (SELECT COUNT(*) FROM documents.document_signatures s WHERE s.document_id = d.id) AS signature_count,
              (SELECT COUNT(*) FROM documents.document_audit a WHERE a.document_id = d.id) AS audit_count
       FROM documents.documents d
       LEFT JOIN documents.document_types dt ON d.document_type_id = dt.id
       WHERE d.entity_type = $1 AND d.entity_id = $2
       ORDER BY d.uploaded_at DESC`,
      [entityType, entityId]
    );
    return result.rows;
  }

  async findDocumentTypeId(typeCode: string): Promise<number | null> {
    const result = await this.query(
      `SELECT id FROM documents.document_types WHERE type_code = $1 LIMIT 1`,
      [typeCode]
    );
    return result.rows[0]?.id ?? null;
  }

  async findLatestVersionByEntity(entityType: string, entityId: number, templateCode: string, language: string): Promise<any | null> {
    const result = await this.query(
      `SELECT d.*, v.id AS version_id, v.supersedes_version_id
       FROM documents.documents d
       JOIN documents.document_versions v ON v.document_id = d.id
       WHERE d.entity_type = $1 AND d.entity_id = $2
         AND d.template_code = $3 AND d.language = $4
         AND d.status IN ('OFFICIAL', 'SUPERSEDED')
       ORDER BY d.current_version_no DESC
       LIMIT 1`,
      [entityType, entityId, templateCode, language]
    );
    return result.rows[0] || null;
  }

  async createDocument(data: DocumentInsert): Promise<number> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO documents.documents
        (document_type_id, entity_type, entity_id, document_title, file_name, mime_type,
         file_size_bytes, storage_path, checksum_sha256, uploaded_by,
         document_number, document_uuid, status, is_immutable, current_version_no,
         template_code, template_version, language,
         supersedes_version_no, superseded_by_document_id,
         is_active, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10,
               $11, $12, 'OFFICIAL', true, $13,
               $14, $15, $16,
               $17, $18,
               true, $19, $20)
       RETURNING id`,
      [
        data.document_type_id, data.entity_type, data.entity_id,
        data.document_title, data.file_name, data.mime_type,
        data.file_size_bytes, data.storage_path, data.checksum_sha256, data.uploaded_by,
        data.document_number, data.document_uuid, data.current_version_no,
        data.template_code, data.template_version, data.language,
        data.supersedes_version_no ?? null, data.superseded_by_document_id ?? null,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0].id;
  }

  async createVersion(data: {
    document_id: number;
    version_no: number;
    file_name: string;
    storage_path: string;
    checksum_sha256: string;
    uploaded_by: number;
    version_notes?: string;
    document_uuid?: string;
    template_code?: string;
    template_version?: number;
    language?: string;
    supersedes_version_id?: number | null;
  }): Promise<void> {
    const meta = this.createMeta();
    await this.query(
      `INSERT INTO documents.document_versions
        (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, version_notes,
         document_uuid, template_code, template_version, language, supersedes_version_id,
         created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)`,
      [
        data.document_id, data.version_no, data.file_name, data.storage_path,
        data.checksum_sha256, data.uploaded_by, data.version_notes || null,
        data.document_uuid || null, data.template_code || null,
        data.template_version || null, data.language || null,
        data.supersedes_version_id ?? null,
        meta.created_by, meta.created_at,
      ]
    );
  }

  async createGenerated(data: {
    template_id: number;
    entity_type: string;
    entity_id: number;
    generated_document_id: number;
    generated_by: number;
    generation_parameters: any;
  }): Promise<void> {
    const meta = this.createMeta();
    await this.query(
      `INSERT INTO documents.generated_documents
        (template_id, entity_type, entity_id, generated_document_id, generated_by, generation_parameters, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8)`,
      [
        data.template_id, data.entity_type, data.entity_id,
        data.generated_document_id, data.generated_by,
        JSON.stringify(data.generation_parameters), meta.created_by, meta.created_at,
      ]
    );
  }

  async logAudit(documentId: number, actionType: string, actionBy: number, details?: any): Promise<void> {
    await this.query(
      `INSERT INTO documents.document_audit (document_id, action_type, action_by, details)
       VALUES ($1, $2, $3, $4)`,
      [documentId, actionType, actionBy, details ? JSON.stringify(details) : null]
    );
  }

  async getDocumentVersions(documentId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM documents.document_versions
       WHERE document_id = $1
       ORDER BY version_no ASC`,
      [documentId]
    );
    return result.rows;
  }

  async getDocumentAudit(documentId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT da.*, u.username AS actor_name
       FROM documents.document_audit da
       LEFT JOIN security.users u ON u.id = da.action_by
       WHERE da.document_id = $1
       ORDER BY da.action_timestamp ASC`,
      [documentId]
    );
    return result.rows;
  }

  async getDocumentSignatures(documentId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ds.*, u.username AS signer_name
       FROM documents.document_signatures ds
       LEFT JOIN security.users u ON u.id = ds.signer_id
       WHERE ds.document_id = $1
       ORDER BY ds.signature_order ASC, ds.id ASC`,
      [documentId]
    );
    return result.rows;
  }

  async listSignatureTypes(): Promise<any[]> {
    const result = await this.query(
      `SELECT code, name_ar, name_en FROM documents.document_signature_types
       WHERE is_active = TRUE ORDER BY sort_order`
    );
    return result.rows;
  }

  async addSignatureSlot(
    documentId: number,
    data: { signer_id: number; signature_type: string; signature_order: number; signer_title?: string; is_required: boolean }
  ): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO documents.document_signatures
        (document_id, signer_id, signature_type, signature_order, signature_status, signer_title, is_required, created_by, created_at)
       VALUES ($1, $2, $3, $4, 'PENDING', $5, $6, $7, $8)
       RETURNING *`,
      [
        documentId, data.signer_id, data.signature_type, data.signature_order,
        data.signer_title || null, data.is_required, meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async signSlot(documentId: number, signerId: number, signatureHash: string): Promise<any | null> {
    const result = await this.query(
      `UPDATE documents.document_signatures
          SET signature_status = 'SIGNED',
              signature_hash = $3,
              signed_at = now(),
              verification_metadata = jsonb_build_object('signed_by', $2, 'signature_type', signature_type)
        WHERE document_id = $1 AND signer_id = $2 AND signature_status = 'PENDING'
        RETURNING *`,
      [documentId, signerId, signatureHash]
    );
    return result.rows[0] || null;
  }

  async addSignature(documentId: number, signerId: number, signatureType: string, signatureHash: string): Promise<any> {
    const result = await this.query(
      `INSERT INTO documents.document_signatures
        (document_id, signer_id, signature_type, signature_hash, signed_at)
       VALUES ($1, $2, $3, $4, now())
       RETURNING *`,
      [documentId, signerId, signatureType, signatureHash]
    );
    return result.rows[0];
  }

  async setDocumentStatus(
    documentId: number,
    status: 'REVOKED' | 'VOID',
    reason: string,
    actorId: number
  ): Promise<{ ok: boolean; reason?: string }> {
    const result = await this.query(
      `UPDATE documents.documents
       SET status = $1, revoked_at = now(), revoked_by = $2, revocation_reason = $3
       WHERE id = $4 AND status = 'OFFICIAL'
       RETURNING id`,
      [status, actorId, reason, documentId]
    );
    return { ok: result.rows.length > 0 };
  }

  async markSuperseded(oldDocumentId: number, newDocumentId: number): Promise<void> {
    await this.query(
      `UPDATE documents.documents
       SET status = 'SUPERSEDED', superseded_by_document_id = $1
       WHERE id = $2`,
      [newDocumentId, oldDocumentId]
    );
  }

  async logVerification(reference: string, ip: string | null, result: string, details?: any): Promise<void> {
    await this.query(
      `INSERT INTO documents.document_verification_log (reference, verified_by_ip, result, details)
       VALUES ($1, $2, $3, $4)`,
      [reference, ip, result, details ? JSON.stringify(details) : null]
    );
  }

  async getVerificationData(reference: string): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM documents.fn_verify_generated_document($1)`,
      [reference]
    );
    return result.rows[0] || null;
  }
}
