/*
 * مكون SchemaForm: عرض نموذج ديناميكي من مخطط JSON
 * (أقسام، حقول بأنواع مختلفة، حقول شرطية، تحقق محلي).
 */
import { useTranslation } from 'react-i18next'
import { cn } from '../../lib/utils'
import { Input } from '../ui/input'
import { Textarea } from '../ui/textarea'
import { Switch } from '../ui/switch'
import type {
  FormField,
  FormFieldOption,
  FormSchema,
  FormSection,
} from './types'

interface SchemaFormProps {
  schema: FormSchema
  responses: Record<string, unknown>
  onChange: (name: string, value: unknown) => void
  disabled?: boolean
}

function getLabel(label: { ar: string; en?: string }, lang: string): string {
  return lang === 'ar' ? label.ar : (label.en || label.ar)
}

function isFieldVisible(field: FormField, responses: Record<string, unknown>): boolean {
  if (!field.conditional) return true
  return responses[field.conditional.field] === field.conditional.equals
}

function isEmpty(value: unknown): boolean {
  return value === undefined || value === null || value === ''
}

function validateField(field: FormField, value: unknown): string | null {
  if (field.required && isEmpty(value)) return 'required'
  if (isEmpty(value)) return null
  switch (field.type) {
    case 'text':
    case 'textarea':
      if (field.pattern && !new RegExp(field.pattern).test(String(value))) return 'pattern'
      if (field.maxLength && String(value).length > field.maxLength) return 'maxLength'
      break
    case 'number':
      if (typeof value !== 'number') return 'type'
      if (field.min !== undefined && value < field.min) return 'min'
      if (field.max !== undefined && value > field.max) return 'max'
      break
    case 'scale':
      if (field.min !== undefined && Number(value) < field.min) return 'min'
      if (field.max !== undefined && Number(value) > field.max) return 'max'
      break
    default:
      break
  }
  return null
}

function FieldErrors({ errors, field }: { errors: string[]; field: FormField }) {
  const { t, i18n } = useTranslation()
  const lang = i18n.language?.startsWith('ar') ? 'ar' : 'en'
  return (
    <div className="space-y-1">
      {errors.map((err) => (
        <p key={err} className="text-xs text-red-500">{t(`schemaForm.errors.${err}`, { field: getLabel(field.label, lang) })}</p>
      ))}
    </div>
  )
}

function OptionField({ field, value, onChange, disabled, lang }: {
  field: FormField
  value: unknown
  onChange: (v: string) => void
  disabled?: boolean
  lang: string
}) {
  return (
    <div className="flex flex-wrap gap-2">
      {(field.options || []).map((opt: FormFieldOption) => {
        const selected = String(value) === opt.value
        return (
          <button
            key={opt.value}
            type="button"
            disabled={disabled}
            onClick={() => onChange(opt.value)}
            className={cn(
              'px-3 py-1.5 rounded-md border text-sm transition-colors',
              selected
                ? 'bg-blue-600 text-white border-blue-600'
                : 'bg-white text-slate-700 border-slate-300 hover:bg-slate-50',
              disabled && 'opacity-60 cursor-not-allowed'
            )}
          >
            {getLabel(opt.label, lang)}
          </button>
        )
      })}
    </div>
  )
}

function ScaleField({ field, value, onChange, disabled }: {
  field: FormField
  value: unknown
  onChange: (v: number) => void
  disabled?: boolean
}) {
  const min = field.min ?? 1
  const max = field.max ?? 5
  const steps = Array.from({ length: max - min + 1 }, (_, i) => min + i)
  return (
    <div className="flex flex-wrap gap-2 items-center">
      {steps.map((n) => {
        const selected = Number(value) === n
        return (
          <button
            key={n}
            type="button"
            disabled={disabled}
            onClick={() => onChange(n)}
            className={cn(
              'w-10 h-10 rounded-full border text-sm font-medium transition-colors',
              selected
                ? 'bg-blue-600 text-white border-blue-600'
                : 'bg-white text-slate-700 border-slate-300 hover:bg-slate-50',
              disabled && 'opacity-60 cursor-not-allowed'
            )}
          >
            {n}
          </button>
        )
      })}
      <span className="text-xs text-slate-400">{min} – {max}</span>
    </div>
  )
}

