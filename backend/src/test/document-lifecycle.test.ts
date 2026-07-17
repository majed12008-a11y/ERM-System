import { describe, it, expect, vi, beforeEach } from 'vitest';
import { DocumentService } from '../services/document.service';
import { DocumentRepository } from '../repositories/document.repository';
import fs from 'fs';

vi.mock('../../repositories/document.repository');

function makeDoc(overrides: any = {}) {
  return {
    id: 1,
    document_type_id: 1,
    entity_type: 'Application',
    entity_id: 100,
    document_title: 'Test Document',
    file_name: 'test.pdf',
    mime_type: 'application/pdf',
    file_size_bytes: 1024,
    storage_path: '/uploads/test.pdf',
    uploaded_by: 1,
    uploaded_by_username: 'admin',
    type_name_ar: 'مستند',
    uploaded_at: new Date(),
    created_at: new Date(),
    deleted_at: null,
    ...overrides,
  };
}

describe('DocumentService — lifecycle', () => {
  let service: DocumentService;
  let repo: any;

  beforeEach(() => {
    vi.clearAllMocks();
    repo = {
      findAll: vi.fn(),
      findById: vi.fn(),
      findByEntity: vi.fn(),
      create: vi.fn(),
      softDelete: vi.fn(),
      restore: vi.fn(),
      getTypes: vi.fn(),
      getClassifications: vi.fn(),
      getSignatures: vi.fn(),
      getPendingSignatures: vi.fn(),
      addSignature: vi.fn(),
      findSignature: vi.fn(),
    };
    service = new DocumentService(repo);
  });

  describe('softDelete', () => {
    it('should soft-delete a document without removing physical file', async () => {
      repo.softDelete.mockResolvedValue({ deleted: true, storage_path: '/uploads/test.pdf' });
      const result = await service.softDelete(1);
      expect(result).toEqual({ id: 1 });
      expect(repo.softDelete).toHaveBeenCalledWith(1);
    });

    it('should throw 404 if document not found', async () => {
      repo.softDelete.mockResolvedValue({ deleted: false });
      await expect(service.softDelete(999)).rejects.toMatchObject({ status: 404 });
    });

    it('should NOT call fs.unlink (P0 fix)', async () => {
      const unlinkSpy = vi.spyOn(fs.promises, 'unlink');
      repo.softDelete.mockResolvedValue({ deleted: true, storage_path: '/uploads/test.pdf' });
      await service.softDelete(1);
      expect(unlinkSpy).not.toHaveBeenCalled();
      unlinkSpy.mockRestore();
    });
  });

  describe('getById', () => {
    it('should return document metadata', async () => {
      const doc = makeDoc();
      repo.findById.mockResolvedValue(doc);
      const result = await service.getById(1);
      expect(result).toEqual(doc);
    });

    it('should throw 404 if not found', async () => {
      repo.findById.mockResolvedValue(null);
      await expect(service.getById(999)).rejects.toMatchObject({ status: 404 });
    });

    it('should throw 410 if soft-deleted', async () => {
      repo.findById.mockResolvedValue(makeDoc({ deleted_at: new Date() }));
      await expect(service.getById(1)).rejects.toMatchObject({ status: 410 });
    });
  });

  describe('restore', () => {
    it('should restore a soft-deleted document', async () => {
      repo.findById.mockResolvedValue(makeDoc({ deleted_at: new Date() }));
      repo.restore.mockResolvedValue(true);
      const result = await service.restore(1);
      expect(result).toEqual({ id: 1 });
      expect(repo.restore).toHaveBeenCalledWith(1);
    });

    it('should throw 400 if document is not deleted', async () => {
      repo.findById.mockResolvedValue(makeDoc({ deleted_at: null }));
      await expect(service.restore(1)).rejects.toMatchObject({ status: 400 });
    });

    it('should throw 404 if document not found', async () => {
      repo.findById.mockResolvedValue(null);
      await expect(service.restore(999)).rejects.toMatchObject({ status: 404 });
    });
  });

  describe('upload', () => {
    it('should upload with file', async () => {
      const file = { originalname: 'test.pdf', mimetype: 'application/pdf', path: '/uploads/test.pdf', size: 1024 } as Express.Multer.File;
      repo.create.mockResolvedValue(makeDoc());
      const result = await service.upload(file, {}, { id: 1 } as any);
      expect(repo.create).toHaveBeenCalled();
      expect(result).toBeDefined();
    });

    it('should upload without file (metadata only)', async () => {
      repo.create.mockResolvedValue(makeDoc());
      const result = await service.upload(undefined, { file_name: 'test.pdf', mime_type: 'application/pdf', document_title: 'Test' }, { id: 1 } as any);
      expect(repo.create).toHaveBeenCalled();
    });
  });

  describe('sign', () => {
    it('should sign a document', async () => {
      repo.findById.mockResolvedValue(makeDoc());
      repo.findSignature.mockResolvedValue(null);
      repo.addSignature.mockResolvedValue({ id: 1, document_id: 1, signer_id: 1, signature_hash: 'abc' });
      const result = await service.sign(1, { id: 1 } as any);
      expect(result).toBeDefined();
      expect(repo.addSignature).toHaveBeenCalled();
    });

    it('should throw 400 if already signed', async () => {
      repo.findById.mockResolvedValue(makeDoc());
      repo.findSignature.mockResolvedValue({ id: 1 });
      await expect(service.sign(1, { id: 1 } as any)).rejects.toMatchObject({ status: 400 });
    });
  });

  describe('storage helpers', () => {
    it('getStoragePath returns storage_path', () => {
      const doc = makeDoc();
      expect(service.getStoragePath(doc)).toBe('/uploads/test.pdf');
    });

    it('getMimeType returns mime_type', () => {
      const doc = makeDoc();
      expect(service.getMimeType(doc)).toBe('application/pdf');
    });

    it('getMimeType defaults to octet-stream', () => {
      expect(service.getMimeType({})).toBe('application/octet-stream');
    });

    it('getFileName returns file_name', () => {
      const doc = makeDoc();
      expect(service.getFileName(doc)).toBe('test.pdf');
    });

    it('getFileName falls back to document_title', () => {
      expect(service.getFileName({ document_title: 'My Doc' })).toBe('My Doc');
    });
  });
});
