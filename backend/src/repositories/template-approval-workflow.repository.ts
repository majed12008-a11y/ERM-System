import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';

export interface ApprovalStepRow {
  id: number;
  template_version_id: number;
  step_order: number;
  approver_role: string;
  approver_id: number | null;
  status: 'PENDING' | 'APPROVED' | 'REJECTED';
  comments: string | null;
  acted_by: number | null;
  acted_at: Date | null;
  created_at: Date;
}

export interface CreateApprovalStepInput {
  template_version_id: number;
  step_order: number;
  approver_role: string;
  approver_id?: number | null;
}

export class TemplateApprovalWorkflowRepository extends AuditableRepository {
  async createSteps(steps: CreateApprovalStepInput[], client?: PoolClient): Promise<ApprovalStepRow[]> {
    if (steps.length === 0) return [];
    const values: any[] = [];
    const placeholders: string[] = [];
    let idx = 1;

    for (const step of steps) {
      placeholders.push(`($${idx++}, $${idx++}, $${idx++}, $${idx++})`);
      values.push(step.template_version_id, step.step_order, step.approver_role, step.approver_id ?? null);
    }

    const result = await this.query(
      `INSERT INTO templates.template_approval_workflow
        (template_version_id, step_order, approver_role, approver_id)
       VALUES ${placeholders.join(', ')}
       RETURNING *`,
      values,
      client,
    );
    return result.rows;
  }

  async findByVersionId(versionId: number): Promise<ApprovalStepRow[]> {
    const result = await this.query(
      `SELECT * FROM templates.template_approval_workflow
       WHERE template_version_id = $1
       ORDER BY step_order ASC`,
      [versionId],
    );
    return result.rows;
  }

  async findById(id: number): Promise<ApprovalStepRow | null> {
    const result = await this.query(
      `SELECT * FROM templates.template_approval_workflow WHERE id = $1`,
      [id],
    );
    return result.rows[0] || null;
  }

  async approveStep(id: number, userId: number, comments?: string, client?: PoolClient): Promise<ApprovalStepRow> {
    const result = await this.query(
      `UPDATE templates.template_approval_workflow
       SET status = 'APPROVED', acted_by = $1, acted_at = NOW(), comments = COALESCE($2, comments)
       WHERE id = $3 AND status = 'PENDING'
       RETURNING *`,
      [userId, comments || null, id],
      client,
    );
    if (!result.rows[0]) throw Object.assign(new Error('Approval step not found or already acted upon'), { status: 404 });
    return result.rows[0];
  }

  async rejectStep(id: number, userId: number, comments?: string, client?: PoolClient): Promise<ApprovalStepRow> {
    const result = await this.query(
      `UPDATE templates.template_approval_workflow
       SET status = 'REJECTED', acted_by = $1, acted_at = NOW(), comments = COALESCE($2, comments)
       WHERE id = $3 AND status = 'PENDING'
       RETURNING *`,
      [userId, comments || null, id],
      client,
    );
    if (!result.rows[0]) throw Object.assign(new Error('Approval step not found or already acted upon'), { status: 404 });
    return result.rows[0];
  }

  async countPendingSteps(versionId: number): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(*) as count FROM templates.template_approval_workflow
       WHERE template_version_id = $1 AND status = 'PENDING'`,
      [versionId],
    );
    return parseInt(result.rows[0].count, 10);
  }

  async countRejectedSteps(versionId: number): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(*) as count FROM templates.template_approval_workflow
       WHERE template_version_id = $1 AND status = 'REJECTED'`,
      [versionId],
    );
    return parseInt(result.rows[0].count, 10);
  }

  async allStepsApproved(versionId: number): Promise<boolean> {
    const result = await this.query(
      `SELECT COUNT(*) as total,
              COUNT(*) FILTER (WHERE status = 'APPROVED') as approved
       FROM templates.template_approval_workflow
       WHERE template_version_id = $1`,
      [versionId],
    );
    const row = result.rows[0];
    return parseInt(row.total, 10) > 0 && parseInt(row.total, 10) === parseInt(row.approved, 10);
  }

  async cancelPendingSteps(versionId: number, userId: number, reason?: string, client?: PoolClient): Promise<ApprovalStepRow[]> {
    const result = await this.query(
      `UPDATE templates.template_approval_workflow
       SET status = 'REJECTED', acted_by = $1, acted_at = NOW(),
           comments = COALESCE($2, 'Cancelled')
       WHERE template_version_id = $3 AND status = 'PENDING'
       RETURNING *`,
      [userId, reason || null, versionId],
      client,
    );
    return result.rows;
  }
}
