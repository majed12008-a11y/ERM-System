import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ConditionService } from '../services/condition.service';

vi.mock('../services/notification.service', () => {
  class MockNotificationService {
    async send() { return undefined; }
  }
  return {
    NotificationService: MockNotificationService,
  };
});

describe('ConditionService', () => {
  let service: ConditionService;
  let mockRepo: any;

  beforeEach(() => {
    mockRepo = {
      findByApplication: vi.fn(),
      findByIdIncludingDeleted: vi.fn(),
      create: vi.fn(),
      update: vi.fn(),
      resolveStatus: vi.fn(),
      softDelete: vi.fn(),
      getOpenCount: vi.fn(),
      getUnmetConditionIds: vi.fn(),
      evaluateEvidenceCoverage: vi.fn(),
      countByStatus: vi.fn(),
      getApplicationStatus: vi.fn(),
      getApplicationOwner: vi.fn().mockResolvedValue(null),
      getApplicationTargetCommittee: vi.fn().mockResolvedValue(null),
      getCommitteeChair: vi.fn().mockResolvedValue(null),
      getCommitteeMembers: vi.fn().mockResolvedValue([]),
      getEthicsAdmins: vi.fn().mockResolvedValue([]),
    };
    service = new ConditionService(mockRepo);
    vi.clearAllMocks();
  });

  const mockUser = {
    id: 10,
    uuid: '',
    institution_id: 1,
    username: 'admin',
    email: 'admin@test.com',
    status: 'ACTIVE',
    roles: ['ETHICS_ADMIN'],
    is_email_verified: true,
  };

  const sampleCondition = {
    id: 1,
    application_id: 100,
    condition_text: 'Provide additional safety data',
    severity: 'MAJOR',
    category: 'SCIENTIFIC',
    due_date: null,
    status: 'OPEN',
    resolved_by: null,
    resolved_at: null,
    created_at: new Date(),
    created_by: 5,
    updated_at: null,
    updated_by: null,
    deleted_at: null,
    deleted_by: null,
  };

  // ─── getConditions ───
  describe('getConditions', () => {
    it('returns conditions for an application', async () => {
      mockRepo.findByApplication.mockResolvedValue([sampleCondition]);
      const result = await service.getConditions(100);
      expect(result).toHaveLength(1);
      expect(mockRepo.findByApplication).toHaveBeenCalledWith(100);
    });

    it('returns empty array when no conditions', async () => {
      mockRepo.findByApplication.mockResolvedValue([]);
      const result = await service.getConditions(999);
      expect(result).toEqual([]);
    });
  });

  // ─── createCondition ───
  describe('createCondition', () => {
    it('creates a condition with defaults', async () => {
      mockRepo.create.mockResolvedValue({ ...sampleCondition, id: 2 });
      const result = await service.createCondition(100, {
        condition_text: 'Test condition',
      }, mockUser);
      expect(result.id).toBe(2);
      expect(mockRepo.create).toHaveBeenCalledWith({
        application_id: 100,
        condition_text: 'Test condition',
        severity: undefined,
        category: undefined,
        due_date: undefined,
      });
    });
  });

  // ─── updateCondition ───
  describe('updateCondition', () => {
    it('updates a condition', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue(sampleCondition);
      mockRepo.update.mockResolvedValue({ ...sampleCondition, condition_text: 'Updated' });
      const result = await service.updateCondition(1, { condition_text: 'Updated' }, mockUser);
      expect(mockRepo.update).toHaveBeenCalledWith(1, { condition_text: 'Updated' });
    });

    it('throws 404 when condition not found', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue(null);
      const err = await service.updateCondition(999, { condition_text: 'x' }, mockUser).catch(e => e);
      expect(err.status).toBe(404);
    });

    it('throws 404 when condition is soft-deleted', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue({ ...sampleCondition, deleted_at: new Date() });
      const err = await service.updateCondition(1, { condition_text: 'x' }, mockUser).catch(e => e);
      expect(err.status).toBe(404);
    });
  });

  // ─── resolveCondition — transition safety ───
  describe('resolveCondition', () => {
    // Allowed transitions
    it.each([
      ['OPEN', 'MET'],
      ['OPEN', 'NOT_MET'],
      ['OPEN', 'WAIVED'],
      ['NOT_MET', 'MET'],
      ['NOT_MET', 'WAIVED'],
    ])('allows %s → %s', async (from, to) => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue({ ...sampleCondition, status: from });
      mockRepo.resolveStatus.mockResolvedValue({ ...sampleCondition, status: to });
      const result = await service.resolveCondition(1, to, mockUser);
      expect(result.status).toBe(to);
      expect(mockRepo.resolveStatus).toHaveBeenCalledWith(1, to, mockUser.id);
    });

    // Forbidden transitions
    it.each([
      ['MET', 'NOT_MET'],
      ['WAIVED', 'MET'],
      ['NOT_MET', 'OPEN'],
    ])('rejects %s → %s with 400', async (from, to) => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue({ ...sampleCondition, status: from });
      const err = await service.resolveCondition(1, to, mockUser).catch(e => e);
      expect(err.status).toBe(400);
      expect(err.message).toMatch(new RegExp(`Invalid status transition: ${from} → ${to}`));
    });

    it('throws 404 when condition not found', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue(null);
      const err = await service.resolveCondition(999, 'MET', mockUser).catch(e => e);
      expect(err.status).toBe(404);
    });

    it('throws 404 when condition is soft-deleted', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue({ ...sampleCondition, deleted_at: new Date() });
      const err = await service.resolveCondition(1, 'MET', mockUser).catch(e => e);
      expect(err.status).toBe(404);
    });
  });

  // ─── deleteCondition ───
  describe('deleteCondition', () => {
    it('soft-deletes a condition', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue(sampleCondition);
      mockRepo.getApplicationStatus.mockResolvedValue('COMMITTEE_REVIEW');
      mockRepo.softDelete.mockResolvedValue(true);
      const result = await service.deleteCondition(1, mockUser);
      expect(result).toBe(true);
      expect(mockRepo.softDelete).toHaveBeenCalledWith(1);
    });

    it('blocks deletion of last OPEN condition in AWAITING_CONDITIONS', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue(sampleCondition);
      mockRepo.getApplicationStatus.mockResolvedValue('AWAITING_CONDITIONS');
      mockRepo.getOpenCount.mockResolvedValue(1);
      const err = await service.deleteCondition(1, mockUser).catch(e => e);
      expect(err.status).toBe(409);
      expect(err.message).toMatch(/Cannot delete the last OPEN condition/);
    });

    it('blocks deletion of last OPEN condition in EVIDENCE_REJECTED', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue(sampleCondition);
      mockRepo.getApplicationStatus.mockResolvedValue('EVIDENCE_REJECTED');
      mockRepo.getOpenCount.mockResolvedValue(1);
      const err = await service.deleteCondition(1, mockUser).catch(e => e);
      expect(err.status).toBe(409);
    });

    it('allows deletion when application is in AWAITING_CONDITIONS but condition is not OPEN', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue({ ...sampleCondition, status: 'MET' });
      mockRepo.getApplicationStatus.mockResolvedValue('AWAITING_CONDITIONS');
      mockRepo.softDelete.mockResolvedValue(true);
      const result = await service.deleteCondition(1, mockUser);
      expect(result).toBe(true);
    });

    it('throws 404 when condition not found', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue(null);
      const err = await service.deleteCondition(999, mockUser).catch(e => e);
      expect(err.status).toBe(404);
    });

    it('throws 404 when softDelete returns false', async () => {
      mockRepo.findByIdIncludingDeleted.mockResolvedValue(sampleCondition);
      mockRepo.getApplicationStatus.mockResolvedValue('DRAFT');
      mockRepo.softDelete.mockResolvedValue(false);
      const err = await service.deleteCondition(1, mockUser).catch(e => e);
      expect(err.status).toBe(404);
    });
  });

  // ─── evaluate ───
  describe('evaluate', () => {
    it('returns zero counts when no conditions', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 0, open: 0, met: 0, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([]);
      const result = await service.evaluate(100);
      expect(result.total).toBe(0);
      expect(result.open).toBe(0);
      expect(result.allSatisfied).toBe(true);
      expect(result.canApprove).toBe(false);
      expect(result.unmetConditionIds).toEqual([]);
      expect(result.missingEvidenceIds).toEqual([]);
    });

    it('returns correct evaluation with mixed conditions', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 3, open: 1, met: 1, notMet: 1, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([1, 2]);
      mockRepo.evaluateEvidenceCoverage.mockResolvedValue([
        { condition_id: 1, has_evidence: true },
        { condition_id: 2, has_evidence: false },
      ]);
      const result = await service.evaluate(100);
      expect(result.total).toBe(3);
      expect(result.allSatisfied).toBe(false);
      expect(result.unmetConditionIds).toEqual([1, 2]);
      expect(result.missingEvidenceIds).toEqual([2]);
    });

    it('sets canApprove=true when all satisfied and status is AWAITING_CONDITIONS', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 0, met: 2, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([]);
      const result = await service.evaluate(100, 'AWAITING_CONDITIONS');
      expect(result.canApprove).toBe(true);
      expect(result.canReject).toBe(false);
    });

    it('sets canReject=true when unresolved and status is AWAITING_CONDITIONS', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 1, met: 1, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([1]);
      mockRepo.evaluateEvidenceCoverage.mockResolvedValue([{ condition_id: 1, has_evidence: true }]);
      const result = await service.evaluate(100, 'AWAITING_CONDITIONS');
      expect(result.canApprove).toBe(false);
      expect(result.canReject).toBe(true);
    });

    it('sets canSubmitEvidence when evidence complete and status is EVIDENCE_REJECTED', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 1, open: 1, met: 0, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([1]);
      mockRepo.evaluateEvidenceCoverage.mockResolvedValue([{ condition_id: 1, has_evidence: true }]);
      const result = await service.evaluate(100, 'EVIDENCE_REJECTED');
      expect(result.canSubmitEvidence).toBe(true);
    });
  });

  // ─── validateTransition ───
  describe('validateTransition', () => {
    it('COMMITTEE_CONDITIONAL: passes when conditions exist', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 2, met: 0, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([1, 2]);
      mockRepo.evaluateEvidenceCoverage.mockResolvedValue([
        { condition_id: 1, has_evidence: false },
        { condition_id: 2, has_evidence: false },
      ]);
      await expect(service.validateTransition('COMMITTEE_CONDITIONAL', 100, mockUser)).resolves.toBeUndefined();
    });

    it('COMMITTEE_CONDITIONAL: fails when no conditions exist', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 0, open: 0, met: 0, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([]);
      const err = await service.validateTransition('COMMITTEE_CONDITIONAL', 100, mockUser).catch(e => e);
      expect(err.status).toBe(400);
      expect(err.message).toMatch(/At least one condition must be specified/);
    });

    it('CONDITIONS_MET: passes when all conditions satisfied', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 0, met: 2, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([]);
      await expect(service.validateTransition('CONDITIONS_MET', 100, mockUser)).resolves.toBeUndefined();
    });

    it('CONDITIONS_MET: fails when conditions not all MET', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 1, met: 1, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([1]);
      mockRepo.evaluateEvidenceCoverage.mockResolvedValue([{ condition_id: 1, has_evidence: false }]);
      const err = await service.validateTransition('CONDITIONS_MET', 100, mockUser).catch(e => e);
      expect(err.status).toBe(400);
    });

    it('CONDITIONS_NOT_MET: fails when all conditions already satisfied', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 0, met: 2, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([]);
      const err = await service.validateTransition('CONDITIONS_NOT_MET', 100, mockUser).catch(e => e);
      expect(err.status).toBe(400);
    });

    it('CONDITIONS_NOT_MET: passes when some conditions unresolved', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 1, met: 1, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([1]);
      mockRepo.evaluateEvidenceCoverage.mockResolvedValue([{ condition_id: 1, has_evidence: false }]);
      await expect(service.validateTransition('CONDITIONS_NOT_MET', 100, mockUser)).resolves.toBeUndefined();
    });

    it('SUBMIT_EVIDENCE: passes when all conditions have evidence', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 2, met: 0, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([1, 2]);
      mockRepo.evaluateEvidenceCoverage.mockResolvedValue([
        { condition_id: 1, has_evidence: true },
        { condition_id: 2, has_evidence: true },
      ]);
      await expect(service.validateTransition('SUBMIT_EVIDENCE', 100, mockUser)).resolves.toBeUndefined();
    });

    it('SUBMIT_EVIDENCE: fails when some conditions lack evidence', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 2, open: 2, met: 0, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([1, 2]);
      mockRepo.evaluateEvidenceCoverage.mockResolvedValue([
        { condition_id: 1, has_evidence: true },
        { condition_id: 2, has_evidence: false },
      ]);
      const err = await service.validateTransition('SUBMIT_EVIDENCE', 100, mockUser).catch(e => e);
      expect(err.status).toBe(400);
    });

    it('REJECT_CONDITIONS: always passes (admin discretion)', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 0, open: 0, met: 0, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([]);
      await expect(service.validateTransition('REJECT_CONDITIONS', 100, mockUser)).resolves.toBeUndefined();
    });

    it('unknown transition: passes silently', async () => {
      mockRepo.countByStatus.mockResolvedValue({ total: 0, open: 0, met: 0, notMet: 0, waived: 0 });
      mockRepo.getUnmetConditionIds.mockResolvedValue([]);
      await expect(service.validateTransition('SOME_UNKNOWN', 100, mockUser)).resolves.toBeUndefined();
    });
  });
});
