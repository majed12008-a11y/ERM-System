/*
 * نموذج الرسم البياني للتتبع (MODEL-TRACEABILITY) — بنية سلسلة
 * التتبع الرجعي Decision → Evidence → Constraint → Rule (T3/G3/EC8).
 * يُعرَّف هنا شكل السلسلة والحواف فقط؛ لا يُسجَّل أي قرار ولا
 * تُشغَّل أي سلسلة (خط الأساس: 0 قرارات). نموذج وصفي سلبي فقط.
 *
 * سلسلة مراجعة EC8 المسجَّلة في هذه المرحلة: Decision → Evidence →
 * Constraint → Rule (object-model §2.3; ADR-002 T3). الصيغة البديلة
 * لسلسلة §4 الكاملة (عبر Verification/Gate) غموض في المصدر — أُحيل
 * إلى مجلس ADR (قرار المراجعة LOW-2) وتبقى القرار لمحرك الإنفاذ قبل
 * بناء مراجعة EC8. أصناف الكائنات تشمل Verification/Gate/ADR لأن
 * الحواف المكوِّنة (records/produces/evaluates/cites) تتطلب مداها؛
 * هذا لا يغيّر ترتيب السلسلة المُسجَّل في TRACEABILITY_CHAIN.
 */
import { ConstitutionalObjectKind } from './types';
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

export interface TraceabilityNode {
  readonly kind: ConstitutionalObjectKind;
  readonly anchor: string;
  readonly direction: string;
}

/** سلسلة التتبع الرجعي بترتيبها (T3; EC8). */
export const TRACEABILITY_CHAIN: ReadonlyArray<TraceabilityNode> = [
  { kind: 'Decision', anchor: 'R6', direction: 'records the outcome of a verification/gate' },
  { kind: 'Evidence', anchor: 'R3', direction: 'is the artifact the constraint examined' },
  { kind: 'Constraint', anchor: 'R2', direction: 'is the predicate the rule is constrained by' },
  { kind: 'Rule', anchor: 'R1', direction: 'is the constitutional source (P/I/G/EC)' },
];

export const TRACEABILITY_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-TRACEABILITY',
  name: 'Traceability Object Graph',
  purpose:
    'Defines the backward traceability graph required by T3/G3/EC8: every decision must trace decision → evidence → constraint → rule. The graph is the structural contract the future engine audits chains against. The EC8 audit chain recorded by Phase 3 is Decision → Evidence → Constraint → Rule (object-model §2.3; ADR-002 T3); the alternative full-chain reading via Verification/Gate (object-model §4) is a known source ambiguity surfaced to the ADR board (review LOW-2) and must be reconciled before the engine builds the EC8 audit.',
  authority: [
    { document: 'ADR-002', section: 'T3 / G3 / EC8' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2; Section 3' },
    { document: 'constitutional-object-model.md', section: 'Section 2.3; Section 3' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['records', 'produces', 'traverses', 'cites', 'evaluates', 'examines', 'constrained-by'],
  objectKinds: ['Decision', 'Evidence', 'Constraint', 'Rule', 'Traceability', 'Verification', 'Gate', 'ADR'],
  status:
    'Graph shape and the recorded EC8 audit chain defined; no chain is instantiated (0 decisions recorded in R6). EC8 remains scaffold-only until the future engine audits against recorded provenance.',
};
