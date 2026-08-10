/*
 * مواصفة التحقق (SPEC-VERIFICATION) — البنية الهيكلية لتعريف
 * إجراء التحقق الموضوعي: مدخلاته ومخرجاته ومعياره ونتيجته.
 * التحقق يُسجَّل قبل أن يُشغَّل؛ تحقق غير مسجّل لا وجود له.
 * تُعرَّف هنا الحقول البنيوية فقط — لم يُنفَّذ أي إجراء. المرجع:
 * R4 (سجل التحقق) و constitutional-enforcement-architecture.md
 * §6.1/§8 و constitutional-state-machine.md §5.
 */
import { PHASE_2_SCOPE, SpecKindDefinition } from './types';

export const VERIFICATION_SPEC_DEFINITION: SpecKindDefinition = {
  scope: PHASE_2_SCOPE,
  id: 'SPEC-VERIFICATION',
  kind: 'Verification',
  name: 'Verification Specification',
  extends: 'R4',
  owner: 'D4',
  purpose:
    'Structural definition of a verification specification: the objective procedure that evaluates evidence against a constraint and produces a binary, recorded result. Verification is independent of the domains whose artifacts it verifies.',
  shape: [
    { name: 'procedureId', meaning: 'The verification procedure identity (R4 VERIFICATION_RECORDS reference).', required: true, source: 'enforcement architecture §2 (Verification Registry)' },
    { name: 'constraintRef', meaning: 'The constraint the procedure evaluates (R2 reference).', required: true, source: 'constitutional-object-model §2.2 (evaluates → Evidence against Constraint)' },
    { name: 'inputs', meaning: 'The inputs the procedure reads (evidence artifacts, files, catalogs).', required: true, source: 'enforcement architecture §2 (Verification Registry inputs)' },
    { name: 'outputs', meaning: 'The outputs the procedure produces (binary verdict, recorded decision).', required: true, source: 'enforcement architecture §2 (Verification Registry outputs)' },
    { name: 'expectedResult', meaning: 'The pass/fail criterion the procedure applies.', required: true, source: 'enforcement architecture §2 (Verification Registry)' },
    { name: 'lastRun', meaning: 'The recorded last run timestamp; unset means the procedure has never run (R4 status NotRegistered).', required: true, source: 'constitutional-state-machine §5 (Verified/Violated)' },
    { name: 'result', meaning: 'The recorded binary result; unset until the procedure runs.', required: true, source: 'constitutional-state-machine §5 (Verified/Violated)' },
  ],
  objectModelRelations: 'evaluates → Evidence against → Constraint; produces → Decision; is required by → Gate',
  stateMachineApplicability:
    'Follows the uniform state machine (constitutional-state-machine §5); Verified/Violated apply to verification procedures because the result states are theirs.',
  authority: [
    { document: 'ADR-002', section: 'Canonical Dataset Architecture (D4 Verification; EC1-EC10 initial set)' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Verification Registry); Section 6.1; Section 8' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  instantiates:
    'R4 registers the EC1..EC10 initial verification set (7 Ready / 3 NeedsExtension) plus READY_OUTSIDE_INITIAL_SET (I11, G11).',
};
