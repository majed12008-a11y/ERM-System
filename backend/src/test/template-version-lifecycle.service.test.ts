import { describe, it, expect, vi, beforeEach } from 'vitest';
import {
  VersionLifecycleService,
  checkLifecyclePermission,
  checkTransitionPreconditions,
} from '../services/template-version-lifecycle.service';
import type { VersionData } from '../services/template-version-lifecycle.service';

const mockVersion: VersionData = {
  id: 1,
  template_id: 1,
  version: '1.0.0',
  status: 'DRAFT',
  content: { ar: { body: 'test content' }, en: { body: 'test content' } },
  content_hash: 'abc123',
  variable_definitions: [],
  change_summary: 'Initial draft',
  effective_from: null,
  effective_until: null,
  retired_at: null,
  approved_by: null,
  approved_at: null,
  created_by: 5,
  created_at: new Date(),
};

const adminUser = {
  id: 10, uuid: '', institution_id: 1, username: 'admin',
  email: 'admin@test.com', status: 'ACTIVE',
  roles: ['ETHICS_ADMIN'], is_email_verified: true,
};

const chairUser = {
  id: 11, uuid: '', institution_id: 1, username: 'chair',
  email: 'chair@test.com', status: 'ACTIVE',
  roles: ['ETHICS_CHAIR'], is_email_verified: true,
};

const regularUser = {
  id: 12, uuid: '', institution_id: 1, username: 'user',
  email: 'user@test.com', status: 'ACTIVE',
  roles: ['APPLICANT'], is_email_verified: true,
};

const creatorUser = {
  ...regularUser, id: 5, // same as mockVersion.created_by
};

