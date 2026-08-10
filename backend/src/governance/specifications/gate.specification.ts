/*
 * مواصفة البوابة (SPEC-GATE) — البنية الهيكلية لتعريف البوابة:
 * نقطة العملية الملزمة التي تُنفَّذ عندها نتائج التحقق. بوابة بلا
 * تحقق مطلوب أو تحقق بلا بوابة هو إعلان فقط. تُعرَّف هنا الحقول
 * البنيوية فقط؛ ربط البوابات بالتحقق (GATE_ELEMENT_ASSIGNMENTS)
 * من عمل مرحلة لاحقة. المرجع: R5 (سجل البوابات) و
 * constitutional-enforcement-architecture.md §2/§5.
 */
import { PHASE_2_SCOPE, SpecKindDefinition } from './types';

export const GATE_SPEC_DEFINITION: SpecKindDefinition = {
  scope: PHASE_2_SCOPE,
  id: 'SPEC-GATE',
  kind: 'Gate',
  name: 'Gate Specification',
  extends: 'R5',
  owner: 'D5',
  purpose:
    'Structural definition of a gate specification: the binding process point at which verification results are enforced. No action passes a gate while a required verification has failed or is unexecuted.',
  shape: [
    { name: 'gateId', meaning: 'The gate identity (R5 GATES reference: GATE-01..GATE-05).', required: true, source: 'enforcement architecture §2 (Gate Registry)' },
    { name: 'requiredVerification', meaning: 'The verification procedures required before the gate passes (R4 references).', required: true, source: 'constitutional-object-model §2.2 (requires → Verification)' },
    { name: 'haltOn', meaning: 'The condition under which the gate halts action: a required verification failed or unexecuted.', required: true, source: 'enforcement architecture §2 (Gate Registry); §5 state rule' },
    { name: 'produces', meaning: 'The decision record the gate ruling produces (R6 reference).', required: true, source: 'constitutional-object-model §2.2 (produces → Decision)' },
  ],
  objectModelRelations: 'requires → Verification; produces → Decision (gate ruling); halts action on failure',
  stateMachineApplicability:
    'Follows the uniform state machine (constitutional-state-machine §5); gates bind in Active and are archived when superseded.',
  authority: [
    { document: 'ADR-002', section: 'Canonical Dataset Architecture (D5 Gate)' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Gate Registry); Section 5' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  instantiates:
    'R5 registers GATE-01..GATE-05 with 0 bound verifications (GATE_ELEMENT_ASSIGNMENTS empty); binding is a later phase.',
};
