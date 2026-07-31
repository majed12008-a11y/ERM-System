import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TimelineService } from '../services/template-timeline.service';
import type { VersionData } from '../services/template-version-lifecycle.service';
import { isDateInRange, rangesOverlap } from '../shared/template-timeline.types';

const now = new Date('2026-07-10T12:00:00Z');
const futureDate = new Date('2026-08-01T00:00:00Z');
const pastDate = new Date('2026-01-01T00:00:00Z');
const yesterday = new Date('2026-07-09T12:00:00Z');
const tomorrow = new Date('2026-07-11T12:00:00Z');

function makeVersion(overrides: Partial<VersionData> = {}): VersionData {
  return {
    id: 1,
    template_id: 100,
    version: '1.0.0',
    status: 'DRAFT',
    content: { ar: { body: 'test' } },
    content_hash: 'abc',
    variable_definitions: [],
    change_summary: null,
    effective_from: null,
    effective_until: null,
    retired_at: null,
    approved_by: null,
    approved_at: null,
    created_by: 5,
    created_at: new Date('2026-01-15T00:00:00Z'),
    ...overrides,
  };
}

function makeAuditEvent(overrides: Partial<any> = {}): any {
  return {
    id: 1,
    action: 'CREATED',
    previous_status: null,
    new_status: 'DRAFT',
    created_at: new Date('2026-01-15T00:00:00Z'),
    actor_id: 5,
    comment: null,
    ...overrides,
  };
}

// ─── Pure Function Tests ───────────────────────────────────

describe('Timeline — Pure Functions', () => {
  describe('isDateInRange', () => {
    it('returns true when no bounds set', () => {
      expect(isDateInRange(now, null, null)).toBe(true);
    });

    it('returns true when date is after from', () => {
      expect(isDateInRange(now, pastDate, null)).toBe(true);
    });

    it('returns false when date is before from', () => {
      expect(isDateInRange(pastDate, now, null)).toBe(false);
    });

    it('returns false when date is at or after until (exclusive)', () => {
      expect(isDateInRange(now, null, now)).toBe(false);
    });

    it('returns true when date is before until', () => {
      expect(isDateInRange(pastDate, null, now)).toBe(true);
    });

    it('returns true within both bounds', () => {
      expect(isDateInRange(now, pastDate, tomorrow)).toBe(true);
    });
  });

  describe('rangesOverlap', () => {
    it('detects overlapping ranges', () => {
      expect(rangesOverlap(pastDate, now, yesterday, tomorrow)).toBe(true);
    });

    it('returns false for non-overlapping ranges', () => {
      expect(rangesOverlap(pastDate, yesterday, now, tomorrow)).toBe(false);
    });

    it('touching ranges do not overlap (exclusive end)', () => {
      expect(rangesOverlap(pastDate, now, now, tomorrow)).toBe(false);
    });

    it('null ends are treated as infinity', () => {
      expect(rangesOverlap(pastDate, null, now, tomorrow)).toBe(true);
    });

    it('null starts are treated as epoch', () => {
      expect(rangesOverlap(null, pastDate, now, tomorrow)).toBe(false);
    });
  });
});

// ─── Timeline Service ───────────────────────────────────────

