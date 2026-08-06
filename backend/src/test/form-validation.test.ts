import { describe, it, expect } from 'vitest';
import {
  isEmpty,
  isFieldActive,
  validateFieldValue,
  validateDependencies,
  validateResponses,
  computeComputed,
} from '../services/form-validation';
import { FormField, FormComputed, FormSchema } from '../shared/types';

function field(partial: Partial<FormField> & { name: string; type: string }): FormField {
  return {
    name: partial.name,
    label: partial.label ?? { ar: partial.name, en: partial.name },
    type: partial.type,
    required: partial.required,
    options: partial.options,
    min: partial.min,
    max: partial.max,
    maxLength: partial.maxLength,
    pattern: partial.pattern,
    rows: partial.rows,
    conditional: partial.conditional,
    dependencies: partial.dependencies,
  };
}

describe('isEmpty', () => {
  it('treats undefined/null/empty-string as empty', () => {
    expect(isEmpty(undefined)).toBe(true);
    expect(isEmpty(null)).toBe(true);
    expect(isEmpty('')).toBe(true);
    expect(isEmpty(0)).toBe(false);
    expect(isEmpty(false)).toBe(false);
  });
});

describe('isFieldActive', () => {
  it('shows field when no conditional', () => {
    expect(isFieldActive(field({ name: 'a', type: 'text' }), {})).toBe(true);
  });

  it('eq match shows field', () => {
    const f = field({ name: 'a', type: 'text', conditional: { field: 'multi_center', op: 'eq', value: true } });
    expect(isFieldActive(f, { multi_center: true })).toBe(true);
    expect(isFieldActive(f, { multi_center: false })).toBe(false);
  });

  it('backward-compatible equals short-cut', () => {
    const f = field({ name: 'a', type: 'text', conditional: { field: 'x', equals: 'Y' } });
    expect(isFieldActive(f, { x: 'Y' })).toBe(true);
    expect(isFieldActive(f, { x: 'N' })).toBe(false);
  });

  it('ne match shows field when different', () => {
    const f = field({ name: 'a', type: 'text', conditional: { field: 'compensation', op: 'ne', value: 'NONE' } });
    expect(isFieldActive(f, { compensation: 'STIPEND' })).toBe(true);
    expect(isFieldActive(f, { compensation: 'NONE' })).toBe(false);
  });

  it('in match when current is one of values', () => {
    const f = field({ name: 'a', type: 'text', conditional: { field: 'grp', op: 'in', value: ['A', 'B'] } });
    expect(isFieldActive(f, { grp: 'B' })).toBe(true);
    expect(isFieldActive(f, { grp: 'C' })).toBe(false);
  });

  it('empty shows field when source is empty', () => {
    const f = field({ name: 'a', type: 'text', conditional: { field: 'grp', op: 'empty' } });
    expect(isFieldActive(f, { grp: '' })).toBe(true);
    expect(isFieldActive(f, { grp: 'X' })).toBe(false);
  });
});

describe('validateFieldValue', () => {
  it('validates email format', () => {
    expect(validateFieldValue(field({ name: 'e', type: 'email' }), 'bad')).toBeTruthy();
    expect(validateFieldValue(field({ name: 'e', type: 'email' }), 'a@b.com')).toBeNull();
  });

  it('validates tel pattern', () => {
    const f = field({ name: 'p', type: 'tel', pattern: '^[0-9+\\-\\s()]{7,15}$' });
    expect(validateFieldValue(f, '0551234567')).toBeNull();
    expect(validateFieldValue(f, 'abc')).toBeTruthy();
  });

  it('validates checkbox array and allowed options', () => {
    const f = field({
      name: 'c', type: 'checkbox', options: [
        { value: 'A', label: { ar: 'أ', en: 'A' } },
        { value: 'B', label: { ar: 'ب', en: 'B' } },
      ],
    });
    expect(validateFieldValue(f, ['A'])).toBeNull();
    expect(validateFieldValue(f, ['A', 'Z'])).toBeTruthy();
    expect(validateFieldValue(f, 'A')).toBeTruthy();
  });

  it('validates number bounds', () => {
    const f = field({ name: 'n', type: 'number', min: 1, max: 100 });
    expect(validateFieldValue(f, 0)).toBeTruthy();
    expect(validateFieldValue(f, 50)).toBeNull();
    expect(validateFieldValue(f, 101)).toBeTruthy();
  });

  it('validates select option membership', () => {
    const f = field({
      name: 's', type: 'select', options: [
        { value: 'X', label: { ar: 'س', en: 'X' } },
      ],
    });
    expect(validateFieldValue(f, 'X')).toBeNull();
    expect(validateFieldValue(f, 'UNKNOWN')).toBeTruthy();
  });
});

