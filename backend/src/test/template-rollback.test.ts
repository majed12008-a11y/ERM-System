import { describe, it, expect, vi, beforeEach } from 'vitest';
import { RollbackService } from '../services/template-rollback.service';
import type { VersionData } from '../services/template-version-lifecycle.service';
import type { AuthUser } from '../shared/types';
import type { TimelineDTO } from '../shared/template-timeline.types';

const now = new Date('2026-07-10T12:00:00Z');
const pastDate = new Date('2026-01-01T00:00:00Z');

function makeVersion(overrides: Partial<VersionData> = {}): VersionData {
  return {
    id: 1,
    template_id: 100,
    version: '1.0.0',
    status: 'DEPRECATED',
    content: { ar: { body: 'rollback content' } },
    content_hash: 'orig_hash_abc',
    variable_definitions: [],
    change_summary: 'Was approved then deprecated',
    effective_from: pastDate,
    effective_until: now,
    retired_at: null,
    approved_by: 10,
    approved_at: pastDate,
    created_by: 5,
    created_at: new Date('2026-01-10T00:00:00Z'),
    ...overrides,
  };
}

function makeTimelineDTO(overrides: Partial<TimelineDTO> = {}): TimelineDTO {
  return {
    versionId: 1,
    templateCode: 'TPL-001',
    version: '1.0.0',
    currentStatus: 'DEPRECATED',
    events: [],
    periods: [],
    effectiveFrom: null,
    effectiveUntil: null,
    isActive: false,
    isScheduled: false,
    isExpired: false,
    ...overrides,
  };
}

const adminUser: AuthUser = {
  id: 10, uuid: '', institution_id: 1, username: 'admin',
  email: 'admin@test.com', status: 'ACTIVE',
  roles: ['ETHICS_ADMIN'], is_email_verified: true,
};

const superAdminUser: AuthUser = {
  id: 11, uuid: '', institution_id: 1, username: 'super',
  email: 'super@test.com', status: 'ACTIVE',
  roles: ['SUPER_ADMIN'], is_email_verified: true,
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

const committeeUser: AuthUser = {
  id: 14, uuid: '', institution_id: 1, username: 'reviewer',
  email: 'reviewer@test.com', status: 'ACTIVE',
  roles: ['ETHICS_REVIEWER'], is_email_verified: true,
};

// ─── RollbackService — Policy ─────────────────────────────

describe('RollbackService — Policy', () => {
  let service: RollbackService;

  beforeEach(() => {
    service = new RollbackService(
      {} as any,
      {} as any,
      {} as any,
    );
  });

  describe('canRollback', () => {
    it('allows admin to rollback', () => {
      expect(service.canRollback(adminUser)).toBe(true);
    });

    it('allows super_admin to rollback', () => {
      expect(service.canRollback(superAdminUser)).toBe(true);
    });

    it('denies regular user', () => {
      expect(service.canRollback(regularUser)).toBe(false);
    });

    it('denies creator', () => {
      expect(service.canRollback(creatorUser)).toBe(false);
    });

    it('denies committee member', () => {
      expect(service.canRollback(committeeUser)).toBe(false);
    });
  });
});

// ─── RollbackService — validateRollback ───────────────────

describe('RollbackService — validateRollback', () => {
  let service: RollbackService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findApproved: vi.fn(),
    };
    service = new RollbackService({} as any, {} as any, mockVersionRepo);
  });

  it('returns canRollback=true for valid DEPRECATED version', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DEPRECATED' }));

    const result = await service.validateRollback('TPL-001', '1.0.0', adminUser);

    expect(result.canRollback).toBe(true);
    expect(result.reasons).toEqual([]);
  });

  it('returns canRollback=false for non-DEPRECATED status', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DRAFT' }));

    const result = await service.validateRollback('TPL-001', '1.0.0', adminUser);

    expect(result.canRollback).toBe(false);
    expect(result.reasons.some(r => r.includes('Invalid transition'))).toBe(true);
  });

  it('returns canRollback=false for unauthorized user', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DEPRECATED' }));

    const result = await service.validateRollback('TPL-001', '1.0.0', regularUser);

    expect(result.canRollback).toBe(false);
    expect(result.reasons.some(r => r.includes('Not authorized'))).toBe(true);
  });

  it('returns canRollback=false and collects multiple reasons', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DRAFT' }));

    const result = await service.validateRollback('TPL-001', '1.0.0', regularUser);

    expect(result.canRollback).toBe(false);
    expect(result.reasons.length).toBeGreaterThanOrEqual(2);
  });

  it('returns canRollback=false for nonexistent version', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(null);

    const result = await service.validateRollback('NONEXIST', '1.0.0', adminUser);

    expect(result.canRollback).toBe(false);
    expect(result.reasons.some(r => r.includes('not found'))).toBe(true);
  });

  it('returns canRollback=false for APPROVED status (already active)', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'APPROVED' }));

    const result = await service.validateRollback('TPL-001', '1.0.0', adminUser);

    expect(result.canRollback).toBe(false);
  });
});

