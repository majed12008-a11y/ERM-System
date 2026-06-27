/*
 * تعريفات أنواع قاعدة البيانات: تطابق بنية جداول
 * الطلبات والمشاريع في قاعدة البيانات.
 */
export interface ApplicationRow {
  id: number;
  application_number: string;
  project_id: number;
  application_type: string;
  submitted_by: number;
  target_committee_id: number;
  current_status: string;
  created_at: Date;
  created_by: number | null;
  updated_at: Date | null;
  updated_by: number | null;
  deleted_at: Date | null;
  deleted_by: number | null;
  project_title?: string;
  project_code?: string;
  submitted_by_username?: string;
  status_name_ar?: string;
}

export interface ProjectRow {
  id: number;
  institution_id: number;
  project_code: string;
  title_ar: string;
  title_en: string | null;
  abstract_ar: string | null;
  abstract_en: string | null;
  objectives: string;
  principal_investigator_id: number;
  research_category: string | null;
  risk_level: string | null;
  start_date: Date | null;
  expected_end_date: Date | null;
  created_at: Date;
  created_by: number | null;
  updated_at: Date | null;
  updated_by: number | null;
  deleted_at: Date | null;
  deleted_by: number | null;
}

export interface WorkflowInstanceRow {
  id: number;
  entity_type: string;
  entity_id: number;
  current_state_id: number;
  status_code: string;
  created_at: Date;
}

export interface WorkflowTransitionRow {
  id: number;
  transition_code: string;
  from_state_id: number;
  to_state_id: number;
  allowed_roles: string | null;
  requires_comment: boolean;
  to_state_code: string;
}

export interface NotificationRow {
  id: number;
  user_id: number;
  notification_type: string;
  subject: string;
  message_body: string;
  priority_level: string;
  created_at: Date;
}
