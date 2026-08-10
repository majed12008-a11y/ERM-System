/*
 * سجل التحقق (R4) — الإجراءات الموضوعية لكل قيد ومدخلاتها
 * ومخرجاتها وآخر تشغيل ونتيجتها. التحقق يُسجَّل قبل أن
 * يُشغَّل؛ تحقق غير مسجّل لا وجود له. مجموعة EC1..EC10
 * هي مجموعة التحقق الأولية (constitutional-enforcement-architecture.md
 * §6.1 و §8). مرحلة الأولى تسجيل هيكلي فقط — لم يُنفَّذ أي
 * إجراء تحقق ولم يُسجَّل أي تشغيل.
 */
import { ExitCriterionId } from './types';
import { ConstitutionalRegistry } from './registry';

export type VerificationReadiness = 'Ready' | 'NeedsExtension';
export type VerificationRunStatus = 'NotRegistered';

export interface VerificationRecord {
  readonly id: ExitCriterionId;
  readonly readiness: VerificationReadiness;
  readonly verificationBasis: string;
  readonly status: VerificationRunStatus;
}

export const VERIFICATION_RECORDS: ReadonlyArray<VerificationRecord> = [
  { id: 'EC1', readiness: 'Ready', verificationBasis: 'File existence + approval record.', status: 'NotRegistered' },
  { id: 'EC2', readiness: 'Ready', verificationBasis: 'Non-empty + final-vocabulary term-set comparison.', status: 'NotRegistered' },
  { id: 'EC3', readiness: 'Ready', verificationBasis: 'Grep of DOMAIN_MODEL for Aggregate, Aggregate Root, Application/Condition roots.', status: 'NotRegistered' },
  { id: 'EC4', readiness: 'NeedsExtension', verificationBasis: 'Repeatable consistency-matrix re-audit.', status: 'NotRegistered' },
  { id: 'EC5', readiness: 'Ready', verificationBasis: 'Forbidden-terms grep.', status: 'NotRegistered' },
  { id: 'EC6', readiness: 'Ready', verificationBasis: 'Cutover-checklist grep for seed-status gating.', status: 'NotRegistered' },
  { id: 'EC7', readiness: 'Ready', verificationBasis: 'Citation grep for SREA / dataset-architecture.', status: 'NotRegistered' },
  { id: 'EC8', readiness: 'NeedsExtension', verificationBasis: 'Decision/evidence provenance records to audit chains against.', status: 'NotRegistered' },
  { id: 'EC9', readiness: 'NeedsExtension', verificationBasis: 'Verdict-consistency contradiction check; semantic residue remains human.', status: 'NotRegistered' },
  { id: 'EC10', readiness: 'Ready', verificationBasis: 'ADR-index mapping-table presence.', status: 'NotRegistered' },
];

/** عناصر جاهزة لكنها ليست ضمن مجموعة EC1..EC10 الأولية (إشارة فقط، لا تسجيل تحقق). */
export const READY_OUTSIDE_INITIAL_SET: ReadonlyArray<{ readonly element: string; readonly basis: string }> = [
  { element: 'I11', basis: 'Bypass detection: SECURITY DEFINER functions and disabled RLS observable in the accepted baseline.' },
  { element: 'G11', basis: 'Forbidden-terminology check defined (transition plan §6.4; EC5).' },
];

export const VERIFICATION_REGISTRY = new ConstitutionalRegistry<VerificationRecord>(
  'R4',
  'Verification Registry',
  'D4',
  [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 6.1 / Section 8' },
    { document: 'constitutional-enforcement-domains.csv', section: 'D4' },
  ],
  VERIFICATION_RECORDS,
);
