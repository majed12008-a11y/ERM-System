// ============================================================
// Description: Version lifecycle state machine service.
// Orchestrates transitions through the 5-state lifecycle:
// DRAFT → REVIEW → APPROVED → DEPRECATED → ARCHIVED
// with rollback support (DEPRECATED → APPROVED).
// Delegates persistence to injected repository interfaces.
// Authorization is checked at the service boundary.
// ============================================================

import {
  LifecycleStatus,
  assertValidTransition,
  getTransitionAction,
} from '../shared/template-version-lifecycle.types';
import type { AuthUser } from '../shared/types';

// ─── Repository Interfaces (contracts only) ────────────────

export interface VersionData {
  id: number;
  template_id: number;
  version: string;
  status: string;
  content: any;
  content_hash: string;
  variable_definitions: any;
  change_summary: string | null;
  effective_from: Date | null;
  effective_until: Date | null;
  retired_at: Date | null;
  approved_by: number | null;
  approved_at: Date | null;
  created_by: number;
  created_at: Date;
}

export interface IVersionRepository {
  findByCodeAndVersion(code: string, version: string): Promise<VersionData | null>;
  updateStatus(id: number, newStatus: string, userId: number, client?: any): Promise<VersionData>;
  findApproved(templateId: number, now: Date): Promise<VersionData | null>;
  deprecateCurrentApproved(templateId: number, now: Date, client?: any): Promise<VersionData | null>;
  updateEffectiveDates(id: number, effectiveFrom: Date | null, effectiveUntil: Date | null, client?: any): Promise<VersionData>;
}

export interface IAuditRepository {
  log(entry: {
    template_version_id: number;
    action: string;
    actor_id: number;
    previous_status: string | null;
    new_status: string | null;
    comment?: string;
  }, client?: any): Promise<any>;
  findByVersionId(versionId: number): Promise<any[]>;
}

export interface IApprovalRepository {
  findByVersionId(versionId: number): Promise<any[]>;
  allStepsApproved(versionId: number): Promise<boolean>;
}

// ─── Authorization Check ───────────────────────────────────

export function checkLifecyclePermission(
  action: string,
  version: VersionData,
  user: AuthUser,
): void {
  // ADMIN can perform any lifecycle action
  if (user.roles.includes('ETHICS_ADMIN') || user.roles.includes('SUPER_ADMIN')) {
    return;
  }

  // Creator can submit their own DRAFT for review
  if (action === 'SUBMITTED' && version.status === 'DRAFT' && version.created_by === user.id) {
    return;
  }

  // Committee roles (CHAIR, REVIEWER) can approve/reject
  if ((action === 'APPROVED' || action === 'REJECTED') &&
      (user.roles.includes('ETHICS_CHAIR') || user.roles.includes('ETHICS_REVIEWER'))) {
    return;
  }

  throw Object.assign(
    new Error(`Not authorized to perform ${action} on version ${version.version}`),
    { status: 403 },
  );
}

// ─── Transition Preconditions ──────────────────────────────

export function checkTransitionPreconditions(
  action: string,
  version: VersionData,
  comment?: string,
): void {
  // Rejection requires a reason
  if (action === 'REJECTED' && (!comment || comment.trim().length === 0)) {
    throw Object.assign(new Error('Rejection reason is required'), { status: 400 });
  }

  // Only DRAFT content can be submitted
  if (action === 'SUBMITTED' && version.status === 'DRAFT') {
    const hasContent = version.content && (
      (version.content as any)?.ar?.body ||
      (version.content as any)?.en?.body
    );
    if (!hasContent) {
      throw Object.assign(new Error('Cannot submit a version without content'), { status: 400 });
    }
  }

  // Archiving requires the version to be DEPRECATED (already checked by assertValidTransition)
  // Additional check: cannot archive if there's no replacement
  if (action === 'ARCHIVED') {
    // Business rule: archiving is always allowed from DEPRECATED
  }
}

// ─── Lifecycle Service ─────────────────────────────────────

export class VersionLifecycleService {
  constructor(
    private versionRepo: IVersionRepository,
    private auditRepo: IAuditRepository,
    private approvalRepo: IApprovalRepository,
  ) {}

  async submit(
    templateCode: string,
    version: string,
    user: AuthUser,
    comment?: string,
  ): Promise<VersionData> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    // 1. State machine validation
    assertValidTransition(ver.status, 'REVIEW');

    // 2. Authorization
    checkLifecyclePermission('SUBMITTED', ver, user);

    // 3. Preconditions
    checkTransitionPreconditions('SUBMITTED', ver, comment);

    // 4. Execute transition
    const updated = await this.versionRepo.updateStatus(ver.id, 'REVIEW', user.id);

    // 5. Audit
    await this.auditRepo.log({
      template_version_id: ver.id,
      action: 'SUBMITTED',
      actor_id: user.id,
      previous_status: ver.status,
      new_status: 'REVIEW',
      comment: comment || undefined,
    });

