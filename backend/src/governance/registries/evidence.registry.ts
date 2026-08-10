/*
 * سجل الأدلة (R3) — الأصناف التي تفحصها القيود ومالك
 * كل أصل (P2, I4, G5). دليل غير مسجّل غير مقبول كدليل.
 * خط الأساس: 13 من 43 عنصرًا لها أدلة حاضرة (P9, I8,
 * I11, EC1..EC10) و30 غائبة. مرحلة الأولى كتالوج هيكلي
 * فقط — لا يُنتَج هنا أي أصل أدلة جديد.
 */
import { ConstitutionalElementId } from './types';
import { ConstitutionalRegistry } from './registry';

export interface EvidenceArtifactType {
  readonly artifact: string;
  readonly owningBody: string;
}

/** أصناف أدلة D3 (constitutional-enforcement-architecture.md §2، D3). */
export const EVIDENCE_ARTIFACTS: ReadonlyArray<EvidenceArtifactType> = [
  { artifact: 'Aggregate model', owningBody: 'Domain Architecture (models)' },
  { artifact: 'Business dependency graph', owningBody: 'Domain Architecture (models)' },
  { artifact: 'Natural-key sets', owningBody: 'Domain Architecture (models)' },
  { artifact: 'Construction product', owningBody: 'Engineering Governance (engineering artifacts)' },
  { artifact: 'Dead-data inventory', owningBody: 'Engineering Governance (engineering artifacts)' },
  { artifact: 'Documents', owningBody: 'Enterprise Architecture (constitutional documents)' },
  { artifact: 'Database state', owningBody: 'DevOps Governance (operational artifacts)' },
];

export interface EvidenceRecord {
  readonly element: ConstitutionalElementId;
  readonly evidencePresent: true;
  readonly evidenceSource: string;
}

export const EVIDENCE_PRESENT: ReadonlyArray<EvidenceRecord> = [
  { element: 'P9', evidencePresent: true, evidenceSource: 'Dead-data inventory (matrix Present); extension: consumer-measurement window (§6.2)' },
  { element: 'I8', evidencePresent: true, evidenceSource: 'Canonical counts consumer analysis (matrix Present); extension: consumer-measurement window (§6.2)' },
  { element: 'I11', evidencePresent: true, evidenceSource: '174+ RLS policies + app.user_id context' },
  { element: 'EC1', evidencePresent: true, evidenceSource: 'ADR-001 file + approval record' },
  { element: 'EC2', evidencePresent: true, evidenceSource: 'Glossary document index + ADR index + final vocabulary' },
  { element: 'EC3', evidencePresent: true, evidenceSource: 'DOMAIN_MODEL' },
  { element: 'EC4', evidencePresent: true, evidenceSource: 'Consistency matrix + document disposition records' },
  { element: 'EC5', evidencePresent: true, evidenceSource: 'Active documents (baseline v2 set)' },
  { element: 'EC6', evidencePresent: true, evidenceSource: 'Cutover checklist' },
  { element: 'EC7', evidencePresent: true, evidenceSource: 'SREA / dataset-architecture documents' },
  { element: 'EC8', evidencePresent: true, evidenceSource: 'The 6 traceability chains' },
  { element: 'EC9', evidencePresent: true, evidenceSource: 'Enterprise baseline assessment v2' },
  { element: 'EC10', evidencePresent: true, evidenceSource: 'ADR-INDEX mapping table' },
];

/** عدد العناصر الغائب عنها دليل حالي (43 − 13). */
export const EVIDENCE_GAP_COUNT = 30;

export const EVIDENCE_REGISTRY = new ConstitutionalRegistry<EvidenceRecord>(
  'R3',
  'Evidence Registry',
  'D3',
  [
    { document: 'ADR-002', section: 'P2 / I4 / G5' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Evidence Registry)' },
    { document: 'constitutional-enforcement-domains.csv', section: 'D3' },
  ],
  EVIDENCE_PRESENT,
);
