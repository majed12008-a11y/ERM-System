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

// ================================================================
// Template Engine — database row types (templates schema)
// ================================================================

export interface TemplateCategoryRow {
  id: number;
  code: string;
  name_ar: string;
  name_en: string;
  description: string | null;
  parent_category_id: number | null;
  required_variables: any;
  default_output_format: string;
  approval_required: boolean;
  sort_order: number;
  is_active: boolean;
  created_at: Date;
  created_by: number | null;
  updated_at: Date | null;
  updated_by: number | null;
  deleted_at: Date | null;
  deleted_by: number | null;
}

export interface TemplateRow {
  id: number;
  category_id: number;
  code: string;
  name_ar: string;
  name_en: string;
  description: string | null;
  engine: string;
  default_locale: string;
  default_output_format: string | null;
  variable_sources: any;
  tags: string[];
  usage_count: number;
  is_active: boolean;
  created_at: Date;
  created_by: number | null;
  updated_at: Date | null;
  updated_by: number | null;
  deleted_at: Date | null;
  deleted_by: number | null;
}

export interface TemplateVersionRow {
  id: number;
  template_id: number;
  version: string;
  status: 'DRAFT' | 'REVIEW' | 'APPROVED' | 'DEPRECATED' | 'ARCHIVED';
  content: any;
  content_hash: string;
  variable_definitions: any;
  change_summary: string | null;
  effective_from: Date | null;
  effective_until: Date | null;
  retired_at: Date | null;
  approved_by: number | null;
  approved_at: Date | null;
  created_by: number;
  created_at: Date;
}

export interface TemplateLocalizationRow {
  id: number;
  template_version_id: number;
  locale: string;
  content: any;
  content_hash: string;
  is_verified: boolean;
  verified_by: number | null;
  verified_at: Date | null;
  created_at: Date;
}

export interface TemplateVariableRow {
  id: number;
  code: string;
  name_ar: string;
  name_en: string;
  type: 'string' | 'number' | 'date' | 'boolean' | 'array' | 'object' | 'enum';
  enum_values: any;
  source_type: 'manual' | 'entity' | 'computed' | 'context';
  resolver_path: string | null;
  resolver_function: string | null;
  resolver_function_args: any;
  entity_whitelist_root: string | null;
  default_value: any;
  description_ar: string;
  description_en: string;
  required: boolean;
  validation_rules: any;
  is_active: boolean;
  created_at: Date;
  created_by: number | null;
  updated_at: Date | null;
  updated_by: number | null;
  deleted_at: Date | null;
  deleted_by: number | null;
}

export interface TemplatePartialRow {
  id: number;
  template_id: number | null;
  code: string;
  name_ar: string;
  name_en: string;
  engine: string;
  content: string;
  content_hash: string;
  version: string;
  depends_on: string[];
  is_active: boolean;
  created_at: Date;
  created_by: number | null;
  updated_at: Date | null;
  updated_by: number | null;
  deleted_at: Date | null;
  deleted_by: number | null;
}

export interface TemplateOutputRow {
  id: number;
  template_version_id: number;
  locale: string;
  output_format: string;
  entity_type: string;
  entity_id: number;
  storage_path: string;
  file_name: string;
  file_size_bytes: number | null;
  checksum_sha256: string;
  variables_hash: string;
  rendered_html_hash: string | null;
  digital_signature_ref: string | null;
  generated_by: number;
  generated_at: Date;
  generation_duration_ms: number | null;
  status: 'SUCCESS' | 'FAILED' | 'PARTIAL';
  error_message: string | null;
}

export interface TemplateRenderJobRow {
  id: number;
  template_version_id: number;
  locale: string;
  output_format: string;
  entity_type: string;
  entity_id: number;
  variables: any;
  priority: number;
  status: 'QUEUED' | 'PROCESSING' | 'COMPLETED' | 'FAILED';
  output_id: number | null;
  error_message: string | null;
  queued_at: Date;
  started_at: Date | null;
  completed_at: Date | null;
  created_by: number;
}

export interface TemplateRenderHistoryRow {
  id: number;
  template_version_id: number;
  template_code: string;
  version: string;
  locale: string;
  output_format: string;
  entity_type: string;
  entity_id: number;
  generated_by: number;
  generated_at: Date;
  variables_hash: string;
  rendered_html_hash: string | null;
  output_id: number;
  storage_path: string;
  checksum_sha256: string;
  duration_ms: number | null;
  status: string;
}

export interface EventTemplateMappingRow {
  id: number;
  event_type: string;
  template_code: string;
  locale: string;
  output_format: string;
  is_active: boolean;
  created_at: Date;
  created_by: number | null;
  updated_at: Date | null;
  updated_by: number | null;
}
