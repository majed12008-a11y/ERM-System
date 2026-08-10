/*
 * نموذج تبعية التحقق (MODEL-VERIFICATION-DEPENDENCY) — بنية
 * اعتماد إجراء التحقق على قيده وعلى الدليل الذي يفحصه القيد،
 * مع استقلالية D4 الهيكلية. يُعرَّف الشكل والقواعد فقط؛ لا
 * يُنفَّذ أي إجراء تحقق (R4: كل السجلات NotRegistered).
 */
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

export interface VerificationDependencyRule {
  readonly id: string;
  readonly rule: string;
}

export const VERIFICATION_DEPENDENCY_RULES: ReadonlyArray<VerificationDependencyRule> = [
  { id: 'VD-1', rule: 'A verification procedure evaluates evidence against its constraint; it depends on the constraint (R2) and on the evidence the constraint examines (R3).' },
  { id: 'VD-2', rule: 'Verification is registered before it runs; an unregistered verification does not exist (R4).' },
  { id: 'VD-3', rule: 'Verification independence is structural: D4 is independent of the domains whose artifacts it verifies.' },
  { id: 'VD-4', rule: 'A verification produces a binary, recorded result (produces → Decision).' },
  { id: 'VD-5', rule: 'Ready checks outside the EC set (I11, G11) are registered in R4 READY_OUTSIDE_INITIAL_SET; they are referenced, not executed.' },
];

export const VERIFICATION_DEPENDENCY_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-VERIFICATION-DEPENDENCY',
  name: 'Verification Dependency Model',
  purpose:
    'Defines the dependency structure of verification procedures (constraint → evidence → procedure → recorded decision) and the independence invariant that keeps verification objective. The future engine resolves which evidence a procedure reads and which constraint it evaluates against through this model.',
  authority: [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 1 (D4); Section 2 (Verification Registry); Section 6.1' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3.3' },
    { document: 'ADR-002' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['evaluates', 'is-evaluated-by', 'examines', 'produces', 'is-required-by'],
  objectKinds: ['Verification', 'Constraint', 'Evidence', 'Decision', 'Gate'],
  status:
    'Dependency structure defined; R4 records remain unexecuted (status NotRegistered for all 10 EC procedures). No procedure is authored or run.',
};
