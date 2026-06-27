/*
 * مستودع المستندات والملفات: رفع، تنزيل،
 * حذف منطقي، وتصنيف المستندات حسب أنواعها
 * وارتباطها بالكيانات المختلفة.
 */
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class DocumentRepository extends AuditableRepository {
  async findAll(params: PaginationParams): Promise<{ rows: any[]; total: number }> {
    const countResult = await this.query('SELECT COUNT(*) FROM documents.documents');
    const total = parseInt(countResult.rows[0].count);

    const result = await this.query(
      `SELECT d.*, dt.type_name_ar, u.username as uploaded_by_username
       FROM documents.documents d
       LEFT JOIN documents.document_types dt ON d.document_type_id = dt.id
       LEFT JOIN security.users u ON d.uploaded_by = u.id
       ORDER BY d.uploaded_at DESC
       LIMIT $1 OFFSET $2`,
      [params.limit, (params.page - 1) * params.limit]
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT d.*, dt.type_name_ar, u.username as uploaded_by_username
       FROM documents.documents d
       LEFT JOIN documents.document_types dt ON d.document_type_id = dt.id
       LEFT JOIN security.users u ON d.uploaded_by = u.id
       WHERE d.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findByEntity(entityType: string, entityId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT d.*, dt.type_name_ar, u.username as uploaded_by_username
       FROM documents.documents d
       LEFT JOIN documents.document_types dt ON d.document_type_id = dt.id
       LEFT JOIN security.users u ON d.uploaded_by = u.id
       WHERE d.entity_type = $1 AND d.entity_id = $2
       ORDER BY d.uploaded_at DESC`,
      [entityType, entityId]
    );
    return result.rows;
  }

  async create(data: {
    document_type_id?: number; entity_type?: string; entity_id?: number;
    document_title: string; file_name: string; mime_type: string;
    storage_path: string; uploaded_by: number; file_size_bytes?: number;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO documents.documents
        (document_type_id, entity_type, entity_id, document_title, file_name, mime_type, file_size_bytes, storage_path, uploaded_by, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
       RETURNING *`,
      [
        data.document_type_id || null, data.entity_type || null, data.entity_id || null,
        data.document_title, data.file_name, data.mime_type,
        data.file_size_bytes || null, data.storage_path, data.uploaded_by,
        meta.created_by, meta.created_at,
      ]
    );
    return result.rows[0];
  }

  async softDelete(id: number): Promise<{ deleted: boolean; storage_path?: string }> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE documents.documents SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL RETURNING storage_path`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    if (result.rows.length === 0) return { deleted: false };
    return { deleted: true, storage_path: result.rows[0].storage_path };
  }

  async getTypes(): Promise<any[]> {
    const result = await this.query('SELECT * FROM documents.document_types ORDER BY type_name_ar');
    return result.rows;
  }

  async getClassifications(): Promise<any[]> {
    const result = await this.query(
      'SELECT id, code, name_ar, name_en, description, clearance_required FROM documents.document_classifications WHERE is_active = true ORDER BY clearance_required'
    );
    return result.rows;
  }

  async getSignatures(documentId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ds.*, u.username as signer_name, u.username as display_name
       FROM documents.document_signatures ds
       LEFT JOIN security.users u ON ds.signer_id = u.id
       WHERE ds.document_id = $1
       ORDER BY ds.signed_at`,
      [documentId]
    );
    return result.rows;
  }

  async addSignature(documentId: number, signerId: number, signatureHash: string): Promise<any> {
    const result = await this.query(
      `INSERT INTO documents.document_signatures (document_id, signer_id, signature_type, signature_hash, signed_at)
       VALUES ($1, $2, 'ELECTRONIC', $3, now()) RETURNING *`,
      [documentId, signerId, signatureHash]
    );
    return result.rows[0];
  }

  async findSignature(documentId: number, signerId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT id FROM documents.document_signatures WHERE document_id = $1 AND signer_id = $2`,
      [documentId, signerId]
    );
    return result.rows[0] || null;
  }

  async getPendingSignatures(userId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT d.*, dt.type_name_ar
       FROM documents.documents d
       LEFT JOIN documents.document_types dt ON d.document_type_id = dt.id
       WHERE d.id NOT IN (
         SELECT document_id FROM documents.document_signatures WHERE signer_id = $1
       )
       AND (d.entity_type = 'MeetingMinutes' OR d.entity_type = 'Decision')
       ORDER BY d.uploaded_at DESC`,
      [userId]
    );
    return result.rows;
  }
}
