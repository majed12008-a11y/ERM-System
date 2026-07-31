import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ApprovalWorkflowService } from '../services/template-approval-workflow.service';
import type { ApprovalStepRow } from '../repositories/template-approval-workflow.repository';
import type { VersionData } from '../services/template-version-lifecycle.service';
import type { AuthUser } from '../shared/types';

const mockVersion: VersionData = {
  id: 1,
  template_id: 1,
  version: '1.0.0',
  status: 'DRAFT',
  content: { ar: { body: 'test' } },
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

const adminUser: AuthUser = {
  id: 10, uuid: '', institution_id: 1, username: 'admin',
  email: 'admin@test.com', status: 'ACTIVE',
  roles: ['ETHICS_ADMIN'], is_email_verified: true,
};

const chairUser: AuthUser = {
  id: 11, uuid: '', institution_id: 1, username: 'chair',
  email: 'chair@test.com', status: 'ACTIVE',
  roles: ['ETHICS_CHAIR'], is_email_verified: true,
};

const reviewerUser: AuthUser = {
  id: 12, uuid: '', institution_id: 1, username: 'reviewer',
  email: 'reviewer@test.com', status: 'ACTIVE',
  roles: ['ETHICS_REVIEWER'], is_email_verified: true,
};

const regularUser: AuthUser = {
  id: 13, uuid: '', institution_id: 1, username: 'user',
  email: 'user@test.com', status: 'ACTIVE',
  roles: ['APPLICANT'], is_email_verified: true,
};

const creatorUser: AuthUser = {
  id: 5, uuid: '', institution_id: 1, username: 'creator',
  email: 'creator@test.com', status: 'ACTIVE',
  roles: ['APPLICANT'], is_email_verified: true,
};

const mockStep: ApprovalStepRow = {
  id: 1,
  template_version_id: 1,
  step_order: 1,
  approver_role: 'ETHICS_REVIEWER',
  approver_id: null,
  status: 'PENDING',
  comments: null,
  acted_by: null,
  acted_at: null,
  created_at: new Date(),
};

// ─── Policy Tests ───────────────────────────────────────────

describe('ApprovalWorkflowService — Policy', () => {
  let service: ApprovalWorkflowService;
  let mockApprovalRepo: any;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockApprovalRepo = {
      createSteps: vi.fn(),
      findByVersionId: vi.fn(),
      findById: vi.fn(),
      approveStep: vi.fn(),
      rejectStep: vi.fn(),
      allStepsApproved: vi.fn(),
      cancelPendingSteps: vi.fn(),
    };
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    service = new ApprovalWorkflowService(mockApprovalRepo, mockVersionRepo);
  });

  describe('canApproveStep', () => {
    it('allows admin to approve any step', () => {
      expect(service.canApproveStep(adminUser, mockStep)).toBe(true);
    });

    it('allows chair to approve step with matching role', () => {
      const chairStep = { ...mockStep, approver_role: 'ETHICS_CHAIR' };
      expect(service.canApproveStep(chairUser, chairStep)).toBe(true);
    });

    it('allows reviewer to approve step with matching role', () => {
      expect(service.canApproveStep(reviewerUser, mockStep)).toBe(true);
    });

    it('allows step-assigned user by approver_id', () => {
      const assignedStep = { ...mockStep, approver_id: 20 };
      const assignedUser: AuthUser = { ...regularUser, id: 20 };
      expect(service.canApproveStep(assignedUser, assignedStep)).toBe(true);
    });

    it('allows user matching approver_role', () => {
      const roleStep = { ...mockStep, approver_role: 'ETHICS_REVIEWER' };
      expect(service.canApproveStep(reviewerUser, roleStep)).toBe(true);
    });

    it('denies regular user without matching role or id', () => {
      expect(service.canApproveStep(regularUser, mockStep)).toBe(false);
    });

    it('denies user not matching approver_role', () => {
      const roleStep = { ...mockStep, approver_role: 'ETHICS_ADMIN' };
      expect(service.canApproveStep(reviewerUser, roleStep)).toBe(false);
    });
  });

  describe('canInitiateApproval', () => {
    it('allows admin to initiate', () => {
      expect(service.canInitiateApproval(adminUser, mockVersion)).toBe(true);
    });

    it('allows version creator to initiate', () => {
      expect(service.canInitiateApproval(creatorUser, mockVersion)).toBe(true);
    });

    it('denies non-creator regular user', () => {
      expect(service.canInitiateApproval(regularUser, mockVersion)).toBe(false);
    });
  });

  describe('canCancelApproval', () => {
    it('allows admin to cancel', () => {
      expect(service.canCancelApproval(adminUser, mockVersion)).toBe(true);
    });

    it('denies regular user to cancel', () => {
      expect(service.canCancelApproval(regularUser, mockVersion)).toBe(false);
    });

    it('denies creator to cancel', () => {
      expect(service.canCancelApproval(creatorUser, mockVersion)).toBe(false);
    });
  });
});

