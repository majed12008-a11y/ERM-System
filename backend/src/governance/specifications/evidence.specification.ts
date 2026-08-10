/*
 * مواصفة الدليل (SPEC-EVIDENCE) — البنية الهيكلية لتعريف الدليل:
 * الأصناف التي تفحصها القيود ومالك كل أصل (P2, I4, G5). تُعرَّف
 * هنا الحقول البنيوية فقط؛ لا يُنتَج أي أصل أدلة جديد. المرجع:
 * R3 (سجل الأدلة) و constitutional-enforcement-architecture.md §2.
 */
import { PHASE_2_SCOPE, SpecKindDefinition } from './types';

export const EVIDENCE_SPEC_DEFINITION: SpecKindDefinition = {
  scope: PHASE_2_SCOPE,
  id: 'SPEC-EVIDENCE',
  kind: 'Evidence',
  name: 'Evidence Specification',
  extends: 'R3',
  owner: 'D3',
  purpose:
    'Structural definition of an evidence specification: the artifact a constraint examines, its single owning body (P2/I4/G5), and its currency. An unregistered evidence source is not admissible as evidence.',
  shape: [
    { name: 'artifact', meaning: 'The evidence artifact identity (R3 EVIDENCE_ARTIFACTS reference).', required: true, source: 'enforcement architecture §2 (Evidence Registry)' },
    { name: 'owningBody', meaning: 'The single owning body per P2/I4/G5; ownership is declared, single, and enforced.', required: true, source: 'ADR-002 P2 / I4 / G5; constitutional-object-model §3.7' },
    { name: 'currency', meaning: 'The currency / recency requirement the artifact must meet to be admissible.', required: true, source: 'enforcement architecture §2 (Evidence Registry currency)' },
    { name: 'admissibleAs', meaning: 'The purpose for which the artifact is admissible as evidence.', required: true, source: 'constitutional-object-model §2.2 (is examined by → Constraint)' },
    { name: 'examinedBy', meaning: 'The constraint(s) that examine this artifact (R2 reference).', required: true, source: 'constitutional-object-model §2.2 (is examined by → Constraint)' },
  ],
  objectModelRelations: 'is examined by → Constraint; has → Ownership (single, P2/I4/G5); is cited by → Traceability',
  stateMachineApplicability:
    'Follows the uniform state machine (constitutional-state-machine §5); an evidence source is Approved when curated and Active when admissible.',
  authority: [
    { document: 'ADR-002', section: 'P2 / I4 / G5' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Evidence Registry); Section 3' },
    { document: 'constitutional-object-model.md', section: 'Section 2.2; Section 3' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  instantiates:
    'R3 registers 7 evidence artifact types (EVIDENCE_ARTIFACTS) and 13 present evidence sources (EVIDENCE_GAP_COUNT = 30).',
};
