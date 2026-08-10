/*
 * سجل البوابات (R5) — نقاط العملية الملزمة التي تُنفَّذ
 * عندها نتائج التحقق (نشر الوثيقة، التخلص من الوثيقة،
 * اعتماد ADR، قبول البناء، القطع). بوابة بلا تحقق مطلوب
 * أو تحقق بلا بوابة هو إعلان فقط. خط الأساس: 0 من 43
 * عنصرًا لها بوابة. مرحلة الأولى تسجيل هيكلي فقط.
 */
import { ConstitutionalRegistry } from './registry';

export interface GateDefinition {
  readonly id: string;
  readonly name: string;
  readonly owner: string;
  readonly scope: string;
  /** لا بوابة لها تحقق مطلوب في مرحلة الأولى. */
  readonly requiredVerification: ReadonlyArray<string>;
}

export const GATES: ReadonlyArray<GateDefinition> = [
  { id: 'GATE-01', name: 'Document publication gate', owner: 'Enterprise Architecture (constitutional gates)', scope: 'Document publication', requiredVerification: [] },
  { id: 'GATE-02', name: 'Document disposition gate', owner: 'Enterprise Architecture (constitutional gates)', scope: 'Document disposition', requiredVerification: [] },
  { id: 'GATE-03', name: 'ADR approval gate', owner: 'Enterprise Architecture (constitutional gates)', scope: 'ADR approval', requiredVerification: [] },
  { id: 'GATE-04', name: 'Construction acceptance gate', owner: 'Engineering Governance (engineering gates)', scope: 'Construction acceptance', requiredVerification: [] },
  { id: 'GATE-05', name: 'Cutover gate', owner: 'DevOps Governance (cutover)', scope: 'Cutover', requiredVerification: [] },
];

/** تعيينات عنصر←بوابة: فارغة في مرحلة الأولى (0 من 43 عنصرًا لها بوابة). */
export const GATE_ELEMENT_ASSIGNMENTS: ReadonlyArray<{ readonly element: string; readonly gate: string }> = [];

export const GATE_REGISTRY = new ConstitutionalRegistry<GateDefinition>(
  'R5',
  'Gate Registry',
  'D5',
  [
    { document: 'constitutional-enforcement-domains.csv', section: 'D5' },
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Gate Registry)' },
  ],
  GATES,
);
