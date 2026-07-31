// ============================================================
// Description: Version lifecycle types and constants for the
// template engine state machine. Defines statuses, transitions,
// actions, and a pure transition validator function.
// No service or repository dependencies.
// ============================================================

import { VALID_VERSION_STATUSES, VersionStatus } from './template-validation.types';

// 5 states: DRAFT, REVIEW, APPROVED, DEPRECATED, ARCHIVED
export type LifecycleStatus = VersionStatus;

// Transition action names that go into the audit log
export const LIFECYCLE_ACTIONS = [
  'CREATED', 'SUBMITTED', 'APPROVED', 'REJECTED',
  'DEPRECATED', 'ARCHIVED', 'ROLLED_BACK', 'SUPERSEDED',
] as const;

export type LifecycleAction = (typeof LIFECYCLE_ACTIONS)[number];

// The transition map: each key is a source state, value is array of valid target states
export const TRANSITION_MATRIX: Record<LifecycleStatus, LifecycleStatus[]> = {
  DRAFT: ['REVIEW'],
  REVIEW: ['APPROVED', 'DRAFT'],
  APPROVED: ['DEPRECATED'],
  DEPRECATED: ['ARCHIVED', 'APPROVED'],
  ARCHIVED: [],
};

// Maps (source, target) pair to the audit action name
export const TRANSITION_TO_ACTION: Record<string, LifecycleAction> = {
  'DRAFT->REVIEW': 'SUBMITTED',
  'REVIEW->APPROVED': 'APPROVED',
  'REVIEW->DRAFT': 'REJECTED',
  'APPROVED->DEPRECATED': 'DEPRECATED',
  'DEPRECATED->ARCHIVED': 'ARCHIVED',
  'DEPRECATED->APPROVED': 'ROLLED_BACK',
};

// Terminal states — no valid outgoing transitions
export const TERMINAL_STATUSES: LifecycleStatus[] = ['ARCHIVED'];

// Statuses that allow content modification
export const MUTABLE_STATUSES: LifecycleStatus[] = ['DRAFT'];

// Statuses considered "active" (usable for generation)
export const ACTIVE_STATUSES: LifecycleStatus[] = ['APPROVED', 'DEPRECATED'];

/**
 * Pure function: validates whether a transition from currentStatus
 * to targetStatus is allowed by the state machine.
 * Throws on invalid transition with a descriptive message.
 */
export function assertValidTransition(
  currentStatus: string,
  targetStatus: string,
): void {
  const allowed = TRANSITION_MATRIX[currentStatus as LifecycleStatus];
  if (!allowed) {
    throw Object.assign(
      new Error(`Unknown lifecycle status: "${currentStatus}"`),
      { status: 400 },
    );
  }
  if (!allowed.includes(targetStatus as LifecycleStatus)) {
    throw Object.assign(
      new Error(
        `Invalid transition: cannot move from ${currentStatus} to ${targetStatus}. ` +
        `Allowed targets from ${currentStatus}: ${allowed.join(', ') || '(none — terminal state)'}`,
      ),
      { status: 400 },
    );
  }
}

/**
 * Returns the audit action name for a given (from, to) transition pair.
 */
export function getTransitionAction(
  fromStatus: LifecycleStatus,
  toStatus: LifecycleStatus,
): LifecycleAction {
  const key = `${fromStatus}->${toStatus}`;
  return TRANSITION_TO_ACTION[key] || ('SUPERSEDED' as LifecycleAction);
}
