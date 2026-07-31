import {
  assertValidTransition,
  getTransitionAction,
  TRANSITION_MATRIX,
  LifecycleStatus,
} from '../shared/template-version-lifecycle.types';
import {
  checkLifecyclePermission,
  checkTransitionPreconditions,
  VersionData,
} from './template-version-lifecycle.service';
import { TemplateValidationService } from './template-validation.service';
import type { AuthUser } from '../shared/types';
import type { ValidationResult, ValidationItem } from '../shared/template-validation.types';
import { TEMPLATE_VALIDATION_CODES as C } from '../shared/template-validation.types';

export interface LifecycleValidationParams {
  templateCode: string;
  version: string;
  currentStatus: string;
  targetStatus: string;
  versionData: VersionData;
  user: AuthUser;
  comment?: string;
}

export interface IApprovalReadiness {
  hasApprovalSteps: boolean;
  allStepsApproved: boolean;
}

export class LifecycleValidationService {
  constructor(
    private validationService: TemplateValidationService,
  ) {}

  async validateTransition(
    params: LifecycleValidationParams,
    approvalReadiness?: IApprovalReadiness,
  ): Promise<ValidationResult> {
    const items: ValidationItem[] = [];
    const action = getTransitionAction(
      params.currentStatus as LifecycleStatus,
      params.targetStatus as LifecycleStatus,
    );

    // 1. Structural validation — only on submit (DRAFT → REVIEW)
    if (params.targetStatus === 'REVIEW' && params.currentStatus === 'DRAFT') {
      const structuralResult = await this.validationService.validateVersion({
        template_id: params.versionData.template_id,
        version: params.versionData.version,
        status: params.versionData.status,
        content: params.versionData.content,
        content_hash: params.versionData.content_hash,
        variable_definitions: params.versionData.variable_definitions,
        change_summary: params.versionData.change_summary || undefined,
        effective_from: params.versionData.effective_from?.toISOString(),
        effective_until: params.versionData.effective_until?.toISOString(),
        created_by: params.versionData.created_by,
      });
      items.push(...structuralResult.items.map(i => ({
        ...i,
        code: i.code === (C.TPL_VAL_060 as any) ? C.TPL_VAL_068 as any : i.code,
      })));
    }

    // 2. Lifecycle validation — state machine enforces transition rules
    try {
      assertValidTransition(params.currentStatus, params.targetStatus);
    } catch (e: any) {
      items.push({
        code: C.TPL_VAL_062,
        severity: 'ERROR',
        message: e.message || `Invalid transition from ${params.currentStatus} to ${params.targetStatus}`,
        affectedField: 'version.status',
        suggestedResolution: `Valid targets from ${params.currentStatus}: ${(TRANSITION_MATRIX[params.currentStatus as LifecycleStatus] || []).join(', ') || 'none (terminal)'}`,
      });
    }

    // 3. Business preconditions
    try {
      checkTransitionPreconditions(action, params.versionData, params.comment);
    } catch (e: any) {
      const code = e.message?.toLowerCase().includes('reason')
        ? C.TPL_VAL_064
        : C.TPL_VAL_064;
      items.push({
        code,
        severity: 'ERROR',
        message: e.message || 'Transition precondition failed',
        affectedField: action === 'REJECTED' ? 'transition.reason' : 'version.content',
        suggestedResolution: action === 'REJECTED'
          ? 'Provide a reason for rejection'
          : 'Ensure the version contains valid content',
      });
    }

    // 4. Authorization
    try {
      checkLifecyclePermission(action, params.versionData, params.user);
    } catch (e: any) {
      items.push({
        code: C.TPL_VAL_063,
        severity: 'ERROR',
        message: e.message || `Not authorized to perform ${action}`,
        affectedField: 'user.roles',
        suggestedResolution: 'Request admin or chair privileges for this operation',
      });
    }

    // 5. Effective dates validation
    if (params.versionData.effective_from && params.versionData.effective_until) {
      if (params.versionData.effective_until <= params.versionData.effective_from) {
        items.push({
          code: C.TPL_VAL_065,
          severity: 'ERROR',
          message: 'Effective until must be after effective from',
          affectedField: 'version.effective_until',
          suggestedResolution: 'Set effective_until to a date after effective_from',
        });
      }
    }

    // 6. Approval readiness check
    if (params.targetStatus === 'APPROVED' && approvalReadiness) {
      if (approvalReadiness.hasApprovalSteps && !approvalReadiness.allStepsApproved) {
        items.push({
          code: C.TPL_VAL_066,
          severity: 'ERROR',
          message: 'Approval workflow not complete: all steps must be APPROVED',
          affectedField: 'approval_workflow.status',
          suggestedResolution: 'Complete all pending approval steps before approving',
        });
      }
    }

    // 7. Version status check — verify version is in expected status
    if (params.versionData.status !== params.currentStatus) {
      items.push({
        code: C.TPL_VAL_067,
        severity: 'ERROR',
        message: `Version is in status "${params.versionData.status}", expected "${params.currentStatus}"`,
        affectedField: 'version.status',
        suggestedResolution: 'Refresh version data and retry the operation',
      });
    }

    return this.buildResult(items, params);
  }

  private buildResult(
    items: ValidationItem[],
    params: LifecycleValidationParams,
  ): ValidationResult {
    const errors = items.filter(i => i.severity === 'ERROR');
    const warnings = items.filter(i => i.severity === 'WARNING');
    const infos = items.filter(i => i.severity === 'INFO');
    return {
      isValid: errors.length === 0,
      items,
      errors,
      warnings,
      infos,
      templateCode: params.templateCode,
      templateVersion: params.version,
      validatedAt: new Date(),
    };
  }
}
