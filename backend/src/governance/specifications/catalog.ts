/*
 * فهرس مواصفات الإنفاذ — الكتالوج الرسمي لأصناف المواصفات الستة
 * بترتيب سلسلة الإنفاذ (Constraint → Evidence → Verification →
 * Gate → Decision → Exception). كتالوج بنيوي سلبي فقط — لا يحتوي
 * أي منطق تنفيذي أو تحقق أو بوابة.
 */
import { SpecKindDefinition } from './types';
import { CONSTRAINT_SPEC_DEFINITION } from './constraint.specification';
import { EVIDENCE_SPEC_DEFINITION } from './evidence.specification';
import { VERIFICATION_SPEC_DEFINITION } from './verification.specification';
import { GATE_SPEC_DEFINITION } from './gate.specification';
import { DECISION_SPEC_DEFINITION } from './decision.specification';
import { EXCEPTION_SPEC_DEFINITION } from './exception.specification';

/** جميع تعريفات المواصفات الستة بترتيب سلسلة الإنفاذ. */
export const ENFORCEMENT_SPEC_KINDS: ReadonlyArray<SpecKindDefinition> = [
  CONSTRAINT_SPEC_DEFINITION,
  EVIDENCE_SPEC_DEFINITION,
  VERIFICATION_SPEC_DEFINITION,
  GATE_SPEC_DEFINITION,
  DECISION_SPEC_DEFINITION,
  EXCEPTION_SPEC_DEFINITION,
];
