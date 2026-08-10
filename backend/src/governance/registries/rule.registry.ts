/*
 * سجل القواعد (R1) — التعداد الرسمي للعناصر الدستورية
 * الأربعة والأربعين (P1..P9, I1..I11, G1..G13, EC1..EC10)
 * مع نوع كل عنصر ونصّه وحالة روابط الإنفاذ الخمسة
 * والتصنيف الحالي والتحقق المقصود. المصدر:
 * constitution-enforcement-matrix.csv (43 سطرًا) و ADR-002.
 * المالك: D1 Constitutional Definition.
 * لا شيء يعتبر دستوريًا ما لم يُسجَّل هنا.
 */
import { ConstitutionalElement, ConstitutionalElementType, ConstitutionalElementId, RegistryLink } from './types';
import { ConstitutionalRegistry } from './registry';

const M: RegistryLink = { status: 'Mapped' };
const P: RegistryLink = { status: 'Present' };

interface ElementSeed {
  readonly id: ConstitutionalElementId;
  readonly type: ConstitutionalElementType;
  readonly rule: string;
  readonly constraintLink: RegistryLink;
  readonly evidenceLink: RegistryLink;
  readonly verificationLink: RegistryLink;
  readonly gateLink?: RegistryLink;
  readonly decisionLink?: RegistryLink;
  readonly currentClassification: ConstitutionalElement['currentClassification'];
  readonly intendedVerification: ConstitutionalElement['intendedVerification'];
}

function element(seed: ElementSeed): ConstitutionalElement {
  return {
    id: seed.id,
    type: seed.type,
    rule: seed.rule,
    constraintLink: seed.constraintLink,
    evidenceLink: seed.evidenceLink,
    verificationLink: seed.verificationLink,
    gateLink: seed.gateLink ?? M,
    decisionLink: seed.decisionLink ?? M,
    currentClassification: seed.currentClassification,
    intendedVerification: seed.intendedVerification,
  };
}

