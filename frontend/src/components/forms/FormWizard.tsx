/*
 * مكون FormWizard: عرض نموذج wizard متعدد الأقسام
 * (معالج/stepper) — تنقل بين الأقسام، شريط تقدم،
 * تحقق ملزم لكل قسم، خطوة مراجعة، وطباعة.
 * يُستخدم عندما يكون schema.wizard = true.
 */
import { useMemo, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { cn } from '../../lib/utils'
import { Button } from '../ui/button'
import {
  ArrowRight, ArrowLeft, Check, FileText, Loader2, Printer, Send, Save,
} from 'lucide-react'
import { SectionRenderer } from './SchemaForm'
import {
  validateAllSections,
  validateSection,
  computeComputed,
  isFieldActive,
  type FieldError,
} from './validation'
import type { FormSchema } from './types'

interface FormWizardProps {
  schema: FormSchema
  responses: Record<string, unknown>
  onChange: (name: string, value: unknown) => void
  disabled?: boolean
  saveState: 'idle' | 'saving' | 'saved'
  isSavingDraft?: boolean
  isSubmitting?: boolean
  onSaveDraft?: () => void
  onSubmit?: () => void
}

function getLabel(label: { ar: string; en?: string }, lang: string): string {
  return lang === 'ar' ? label.ar : (label.en || label.ar)
}

function formatValue(value: unknown, lang: string, t: (k: string) => string): string {
  if (value === undefined || value === null || value === '') return t('formWizard.noValue')
  if (Array.isArray(value)) return value.join('، ')
  if (typeof value === 'boolean') return value ? (lang === 'ar' ? 'نعم' : 'Yes') : (lang === 'ar' ? 'لا' : 'No')
  return String(value)
}

export default function FormWizard({
  schema, responses, onChange, disabled,
  saveState, isSavingDraft, isSubmitting, onSaveDraft, onSubmit,
}: FormWizardProps) {
  const { t, i18n } = useTranslation()
  const lang = i18n.language?.startsWith('ar') ? 'ar' : 'en'
  const sections = useMemo(() => schema.sections || [], [schema.sections])
  const reviewIndex = sections.length
  const totalSteps = sections.length + 1

  const [step, setStep] = useState(0)

  const allErrors = useMemo(() => validateAllSections(schema, responses), [schema, responses])
  const sectionErrorsMap = useMemo(() => {
    const map: Record<string, Record<string, FieldError>> = {}
    for (const s of sections) map[s.id] = validateSection(s, responses)
    return map
  }, [sections, responses])
  const sectionErrorCounts = useMemo(() => {
    const counts: Record<string, number> = {}
    for (const s of sections) counts[s.id] = Object.keys(sectionErrorsMap[s.id] || {}).length
    return counts
  }, [sections, sectionErrorsMap])
  const totalErrors = Object.keys(allErrors).length

  const computedValue = useMemo(() => computeComputed(schema.computed, responses), [schema.computed, responses])
  const computedTotal = schema.computed?.total_score?.fields?.length ?? 0
  const isReview = step === reviewIndex
  const currentSection = isReview ? null : sections[step]

  function goNext() {
    if (currentSection) {
      const count = sectionErrorCounts[currentSection.id] || 0
      if (count > 0) {
        toast.warning(t('formWizard.sectionErrors'))
        return
      }
    }
    if (step < reviewIndex) setStep(step + 1)
  }

  function goPrev() {
    if (step > 0) setStep(step - 1)
  }

  function goTo(index: number) {
    if (index < step) {
      setStep(index)
      return
    }
    let cursor = step
    while (cursor < index) {
      const s = sections[cursor]
      if (s && (sectionErrorCounts[s.id] || 0) > 0) {
        toast.warning(t('formWizard.sectionErrors'))
        return
      }
      cursor += 1
    }
    setStep(index)
  }

  const ready = totalErrors === 0

  return (
    <div className="space-y-5 print:space-y-2">
      {/* Stepper */}
      <div className="rounded-xl border bg-white p-4 print:hidden">
        <ol className="flex flex-wrap items-center gap-2">
          {sections.map((s, i) => {
            const complete = (sectionErrorCounts[s.id] || 0) === 0
            const active = step === i
            const reached = step >= i
            return (
              <li key={s.id} className="flex items-center gap-2">
                <button
                  type="button"
                  disabled={disabled}
                  onClick={() => goTo(i)}
                  className={cn(
                    'flex items-center gap-2 rounded-lg border px-3 py-1.5 text-sm transition-colors',
                    active ? 'border-blue-600 bg-blue-50 text-blue-800' : 'border-slate-200 text-slate-600 hover:bg-slate-50',
                    complete && !active && 'border-green-300 bg-green-50 text-green-700',
                    !reached && !active && 'opacity-60'
                  )}
                >
                  <span className={cn(
                    'flex h-5 w-5 items-center justify-center rounded-full text-xs font-medium',
                    active ? 'bg-blue-600 text-white' : complete ? 'bg-green-500 text-white' : 'bg-slate-200 text-slate-600'
                  )}>
                    {complete && !active ? <Check className="w-3 h-3" /> : i + 1}
                  </span>
                  <span className="hidden sm:inline">{getLabel(s.title, lang)}</span>
                </button>
                {i < sections.length - 1 && <span className="text-slate-300">›</span>}
              </li>
            )
          })}
          <li>
            <button
              type="button"
              disabled={disabled}
              onClick={() => goTo(reviewIndex)}
              className={cn(
                'flex items-center gap-2 rounded-lg border px-3 py-1.5 text-sm transition-colors',
                isReview ? 'border-blue-600 bg-blue-50 text-blue-800' : 'border-slate-200 text-slate-600 hover:bg-slate-50'
              )}
            >
              <span className={cn(
                'flex h-5 w-5 items-center justify-center rounded-full text-xs font-medium',
                isReview ? 'bg-blue-600 text-white' : 'bg-slate-200 text-slate-600'
              )}>
                {reviewIndex + 1}
              </span>
              <span className="hidden sm:inline">{t('formWizard.review')}</span>
            </button>
          </li>
        </ol>

        {/* Progress */}
        <div className="mt-3 h-1.5 w-full rounded-full bg-slate-100 overflow-hidden">
          <div
            className="h-full rounded-full bg-blue-600 transition-all"
            style={{ width: `${((step + 1) / totalSteps) * 100}%` }}
          />
        </div>
        <div className="mt-1.5 flex items-center justify-between text-xs text-slate-400">
          <span>{t('formWizard.step', { current: step + 1, total: totalSteps })}</span>
          <span className={cn(ready ? 'text-green-600' : 'text-amber-600')}>
            {ready ? t('formWizard.ready') : t('formWizard.notReady', { count: totalErrors })}
          </span>
        </div>
      </div>

      {/* Section / Review body */}
      <div className="print:hidden">
        {currentSection ? (
          <div className="rounded-xl border bg-white p-5">
            <SectionRenderer
              section={currentSection}
              responses={responses}
              onChange={onChange}
              disabled={disabled}
              errors={sectionErrorsMap[currentSection.id]}
            />
          </div>
        ) : (
          <div className="rounded-xl border bg-white p-5 space-y-6">
            <div className="flex items-center justify-between">
              <h3 className="text-base font-semibold text-slate-800 flex items-center gap-2">
                <FileText className="w-4 h-4 text-blue-600" />
                {t('formWizard.reviewSummary')}
              </h3>
              <div className="flex items-center gap-2">
                {computedValue != null && computedTotal > 0 && (
                  <span className="rounded-lg bg-green-50 border border-green-200 px-3 py-1.5 text-sm text-green-800">
                    {t('formWizard.computedReadiness', { value: computedValue, total: computedTotal })}
                  </span>
                )}
                <Button type="button" variant="outline" size="sm" onClick={() => window.print()}>
                  <Printer className="w-3.5 h-3.5 ms-1" /> {t('formWizard.print')}
                </Button>
              </div>
            </div>
            {sections.map((s) => (
              <div key={s.id}>
                <h4 className="text-sm font-semibold text-slate-700 border-b pb-1 mb-3">{getLabel(s.title, lang)}</h4>
                <dl className="grid grid-cols-1 md:grid-cols-2 gap-x-6 gap-y-2">
                  {s.fields.filter((f) => isFieldActive(f, responses)).map((f) => (
                    <div key={f.name} className="flex items-start gap-2 text-sm">
                      <dt className="text-slate-400 whitespace-nowrap">{getLabel(f.label, lang)}:</dt>
                      <dd className="text-slate-700 font-medium">{formatValue(responses[f.name], lang, t)}</dd>
                    </div>
                  ))}
                </dl>
              </div>
            ))}
          </div>
        )}
      </div>

      {/* Footer nav */}
      <div className="flex items-center justify-between flex-wrap gap-3 rounded-xl border bg-white p-3 print:hidden">
        <div className="flex items-center gap-2 text-sm text-slate-500">
          {saveState === 'saving' && <span className="flex items-center gap-1 text-slate-400"><Loader2 className="w-3.5 h-3.5 animate-spin" /> {t('formFill.saving')}</span>}
          {saveState === 'saved' && <span className="text-green-600">{t('formFill.saved')}</span>}
        </div>
        <div className="flex items-center gap-2">
          {onSaveDraft && (
            <Button size="sm" variant="outline" disabled={disabled || isSavingDraft} onClick={onSaveDraft}>
              <Save className="w-3.5 h-3.5 ms-1" /> {t('formFill.saveDraft')}
            </Button>
          )}
          {step > 0 && (
            <Button size="sm" variant="outline" disabled={disabled} onClick={goPrev}>
              {lang === 'ar' ? <ArrowRight className="w-3.5 h-3.5 ms-1" /> : <ArrowLeft className="w-3.5 h-3.5 ms-1" />}
              {t('formWizard.prev')}
            </Button>
          )}
          {!isReview ? (
            <Button size="sm" disabled={disabled} onClick={goNext}>
              {t('formWizard.next')}
              {lang === 'ar' ? <ArrowLeft className="w-3.5 h-3.5 ms-1" /> : <ArrowRight className="w-3.5 h-3.5 ms-1" />}
            </Button>
          ) : (
            <Button size="sm" disabled={disabled || !ready || isSubmitting} onClick={onSubmit}>
              {isSubmitting ? <Loader2 className="w-3.5 h-3.5 ms-1 animate-spin" /> : <Send className="w-3.5 h-3.5 ms-1" />}
              {t('formWizard.submit')}
            </Button>
          )}
        </div>
      </div>

      {/* Printable review (visible only on print) */}
      <div className="hidden print:block">
        <h2 className="text-lg font-bold mb-4">{t('formWizard.reviewSummary')}</h2>
        {sections.map((s) => (
          <div key={s.id} className="mb-4">
            <h3 className="font-semibold border-b mb-2">{getLabel(s.title, lang)}</h3>
            {s.fields.map((f) => (
              <p key={f.name} className="text-sm">
                <span className="font-medium">{getLabel(f.label, lang)}: </span>
                {formatValue(responses[f.name], lang, t)}
              </p>
            ))}
          </div>
        ))}
      </div>
    </div>
  )
}
