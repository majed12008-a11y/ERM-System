import { describe, it, expect, vi, beforeEach } from 'vitest';
import { DocumentService } from '../services/document.service';
import { FormService } from '../services/form.service';

const owner = {
  id: 65,
  uuid: 'u-65',
  institution_id: 1,
  username: 'owner',
  email: 'owner@test.com',
  status: 'ACTIVE',
  roles: [],
  is_email_verified: true,
};

const admin = {
  id: 1,
  uuid: 'u-1',
  institution_id: 1,
  username: 'admin',
  email: 'admin@test.com',
  status: 'ACTIVE',
  roles: ['SUPER_ADMIN'],
  is_email_verified: true,
};

const signer = {
  id: 66,
  uuid: 'u-66',
  institution_id: 1,
  username: 'signer',
  email: 'signer@test.com',
  status: 'ACTIVE',
  roles: [],
  is_email_verified: true,
};

const doc = {
  id: 10,
  document_number: 'DOC-010',
  document_uuid: 'uuid-10',
  document_title: 'Official doc',
  document_type_id: 1,
  entity_type: 'Form',
  entity_id: 3,
  file_name: 'doc.pdf',
  mime_type: 'application/pdf',
  storage_path: 'uploads/doc.pdf',
  uploaded_by: owner.id,
  status: 'ISSUED',
  lifecycle_state_id: 5,
  checksum_sha256: 'abc',
  is_immutable: true,
};

describe('DocumentService multi-signature slots', () => {
  let service: DocumentService;
  let repo: any;

  beforeEach(() => {
    repo = {
      findById: vi.fn(),
      findSignature: vi.fn(),
      addSignatureSlot: vi.fn(),
      signSlot: vi.fn(),
      logAudit: vi.fn(),
    };
    service = new DocumentService(repo);
    vi.clearAllMocks();
  });

  it('owner can create a PENDING slot', async () => {
    repo.findById.mockResolvedValue(doc);
    repo.addSignatureSlot.mockResolvedValue({ id: 7, document_id: 10, signer_id: signer.id, signature_status: 'PENDING' });

    const slot = await service.addSignatureSlot(10, {
      signer_id: signer.id,
      signature_type: 'CHAIR',
      signature_order: 2,
      signer_title: 'Committee Chair',
      is_required: true,
    }, owner);

    expect(slot.signature_status).toBe('PENDING');
    expect(repo.addSignatureSlot).toHaveBeenCalledWith(10, {
      signer_id: signer.id,
      signature_type: 'CHAIR',
      signature_order: 2,
      signer_title: 'Committee Chair',
      is_required: true,
    });
    expect(repo.logAudit).toHaveBeenCalledWith(10, 'SIGNATURE_SLOT_ADDED', owner.id, expect.objectContaining({ signature_type: 'CHAIR' }));
  });

  it('admin can create a slot for a document they do not own', async () => {
    repo.findById.mockResolvedValue(doc);
    repo.addSignatureSlot.mockResolvedValue({ id: 8, signature_status: 'PENDING' });

    await service.addSignatureSlot(10, { signer_id: signer.id, signature_type: 'APPROVER' }, admin);
    expect(repo.addSignatureSlot).toHaveBeenCalledTimes(1);
  });

  it('non-owner non-admin cannot add a slot', async () => {
    repo.findById.mockResolvedValue(doc);
    const err = await service.addSignatureSlot(10, { signer_id: signer.id, signature_type: 'CHAIR' }, signer).catch((e: any) => e);
    expect(err.status).toBe(403);
    expect(repo.addSignatureSlot).not.toHaveBeenCalled();
  });

  it('returns 404 for a missing document', async () => {
    repo.findById.mockResolvedValue(null);
    const err = await service.addSignatureSlot(999, { signer_id: signer.id, signature_type: 'CHAIR' }, owner).catch((e: any) => e);
    expect(err.status).toBe(404);
  });

  it('signs an existing PENDING slot without creating a duplicate', async () => {
    repo.findById.mockResolvedValue(doc);
    repo.findSignature.mockResolvedValue({ id: 7, document_id: 10, signer_id: owner.id, signature_status: 'PENDING' });
    repo.signSlot.mockResolvedValue({ id: 7, signature_status: 'SIGNED', signed_at: '2026-08-03T10:00:00.000Z' });

    const signed = await service.sign(10, owner);

    expect(signed.signature_status).toBe('SIGNED');
    expect(repo.addSignatureSlot).not.toHaveBeenCalled();
    expect(repo.signSlot).toHaveBeenCalledWith(10, owner.id, expect.any(String));
    expect(repo.logAudit).toHaveBeenCalledWith(10, 'SIGNED', owner.id, expect.objectContaining({ signature_id: 7 }));
  });

  it('creates a PENDING slot then signs it when the user has no slot', async () => {
    repo.findById.mockResolvedValue(doc);
    repo.findSignature.mockResolvedValue(null);
    repo.addSignatureSlot.mockResolvedValue({ id: 9, signer_id: owner.id, signature_status: 'PENDING' });
    repo.signSlot.mockResolvedValue({ id: 9, signature_status: 'SIGNED' });

    const signed = await service.sign(10, owner);

    expect(repo.addSignatureSlot).toHaveBeenCalledWith(10, {
      signer_id: owner.id,
      signature_type: 'ELECTRONIC',
      signature_order: 1,
      is_required: true,
    });
    expect(signed.id).toBe(9);
  });

  it('rejects signing when the user already has a SIGNED slot', async () => {
    repo.findById.mockResolvedValue(doc);
    repo.findSignature.mockResolvedValue({ id: 5, signer_id: owner.id, signature_status: 'SIGNED' });

    const err = await service.sign(10, owner).catch((e: any) => e);
    expect(err.status).toBe(400);
    expect(err.message).toBe('Already signed');
    expect(repo.signSlot).not.toHaveBeenCalled();
  });

  it('rejects signing when slot creation is blocked (RLS)', async () => {
    repo.findById.mockResolvedValue(doc);
    repo.findSignature.mockResolvedValue(null);
    repo.addSignatureSlot.mockResolvedValue(undefined);

    const err = await service.sign(10, owner).catch((e: any) => e);
    expect(err.status).toBe(403);
    expect(err.message).toBe('Not authorized to sign this document');
  });
});

