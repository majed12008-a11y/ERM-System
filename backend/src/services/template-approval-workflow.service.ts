import type { AuthUser } from '../shared/types';
import type { VersionData } from './template-version-lifecycle.service';
import { assertValidTransition, getTransitionAction } from '../shared/template-version-lifecycle.types';
import { checkLifecyclePermission } from './template-version-lifecycle.service';
import type {
  TemplateApprovalWorkflowRepository,
  ApprovalStepRow,
  CreateApprovalStepInput,
} from '../repositories/template-approval-workflow.repository';

export interface ApprovalAuditEntry {
  action: string;
  actor: number;
  timestamp: Date;
  reason: string | null;
  previousState: string;
  newState: string;
  stepId: number;
  templateVersionId: number;
  stepOrder: number;
}

export interface ApprovalStatusDTO {
  versionId: number;
  templateCode: string;
  version: string;
  totalSteps: number;
  approvedSteps: number;
  rejectedSteps: number;
  pendingSteps: number;
  isFullyApproved: boolean;
  steps: ApprovalStepRow[];
}

export interface ApproveStepResult {
  step: ApprovalStepRow;
  fullyApproved: boolean;
  audit: ApprovalAuditEntry;
}

export interface InitiateApprovalResult {
  steps: ApprovalStepRow[];
  readyForApproval: boolean;
}

export class ApprovalWorkflowService {
  constructor(
    private approvalRepo: TemplateApprovalWorkflowRepository,
    private versionRepo: {
      findByCodeAndVersion(code: string, version: string): Promise<VersionData | null>;
    },
  ) {}

  canApproveStep(user: AuthUser, step: ApprovalStepRow): boolean {
    if (user.roles.includes('ETHICS_ADMIN') || user.roles.includes('SUPER_ADMIN')) return true;
    if (step.approver_id !== null && step.approver_id === user.id) return true;
    return user.roles.includes(step.approver_role);
  }

  canInitiateApproval(user: AuthUser, version: VersionData): boolean {
    if (user.roles.includes('ETHICS_ADMIN') || user.roles.includes('SUPER_ADMIN')) return true;
    return version.created_by === user.id;
  }

  canCancelApproval(user: AuthUser, version: VersionData): boolean {
    return user.roles.includes('ETHICS_ADMIN') || user.roles.includes('SUPER_ADMIN');
  }

  async initiateApproval(
    templateCode: string,
    version: string,
    steps: Omit<CreateApprovalStepInput, 'template_version_id' | 'step_order'>[],
    user: AuthUser,
  ): Promise<InitiateApprovalResult> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    assertValidTransition(ver.status, 'REVIEW');
    checkLifecyclePermission('SUBMITTED', ver, user);

    if (!this.canInitiateApproval(user, ver)) {
      throw Object.assign(new Error('Not authorized to initiate approval workflow'), { status: 403 });
    }

    if (steps.length === 0) {
      throw Object.assign(new Error('At least one approval step is required'), { status: 400 });
    }

    const existingSteps = await this.approvalRepo.findByVersionId(ver.id);
    if (existingSteps.length > 0) {
      throw Object.assign(new Error('Approval workflow already exists for this version'), { status: 409 });
    }

    const stepInputs: CreateApprovalStepInput[] = steps.map((s, i) => ({
      template_version_id: ver.id,
      step_order: i + 1,
      approver_role: s.approver_role,
      approver_id: s.approver_id ?? null,
    }));

    const created = await this.approvalRepo.createSteps(stepInputs);

