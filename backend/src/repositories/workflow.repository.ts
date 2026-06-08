import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';

export class WorkflowRepository extends AuditableRepository {
  async initWorkflow(workflowCode: string, entityType: string, entityId: number, client?: PoolClient): Promise<void> {
    await this.query("SELECT system.fn_init_workflow($1, $2, $3)", [workflowCode, entityType, entityId], client);
  }

  async autoTransition(entityType: string, entityId: number, userId: number, client?: PoolClient): Promise<void> {
    await this.query("SELECT system.fn_auto_transition($1, $2, $3)", [entityType, entityId, userId], client);
  }

  async getDefinitions(): Promise<any[]> {
    const result = await this.query(
      `SELECT w.*,
              (SELECT json_agg(json_build_object('state_code', s.state_code, 'state_name', s.state_name, 'is_initial', s.is_initial, 'is_terminal', s.is_terminal) ORDER BY s.display_order) FROM workflow.workflow_states s WHERE s.workflow_id = w.id) as states,
              (SELECT json_agg(json_build_object('transition_code', t.transition_code, 'transition_name', t.transition_name)) FROM workflow.workflow_transitions t WHERE t.workflow_id = w.id) as transitions
       FROM workflow.workflows w WHERE w.is_active = TRUE`
    );
    return result.rows;
  }

  async findInstance(entityType: string, entityId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT wi.id as instance_id, wi.current_state_id, s.state_code as current_state_code, wi.workflow_id
       FROM workflow.workflow_instances wi
       JOIN workflow.workflow_states s ON wi.current_state_id = s.id
       WHERE wi.entity_type = $1 AND wi.entity_id = $2 AND wi.status_code = 'ACTIVE'`,
      [entityType, entityId]
    );
    return result.rows[0] || null;
  }

  async getInstanceDetail(entityType: string, entityId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT wi.*, w.workflow_name, s.state_name as current_state_name
       FROM workflow.workflow_instances wi
       JOIN workflow.workflows w ON wi.workflow_id = w.id
       JOIN workflow.workflow_states s ON wi.current_state_id = s.id
       WHERE wi.entity_type = $1 AND wi.entity_id = $2 AND wi.status_code = 'ACTIVE'`,
      [entityType, entityId]
    );
    return result.rows[0] || null;
  }

  async findTransition(transitionCode: string, fromStateId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT t.*, ts.state_code as to_state_code
       FROM workflow.workflow_transitions t
       JOIN workflow.workflow_states ts ON t.to_state_id = ts.id
       WHERE t.transition_code = $1 AND t.from_state_id = $2`,
      [transitionCode, fromStateId]
    );
    return result.rows[0] || null;
  }

  async getAvailableTransitions(stateId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT t.id, t.transition_code, t.transition_name, t.requires_comment, t.allowed_roles,
              ts.state_code as to_state_code, ts.state_name as to_state_name
       FROM workflow.workflow_transitions t
       JOIN workflow.workflow_states ts ON t.to_state_id = ts.id
       WHERE t.from_state_id = $1`,
      [stateId]
    );
    return result.rows;
  }

  async createAction(instanceId: number, transitionId: number, userId: number, comment?: string, client?: PoolClient): Promise<void> {
    await this.query(
      `INSERT INTO workflow.workflow_actions (workflow_instance_id, transition_id, action_by, action_comment)
       VALUES ($1, $2, $3, $4)`,
      [instanceId, transitionId, userId, comment || null],
      client
    );
  }

  async createHistory(instanceId: number, fromStateId: number, toStateId: number,
                       transitionId: number, userId: number, comments?: string, client?: PoolClient): Promise<void> {
    await this.query(
      `INSERT INTO workflow.workflow_history
        (workflow_instance_id, from_state_id, to_state_id, transition_id, action_by, comments)
       VALUES ($1, $2, $3, $4, $5, $6)`,
      [instanceId, fromStateId, toStateId, transitionId, userId, comments || null],
      client
    );
  }

  async updateInstanceState(instanceId: number, toStateId: number, client?: PoolClient): Promise<void> {
    await this.query(
      `UPDATE workflow.workflow_instances SET current_state_id = $1 WHERE id = $2`,
      [toStateId, instanceId],
      client
    );
  }

  async completeInstance(instanceId: number, client?: PoolClient): Promise<void> {
    await this.query(
      `UPDATE workflow.workflow_instances SET completed_at = now(), status_code = 'COMPLETED' WHERE id = $1`,
      [instanceId],
      client
    );
  }
}
