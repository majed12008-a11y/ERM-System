/*
 * نموذج أثر القرار (MODEL-DECISION-PROVENANCE) — بنية سجل قرار
 * نتائج التحقق وأحكام البوابات بسلطتها وتتبعها الرجعي (T3/G3/EC8).
 * يُعرَّف الشكل والقواعد فقط؛ لا يُسجَّل أي قرار (R6: خط الأساس
 * 0 قرارات). بدون سجل قرار يكون الإنفاذ غير قابل للملاحظة.
 */
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

/** شكل سجل أثر القرار — تعريف نوعي، لا مثيلات. */
export interface DecisionProvenanceRecord {
  readonly decisionId: string;
  readonly decisionType: string;
  readonly sourceKind: 'Verification' | 'Gate';
  readonly sourceId: string;
  readonly authority: string;
  readonly recordedOn: string;
  readonly tracesTo: ReadonlyArray<string>;
}

export interface DecisionProvenanceRule {
  readonly id: string;
  readonly rule: string;
}

export const DECISION_PROVENANCE_RULES: ReadonlyArray<DecisionProvenanceRule> = [
  { id: 'DP-1', rule: 'Every verification outcome and gate ruling is recorded as a Decision with authority (T3/G3/EC8).' },
  { id: 'DP-2', rule: 'A decision without recorded authority is a note, not a decision (object-model §3.5).' },
  { id: 'DP-3', rule: 'Traceability runs backward: decision → evidence → constraint → rule; an untraceable decision fails T3.' },
  { id: 'DP-4', rule: 'No decision may rely on an execution event absent from the Execution Registry (R7).' },
  { id: 'DP-5', rule: 'Decisions follow the uniform state machine: Approved → Active (on record) → Archived (when superseded).' },
];

export const DECISION_PROVENANCE_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-DECISION-PROVENANCE',
  name: 'Decision Provenance Model',
  purpose:
    'Defines the provenance record a decision must carry so enforcement is observable: the outcome source (verification or gate), the authority, the record date, and the backward trace chain. The future engine writes and audits decisions against this shape.',
  authority: [
    { document: 'ADR-002', section: 'T3 / G3 / EC8' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Decision Registry); Section 1 (D6)' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3.5' },
    { document: 'constitutional-state-machine.md', section: 'Section 5' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['records', 'produces', 'traverses', 'attaches-to'],
  objectKinds: ['Decision', 'Verification', 'Gate', 'Evidence', 'Constraint', 'Rule', 'Traceability', 'Lifecycle'],
  status:
    'Provenance shape defined; R6 records zero decisions (baseline). No decision is recorded or audited. `cites` is not composed here: the vocabulary range of `cites` is ADR → Evidence/Traceability (object-model §2.2), which cannot express a decision citing a document (review MED-1).',
};