// ─── Service Method Tests ───────────────────────────────────

describe('ApprovalWorkflowService — Methods', () => {
  let service: ApprovalWorkflowService;
  let mockApprovalRepo: any;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockApprovalRepo = {
      createSteps: vi.fn(),
      findByVersionId: vi.fn(),
      findById: vi.fn(),
      approveStep: vi.fn(),
      rejectStep: vi.fn(),
      allStepsApproved: vi.fn(),
      cancelPendingSteps: vi.fn(),
    };
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    service = new ApprovalWorkflowService(mockApprovalRepo, mockVersionRepo);
  });

  // ─── Initiate Approval ──────────────────────────────────

  describe('initiateApproval', () => {
    it('creates approval steps for a DRAFT version', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });
      mockApprovalRepo.findByVersionId.mockResolvedValue([]);
      mockApprovalRepo.createSteps.mockResolvedValue([
        { ...mockStep, id: 1, step_order: 1 },
        { ...mockStep, id: 2, step_order: 2, approver_role: 'ETHICS_ADMIN' },
      ]);

      const result = await service.initiateApproval(
        'TPL-001', '1.0.0',
        [
          { approver_role: 'ETHICS_REVIEWER' },
          { approver_role: 'ETHICS_ADMIN' },
        ],
        creatorUser,
      );

      expect(result.steps).toHaveLength(2);
      expect(mockApprovalRepo.createSteps).toHaveBeenCalledWith(
        expect.arrayContaining([
          expect.objectContaining({ template_version_id: 1, step_order: 1, approver_role: 'ETHICS_REVIEWER' }),
          expect.objectContaining({ template_version_id: 1, step_order: 2, approver_role: 'ETHICS_ADMIN' }),
        ]),
      );
      expect(result.readyForApproval).toBe(false);
    });

    it('allows admin to initiate for any version', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });
      mockApprovalRepo.findByVersionId.mockResolvedValue([]);
      mockApprovalRepo.createSteps.mockResolvedValue([mockStep]);

      const result = await service.initiateApproval(
        'TPL-001', '1.0.0',
        [{ approver_role: 'ETHICS_ADMIN' }],
        adminUser,
      );

      expect(result.steps).toHaveLength(1);
    });

    it('rejects initiate when steps array is empty', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });
      mockApprovalRepo.findByVersionId.mockResolvedValue([]);

      const err = await service.initiateApproval(
        'TPL-001', '1.0.0', [], creatorUser,
      ).catch((e: any) => e);

      expect(err.status).toBe(400);
      expect(err.message).toContain('required');
    });

    it('rejects initiate when workflow already exists', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });
      mockApprovalRepo.findByVersionId.mockResolvedValue([mockStep]);

      const err = await service.initiateApproval(
        'TPL-001', '1.0.0',
        [{ approver_role: 'ETHICS_REVIEWER' }],
        creatorUser,
      ).catch((e: any) => e);

      expect(err.status).toBe(409);
    });

    it('rejects initiate from unauthorized user', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });

      const err = await service.initiateApproval(
        'TPL-001', '1.0.0',
        [{ approver_role: 'ETHICS_REVIEWER' }],
        regularUser,
      ).catch((e: any) => e);

      expect(err.status).toBe(403);
    });

    it('throws 404 when version not found', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(null);

      const err = await service.initiateApproval(
        'NONEXIST', '1.0.0',
        [{ approver_role: 'ETHICS_REVIEWER' }],
        adminUser,
      ).catch((e: any) => e);

      expect(err.status).toBe(404);
    });
  });

  // ─── Approve Step ───────────────────────────────────────

  describe('approveStep', () => {
    it('approves a pending step', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue(mockStep);
      mockApprovalRepo.approveStep.mockResolvedValue({ ...mockStep, status: 'APPROVED', acted_by: 10, acted_at: new Date() });
      mockApprovalRepo.allStepsApproved.mockResolvedValue(true);

      const result = await service.approveStep('TPL-001', '1.0.0', 1, adminUser, 'Looks good');

      expect(result.step.status).toBe('APPROVED');
      expect(result.fullyApproved).toBe(true);
      expect(result.audit).toBeDefined();
      expect(result.audit.action).toBe('APPROVED');
      expect(result.audit.actor).toBe(10);
      expect(result.audit.previousState).toBe('PENDING');
      expect(result.audit.newState).toBe('APPROVED');
    });

    it('reports not fully approved when steps remain pending', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue(mockStep);
      mockApprovalRepo.approveStep.mockResolvedValue({ ...mockStep, status: 'APPROVED', acted_by: 10, acted_at: new Date() });
      mockApprovalRepo.allStepsApproved.mockResolvedValue(false);

      const result = await service.approveStep('TPL-001', '1.0.0', 1, adminUser);

      expect(result.fullyApproved).toBe(false);
    });

    it('rejects approve when version is not in REVIEW', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'DRAFT' });

      const err = await service.approveStep('TPL-001', '1.0.0', 1, adminUser).catch((e: any) => e);
      expect(err.status).toBe(400);
      expect(err.message).toContain('DRAFT');
    });

    it('rejects approve when step does not belong to version', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW', id: 2 });
      mockApprovalRepo.findById.mockResolvedValue(mockStep);

      const err = await service.approveStep('TPL-001', '1.0.0', 1, adminUser).catch((e: any) => e);
      expect(err.status).toBe(400);
      expect(err.message).toContain('not belong');
    });

    it('rejects approve when step already acted upon', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue({ ...mockStep, status: 'APPROVED' });

      const err = await service.approveStep('TPL-001', '1.0.0', 1, adminUser).catch((e: any) => e);
      expect(err.status).toBe(400);
      expect(err.message).toContain('already');
    });

    it('rejects approve from unauthorized user', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue({ ...mockStep, approver_role: 'ETHICS_ADMIN' });

      const err = await service.approveStep('TPL-001', '1.0.0', 1, regularUser).catch((e: any) => e);
      expect(err.status).toBe(403);
    });

    it('throws 404 when step not found', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue(null);

      const err = await service.approveStep('TPL-001', '1.0.0', 999, adminUser).catch((e: any) => e);
      expect(err.status).toBe(404);
    });
  });

  // ─── Reject Step ────────────────────────────────────────

  describe('rejectStep', () => {
    it('rejects a pending step', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue(mockStep);
      mockApprovalRepo.rejectStep.mockResolvedValue({ ...mockStep, status: 'REJECTED', acted_by: 10, acted_at: new Date() });

      const result = await service.rejectStep('TPL-001', '1.0.0', 1, adminUser, 'Needs revision');

      expect(result.step.status).toBe('REJECTED');
      expect(result.audit).toBeDefined();
      expect(result.audit.action).toBe('REJECTED');
      expect(result.audit.reason).toBe('Needs revision');
    });

    it('rejects reject from unauthorized user', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue({ ...mockStep, approver_role: 'ETHICS_ADMIN' });

      const err = await service.rejectStep('TPL-001', '1.0.0', 1, regularUser, 'No').catch((e: any) => e);
      expect(err.status).toBe(403);
    });
  });

  // ─── Get Status ─────────────────────────────────────────

  describe('getStatus', () => {
    it('returns full approval status DTO', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(mockVersion);
      mockApprovalRepo.findByVersionId.mockResolvedValue([
        { ...mockStep, id: 1, status: 'APPROVED' },
        { ...mockStep, id: 2, step_order: 2, status: 'PENDING' },
      ]);

      const status = await service.getStatus('TPL-001', '1.0.0');

      expect(status.totalSteps).toBe(2);
      expect(status.approvedSteps).toBe(1);
      expect(status.pendingSteps).toBe(1);
      expect(status.rejectedSteps).toBe(0);
      expect(status.isFullyApproved).toBe(false);
    });

    it('returns isFullyApproved=true when all steps approved', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(mockVersion);
      mockApprovalRepo.findByVersionId.mockResolvedValue([
        { ...mockStep, id: 1, status: 'APPROVED' },
        { ...mockStep, id: 2, step_order: 2, status: 'APPROVED' },
      ]);

      const status = await service.getStatus('TPL-001', '1.0.0');
      expect(status.isFullyApproved).toBe(true);
    });

    it('returns zero counts when no workflow exists', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(mockVersion);
      mockApprovalRepo.findByVersionId.mockResolvedValue([]);

      const status = await service.getStatus('TPL-001', '1.0.0');
      expect(status.totalSteps).toBe(0);
      expect(status.isFullyApproved).toBe(false);
    });
  });

  // ─── Cancel Approval ────────────────────────────────────

  describe('cancelApproval', () => {
    it('cancels all pending steps', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(mockVersion);
      mockApprovalRepo.cancelPendingSteps.mockResolvedValue([
        { ...mockStep, status: 'REJECTED', comments: 'Cancelled by admin' },
      ]);

      const result = await service.cancelApproval('TPL-001', '1.0.0', adminUser, 'Workflow obsolete');

      expect(result).toHaveLength(1);
      expect(mockApprovalRepo.cancelPendingSteps).toHaveBeenCalledWith(1, 10, 'Workflow obsolete');
    });

    it('denies non-admin from cancelling', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue(mockVersion);

      const err = await service.cancelApproval('TPL-001', '1.0.0', regularUser).catch((e: any) => e);
      expect(err.status).toBe(403);
    });
  });

  // ─── Consistency with Lifecycle State Machine ──────────

  describe('workflow consistency', () => {
    it('approveStep returns audit metadata for every action', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue(mockStep);
      mockApprovalRepo.approveStep.mockResolvedValue({ ...mockStep, status: 'APPROVED', acted_by: 10 });
      mockApprovalRepo.allStepsApproved.mockResolvedValue(true);

      const result = await service.approveStep('TPL-001', '1.0.0', 1, adminUser, 'ok');

      expect(result.audit).toMatchObject({
        action: 'APPROVED',
        actor: 10,
        previousState: 'PENDING',
        newState: 'APPROVED',
        stepId: 1,
        templateVersionId: 1,
        stepOrder: 1,
      });
      expect(result.audit.timestamp).toBeInstanceOf(Date);
    });

    it('rejectStep returns audit metadata', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });
      mockApprovalRepo.findById.mockResolvedValue(mockStep);
      mockApprovalRepo.rejectStep.mockResolvedValue({ ...mockStep, status: 'REJECTED', acted_by: 10 });

      const result = await service.rejectStep('TPL-001', '1.0.0', 1, adminUser, 'no');

      expect(result.audit).toMatchObject({
        action: 'REJECTED',
        previousState: 'PENDING',
        newState: 'REJECTED',
        reason: 'no',
      });
    });

    it('initiateApproval only valid for DRAFT versions', async () => {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValue({ ...mockVersion, status: 'REVIEW' });

      const err = await service.initiateApproval(
        'TPL-001', '1.0.0',
        [{ approver_role: 'ETHICS_REVIEWER' }],
        adminUser,
      ).catch((e: any) => e);

      expect(err.status).toBe(400);
    });
  });
});
