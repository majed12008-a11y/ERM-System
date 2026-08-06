/*
 * محرك التحقق والحسابات لنماذج مكتبة النماذج — دوال نقية (بدون DB)
 * تُستخدم من FormService وخادم التحقق، وقابلة للاختبار المباشر.
 * تتوافق مع مخطط FormSchema في shared/types.
 */

import { FormField, FormSchema } from '../shared/types';

export function isEmpty(value: any): boolean {
  return value === undefined || value === null || value === '';
}

/** هل الحقل مرئي استناداً إلى conditional (فردي الحقل). */
export function isFieldActive(field: FormField, responses: Record<string, any>): boolean {
  if (!field.conditional) return true;
  const cond = field.conditional;
  const current = responses[cond.field];

  if (cond.op === 'empty') return isEmpty(current);
  const op = cond.op || 'eq';
  const expected = cond.op === 'in' || cond.op === 'ne' || cond.op === 'eq'
    ? (cond.value !== undefined ? cond.value : cond.equals)
    : cond.equals;

  if (op === 'eq') return current === expected;
  if (op === 'ne') return current !== expected;
  if (op === 'in') {
    return Array.isArray(expected) ? expected.some((v) => current === v) : current === expected;
  }
  return true;
}

/** تحقق من قيمة حقل واحد (نوع/مدى/نمط/خيارات). يعيد رسالة أو null. */
export function validateFieldValue(field: FormField, value: any): string | null {
  switch (field.type) {
    case 'text':
    case 'textarea':
    case 'date': {
      if (typeof value !== 'string') return `Field "${field.name}" must be a string`;
      if (field.maxLength && value.length > field.maxLength) {
        return `Field "${field.name}" exceeds max length ${field.maxLength}`;
      }
      if (field.pattern && !new RegExp(field.pattern).test(value)) {
        return `Field "${field.name}" does not match required format`;
      }
      return null;
    }
    case 'email': {
      if (typeof value !== 'string') return `Field "${field.name}" must be a string`;
      const emailRe = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRe.test(value)) return `Field "${field.name}" must be a valid email address`;
      if (field.maxLength && value.length > field.maxLength) return `Field "${field.name}" exceeds max length ${field.maxLength}`;
      return null;
    }
    case 'tel': {
      if (typeof value !== 'string') return `Field "${field.name}" must be a string`;
      if (field.pattern && !new RegExp(field.pattern).test(value)) {
        return `Field "${field.name}" does not match required format`;
      }
      if (field.maxLength && value.length > field.maxLength) return `Field "${field.name}" exceeds max length ${field.maxLength}`;
      return null;
    }
    case 'number': {
      const n = typeof value === 'number' ? value : Number(value);
      if (Number.isNaN(n)) return `Field "${field.name}" must be a number`;
      if (field.min !== undefined && n < field.min) return `Field "${field.name}" below minimum ${field.min}`;
      if (field.max !== undefined && n > field.max) return `Field "${field.name}" exceeds maximum ${field.max}`;
      return null;
    }
    case 'boolean': {
      if (typeof value !== 'boolean') return `Field "${field.name}" must be a boolean`;
      return null;
    }
    case 'scale': {
      const n = typeof value === 'number' ? value : Number(value);
      if (Number.isNaN(n)) return `Field "${field.name}" must be a number`;
      const min = field.min ?? 1;
      const max = field.max ?? 5;
      if (n < min || n > max) return `Field "${field.name}" must be between ${min} and ${max}`;
      return null;
    }
    case 'checkbox': {
      if (!Array.isArray(value)) return `Field "${field.name}" must be an array of selected options`;
      if (field.options) {
        const allowed = new Set(field.options.map((o) => o.value));
        for (const v of value) {
          if (!allowed.has(v)) return `Field "${field.name}" has an invalid option`;
        }
      }
      return null;
    }
    case 'select':
    case 'radio': {
      if (typeof value !== 'string') return `Field "${field.name}" must be a string`;
      if (field.options && !field.options.some((o) => o.value === value)) {
        return `Field "${field.name}" has an invalid option`;
      }
      return null;
    }
    default:
      return null;
  }
}

