/*
 * سجل حالة البنية (R8) — الحالة القانونية لكل كائن
 * دستوري وفق constitutional-state-machine.md. قاعدة مجهولة
 * الحالة غير قابلة للاستخدام. تسعة حالات وخمس عشرة
 * انتقالة. مرحلة الأولى تسجيل هيكلي فقط — لا تُسنَد أي
 * حالة فعلية لأي كائن هنا بعد.
 */
import { ConstitutionalStateDefinition, StateTransition } from './types';
import { ConstitutionalRegistry } from './registry';

export const CONSTITUTIONAL_STATES: ReadonlyArray<ConstitutionalStateDefinition> = [
  { id: 'Draft', meaning: 'Written; not constitutional.', bindingEffect: 'Binds nothing.' },
  { id: 'Proposed', meaning: 'Submitted for ADR approval; under review.', bindingEffect: 'Binds nothing; pending a decision.' },
  { id: 'Approved', meaning: 'Accepted as constitutional; not yet bound to verification.', bindingEffect: 'Governs in principle; no enforcement attached.' },
  { id: 'Active', meaning: 'Binding; linked to constraint, evidence, and verification.', bindingEffect: 'Governs all future work; verification attached.' },
  { id: 'Verified', meaning: 'Active and last verification passed.', bindingEffect: 'Governs; usable at gates.' },
  { id: 'Violated', meaning: 'Active and last verification failed, or a violation was detected.', bindingEffect: 'Governs but is in breach; may not bind a gate.' },
  { id: 'Suspended', meaning: 'Active obligations deferred by a recorded Exception.', bindingEffect: 'Obligations deferred; may not bind a gate.' },
  { id: 'Deprecated', meaning: 'Superseded; creates no new obligations; history preserved.', bindingEffect: 'Binds nothing new; existing obligations carry through replacement (T6).' },
  { id: 'Archived', meaning: 'Retired; immutable history.', bindingEffect: 'Terminal for normal use; never authoritative for implementation.' },
];

export const STATE_TRANSITIONS: ReadonlyArray<StateTransition> = [
  { from: 'Draft', to: 'Proposed', condition: 'Submitted to the ADR board.', authority: 'Owner (D1)' },
  { from: 'Proposed', to: 'Approved', condition: 'ADR accepted.', authority: 'ADR board' },
  { from: 'Proposed', to: 'Draft', condition: 'Rejected or returned for revision.', authority: 'ADR board' },
  { from: 'Approved', to: 'Active', condition: 'Verification bound; gate assigned.', authority: 'ADR board + owner of verification (D4)' },
  { from: 'Approved', to: 'Deprecated', condition: 'Superseded before activation.', authority: 'ADR board' },
  { from: 'Active', to: 'Verified', condition: 'Verification passed.', authority: 'Verification (D4)' },
  { from: 'Active', to: 'Violated', condition: 'Verification failed or violation detected.', authority: 'Verification (D4)' },
  { from: 'Verified', to: 'Violated', condition: 'Subsequent verification failed.', authority: 'Verification (D4)' },
  { from: 'Violated', to: 'Verified', condition: 'Remediation passed re-verification.', authority: 'Verification (D4)' },
  { from: 'Violated', to: 'Suspended', condition: 'Exception granted with scope and expiry.', authority: 'ADR board / recorded authority (D6)' },
  { from: 'Violated', to: 'Deprecated', condition: 'Replaced by ADR while violated.', authority: 'ADR board' },
  { from: 'Suspended', to: 'Active', condition: 'Exception expired or lifted.', authority: 'Authority that granted the exception' },
  { from: 'Suspended', to: 'Deprecated', condition: 'Replaced while suspended.', authority: 'ADR board' },
  { from: 'Deprecated', to: 'Archived', condition: 'Retirement executed; archive manifest recorded.', authority: 'Owner (D1/D7)' },
  { from: 'Archived', to: null, condition: 'Terminal. Revival requires a new ADR (a new object).', authority: '—' },
];

/** قواعد آلة الحالة (constitutional-state-machine.md §4). */
export const STATE_RULES: ReadonlyArray<string> = [
  'No binding without Active.',
  'No gate on a breach: Violated or Suspended may not bind a Gate (D5).',
  'Exceptions are recorded and expiring (D6); a Suspended rule without an exception record is a state violation.',
  'No silent retirement: Archived requires passing through Deprecated and recording an archive manifest (T6, T8).',
  'Archived is terminal; revival requires a new ADR creating a new object.',
  'Every transition has an authority (D6); a transition without a recorded authority is an undocumented state change.',
  'State is observable: the current state is held in the Architecture State Registry (D7).',
];

export const STATE_REGISTRY = new ConstitutionalRegistry<StateTransition>(
  'R8',
  'Architecture State Registry',
  'D7',
  [
    { document: 'constitutional-state-machine.md' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 5' },
  ],
  STATE_TRANSITIONS,
);