/*
 * سجل التنفيذ (R7) — أحداث البناء والتنفيذ مع أثر رجعي
 * يبقى بعد الاستعادة (I2, C3, P7). لا يجوز أن يعتمد أي
 * قرار على حدث تنفيذ غائب هنا. إشارة A1: صفوف ops.seed_tracker
 * غير موثوقة، ويجب إعادة بناء الأثر الرجعي — لا ترحيله —
 * في مرحلة لاحقة. مرحلة الأولى تسجيل هيكلي فقط.
 */
import { ConstitutionalRegistry } from './registry';

export type ExecutionEventType = 'Dataset construction' | 'Migration' | 'Installer history' | 'Restore event';

export interface ExecutionEventRecord {
  readonly id: string;
  readonly type: ExecutionEventType;
  readonly recordedAt: string;
  readonly provenance: string;
}

/** إشارة A1: حالة صفوف seed_tracker في مسار الإثبات. */
export const SEED_TRACKER_UNTRUSTED = {
  source: 'ops.seed_tracker',
  status: 'Untrusted',
  reason: 'challenge review A1',
  disposition: 'provenance must be rebuilt, not migrated',
} as const;

export const EXECUTION_EVENT_TYPES: ReadonlyArray<ExecutionEventType> = [
  'Dataset construction',
  'Migration',
  'Installer history',
  'Restore event',
];

/** لا أحداث تنفيذ مسجّلة في مرحلة الأولى. */
export const EXECUTION_EVENTS: ReadonlyArray<ExecutionEventRecord> = [];

export const EXECUTION_REGISTRY = new ConstitutionalRegistry<ExecutionEventRecord>(
  'R7',
  'Execution Registry',
  'D8',
  [
    { document: 'constitutional-enforcement-architecture.md', section: 'Section 2 (Execution Registry)' },
    { document: 'constitutional-enforcement-domains.csv', section: 'D8' },
    { document: 'ADR-002', section: 'I2 / C3 / P7; A1 seed_tracker untrusted' },
  ],
  EXECUTION_EVENTS,
);
