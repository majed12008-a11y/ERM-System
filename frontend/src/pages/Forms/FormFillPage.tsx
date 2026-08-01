/*
 * صفحة تعبئة النموذج: عرض المخطط ديناميكياً، حفظ تلقائي
 * للمسودة، إرسال النموذج، وتوليد/تنزيل المستند الرسمي.
 */
import { useEffect, useMemo, useRef, useState } from 'react'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import {
  FileText, Save, Send, Download, FileCheck2, ArrowRight, Loader2,
} from 'lucide-react'
import {
  getFormInstance, saveFormDraft, submitForm, generateFormDocument,
  downloadFormDocument,
} from '../../api/forms'
import SchemaForm from '../../components/forms/SchemaForm'
import type {
  FormDefinition, FormInstance, FormSchema, GeneratedDocument,
} from '../../components/forms/types'
import { Card, CardContent } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Badge } from '../../components/ui/badge'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import { AxiosError } from 'axios'

type InstanceData = { instance: FormInstance; definition: FormDefinition }

const STATUS_VARIANTS: Record<string, 'default' | 'success' | 'warning' | 'destructive' | 'secondary'> = {
  DRAFT: 'secondary',
  RETURNED: 'warning',
  SUBMITTED: 'success',
  APPROVED: 'success',
  VOID: 'destructive',
}

export default function FormFillPage() {
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { instanceId } = useParams<{ instanceId: string }>()
  const id = Number(instanceId)

  const { data, isLoading } = useQuery({
    queryKey: ['form-instance', id],
    queryFn: () => getFormInstance(id),
    enabled: !!id,
  })

  if (isLoading || !data) return <PageSkeleton />

  return (
    <FormFillBody
      key={data.instance.id}
      data={data}
      navigate={navigate}
      queryClient={queryClient}
    />
  )
}

