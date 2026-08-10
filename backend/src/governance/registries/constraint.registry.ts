/*
 * سجل القيود (R2) — المسندات التشغيلية القابلة للدحض
 * لكل قاعدة. قاعدة بلا قيد مسجّل غير قابلة للدحض وبالتالي
 * غير قابلة للإنفاذ. خط الأساس: 12 من 43 عنصرًا لها قيد
 * حاضر (I1, I11, EC1..EC10) والباقي (31) غائب
 * (enforcement-gap-register.csv). لا يُعرَّف هنا نص أي
 * قيد جديد — هذه الكتالوج الهيكلي فقط؛ كتابة المسندات من
 * عمل D2 في مرحلة لاحقة.
 */
import { ConstitutionalElementId } from './types';
import { ConstitutionalRegistry } from './registry';

export interface ConstraintRecord {
  readonly element: ConstitutionalElementId;
  /** هل القيد حاضر في المصافوفة (constitution-enforcement-matrix.csv)؟ */
  readonly constraintPresent: true;
  /** أصل القيد الحاضر (وصف، لا مسند نهائي). */
  readonly predicateSource: string;
  readonly note?: string;
}

export const CONSTRAINTS_PRESENT: ReadonlyArray<ConstraintRecord> = [
  { element: 'I1', constraintPresent: true, predicateSource: 'Seed suite never treated as the dataset product', note: 'Matrix constraint link Present (P)' },
  { element: 'I11', constraintPresent: true, predicateSource: 'RLS is the sole access-control mechanism; never disabled never bypassed', note: 'Matrix constraint link Present-Partial: RLS policies present; never-bypassed mapped' },
  { element: 'EC1', constraintPresent: true, predicateSource: 'ADR-001 exists and approved; ADR template non-empty and binding' },
  { element: 'EC2', constraintPresent: true, predicateSource: 'Glossary document index and ADR index populated; final vocabulary recorded' },
  { element: 'EC3', constraintPresent: true, predicateSource: 'DOMAIN_MODEL defines Aggregate and Aggregate Root; Application and Condition roots named' },
  { element: 'EC4', constraintPresent: true, predicateSource: 'All 27 affected documents disposed; zero active Partially Consistent/Divergent/Superseded' },
  { element: 'EC5', constraintPresent: true, predicateSource: 'Zero forbidden terms in active documents' },
  { element: 'EC6', constraintPresent: true, predicateSource: 'Cutover checklist gates on dataset-construction evidence not seed-status' },
  { element: 'EC7', constraintPresent: true, predicateSource: 'SREA and dataset-architecture archived; no active document cites them as forward plan' },
  { element: 'EC8', constraintPresent: true, predicateSource: 'All 6 traceability chains re-verified with 0 broken' },
  { element: 'EC9', constraintPresent: true, predicateSource: 'Enterprise baseline assessment v2 approved with ADR-002-consistent verdict' },
  { element: 'EC10', constraintPresent: true, predicateSource: 'Informal ADR numbering collision resolved; mapping table present' },
];

/** عدد العناصر الغائب عنها قيد حالي (43 − 12). */
export const CONSTRAINT_GAP_COUNT = 31;

export const CONSTRAINT_GAP_NOTE =
  '31 of 43 constitutional elements lack a registered constraint (enforcement-gap-register.csv). Constraint predicates are defined by D2 in a later phase; this registry holds the structural status only.';

export const CONSTRAINT_REGISTRY = new ConstitutionalRegistry<ConstraintRecord>(
  'R2',
  'Constraint Registry',
  'D2',
  [
    { document: 'ADR-002' },
    { document: 'enforcement-gap-register.csv' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2' },
  ],
  CONSTRAINTS_PRESENT,
);