    return {
      steps: created,
      readyForApproval: ver.status === 'REVIEW',
    };
  }

  async approveStep(
    templateCode: string,
    version: string,
    stepId: number,
    user: AuthUser,
    comment?: string,
  ): Promise<ApproveStepResult> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    if (ver.status !== 'REVIEW') {
      throw Object.assign(
        new Error(`Cannot approve step: version is in "${ver.status}" status, expected "REVIEW"`),
        { status: 400 },
      );
    }

    const step = await this.approvalRepo.findById(stepId);
    if (!step) {
      throw Object.assign(new Error('Approval step not found'), { status: 404 });
    }
    if (step.template_version_id !== ver.id) {
      throw Object.assign(new Error('Approval step does not belong to this version'), { status: 400 });
    }
    if (step.status !== 'PENDING') {
      throw Object.assign(new Error(`Approval step is already "${step.status}"`), { status: 400 });
    }

    if (!this.canApproveStep(user, step)) {
      throw Object.assign(new Error('Not authorized to approve this step'), { status: 403 });
    }

    const updated = await this.approvalRepo.approveStep(stepId, user.id, comment);
    const fullyApproved = await this.approvalRepo.allStepsApproved(ver.id);

    const audit: ApprovalAuditEntry = {
      action: 'APPROVED',
      actor: user.id,
      timestamp: new Date(),
      reason: comment || null,
      previousState: 'PENDING',
      newState: 'APPROVED',
      stepId: updated.id,
      templateVersionId: ver.id,
      stepOrder: updated.step_order,
    };

    return { step: updated, fullyApproved, audit };
  }

  async rejectStep(
    templateCode: string,
    version: string,
    stepId: number,
    user: AuthUser,
    comment?: string,
  ): Promise<{ step: ApprovalStepRow; audit: ApprovalAuditEntry }> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    if (ver.status !== 'REVIEW') {
      throw Object.assign(
        new Error(`Cannot reject step: version is in "${ver.status}" status, expected "REVIEW"`),
        { status: 400 },
      );
    }

    const step = await this.approvalRepo.findById(stepId);
    if (!step) {
      throw Object.assign(new Error('Approval step not found'), { status: 404 });
    }
    if (step.template_version_id !== ver.id) {
      throw Object.assign(new Error('Approval step does not belong to this version'), { status: 400 });
    }
    if (step.status !== 'PENDING') {
      throw Object.assign(new Error(`Approval step is already "${step.status}"`), { status: 400 });
    }

    if (!this.canApproveStep(user, step)) {
      throw Object.assign(new Error('Not authorized to reject this step'), { status: 403 });
    }

    const updated = await this.approvalRepo.rejectStep(stepId, user.id, comment);

    const audit: ApprovalAuditEntry = {
      action: 'REJECTED',
      actor: user.id,
      timestamp: new Date(),
      reason: comment || null,
      previousState: 'PENDING',
      newState: 'REJECTED',
      stepId: updated.id,
      templateVersionId: ver.id,
      stepOrder: updated.step_order,
    };

    return { step: updated, audit };
  }

  async getStatus(templateCode: string, version: string): Promise<ApprovalStatusDTO> {
    const ver = await this.getVersionOrThrow(templateCode, version);
    const steps = await this.approvalRepo.findByVersionId(ver.id);

    return {
      versionId: ver.id,
      templateCode,
      version,
      totalSteps: steps.length,
      approvedSteps: steps.filter(s => s.status === 'APPROVED').length,
      rejectedSteps: steps.filter(s => s.status === 'REJECTED').length,
      pendingSteps: steps.filter(s => s.status === 'PENDING').length,
      isFullyApproved: steps.length > 0 && steps.every(s => s.status === 'APPROVED'),
      steps,
    };
  }

  async isFullyApproved(templateCode: string, version: string): Promise<boolean> {
    const ver = await this.getVersionOrThrow(templateCode, version);
    return this.approvalRepo.allStepsApproved(ver.id);
  }

  async cancelApproval(
    templateCode: string,
    version: string,
    user: AuthUser,
    reason?: string,
  ): Promise<ApprovalStepRow[]> {
    const ver = await this.getVersionOrThrow(templateCode, version);

    if (!this.canCancelApproval(user, ver)) {
      throw Object.assign(new Error('Not authorized to cancel approval workflow'), { status: 403 });
    }

    return this.approvalRepo.cancelPendingSteps(ver.id, user.id, reason);
  }

  private async getVersionOrThrow(templateCode: string, version: string): Promise<VersionData> {
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