function FieldInput({ field, value, onChange, disabled, id }: {
  field: FormField
  value: unknown
  onChange: (v: unknown) => void
  disabled?: boolean
  id?: string
}) {
  const { i18n } = useTranslation()
  const lang = i18n.language?.startsWith('ar') ? 'ar' : 'en'

  switch (field.type) {
    case 'textarea':
      return (
        <Textarea
          id={id}
          name={id}
          rows={field.rows || 4}
          value={String(value ?? '')}
          disabled={disabled}
          maxLength={field.maxLength}
          onChange={(e) => onChange(e.target.value)}
          className="text-sm"
        />
      )
    case 'number':
      return (
        <Input
          id={id}
          name={id}
          type="number"
          value={String(value ?? '')}
          disabled={disabled}
          min={field.min}
          max={field.max}
          onChange={(e) => {
            const v = e.target.value
            onChange(v === '' ? undefined : Number(v))
          }}
          className="text-sm w-full md:w-64"
        />
      )
    case 'date':
      return (
        <Input
          id={id}
          name={id}
          type="date"
          value={String(value ?? '')}
          disabled={disabled}
          onChange={(e) => onChange(e.target.value || undefined)}
          className="text-sm w-full md:w-64"
        />
      )
    case 'boolean':
      return (
        <div className="flex items-center gap-3">
          <Switch
            id={id}
            checked={Boolean(value)}
            disabled={disabled}
            onCheckedChange={(checked) => onChange(checked)}
          />
          <span className="text-sm text-slate-600">{value ? 'نعم' : 'لا'}</span>
        </div>
      )
    case 'scale':
      return <ScaleField field={field} value={value} onChange={onChange} disabled={disabled} />
    case 'select': {
      const options = field.options || []
      return (
        <select
          id={id}
          name={id}
          value={String(value ?? '')}
          disabled={disabled}
          onChange={(e) => onChange(e.target.value || undefined)}
          className="flex h-9 w-full md:w-72 items-center rounded-md border border-input bg-white px-3 py-2 text-sm text-slate-800 shadow-sm focus:outline-none focus:ring-1 focus:ring-ring disabled:cursor-not-allowed disabled:opacity-50"
        >
          <option value="">—</option>
          {options.map((opt) => (
            <option key={opt.value} value={opt.value}>{getLabel(opt.label, lang)}</option>
          ))}
        </select>
      )
    }
    case 'radio':
      return <OptionField field={field} value={value} onChange={onChange} disabled={disabled} lang={lang} />
    case 'text':
    default:
      return (
        <Input
          id={id}
          name={id}
          value={String(value ?? '')}
          disabled={disabled}
          maxLength={field.maxLength}
          onChange={(e) => onChange(e.target.value || undefined)}
          className="text-sm w-full md:w-96"
        />
      )
  }
}

function SectionRenderer({ section, responses, onChange, disabled }: {
  section: FormSection
  responses: Record<string, unknown>
  onChange: (name: string, value: unknown) => void
  disabled?: boolean
}) {
  const { i18n } = useTranslation()
  const lang = i18n.language?.startsWith('ar') ? 'ar' : 'en'

  return (
    <div className="space-y-5">
      <h3 className="text-base font-semibold text-slate-800 border-b pb-2">
        {getLabel(section.title, lang)}
      </h3>
      {section.fields.map((field) => {
        if (!isFieldVisible(field, responses)) return null
        const value = responses[field.name]
        const error = validateField(field, value)
        return (
          <div key={field.name} className="space-y-1.5">
            <label htmlFor={field.name} className="block text-sm font-medium text-slate-700">
              {getLabel(field.label, lang)}
              {field.required && <span className="text-red-500 ms-1">*</span>}
            </label>
            <FieldInput field={field} value={value} onChange={(v) => onChange(field.name, v)} disabled={disabled} id={field.name} />
            {error && <FieldErrors errors={[error]} field={field} />}
          </div>
        )
      })}
    </div>
  )
}

export default function SchemaForm({ schema, responses, onChange, disabled }: SchemaFormProps) {
  if (!schema?.sections?.length) return null
  return (
    <div className="space-y-8">
      {schema.sections.map((section) => (
        <SectionRenderer
          key={section.id}
          section={section}
          responses={responses}
          onChange={onChange}
          disabled={disabled}
        />
      ))}
    </div>
  )
}
