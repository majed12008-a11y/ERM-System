import { AuthUser } from '../shared/types';
import { assertValidTransition } from '../shared/template-version-lifecycle.types';
import { VersionData, VersionLifecycleService } from './template-version-lifecycle.service';
import { TimelineService, ITimelineVersionRepository } from './template-timeline.service';
import { TimelineDTO } from '../shared/template-timeline.types';

export interface RollbackValidationResult {
  canRollback: boolean;
  reasons: string[];
}

export interface RollbackImpact {
  previouslyActiveVersion: VersionData | null;
  timelineBefore: TimelineDTO;
  timelineAfter: TimelineDTO;
}

export interface RollbackResult {
  success: boolean;
  versionId: number;
  templateCode: string;
  version: string;
  previousStatus: string;
  newStatus: string;
  rollbackedAt: Date;
  contentIntegrityVerified: boolean;
  impact: RollbackImpact;
  consistencyVerified: boolean;
  consistencyIssues: string[];
}

export interface IRollbackVersionRepository {
  findByCodeAndVersion(code: string, version: string): Promise<VersionData | null>;
  findApproved(templateId: number, now: Date): Promise<VersionData | null>;
}

export class RollbackService {
  constructor(
    private lifecycleService: VersionLifecycleService,
    private timelineService: TimelineService,
    private versionRepo: IRollbackVersionRepository,
  ) {}

  canRollback(user: AuthUser): boolean {
    return user.roles.includes('ETHICS_ADMIN') || user.roles.includes('SUPER_ADMIN');
  }

  async validateRollback(
    templateCode: string,
    version: string,
    user: AuthUser,
  ): Promise<RollbackValidationResult> {
    const reasons: string[] = [];

    try {
      const ver = await this.getVersionOrThrow(templateCode, version);

      try {
        assertValidTransition(ver.status, 'APPROVED');
      } catch (e: any) {
        reasons.push(e.message);
      }

      if (!this.canRollback(user)) {
        reasons.push('Not authorized to perform rollback');
      }
    } catch (e: any) {
      reasons.push(e.message);
    }

    return { canRollback: reasons.length === 0, reasons };
  }

  async executeRollback(
    templateCode: string,
    version: string,
    user: AuthUser,
    reason?: string,
  ): Promise<RollbackResult> {
    const validation = await this.validateRollback(templateCode, version, user);
    if (!validation.canRollback) {
      throw Object.assign(
        new Error(`Rollback validation failed: ${validation.reasons.join('; ')}`),
        {
          status: validation.reasons.some(r => r.includes('Not authorized'))
            ? 403
            : validation.reasons.some(r => r.includes('not found'))
              ? 404
              : 400,
        },
      );
    }

    const ver = await this.getVersionOrThrow(templateCode, version);
    const previousStatus = ver.status;

    const timelineBefore = await this.timelineService.buildTimeline(templateCode, version);
    const previouslyActive = await this.versionRepo.findApproved(ver.template_id, new Date());

    const contentHashAtRollback = ver.content_hash;

    const updated = await this.lifecycleService.rollback(templateCode, version, user, reason);

    const timelineAfter = await this.timelineService.buildTimeline(templateCode, version);
    const consistency = await this.timelineService.checkChronologyConsistency(templateCode);

    return {
      success: true,
      versionId: updated.id,
      templateCode,
      version,
      previousStatus,
      newStatus: updated.status,
      rollbackedAt: new Date(),
      contentIntegrityVerified: updated.content_hash === contentHashAtRollback,
      impact: {
        previouslyActiveVersion: previouslyActive && previouslyActive.id !== ver.id
          ? previouslyActive : null,
        timelineBefore,
        timelineAfter,
      },
      consistencyVerified: consistency.valid,
      consistencyIssues: consistency.issues,
    };
  }

  async getRollbackHistory(
    templateCode: string,
  ): Promise<{ version: string; rollbackedAt: Date; previousStatus: string }[]> {
    const timeline = await this.timelineService.buildVersionTimelines(templateCode);
    const entries: { version: string; rollbackedAt: Date; previousStatus: string }[] = [];

    for (const tl of timeline) {
      const rollbackEvents = tl.events.filter(e => e.category === 'ROLLED_BACK');
      for (const event of rollbackEvents) {
        entries.push({
          version: tl.version,
          rollbackedAt: event.timestamp,
          previousStatus: event.fromStatus || 'UNKNOWN',
        });
      }
    }

    entries.sort((a, b) => b.rollbackedAt.getTime() - a.rollbackedAt.getTime());
    return entries;
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
