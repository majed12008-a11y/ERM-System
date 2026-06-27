import { useState, useRef } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate, useParams } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../../api/client'
import { Button } from '../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '../../components/ui/card'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import { FileUp, Check, ChevronRight, ChevronLeft, Save, Send, Trash2 } from 'lucide-react'

type Step = 1 | 2 | 3 | 4

const STEPS: { key: Step; titleKey: string; descKey: string }[] = [
  { key: 1, titleKey: 'applications.wizardStep1', descKey: 'applications.wizardStep1Desc' },
  { key: 2, titleKey: 'applications.wizardStep2', descKey: 'applications.wizardStep2Desc' },
  { key: 3, titleKey: 'applications.wizardStep3', descKey: 'applications.wizardStep3Desc' },
  { key: 4, titleKey: 'applications.wizardStep4', descKey: 'applications.wizardStep4Desc' },
]

export default function ApplicationEdit() {
  const { t } = useTranslation()
  const { id } = useParams()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [step, setStep] = useState<Step>(1)
  const [selectedProject, setSelectedProject] = useState<any>(null)
  const fileRef = useRef<HTMLInputElement>(null)
  const [uploadFile, setUploadFile] = useState<File | null>(null)
  const [uploadTitle, setUploadTitle] = useState('')
  const [deleteTarget, setDeleteTarget] = useState<number | null>(null)

  const { data: app, isLoading } = useQuery({
    queryKey: ['application', id],
    queryFn: () => api.get(`/core/applications/${id}`).then((r) => r.data.data),
  })

  const { data: projects } = useQuery({
    queryKey: ['projects-dropdown'],
    queryFn: () => api.get('/core/projects').then((r) => r.data.data),
    enabled: !!app,
  })

  const { data: committees } = useQuery({
    queryKey: ['committees-dropdown'],
    queryFn: () => api.get('/committee/committees').then((r) => r.data.data),
    enabled: !!app,
  })

  const { data: projectDetail } = useQuery({
    queryKey: ['project-detail', app?.project_id],
    queryFn: () => api.get(`/core/projects/${app.project_id}`).then((r) => r.data.data),
    enabled: !!app?.project_id && step >= 2,
  })

  const { data: documents, refetch: refetchDocs } = useQuery({
    queryKey: ['application-documents', id],
    queryFn: () => api.get(`/documents/entity/Application/${id}`).then((r) => r.data.data),
    enabled: !!id,
  })

  const { register, handleSubmit, watch, setValue, formState: { isSubmitting } } = useForm({
    defaultValues: {
      application_type: app?.application_type || 'INITIAL',
      target_committee_id: app?.target_committee_id ? String(app.target_committee_id) : '',
      priority_level: app?.priority_level || '',
      remarks: app?.remarks || '',
    },
    values: app ? {
      application_type: app.application_type || 'INITIAL',
      target_committee_id: app.target_committee_id ? String(app.target_committee_id) : '',
      priority_level: app.priority_level || '',
      remarks: app.remarks || '',
    } : undefined,
  })

  const updateMutation = useMutation({
    mutationFn: (body: any) => api.put(`/core/applications/${id}`, body),
    onSuccess: () => {
      toast.success(t('applications.draftSaved'))
      queryClient.invalidateQueries({ queryKey: ['applications'] })
      queryClient.invalidateQueries({ queryKey: ['application', id] })
      navigate('/applications')
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('applications.createFailed')),
  })

  const submitMutation = useMutation({
    mutationFn: () => api.post(`/core/applications/${id}/submit`, {}),
    onSuccess: () => {
      toast.success(t('applications.created'))
      queryClient.invalidateQueries({ queryKey: ['applications'] })
      queryClient.invalidateQueries({ queryKey: ['application', id] })
      navigate('/applications')
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('applications.createFailed')),
  })

  const uploadMutation = useMutation({
    mutationFn: (formData: FormData) => api.post('/documents', formData, { headers: { 'Content-Type': 'multipart/form-data' } }),
    onSuccess: () => {
      toast.success(t('applications.attachmentUploaded'))
      setUploadFile(null)
      setUploadTitle('')
      refetchDocs()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('applications.attachmentUploadFailed')),
  })

  const deleteMutation = useMutation({
    mutationFn: (docId: number) => api.delete(`/documents/${docId}`),
    onSuccess: () => { toast.success(t('documents.deleted')); refetchDocs(); setDeleteTarget(null) },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  function handleUpload() {
    if (!uploadFile) { toast.error(t('applications.fileRequired')); return }
    if (!uploadTitle.trim()) { toast.error(t('applications.titleRequired')); return }
    const fd = new FormData()
    fd.append('file', uploadFile)
    fd.append('document_title', uploadTitle)
    fd.append('entity_type', 'Application')
    fd.append('entity_id', String(id))
    uploadMutation.mutate(fd)
  }

  function onSave(data: any) {
    updateMutation.mutate(data)
  }

  function onSubmitApp() {
    submitMutation.mutate()
  }

  if (isLoading) return <PageSkeleton />
  if (!app) return <p className="text-red-500">{t('applications.notFound')}</p>
  if (app.current_status !== 'DRAFT') {
    return (
      <div className="text-center py-12">
        <p className="text-slate-500 mb-4">{t('applications.draftInfo')}</p>
        <Button onClick={() => navigate(`/applications/${id}`)}>{t('applications.back')}</Button>
      </div>
    )
  }

  const stepLabels = STEPS.map(s => t(s.titleKey))

  return (
    <div className="max-w-3xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">{t('applications.editDraft')} — {app.application_number}</h1>

      <div className="flex items-center gap-2 mb-8">
        {STEPS.map((s, i) => {
          const isActive = step === s.key
          const isDone = step > s.key
          return (
            <div key={s.key} className="flex items-center gap-2 flex-1">
              <div className={`flex items-center gap-2 px-3 py-1.5 rounded-full text-sm ${
                isActive ? 'bg-blue-100 text-blue-700 font-medium' :
                isDone ? 'bg-green-100 text-green-700' : 'bg-slate-100 text-slate-400'
              }`}>
                {isDone ? <Check className="w-3.5 h-3.5" /> : <span>{s.key}</span>}
                <span className="hidden sm:inline">{t(s.titleKey)}</span>
              </div>
              {i < STEPS.length - 1 && <div className="flex-1 h-px bg-slate-200" />}
            </div>
          )
        })}
      </div>

      <form onSubmit={handleSubmit(onSave)}>
        {step === 1 && (
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">{t('applications.wizardStep1')}</CardTitle>
              <CardDescription>{t('applications.wizardStep1Desc')}</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-1">{t('applications.project')}</label>
                <input type="text" value={app.project_title || ''} disabled className="w-full p-2 border rounded text-sm bg-slate-50" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('applications.applicationType')}</label>
                <select {...register('application_type')} className="w-full p-2 border rounded text-sm">
                  <option value="INITIAL">{t('applications.initialReview')}</option>
                  <option value="AMENDMENT">{t('applications.amendment')}</option>
                  <option value="RENEWAL">{t('applications.renewal')}</option>
                  <option value="EXPEDITED">{t('applications.expedited')}</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('applications.targetCommittee')}</label>
                <select {...register('target_committee_id')} className="w-full p-2 border rounded text-sm">
                  <option value="">{t('applications.selectCommittee')}</option>
                  {(committees || []).map((c: any) => (
                    <option key={c.id} value={c.id}>{c.committee_name_ar}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('applications.notes')}</label>
                <textarea {...register('remarks')} className="w-full p-2 border rounded text-sm" rows={3} />
              </div>
            </CardContent>
          </Card>
        )}

        {step === 2 && (
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">{t('applications.wizardStep2')}</CardTitle>
              <CardDescription>{t('applications.wizardStep2Desc')}</CardDescription>
            </CardHeader>
            <CardContent>
              {projectDetail ? (
                <dl className="grid grid-cols-2 gap-4 text-sm">
                  <div className="col-span-2">
                    <dt className="text-slate-500 text-xs">{t('applications.titleAr')}</dt>
                    <dd className="font-medium">{projectDetail.title_ar}</dd>
                  </div>
                  <div className="col-span-2">
                    <dt className="text-slate-500 text-xs">{t('applications.titleEn')}</dt>
                    <dd className="font-medium">{projectDetail.title_en || '\u2014'}</dd>
                  </div>
                  <div>
                    <dt className="text-slate-500 text-xs">{t('applications.projectCode')}</dt>
                    <dd className="font-medium">{projectDetail.project_code}</dd>
                  </div>
                  <div>
                    <dt className="text-slate-500 text-xs">{t('applications.researchCategory')}</dt>
                    <dd className="font-medium">{projectDetail.research_category || '\u2014'}</dd>
                  </div>
                  <div>
                    <dt className="text-slate-500 text-xs">{t('applications.riskLevel')}</dt>
                    <dd className="font-medium">{projectDetail.risk_level || '\u2014'}</dd>
                  </div>
                  <div className="col-span-2">
                    <dt className="text-slate-500 text-xs">{t('applications.objectives')}</dt>
                    <dd className="font-medium text-sm whitespace-pre-wrap">{projectDetail.objectives || '\u2014'}</dd>
                  </div>
                </dl>
              ) : (
                <p className="text-sm text-slate-400">{t('common.loading')}</p>
              )}
            </CardContent>
          </Card>
        )}

        {step === 3 && (
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">{t('applications.wizardStep3')}</CardTitle>
              <CardDescription>{t('applications.wizardStep3Desc')}</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="border-2 border-dashed border-slate-200 rounded-lg p-6">
                <div className="flex flex-col items-center gap-3">
                  <FileUp className="w-8 h-8 text-slate-300" />
                  <p className="text-sm text-slate-500">{t('applications.selectFile')}</p>
                  <input type="file" ref={fileRef} onChange={(e) => setUploadFile(e.target.files?.[0] || null)} className="text-sm" />
                </div>
                {uploadFile && (
                  <p className="text-xs text-slate-500 mt-2 text-center">{uploadFile.name} ({(uploadFile.size / 1024).toFixed(1)} KB)</p>
                )}
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('documents.titleLabel')}</label>
                <input type="text" value={uploadTitle} onChange={(e) => setUploadTitle(e.target.value)}
                  className="w-full p-2 border rounded text-sm" placeholder={t('documents.titlePlaceholder')} />
              </div>
              <Button type="button" variant="outline" className="w-full" onClick={handleUpload} disabled={uploadMutation.isPending}>
                <FileUp className="w-4 h-4 mr-1" /> {uploadMutation.isPending ? t('common.uploading') : t('applications.uploadAttachment')}
              </Button>

              {documents && documents.length > 0 && (
                <div className="space-y-2 mt-4">
                  <p className="text-sm font-medium">{t('applications.attachments')}</p>
                  {documents.map((d: any) => (
                    <div key={d.id} className="flex items-center justify-between text-sm border rounded p-2">
                      <div className="flex-1 min-w-0">
                        <p className="font-medium truncate">{d.document_title}</p>
                        <p className="text-xs text-slate-400">{d.file_name}</p>
                      </div>
                      <button type="button" onClick={() => setDeleteTarget(d.id)} className="text-red-500 hover:text-red-700 ml-2">
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>
        )}

        {step === 4 && (
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">{t('applications.wizardStep4')}</CardTitle>
              <CardDescription>{t('applications.wizardStep4Desc')}</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <dl className="grid grid-cols-2 gap-3 text-sm bg-slate-50 p-4 rounded-lg">
                <div>
                  <dt className="text-slate-500 text-xs">{t('applications.number')}</dt>
                  <dd className="font-medium">{app.application_number}</dd>
                </div>
                <div>
                  <dt className="text-slate-500 text-xs">{t('applications.project')}</dt>
                  <dd className="font-medium">{app.project_title}</dd>
                </div>
                <div>
                  <dt className="text-slate-500 text-xs">{t('applications.type')}</dt>
                  <dd className="font-medium">{t(`applications.${watch('application_type') === 'INITIAL' ? 'initialReview' : watch('application_type').toLowerCase()}`)}</dd>
                </div>
                <div>
                  <dt className="text-slate-500 text-xs">{t('applications.status')}</dt>
                  <dd className="font-medium text-amber-600">{t('applications.draft')}</dd>
                </div>
                <div>
                  <dt className="text-slate-500 text-xs">{t('applications.committee')}</dt>
                  <dd className="font-medium">{(committees || []).find((c: any) => String(c.id) === watch('target_committee_id'))?.committee_name_ar || '\u2014'}</dd>
                </div>
              </dl>
              <p className="text-xs text-slate-500">{t('applications.draftInfo')}</p>
            </CardContent>
          </Card>
        )}

        <div className="flex items-center justify-between mt-6">
          <div>
            {step > 1 && (
              <Button type="button" variant="outline" onClick={() => setStep((step - 1) as Step)}>
                <ChevronLeft className="w-4 h-4 mr-1" /> {t('applications.prev')}
              </Button>
            )}
          </div>
          <div className="flex items-center gap-3">
            {step < 4 ? (
              <Button type="button" onClick={() => setStep((step + 1) as Step)}>
                {t('applications.next')} <ChevronRight className="w-4 h-4 ml-1" />
              </Button>
            ) : (
              <div className="flex items-center gap-3">
                <Button type="submit" variant="outline" disabled={updateMutation.isPending}>
                  <Save className="w-4 h-4 mr-1" /> {t('applications.saveAsDraft')}
                </Button>
                <Button type="button" disabled={submitMutation.isPending} onClick={onSubmitApp}>
                  <Send className="w-4 h-4 mr-1" /> {submitMutation.isPending ? t('applications.submitting') : t('applications.submit')}
                </Button>
              </div>
            )}
          </div>
        </div>
      </form>
    </div>
  )
}