describe('VersionLifecycleService', () => {
  let service: VersionLifecycleService;
  let mockVersionRepo: any;
  let mockAuditRepo: any;
  let mockApprovalRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      updateStatus: vi.fn(),
      findApproved: vi.fn(),
      deprecateCurrentApproved: vi.fn(),
      updateEffectiveDates: vi.fn(),
    };
    mockAuditRepo = {
      log: vi.fn().mockResolvedValue({ id: 1 }),
      findByVersionId: vi.fn(),
    };
    mockApprovalRepo = {
      findByVersionId: vi.fn().mockResolvedValue([]),
      allStepsApproved: vi.fn().mockResolvedValue(true),
    };

    service = new VersionLifecycleService(mockVersionRepo, mockAuditRepo, mockApprovalRepo);
  });

  // ─── Submit ─────────────────────────────────────────────

  describe('submit', () => {
    it('transitions DRAFT → REVIEW for admin', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });

      const result = await service.submit('TPL-001', '1.0.0', adminUser, 'Ready');

      expect(result.status).toBe('REVIEW');
      expect(mockVersionRepo.updateStatus).toHaveBeenCalledWith(1, 'REVIEW', 10);
      expect(mockAuditRepo.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'SUBMITTED', previous_status: 'DRAFT', new_status: 'REVIEW' }),
      );
    });

    it('allows creator to submit their own DRAFT', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });

      const result = await service.submit('TPL-001', '1.0.0', creatorUser, 'Ready');

      expect(result.status).toBe('REVIEW');
    });

    it('rejects submit from non-DRAFT status', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'APPROVED' });

      const err = await service.submit('TPL-001', '1.0.0', adminUser, '').catch((e: any) => e);
      expect(err.status).toBe(400);
      expect(err.message).toContain('Invalid transition');
    });

    it('rejects submit from unauthorized user', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });

      const err = await service.submit('TPL-001', '1.0.0', regularUser, '').catch((e: any) => e);
      expect(err.status).toBe(403);
      expect(err.message).toContain('Not authorized');
    });

    it('throws 404 when version not found', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(null);

      const err = await service.submit('NONEXIST', '1.0.0', adminUser, '').catch((e: any) => e);
      expect(err.status).toBe(404);
    });
  });

  // ─── Approve ────────────────────────────────────────────

  describe('approve', () => {
    it('transitions REVIEW → APPROVED', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW', id: 2 });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'APPROVED', id: 2 });
      mockVersionRepo.deprecateCurrentApproved.mockResolvedValue(null);

      const result = await service.approve('TPL-001', '1.0.0', adminUser);

      expect(result.status).toBe('APPROVED');
      expect(mockAuditRepo.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'APPROVED' }),
      );
    });

    it('deprecates previous APPROVED version', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW', id: 2, template_id: 1 });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'APPROVED', id: 2 });
      mockVersionRepo.deprecateCurrentApproved.mockResolvedValue({ ...mockVersion, status: 'DEPRECATED', id: 1 });

      await service.approve('TPL-001', '1.0.0', adminUser);

      expect(mockVersionRepo.deprecateCurrentApproved).toHaveBeenCalledWith(1, expect.any(Date));
    });

    it('rejects approve from non-REVIEW status', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });

      const err = await service.approve('TPL-001', '1.0.0', adminUser).catch((e: any) => e);
      expect(err.status).toBe(400);
    });

    it('rejects approve from unauthorized user', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });

      const err = await service.approve('TPL-001', '1.0.0', regularUser).catch((e: any) => e);
      expect(err.status).toBe(403);
    });

    it('rejects approve when approval workflow incomplete', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW', id: 1 });
      mockApprovalRepo.findByVersionId.mockResolvedValue([{ id: 1, status: 'PENDING' }]);
      mockApprovalRepo.allStepsApproved.mockResolvedValue(false);

      const err = await service.approve('TPL-001', '1.0.0', adminUser).catch((e: any) => e);
      expect(err.status).toBe(400);
      expect(err.message).toContain('APPROVED');
    });
  });

  // ─── Reject ─────────────────────────────────────────────

  describe('reject', () => {
    it('transitions REVIEW → DRAFT', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });

      const result = await service.reject('TPL-001', '1.0.0', adminUser, 'Needs revision');

      expect(result.status).toBe('DRAFT');
      expect(mockAuditRepo.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'REJECTED' }),
      );
    });

    it('requires rejection reason', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });

      const err = await service.reject('TPL-001', '1.0.0', adminUser, '').catch((e: any) => e);
      expect(err.status).toBe(400);
      expect(err.message).toContain('reason');
    });

    it('rejects reject from DRAFT status', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });

      const err = await service.reject('TPL-001', '1.0.0', adminUser, 'bad').catch((e: any) => e);
      expect(err.status).toBe(400);
    });
  });

  // ─── Deprecate ──────────────────────────────────────────

  describe('deprecate', () => {
    it('transitions APPROVED → DEPRECATED', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'APPROVED' });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'DEPRECATED' });

      const result = await service.deprecate('TPL-001', '1.0.0', adminUser, 'Superseded by v2');

      expect(result.status).toBe('DEPRECATED');
      expect(mockAuditRepo.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'DEPRECATED' }),
      );
    });
  });

  // ─── Archive ────────────────────────────────────────────

  describe('archive', () => {
    it('transitions DEPRECATED → ARCHIVED', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DEPRECATED' });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'ARCHIVED' });

      const result = await service.archive('TPL-001', '1.0.0', adminUser, 'End of life');

      expect(result.status).toBe('ARCHIVED');
      expect(mockAuditRepo.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'ARCHIVED' }),
      );
    });
  });

  // ─── Rollback ───────────────────────────────────────────

  describe('rollback', () => {
    it('transitions DEPRECATED → APPROVED', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DEPRECATED', id: 2, template_id: 1 });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'APPROVED', id: 2 });
      mockVersionRepo.findApproved.mockResolvedValue(null);
      mockVersionRepo.updateEffectiveDates.mockResolvedValue({ ...mockVersion, status: 'APPROVED', id: 2 });

      const result = await service.rollback('TPL-001', '1.0.0', adminUser, 'Rollback');

      expect(result.status).toBe('APPROVED');
      expect(mockVersionRepo.updateEffectiveDates).toHaveBeenCalledWith(2, null, null);
      expect(mockAuditRepo.log).toHaveBeenCalledWith(
        expect.objectContaining({ action: 'ROLLED_BACK' }),
      );
    });

    it('deprecates current active version on rollback', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DEPRECATED', id: 2, template_id: 1 });
      mockVersionRepo.updateStatus.mockResolvedValue({ ...mockVersion, status: 'APPROVED', id: 2 });
      mockVersionRepo.findApproved.mockResolvedValue({ ...mockVersion, status: 'APPROVED', id: 3 });
      mockVersionRepo.updateEffectiveDates.mockResolvedValue({ ...mockVersion, status: 'APPROVED', id: 2 });

      await service.rollback('TPL-001', '1.0.0', adminUser, 'Revert to 1.0.0');

      expect(mockVersionRepo.deprecateCurrentApproved).toHaveBeenCalledWith(1, expect.any(Date));
    });
  });

  // ─── isVersionActive ─────────────────────────────────────

  describe('isVersionActive', () => {
    it('returns true for APPROVED with no effective dates', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'APPROVED' });

      const result = await service.isVersionActive('TPL-001', '1.0.0');
      expect(result).toBe(true);
    });

    it('returns false for non-APPROVED status', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });

      const result = await service.isVersionActive('TPL-001', '1.0.0');
      expect(result).toBe(false);
    });

    it('returns false for future-dated version', async () => {
      const future = new Date(Date.now() + 86400000 * 30);
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'APPROVED', effective_from: future });

      const result = await service.isVersionActive('TPL-001', '1.0.0');
      expect(result).toBe(false);
    });

    it('returns false for expired version', async () => {
      const past = new Date(Date.now() - 86400000);
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'APPROVED', effective_until: past });

      const result = await service.isVersionActive('TPL-001', '1.0.0');
      expect(result).toBe(false);
    });
  });

  // ─── History & Approval Status ─────────────────────────

  describe('getTransitionHistory', () => {
    it('returns audit entries for a version', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(mockVersion);
      mockAuditRepo.findByVersionId.mockResolvedValue([{ id: 1, action: 'CREATED' }]);

      const history = await service.getTransitionHistory('TPL-001', '1.0.0');
      expect(history).toHaveLength(1);
      expect(mockAuditRepo.findByVersionId).toHaveBeenCalledWith(1);
    });
  });

  describe('getApprovalStatus', () => {
    it('returns approval steps for a version', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(mockVersion);
      mockApprovalRepo.findByVersionId.mockResolvedValue([{ id: 1, status: 'PENDING' }]);

      const status = await service.getApprovalStatus('TPL-001', '1.0.0');
      expect(status).toHaveLength(1);
    });
  });
});