// ─── RollbackService — executeRollback ────────────────────

describe('RollbackService — executeRollback', () => {
  let service: RollbackService;
  let mockLifecycleService: any;
  let mockTimelineService: any;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findApproved: vi.fn(),
    };
    mockLifecycleService = {
      rollback: vi.fn(),
    };
    mockTimelineService = {
      buildTimeline: vi.fn(),
      buildVersionTimelines: vi.fn(),
      checkChronologyConsistency: vi.fn(),
    };
    service = new RollbackService(mockLifecycleService, mockTimelineService, mockVersionRepo);
  });

  it('executes successful rollback and returns full result', async () => {
    const depVersion = makeVersion({
      id: 1, version: '1.0.0', status: 'DEPRECATED', content_hash: 'hash_abc',
    });
    const approvedVersion = makeVersion({
      id: 1, version: '1.0.0', status: 'APPROVED', content_hash: 'hash_abc',
    });
    const timelineBefore = makeTimelineDTO({ currentStatus: 'DEPRECATED' });
    const timelineAfter = makeTimelineDTO({ currentStatus: 'APPROVED' });

    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(depVersion);
    mockVersionRepo.findApproved.mockResolvedValue(null);
    mockTimelineService.buildTimeline
      .mockResolvedValueOnce(timelineBefore)
      .mockResolvedValueOnce(timelineAfter);
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({ valid: true, issues: [] });
    mockLifecycleService.rollback.mockResolvedValue(approvedVersion);

    const result = await service.executeRollback('TPL-001', '1.0.0', adminUser);

    expect(result.success).toBe(true);
    expect(result.versionId).toBe(1);
    expect(result.previousStatus).toBe('DEPRECATED');
    expect(result.newStatus).toBe('APPROVED');
    expect(result.contentIntegrityVerified).toBe(true);
    expect(result.consistencyVerified).toBe(true);
    expect(result.consistencyIssues).toEqual([]);
    expect(result.impact.previouslyActiveVersion).toBeNull();
  });

  it('captures previously active version in impact', async () => {
    const depVersion = makeVersion({ id: 2, version: '2.0.0', status: 'DEPRECATED', template_id: 100 });
    const activeVersion = makeVersion({ id: 1, version: '1.0.0', status: 'APPROVED', template_id: 100 });
    const approvedVersion = makeVersion({ id: 2, version: '2.0.0', status: 'APPROVED', template_id: 100 });

    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(depVersion);
    mockVersionRepo.findApproved.mockResolvedValue(activeVersion);
    mockTimelineService.buildTimeline
      .mockResolvedValueOnce(makeTimelineDTO())
      .mockResolvedValueOnce(makeTimelineDTO({ currentStatus: 'APPROVED' }));
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({ valid: true, issues: [] });
    mockLifecycleService.rollback.mockResolvedValue(approvedVersion);

    const result = await service.executeRollback('TPL-001', '2.0.0', adminUser);

    expect(result.impact.previouslyActiveVersion).not.toBeNull();
    expect(result.impact.previouslyActiveVersion!.id).toBe(1);
  });

  it('ignores self as previously active', async () => {
    const depVersion = makeVersion({ id: 1, version: '1.0.0', status: 'DEPRECATED' });
    const approvedVersion = makeVersion({ id: 1, version: '1.0.0', status: 'APPROVED' });

    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(depVersion);
    mockVersionRepo.findApproved.mockResolvedValue(depVersion);
    mockTimelineService.buildTimeline
      .mockResolvedValueOnce(makeTimelineDTO())
      .mockResolvedValueOnce(makeTimelineDTO({ currentStatus: 'APPROVED' }));
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({ valid: true, issues: [] });
    mockLifecycleService.rollback.mockResolvedValue(approvedVersion);

    const result = await service.executeRollback('TPL-001', '1.0.0', adminUser);

    expect(result.impact.previouslyActiveVersion).toBeNull();
  });

  it('verifies content integrity via hash comparison', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      status: 'DEPRECATED', content_hash: 'original_hash',
    }));
    mockVersionRepo.findApproved.mockResolvedValue(null);
    mockTimelineService.buildTimeline
      .mockResolvedValueOnce(makeTimelineDTO())
      .mockResolvedValueOnce(makeTimelineDTO({ currentStatus: 'APPROVED' }));
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({ valid: true, issues: [] });
    mockLifecycleService.rollback.mockResolvedValue(makeVersion({
      status: 'APPROVED', content_hash: 'original_hash',
    }));

    const result = await service.executeRollback('TPL-001', '1.0.0', adminUser);
    expect(result.contentIntegrityVerified).toBe(true);
  });

  it('reports content integrity failure when hash changed', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      status: 'DEPRECATED', content_hash: 'original_hash',
    }));
    mockVersionRepo.findApproved.mockResolvedValue(null);
    mockTimelineService.buildTimeline
      .mockResolvedValueOnce(makeTimelineDTO())
      .mockResolvedValueOnce(makeTimelineDTO({ currentStatus: 'APPROVED', version: '1.0.0' }));
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({ valid: true, issues: [] });
    mockLifecycleService.rollback.mockResolvedValue(makeVersion({
      status: 'APPROVED', content_hash: 'tampered_hash',
    }));

    const result = await service.executeRollback('TPL-001', '1.0.0', adminUser);
    expect(result.contentIntegrityVerified).toBe(false);
  });

  it('reports chronology consistency issues', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DEPRECATED' }));
    mockVersionRepo.findApproved.mockResolvedValue(null);
    mockTimelineService.buildTimeline
      .mockResolvedValueOnce(makeTimelineDTO())
      .mockResolvedValueOnce(makeTimelineDTO({ currentStatus: 'APPROVED' }));
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({
      valid: false,
      issues: ['Overlap detected between v1.0.0 and v2.0.0'],
    });
    mockLifecycleService.rollback.mockResolvedValue(makeVersion({ status: 'APPROVED' }));

    const result = await service.executeRollback('TPL-001', '1.0.0', adminUser);

    expect(result.consistencyVerified).toBe(false);
    expect(result.consistencyIssues).toContain('Overlap detected between v1.0.0 and v2.0.0');
  });

  it('throws 403 for unauthorized user', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DEPRECATED' }));

    const err = await service.executeRollback('TPL-001', '1.0.0', regularUser).catch((e: any) => e);
    expect(err.status).toBe(403);
    expect(err.message).toContain('authorized');
  });

  it('throws 400 for invalid state (non-DEPRECATED)', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DRAFT' }));

    const err = await service.executeRollback('TPL-001', '1.0.0', adminUser).catch((e: any) => e);
    expect(err.status).toBe(400);
  });

  it('throws 404 for nonexistent version', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(null);

    const err = await service.executeRollback('NONEXIST', '1.0.0', adminUser).catch((e: any) => e);
    expect(err.status).toBe(404);
  });

  it('passes reason to lifecycle service', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DEPRECATED' }));
    mockVersionRepo.findApproved.mockResolvedValue(null);
    mockTimelineService.buildTimeline
      .mockResolvedValue(makeTimelineDTO());
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({ valid: true, issues: [] });
    mockLifecycleService.rollback.mockResolvedValue(makeVersion({ status: 'APPROVED' }));

    await service.executeRollback('TPL-001', '1.0.0', adminUser, 'Rolling back to fix issue');

    expect(mockLifecycleService.rollback).toHaveBeenCalledWith(
      'TPL-001', '1.0.0', adminUser, 'Rolling back to fix issue',
    );
  });
});

