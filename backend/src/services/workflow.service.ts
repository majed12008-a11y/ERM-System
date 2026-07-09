/*
 * إدارة سير العمل (Workflow): إنشاء حالات Workflow،
 * تنفيذ المهام، متابعة الحالة. يربط بين تعريفات
 * workflow والطلبات والمشاريع.
 */
import { PoolClient } from 'pg';
import { WorkflowRepository } from '../repositories/workflow.repository';
import { AuthUser } from '../shared/types';
import { withTransaction } from '../config/database';
import { logger } from '../config/logger';
import {
  workflowTransitionsTotal,
  workflowTransitionDurationSeconds,
  workflowTransitionFailuresTotal,
} from './metrics.service';
import { WorkflowAuthorizationPolicy } from './workflow-authorization.policy';

function categorizeTransitionError(err: any): string {
  const msg: string = err.message || '';
  const status: number = err.status || 500;
  if (status === 400) {
    if (msg.includes('No active workflow instance')) return 'no_instance';
    if (msg.includes('Invalid transition')) return 'invalid_transition';
    if (msg.includes('Comment required')) return 'validation_failed';
    return 'validation_failed';
  }
  if (status === 403) return 'unauthorized';
  return 'internal_error';
}

export class WorkflowService {
  private repo = new WorkflowRepository();
  private policy = new WorkflowAuthorizationPolicy();

  async getDefinitions() { return this.repo.getDefinitions(); }
  async initWorkflow(workflowCode: string, entityType: string, entityId: number, client?: PoolClient) {
    return this.repo.initWorkflow(workflowCode, entityType, entityId, client);
  }
  async getInstance(entityType: string, entityId: number) {
    const instance = await this.repo.getInstanceDetail(entityType, parseInt(String(entityId)));
    if (!instance) return null;
    return instance;
  }

  async getAvailableTransitions(entityType: string, entityId: number, user: AuthUser) {
    const instance = await this.repo.findInstance(entityType, parseInt(String(entityId)));
    if (!instance) return { current_state: null, transitions: [] };

    const all = await this.repo.getAvailableTransitions(instance.current_state_id);
    const allowed = all.filter((t: any) => {
      if (!t.allowed_roles) return true;
      const roles = t.allowed_roles.split(',').map((r: string) => r.trim());
      return user.roles?.some((r: string) => roles.includes(r));
    });

    return { current_state: instance.current_state_code, transitions: allowed };
  }

  async executeTransition(
    entityType: string,
    entityId: number,
    transitionCode: string,
    user: AuthUser,
    comment?: string,
    client?: PoolClient
  ) {
    const numericEntityId = parseInt(String(entityId));
    const workflowLabel = entityType;
    const transitionLabel = transitionCode;
    const start = process.hrtime.bigint();

    const doTransition = async (txClient: PoolClient) => {
      const instance = await this.repo.findInstance(entityType, numericEntityId, txClient);
      if (!instance) {
        throw Object.assign(new Error('No active workflow instance'), { status: 400 });
      }

      const transition = await this.repo.findTransition(transitionCode, instance.current_state_id);
      if (!transition) {
        throw Object.assign(new Error('Invalid transition for current state'), { status: 400 });
      }

      if (transition.allowed_roles) {
        const roles = transition.allowed_roles.split(',').map((r: string) => r.trim());
        if (!user.roles?.some((r: string) => roles.includes(r))) {
          throw Object.assign(new Error('Not authorized for this transition'), { status: 403 });
        }
      }

      if (this.policy.requiresOwnership(entityType, transition) && !this.policy.canBypassOwnership(user)) {
        const ownerId = await this.repo.getEntityOwnerId(entityType, numericEntityId, txClient);
        if (ownerId !== user.id) {
          throw Object.assign(new Error('Only the entity owner can perform this action'), { status: 403 });
        }
      }

      if (transition.requires_comment && !comment) {
        throw Object.assign(new Error('Comment required for this transition'), { status: 400 });
      }

      await this.repo.createAction(instance.instance_id, transition.id, user.id, comment, txClient);
      await this.repo.createHistory(instance.instance_id, instance.current_state_id, transition.to_state_id, transition.id, user.id, comment, txClient);
      await this.repo.updateInstanceState(instance.instance_id, transition.to_state_id, txClient);
      if (transition.to_state_is_terminal) {
        await this.repo.completeInstance(instance.instance_id, txClient);
      }

      return {
        transition_code: transition.transition_code,
        from_state: instance.current_state_code,
        to_state: transition.to_state_code,
        requires_comment: transition.requires_comment,
      };
    };

    try {
      const result = client ? await doTransition(client) : await withTransaction(doTransition);
      const durationSeconds = Number(process.hrtime.bigint() - start) / 1e9;

      logger.info({
        entityType, entityId: numericEntityId, transitionCode,
        fromState: result.from_state, toState: result.to_state,
        userId: user.id, durationSeconds,
      }, 'Workflow transition executed');

      workflowTransitionsTotal.inc({ workflow: workflowLabel, transition: transitionLabel, result: 'success' });
      workflowTransitionDurationSeconds.observe({ workflow: workflowLabel, transition: transitionLabel }, durationSeconds);

      return result;
    } catch (err: any) {
      const durationSeconds = Number(process.hrtime.bigint() - start) / 1e9;
      const reason = categorizeTransitionError(err);

      logger.error({
        err, entityType, entityId: numericEntityId, transitionCode,
        userId: user.id, durationSeconds, reason, status: err.status || 500,
      }, 'Workflow transition failed');

      workflowTransitionsTotal.inc({ workflow: workflowLabel, transition: transitionLabel, result: 'failure' });
      workflowTransitionFailuresTotal.inc({ workflow: workflowLabel, transition: transitionLabel, reason });

      throw err;
    }
  }

  async getSLAStatus(entityType: string, entityId: number) {
    return this.repo.getSLAStatus(entityType, parseInt(String(entityId)));
  }

  async getHistory(entityType: string, entityId: number) {
    return this.repo.getWorkflowHistory(entityType, parseInt(String(entityId)));
  }
}
