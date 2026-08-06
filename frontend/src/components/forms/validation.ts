/*
 * محرك التحقق والحسابات لنماذج مكتبة النماذج (الواجهة الأمامية) — دوال نقية.
 * مرآة وظيفية لدوال backend/src/services/form-validation.ts
 * لضمان تطابق سلوك التحقق في الواجهتين.
 */
import type {
  FormField,
  FormSchema,
  FormSection,
} from './types'

export type FieldErrorCode =
  | 'required'
  | 'pattern'
  | 'maxLength'
  | 'type'
  | 'min'
  | 'max'
  | 'email'
  | 'dependency'

export interface FieldError {
  code: FieldErrorCode
  /** رسالة مخصصة من schema (للتبعيات cross-field) إن وُجدت. */
  message?: { ar: string; en?: string }
}

export function isEmpty(value: unknown): boolean {
  return value === undefined || value === null || value === ''
}

/** هل الحقل مرئي استناداً إلى conditional (فردي الحقل). */
export function isFieldActive(field: FormField, responses: Record<string, unknown>): boolean {
  if (!field.conditional) return true
  const cond = field.conditional
  const current = responses[cond.field]

  if (cond.op === 'empty') return isEmpty(current)
  const op = cond.op || 'eq'
  const expected = cond.value !== undefined ? cond.value : cond.equals

  if (op === 'eq') return current === expected
  if (op === 'ne') return current !== expected
  if (op === 'in') {
    return Array.isArray(expected) ? expected.some((v) => current === v) : current === expected
  }
  return true
}

/** تحقق من قيمة حقل واحد (نوع/مدى/نمط/خيارات). يعيد خطأ أو null. */
export function validateFieldValue(field: FormField, value: unknown): FieldError | null {
  switch (field.type) {
    case 'text':
    case 'textarea':
    case 'date': {
      if (typeof value !== 'string') return { code: 'type' }
      if (field.maxLength && value.length > field.maxLength) return { code: 'maxLength' }
      if (field.pattern && !new RegExp(field.pattern).test(value)) return { code: 'pattern' }
      return null
    }
    case 'email': {
      if (typeof value !== 'string') return { code: 'type' }
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value)) return { code: 'email' }
      if (field.maxLength && value.length > field.maxLength) return { code: 'maxLength' }
      return null
    }
    case 'tel': {
      if (typeof value !== 'string') return { code: 'type' }
      if (field.pattern && !new RegExp(field.pattern).test(value)) return { code: 'pattern' }
      if (field.maxLength && value.length > field.maxLength) return { code: 'maxLength' }
      return null
    }
    case 'number':
    case 'scale': {
      const n = typeof value === 'number' ? value : Number(value)
      if (Number.isNaN(n)) return { code: 'type' }
      const min = field.type === 'scale' ? (field.min ?? 1) : field.min
      const max = field.type === 'scale' ? (field.max ?? 5) : field.max
      if (min !== undefined && n < min) return { code: 'min' }
      if (max !== undefined && n > max) return { code: 'max' }
      return null
    }
    case 'boolean': {
      if (typeof value !== 'boolean') return { code: 'type' }
      return null
    }
    case 'checkbox': {
      if (!Array.isArray(value)) return { code: 'type' }
      if (field.options) {
        const allowed = new Set(field.options.map((o) => o.value))
        if (value.some((v) => !allowed.has(v))) return { code: 'type' }
      }
      return null
    }
    case 'select':
    case 'radio': {
      if (typeof value !== 'string') return { code: 'type' }
      if (field.options && !field.options.some((o) => o.value === value)) return { code: 'type' }
      return null
    }
    default:
      return null
  }
}