// ─── getRollbackHistory ───────────────────────────────────

describe('RollbackService — getRollbackHistory', () => {
  let service: RollbackService;
  let mockLifecycleService: any;
  let mockTimelineService: any;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findApproved: vi.fn(),
    };
    mockLifecycleService = {
      rollback: vi.fn(),
    };
    mockTimelineService = {
      buildTimeline: vi.fn(),
      buildVersionTimelines: vi.fn(),
      checkChronologyConsistency: vi.fn(),
    };
    service = new RollbackService(mockLifecycleService, mockTimelineService, mockVersionRepo);
  });

  it('returns rollback history entries in reverse chronological order', async () => {
    mockTimelineService.buildVersionTimelines.mockResolvedValue([
      {
        version: '2.0.0', events: [{
          category: 'ROLLED_BACK', timestamp: new Date('2026-06-15T00:00:00Z'),
          fromStatus: 'DEPRECATED',
        }],
      },
      {
        version: '1.0.0', events: [{
          category: 'ROLLED_BACK', timestamp: new Date('2026-03-01T00:00:00Z'),
          fromStatus: 'DEPRECATED',
        }],
      },
    ]);

    const history = await service.getRollbackHistory('TPL-001');

    expect(history).toHaveLength(2);
    expect(history[0].version).toBe('2.0.0');
    expect(history[1].version).toBe('1.0.0');
  });

  it('filters to only ROLLED_BACK events', async () => {
    mockTimelineService.buildVersionTimelines.mockResolvedValue([
      {
        version: '1.0.0', events: [
          { category: 'CREATED', timestamp: new Date('2026-01-01T00:00:00Z') },
          { category: 'SUBMITTED', timestamp: new Date('2026-01-15T00:00:00Z') },
          { category: 'ROLLED_BACK', timestamp: new Date('2026-06-01T00:00:00Z'), fromStatus: 'DEPRECATED' },
        ],
      },
    ]);

    const history = await service.getRollbackHistory('TPL-001');

    expect(history).toHaveLength(1);
    expect(history[0].version).toBe('1.0.0');
  });

  it('returns empty array when no rollbacks occurred', async () => {
    mockTimelineService.buildVersionTimelines.mockResolvedValue([
      {
        version: '1.0.0', events: [
          { category: 'CREATED' },
          { category: 'APPROVED' },
          { category: 'DEPRECATED' },
        ],
      },
    ]);

    const history = await service.getRollbackHistory('TPL-001');
    expect(history).toEqual([]);
  });
});

