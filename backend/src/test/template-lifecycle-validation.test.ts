import { describe, it, expect, vi, beforeEach } from 'vitest';
import { LifecycleValidationService } from '../services/template-lifecycle-validation.service';
import type { VersionData } from '../services/template-version-lifecycle.service';
import type { AuthUser } from '../shared/types';

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

const adminUser: AuthUser = {
  id: 10, uuid: '', institution_id: 1, username: 'admin',
  email: 'admin@test.com', status: 'ACTIVE',
  roles: ['ETHICS_ADMIN'], is_email_verified: true,
};

const regularUser: AuthUser = {
  id: 12, uuid: '', institution_id: 1, username: 'user',
  email: 'user@test.com', status: 'ACTIVE',
  roles: ['APPLICANT'], is_email_verified: true,
};

describe('LifecycleValidationService', () => {
  let service: LifecycleValidationService;
  let mockValidationService: any;

  beforeEach(() => {
    mockValidationService = {
      validateVersion: vi.fn().mockResolvedValue({
        isValid: true,
        items: [],
        errors: [],
        warnings: [],
        infos: [],
        validatedAt: new Date(),
      }),
    };
    service = new LifecycleValidationService(mockValidationService);
  });

  // ─── Valid transitions ──────────────────────────────────

  describe('valid transitions', () => {
    it('approves valid DRAFT → REVIEW transition', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DRAFT',
        targetStatus: 'REVIEW',
        versionData: { ...mockVersion, status: 'DRAFT' },
        user: adminUser,
        comment: 'Ready for review',
      });

      expect(result.isValid).toBe(true);
      expect(result.errors).toHaveLength(0);
    });

    it('approves valid REVIEW → APPROVED transition', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'REVIEW',
        targetStatus: 'APPROVED',
        versionData: { ...mockVersion, status: 'REVIEW' },
        user: adminUser,
      });

      expect(result.isValid).toBe(true);
      expect(result.errors).toHaveLength(0);
    });

    it('approves valid REVIEW → DRAFT (reject) transition with reason', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'REVIEW',
        targetStatus: 'DRAFT',
        versionData: { ...mockVersion, status: 'REVIEW' },
        user: adminUser,
        comment: 'Needs revision',
      });

      expect(result.isValid).toBe(true);
    });

    it('approves valid APPROVED → DEPRECATED transition', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'APPROVED',
        targetStatus: 'DEPRECATED',
        versionData: { ...mockVersion, status: 'APPROVED' },
        user: adminUser,
      });

      expect(result.isValid).toBe(true);
    });

    it('approves valid DEPRECATED → ARCHIVED transition', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DEPRECATED',
        targetStatus: 'ARCHIVED',
        versionData: { ...mockVersion, status: 'DEPRECATED' },
        user: adminUser,
      });

      expect(result.isValid).toBe(true);
    });

    it('approves valid DEPRECATED → APPROVED (rollback) transition', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DEPRECATED',
        targetStatus: 'APPROVED',
        versionData: { ...mockVersion, status: 'DEPRECATED' },
        user: adminUser,
      });

      expect(result.isValid).toBe(true);
    });
  });

  // ─── Invalid transitions ────────────────────────────────

  describe('invalid transitions', () => {
    it('rejects DRAFT → APPROVED (no skip-review)', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DRAFT',
        targetStatus: 'APPROVED',
        versionData: { ...mockVersion, status: 'DRAFT' },
        user: adminUser,
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-062')).toBe(true);
    });

    it('rejects ARCHIVED → anything (terminal state)', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'ARCHIVED',
        targetStatus: 'DRAFT',
        versionData: { ...mockVersion, status: 'ARCHIVED' },
        user: adminUser,
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-062')).toBe(true);
    });

    it('rejects APPROVED → REVIEW (backwards)', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'APPROVED',
        targetStatus: 'REVIEW',
        versionData: { ...mockVersion, status: 'APPROVED' },
        user: adminUser,
      });

      expect(result.isValid).toBe(false);
    });

    it('rejects DRAFT → ARCHIVED (skip entire lifecycle)', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DRAFT',
        targetStatus: 'ARCHIVED',
        versionData: { ...mockVersion, status: 'DRAFT' },
        user: adminUser,
      });

      expect(result.isValid).toBe(false);
    });
  });

  // ─── Authorization failures ─────────────────────────────

  describe('authorization failures', () => {
    it('rejects submit from unauthorized user', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DRAFT',
        targetStatus: 'REVIEW',
        versionData: { ...mockVersion, status: 'DRAFT' },
        user: regularUser,
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-063')).toBe(true);
    });

    it('rejects approve from unauthorized user', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'REVIEW',
        targetStatus: 'APPROVED',
        versionData: { ...mockVersion, status: 'REVIEW' },
        user: regularUser,
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-063')).toBe(true);
    });
  });

  // ─── Precondition failures ──────────────────────────────

  describe('precondition failures', () => {
    it('rejects reject without reason', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'REVIEW',
        targetStatus: 'DRAFT',
        versionData: { ...mockVersion, status: 'REVIEW' },
        user: adminUser,
        comment: '',
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-064')).toBe(true);
    });

    it('rejects submit of empty version content', async () => {
      mockValidationService.validateVersion.mockResolvedValue({
        isValid: false,
        items: [{ code: 'TPL-VAL-001', severity: 'ERROR', message: 'Empty content', affectedField: 'content', suggestedResolution: 'Add content' }],
        errors: [{ code: 'TPL-VAL-001', severity: 'ERROR', message: 'Empty content', affectedField: 'content', suggestedResolution: 'Add content' }],
        warnings: [],
        infos: [],
        validatedAt: new Date(),
      });

      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DRAFT',
        targetStatus: 'REVIEW',
        versionData: { ...mockVersion, status: 'DRAFT', content: {} },
        user: adminUser,
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.length).toBeGreaterThan(0);
    });
  });

  // ─── Approval readiness ─────────────────────────────────

  describe('approval readiness', () => {
    it('blocks approve when workflow steps are not all approved', async () => {
      const result = await service.validateTransition(
        {
          templateCode: 'TPL-001',
          version: '1.0.0',
          currentStatus: 'REVIEW',
          targetStatus: 'APPROVED',
          versionData: { ...mockVersion, status: 'REVIEW' },
          user: adminUser,
        },
        { hasApprovalSteps: true, allStepsApproved: false },
      );

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-066')).toBe(true);
    });

    it('allows approve when no approval steps exist', async () => {
      const result = await service.validateTransition(
        {
          templateCode: 'TPL-001',
          version: '1.0.0',
          currentStatus: 'REVIEW',
          targetStatus: 'APPROVED',
          versionData: { ...mockVersion, status: 'REVIEW' },
          user: adminUser,
        },
        { hasApprovalSteps: false, allStepsApproved: false },
      );

      expect(result.isValid).toBe(true);
    });

    it('allows approve when all approval steps are approved', async () => {
      const result = await service.validateTransition(
        {
          templateCode: 'TPL-001',
          version: '1.0.0',
          currentStatus: 'REVIEW',
          targetStatus: 'APPROVED',
          versionData: { ...mockVersion, status: 'REVIEW' },
          user: adminUser,
        },
        { hasApprovalSteps: true, allStepsApproved: true },
      );

      expect(result.isValid).toBe(true);
    });
  });

  // ─── Effective date validation ──────────────────────────

  describe('effective date validation', () => {
    it('rejects inverted effective dates (until < from)', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'REVIEW',
        targetStatus: 'APPROVED',
        versionData: {
          ...mockVersion,
          status: 'REVIEW',
          effective_from: new Date('2026-12-01'),
          effective_until: new Date('2026-01-01'),
        },
        user: adminUser,
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-065')).toBe(true);
    });

    it('rejects zero-width effective dates (from === until)', async () => {
      const sameDate = new Date('2026-07-10');
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'REVIEW',
        targetStatus: 'APPROVED',
        versionData: {
          ...mockVersion,
          status: 'REVIEW',
          effective_from: sameDate,
          effective_until: sameDate,
        },
        user: adminUser,
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-065')).toBe(true);
    });
  });

  // ─── Version status mismatch ────────────────────────────

  describe('version status mismatch', () => {
    it('detects when version status differs from expected', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'REVIEW',
        targetStatus: 'APPROVED',
        versionData: { ...mockVersion, status: 'DRAFT' },
        user: adminUser,
      });

      expect(result.isValid).toBe(false);
      expect(result.errors.some(e => e.code === 'TPL-VAL-067')).toBe(true);
    });
  });

  // ─── Multiple simultaneous failures ─────────────────────

  describe('multiple simultaneous failures', () => {
    it('reports all errors in a single result', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DRAFT',
        targetStatus: 'APPROVED',
        versionData: { ...mockVersion, status: 'DRAFT' },
        user: regularUser,
      });

      expect(result.isValid).toBe(false);

      const errorCodes = result.errors.map(e => e.code);
      expect(errorCodes).toContain('TPL-VAL-062'); // invalid transition
      expect(errorCodes).toContain('TPL-VAL-063'); // unauthorized
    });

    it('aggregates all validation layers on a completely invalid request', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'APPROVED',
        targetStatus: 'REVIEW',
        versionData: {
          ...mockVersion,
          status: 'REVIEW',
          effective_from: new Date('2026-12-01'),
          effective_until: new Date('2026-01-01'),
        },
        user: regularUser,
        comment: '',
      });

      const errorCodes = result.errors.map(e => e.code);
      expect(errorCodes).toContain('TPL-VAL-062'); // invalid transition
      expect(errorCodes).toContain('TPL-VAL-063'); // unauthorized
      expect(errorCodes).toContain('TPL-VAL-067'); // status mismatch
    });
  });

  // ─── ValidationResult structure ─────────────────────────

  describe('ValidationResult structure', () => {
    it('returns correctly shaped result for valid transition', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DRAFT',
        targetStatus: 'REVIEW',
        versionData: { ...mockVersion, status: 'DRAFT' },
        user: adminUser,
      });

      expect(result).toHaveProperty('isValid');
      expect(result).toHaveProperty('items');
      expect(result).toHaveProperty('errors');
      expect(result).toHaveProperty('warnings');
      expect(result).toHaveProperty('infos');
      expect(result).toHaveProperty('templateCode', 'TPL-001');
      expect(result).toHaveProperty('templateVersion', '1.0.0');
      expect(result).toHaveProperty('validatedAt');
      expect(result.validatedAt).toBeInstanceOf(Date);
    });

    it('all items have required fields', async () => {
      const result = await service.validateTransition({
        templateCode: 'TPL-001',
        version: '1.0.0',
        currentStatus: 'DRAFT',
        targetStatus: 'APPROVED',
        versionData: { ...mockVersion, status: 'DRAFT' },
        user: regularUser,
      });

      for (const item of result.items) {
        expect(item).toHaveProperty('code');
        expect(item).toHaveProperty('severity');
        expect(item).toHaveProperty('message');
        expect(item).toHaveProperty('affectedField');
        expect(item).toHaveProperty('suggestedResolution');
      }
    });
  });
});
