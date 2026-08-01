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

export interface FormField {
  name: string
  label: FormFieldLabel
  type: 'text' | 'textarea' | 'number' | 'date' | 'boolean' | 'scale' | 'select' | 'radio'
  required?: boolean
  options?: FormFieldOption[]
  min?: number
  max?: number
  maxLength?: number
  pattern?: string
  rows?: number
  conditional?: { field: string; equals: string }
}

export interface FormSection {
  id: string
  title: FormFieldLabel
  fields: FormField[]
}

export interface FormSchema {
  formCode: string
  version: string
  sections: FormSection[]
  computed?: { total_score?: { type: 'mean'; fields: string[] } }
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
  template: string
  language: string
  size: number
  version: number
  storagePath: string
  fileName: string
  sha256: string
  instanceId: number
  formCode: string
}
