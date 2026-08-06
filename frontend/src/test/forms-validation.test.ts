import { describe, it, expect } from 'vitest'
import {
  isEmpty,
  isFieldActive,
  validateField,
  validateSection,
  validateAllSections,
  computeComputed,
} from '../components/forms/validation'
import type { FormField, FormSchema } from '../components/forms/types'

function f(partial: Partial<FormField> & { name: string; type: FormField['type'] }): FormField {
  return {
    name: partial.name,
    label: { ar: partial.name, en: partial.name },
    type: partial.type,
    required: partial.required,
    options: partial.options,
    min: partial.min,
    max: partial.max,
    maxLength: partial.maxLength,
    pattern: partial.pattern,
    conditional: partial.conditional,
    dependencies: partial.dependencies,
  }
}

describe('validation helpers', () => {
  it('isEmpty', () => {
    expect(isEmpty(undefined)).toBe(true)
    expect(isEmpty(null)).toBe(true)
    expect(isEmpty('')).toBe(true)
    expect(isEmpty(0)).toBe(false)
    expect(isEmpty(false)).toBe(false)
  })

  it('isFieldActive respects op variants', () => {
    const eq = f({ name: 'a', type: 'text', conditional: { field: 'x', op: 'eq', value: 'Y' } })
    expect(isFieldActive(eq, { x: 'Y' })).toBe(true)
    expect(isFieldActive(eq, { x: 'N' })).toBe(false)

    const ne = f({ name: 'a', type: 'text', conditional: { field: 'x', op: 'ne', value: 'NONE' } })
    expect(isFieldActive(ne, { x: 'STIPEND' })).toBe(true)
    expect(isFieldActive(ne, { x: 'NONE' })).toBe(false)

    const inC = f({ name: 'a', type: 'text', conditional: { field: 'x', op: 'in', value: ['A', 'B'] } })
    expect(isFieldActive(inC, { x: 'B' })).toBe(true)
    expect(isFieldActive(inC, { x: 'C' })).toBe(false)

    const empty = f({ name: 'a', type: 'text', conditional: { field: 'x', op: 'empty' } })
    expect(isFieldActive(empty, { x: '' })).toBe(true)
    expect(isFieldActive(empty, { x: 'Z' })).toBe(false)
  })

  it('validates email, tel, checkbox', () => {
    expect(validateField(f({ name: 'e', type: 'email' }), { e: 'bad' })).toMatchObject({ code: 'email' })
    expect(validateField(f({ name: 'e', type: 'email' }), { e: 'a@b.com' })).toBeNull()

    const tel = f({ name: 'p', type: 'tel', pattern: '^[0-9+\\-\\s()]{7,15}$' })
    expect(validateField(tel, { p: 'abc' })).toMatchObject({ code: 'pattern' })
    expect(validateField(tel, { p: '0551234567' })).toBeNull()

    const cb = f({ name: 'c', type: 'checkbox', options: [{ value: 'A', label: { ar: 'أ', en: 'A' } }] })
    expect(validateField(cb, { c: ['A'] })).toBeNull()
    expect(validateField(cb, { c: ['Z'] })).toMatchObject({ code: 'type' })
  })

  it('validates dependencies between fields', () => {
    const end = f({
      name: 'end_date', type: 'date',
      dependencies: [{ field: 'start_date', op: 'gte' }],
    })
    expect(validateField(end, { end_date: '2026-05-01', start_date: '2026-04-01' })).toBeNull()
    expect(validateField(end, { end_date: '2026-03-01', start_date: '2026-04-01' })).toMatchObject({ code: 'dependency' })
  })

  it('required is enforced only for active fields', () => {
    const opt = f({ name: 'o', type: 'text', required: true })
    const hidden = f({ name: 'h', type: 'text', required: true, conditional: { field: 'flag', op: 'eq', value: true } })
    expect(validateSection({ id: 's', title: { ar: 'قسم', en: 'Section' }, fields: [opt, hidden] }, { flag: false }))
      .toHaveProperty('o')
    expect(validateSection({ id: 's', title: { ar: 'قسم', en: 'Section' }, fields: [opt, hidden] }, { flag: false }))
      .not.toHaveProperty('h')
  })

  it('validateAllSections aggregates errors', () => {
    const schema: FormSchema = {
      formCode: 'X', version: '1', sections: [
        { id: 'a', title: { ar: 'أ', en: 'A' }, fields: [f({ name: 'r', type: 'text', required: true })] },
        { id: 'b', title: { ar: 'ب', en: 'B' }, fields: [f({ name: 'e', type: 'email' })] },
      ],
    }
    const errors = validateAllSections(schema, { e: 'bad' })
    expect(errors.r).toBeDefined()
    expect(errors.e).toBeDefined()
  })

  it('computeComputed count_checked ignores false booleans', () => {
    const def = { type: 'count_checked' as const, fields: ['a', 'b', 'c'] }
    expect(computeComputed({ total_score: def }, { a: true, b: false, c: ['X', 'Y'] })).toBe(3)
  })

  it('computeComputed mean/sum/count', () => {
    expect(computeComputed({ total_score: { type: 'mean', fields: ['a', 'b'] } }, { a: 2, b: 4 })).toBe(3)
    expect(computeComputed({ total_score: { type: 'sum', fields: ['a', 'b'] } }, { a: 2, b: 4 })).toBe(6)
    expect(computeComputed({ total_score: { type: 'count', fields: ['a', 'b'] } }, { a: 'x', b: '' })).toBe(1)
    expect(computeComputed(undefined, {})).toBeNull()
  })
})