// ─── Authorization Tests ──────────────────────────────────

describe('checkLifecyclePermission', () => {
  const ver = { ...mockVersion, status: 'DRAFT', created_by: 5 };

  it('allows admin any action', () => {
    expect(() => checkLifecyclePermission('ARCHIVED', ver, adminUser)).not.toThrow();
  });

  it('allows creator to SUBMIT', () => {
    expect(() => checkLifecyclePermission('SUBMITTED', { ...ver, status: 'DRAFT' }, creatorUser)).not.toThrow();
  });

  it('allows chair to APPROVE', () => {
    expect(() => checkLifecyclePermission('APPROVED', { ...ver, status: 'REVIEW' }, chairUser)).not.toThrow();
  });

  it('allows chair to REJECT', () => {
    expect(() => checkLifecyclePermission('REJECTED', { ...ver, status: 'REVIEW' }, chairUser)).not.toThrow();
  });

  it('denies regular user from approving', () => {
    expect(() => checkLifecyclePermission('APPROVED', { ...ver, status: 'REVIEW' }, regularUser)).toThrow();
  });

  it('denies non-creator from submitting', () => {
    expect(() => checkLifecyclePermission('SUBMITTED', { ...ver, status: 'DRAFT' }, regularUser)).toThrow();
  });
});

// ─── Precondition Tests ───────────────────────────────────

describe('checkTransitionPreconditions', () => {
  it('rejects rejection without reason', () => {
    expect(() => checkTransitionPreconditions('REJECTED', mockVersion, '')).toThrow();
  });

  it('accepts rejection with reason', () => {
    expect(() => checkTransitionPreconditions('REJECTED', mockVersion, 'Needs work')).not.toThrow();
  });
});
