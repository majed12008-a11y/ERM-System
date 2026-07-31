import type { LifecycleStatus } from './template-version-lifecycle.types';

export const TIMELINE_EVENT_CATEGORIES = [
  'CREATED', 'SUBMITTED', 'APPROVED', 'REJECTED',
  'DEPRECATED', 'ARCHIVED', 'ROLLED_BACK', 'SUPERSEDED',
  'ACTIVATED', 'EXPIRED',
] as const;

export type TimelineEventCategory = (typeof TIMELINE_EVENT_CATEGORIES)[number];

export interface TimelineEvent {
  id: number;
  versionId: number;
  version: string;
  category: TimelineEventCategory;
  fromStatus: string | null;
  toStatus: string | null;
  timestamp: Date;
  actorId: number;
  comment: string | null;
}

export interface TimelinePeriod {
  status: string;
  versionId: number;
  version: string;
  from: Date;
  to: Date | null;
}

export interface TimelineDTO {
  versionId: number;
  templateCode: string;
  version: string;
  currentStatus: string;
  events: TimelineEvent[];
  periods: TimelinePeriod[];
  effectiveFrom: Date | null;
  effectiveUntil: Date | null;
  isActive: boolean;
  isScheduled: boolean;
  isExpired: boolean;
}

export interface ActiveVersionDTO {
  versionId: number;
  templateId: number;
  templateCode: string;
  version: string;
  status: LifecycleStatus;
  effectiveFrom: Date | null;
  effectiveUntil: Date | null;
  resolvedAt: Date;
}

export interface ChronologyEntry {
  versionId: number;
  version: string;
  status: string;
  effectiveFrom: Date | null;
  effectiveUntil: Date | null;
  approvedAt: Date | null;
  isActiveNow: boolean;
}

export interface ChronologyDTO {
  templateCode: string;
  templateId: number;
  entries: ChronologyEntry[];
  activeEntry: ChronologyEntry | null;
}

export interface OverlapWarning {
  versionIdA: number;
  versionA: string;
  versionIdB: number;
  versionB: string;
  overlapFrom: Date;
  overlapUntil: Date;
}

export function isDateInRange(
  date: Date,
  from: Date | null,
  until: Date | null,
): boolean {
  if (from && date < from) return false;
  if (until && date >= until) return false;
  return true;
}

export function rangesOverlap(
  fromA: Date | null,
  untilA: Date | null,
  fromB: Date | null,
  untilB: Date | null,
): boolean {
  const aStart = fromA ?? new Date(0);
  const aEnd = untilA ?? new Date(8640000000000000);
  const bStart = fromB ?? new Date(0);
  const bEnd = untilB ?? new Date(8640000000000000);
  return aStart < bEnd && bStart < aEnd;
}

export function isAfterNow(date: Date): boolean {
  return date > new Date();
}
