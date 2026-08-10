/*
 * واجهة السجلات الدستورية (R1..R11) — بوابة كتالوجات
 * هيكلية فقط. لا تحتوي على أي توجيه أو خدمة أو سلوك
 * تنفيذي؛ إعادة تصدير الأنواع والسجلات الإحدى عشر.
 * الربط بأي سلوك وقت التشغيل ممنوع في المرحلة الأولى
 * (RUNTIME_ENFORCEMENT_PROHIBITED).
 */
export * from './types';
export * from './registry';
export * from './rule.registry';
export * from './constraint.registry';
export * from './evidence.registry';
export * from './verification.registry';
export * from './gate.registry';
export * from './decision.registry';
export * from './execution.registry';
export * from './architecture-state.registry';
export * from './exception.registry';
export * from './ownership.registry';
export * from './vocabulary.registry';

import { ConstitutionalRegistry } from './registry';
import { RULE_REGISTRY } from './rule.registry';
import { CONSTRAINT_REGISTRY } from './constraint.registry';
import { EVIDENCE_REGISTRY } from './evidence.registry';
import { VERIFICATION_REGISTRY } from './verification.registry';
import { GATE_REGISTRY } from './gate.registry';
import { DECISION_REGISTRY } from './decision.registry';
import { EXECUTION_REGISTRY } from './execution.registry';
import { STATE_REGISTRY } from './architecture-state.registry';
import { EXCEPTION_REGISTRY } from './exception.registry';
import { OWNERSHIP_REGISTRY } from './ownership.registry';
import { VOCABULARY_REGISTRY } from './vocabulary.registry';

/** جميع السجلات الإحدى عشر بالترتيب R1..R11. */
export const REGISTRIES: ReadonlyArray<ConstitutionalRegistry<unknown>> = [
  RULE_REGISTRY,
  CONSTRAINT_REGISTRY,
  EVIDENCE_REGISTRY,
  VERIFICATION_REGISTRY,
  GATE_REGISTRY,
  DECISION_REGISTRY,
  EXECUTION_REGISTRY,
  STATE_REGISTRY,
  EXCEPTION_REGISTRY,
  OWNERSHIP_REGISTRY,
  VOCABULARY_REGISTRY,
];
