/*
 * إدارة المستندات والملفات المرفقة: تحميل، تنزيل،
 * حذف، تصنيف. يتعامل مع نظام الملفات المحلي
 * ويسجل البيانات الوصفية في قاعدة البيانات مع RLS.
 */
import path from 'path';
import fs from 'fs';
import crypto from 'crypto';
import { DocumentRepository } from '../repositories/document.repository';
import { AuthUser } from '../shared/types';
import { PaginationParams } from '../shared/pagination';

const UPLOAD_DIR = path.resolve('uploads');
if (!fs.existsSync(UPLOAD_DIR)) {
  fs.mkdirSync(UPLOAD_DIR, { recursive: true });
}

export class DocumentService {
  constructor(private repo = new DocumentRepository()) {}

  async getAll(params: PaginationParams) {
    const { rows, total } = await this.repo.findAll(params);
    return {
      data: rows,
      pagination: { page: params.page, limit: params.limit, total, totalPages: Math.ceil(total / params.limit) },
    };
  }

  async getTypes() { return this.repo.getTypes(); }
  async getClassifications() { return this.repo.getClassifications(); }
  async getByEntity(entityType: string, entityId: number) {
    return this.repo.findByEntity(entityType, entityId);
  }
  async getSignatures(documentId: number) { return this.repo.getSignatures(documentId); }
  async getPendingSignatures(user: AuthUser) { return this.repo.getPendingSignatures(user.id); }

  async upload(file: Express.Multer.File | undefined, body: any, user: AuthUser): Promise<any> {
    if (file) {
      return this.repo.create({
        document_type_id: body.document_type_id,
        entity_type: body.entity_type,
        entity_id: body.entity_id,
        document_title: body.document_title || file.originalname,
        file_name: file.originalname,
        mime_type: file.mimetype,
        storage_path: file.path,
        uploaded_by: user.id,
        file_size_bytes: file.size,
      });
    }

    return this.repo.create({
      document_type_id: body.document_type_id,
      entity_type: body.entity_type,
      entity_id: body.entity_id,
      document_title: body.document_title,
      file_name: body.file_name,
      mime_type: body.mime_type,
      storage_path: '/uploads/' + body.file_name,
      uploaded_by: user.id,
    });
  }

  async sign(documentId: number, user: AuthUser, signatureType: string = 'ELECTRONIC'): Promise<any> {
    const doc = await this.repo.findById(documentId);
    if (!doc) throw Object.assign(new Error('Document not found'), { status: 404 });

    const existing = await this.repo.findSignature(documentId, user.id);
    if (existing && existing.signature_status === 'SIGNED') {
      throw Object.assign(new Error('Already signed'), { status: 400 });
    }

    let slot = existing && existing.signature_status === 'PENDING'
      ? existing
      : await this.repo.addSignatureSlot(documentId, {
          signer_id: user.id,
          signature_type: signatureType,
          signature_order: 1,
          is_required: true,
        });
    if (!slot) {
      throw Object.assign(new Error('Not authorized to sign this document'), { status: 403 });
    }

    const raw = `${user.id}-${documentId}-${slot.id}-${Date.now()}`;
    const hash = crypto.createHash('sha256').update(raw).digest('hex');

    const signed = await this.repo.signSlot(documentId, user.id, hash);
    if (!signed) throw Object.assign(new Error('No pending signature slot for this user'), { status: 400 });

    await this.repo.logAudit(documentId, 'SIGNED', user.id, {
      signature_id: signed.id,
      signature_type: signed.signature_type,
    });
    return signed;
  }

  async addSignatureSlot(
    documentId: number,
    signatory: { signer_id: number; signature_type: string; signature_order?: number; signer_title?: string; is_required?: boolean },
    user: AuthUser
  ): Promise<any> {
    const doc = await this.repo.findById(documentId);
    if (!doc) throw Object.assign(new Error('Document not found'), { status: 404 });

    const isAdmin = user.roles?.some((r: string) => ['SUPER_ADMIN', 'ETHICS_ADMIN', 'ADMIN', 'SYS_ADMIN'].includes(r));
    if (doc.uploaded_by !== user.id && !isAdmin) {
      throw Object.assign(new Error('Only the document owner or an admin can add signature slots'), { status: 403 });
    }

    const result = await this.repo.addSignatureSlot(documentId, {
      signer_id: signatory.signer_id,
      signature_type: signatory.signature_type,
      signature_order: signatory.signature_order ?? 1,
      signer_title: signatory.signer_title,
      is_required: signatory.is_required ?? true,
    });

    await this.repo.logAudit(documentId, 'SIGNATURE_SLOT_ADDED', user.id, {
      signature_id: result.id,
      signature_type: signatory.signature_type,
    });
    return result;
  }

  async softDelete(id: number): Promise<void> {
    const result = await this.repo.softDelete(id);
    if (!result.deleted) throw Object.assign(new Error('Document not found or already deleted'), { status: 404 });

    if (result.storage_path) {
      try { await fs.promises.unlink(result.storage_path); } catch { /* file may not exist */ }
    }
  }
}
