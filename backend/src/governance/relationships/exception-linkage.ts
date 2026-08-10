/*
 * نموذج ربط الاستثناء (MODEL-EXCEPTION-LINKAGE) — بنية ربط
 * الاستثناء بالقرار الذي منحه وبالقاعدة التي يعلّقها. يُعرَّف
 * الشكل والقواعد فقط؛ لا يُسجَّل أي استثناء جديد (R9: السابقة
 * الوحيدة I11 غير مسجّلة ومؤجّلة مع مراجعة ADR لها).
 */
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

/** شكل سجل استثناء — تعريف نوعي، لا مثيلات. */
export interface ExceptionLinkageRecord {
  readonly exceptionId: string;
  readonly grantedByDecisionId: string;
  readonly suspendsElement: string;
  readonly authority: string;
  readonly scope: string;
  readonly expiry: string;
  readonly status: string;
}

export interface ExceptionLinkageRule {
  readonly id: string;
  readonly rule: string;
}

export const EXCEPTION_LINKAGE_RULES: ReadonlyArray<ExceptionLinkageRule> = [
  { id: 'EL-1', rule: 'An exception is granted by a Decision and suspends the affected Rule for its duration (object-model §2.2).' },
  { id: 'EL-2', rule: 'Exceptions are explicit, bounded, and expiring; a Suspended rule without an exception record is a state violation (state-machine §4.3).' },
  { id: 'EL-3', rule: 'A deviation not recorded in the Exception Registry is a violation regardless of intent.' },
  { id: 'EL-4', rule: 'The known I11 SECURITY DEFINER precedent remains unrecorded and deferred with its ADR review (R9 KNOWN_PRECEDENTS).' },
  { id: 'EL-5', rule: 'Exceptions follow the uniform state machine: Approved → Active (on grant) → Archived (on expiry).' },
];

export const EXCEPTION_LINKAGE_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-EXCEPTION-LINKAGE',
  name: 'Exception Linkage Model',
  purpose:
    'Defines the linkage structure of sanctioned deviations: an exception is granted by a decision, suspends a rule, and carries authority, scope, and expiry. The future engine resolves the Suspended state only through this linkage.',
  authority: [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 1 (D6); Section 2 (Exception Registry); Section 4 (Exception stage)' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3.6' },
    { document: 'constitutional-state-machine.md', section: 'Section 4.3; Section 5' },
    { document: 'ADR-002' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['grants', 'suspends', 'attaches-to'],
  objectKinds: ['Exception', 'Decision', 'Rule', 'Lifecycle', 'Baseline'],
  status:
    'Linkage structure defined; R9 registers only the unrecorded/deferred I11 precedent. No exception is granted or processed. `records` is not composed here: a decision granting an exception is already expressed by `grants`; `records` ranges Decision → Verification/Gate, outside this model\'s span.',
};
