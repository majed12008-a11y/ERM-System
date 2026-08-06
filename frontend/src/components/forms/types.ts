/*
 * أنواع بيانات مكتبة النماذج: تعريفات النماذج،
 * مثيلات النماذج، ومخططات الحقول (JSON Schema).
 */

export interface FormFieldLabel {
  ar: string
  en?: string
}

export interface FormFieldOption {
  value: string
  label: FormFieldLabel
}

export type ConditionalOperator = 'eq' | 'ne' | 'in' | 'empty'

export interface FieldConditional {
  field: string
  op?: ConditionalOperator
  /** Backward-compatible equality short-cut (equivalent to op: 'eq'). */
  equals?: unknown
  /** Value for op: 'eq' | 'ne' | 'in'. */
  value?: unknown
}

export interface FieldDependency {
  field: string
  op: 'lt' | 'lte' | 'gt' | 'gte' | 'eq' | 'ne'
  /** Static comparison value. */
  value?: unknown
  /** Compare against another field's response (takes precedence over value). */
  valueField?: string
  message?: FormFieldLabel
}

export interface FormField {
  name: string
  label: FormFieldLabel
  type: 'text' | 'textarea' | 'number' | 'date' | 'boolean' | 'scale' | 'select' | 'radio' | 'email' | 'tel' | 'checkbox'
  required?: boolean
  options?: FormFieldOption[]
  min?: number
  max?: number
  maxLength?: number
  pattern?: string
  rows?: number
  conditional?: FieldConditional
  dependencies?: FieldDependency[]
  placeholder?: FormFieldLabel | string
  helpText?: FormFieldLabel | string
  unit?: string
}

export interface FormSection {
  id: string
  title: FormFieldLabel
  fields: FormField[]
}

export interface FormComputed {
  type: 'mean' | 'sum' | 'count' | 'count_checked'
  fields?: string[]
}

export interface FormWorkflowConfig {
  entity_type: string
  /** Transition code executed on submit (e.g. 'SUBMIT'). */
  transition_on_submit: string
  /** Workflow definition code. Required when the workflow instance does not exist yet (e.g. app shell created as draft). */
  workflow_code?: string
}

export interface FormDocumentConfig {
  template_code: string
  document_type: string
}

export interface FormSchema {
  formCode: string
  version: string
  sections: FormSection[]
  computed?: { total_score?: FormComputed }
  /** Render as a wizard (stepper/section navigation) instead of single scroll. */
  wizard?: boolean
  /** Config-driven workflow binding executed on submit through the workflow engine. */
  workflow?: FormWorkflowConfig
  /** Document generation override (takes precedence over CATEGORY_TEMPLATE). */
  document?: FormDocumentConfig
}

export interface FormDefinition {
  id: number
  form_code: string
  form_name_ar: string
  form_name_en: string | null
  category: string
  workflow_stage: string | null
  version_no: number
  schema_version: string | null
  form_schema: FormSchema
  renderer: string | null
  is_active: boolean
}

export type FormInstanceStatus = 'DRAFT' | 'RETURNED' | 'SUBMITTED' | 'APPROVED' | 'VOID'

export interface FormInstance {
  id: number
  form_definition_id: number
  entity_type: string
  entity_id: number
  status: FormInstanceStatus
  responses: Record<string, unknown>
  total_score: number | null
  recommendation: string | null
  submitted_at: string | null
  approved_at: string | null
  approved_by: number | null
  created_by: number
  created_at: string
  updated_at: string | null
  form_code?: string
  form_name_ar?: string
  form_name_en?: string | null
}

export interface GeneratedDocument {
  documentId: number
  documentNumber: string
  versionNo: number
  templateId: number
  storagePath: string
  fileName: string
  checksumSha256: string
  language: string
  instanceId: number
  formCode: string
}

export type DocumentLifecycleStatus = 'OFFICIAL' | 'REVOKED' | 'VOID' | 'SUPERSEDED'

export interface GeneratedDocumentRecord {
  id: number
  document_type_id: number
  entity_type: string
  entity_id: number
  document_title: string
  file_name: string
  mime_type: string
  file_size_bytes: number
  storage_path: string
  checksum_sha256: string
  uploaded_by: number
  uploaded_at: string
  document_number: string
  document_uuid: string
  status: DocumentLifecycleStatus
  is_immutable: boolean
  current_version_no: number
  template_code: string | null
  template_version: number | null
  language: string | null
  supersedes_version_no: number | null
  superseded_by_document_id: number | null
  revoked_at: string | null
  revoked_by: number | null
  revocation_reason: string | null
  type_name_ar?: string | null
  version_count: number
  signature_count: number
  audit_count: number
}

export interface DocumentVersion {
  id: number
  document_id: number
  version_no: number
  file_name: string
  storage_path: string
  checksum_sha256: string
  uploaded_by: number
  version_notes: string | null
  document_uuid: string | null
  template_code: string | null
  template_version: number | null
  language: string | null
  supersedes_version_id: number | null
}

export interface DocumentAuditEntry {
  id: number
  document_id: number
  action_type: string
  action_by: number | null
  action_timestamp: string
  details: Record<string, unknown> | null
  actor_name?: string | null
}

export interface DocumentSignature {
  id: number
  document_id: number
  signer_id: number
  signature_type: string
  signature_hash: string
  signed_at: string
  signer_name?: string | null
}

export interface DocumentDetail {
  document: GeneratedDocumentRecord
  versions: DocumentVersion[]
  audit: DocumentAuditEntry[]
  signatures: DocumentSignature[]
}
