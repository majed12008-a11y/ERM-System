/*
 * نموذج الهوية الدستورية (MODEL-IDENTITY) — القواعد التي تُعرّف
 * بها الكائنات الدستورية: صنف الكائن، نمط معرّفه، والمرساة
 * (السجل أو الطبقة) التي تضبطه. هوية غير مسجّلة غير قابلة
 * للإسناد (nothing is constitutional unless registered). نموذج
 * وصفي سلبي فقط — لا يحتوي أي سلوك.
 *
 * نطاق الهوية (قرار المراجعة MED-2 / الشرط C3): القواعد تغطي
 * الأصناف المرساة في سجلات R1..R11 أو في الطبقات (المواصفات،
 * سلسلة ADR). أصناف ملكية/دورة حياة/تتبع/خط الأساس والصنفان
 * الفرعيان للقاعدة (Principle/Invariant) لا تملك قواعد هوية في
 * هذه المرحلة — تُسند هويتها في مرحلة لاحقة (D7/محرك الإنفاذ)
 * عبر OWN/attaches-to/traverses/belongs-to. يُسجَّل ADR الآن
 * على الأقل لأنه أداة التعديل التي تحتاجها مرحلة المحرك.
 */
import { ConstitutionalObjectKind } from './types';
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

export interface ConstitutionalIdRule {
  readonly objectKind: ConstitutionalObjectKind;
  readonly idPattern: string;
  readonly anchor: string;
  readonly rule: string;
}

/** قواعد الهوية لكل صنف كائن دستوري (المرجع: السجلات R1..R11). */
export const CONSTITUTIONAL_ID_RULES: ReadonlyArray<ConstitutionalIdRule> = [
  { objectKind: 'Rule', idPattern: 'P1..P9, I1..I11, G1..G13, EC1..EC10', anchor: 'R1', rule: 'A constitutional rule is identified by its element id; nothing is constitutional unless registered in R1.' },
  { objectKind: 'ADR', idPattern: 'ADR-<NNN> (registered in ADR-INDEX)', anchor: 'ADR series (ADR-001 §2)', rule: 'An ADR is identified by its number and is part of the series only if registered in ADR-INDEX; only registered ADRs are change instruments (ADR-001 §2.2/§2.3).' },
  { objectKind: 'Constraint', idPattern: 'element id of the constrained rule', anchor: 'R2', rule: 'A constraint record is identified by the element it constrains; presence/gap is recorded in R2.' },
  { objectKind: 'Evidence', idPattern: 'artifact name from R3 EVIDENCE_ARTIFACTS', anchor: 'R3', rule: 'An evidence source is identified by its artifact; unregistered evidence is inadmissible.' },
  { objectKind: 'Verification', idPattern: 'EC1..EC10 (+ I11, G11 ready outside the set)', anchor: 'R4', rule: 'A verification procedure is identified by its record id in R4; unregistered verification does not exist.' },
  { objectKind: 'Gate', idPattern: 'GATE-01..GATE-05', anchor: 'R5', rule: 'A gate is identified by its gate id in R5.' },
  { objectKind: 'Decision', idPattern: 'record id in R6', anchor: 'R6', rule: 'A decision is identified by its record; baseline is 0 recorded decisions.' },
  { objectKind: 'Exception', idPattern: 'record id in R9', anchor: 'R9', rule: 'An exception is identified by its record; the known precedent (I11) is unrecorded and deferred.' },
  { objectKind: 'State', idPattern: 'Draft, Proposed, Approved, Active, Verified, Violated, Suspended, Deprecated, Archived', anchor: 'R8', rule: 'A state is identified per the constitutional state machine.' },
  { objectKind: 'Aggregate', idPattern: 'A01..A25', anchor: 'R10', rule: 'An aggregate is identified by its aggregate id; every table maps to exactly one aggregate.' },
  { objectKind: 'Term', idPattern: 'final-vocabulary term', anchor: 'R11', rule: 'A term is identified by its term string; unregistered terms may not enter active documents (G4/G11).' },
  { objectKind: 'Specification', idPattern: 'SPEC-CONSTRAINT, SPEC-EVIDENCE, SPEC-VERIFICATION, SPEC-GATE, SPEC-DECISION, SPEC-EXCEPTION', anchor: 'specifications layer (Phase 2)', rule: 'A specification kind is identified by its spec id in the specification layer.' },
  { objectKind: 'Registry', idPattern: 'R1..R11', anchor: 'registries layer (Phase 1)', rule: 'A registry is identified by its registry id in the registries layer.' },
];

export const OBJECT_IDENTITY_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-IDENTITY',
  name: 'Constitutional Identity Model',
  purpose:
    'Defines the strongly typed identity of every constitutional object: object kind, id pattern, and the anchoring registry or layer that governs the id. A constitutional reference is valid only when it resolves to a registered identity. Scoping: id rules cover registry-anchored kinds (R1..R11) plus the ADR series and specification layer; Principle/Invariant/Lifecycle/Ownership/Traceability/Baseline identity is assigned in later phases (D7/engine) per the MODEL-IDENTITY header.',
  authority: [
    { document: 'ADR-002', section: 'Canonical Dataset Architecture' },
    { document: 'constitutional-object-model.md', section: 'Section 1; Section 3' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2; Section 3' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['owns', 'belongs-to', 'extends'],
  objectKinds: ['Rule', 'Constraint', 'Evidence', 'Verification', 'Gate', 'Decision', 'Exception', 'State', 'Aggregate', 'Term', 'Specification', 'Registry', 'Ownership', 'Baseline', 'ADR'],
  status:
    'Identity rules anchored to the Phase 1 registries (R1..R11), the ADR series, and the Phase 2 specification layer; no identity state is assigned (D7 assigns state in a later phase).',
};
