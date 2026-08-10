/*
 * نموذج تحليل السلطة (MODEL-AUTHORITY-RESOLUTION) — بنية تحويل
 * كل مالك نطاق إنفاذ (D1..D8) إلى الجهة المختصة ومستندات السلطة.
 * النموذج يُعرّف القرار (resolution) كتابةً؛ لا يُنفَّذ أي تحليل.
 * المصدر: constitutional-enforcement-architecture.md §1
 * (enforcement domains) و constitutional-enforcement-domains.csv.
 */
import { EnforcementDomainId } from '../registries/registry';
import { MetadataModel } from './types';
import { PHASE_3_SCOPE } from './types';

export interface AuthorityResolution {
  readonly owner: EnforcementDomainId;
  readonly authorityBody: string;
  readonly authorityDocuments: ReadonlyArray<string>;
  readonly basis: string;
}

/** قرارات السلطة لكل نطاق إنفاذ (D1..D8). */
export const AUTHORITY_RESOLUTIONS: ReadonlyArray<AuthorityResolution> = [
  { owner: 'D1', authorityBody: 'Enterprise Architecture (ADR board)', authorityDocuments: ['ADR-001', 'ADR-002', 'ADR-INDEX', 'baseline-v2-index'], basis: 'Constitutional definition; rules enter and leave the constitution only through this domain.' },
  { owner: 'D2', authorityBody: 'Enterprise Architecture (ADR board); Domain Architecture for domain-model-derived constraints', authorityDocuments: ['ADR-002'], basis: 'Constraint derivation and Constraint Registry ownership.' },
  { owner: 'D3', authorityBody: 'Single artifact owner per P2/I4/G5 (Domain/Engineering/DevOps/Enterprise Architecture)', authorityDocuments: ['ADR-002'], basis: 'Evidence curation and artifact ownership declaration; Ownership Registry (R10).' },
  { owner: 'D4', authorityBody: 'Independent Enterprise Architecture Review Board', authorityDocuments: ['ADR-002'], basis: 'Objective verification, structurally independent of the artifacts it verifies.' },
  { owner: 'D5', authorityBody: 'Engineering Governance (engineering gates); Enterprise Architecture (constitutional gates); DevOps Governance (cutover)', authorityDocuments: ['ADR-002'], basis: 'Gate ownership and binding process points.' },
  { owner: 'D6', authorityBody: 'Enterprise Architecture (ADR board) for constitutional decisions; Independent Review Board for verification rulings', authorityDocuments: ['ADR-002'], basis: 'Decision and exception recording; every transition has an authority.' },
  { owner: 'D7', authorityBody: 'Enterprise Architecture', authorityDocuments: ['constitutional-state-machine.md', 'ADR-002'], basis: 'State assignment and observability of every constitutional object.' },
  { owner: 'D8', authorityBody: 'Engineering Governance / DevOps Governance', authorityDocuments: ['ADR-002'], basis: 'Execution and provenance records that survive restore (I2/C3/P7).' },
];

export const AUTHORITY_RESOLUTION_MODEL: MetadataModel = {
  scope: PHASE_3_SCOPE,
  id: 'MODEL-AUTHORITY-RESOLUTION',
  name: 'Authority Resolution Model',
  purpose:
    'Defines, for each enforcement domain owner (D1..D8), the authority body and authority documents that legitimize its enforcement acts. The future engine resolves the recorded authority of a decision, exception, or transition against this model.',
  authority: [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 1 (Enforcement Domains)' },
    { document: 'constitutional-enforcement-domains.csv', section: 'D1..D8' },
    { document: 'constitutional-object-model.md', section: 'Section 1' },
    { document: 'ADR-002' },
    { document: 'ADR-001', section: 'Series foundation' },
  ],
  composedOf: ['owns', 'records'],
  objectKinds: ['Rule', 'Decision', 'Exception', 'Ownership', 'Baseline', 'Verification', 'Gate'],
  status:
    'Resolution map defined for all eight domains; no authority act is executed. A transition without a recorded authority remains a state-machine violation by definition (§4.6). `cites` is not composed here: the vocabulary range of `cites` is ADR → Evidence/Traceability (object-model §2.2), which cannot express a decision citing a document (review MED-1).',
};
