/*
 * أنواع السجل الدستوري — الطبقة المشتركة للمرحلة الأولى.
 * تعرّف معرّفات العناصر الدستورية (P/I/G/EC) وأنواع الروابط
 * والتصنيفات وحالات آلة الحالة (R8) وبنية التسجيل (R10)
 * كأنواع TypeScript صارمة وثوابت قراءة فقط فقط — دون أي
 * منطق سلوكي أو تنفيذي أو تحقق. المصدر: ADR-002
 * و constitution-enforcement-matrix.csv و DOMAIN_MODEL.md
 * و constitutional-state-machine.md.
 */

export const PRINCIPLE_IDS = ['P1', 'P2', 'P3', 'P4', 'P5', 'P6', 'P7', 'P8', 'P9'] as const;
export const INVARIANT_IDS = ['I1', 'I2', 'I3', 'I4', 'I5', 'I6', 'I7', 'I8', 'I9', 'I10', 'I11'] as const;
export const GOVERNANCE_IDS = ['G1', 'G2', 'G3', 'G4', 'G5', 'G6', 'G7', 'G8', 'G9', 'G10', 'G11', 'G12', 'G13'] as const;
export const EXIT_CRITERION_IDS = ['EC1', 'EC2', 'EC3', 'EC4', 'EC5', 'EC6', 'EC7', 'EC8', 'EC9', 'EC10'] as const;

/** كل معرّفات العناصر الدستورية الأربعة والأربعين (43) بترتيب P/I/G/EC. */
export const CONSTITUTIONAL_ELEMENT_IDS = [
  ...PRINCIPLE_IDS,
  ...INVARIANT_IDS,
  ...GOVERNANCE_IDS,
  ...EXIT_CRITERION_IDS,
] as const;

export type PrincipleId = (typeof PRINCIPLE_IDS)[number];
export type InvariantId = (typeof INVARIANT_IDS)[number];
export type GovernanceId = (typeof GOVERNANCE_IDS)[number];
export type ExitCriterionId = (typeof EXIT_CRITERION_IDS)[number];
export type ConstitutionalElementId = (typeof CONSTITUTIONAL_ELEMENT_IDS)[number];

export type ConstitutionalElementType = 'Principle' | 'Invariant' | 'Governance' | 'Exit criterion';

/** حالة رابط في مصفوفة الإنفاذ: M مخطّط، P موجود، P جزئي (مثل I11). */
export type RegistryLinkStatus = 'Mapped' | 'Present' | 'Present-Partial';

export interface RegistryLink {
  readonly status: RegistryLinkStatus;
  readonly note?: string;
}

export type CurrentClassification =
  | 'Currently unenforceable'
  | 'Documentation only'
  | 'Human-reviewed'
  | 'Automatically verifiable (with documented bypass)';

export type IntendedVerification = 'Continuously enforced' | 'Automatically verifiable';

/** عنصر دستوري مسجّل في R1 (المصدر: constitution-enforcement-matrix.csv). */
export interface ConstitutionalElement {
  readonly id: ConstitutionalElementId;
  readonly type: ConstitutionalElementType;
  readonly rule: string;
  readonly constraintLink: RegistryLink;
  readonly evidenceLink: RegistryLink;
  readonly verificationLink: RegistryLink;
  readonly gateLink: RegistryLink;
  readonly decisionLink: RegistryLink;
  readonly currentClassification: CurrentClassification;
  readonly intendedVerification: IntendedVerification;
}

/* --- حالة آلة الحالة (R8) --- */

export const CONSTITUTIONAL_STATE_IDS = [
  'Draft',
  'Proposed',
  'Approved',
  'Active',
  'Verified',
  'Violated',
  'Suspended',
  'Deprecated',
  'Archived',
] as const;

export type ConstitutionalStateId = (typeof CONSTITUTIONAL_STATE_IDS)[number];

export interface ConstitutionalStateDefinition {
  readonly id: ConstitutionalStateId;
  readonly meaning: string;
  readonly bindingEffect: string;
}

export interface StateTransition {
  readonly from: ConstitutionalStateId;
  readonly to: ConstitutionalStateId | null;
  readonly condition: string;
  readonly authority: string;
}

/* --- التسجيل (R10) --- */

export const AGGREGATE_IDS = [
  'A01', 'A02', 'A03', 'A04', 'A05', 'A06', 'A07', 'A08', 'A09', 'A10',
  'A11', 'A12', 'A13', 'A14', 'A15', 'A16', 'A17', 'A18', 'A19', 'A20',
  'A21', 'A22', 'A23', 'A24', 'A25',
] as const;

export type AggregateId = (typeof AGGREGATE_IDS)[number];
export type AggregateTier = 'Core' | 'Supporting' | 'Infrastructure';

export type TableClassification =
  | 'Core'
  | 'Supporting'
  | 'Infrastructure'
  | 'Reference-data'
  | 'Runtime-generated'
  | 'Historical'
  | 'Dead-data'
  | 'View';

/** تعريف تجمّع (المصدر: DOMAIN_MODEL.md Section 1). */
export interface AggregateDefinition {
  readonly id: AggregateId;
  readonly name: string;
  readonly tier: AggregateTier;
  readonly purpose: string;
  readonly businessOwner: string;
  readonly rootEntity: string;
  readonly responsibility: string;
  readonly boundary: string;
}

/** تعيين جدول لتجمّع واحد بالضبط (المصدر: aggregate-table-mapping.csv). */
export interface AggregateTable {
  readonly aggregate: AggregateId;
  readonly schema: string;
  readonly table: string;
  readonly ownership: string;
  readonly classification: TableClassification;
}