/** تحقق من التبعيات بين الحقول (مثال: end_date >= start_date). */
export function validateDependencies(field: FormField, responses: Record<string, any>): string | null {
  if (!field.dependencies || field.dependencies.length === 0) return null;
  const current = responses[field.name];
  if (isEmpty(current)) return null;

  for (const dep of field.dependencies) {
    const compareValue = dep.valueField !== undefined
      ? responses[dep.valueField]
      : (dep.value !== undefined ? dep.value : responses[dep.field]);
    if (isEmpty(compareValue)) continue;

    const a = typeof current === 'number' ? current : Number(current);
    const b = typeof compareValue === 'number' ? compareValue : Number(compareValue);
    const numericOk = !Number.isNaN(a) && !Number.isNaN(b);

    let ok: boolean;
    switch (dep.op) {
      case 'lt': ok = numericOk ? a < b : String(current) < String(compareValue); break;
      case 'lte': ok = numericOk ? a <= b : String(current) <= String(compareValue); break;
      case 'gt': ok = numericOk ? a > b : String(current) > String(compareValue); break;
      case 'gte': ok = numericOk ? a >= b : String(current) >= String(compareValue); break;
      case 'eq': ok = current === compareValue; break;
      case 'ne': ok = current !== compareValue; break;
      default: ok = true;
    }
    if (!ok) {
      return dep.message?.ar || `Field "${field.name}" violates dependency on "${dep.field}"`;
    }
  }
  return null;
}

/** تحقق من مجموعة استجابات كاملة مقابل المخطط. يرمي خطأ 400 مع validationErrors. */
export function validateResponses(schema: FormSchema, responses: Record<string, any>): Record<string, any> {
  const allFields = schema.sections.flatMap((s) => s.fields);
  const allowed = new Set<string>();
  for (const f of allFields) allowed.add(f.name);

  for (const key of Object.keys(responses)) {
    if (!allowed.has(key)) {
      throw Object.assign(new Error(`Unknown field: ${key}`), { status: 400 });
    }
  }

  const errors: string[] = [];
  const cleaned: Record<string, any> = {};

  for (const field of allFields) {
    const value = responses[field.name];
    const isActive = isFieldActive(field, responses);
    const required = Boolean(field.required) && isActive;

    if (required && isEmpty(value)) {
      errors.push(`Field "${field.name}" is required`);
      continue;
    }
    if (isEmpty(value)) continue;

    const err = validateFieldValue(field, value);
    if (err) {
      errors.push(err);
      continue;
    }
    const depErr = validateDependencies(field, responses);
    if (depErr) {
      errors.push(depErr);
      continue;
    }
    cleaned[field.name] = value;
  }

  if (errors.length > 0) {
    throw Object.assign(new Error(`Validation failed: ${errors.join('; ')}`), {
      status: 400,
      validationErrors: errors,
    });
  }
  return cleaned;
}

/** حساب قيمة محسوبة (mean | sum | count | count_checked). يعيد null إذا غير ممكن. */
export function computeComputed(computed: FormSchema['computed'], responses: Record<string, any>): number | null {
  const totalScoreDef = computed?.total_score;
  if (!totalScoreDef || !totalScoreDef.fields) return null;
  const fields = totalScoreDef.fields;

  switch (totalScoreDef.type) {
    case 'mean': {
      const values = fields.map((f) => responses[f]).filter((v): v is number => typeof v === 'number');
      if (values.length === 0) return null;
      const mean = values.reduce((a, b) => a + b, 0) / values.length;
      return Math.round(mean * 100) / 100;
    }
    case 'sum': {
      const values = fields.map((f) => responses[f]).filter((v): v is number => typeof v === 'number');
      if (values.length === 0) return null;
      return Math.round(values.reduce((a, b) => a + b, 0) * 100) / 100;
    }
    case 'count': {
      let count = 0;
      for (const f of fields) {
        const v = responses[f];
        if (!isEmpty(v)) count += Array.isArray(v) ? v.length : 1;
      }
      return count;
    }
    case 'count_checked': {
      let count = 0;
      for (const f of fields) {
        const v = responses[f];
        if (Array.isArray(v)) count += v.length;
        else if (typeof v === 'boolean') count += v ? 1 : 0;
        else if (!isEmpty(v)) count += 1;
      }
      return count;
    }
    default:
      return null;
  }
}
