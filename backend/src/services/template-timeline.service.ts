import {
  TimelineDTO,
  TimelineEvent,
  TimelinePeriod,
  ActiveVersionDTO,
  ChronologyDTO,
  ChronologyEntry,
  OverlapWarning,
  TimelineEventCategory,
  isDateInRange,
  rangesOverlap,
} from '../shared/template-timeline.types';
import { ACTIVE_STATUSES, LifecycleStatus } from '../shared/template-version-lifecycle.types';
import type { VersionData } from './template-version-lifecycle.service';

export interface ITimelineVersionRepository {
  findByCodeAndVersion(code: string, version: string): Promise<VersionData | null>;
  findByTemplateCode(code: string): Promise<VersionData[]>;
  findById(id: number): Promise<VersionData | null>;
  findApproved(templateId: number, now: Date): Promise<VersionData | null>;
}

export interface ITimelineAuditRepository {
  findByVersionId(versionId: number): Promise<any[]>;
}

export interface ITimelineTemplateRepository {
  findIdByCode(code: string): Promise<number | null>;
}

export class TimelineService {
  constructor(
    private versionRepo: ITimelineVersionRepository,
    private auditRepo: ITimelineAuditRepository,
    private templateRepo: ITimelineTemplateRepository,
  ) {}

  async buildTimeline(templateCode: string, version: string): Promise<TimelineDTO> {
    const ver = await this.getVersionOrThrow(templateCode, version);
    const rawEvents = await this.auditRepo.findByVersionId(ver.id);

    const events: TimelineEvent[] = rawEvents.map((e: any, i: number) => ({
      id: e.id || i + 1,
      versionId: ver.id,
      version: ver.version,
      category: this.mapActionToCategory(e.action || 'CREATED'),
      fromStatus: e.previous_status || null,
      toStatus: e.new_status || null,
      timestamp: new Date(e.created_at || e.timestamp || new Date()),
      actorId: e.actor_id || e.acted_by || 0,
      comment: e.comment || null,
    }));

    events.sort((a, b) => a.timestamp.getTime() - b.timestamp.getTime());

    const periods = this.buildPeriods(events, ver);
    const now = new Date();

    return {
      versionId: ver.id,
      templateCode,
      version: ver.version,
      currentStatus: ver.status,
      events,
      periods,
      effectiveFrom: ver.effective_from,
      effectiveUntil: ver.effective_until,
      isActive: this.isVersionActiveNow(ver, now),
      isScheduled: !!(
        ver.status === 'APPROVED' &&
        ver.effective_from &&
        ver.effective_from > now
      ),
      isExpired: !!(
        ver.status === 'APPROVED' &&
        ver.effective_until &&
        ver.effective_until <= now
      ),
    };
  }

  async buildVersionTimelines(templateCode: string): Promise<TimelineDTO[]> {
    const versions = await this.versionRepo.findByTemplateCode(templateCode);
    if (versions.length === 0) return [];

    const timelines = await Promise.all(
      versions.map(v => this.buildTimeline(templateCode, v.version)),
    );

    timelines.sort((a, b) => {
      const aDate = a.effectiveFrom || a.events[0]?.timestamp || new Date(0);
      const bDate = b.effectiveFrom || b.events[0]?.timestamp || new Date(0);
      return bDate.getTime() - aDate.getTime();
    });

    return timelines;
  }

  async resolveActiveVersion(
    templateCode: string,
    asOfDate?: Date,
  ): Promise<ActiveVersionDTO | null> {
    const templateId = await this.templateRepo.findIdByCode(templateCode);
    if (!templateId) return null;

    const now = asOfDate || new Date();
    const versions = await this.versionRepo.findByTemplateCode(templateCode);

    const approvedVersions = versions.filter(
      v => v.status === 'APPROVED' && this.isVersionActiveNow(v, now),
    );

    if (approvedVersions.length === 0) return null;

    approvedVersions.sort((a, b) => {
      const aDate = a.effective_from || a.approved_at || a.created_at;
      const bDate = b.effective_from || b.approved_at || b.created_at;
      return bDate.getTime() - aDate.getTime();
    });

    const active = approvedVersions[0];

    return {
      versionId: active.id,
      templateId: active.template_id,
      templateCode,
      version: active.version,
      status: active.status as LifecycleStatus,
      effectiveFrom: active.effective_from,
      effectiveUntil: active.effective_until,
      resolvedAt: now,
    };
  }

  async getChronology(templateCode: string): Promise<ChronologyDTO> {
    const templateId = await this.templateRepo.findIdByCode(templateCode);
    if (!templateId) {
      return { templateCode, templateId: 0, entries: [], activeEntry: null };
    }

    const versions = await this.versionRepo.findByTemplateCode(templateCode);
    const now = new Date();

    const entries: ChronologyEntry[] = versions
      .filter(v => v.status === 'APPROVED' || v.status === 'DEPRECATED' || v.status === 'ARCHIVED')
      .map(v => ({
        versionId: v.id,
        version: v.version,
        status: v.status,
        effectiveFrom: v.effective_from,
        effectiveUntil: v.effective_until,
        approvedAt: v.approved_at,
        isActiveNow: v.status === 'APPROVED' && this.isVersionActiveNow(v, now),
      }));

    entries.sort((a, b) => {
      const aDate = a.effectiveFrom || a.approvedAt || new Date(0);
      const bDate = b.effectiveFrom || b.approvedAt || new Date(0);
      return aDate.getTime() - bDate.getTime();
    });

    const activeEntry = entries.find(e => e.isActiveNow) || null;

    return { templateCode, templateId, entries, activeEntry };
  }