describe('FormService strict slot signing', () => {
  let service: FormService;
  let renderRepo: any;

  beforeEach(() => {
    renderRepo = {
      findDocumentById: vi.fn(),
      signSlot: vi.fn(),
      logAudit: vi.fn(),
    };
    service = new FormService(undefined, undefined, undefined, renderRepo);
    vi.clearAllMocks();
  });

  it('signs the signer PENDING slot and records audit', async () => {
    renderRepo.findDocumentById.mockResolvedValue(doc);
    renderRepo.signSlot.mockResolvedValue({ id: 12, document_id: 10, signer_id: signer.id, signature_status: 'SIGNED', signed_at: '2026-08-03T10:00:00.000Z' });

    const signed = await service.signDocument(10, signer, 'CHAIR');

    expect(signed.signature_status).toBe('SIGNED');
    expect(renderRepo.signSlot).toHaveBeenCalledWith(10, signer.id, expect.any(String));
    expect(renderRepo.logAudit).toHaveBeenCalledWith(10, 'SIGNED', signer.id, expect.objectContaining({ signature_type: 'CHAIR' }));
  });

  it('rejects a signer without a pre-assigned PENDING slot', async () => {
    renderRepo.findDocumentById.mockResolvedValue(doc);
    renderRepo.signSlot.mockResolvedValue(null);

    const err = await service.signDocument(10, signer, 'CHAIR').catch((e: any) => e);
    expect(err.status).toBe(400);
    expect(err.message).toMatch(/No pending signature slot/);
  });

  it('rejects signing a terminal document', async () => {
    renderRepo.findDocumentById.mockResolvedValue({ ...doc, status: 'ARCHIVED', lifecycle_state_id: 10 });
    const err = await service.signDocument(10, signer, 'CHAIR').catch((e: any) => e);
    expect(err.status).toBe(400);
    expect(renderRepo.signSlot).not.toHaveBeenCalled();
  });

  it('returns 404 for a missing document', async () => {
    renderRepo.findDocumentById.mockResolvedValue(null);
    const err = await service.signDocument(999, signer, 'CHAIR').catch((e: any) => e);
    expect(err.status).toBe(404);
  });
});