describe('TimelineService — buildTimeline', () => {
  let service: TimelineService;
  let mockVersionRepo: any;
  let mockAuditRepo: any;
  let mockTemplateRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findByTemplateCode: vi.fn(),
      findById: vi.fn(),
      findApproved: vi.fn(),
    };
    mockAuditRepo = {
      findByVersionId: vi.fn(),
    };
    mockTemplateRepo = {
      findIdByCode: vi.fn(),
    };
    service = new TimelineService(mockVersionRepo, mockAuditRepo, mockTemplateRepo);
  });

  it('returns full TimelineDTO structure', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DRAFT' }));
    mockAuditRepo.findByVersionId.mockResolvedValue([makeAuditEvent()]);

    const result = await service.buildTimeline('TPL-001', '1.0.0');

    expect(result).toHaveProperty('versionId', 1);
    expect(result).toHaveProperty('templateCode', 'TPL-001');
    expect(result).toHaveProperty('version', '1.0.0');
    expect(result).toHaveProperty('currentStatus', 'DRAFT');
    expect(result).toHaveProperty('events');
    expect(result).toHaveProperty('periods');
    expect(result).toHaveProperty('isActive');
    expect(result).toHaveProperty('isScheduled');
    expect(result).toHaveProperty('isExpired');
  });

  it('orders events chronologically', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'APPROVED' }));
    mockAuditRepo.findByVersionId.mockResolvedValue([
      makeAuditEvent({ id: 1, action: 'CREATED', new_status: 'DRAFT', created_at: new Date('2026-01-15T00:00:00Z') }),
      makeAuditEvent({ id: 2, action: 'SUBMITTED', new_status: 'REVIEW', created_at: new Date('2026-02-01T00:00:00Z') }),
      makeAuditEvent({ id: 3, action: 'APPROVED', new_status: 'APPROVED', created_at: new Date('2026-03-01T00:00:00Z') }),
    ]);

    const result = await service.buildTimeline('TPL-001', '1.0.0');

    expect(result.events).toHaveLength(3);
    expect(result.events[0].category).toBe('CREATED');
    expect(result.events[1].category).toBe('SUBMITTED');
    expect(result.events[2].category).toBe('APPROVED');
  });

  it('handles empty audit log gracefully', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DRAFT' }));
    mockAuditRepo.findByVersionId.mockResolvedValue([]);

    const result = await service.buildTimeline('TPL-001', '1.0.0');

    expect(result.events).toHaveLength(0);
    expect(result.periods).toHaveLength(1);
    expect(result.currentStatus).toBe('DRAFT');
  });

  it('builds periods from events', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'APPROVED' }));
    mockAuditRepo.findByVersionId.mockResolvedValue([
      makeAuditEvent({ id: 1, action: 'CREATED', new_status: 'DRAFT', created_at: new Date('2026-01-15T00:00:00Z') }),
      makeAuditEvent({ id: 2, action: 'APPROVED', new_status: 'APPROVED', created_at: new Date('2026-03-01T00:00:00Z') }),
    ]);

    const result = await service.buildTimeline('TPL-001', '1.0.0');

    expect(result.periods).toHaveLength(2);
    expect(result.periods[0].status).toBe('DRAFT');
    expect(result.periods[1].status).toBe('APPROVED');
    expect(result.periods[1].to).toBeNull();
  });

  it('sets isActive=true for approved version in effective window', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      status: 'APPROVED', effective_from: pastDate, effective_until: tomorrow,
    }));
    mockAuditRepo.findByVersionId.mockResolvedValue([]);

    const result = await service.buildTimeline('TPL-001', '1.0.0');
    expect(result.isActive).toBe(true);
  });

  it('sets isActive=false for non-approved version', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ status: 'DRAFT' }));
    mockAuditRepo.findByVersionId.mockResolvedValue([]);

    const result = await service.buildTimeline('TPL-001', '1.0.0');
    expect(result.isActive).toBe(false);
  });

  it('sets isScheduled=true for future activation', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      status: 'APPROVED', effective_from: futureDate,
    }));
    mockAuditRepo.findByVersionId.mockResolvedValue([]);

    const result = await service.buildTimeline('TPL-001', '1.0.0');
    expect(result.isScheduled).toBe(true);
    expect(result.isActive).toBe(false);
  });

  it('sets isExpired=true for past expiration', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      status: 'APPROVED', effective_from: pastDate, effective_until: yesterday,
    }));
    mockAuditRepo.findByVersionId.mockResolvedValue([]);

    const result = await service.buildTimeline('TPL-001', '1.0.0');
    expect(result.isExpired).toBe(true);
    expect(result.isActive).toBe(false);
  });

  it('throws 404 for missing version', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(null);

    const err = await service.buildTimeline('NONEXIST', '1.0.0').catch((e: any) => e);
    expect(err.status).toBe(404);
  });
});

// ─── buildVersionTimelines ─────────────────────────────────