  async detectOverlaps(templateCode: string): Promise<OverlapWarning[]> {
    const templateId = await this.templateRepo.findIdByCode(templateCode);
    if (!templateId) return [];

    const versions = await this.versionRepo.findByTemplateCode(templateCode);

    const approved = versions.filter(
      v => v.status === 'APPROVED' && v.effective_from !== null,
    );

    const warnings: OverlapWarning[] = [];

    for (let i = 0; i < approved.length; i++) {
      for (let j = i + 1; j < approved.length; j++) {
        const a = approved[i];
        const b = approved[j];

        if (a.id === b.id) continue;

        if (rangesOverlap(a.effective_from, a.effective_until, b.effective_from, b.effective_until)) {
          const overlapFrom = new Date(Math.max(
            (a.effective_from || new Date(0)).getTime(),
            (b.effective_from || new Date(0)).getTime(),
          ));
          const overlapUntil = new Date(Math.min(
            (a.effective_until || new Date(8640000000000000)).getTime(),
            (b.effective_until || new Date(8640000000000000)).getTime(),
          ));

          warnings.push({
            versionIdA: a.id,
            versionA: a.version,
            versionIdB: b.id,
            versionB: b.version,
            overlapFrom,
            overlapUntil,
          });
        }
      }
    }

    return warnings;
  }

  async checkChronologyConsistency(
    templateCode: string,
  ): Promise<{ valid: boolean; issues: string[] }> {
    const issues: string[] = [];

    const timeline = await this.buildVersionTimelines(templateCode);
    if (timeline.length === 0) {
      return { valid: true, issues: [] };
    }

    for (const tl of timeline) {
      if (tl.effectiveFrom && tl.effectiveUntil && tl.effectiveUntil <= tl.effectiveFrom) {
        issues.push(
          `Version ${tl.version}: effective_until (${tl.effectiveUntil.toISOString()}) ` +
          `is not after effective_from (${tl.effectiveFrom.toISOString()})`,
        );
      }
    }

    const overlaps = await this.detectOverlaps(templateCode);
    for (const ov of overlaps) {
      issues.push(
        `Overlap: v${ov.versionA} and v${ov.versionB} overlap ` +
        `from ${ov.overlapFrom.toISOString()} to ${ov.overlapUntil.toISOString()}`,
      );
    }

    const chronology = await this.getChronology(templateCode);
    const activeEntries = chronology.entries.filter(e => e.isActiveNow);
    if (activeEntries.length > 1) {
      issues.push(
        `Multiple active versions: ${activeEntries.map(e => e.version).join(', ')}`,
      );
    }

    return { valid: issues.length === 0, issues };
  }

  private buildPeriods(events: TimelineEvent[], version: VersionData): TimelinePeriod[] {
    if (events.length === 0) {
      return [{
        status: version.status,
        versionId: version.id,
        version: version.version,
        from: version.created_at,
        to: null,
      }];
    }

    const periods: TimelinePeriod[] = [];

    for (let i = 0; i < events.length; i++) {
      const event = events[i];
      const toEvent = i + 1 < events.length ? events[i + 1] : null;

      if (event.toStatus) {
        periods.push({
          status: event.toStatus,
          versionId: version.id,
          version: version.version,
          from: event.timestamp,
          to: toEvent ? toEvent.timestamp : null,
        });
      }
    }

    return periods;
  }

  private isVersionActiveNow(version: VersionData, now: Date): boolean {
    if (version.status !== 'APPROVED') return false;
    if (version.effective_from && version.effective_from > now) return false;
    if (version.effective_until && version.effective_until <= now) return false;
    return true;
  }

  private mapActionToCategory(action: string): TimelineEventCategory {
    const normalized = action.toUpperCase();
    const CATEGORIES: readonly string[] = [
      'CREATED', 'SUBMITTED', 'APPROVED', 'REJECTED',
      'DEPRECATED', 'ARCHIVED', 'ROLLED_BACK', 'SUPERSEDED',
      'ACTIVATED', 'EXPIRED',
    ];
    if (CATEGORIES.includes(normalized)) {
      return normalized as TimelineEventCategory;
    }
    return 'CREATED';
  }

  private async getVersionOrThrow(
    templateCode: string,
    version: string,
  ): Promise<VersionData> {
    const ver = await this.versionRepo.findByCodeAndVersion(templateCode, version);
    if (!ver) {
      throw Object.assign(
        new Error(`Version ${version} of template "${templateCode}" not found`),
        { status: 404 },
      );
    }
    return ver;
  }
}
