/*
 * مواصفة القرار (SPEC-DECISION) — البنية الهيكلية لتعريف القرار:
 * النتيجة المسجّلة لكل تحقق ولكل حكم بوابة بسلطتها. بدون سجل قرار
 * يكون الإنفاذ غير قابل للملاحظة (T3/G3/EC8). تُعرَّف هنا الحقول
 * البنيوية فقط — لا يُسجَّل أي قرار. المرجع: R6 (سجل القرارات) و
 * constitutional-enforcement-architecture.md §2/§3.
 */
import { PHASE_2_SCOPE, SpecKindDefinition } from './types';

export const DECISION_SPEC_DEFINITION: SpecKindDefinition = {
  scope: PHASE_2_SCOPE,
  id: 'SPEC-DECISION',
  kind: 'Decision',
  name: 'Decision Specification',
  extends: 'R6',
  owner: 'D6',
  purpose:
    'Structural definition of a decision specification: the recorded outcome of a verification, a gate ruling, an ADR approval, or an exception grant, with its authority. A decision without recorded authority is a note, not a decision.',
  shape: [
    { name: 'decisionId', meaning: 'The decision record identity.', required: true, source: 'enforcement architecture §2 (Decision Registry)' },
    { name: 'type', meaning: 'The decision type: Verification outcome | Gate ruling | ADR approval | Exception grant (R6 DecisionType).', required: true, source: 'R6 DecisionType; constitutional-object-model §2.2' },
    { name: 'targetElement', meaning: 'The constitutional object the decision concerns (R1 reference).', required: true, source: 'enforcement architecture §2 (Decision Registry)' },
    { name: 'authority', meaning: 'The recorded authority (D6); a decision without authority is a note.', required: true, source: 'constitutional-object-model §3.5' },
    { name: 'recordedOn', meaning: 'The date the decision was recorded (provenance).', required: true, source: 'ADR-002 T3 / G3; enforcement architecture §2' },
    { name: 'tracesTo', meaning: 'The backward traceability chain decision → evidence → constraint → rule (T3 / EC8).', required: true, source: 'ADR-002 T3 / G3 / EC8; constitutional-object-model §2.3' },
  ],
  objectModelRelations: 'records → Verification/Gate outcome; may grant → Exception; requires recorded Authority',
  stateMachineApplicability:
    'Follows the uniform state machine (constitutional-state-machine §5); a decision is Approved, becomes Active on record, and is Archived when superseded.',
  authority: [
    { document: 'ADR-002', section: 'T3 / G3 / EC8' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Decision Registry); Section 3' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  instantiates: 'R6 registers 0 recorded decisions (baseline); decisions are recorded only by D6.',
};