describe('TimelineService — buildVersionTimelines', () => {
  let service: TimelineService;
  let mockVersionRepo: any;
  let mockAuditRepo: any;
  let mockTemplateRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findByTemplateCode: vi.fn(),
      findById: vi.fn(),
      findApproved: vi.fn(),
    };
    mockAuditRepo = {
      findByVersionId: vi.fn(),
    };
    mockTemplateRepo = {
      findIdByCode: vi.fn(),
    };
    service = new TimelineService(mockVersionRepo, mockAuditRepo, mockTemplateRepo);
  });

  it('returns timelines for all versions ordered by date', async () => {
    const v1 = makeVersion({ id: 1, version: '1.0.0', status: 'DRAFT', created_at: new Date('2026-01-01T00:00:00Z') });
    const v2 = makeVersion({ id: 2, version: '2.0.0', status: 'APPROVED', created_at: new Date('2026-06-01T00:00:00Z') });
    mockVersionRepo.findByTemplateCode.mockResolvedValue([v1, v2]);
    mockVersionRepo.findByCodeAndVersion.mockImplementation(
      (_code: string, ver: string) => Promise.resolve([v1, v2].find(v => v.version === ver) || null),
    );
    mockAuditRepo.findByVersionId.mockResolvedValue([]);

    const result = await service.buildVersionTimelines('TPL-001');

    expect(result).toHaveLength(2);
  });

  it('returns empty array when no versions exist', async () => {
    mockVersionRepo.findByTemplateCode.mockResolvedValue([]);

    const result = await service.buildVersionTimelines('NONEXIST');
    expect(result).toEqual([]);
  });
});

// ─── resolveActiveVersion ──────────────────────────────────

describe('TimelineService — resolveActiveVersion', () => {
  let service: TimelineService;
  let mockVersionRepo: any;
  let mockAuditRepo: any;
  let mockTemplateRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findByTemplateCode: vi.fn(),
      findById: vi.fn(),
      findApproved: vi.fn(),
    };
    mockAuditRepo = {
      findByVersionId: vi.fn(),
    };
    mockTemplateRepo = {
      findIdByCode: vi.fn(),
    };
    service = new TimelineService(mockVersionRepo, mockAuditRepo, mockTemplateRepo);
  });

  it('returns the currently active version', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 2, version: '2.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: tomorrow,
      }),
      makeVersion({ id: 1, version: '1.0.0', status: 'DRAFT' }),
    ]);

    const result = await service.resolveActiveVersion('TPL-001');

    expect(result).not.toBeNull();
    expect(result!.versionId).toBe(2);
    expect(result!.version).toBe('2.0.0');
    expect(result!.status).toBe('APPROVED');
  });

  it('respects asOfDate parameter', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: futureDate,
      }),
    ]);

    const result = await service.resolveActiveVersion('TPL-001', yesterday);
    expect(result).not.toBeNull();
    expect(result!.versionId).toBe(1);
  });

  it('returns null when no approved version exists', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({ id: 1, version: '1.0.0', status: 'DRAFT' }),
    ]);

    const result = await service.resolveActiveVersion('TPL-001');
    expect(result).toBeNull();
  });

  it('returns null when all approved versions are expired', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: yesterday,
      }),
    ]);

    const result = await service.resolveActiveVersion('TPL-001');
    expect(result).toBeNull();
  });

  it('prefers the most recently effective version', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: new Date('2026-07-01T00:00:00Z'),
      }),
      makeVersion({
        id: 2, version: '2.0.0', status: 'APPROVED',
        effective_from: new Date('2026-07-01T00:00:00Z'), effective_until: tomorrow,
      }),
    ]);

    const result = await service.resolveActiveVersion('TPL-001', now);
    expect(result).not.toBeNull();
    expect(result!.versionId).toBe(2);
  });

  it('returns null for version with future effective_from (scheduled)', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: futureDate, effective_until: null,
      }),
    ]);

    const result = await service.resolveActiveVersion('TPL-001', now);
    expect(result).toBeNull();
  });

  it('approves version with null effective_from', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: null, effective_until: null,
      }),
    ]);

    const result = await service.resolveActiveVersion('TPL-001', now);
    expect(result).not.toBeNull();
    expect(result!.versionId).toBe(1);
  });

  it('treats effective_until boundary as exclusive (equal = expired)', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: now,
      }),
    ]);

    const result = await service.resolveActiveVersion('TPL-001', now);
    expect(result).toBeNull();
  });
});

// ─── getChronology ─────────────────────────────────────────