describe('validateDependencies', () => {
  it('end_date must be >= start_date', () => {
    const f = field({
      name: 'end_date', type: 'date',
      dependencies: [{ field: 'start_date', op: 'gte' }],
    });
    expect(validateDependencies(f, { end_date: '2026-05-01', start_date: '2026-04-01' })).toBeNull();
    expect(validateDependencies(f, { end_date: '2026-03-01', start_date: '2026-04-01' })).toBeTruthy();
  });

  it('skips when current value is empty', () => {
    const f = field({ name: 'end_date', type: 'date', dependencies: [{ field: 'start_date', op: 'gte' }] });
    expect(validateDependencies(f, { end_date: '', start_date: '2026-04-01' })).toBeNull();
  });

  it('supports valueField comparison', () => {
    const f = field({
      name: 'sample_end', type: 'number',
      dependencies: [{ field: 'sample_start', valueField: 'sample_start', op: 'gt' }],
    });
    expect(validateDependencies(f, { sample_end: 10, sample_start: 5 })).toBeNull();
    expect(validateDependencies(f, { sample_end: 3, sample_start: 5 })).toBeTruthy();
  });
});

describe('validateResponses', () => {
  function appSchema(): FormSchema {
    return {
      formCode: 'APP_PROTOCOL',
      version: '1.0.0',
      sections: [
        {
          id: 's1',
          title: { ar: 'قسم', en: 'Section' },
          fields: [
            field({ name: 'pi_email', type: 'email', required: true }),
            field({ name: 'pi_phone', type: 'tel', pattern: '^[0-9+\\-\\s()]{7,15}$', required: true }),
            field({ name: 'multi_center', type: 'boolean', required: true }),
            field({
              name: 'study_sites', type: 'textarea', required: true,
              conditional: { field: 'multi_center', op: 'eq', value: true },
            }),
            field({
              name: 'start_date', type: 'date', required: true,
            }),
            field({
              name: 'end_date', type: 'date', required: true,
              dependencies: [{ field: 'start_date', op: 'gte' }],
            }),
          ],
        },
      ],
    };
  }

  it('rejects unknown fields', () => {
    expect(() => validateResponses(appSchema(), { hacker: 1 })).toThrow(/Unknown field/);
  });

  it('rejects missing required fields', () => {
    const err = (() => {
      try {
        validateResponses(appSchema(), {});
        return null;
      } catch (e: any) {
        return e;
      }
    })();
    expect(err.status).toBe(400);
    expect(err.validationErrors.join('; ')).toContain('pi_email');
  });

  it('rejects invalid email', () => {
    const err = (() => {
      try {
        validateResponses(appSchema(), { pi_email: 'nope', pi_phone: '0551234567', multi_center: false, end_date: '2026-05-01', start_date: '2026-04-01' });
        return null;
      } catch (e: any) {
        return e;
      }
    })();
    expect(err.validationErrors.join('; ')).toContain('valid email');
  });

  it('validates inactive conditional fields are ignored', () => {
    const clean = validateResponses(appSchema(), {
      pi_email: 'a@b.com',
      pi_phone: '0551234567',
      multi_center: false,
      end_date: '2026-05-01',
      start_date: '2026-04-01',
    });
    expect(clean.study_sites).toBeUndefined();
    expect(clean.pi_email).toBe('a@b.com');
  });

  it('validates required conditional field when active', () => {
    expect(() => validateResponses(appSchema(), {
      pi_email: 'a@b.com',
      pi_phone: '0551234567',
      multi_center: true,
      end_date: '2026-05-01',
      start_date: '2026-04-01',
    })).toThrow(/study_sites/);
  });

  it('rejects cross-field dependency violation', () => {
    const err = (() => {
      try {
        validateResponses(appSchema(), {
          pi_email: 'a@b.com',
          pi_phone: '0551234567',
          multi_center: false,
          start_date: '2026-05-01',
          end_date: '2026-03-01',
        });
        return null;
      } catch (e: any) {
        return e;
      }
    })();
    expect(err.validationErrors.join('; ')).toContain('end_date');
  });
});

describe('computeComputed', () => {
  it('computes mean', () => {
    expect(computeComputed({ total_score: { type: 'mean', fields: ['a', 'b'] } }, { a: 2, b: 4 })).toBe(3);
  });

  it('computes sum', () => {
    expect(computeComputed({ total_score: { type: 'sum', fields: ['a', 'b'] } }, { a: 2, b: 4 })).toBe(6);
  });

  it('computes count of non-empty fields', () => {
    expect(computeComputed({ total_score: { type: 'count', fields: ['a', 'b', 'c'] } }, { a: 'x', b: '' })).toBe(1);
  });

  it('computes count_checked for booleans and arrays', () => {
    const def: FormComputed = { type: 'count_checked', fields: ['a', 'b', 'c'] };
    expect(computeComputed({ total_score: def }, { a: true, b: false, c: ['X', 'Y'] })).toBe(3);
  });

  it('returns null when computed absent', () => {
    expect(computeComputed(undefined, {})).toBeNull();
  });
});
