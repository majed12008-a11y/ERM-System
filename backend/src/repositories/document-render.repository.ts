/*
 * مستودع محرك المستندات: استرجاع القالب النشط حسب (الرمز، اللغة)،
 * وكتابة نواتج التوليد في: documents.documents,
 * documents.document_versions, documents.generated_documents,
 * documents.document_audit.
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

  async findDocumentTypeId(typeCode: string): Promise<number | null> {
    const result = await this.query(
      `SELECT id FROM documents.document_types WHERE type_code = $1 LIMIT 1`,
      [typeCode]
    );
    return result.rows[0]?.id ?? null;
  }

  async createDocument(data: DocumentInsert): Promise<number> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO documents.documents
        (document_type_id, entity_type, entity_id, document_title, file_name, mime_type,
         file_size_bytes, storage_path, checksum_sha256, uploaded_by, is_active, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, true, $11, $12)
       RETURNING id`,
      [
        data.document_type_id, data.entity_type, data.entity_id,
        data.document_title, data.file_name, data.mime_type,
        data.file_size_bytes, data.storage_path, data.checksum_sha256, data.uploaded_by,
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
  }): Promise<void> {
    const meta = this.createMeta();
    await this.query(
      `INSERT INTO documents.document_versions
        (document_id, version_no, file_name, storage_path, checksum_sha256, uploaded_by, version_notes, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)`,
      [
        data.document_id, data.version_no, data.file_name, data.storage_path,
        data.checksum_sha256, data.uploaded_by, data.version_notes || null,
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
}
