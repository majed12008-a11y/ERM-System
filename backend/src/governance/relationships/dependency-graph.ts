/*
 * نموذج مخطط التبعيات الدستوري (MODEL-DEPENDENCY-GRAPH) —
 * بنية سلسلة الإنفاذ وتبعياتها: Rule ← Constraint ← Evidence ←
 * Verification ← Gate ← Decision. يُعرَّف هنا شكل المخطط
 * (العقد والحواف) فقط؛ الربط الفعلي لكل عنصر يبقى في R1 (حالات
 * الروابط) وربط البوابات عمل لاحق. نموذج وصفي سلبي فقط.
 *
 * عقد تدفق الإنفاذ: من Rule (مؤشر 0) إلى Decision (مؤشر 5).
 * حواف الحواف الخمس لا تتشارك اتجاهًا واحدًا بالنسبة لهذا التدفق
 * (قرار المراجعة HIGH-1): forward = في اتجاه التدفق (مؤشر أدنى →
 * أعلى)، backward = عكس التدفق (مؤشر أعلى → أدنى) أي حافة
 * مسبقة/تبعية. التتبع اللاحق (محرك الإنفاذ) يجب أن يقرأ هذا
 * العقد صراحة: الحواف forward تُقطع كما هي، والحواف backward
 * تُقطع معكوسة.
 */
import { ConstitutionalObjectKind } from './types';
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

export interface ChainNode {
  readonly kind: ConstitutionalObjectKind;
  readonly anchor: string;
}

/** سلسلة الإنفاذ بترتيبها (constitutional-object-model.md §4). */
export const ENFORCEMENT_CHAIN: ReadonlyArray<ChainNode> = [
  { kind: 'Rule', anchor: 'R1' },
  { kind: 'Constraint', anchor: 'R2' },
  { kind: 'Evidence', anchor: 'R3' },
  { kind: 'Verification', anchor: 'R4' },
  { kind: 'Gate', anchor: 'R5' },
  { kind: 'Decision', anchor: 'R6' },
];

/** الحواف المكوِّنة للمخطط: أنواع العلاقات بين عقد السلسلة. */
export const DEPENDENCY_EDGE_KINDS = [
  'constrained-by',
  'examines',
  'evaluates',
  'requires',
  'produces',
] as const;

export type DependencyEdgeKind = (typeof DEPENDENCY_EDGE_KINDS)[number];

/**
 * اتجاه حافة مخطط التبعيات نسبةً إلى تدفق الإنفاذ
 * (Rule → Constraint → Evidence → Verification → Gate → Decision):
 * - forward: الحافة تعمل في اتجاه التدفق (مؤشر سلسلة أدنى → أعلى).
 * - backward: الحافة تعمل عكس التدفق (مؤشر سلسلة أعلى → أدنى)،
 *   أي حافة مسبقة/تبعية (dependent → prerequisite).
 */
export type EnforcementChainDirection = 'forward' | 'backward';

/**
 * عقد اتجاه الحواف الخمس (قرار المراجعة HIGH-1): الحواف لا تتشارك
 * اتجاهًا واحدًا؛ محرك الإنفاذ يجب أن يقرأ هذا العقد قبل أي traversal.
 */
export const DEPENDENCY_EDGE_DIRECTIONS: Readonly<Record<DependencyEdgeKind, EnforcementChainDirection>> = {
  'constrained-by': 'forward', // Rule → Constraint (0 → 1)
  'examines': 'forward', // Constraint → Evidence (1 → 2)
  'evaluates': 'backward', // Verification → Evidence (3 → 2): عكس التدفق
  'requires': 'backward', // Gate → Verification (4 → 3): عكس التدفق
  'produces': 'forward', // Verification/Gate → Decision (3/4 → 5)
};

export const DEPENDENCY_GRAPH_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-DEPENDENCY-GRAPH',
  name: 'Constitutional Dependency Graph',
  purpose:
    'Defines the structural dependency graph of the enforcement chain: a constraint depends on a rule, evidence is examined by constraints, verification evaluates evidence against constraints, gates require verifications, and verifications/gates produce decisions. Execution order is governed by this graph, never by numeric order (P4/I6). The five edge kinds carry an explicit direction contract (DEPENDENCY_EDGE_DIRECTIONS): `evaluates` and `requires` run against the enforcement flow (backward, i.e. dependent → prerequisite); `constrained-by`, `examines`, and `produces` run with it (forward).',
  authority: [
    { document: 'ADR-002', section: 'P4 / I6' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2; Section 3; Section 4' },
    { document: 'constitutional-object-model.md', section: 'Section 4' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['constrained-by', 'examines', 'evaluates', 'requires', 'produces'],
  objectKinds: ['Rule', 'Constraint', 'Evidence', 'Verification', 'Gate', 'Decision'],
  status:
    'Chain structure and edge-direction contract defined; per-rule link presence stays at the Phase 0/1 baseline (constraints 12/43, evidence 13/43, verification 11/43, gates 0/43, decisions 0/43). Full graph instantiation is future work.',
};
