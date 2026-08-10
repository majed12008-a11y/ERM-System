/*
 * نموذج تبعية البوابة (MODEL-GATE-DEPENDENCY) — بنية اعتماد
 * البوابة على التحقق المطلوب قبلها وسلوك التوقف عند الفشل.
 * يُعرَّف الشكل والقواعد فقط؛ الربط الفعلي (R5:
 * GATE_ELEMENT_ASSIGNMENTS) يبقى صفريًا — الربط عمل لاحق.
 */
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

export interface GateDependencyRule {
  readonly id: string;
  readonly rule: string;
}

export const GATE_DEPENDENCY_RULES: ReadonlyArray<GateDependencyRule> = [
  { id: 'GD-1', rule: 'A gate depends on the verification procedures it requires; a gate with no required verification, or a verification with no gate, is a declaration (architecture §2).' },
  { id: 'GD-2', rule: 'No gate on a breach: a rule in Violated or Suspended may not bind a gate (state-machine §4.2).' },
  { id: 'GD-3', rule: 'A gate halts action when a required verification has failed or is unexecuted (haltOn).' },
  { id: 'GD-4', rule: 'Gate binding stays at baseline: R5 GATE_ELEMENT_ASSIGNMENTS is empty; binding the 9 Ready checks to gates is future work (§7.3).' },
];

export const GATE_DEPENDENCY_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-GATE-DEPENDENCY',
  name: 'Gate Dependency Model',
  purpose:
    'Defines the dependency structure of binding process points: a gate requires verification results, halts on failure or non-execution, and produces a gate ruling (Decision). The future engine enforces gates only through these dependency edges.',
  authority: [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 1 (D5); Section 2 (Gate Registry); Section 5 (state rule)' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3.4' },
    { document: 'constitutional-state-machine.md', section: 'Section 4.2' },
    { document: 'ADR-002' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['requires', 'is-required-by', 'produces'],
  objectKinds: ['Gate', 'Verification', 'Decision', 'Rule'],
  status:
    'Dependency structure defined; the five gates (GATE-01..GATE-05) remain unbound in R5 (0 assignments, empty requiredVerification). No gate executes.',
};
