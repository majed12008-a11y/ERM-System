import { AuditableRepository } from './auditable.repository';

export class SafetyRepository extends AuditableRepository {
  // Risk Register
  async getRiskRegister(userId: number | null, userRoles: string[]): Promise<any[]> {
    const isAdmin = userRoles.some(r => ['SUPER_ADMIN','SYS_ADMIN','ADMIN','ETHICS_ADMIN'].includes(r));
    const where = !isAdmin && userId ? 'WHERE rr.owner_id = $1' : '';
    const params = !isAdmin && userId ? [userId] : [];
    const result = await this.query(
      `SELECT rr.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as owner_name
       FROM safety.risk_register rr
       LEFT JOIN security.users u ON rr.owner_id = u.id
       ${where} ORDER BY rr.risk_score DESC`,
      params
    );
    return result.rows;
  }

  async createRisk(data: any, userId: number): Promise<any> {
    const meta = this.createMeta();
    const { risk_code, risk_title, risk_description, likelihood, impact, risk_level, owner_id, status } = data;
    const result = await this.query(
      `INSERT INTO safety.risk_register
        (risk_code, risk_title, risk_description, likelihood, impact, risk_level, owner_id, status, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, COALESCE($6, CASE WHEN $4 * $5 >= 9 THEN 'HIGH' WHEN $4 * $5 >= 4 THEN 'MEDIUM' ELSE 'LOW' END), $7, COALESCE($8, 'IDENTIFIED'), $9, $10)
       RETURNING *`,
      [risk_code, risk_title, risk_description, likelihood, impact, risk_level, owner_id, status, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async updateRisk(id: number, data: any): Promise<any | null> {
    const meta = this.updateMeta();
    const { risk_title, risk_description, likelihood, impact, risk_level, owner_id, status } = data;
    const result = await this.query(
      `UPDATE safety.risk_register SET
        risk_title = COALESCE($1, risk_title),
        risk_description = COALESCE($2, risk_description),
        likelihood = COALESCE($3, likelihood),
        impact = COALESCE($4, impact),
        risk_level = COALESCE($5, CASE WHEN COALESCE($3, likelihood) * COALESCE($4, impact) >= 9 THEN 'HIGH' WHEN COALESCE($3, likelihood) * COALESCE($4, impact) >= 4 THEN 'MEDIUM' ELSE 'LOW' END),
        owner_id = COALESCE($6, owner_id),
        status = COALESCE($7, status),
        updated_at = $8, updated_by = $9
       WHERE id = $10 RETURNING *`,
      [risk_title, risk_description, likelihood, impact, risk_level, owner_id, status, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async softDeleteRisk(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE safety.risk_register SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  // Mitigations
  async getMitigations(riskId: number): Promise<any[]> {
    const result = await this.query(
      'SELECT * FROM safety.risk_mitigations WHERE risk_id = $1 ORDER BY created_at DESC',
      [riskId]
    );
    return result.rows;
  }

  async createMitigation(riskId: number, data: any): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO safety.risk_mitigations (risk_id, mitigation_plan, responsible_party, target_date, status, created_by, created_at)
       VALUES ($1, $2, $3, $4, COALESCE($5, 'PLANNED'), $6, $7) RETURNING *`,
      [riskId, data.mitigation_plan, data.responsible_party, data.target_date, data.status, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  // Incidents
  async getIncidents(): Promise<any[]> {
    const result = await this.query(
      `SELECT ri.*, rr.risk_title, rr.risk_code, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as reported_by_name
       FROM safety.risk_incidents ri
       JOIN safety.risk_register rr ON ri.risk_id = rr.id
       LEFT JOIN security.users u ON ri.reported_by = u.id
       ORDER BY ri.incident_date DESC`
    );
    return result.rows;
  }

  async createIncident(data: any, userId: number): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO safety.risk_incidents
        (risk_id, incident_code, incident_date, description, severity, root_cause, reported_by, status, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, COALESCE($8, 'OPEN'), $9, $10) RETURNING *`,
      [data.risk_id, data.incident_code, data.incident_date, data.description, data.severity, data.root_cause, userId, data.status, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  // Corrective Actions
  async getCorrectiveActions(): Promise<any[]> {
    const result = await this.query(
      `SELECT ca.*, ri.description as incident_description
       FROM safety.corrective_actions ca
       LEFT JOIN safety.risk_incidents ri ON ca.incident_id = ri.id
       ORDER BY ca.created_at DESC`
    );
    return result.rows;
  }

  async createCorrectiveAction(data: any): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO safety.corrective_actions
        (incident_id, action_code, description, assigned_to, priority, due_date, status, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, 'OPEN', $7, $8) RETURNING *`,
      [data.incident_id, data.action_code, data.description, data.assigned_to, data.priority, data.due_date, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  // Adverse Events
  async getAdverseEvents(userId: number | null, userRoles: string[]): Promise<any[]> {
    const isAdmin = userRoles.some(r => ['SUPER_ADMIN','SYS_ADMIN','ADMIN','ETHICS_ADMIN'].includes(r));
    let whereClause = '';
    const params: any[] = [];
    if (!isAdmin && userId) {
      whereClause = 'WHERE ae.reported_by = $1';
      params.push(userId);
    }
    const result = await this.query(
      `SELECT ae.*, a.application_number, p.title_ar as project_title
       FROM safety.adverse_events ae
       JOIN core.applications a ON ae.application_id = a.id
       JOIN core.projects p ON a.project_id = p.id
       ${whereClause}
       ORDER BY ae.created_at DESC`,
      params
    );
    return result.rows;
  }

  async getSeriousAdverseEvents(): Promise<any[]> {
    const result = await this.query(
      `SELECT sae.*, a.application_number, p.title_ar as project_title
       FROM safety.serious_adverse_events sae
       JOIN core.applications a ON sae.application_id = a.id
       JOIN core.projects p ON a.project_id = p.id
       ORDER BY sae.created_at DESC`
    );
    return result.rows;
  }

  async getSafetyReports(): Promise<any[]> {
    const result = await this.query(
      `SELECT sr.*, a.application_number
       FROM safety.safety_reports sr
       JOIN core.applications a ON sr.application_id = a.id
       ORDER BY sr.created_at DESC`
    );
    return result.rows;
  }
}
