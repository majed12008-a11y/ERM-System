/*
 * إدارة سير العمل (Workflow): إنشاء حالات Workflow،
 * تنفيذ المهام، متابعة الحالة. يربط بين تعريفات
 * workflow والطلبات والمشاريع.
 */
import { PoolClient } from 'pg';
import { WorkflowRepository } from '../repositories/workflow.repository';
import { AuthUser } from '../shared/types';
import { withTransaction } from '../config/database';

export class WorkflowService {
  private repo = new WorkflowRepository();

  async getDefinitions() { return this.repo.getDefinitions(); }
  async initWorkflow(workflowCode: string, entityType: string, entityId: number, client?: PoolClient) {
    return this.repo.initWorkflow(workflowCode, entityType, entityId, client);
  }
  async autoTransition(entityType: string, entityId: number, userId: number, client?: PoolClient) {
    return this.repo.autoTransition(entityType, entityId, userId, client);
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
    comment?: string
  ) {
    const instance = await this.repo.findInstance(entityType, parseInt(String(entityId)));
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

    if (transition.requires_comment && !comment) {
      throw Object.assign(new Error('Comment required for this transition'), { status: 400 });
    }

    await withTransaction(async (client) => {
      await this.repo.createAction(instance.instance_id, transition.id, user.id, comment, client);
      await this.repo.createHistory(instance.instance_id, instance.current_state_id, transition.to_state_id, transition.id, user.id, comment, client);
      await this.repo.updateInstanceState(instance.instance_id, transition.to_state_id, client);

      if (['APPROVED', 'REJECTED'].includes(transition.to_state_code)) {
        await this.repo.completeInstance(instance.instance_id, client);
      }
    });

    return {
      transition_code: transition.transition_code,
      from_state: instance.current_state_code,
      to_state: transition.to_state_code,
      requires_comment: transition.requires_comment,
    };
  }
}
