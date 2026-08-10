/*
 * نموذج ملكية الأدلة (MODEL-EVIDENCE-OWNERSHIP) — بنية الإسناد
 * الفردي لكل دليل إلى مالك واحد (P2, I4, G5). المحتوى الفعلي
 * للأدلة (EVIDENCE_ARTIFACTS ومصادر الأدلة الحاضرة) محفوظ في
 * R3 — يُشار إليه هنا دون تكرار؛ يضيف النموذج قواعد الملكية
 * والبنيّة. نموذج وصفي سلبي فقط.
 */
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

export interface OwnershipRule {
  readonly id: string;
  readonly rule: string;
}

/** قواعد الملكية الفردية للأدلة (لا تُنفَّذ هنا). */
export const EVIDENCE_OWNERSHIP_RULES: ReadonlyArray<OwnershipRule> = [
  { id: 'OWN-1', rule: 'Every evidence artifact has exactly one owning body (P2/I4/G5); a datum with two owners or none is an I4 violation.' },
  { id: 'OWN-2', rule: 'Ownership is declared in R3 (EVIDENCE_ARTIFACTS owningBody) and enforced by the evidence domain (D3) — declared here, enforced there.' },
  { id: 'OWN-3', rule: 'Ownership attaches to the artifact, not to its runtime residence (external references are not ownership).' },
  { id: 'OWN-4', rule: 'Ownership Registry (R10) assigns every table to exactly one aggregate; the evidence domain reconciles artifact ownership against it.' },
];

export const EVIDENCE_OWNERSHIP_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-EVIDENCE-OWNERSHIP',
  name: 'Evidence Ownership Model',
  purpose:
    'Defines the single-owner structure every evidence artifact participates in: one artifact, one owning body, enforcement by the evidence domain. The artifact/owner pairs themselves live in R3; this model contributes the ownership invariants and the linking kind (owns).',
  authority: [
    { document: 'ADR-002', section: 'P2 / I4 / G5' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Evidence Registry); Section 1 (D3)' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3.7' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['owns', 'is-owned-by', 'attaches-to'],
  objectKinds: ['Evidence', 'Ownership', 'Aggregate', 'Baseline'],
  status:
    'Ownership rules defined; R3 keeps the artifact catalog (7 artifact types, 13 present sources) untouched. No ownership act is executed.',
};
