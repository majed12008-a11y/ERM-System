/*
 * أنواع مواصفات الإنفاذ الدستوري — الطبقة المشتركة للمرحلة الثانية.
 * تُعرّف أصناف المواصفات الستة (Constraint, Evidence, Verification,
 * Gate, Decision, Exception) وبنية كل تعريف مواصفة (هوية، مالك،
 * مرجع سجل، شكل حقول، سلطة) كأنواع TypeScript صارمة وثوابت قراءة
 * فقط فقط — دون أي منطق سلوكي أو تنفيذي أو تحقق. المصدر:
 * ADR-001 و ADR-002 و constitutional-enforcement-architecture.md
 * و constitutional-object-model.md و constitutional-state-machine.md.
 * الطبقة بنية سلبية فقط؛ الربط بأي سلوك وقت التشغيل ممنوع في
 * المرحلة الثانية (SPECIFICATIONS_RUNTIME_PROHIBITED).
 */
import type { RegistryId, EnforcementDomainId, RegistryReference } from '../registries/registry';

/** نطاق المرحلة الثانية: بيانات وصفية دستورية سلبية فقط. */
export const PHASE_2_SCOPE = 'constitutional-enforcement-metadata' as const;

export type Phase2Scope = typeof PHASE_2_SCOPE;

/** أصناف مواصفات الإنفاذ الستة — المصدر: طلب المرحلة الثانية. */
export type EnforcementSpecKind =
  | 'Constraint'
  | 'Evidence'
  | 'Verification'
  | 'Gate'
  | 'Decision'
  | 'Exception';

export type EnforcementSpecKindId =
  | 'SPEC-CONSTRAINT'
  | 'SPEC-EVIDENCE'
  | 'SPEC-VERIFICATION'
  | 'SPEC-GATE'
  | 'SPEC-DECISION'
  | 'SPEC-EXCEPTION';

/** معرّفات أصناف المواصفات الستة بترتيب سلسلة الإنفاذ. */
export const ENFORCEMENT_SPEC_KIND_IDS = [
  'SPEC-CONSTRAINT',
  'SPEC-EVIDENCE',
  'SPEC-VERIFICATION',
  'SPEC-GATE',
  'SPEC-DECISION',
  'SPEC-EXCEPTION',
] as const;

/** حقل هيكلي واحد في شكل المواصفة (تعريف بنيوي، لا قيمة). */
export interface SpecField {
  readonly name: string;
  readonly meaning: string;
  readonly required: boolean;
  readonly source: string;
}

/**
 * تعريف صنف مواصفة: البنية الهيكلية التي يلتزم بها محرك الإنفاذ
 * المستقبلي عند التعامل مع هذا الصنف. لا يحوي أي محتوى تنفيذي —
 * مراجع سجلات وسلطات وشكل حقول فقط.
 */
export interface SpecKindDefinition {
  readonly scope: Phase2Scope;
  readonly id: EnforcementSpecKindId;
  readonly kind: EnforcementSpecKind;
  readonly name: string;
  /** السجل (R2..R6, R9) الذي يمتدّ تعريف المواصفة هذا بنيويًا. */
  readonly extends: RegistryId;
  readonly owner: EnforcementDomainId;
  readonly purpose: string;
  /** شكل المواصفة: الحقول البنيوية التي تتكوّن منها. */
  readonly shape: ReadonlyArray<SpecField>;
  /** علاقات الكائن في constitutional-object-model.md §2.2. */
  readonly objectModelRelations: string;
  /** انطباق آلة الحالة (constitutional-state-machine.md §5). */
  readonly stateMachineApplicability: string;
  readonly authority: ReadonlyArray<RegistryReference>;
  /** ما يستحضره التعريف بنيويًا من محتوى السجلات الحالي. */
  readonly instantiates: string;
}

/**
 * علامة حظر السلوك التنفيذي للمرحلة الثانية: مواصفات الإنفاذ بيانات
 * وصفية سلبية فقط؛ لا يجوز ربط أي سلوك قيد أو تحقق أو بوابة أو قرار
 * أو استثناء من هذه الوحدات قبل موافقة مراجعة معمارية لاحقة.
 */
export const SPECIFICATIONS_RUNTIME_PROHIBITED =
  'Phase 2 enforcement specifications are passive constitutional metadata: they define the structural contract between the registries and the future enforcement engine. No constraint, verification, gate, decision, or exception behavior may be wired from these modules until a later architectural review approves it.' as const;
