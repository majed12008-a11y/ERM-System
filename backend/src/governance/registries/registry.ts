/*
 * القاعدة الأساسية للسجلات الدستورية (R1..R11).
 * توفر غلافًا للقراءة فقط يحدد هوية السجل ومالكه
 * (D1..D8) ومراجع السلطة والأثر الرجعي. لا يقدم أي
 * سلوك تنفيذي أو تحقق أو بوابة؛ مرحلة الأولى بناء
 * هيكلي فقط (PHASE_1_SCOPE).
 */

export type RegistryId =
  | 'R1' | 'R2' | 'R3' | 'R4' | 'R5' | 'R6'
  | 'R7' | 'R8' | 'R9' | 'R10' | 'R11';

export type EnforcementDomainId =
  | 'D1' | 'D2' | 'D3' | 'D4' | 'D5' | 'D6' | 'D7' | 'D8';

export const PHASE_1_SCOPE = 'structural-foundation' as const;

/**
 * علامة حظر السلوك التنفيذي: السجلات في المرحلة الأولى كتالوجات هيكلية
 * فقط؛ لا يجوز ربط أي سلوك إنفاذ أو تحقق أو تنفيذ من هذه الوحدات
 * قبل موافقة مراجعة معمارية لاحقة.
 */
export const RUNTIME_ENFORCEMENT_PROHIBITED =
  'Phase 1 registries are structural catalogs only: no enforcement, validation, verification, gate, or execution behavior may be wired from these modules until a later architectural review approves it.' as const;

export interface RegistryReference {
  readonly document: string;
  readonly section?: string;
}

export class ConstitutionalRegistry<TEntry> {
  readonly scope: 'structural-foundation' = PHASE_1_SCOPE;

  constructor(
    readonly id: RegistryId,
    readonly name: string,
    readonly ownedBy: EnforcementDomainId,
    readonly authority: ReadonlyArray<RegistryReference>,
    readonly entries: ReadonlyArray<TEntry>,
  ) {}

  /** الأثر الرجعي: مراجع السلطة المعتمدة لهذا السجل. */
  traceability(): ReadonlyArray<RegistryReference> {
    return this.authority;
  }
}
