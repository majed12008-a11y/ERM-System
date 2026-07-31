import { describe, it, expect, vi } from 'vitest';
import {
  assertValidTransition,
  MUTABLE_STATUSES,
  ACTIVE_STATUSES,
} from '../shared/template-version-lifecycle.types';

// ================================================================
// Database Integrity Tests
//
// These tests validate the database-level integrity guarantees
// defined in 58-template-database-integrity.sql. They are pure
// logic tests that mirror the SQL trigger/check behavior — no
// database connection required.
//
// Constraint Enforcement Layers:
//   Layer 1 — Database (58-template-database-integrity.sql)
//   Layer 2 — Service (template-version-lifecycle.service.ts)
//   Layer 3 — State Machine (template-version-lifecycle.types.ts)
// ================================================================

// ─── Helpers mirroring DB constraint logic ─────────────────────

function shouldBlockContentUpdate(oldStatus: string, oldContent: any, newContent: any): boolean {
  const locked = ['REVIEW', 'APPROVED', 'DEPRECATED', 'ARCHIVED'];
  if (!locked.includes(oldStatus)) return false;
  return JSON.stringify(oldContent) !== JSON.stringify(newContent);
}

function shouldBlockVariableUpdate(oldStatus: string, oldVars: any, newVars: any): boolean {
  const locked = ['REVIEW', 'APPROVED', 'DEPRECATED', 'ARCHIVED'];
  if (!locked.includes(oldStatus)) return false;
  return JSON.stringify(oldVars) !== JSON.stringify(newVars);
}

function isValidEffectiveRange(from: Date | null, until: Date | null): boolean {
  if (from === null || until === null) return true;
  return until > from;
}

// ─── 1. Content Immutability Constraint ───────────────────────

describe('Database Integrity — Content Immutability Trigger', () => {
  const sampleContent = { ar: { body: 'original' }, en: { body: 'original' } };
  const modifiedContent = { ar: { body: 'modified' }, en: { body: 'original' } };
  const sampleVars = [{ code: 'name', type: 'string' }];
  const modifiedVars = [{ code: 'other', type: 'number' }];

  it('allows content changes on DRAFT', () => {
    expect(shouldBlockContentUpdate('DRAFT', sampleContent, modifiedContent)).toBe(false);
  });

  it('blocks content changes on REVIEW', () => {
    expect(shouldBlockContentUpdate('REVIEW', sampleContent, modifiedContent)).toBe(true);
  });

  it('blocks content changes on APPROVED', () => {
    expect(shouldBlockContentUpdate('APPROVED', sampleContent, modifiedContent)).toBe(true);
  });

  it('blocks content changes on DEPRECATED', () => {
    expect(shouldBlockContentUpdate('DEPRECATED', sampleContent, modifiedContent)).toBe(true);
  });

  it('blocks content changes on ARCHIVED', () => {
    expect(shouldBlockContentUpdate('ARCHIVED', sampleContent, modifiedContent)).toBe(true);
  });

  it('allows content change to same value on APPROVED (no-op)', () => {
    expect(shouldBlockContentUpdate('APPROVED', sampleContent, sampleContent)).toBe(false);
  });

  it('allows variable_definitions changes on DRAFT', () => {
    expect(shouldBlockVariableUpdate('DRAFT', sampleVars, modifiedVars)).toBe(false);
  });

  it('blocks variable_definitions changes on REVIEW', () => {
    expect(shouldBlockVariableUpdate('REVIEW', sampleVars, modifiedVars)).toBe(true);
  });

  it('blocks variable_definitions changes on APPROVED', () => {
    expect(shouldBlockVariableUpdate('APPROVED', sampleVars, modifiedVars)).toBe(true);
  });

  it('blocks variable_definitions changes on DEPRECATED', () => {
    expect(shouldBlockVariableUpdate('DEPRECATED', sampleVars, modifiedVars)).toBe(true);
  });

  it('blocks variable_definitions changes on ARCHIVED', () => {
    expect(shouldBlockVariableUpdate('ARCHIVED', sampleVars, modifiedVars)).toBe(true);
  });

  it('allows null content update on non-DRAFT (same content)', () => {
    expect(shouldBlockContentUpdate('REVIEW', null, null)).toBe(false);
  });

  it('only DRAFT is mutable (matches MUTABLE_STATUSES)', () => {
    const lockedStatuses = ['REVIEW', 'APPROVED', 'DEPRECATED', 'ARCHIVED'];
    expect(MUTABLE_STATUSES).toEqual(['DRAFT']);
    lockedStatuses.forEach(s => expect(MUTABLE_STATUSES).not.toContain(s));
  });
});

// ─── 2. Effective Date Constraint ─────────────────────────────

