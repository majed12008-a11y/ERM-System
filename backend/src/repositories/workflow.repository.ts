/*
 * مستودع سير العمل (Workflow): إنشاء حالات workflow،
 * تنفيذ المهام، متابعة التقدم. يربط بين تعريفات
 * Workflow والكيانات (الطلبات والمشاريع).
 */
import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';

export class WorkflowRepository extends AuditableRepository {
  async initWorkflow(workflowCode: string, entityType: string, entityId: number, client?: PoolClient): Promise<void> {
    await this.query("SELECT system.fn_init_workflow($1, $2, $3)", [workflowCode, entityType, entityId], client);
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

  async findInstance(entityType: string, entityId: number, client?: PoolClient): Promise<any | null> {
    const result = await this.query(
      `SELECT wi.id as instance_id, wi.current_state_id, s.state_code as current_state_code, wi.workflow_id
       FROM workflow.workflow_instances wi
       JOIN workflow.workflow_states s ON wi.current_state_id = s.id
       WHERE wi.entity_type = $1 AND wi.entity_id = $2 AND wi.status_code = 'ACTIVE'
       FOR UPDATE`,
      [entityType, entityId],
      client
    );
    return result.rows[0] || null;
  }

  async getEntityOwnerId(entityType: string, entityId: number, client?: PoolClient): Promise<number> {
    if (entityType === 'Application') {
      const result = await this.query(
        `SELECT submitted_by FROM core.applications WHERE id = $1`,
        [entityId],
        client
      );
      if (!result.rows[0]) {
        throw Object.assign(new Error(`Entity not found: ${entityType} #${entityId}`), { status: 404 });
      }
      return result.rows[0].submitted_by;
    }
    throw Object.assign(
      new Error(`Cannot determine owner for unknown entity type '${entityType}'`),
      { status: 500 }
    );
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
      `SELECT t.*, ts.state_code as to_state_code, ts.is_terminal as to_state_is_terminal
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

  /**
   * يفحص حالة SLA للحالة الحالية:
   * هل تجاوز الوقت المسموح به منذ آخر انتقال؟
   * يُعيد { within_sla, sla_duration, elapsed, overdue_by } أو null إذا لا يوجد SLA.
   */
  async getSLAStatus(entityType: string, entityId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT
         s.state_code,
         s.state_name,
         sla.sla_duration,
         sla.escalation_action,
         wh.action_date         AS entered_at,
         NOW() - wh.action_date AS elapsed,
         CASE
           WHEN NOW() - wh.action_date > sla.sla_duration THEN FALSE
           ELSE TRUE
         END                    AS within_sla,
         CASE
           WHEN NOW() - wh.action_date > sla.sla_duration
             THEN (NOW() - wh.action_date) - sla.sla_duration
           ELSE NULL
         END                    AS overdue_by
       FROM workflow.workflow_instances wi
       JOIN workflow.workflow_states s   ON wi.current_state_id = s.id
       LEFT JOIN workflow.workflow_sla sla ON sla.state_id = wi.current_state_id
       LEFT JOIN workflow.workflow_history wh
              ON wh.workflow_instance_id = wi.id
             AND wh.to_state_id = wi.current_state_id
             AND wh.action_date = (
               SELECT MAX(action_date)
                 FROM workflow.workflow_history
                WHERE workflow_instance_id = wi.id
                  AND to_state_id = wi.current_state_id
             )
       WHERE wi.entity_type = $1
         AND wi.entity_id   = $2
         AND wi.status_code = 'ACTIVE'`,
      [entityType, entityId]
    );
    return result.rows[0] || null;
  }

  /**
   * يُعيد التاريخ الكامل لانتقالات Workflow لكيان معين
   * مرتباً من الأحدث للأقدم.
   */
  async getWorkflowHistory(entityType: string, entityId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT
         wh.id,
         fs.state_code  AS from_state,
         fs.state_name  AS from_state_name,
         ts.state_code  AS to_state,
         ts.state_name  AS to_state_name,
         wt.transition_code,
         wt.transition_name,
         wh.comments,
         wh.action_by,
          COALESCE(NULLIF(CONCAT(u.first_name_en, ' ', u.last_name_en), ' '), u.username) AS action_by_name,
         wh.action_date
       FROM workflow.workflow_history wh
       JOIN workflow.workflow_instances wi ON wh.workflow_instance_id = wi.id
       JOIN workflow.workflow_states fs    ON wh.from_state_id = fs.id
       JOIN workflow.workflow_states ts    ON wh.to_state_id   = ts.id
       JOIN workflow.workflow_transitions wt ON wh.transition_id = wt.id
       LEFT JOIN security.users u          ON wh.action_by = u.id
       WHERE wi.entity_type = $1
         AND wi.entity_id   = $2
       ORDER BY wh.action_date DESC`,
      [entityType, entityId]
    );
    return result.rows;
  }
}
