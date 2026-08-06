/*
 * تعريفات الأنواع المشتركة (TypeScript interfaces)
 * المستخدمة عبر النظام بأكمله (المستخدم، AuthUser، المستندات).
 */
export interface User {
  id: number;
  uuid: string;
  institution_id: number;
  username: string;
  email: string;
  status: string;
}

export interface AuthUser {
  id: number;
  uuid: string;
  institution_id: number;
  username: string;
  email: string;
  status: string;
  is_email_verified: boolean;
  roles: string[];
}

export interface AuthenticatedRequest {
  user: User & { roles: string[] };
}

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  pagination?: {
    page: number;
    limit: number;
    total: number;
  };
}

export interface ApplicationStatus {
  status_code: string;
  status_name_ar: string;
  is_terminal: boolean;
}

export interface WorkflowTransition {
  id: number;
  transition_code: string;
  transition_name: string;
  from_state: string;
  to_state: string;
}

// ── Forms Library (schema contract shared by runtime, validation, rendering) ──

export interface FormFieldLabel {
  ar: string;
  en?: string;
}

export interface FormFieldOption {
  value: string;
  label: FormFieldLabel;
}

export type ConditionalOperator = 'eq' | 'ne' | 'in' | 'empty';

export interface FieldConditional {
  field: string;
  op?: ConditionalOperator;
  /** Backward-compatible equality short-cut (equivalent to op: 'eq'). */
  equals?: unknown;
  /** Value for op: 'eq' | 'ne' | 'in'. */
  value?: unknown;
}

export interface FieldDependency {
  field: string;
  op: 'lt' | 'lte' | 'gt' | 'gte' | 'eq' | 'ne';
  /** Static comparison value. */
  value?: unknown;
  /** Compare against another field's response (takes precedence over value). */
  valueField?: string;
  message?: FormFieldLabel;
}

export interface FormField {
  name: string;
  label: FormFieldLabel;
  type: string;
  required?: boolean;
  options?: FormFieldOption[];
  min?: number;
  max?: number;
  maxLength?: number;
  pattern?: string;
  rows?: number;
  conditional?: FieldConditional;
  dependencies?: FieldDependency[];
  placeholder?: FormFieldLabel | string;
  helpText?: FormFieldLabel | string;
  unit?: string;
}

export interface FormSection {
  id: string;
  title: FormFieldLabel;
  fields: FormField[];
}

export interface FormComputed {
  type: 'mean' | 'sum' | 'count' | 'count_checked';
  fields?: string[];
}

export interface FormWorkflowConfig {
  entity_type: string;
  /** Transition code executed on submit (e.g. 'SUBMIT'). */
  transition_on_submit: string;
  /** Workflow definition code. Required when the workflow instance does not exist yet (e.g. app shell created as draft). */
  workflow_code?: string;
}

export interface FormDocumentConfig {
  template_code: string;
  document_type: string;
}

export interface FormSchema {
  formCode: string;
  version: string;
  sections: FormSection[];
  computed?: { total_score?: FormComputed };
  /** Render as a wizard (stepper/section navigation) instead of single scroll. */
  wizard?: boolean;
  /** Config-driven workflow binding executed on submit through the workflow engine. */
  workflow?: FormWorkflowConfig;
  /** Document generation override (takes precedence over CATEGORY_TEMPLATE). */
  document?: FormDocumentConfig;
}

export interface FormDefinitionRow {
  id: number;
  form_code: string;
  form_name_ar: string;
  form_name_en: string | null;
  category: string;
  workflow_stage: string | null;
  version_no: number;
  schema_version: string | null;
  form_schema: FormSchema;
  renderer: string | null;
  is_active: boolean;
}

export interface FormInstanceRow {
  id: number;
  form_definition_id: number;
  entity_type: string;
  entity_id: number;
  status: string;
  responses: Record<string, any>;
  total_score: number | null;
  recommendation: string | null;
  submitted_by: number | null;
  submitted_at: Date | null;
  approved_by: number | null;
  approved_at: Date | null;
  created_by: number;
  created_at: Date;
  updated_at: Date | null;
  updated_by: number | null;
  deleted_at: Date | null;
  deleted_by: number | null;
}
