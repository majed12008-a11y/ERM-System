/*
 * مفردات أصناف العلاقات الدستورية — الكتالوج الرسمي للروابط
 * المميزة (immutable object relationships) مع مدى صحتها من/إلى.
 * المصدر: constitutional-object-model.md §2.1–§2.3 (rule
 * relationships, chain relationships, cross-cutting relationships)
 * + رابط extends (طبقة المواصفات، المرحلة الثانية).
 * كتالوج بنيوي سلبي فقط — لا يحوي أي سلوك.
 */
import { CONSTITUTIONAL_OBJECT_KINDS, ConstitutionalObjectKind, RelationshipKind, RelationshipKindDefinition } from './types';

function kind(
  kind: RelationshipKind,
  name: string,
  meaning: string,
  source: string,
  validFrom: ReadonlyArray<ConstitutionalObjectKind>,
  validTo: ReadonlyArray<ConstitutionalObjectKind>,
): RelationshipKindDefinition {
  return { kind, name, meaning, source, validFrom, validTo };
}

/** كل أصناف الكائنات القابلة للتغيير عبر ADR (proposes/amends/…). */
const CHANGEABLE: ReadonlyArray<ConstitutionalObjectKind> = [
  'Rule', 'Constraint', 'Evidence', 'Verification', 'Gate', 'Decision', 'Exception', 'Baseline',
];

/** كل أصناف الكائنات الدستورية. */
const ALL: ReadonlyArray<ConstitutionalObjectKind> = [...CONSTITUTIONAL_OBJECT_KINDS];

export const RELATIONSHIP_KINDS: ReadonlyArray<RelationshipKindDefinition> = [
  /* --- rule relationships (§2.1) --- */
  kind('realizes', 'Realizes', 'A principle is realized by one or more invariants (e.g., P3 realizes I5).', 'object-model §2.1', ['Principle'], ['Invariant']),
  kind('derives-from', 'Derives from', 'An invariant is a checkable derivative of a principle.', 'object-model §2.1', ['Invariant'], ['Principle']),
  kind('constrained-by', 'Constrained by', 'Every rule has at least one operational predicate (constraint).', 'object-model §2.1', ['Rule'], ['Constraint']),
  kind('constrains', 'Constrains', 'The predicate that makes the rule falsifiable (inverse of constrained-by; completes the §2.2 chain pair).', 'object-model §2.2', ['Constraint'], ['Rule']),
  kind('owns', 'Owns', 'Exactly one owning body per object/artifact (P2, I4, G5).', 'object-model §2.1/§2.3', ['Rule', 'Evidence', 'Aggregate', 'Term', 'Registry', 'Specification'], ['Ownership']),
  kind('is-owned-by', 'Is owned by', 'Inverse of owns: the single owning body of an object.', 'object-model §2.3', ['Ownership'], ALL),
  kind('belongs-to', 'Belongs to', 'Active constitutional objects compose Baseline v2 (object-model §1 defines Baseline as the set of active constitutional objects, which includes exceptions and ADRs).', 'object-model §2.1 / §1', ['Rule', 'Constraint', 'Evidence', 'Verification', 'Gate', 'Exception', 'ADR'], ['Baseline']),
  kind('supersedes', 'Supersedes', 'Via ADR; the old object is deprecated, the new one traces back (T3).', 'object-model §2.1', CHANGEABLE, CHANGEABLE),
  kind('is-superseded-by', 'Is superseded by', 'Inverse of supersedes.', 'object-model §2.1', CHANGEABLE, CHANGEABLE),

  /* --- chain relationships (§2.2) --- */
  kind('examines', 'Examines', 'The predicate operates on the evidence artifact(s).', 'object-model §2.2', ['Constraint'], ['Evidence']),
  kind('is-examined-by', 'Is examined by', 'Evidence is inert without a constraint.', 'object-model §2.2', ['Evidence'], ['Constraint']),
  kind('evaluates', 'Evaluates', 'Verification evaluates evidence against the constraint.', 'object-model §2.2', ['Verification'], ['Evidence']),
  kind('is-evaluated-by', 'Is evaluated by', 'Inverse of evaluates.', 'object-model §2.2', ['Evidence'], ['Verification']),
  kind('requires', 'Requires', 'A gate binds one or more verifications.', 'object-model §2.2', ['Gate'], ['Verification']),
  kind('is-required-by', 'Is required by', 'Inverse of requires; a verification with no gate is a declaration.', 'object-model §2.2', ['Verification'], ['Gate']),
  kind('produces', 'Produces', 'A binary, recorded outcome (verification result or gate ruling).', 'object-model §2.2', ['Verification', 'Gate'], ['Decision']),
  kind('records', 'Records', 'A decision records the verification/gate outcome it documents.', 'enforcement architecture §2 (Decision Registry); §3 (Decision: Records → Verification/Gate)', ['Decision'], ['Verification', 'Gate']),
  kind('grants', 'Grants', 'A decision may grant an exception with scope and expiry; never silent.', 'object-model §2.2', ['Decision'], ['Exception']),
  kind('suspends', 'Suspends', 'Moves the rule to Suspended for the exception duration.', 'object-model §2.2', ['Exception'], ['Rule']),
  kind('cites', 'Cites', 'An ADR must be traceable to its evidence basis (T3).', 'object-model §2.2', ['ADR'], ['Evidence', 'Traceability']),
  kind('proposes', 'Proposes', 'The ADR instrument proposes a new object.', 'object-model §2.2', ['ADR'], CHANGEABLE),
  kind('amends', 'Amends', 'The ADR instrument amends an existing object.', 'object-model §2.2', ['ADR'], CHANGEABLE),
  kind('replaces', 'Replaces', 'The ADR instrument replaces an object.', 'object-model §2.2', ['ADR'], CHANGEABLE),
  kind('retires', 'Retires', 'The ADR instrument retires an object.', 'object-model §2.2', ['ADR'], CHANGEABLE),

  /* --- cross-cutting relationships (§2.3) --- */
  kind('attaches-to', 'Attaches to', 'Lifecycle and Ownership attach to every object/artifact.', 'object-model §2.3', ['Lifecycle', 'Ownership'], ALL),
  kind('traverses', 'Traverses', 'Traceability traverses the chain relationships backward (T3; EC8).', 'object-model §2.3', ['Traceability'], ['Rule', 'Constraint', 'Evidence', 'Verification', 'Gate', 'Decision']),
  kind('extends', 'Extends', 'A specification kind extends the registry whose records it governs (Phase 2 linking).', 'specification layer (Phase 2) DEC-2.3', ['Specification'], ['Registry']),
];

/** معرّفات أصناف العلاقات للتحقق الهيكلي. */
export const RELATIONSHIP_KIND_IDS: ReadonlyArray<RelationshipKind> = [
  ...RELATIONSHIP_KINDS.map((k) => k.kind),
];