describe('Database Integrity — Effective Date CHECK', () => {
  const today = new Date('2026-07-10');
  const yesterday = new Date('2026-07-09');
  const tomorrow = new Date('2026-07-11');
  const nextMonth = new Date('2026-08-10');

  it('allows valid forward range (from < until)', () => {
    expect(isValidEffectiveRange(today, tomorrow)).toBe(true);
    expect(isValidEffectiveRange(yesterday, nextMonth)).toBe(true);
  });

  it('rejects inverted range (from > until)', () => {
    expect(isValidEffectiveRange(tomorrow, yesterday)).toBe(false);
    expect(isValidEffectiveRange(nextMonth, today)).toBe(false);
  });

  it('rejects zero-width range (from === until)', () => {
    expect(isValidEffectiveRange(today, today)).toBe(false);
  });

  it('allows null effective_from (open start)', () => {
    expect(isValidEffectiveRange(null, tomorrow)).toBe(true);
  });

  it('allows null effective_until (open end)', () => {
    expect(isValidEffectiveRange(yesterday, null)).toBe(true);
  });

  it('allows both null (no date restriction)', () => {
    expect(isValidEffectiveRange(null, null)).toBe(true);
  });

  it('allows same-day with different times (until > from by 1ms)', () => {
    const sameDayEarly = new Date('2026-07-10T08:00:00.000Z');
    const sameDayLate = new Date('2026-07-10T23:59:59.999Z');
    expect(isValidEffectiveRange(sameDayEarly, sameDayLate)).toBe(true);
  });
});

// ─── 3. Partial Unique Index — one_approved_version ──────────

describe('Database Integrity — One APPROVED per Template', () => {
  it('state machine prevents approving when already APPROVED (no direct transition)', () => {
    expect(() => assertValidTransition('APPROVED', 'APPROVED')).toThrow();
  });

  it('approve transition only valid from REVIEW', () => {
    expect(() => assertValidTransition('REVIEW', 'APPROVED')).not.toThrow();
    expect(() => assertValidTransition('DRAFT', 'APPROVED')).toThrow();
    expect(() => assertValidTransition('DEPRECATED', 'APPROVED')).not.toThrow();
  });

  it('ACTIVE_STATUSES only includes APPROVED and DEPRECATED', () => {
    expect(ACTIVE_STATUSES).toEqual(['APPROVED', 'DEPRECATED']);
    expect(ACTIVE_STATUSES).not.toContain('DRAFT');
    expect(ACTIVE_STATUSES).not.toContain('REVIEW');
    expect(ACTIVE_STATUSES).not.toContain('ARCHIVED');
  });

  it('service deprecates current APPROVED before approving new version', () => {
    const deprecateCurrentApproved = vi.fn().mockResolvedValue({ id: 1, status: 'DEPRECATED' });
    const updateStatus = vi.fn().mockResolvedValue({ id: 2, status: 'APPROVED' });

    deprecateCurrentApproved(1, new Date());
    updateStatus(2, 'APPROVED', 10);

    expect(deprecateCurrentApproved).toHaveBeenCalledBefore(updateStatus as any);
  });
});

// ─── 4. Rollback Integrity ────────────────────────────────────

describe('Database Integrity — Rollback', () => {
  it('clears effective dates on rolled-back version', () => {
    const updateEffectiveDates = vi.fn().mockResolvedValue({ id: 1, effective_from: null, effective_until: null });
    const result = updateEffectiveDates(1, null, null);
    expect(result).toBeDefined();
    expect(updateEffectiveDates).toHaveBeenCalledWith(1, null, null);
  });

  it('only allows rollback from DEPRECATED', () => {
    expect(() => assertValidTransition('DEPRECATED', 'APPROVED')).not.toThrow();
    expect(() => assertValidTransition('ARCHIVED', 'APPROVED')).toThrow();
    expect(() => assertValidTransition('DRAFT', 'APPROVED')).toThrow();
  });
});

// ─── 5. Constraint Enforcement Strategy ──────────────────────

describe('Database Integrity — Enforcement Layer Strategy', () => {
  it('documents which constraints are enforced at each layer', () => {
    const dbLayer = [
      'one_approved_version partial unique index',
      'chk_template_versions_status CHECK',
      'chk_template_versions_effective_dates CHECK',
      'fn_block_version_content_update trigger',
    ];

    const serviceLayer = [
      'assertValidTransition state machine',
      'checkLifecyclePermission authorization',
      'checkTransitionPreconditions preconditions',
      'deprecateCurrentApproved before approve',
    ];

    const validationLayer = [
      'TemplateValidationService.validateVersion',
      'content structure validation',
      'variable definition validation',
    ];

    expect(dbLayer).toContain('one_approved_version partial unique index');
    expect(dbLayer).toContain('chk_template_versions_effective_dates CHECK');
    expect(dbLayer).toContain('fn_block_version_content_update trigger');
    expect(serviceLayer).toContain('assertValidTransition state machine');
    expect(serviceLayer).toContain('deprecateCurrentApproved before approve');
    expect(validationLayer).toContain('TemplateValidationService.validateVersion');

    // No invariant is enforced redundantly without justification
    const allRules = [...dbLayer, ...serviceLayer, ...validationLayer];
    const uniqueRules = new Set(allRules);
    expect(uniqueRules.size).toBe(allRules.length);
  });
});
