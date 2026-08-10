/*
 * مواصفة القيد (SPEC-CONSTRAINT) — البنية الهيكلية لتعريف القيد:
 * المسند التشغيلي القابل للدحض لكل قاعدة دستورية. تُعرَّف هنا
 * الحقول البنيوية فقط (الشكل)، بلا كتابة أي مسند نهائي — كتابة
 * المسندات من عمل D2 في مرحلة لاحقة. المرجع: R2 (سجل القيود)
 * و constitutional-enforcement-architecture.md §2/§3.
 */
import { PHASE_2_SCOPE, SpecKindDefinition } from './types';

export const CONSTRAINT_SPEC_DEFINITION: SpecKindDefinition = {
  scope: PHASE_2_SCOPE,
  id: 'SPEC-CONSTRAINT',
  kind: 'Constraint',
  name: 'Constraint Specification',
  extends: 'R2',
  owner: 'D2',
  purpose:
    'Structural definition of a constraint specification: the falsifiable operational predicate of a constitutional rule (enforcement architecture §2). A rule with no registered constraint is unfalsifiable and therefore not enforceable.',
  shape: [
    { name: 'element', meaning: 'The constitutional element (P/I/G/EC) the constraint makes falsifiable (R1 reference).', required: true, source: 'constitutional-object-model §2.2 (constrains → Rule)' },
    { name: 'predicate', meaning: 'The falsifiable operational statement: the observable condition whose truth marks a violation.', required: true, source: 'enforcement architecture §2 (Constraint Registry)' },
    { name: 'falsifiabilityCriterion', meaning: 'The observable signature whose existence refutes the constraint.', required: true, source: 'enforcement architecture §2; AEM §3.2' },
    { name: 'examinedEvidence', meaning: 'The evidence artifact(s) the predicate examines (R3 reference).', required: true, source: 'constitutional-object-model §2.2 (examines → Evidence)' },
    { name: 'verificationTarget', meaning: 'The verification procedure defined to evaluate this constraint (R4 reference).', required: true, source: 'constitutional-object-model §2.2 (evaluated by → Verification)' },
  ],
  objectModelRelations: 'constrains → Rule; examines → Evidence; is evaluated by → Verification',
  stateMachineApplicability:
    'Follows the uniform state machine (constitutional-state-machine §5); Verified/Violated apply to constraints because the predicate is verified.',
  authority: [
    { document: 'ADR-002', section: 'Canonical Dataset Architecture (D2 Constraint)' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Constraint Registry); Section 3' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  instantiates:
    'R2 registers 12 present constraints ({I1, I11, EC1..EC10}) and records the 31-element gap (CONSTRAINT_GAP_COUNT = 31).',
};
