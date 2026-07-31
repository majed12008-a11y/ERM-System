import { AuditableRepository } from '../../repositories/auditable.repository';

export class EntityDataRepository extends AuditableRepository {

  async findApplicationBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT a.id, a.application_number, a.project_id, a.application_type,
              a.submitted_by, a.target_committee_id, a.current_status, a.created_at,
              p.title_ar AS project_title, p.project_code,
              c.committee_name_ar, c.committee_name_en,
              u.username AS submitted_by_username,
              ws.state_name AS status_name_ar
       FROM core.applications a
       LEFT JOIN core.projects p ON p.id = a.project_id AND p.deleted_at IS NULL
       LEFT JOIN committee.committees c ON c.id = a.target_committee_id AND c.deleted_at IS NULL
       LEFT JOIN security.users u ON u.id = a.submitted_by
       LEFT JOIN workflow.workflow_instances wi ON wi.entity_type = 'Application' AND wi.entity_id = a.id AND wi.deleted_at IS NULL
       LEFT JOIN workflow.workflow_states ws ON ws.id = wi.current_state_id
       WHERE a.id = ANY($1) AND a.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findConditionBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT ac.id, ac.application_id, ac.condition_text, ac.severity,
              ac.category, ac.status, ac.due_date, ac.resolved_by, ac.resolved_at
       FROM committee.application_conditions ac
       WHERE ac.id = ANY($1) AND ac.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findUserBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT u.id, u.uuid, u.username, u.email,
              u.first_name_ar, u.last_name_ar, u.first_name_en, u.last_name_en,
              u.institution_id, u.status,
              ir.name_ar AS institution_name_ar,
              array_agg(DISTINCT r.code) FILTER (WHERE r.code IS NOT NULL) AS roles
       FROM security.users u
       LEFT JOIN reference.institutions_registry ir ON ir.id = u.institution_id
       LEFT JOIN security.user_roles ur ON ur.user_id = u.id
       LEFT JOIN security.roles r ON r.id = ur.role_id AND r.is_active = true
       WHERE u.id = ANY($1)
       GROUP BY u.id, ir.name_ar`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findCommitteeBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT c.id, c.committee_code, c.committee_name_ar, c.committee_name_en,
              c.committee_type_id, c.institution_id, c.is_active,
              ct.type_code AS committee_type
       FROM committee.committees c
       LEFT JOIN committee.committee_types ct ON ct.id = c.committee_type_id
       WHERE c.id = ANY($1) AND c.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findInstitutionBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT ir.id, ir.name_ar, ir.name_en, ir.national_id AS code,
              ir.city, ir.country, ir.is_active
       FROM reference.institutions_registry ir
       WHERE ir.id = ANY($1)`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findNotificationBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT n.id, n.user_id, n.notification_type, n.subject,
              n.message_body, n.priority_level, n.created_at
       FROM communication.notifications n
       WHERE n.id = ANY($1) AND n.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findMeetingBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT cm.id, cm.committee_id, cm.meeting_date,
              cm.meeting_number AS meeting_type,
              cm.meeting_status AS status,
              cm.location,
              c.committee_name_ar
       FROM committee.committee_meetings cm
       LEFT JOIN committee.committees c ON c.id = cm.committee_id AND c.deleted_at IS NULL
       WHERE cm.id = ANY($1) AND cm.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findReviewBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT ra.id, ra.application_id, ra.reviewer_id,
              COALESCE(u.first_name_ar || ' ' || u.last_name_ar, u.username) AS reviewer_name,
              rr.recommendation_type AS decision,
              rr.justification AS comments,
              ra.assigned_at AS submitted_at
       FROM committee.review_assignments ra
       LEFT JOIN security.users u ON u.id = ra.reviewer_id
       LEFT JOIN committee.review_recommendations rr
         ON rr.application_id = ra.application_id AND rr.reviewer_id = ra.reviewer_id AND rr.deleted_at IS NULL
       WHERE ra.id = ANY($1) AND ra.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findDocumentBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT d.id, d.file_name, d.mime_type AS file_type, d.file_size_bytes,
              d.entity_type, d.entity_id, d.uploaded_by, d.created_at,
              u.username AS uploaded_by_username
       FROM documents.documents d
       LEFT JOIN security.users u ON u.id = d.uploaded_by
       WHERE d.id = ANY($1) AND d.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findReportBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT re.id, rd.report_code AS report_type,
              'Report' AS entity_type, re.report_id AS entity_id,
              re.executed_by AS generated_by,
              re.execution_start AS generated_at,
              re.execution_status AS status
       FROM reporting.report_executions re
       LEFT JOIN reporting.report_definitions rd ON rd.id = re.report_id
       WHERE re.id = ANY($1)`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findCommunicationBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT m.id, m.related_entity_type AS communication_type,
              m.subject, m.message_body AS body,
              m.sender_id, mr.recipient_id, m.created_at AS sent_at
       FROM communication.messages m
       LEFT JOIN communication.message_recipients mr ON mr.message_id = m.id
       WHERE m.id = ANY($1) AND m.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }

  async findSafetyReportBatch(ids: number[]): Promise<Map<number, any>> {
    if (ids.length === 0) return new Map();
    const result = await this.query(
      `SELECT ae.id, ae.application_id, ae.event_type AS report_type,
              ae.severity, ae.description,
              ae.reported_by, ae.reported_at, ae.outcome_status AS status
       FROM safety.adverse_events ae
       WHERE ae.id = ANY($1) AND ae.deleted_at IS NULL`,
      [ids]
    );
    return new Map(result.rows.map((r: any) => [Number(r.id), r]));
  }
}