function FormFillBody({ data, navigate, queryClient }: {
  data: InstanceData
  navigate: ReturnType<typeof useNavigate>
  queryClient: ReturnType<typeof useQueryClient>
}) {
  const { t } = useTranslation()
  const instance = data.instance
  const definition = data.definition

  const [responses, setResponses] = useState<Record<string, unknown>>(() => instance.responses || {})
  const [generated, setGenerated] = useState<GeneratedDocument[]>([])
  const [saveState, setSaveState] = useState<'idle' | 'saving' | 'saved'>('idle')
  const saveTimer = useRef<ReturnType<typeof setTimeout> | null>(null)

  useEffect(() => () => {
    if (saveTimer.current) clearTimeout(saveTimer.current)
  }, [])

  const editable = instance && ['DRAFT', 'RETURNED'].includes(instance.status)
  const schema = definition?.form_schema as FormSchema | undefined

  const saveDraft = useMutation({
    mutationFn: (resp: Record<string, unknown>) => saveFormDraft(instance.id, resp),
    onSuccess: () => setSaveState('saved'),
    onError: (err: AxiosError<{ error?: string }>) => {
      setSaveState('idle')
      toast.error(err.response?.data?.error || t('formFill.saveFailed'))
    },
  })

  function handleChange(name: string, value: unknown) {
    setResponses((prev) => {
      const next = { ...prev, [name]: value }
      if (editable) {
        setSaveState('saving')
        if (saveTimer.current) clearTimeout(saveTimer.current)
        saveTimer.current = setTimeout(() => {
          saveDraft.mutate(next)
        }, 800)
      }
      return next
    })
  }

  const submit = useMutation({
    mutationFn: (resp: Record<string, unknown>) => submitForm(instance.id, resp),
    onSuccess: (updated) => {
      toast.success(t('formFill.submitted'))
      queryClient.setQueryData(['form-instance', instance.id], { instance: updated, definition })
      queryClient.invalidateQueries({ queryKey: ['form-instance', instance.id] })
      window.setTimeout(() => window.location.reload(), 800)
    },
    onError: (err: AxiosError<{ error?: string; validationErrors?: string[] }>) => {
      const v = err.response?.data as { validationErrors?: string[]; error?: string } | undefined
      const msg = v?.validationErrors?.join('; ') || v?.error || t('formFill.submitFailed')
      toast.error(msg)
    },
  })

  const generate = useMutation({
    mutationFn: (language: string) => generateFormDocument(instance.id, { language }),
    onSuccess: (doc) => {
      toast.success(t('formFill.generated'))
      setGenerated((prev) => {
        const next = prev.filter((d) => !(d.template === doc.template && d.language === doc.language))
        next.push(doc)
        return next
      })
    },
    onError: (err: AxiosError<{ error?: string }>) =>
      toast.error(err.response?.data?.error || t('formFill.generateFailed')),
  })

  const liveScore = useMemo(() => {
    if (!schema?.computed?.total_score) return null
    const fields = schema.computed.total_score.fields
    const values = fields.map((f) => Number(responses[f])).filter((n) => !Number.isNaN(n))
    if (values.length !== fields.length || values.length === 0) return null
    return (values.reduce((a, b) => a + b, 0) / values.length).toFixed(2)
  }, [schema, responses])

  return (
    <div className="space-y-5 max-w-4xl">
      <div className="flex items-center justify-between flex-wrap gap-3">
        <div className="flex items-center gap-3">
          <Link to="/forms" className="text-slate-400 hover:text-slate-600">
            <ArrowRight className="w-5 h-5 rtl:rotate-180" />
          </Link>
          <div>
            <h1 className="text-xl font-bold flex items-center gap-2">
              <FileText className="w-5 h-5 text-blue-600" />
              {instance.form_name_ar || definition?.form_name_ar}
            </h1>
            <p className="text-xs text-slate-400">
              {instance.form_code || definition?.form_code} • v{definition?.version_no} • {t('formFill.entity')}: {instance.entity_type} #{instance.entity_id}
            </p>
          </div>
        </div>
        <Badge variant={STATUS_VARIANTS[instance.status] || 'default'}>
          {t(`formLibrary.status.${instance.status}`)}
        </Badge>
      </div>

      {instance.total_score != null && (
        <div className="flex items-center gap-4 rounded-lg bg-blue-50 border border-blue-200 px-4 py-2.5 text-sm">
          <span className="font-medium text-blue-800">{t('formFill.totalScore')}</span>
          <span className="font-bold text-blue-900">{Number(instance.total_score).toFixed(2)}</span>
          {instance.recommendation && (
            <>
              <span className="text-blue-300">|</span>
              <span className="text-blue-800">{t(`formFill.recommendation.${instance.recommendation}`)}</span>
            </>
          )}
        </div>
      )}

      {editable && schema && (
        <Card>
          <CardContent className="p-5">
            <SchemaForm
              schema={schema}
              responses={responses}
              onChange={handleChange}
            />
            <div className="mt-6 pt-4 border-t flex items-center justify-between flex-wrap gap-3">
              <div className="flex items-center gap-2 text-sm text-slate-500">
                {liveScore != null && (
                  <span className="flex items-center gap-1">
                    <FileCheck2 className="w-4 h-4" />
                    {t('formFill.liveScore')}: <span className="font-semibold text-slate-700">{liveScore}</span>
                  </span>
                )}
                {saveState === 'saving' && <span className="flex items-center gap-1 text-slate-400"><Loader2 className="w-3.5 h-3.5 animate-spin" /> {t('formFill.saving')}</span>}
                {saveState === 'saved' && <span className="text-green-600">{t('formFill.saved')}</span>}
              </div>
              <div className="flex items-center gap-2">
                <Button size="sm" variant="outline" disabled={saveDraft.isPending} onClick={() => saveDraft.mutate(responses)}>
                  <Save className="w-3.5 h-3.5 ms-1" /> {t('formFill.saveDraft')}
                </Button>
                <Button size="sm" disabled={submit.isPending} onClick={() => submit.mutate(responses)}>
                  <Send className="w-3.5 h-3.5 ms-1" /> {t('formFill.submit')}
                </Button>
              </div>
            </div>
          </CardContent>
        </Card>
      )}

      {!editable && schema && (
        <Card>
          <CardContent className="p-5">
            <SchemaForm schema={schema} responses={instance.responses || {}} onChange={() => {}} disabled />
          </CardContent>
        </Card>
      )}

      {instance.status !== 'DRAFT' && instance.status !== 'VOID' && (
        <Card>
          <CardContent className="p-5 space-y-4">
            <div className="flex items-center justify-between flex-wrap gap-3">
              <h2 className="text-base font-semibold text-slate-800">{t('formFill.officialDocuments')}</h2>
              <div className="flex items-center gap-2">
                {(['ar', 'en'] as const).map((lang) => (
                  <Button
                    key={lang}
                    size="sm"
                    variant="outline"
                    disabled={generate.isPending}
                    onClick={() => generate.mutate(lang)}
                  >
                    <FileCheck2 className="w-3.5 h-3.5 ms-1" />
                    {lang === 'ar' ? t('formFill.generateAr') : t('formFill.generateEn')}
                  </Button>
                ))}
              </div>
            </div>
            {generated.length > 0 ? (
              <div className="space-y-2">
                {generated.map((doc) => (
                  <div key={`${doc.template}-${doc.language}`} className="flex items-center justify-between rounded-md border p-3 text-sm">
                    <div className="flex items-center gap-3">
                      <FileText className="w-4 h-4 text-slate-400" />
                      <div>
                        <p className="font-medium">{doc.documentNumber}</p>
                        <p className="text-xs text-slate-400">{doc.fileName} • {doc.language} • v{doc.version}</p>
                      </div>
                    </div>
                    <Button
                      size="sm"
                      variant="ghost"
                      onClick={() => downloadFormDocument(doc.documentId, doc.fileName)}
                    >
                      <Download className="w-3.5 h-3.5 ms-1" /> {t('common.download')}
                    </Button>
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-slate-400">{t('formFill.noDocuments')}</p>
            )}
          </CardContent>
        </Card>
      )}

      <div className="text-center">
        <Button variant="link" size="sm" onClick={() => navigate('/forms')}>
          {t('formFill.backToLibrary')}
        </Button>
      </div>
    </div>
  )
}
