/*
 * سجل القرارات (R6) — النتيجة المسجّلة لكل تحقق ولكل
 * حكم بوابة، بسلطتها. بدون سجل قرار يكون الإنفاذ غير
 * قابل للملاحظة (T3/G3/EC8). خط الأساس: 0 من 43
 * عنصرًا لها قرار مسجّل. مرحلة الأولى تسجيل هيكلي فقط —
 * لا يُسجَّل هنا أي قرار.
 */
import { ConstitutionalRegistry } from './registry';

export type DecisionType = 'Verification outcome' | 'Gate ruling' | 'ADR approval' | 'Exception grant';

export interface DecisionRecord {
  readonly id: string;
  readonly type: DecisionType;
  readonly targetElement: string;
  readonly authority: string;
  readonly recordedOn: string;
}

/** لا قرارات مسجّلة في مرحلة الأولى. */
export const DECISIONS: ReadonlyArray<DecisionRecord> = [];

export const DECISION_REGISTRY = new ConstitutionalRegistry<DecisionRecord>(
  'R6',
  'Decision Registry',
  'D6',
  [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Decision Registry)' },
    { document: 'constitutional-enforcement-domains.csv', section: 'D6' },
    { document: 'ADR-002', section: 'T3 / G3 / EC8' },
  ],
  DECISIONS,
);
