import { describe, it, expect } from 'vitest';
import {
  TRANSITION_MATRIX,
  TERMINAL_STATUSES,
  MUTABLE_STATUSES,
  ACTIVE_STATUSES,
  assertValidTransition,
  getTransitionAction,
} from '../shared/template-version-lifecycle.types';

describe('Transition Matrix', () => {
  it('defines all 5 statuses', () => {
    expect(Object.keys(TRANSITION_MATRIX)).toEqual(
      expect.arrayContaining(['DRAFT', 'REVIEW', 'APPROVED', 'DEPRECATED', 'ARCHIVED']),
    );
    expect(Object.keys(TRANSITION_MATRIX)).toHaveLength(5);
  });

  it('DRAFT can only go to REVIEW', () => {
    expect(TRANSITION_MATRIX.DRAFT).toEqual(['REVIEW']);
  });

  it('REVIEW can go to APPROVED or DRAFT', () => {
    expect(TRANSITION_MATRIX.REVIEW).toEqual(['APPROVED', 'DRAFT']);
  });

  it('APPROVED can only go to DEPRECATED', () => {
    expect(TRANSITION_MATRIX.APPROVED).toEqual(['DEPRECATED']);
  });

  it('DEPRECATED can go to ARCHIVED or APPROVED (rollback)', () => {
    expect(TRANSITION_MATRIX.DEPRECATED).toEqual(['ARCHIVED', 'APPROVED']);
  });

  it('ARCHIVED is terminal — no outgoing transitions', () => {
    expect(TRANSITION_MATRIX.ARCHIVED).toEqual([]);
  });
});

describe('assertValidTransition', () => {
  const legalTransitions = [
    ['DRAFT', 'REVIEW'],
    ['REVIEW', 'APPROVED'],
    ['REVIEW', 'DRAFT'],
    ['APPROVED', 'DEPRECATED'],
    ['DEPRECATED', 'ARCHIVED'],
    ['DEPRECATED', 'APPROVED'],
  ];

  it.each(legalTransitions)('allows %s → %s', (from, to) => {
    expect(() => assertValidTransition(from, to)).not.toThrow();
  });

  const illegalTransitions = [
    ['DRAFT', 'APPROVED'],
    ['DRAFT', 'DEPRECATED'],
    ['DRAFT', 'ARCHIVED'],
    ['REVIEW', 'DEPRECATED'],
    ['REVIEW', 'ARCHIVED'],
    ['APPROVED', 'REVIEW'],
    ['APPROVED', 'DRAFT'],
    ['APPROVED', 'ARCHIVED'],
    ['DEPRECATED', 'REVIEW'],
    ['DEPRECATED', 'DRAFT'],
    ['ARCHIVED', 'DRAFT'],
    ['ARCHIVED', 'REVIEW'],
    ['ARCHIVED', 'APPROVED'],
    ['ARCHIVED', 'DEPRECATED'],
    ['ARCHIVED', 'ARCHIVED'],
  ];

  it.each(illegalTransitions)('rejects %s → %s with 400', (from, to) => {
    expect(() => assertValidTransition(from, to)).toThrow();
    try {
      assertValidTransition(from, to);
    } catch (e: any) {
      expect(e.status).toBe(400);
    }
  });

  it('throws for unknown status', () => {
    expect(() => assertValidTransition('UNKNOWN', 'DRAFT')).toThrow('Unknown');
  });
});

describe('getTransitionAction', () => {
  it('returns SUBMITTED for DRAFT→REVIEW', () => {
    expect(getTransitionAction('DRAFT', 'REVIEW')).toBe('SUBMITTED');
  });

  it('returns REJECTED for REVIEW→DRAFT', () => {
    expect(getTransitionAction('REVIEW', 'DRAFT')).toBe('REJECTED');
  });

  it('returns SUPERSEDED for unexpected pairs', () => {
    expect(getTransitionAction('APPROVED', 'APPROVED')).toBe('SUPERSEDED');
  });
});

describe('Status constants', () => {
  it('ARCHIVED is the only terminal status', () => {
    expect(TERMINAL_STATUSES).toEqual(['ARCHIVED']);
  });

  it('only DRAFT is mutable', () => {
    expect(MUTABLE_STATUSES).toEqual(['DRAFT']);
  });

  it('APPROVED and DEPRECATED are active', () => {
    expect(ACTIVE_STATUSES).toEqual(['APPROVED', 'DEPRECATED']);
  });
});