/** تحقق من التبعيات بين الحقول (مثال: end_date >= start_date). */
export function validateDependencies(field: FormField, responses: Record<string, unknown>): FieldError | null {
  if (!field.dependencies || field.dependencies.length === 0) return null
  const current = responses[field.name]
  if (isEmpty(current)) return null

  for (const dep of field.dependencies) {
    const compareValue = dep.valueField !== undefined
      ? responses[dep.valueField]
      : (dep.value !== undefined ? dep.value : responses[dep.field])
    if (isEmpty(compareValue)) continue

    const a = typeof current === 'number' ? current : Number(current)
    const b = typeof compareValue === 'number' ? compareValue : Number(compareValue)
    const numericOk = !Number.isNaN(a) && !Number.isNaN(b)

    let ok: boolean
    switch (dep.op) {
      case 'lt': ok = numericOk ? a < b : String(current) < String(compareValue); break
      case 'lte': ok = numericOk ? a <= b : String(current) <= String(compareValue); break
      case 'gt': ok = numericOk ? a > b : String(current) > String(compareValue); break
      case 'gte': ok = numericOk ? a >= b : String(current) >= String(compareValue); break
      case 'eq': ok = current === compareValue; break
      case 'ne': ok = current !== compareValue; break
      default: ok = true
    }
    if (!ok) {
      return { code: 'dependency', message: dep.message }
    }
  }
  return null
}

/** تحقق كامل من حقل واحد (مطلوب/نوع/تبعية). يعيد خطأ واحد أو null. */
export function validateField(field: FormField, responses: Record<string, unknown>): FieldError | null {
  const isActive = isFieldActive(field, responses)
  const value = responses[field.name]

  if (field.required && isActive && isEmpty(value)) return { code: 'required' }
  if (isEmpty(value)) return null

  const err = validateFieldValue(field, value)
  if (err) return err
  return validateDependencies(field, responses)
}

/** تحقق من قسم كامل (الحقول النشطة فقط). يعيد map بالحقول الخاطئة. */
export function validateSection(section: FormSection, responses: Record<string, unknown>): Record<string, FieldError> {
  const errors: Record<string, FieldError> = {}
  for (const field of section.fields) {
    const err = validateField(field, responses)
    if (err) errors[field.name] = err
  }
  return errors
}

/** تحقق من كل أقسام المخطط. يعيد map بالحقول الخاطئة. */
export function validateAllSections(schema: FormSchema, responses: Record<string, unknown>): Record<string, FieldError> {
  const errors: Record<string, FieldError> = {}
  for (const section of schema.sections || []) {
    Object.assign(errors, validateSection(section, responses))
  }
  return errors
}

/** حساب قيمة محسوبة (mean | sum | count | count_checked). يعيد null إذا غير ممكن. */
export function computeComputed(computed: FormSchema['computed'], responses: Record<string, unknown>): number | null {
  const totalScoreDef = computed?.total_score
  if (!totalScoreDef || !totalScoreDef.fields) return null
  const fields = totalScoreDef.fields

  switch (totalScoreDef.type) {
    case 'mean': {
      const values = fields.map((f) => responses[f]).filter((v): v is number => typeof v === 'number')
      if (values.length === 0) return null
      const mean = values.reduce((a, b) => a + b, 0) / values.length
      return Math.round(mean * 100) / 100
    }
    case 'sum': {
      const values = fields.map((f) => responses[f]).filter((v): v is number => typeof v === 'number')
      if (values.length === 0) return null
      return Math.round(values.reduce((a, b) => a + b, 0) * 100) / 100
    }
    case 'count': {
      let count = 0
      for (const f of fields) {
        const v = responses[f]
        if (!isEmpty(v)) count += Array.isArray(v) ? v.length : 1
      }
      return count
    }
    case 'count_checked': {
      let count = 0
      for (const f of fields) {
        const v = responses[f]
        if (Array.isArray(v)) count += v.length
        else if (typeof v === 'boolean') count += v ? 1 : 0
        else if (!isEmpty(v)) count += 1
      }
      return count
    }
    default:
      return null
  }
}