describe('TimelineService — getChronology', () => {
  let service: TimelineService;
  let mockVersionRepo: any;
  let mockAuditRepo: any;
  let mockTemplateRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findByTemplateCode: vi.fn(),
      findById: vi.fn(),
      findApproved: vi.fn(),
    };
    mockAuditRepo = {
      findByVersionId: vi.fn(),
    };
    mockTemplateRepo = {
      findIdByCode: vi.fn(),
    };
    service = new TimelineService(mockVersionRepo, mockAuditRepo, mockTemplateRepo);
  });

  it('returns entries in chronological order', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 2, version: '2.0.0', status: 'APPROVED',
        effective_from: new Date('2026-06-01T00:00:00Z'), approved_at: new Date('2026-06-01T00:00:00Z'),
      }),
      makeVersion({
        id: 1, version: '1.0.0', status: 'ARCHIVED',
        effective_from: new Date('2026-01-01T00:00:00Z'), approved_at: new Date('2026-01-01T00:00:00Z'),
      }),
    ]);

    const result = await service.getChronology('TPL-001');

    expect(result.entries).toHaveLength(2);
    expect(result.entries[0].version).toBe('1.0.0');
    expect(result.entries[1].version).toBe('2.0.0');
  });

  it('identifies the active entry', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: tomorrow,
      }),
    ]);

    const result = await service.getChronology('TPL-001');

    expect(result.activeEntry).not.toBeNull();
    expect(result.activeEntry!.version).toBe('1.0.0');
  });

  it('handles template with no versions', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(null);

    const result = await service.getChronology('NONEXIST');
    expect(result.entries).toEqual([]);
    expect(result.activeEntry).toBeNull();
  });

  it('filters out DRAFT and REVIEW entries', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({ id: 1, version: '1.0.0', status: 'DRAFT' }),
      makeVersion({ id: 2, version: '2.0.0', status: 'REVIEW' }),
      makeVersion({ id: 3, version: '3.0.0', status: 'APPROVED', effective_from: pastDate, effective_until: tomorrow }),
    ]);

    const result = await service.getChronology('TPL-001');
    expect(result.entries).toHaveLength(1);
    expect(result.entries[0].version).toBe('3.0.0');
  });
});

// ─── detectOverlaps ────────────────────────────────────────

describe('TimelineService — detectOverlaps', () => {
  let service: TimelineService;
  let mockVersionRepo: any;
  let mockAuditRepo: any;
  let mockTemplateRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findByTemplateCode: vi.fn(),
      findById: vi.fn(),
      findApproved: vi.fn(),
    };
    mockAuditRepo = {
      findByVersionId: vi.fn(),
    };
    mockTemplateRepo = {
      findIdByCode: vi.fn(),
    };
    service = new TimelineService(mockVersionRepo, mockAuditRepo, mockTemplateRepo);
  });

  it('detects overlapping effective windows', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: futureDate,
      }),
      makeVersion({
        id: 2, version: '2.0.0', status: 'APPROVED',
        effective_from: yesterday, effective_until: tomorrow,
      }),
    ]);

    const warnings = await service.detectOverlaps('TPL-001');

    expect(warnings).toHaveLength(1);
    expect(warnings[0].versionA).toBe('1.0.0');
    expect(warnings[0].versionB).toBe('2.0.0');
  });

  it('returns empty for non-overlapping windows', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: yesterday,
      }),
      makeVersion({
        id: 2, version: '2.0.0', status: 'APPROVED',
        effective_from: now, effective_until: tomorrow,
      }),
    ]);

    const warnings = await service.detectOverlaps('TPL-001');

    expect(warnings).toEqual([]);
  });

  it('ignores non-approved versions with null effective_from', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({ id: 1, version: '1.0.0', status: 'DRAFT' }),
      makeVersion({ id: 2, version: '2.0.0', status: 'APPROVED', effective_from: pastDate, effective_until: tomorrow }),
    ]);

    const warnings = await service.detectOverlaps('TPL-001');

    expect(warnings).toEqual([]);
  });

  it('returns empty when no versions exist', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([]);

    const warnings = await service.detectOverlaps('TPL-001');
    expect(warnings).toEqual([]);
  });

  it('returns empty for unknown template', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(null);

    const warnings = await service.detectOverlaps('NONEXIST');
    expect(warnings).toEqual([]);
  });
});

// ─── checkChronologyConsistency ────────────────────────────