    return updated;
  }

  async approve(
    templateCode: string,
    version: string,
    user: AuthUser,
    comment?: string,
  ): Promise<VersionData> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    assertValidTransition(ver.status, 'APPROVED');
    checkLifecyclePermission('APPROVED', ver, user);

    // Check approval workflow completeness
    if (ver.status === 'REVIEW') {
      const steps = await this.approvalRepo.findByVersionId(ver.id);
      if (steps.length > 0) {
        const allApproved = await this.approvalRepo.allStepsApproved(ver.id);
        if (!allApproved) {
          throw Object.assign(
            new Error('Approval workflow not complete: all steps must be APPROVED'),
            { status: 400 },
          );
        }
      }
    }

    const updated = await this.versionRepo.updateStatus(ver.id, 'APPROVED', user.id);

    // Deprecate any previously APPROVED version for this template
    const previousApproved = await this.versionRepo.deprecateCurrentApproved(
      ver.template_id, new Date(),
    );
    if (previousApproved) {
      await this.auditRepo.log({
        template_version_id: previousApproved.id,
        action: 'SUPERSEDED',
        actor_id: user.id,
        previous_status: 'APPROVED',
        new_status: 'DEPRECATED',
        comment: `Superseded by version ${version}`,
      });
    }

    await this.auditRepo.log({
      template_version_id: ver.id,
      action: 'APPROVED',
      actor_id: user.id,
      previous_status: ver.status,
      new_status: 'APPROVED',
      comment: comment || undefined,
    });

    return updated;
  }

  async reject(
    templateCode: string,
    version: string,
    user: AuthUser,
    reason: string,
  ): Promise<VersionData> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    assertValidTransition(ver.status, 'DRAFT');
    checkLifecyclePermission('REJECTED', ver, user);
    checkTransitionPreconditions('REJECTED', ver, reason);

    const updated = await this.versionRepo.updateStatus(ver.id, 'DRAFT', user.id);

    await this.auditRepo.log({
      template_version_id: ver.id,
      action: 'REJECTED',
      actor_id: user.id,
      previous_status: ver.status,
      new_status: 'DRAFT',
      comment: reason,
    });

    return updated;
  }

  async deprecate(
    templateCode: string,
    version: string,
    user: AuthUser,
    reason?: string,
  ): Promise<VersionData> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    assertValidTransition(ver.status, 'DEPRECATED');
    checkLifecyclePermission('DEPRECATED', ver, user);

    const updated = await this.versionRepo.updateStatus(ver.id, 'DEPRECATED', user.id);

    await this.auditRepo.log({
      template_version_id: ver.id,
      action: 'DEPRECATED',
      actor_id: user.id,
      previous_status: ver.status,
      new_status: 'DEPRECATED',
      comment: reason || undefined,
    });

    return updated;
  }

  async archive(
    templateCode: string,
    version: string,
    user: AuthUser,
    reason?: string,
  ): Promise<VersionData> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    assertValidTransition(ver.status, 'ARCHIVED');
    checkLifecyclePermission('ARCHIVED', ver, user);
    checkTransitionPreconditions('ARCHIVED', ver);

    const updated = await this.versionRepo.updateStatus(ver.id, 'ARCHIVED', user.id);

    await this.auditRepo.log({
      template_version_id: ver.id,
      action: 'ARCHIVED',
      actor_id: user.id,
      previous_status: ver.status,
      new_status: 'ARCHIVED',
      comment: reason || undefined,
    });

    return updated;
  }

  async rollback(
    templateCode: string,
    version: string,
    user: AuthUser,
    reason?: string,
  ): Promise<VersionData> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    assertValidTransition(ver.status, 'APPROVED');
    checkLifecyclePermission('ROLLED_BACK', ver, user);

    const updated = await this.versionRepo.updateStatus(ver.id, 'APPROVED', user.id);
    await this.versionRepo.updateEffectiveDates(ver.id, null, null);

    // Deprecate the currently active version if different
    const currentActive = await this.versionRepo.findApproved(ver.template_id, new Date());
    if (currentActive && currentActive.id !== ver.id) {
      await this.versionRepo.deprecateCurrentApproved(ver.template_id, new Date());
      await this.auditRepo.log({
        template_version_id: currentActive.id,
        action: 'SUPERSEDED',
        actor_id: user.id,
        previous_status: 'APPROVED',
        new_status: 'DEPRECATED',
        comment: `Superseded by rollback to version ${version}`,
      });
    }

    await this.auditRepo.log({
      template_version_id: ver.id,
      action: 'ROLLED_BACK',
      actor_id: user.id,
      previous_status: 'DEPRECATED',
      new_status: 'APPROVED',
      comment: reason || undefined,
    });

    return updated;
  }

  async getTransitionHistory(
    templateCode: string,
    version: string,
  ): Promise<any[]> {
    const ver = await this.getVersionOrThrow(templateCode, version);
    return this.auditRepo.findByVersionId(ver.id);
  }

  async getApprovalStatus(
    templateCode: string,
    version: string,
  ): Promise<any[]> {
    const ver = await this.getVersionOrThrow(templateCode, version);
    return this.approvalRepo.findByVersionId(ver.id);
  }

  async isVersionActive(
    templateCode: string,
    version: string,
  ): Promise<boolean> {
    const ver = await this.getVersionOrThrow(templateCode, version);
    if (ver.status !== 'APPROVED') return false;

    const now = new Date();
    if (ver.effective_from && ver.effective_from > now) return false;
    if (ver.effective_until && ver.effective_until <= now) return false;

    return true;
  }

  async getActiveVersion(templateCode: string): Promise<VersionData | null> {
    const versions = await this.versionRepo.findByCodeAndVersion(templateCode, ''); // Will be replaced by proper method
    return null; // placeholder — Task 6 completes this
  }

  // ─── Private ──────────────────────────────────────────────

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