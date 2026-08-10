/*
 * أنواع نموذج العلاقات الدستورية — الطبقة المشتركة للمرحلة الثالثة.
 * تُعرّف هوية الكائن الدستوري (ConstitutionalObjectId)، الروابط
 * المميزة (ConstitutionalLink)، أصناف العلاقات (RelationshipKind)،
 * وبنية النموذج الوصفي (MetadataModel) الذي يجسد النماذج العشرة
 * المطلوبة كبيانات وصفية. أنواع TypeScript صارمة وثوابت قراءة
 * فقط فقط — دون أي منطق تنفيذي أو تحقق أو تقييم. المصدر: ADR-001،
 * ADR-002، constitutional-object-model.md،
 * constitutional-enforcement-architecture.md.
 */
import type { RegistryReference } from '../registries/registry';

/** نطاق المرحلة الثالثة: نموذج العلاقات الدستوري (بيانات وصفية فقط). */
export const PHASE_3_SCOPE = 'constitutional-relationship-model' as const;

export type Phase3Scope = typeof PHASE_3_SCOPE;

/** أصناف الكائنات الدستورية — المصدر: constitutional-object-model.md §1. */
export type ConstitutionalObjectKind =
  | 'Rule'
  | 'Principle'
  | 'Invariant'
  | 'ADR'
  | 'Constraint'
  | 'Evidence'
  | 'Verification'
  | 'Gate'
  | 'Decision'
  | 'Exception'
  | 'Lifecycle'
  | 'Ownership'
  | 'Traceability'
  | 'Baseline'
  | 'Registry'
  | 'Specification'
  | 'State'
  | 'Aggregate'
  | 'Term';

export const CONSTITUTIONAL_OBJECT_KINDS: ReadonlyArray<ConstitutionalObjectKind> = [
  'Rule', 'Principle', 'Invariant', 'ADR', 'Constraint', 'Evidence', 'Verification', 'Gate',
  'Decision', 'Exception', 'Lifecycle', 'Ownership', 'Traceability',
  'Baseline', 'Registry', 'Specification', 'State', 'Aggregate', 'Term',
];

/** مرجع كائن دستوري معرّف بقوة (strongly typed constitutional reference). */
export interface ConstitutionalObjectId {
  readonly kind: ConstitutionalObjectKind;
  readonly id: string;
}

/**
 * أصناف العلاقات الدستورية — مفردات الروابط المميزة
 * (constitutional-object-model.md §2.1–§2.3) + رابط الطبقة
 * (extends) من طبقة المواصفات.
 */
export type RelationshipKind =
  | 'constrained-by'
  | 'constrains'
  | 'examines'
  | 'is-examined-by'
  | 'evaluates'
  | 'is-evaluated-by'
  | 'requires'
  | 'is-required-by'
  | 'produces'
  | 'records'
  | 'grants'
  | 'suspends'
  | 'owns'
  | 'is-owned-by'
  | 'supersedes'
  | 'is-superseded-by'
  | 'derives-from'
  | 'realizes'
  | 'cites'
  | 'proposes'
  | 'amends'
  | 'replaces'
  | 'retires'
  | 'belongs-to'
  | 'attaches-to'
  | 'traverses'
  | 'extends';

/** رابط دستوري واحد: علاقة مميزة بين كائنَين بسلطة. */
export interface ConstitutionalLink {
  readonly id: string;
  readonly kind: RelationshipKind;
  readonly from: ConstitutionalObjectId;
  readonly to: ConstitutionalObjectId;
  readonly authority: string;
  readonly note?: string;
}

/** تعريف صنف علاقة: المفردة ومدى صحتها (from/to). */
export interface RelationshipKindDefinition {
  readonly kind: RelationshipKind;
  readonly name: string;
  readonly meaning: string;
  readonly source: string;
  readonly validFrom: ReadonlyArray<ConstitutionalObjectKind>;
  readonly validTo: ReadonlyArray<ConstitutionalObjectKind>;
}

/**
 * نموذج وصفي (MetadataModel): بنية أحد النماذج العشرة —
 * الغرض، السلطة، أصناف العلاقات المكوِّنة، أصناف الكائنات
 * المشاركة، وحالة خط الأساس. لا يحوي أي سلوك.
 */
export interface MetadataModel {
  readonly scope: Phase3Scope;
  readonly id: string;
  readonly name: string;
  readonly purpose: string;
  readonly authority: ReadonlyArray<RegistryReference>;
  readonly composedOf: ReadonlyArray<RelationshipKind>;
  readonly objectKinds: ReadonlyArray<ConstitutionalObjectKind>;
  readonly status: string;
}

/**
 * علامة حظر السلوك التنفيذي للمرحلة الثالثة: نموذج العلاقات بيانات
 * وصفية سلبية فقط؛ لا يجوز ربط أي سلوك إنفاذ أو تقييم أو تنفيذ من
 * هذه الوحدات قبل موافقة مراجعة معمارية لاحقة.
 */
export const RELATIONSHIPS_RUNTIME_PROHIBITED =
  'Phase 3 constitutional relationship model is passive metadata: it defines identity, relationship kinds, and the dependency/traceability/provenance structures the future enforcement engine will consume. No evaluation, resolution, or enforcement behavior may be wired from these modules until a later architectural review approves it.' as const;
