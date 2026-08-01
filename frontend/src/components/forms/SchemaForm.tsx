/*
 * مكون SchemaForm: عرض نموذج ديناميكي من مخطط JSON
 * (أقسام، حقول بأنواع مختلفة، حقول شرطية، تحقق محلي).
 */
import { useTranslation } from 'react-i18next'
import { cn } from '../../lib/utils'
import { Input } from '../ui/input'
import { Textarea } from '../ui/textarea'
import { Switch } from '../ui/switch'
import {
  FormField,
  FormFieldOption,
  FormSchema,
  FormSection,
} from './types'

interface SchemaFormProps {
  schema: FormSchema
  responses: Record<string, any>
  onChange: (name: string, value: any) => void
  disabled?: boolean
}

function getLabel(label: { ar: string; en?: string }, lang: string): string {
  return lang === 'ar' ? label.ar : (label.en || label.ar)
}

function isFieldVisible(field: FormField, responses: Record<string, any>): boolean {
  if (!field.conditional) return true
  return responses[field.conditional.field] === field.conditional.equals
}

function isEmpty(value: any): boolean {
  return value === undefined || value === null || value === ''
}

function validateField(field: FormField, value: any): string | null {
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
  value: any
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

function ScaleField({ field, value, onChange, disabled, lang }: {
  field: FormField
  value: any
  onChange: (v: number) => void
  disabled?: boolean
  lang: string
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

function FieldInput({ field, value, onChange, disabled }: {
  field: FormField
  value: any
  onChange: (v: any) => void
  disabled?: boolean
}) {
  const { i18n } = useTranslation()
  const lang = i18n.language?.startsWith('ar') ? 'ar' : 'en'

  switch (field.type) {
    case 'textarea':
      return (
        <Textarea
          rows={field.rows || 4}
          value={value ?? ''}
          disabled={disabled}
          maxLength={field.maxLength}
          onChange={(e) => onChange(e.target.value)}
          className="text-sm"
        />
      )
    case 'number':
      return (
        <Input
          type="number"
          value={value ?? ''}
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
          type="date"
          value={value ?? ''}
          disabled={disabled}
          onChange={(e) => onChange(e.target.value || undefined)}
          className="text-sm w-full md:w-64"
        />
      )
    case 'boolean':
      return (
        <div className="flex items-center gap-3">
          <Switch
            checked={Boolean(value)}
            disabled={disabled}
            onCheckedChange={(checked) => onChange(checked)}
          />
          <span className="text-sm text-slate-600">{value ? 'نعم' : 'لا'}</span>
        </div>
      )
    case 'scale':
      return <ScaleField field={field} value={value} onChange={onChange} disabled={disabled} lang={lang} />
    case 'select': {
      const options = field.options || []
      return (
        <select
          value={value ?? ''}
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
          value={value ?? ''}
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
  responses: Record<string, any>
  onChange: (name: string, value: any) => void
  disabled?: boolean
}) {
  const { t, i18n } = useTranslation()
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
            <label className="block text-sm font-medium text-slate-700">
              {getLabel(field.label, lang)}
              {field.required && <span className="text-red-500 ms-1">*</span>}
            </label>
            <FieldInput field={field} value={value} onChange={(v) => onChange(field.name, v)} disabled={disabled} />
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