describe('TimelineService — checkChronologyConsistency', () => {
  let service: TimelineService;
  let mockVersionRepo: any;
  let mockAuditRepo: any;
  let mockTemplateRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findByTemplateCode: vi.fn(),
      findById: vi.fn(),
      findApproved: vi.fn(),
    };
    mockAuditRepo = {
      findByVersionId: vi.fn(),
    };
    mockTemplateRepo = {
      findIdByCode: vi.fn(),
    };
    service = new TimelineService(mockVersionRepo, mockAuditRepo, mockTemplateRepo);
  });

  it('passes for valid chronology', async () => {
    const v1 = makeVersion({
      id: 1, version: '1.0.0', status: 'APPROVED',
      effective_from: pastDate, effective_until: yesterday,
    });
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([v1]);
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(v1);
    mockAuditRepo.findByVersionId.mockResolvedValue([makeAuditEvent()]);

    const result = await service.checkChronologyConsistency('TPL-001');
    expect(result.valid).toBe(true);
    expect(result.issues).toEqual([]);
  });

  it('flags inverted effective dates', async () => {
    const v1 = makeVersion({
      id: 1, version: '1.0.0', status: 'APPROVED',
      effective_from: tomorrow, effective_until: pastDate,
    });
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([v1]);
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(v1);
    mockAuditRepo.findByVersionId.mockResolvedValue([makeAuditEvent()]);

    const result = await service.checkChronologyConsistency('TPL-001');
    expect(result.valid).toBe(false);
    expect(result.issues.some(i => i.includes('inverted') || i.includes('not after'))).toBe(true);
  });

  it('flags overlapping windows', async () => {
    const v1 = makeVersion({
      id: 1, version: '1.0.0', status: 'APPROVED',
      effective_from: pastDate, effective_until: futureDate,
    });
    const v2 = makeVersion({
      id: 2, version: '2.0.0', status: 'APPROVED',
      effective_from: yesterday, effective_until: tomorrow,
    });
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([v1, v2]);
    mockVersionRepo.findByCodeAndVersion.mockImplementation(
      (_code: string, ver: string) => Promise.resolve([v1, v2].find(v => v.version === ver) || null),
    );
    mockAuditRepo.findByVersionId.mockResolvedValue([makeAuditEvent()]);

    const result = await service.checkChronologyConsistency('TPL-001');
    expect(result.valid).toBe(false);
    expect(result.issues.some(i => i.includes('Overlap'))).toBe(true);
  });

  it('returns valid when no versions exist', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([]);

    const result = await service.checkChronologyConsistency('TPL-001');
    expect(result.valid).toBe(true);
  });
});

// ─── Rollback Chronology ───────────────────────────────────

describe('TimelineService — Rollback Chronology', () => {
  let service: TimelineService;
  let mockVersionRepo: any;
  let mockAuditRepo: any;
  let mockTemplateRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
      findByTemplateCode: vi.fn(),
      findById: vi.fn(),
      findApproved: vi.fn(),
    };
    mockAuditRepo = {
      findByVersionId: vi.fn(),
    };
    mockTemplateRepo = {
      findIdByCode: vi.fn(),
    };
    service = new TimelineService(mockVersionRepo, mockAuditRepo, mockTemplateRepo);
  });

  it('rollback version with cleared effective dates appears as approved without window', async () => {
    const rollbackVersion = makeVersion({
      id: 2, version: '2.0.0', status: 'APPROVED',
      effective_from: null, effective_until: null,
    });

    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(rollbackVersion);
    mockAuditRepo.findByVersionId.mockResolvedValue([
      makeAuditEvent({ id: 1, action: 'CREATED', new_status: 'DRAFT' }),
      makeAuditEvent({ id: 2, action: 'ROLLED_BACK', new_status: 'APPROVED', created_at: now }),
    ]);

    const result = await service.buildTimeline('TPL-001', '2.0.0');

    expect(result.currentStatus).toBe('APPROVED');
    expect(result.isActive).toBe(true);
    expect(result.effectiveFrom).toBeNull();
    expect(result.effectiveUntil).toBeNull();
  });

  it('detects overlap between effective windows', async () => {
    mockTemplateRepo.findIdByCode.mockResolvedValue(100);
    mockVersionRepo.findByTemplateCode.mockResolvedValue([
      makeVersion({
        id: 1, version: '1.0.0', status: 'APPROVED',
        effective_from: pastDate, effective_until: futureDate,
      }),
      makeVersion({
        id: 2, version: '2.0.0', status: 'APPROVED',
        effective_from: yesterday, effective_until: tomorrow,
      }),
    ]);

    const warnings = await service.detectOverlaps('TPL-001');

    expect(warnings).toHaveLength(1);
  });
});