export const CONSTITUTIONAL_RULES: ReadonlyArray<ConstitutionalElement> = [
  /* --- المبادئ P1..P9 --- */
  element({ id: 'P1', type: 'Principle', rule: 'Dataset-first: Canonical Dataset is the source of truth; seed suite is a historical record', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'P2', type: 'Principle', rule: 'Domain ownership: every datum maps to exactly one owning subsystem or a declared shared kernel', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'P3', type: 'Principle', rule: 'Aggregate ownership: aggregate-level invariants (RULE 11/12) in a single authoritative model', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'P4', type: 'Principle', rule: 'Semantic dependencies: execution order respects business dependency graph, never numeric order', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'P5', type: 'Principle', rule: 'Dataset lifecycle: promote version deprecate branch merge archive', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'P6', type: 'Principle', rule: 'Business identity over execution order: idempotency by natural keys and aggregate roots', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'P7', type: 'Principle', rule: 'Provenance trust: no decision relies on execution state not provable as a product of execution', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'P8', type: 'Principle', rule: 'Behavior verification over integrity verification', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'P9', type: 'Principle', rule: 'No dead data: canonical data may not reference zero-consumer behavior; consumerless data retired', constraintLink: M, evidenceLink: P, verificationLink: M, currentClassification: 'Human-reviewed', intendedVerification: 'Continuously enforced' }),

  /* --- الثوابت I1..I11 --- */
  element({ id: 'I1', type: 'Invariant', rule: 'Seed suite never treated as the dataset product', constraintLink: P, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I2', type: 'Invariant', rule: 'No decision based on recorded execution state unless provenance survives restore', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I3', type: 'Invariant', rule: 'Reproducibility by construction, not by restoration', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I4', type: 'Invariant', rule: 'Every datum belongs to exactly one owning subsystem or a declared shared kernel', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I5', type: 'Invariant', rule: 'Aggregate-level invariants expressible in a single authoritative model and assertable by verification', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I6', type: 'Invariant', rule: 'Execution order respects the business dependency graph; numeric/filename order never sufficient', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I7', type: 'Invariant', rule: 'All canonical data participates in a defined lifecycle', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I8', type: 'Invariant', rule: 'No consumerless data in canonical counts; consumerless data deprecated and retired', constraintLink: M, evidenceLink: P, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I9', type: 'Invariant', rule: 'Verification asserts business behavior in addition to integrity', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({ id: 'I10', type: 'Invariant', rule: 'Idempotency and reconciliation defined by business identity not execution position', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Currently unenforceable', intendedVerification: 'Continuously enforced' }),
  element({
    id: 'I11', type: 'Invariant',
    rule: 'Schema RLS and data are distinct concerns; RLS is the sole access-control mechanism; never disabled never bypassed',
    constraintLink: { status: 'Present-Partial', note: 'RLS policies present; never-bypassed mapped' },
    evidenceLink: { status: 'Present', note: '174+ policies + app.user_id context' },
    verificationLink: { status: 'Present-Partial', note: 'DB enforces RLS; bypass detection mapped' },
    currentClassification: 'Automatically verifiable (with documented bypass)', intendedVerification: 'Continuously enforced',
  }),

  /* --- قواعد الحوكمة G1..G13 --- */
  element({ id: 'G1', type: 'Governance', rule: 'No mixed worldview: every document belongs to exactly one baseline (T1)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'G2', type: 'Governance', rule: 'Single constitutional source: ADR-002 is the sole constitution (T2)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'G3', type: 'Governance', rule: 'Backward traceability: every decision traces to evidence (T3)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'G4', type: 'Governance', rule: 'Controlled terminology evolution (T4)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'G5', type: 'Governance', rule: 'Single ownership of governance artifacts (T5)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'G6', type: 'Governance', rule: 'Archive before replace (T6)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'G7', type: 'Governance', rule: 'Governance first, mechanism later (T7)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'G8', type: 'Governance', rule: 'Evidence is immutable (T8)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'G9', type: 'Governance', rule: 'No new architectural principles beyond P1-P9 (freeze)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'G10', type: 'Governance', rule: 'No new constitutional documents beyond the baseline list (freeze)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'G11', type: 'Governance', rule: 'No new terminology beyond the final vocabulary (freeze)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'G12', type: 'Governance', rule: 'No new ownership models (freeze)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'G13', type: 'Governance', rule: 'Change to a frozen element is a formal ADR; ADR-001 is the first governance act; ordering gate until ADR-001 exists (freeze)', constraintLink: M, evidenceLink: M, verificationLink: M, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),

  /* --- معايير الخروج EC1..EC10 --- */
  element({ id: 'EC1', type: 'Exit criterion', rule: 'ADR-001 exists and approved; ADR template non-empty and binding', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'EC2', type: 'Exit criterion', rule: 'Glossary document index and ADR index populated; final vocabulary recorded', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'EC3', type: 'Exit criterion', rule: 'DOMAIN_MODEL defines Aggregate and Aggregate Root; Application and Condition roots named', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'EC4', type: 'Exit criterion', rule: 'All 27 affected documents disposed; zero active Partially Consistent/Divergent/Superseded', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Continuously enforced' }),
  element({ id: 'EC5', type: 'Exit criterion', rule: 'Zero forbidden terms in active documents', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'EC6', type: 'Exit criterion', rule: 'Cutover checklist gates on dataset-construction evidence not seed-status', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'EC7', type: 'Exit criterion', rule: 'SREA and dataset-architecture archived; no active document cites them as forward plan', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'EC8', type: 'Exit criterion', rule: 'All 6 traceability chains re-verified with 0 broken', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'EC9', type: 'Exit criterion', rule: 'Enterprise baseline assessment v2 approved with ADR-002-consistent verdict', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
  element({ id: 'EC10', type: 'Exit criterion', rule: 'Informal ADR numbering collision resolved; mapping table present', constraintLink: P, evidenceLink: P, verificationLink: P, currentClassification: 'Documentation only', intendedVerification: 'Automatically verifiable' }),
];

export const RULE_REGISTRY = new ConstitutionalRegistry<ConstitutionalElement>(
  'R1',
  'Rule Registry',
  'D1',
  [
    { document: 'ADR-002', section: 'Canonical Dataset Architecture' },
    { document: 'constitution-enforcement-matrix.csv' },
    { document: 'architecture/registry/registry-index.md', section: 'R1' },
  ],
  CONSTITUTIONAL_RULES,
);