// ─── Historical Recovery ──────────────────────────────────

describe('RollbackService — Historical Recovery', () => {
  let service: RollbackService;
  let mockLifecycleService: any;
  let mockTimelineService: any;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findApproved: vi.fn(),
    };
    mockLifecycleService = {
      rollback: vi.fn(),
    };
    mockTimelineService = {
      buildTimeline: vi.fn(),
      buildVersionTimelines: vi.fn(),
      checkChronologyConsistency: vi.fn(),
    };
    service = new RollbackService(mockLifecycleService, mockTimelineService, mockVersionRepo);
  });

  it('timeline after rollback shows version as APPROVED', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DEPRECATED' }));
    mockVersionRepo.findApproved.mockResolvedValue(null);
    mockTimelineService.buildTimeline
      .mockResolvedValueOnce(makeTimelineDTO({ currentStatus: 'DEPRECATED' }))
      .mockResolvedValueOnce(makeTimelineDTO({ currentStatus: 'APPROVED' }));
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({ valid: true, issues: [] });
    mockLifecycleService.rollback.mockResolvedValue(makeVersion({ status: 'APPROVED' }));

    const result = await service.executeRollback('TPL-001', '1.0.0', adminUser);

    expect(result.impact.timelineBefore.currentStatus).toBe('DEPRECATED');
    expect(result.impact.timelineAfter.currentStatus).toBe('APPROVED');
  });

  it('effective dates are cleared after rollback', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      status: 'DEPRECATED', effective_from: pastDate, effective_until: now,
    }));
    mockVersionRepo.findApproved.mockResolvedValue(null);
    mockTimelineService.buildTimeline
      .mockResolvedValueOnce(makeTimelineDTO({
        currentStatus: 'DEPRECATED', effectiveFrom: pastDate, effectiveUntil: now,
      }))
      .mockResolvedValueOnce(makeTimelineDTO({
        currentStatus: 'APPROVED', effectiveFrom: null, effectiveUntil: null,
      }));
    mockTimelineService.checkChronologyConsistency.mockResolvedValue({ valid: true, issues: [] });
    mockLifecycleService.rollback.mockResolvedValue(makeVersion({
      status: 'APPROVED', effective_from: null, effective_until: null,
    }));

    const result = await service.executeRollback('TPL-001', '1.0.0', adminUser);

    expect(result.impact.timelineBefore.effectiveFrom).toEqual(pastDate);
    expect(result.impact.timelineAfter.effectiveFrom).toBeNull();
    expect(result.impact.timelineAfter.effectiveUntil).toBeNull();
  });
});
