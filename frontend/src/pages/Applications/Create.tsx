import { useState, useRef } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { z } from 'zod'
import api from '../../api/client'
import { applicationCreateSchema } from '../../lib/schemas'
import { Button } from '../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '../../components/ui/card'
import { FileUp, Check, ChevronRight, ChevronLeft, Save, Send, X } from 'lucide-react'

type ApplicationFormData = z.input<typeof applicationCreateSchema>
type Step = 1 | 2 | 3 | 4

const STEPS: { key: Step; titleKey: string; descKey: string }[] = [
  { key: 1, titleKey: 'applications.wizardStep1', descKey: 'applications.wizardStep1Desc' },
  { key: 2, titleKey: 'applications.wizardStep2', descKey: 'applications.wizardStep2Desc' },
  { key: 3, titleKey: 'applications.wizardStep3', descKey: 'applications.wizardStep3Desc' },
  { key: 4, titleKey: 'applications.wizardStep4', descKey: 'applications.wizardStep4Desc' },
]

interface PendingFile {
  file: File
  title: string
}

export default function ApplicationCreate() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [step, setStep] = useState<Step>(1)
  const [selectedProject, setSelectedProject] = useState<any>(null)
  const fileRef = useRef<HTMLInputElement>(null)
  const [pendingFiles, setPendingFiles] = useState<PendingFile[]>([])
  const [uploadTitle, setUploadTitle] = useState('')

  const { register, handleSubmit, watch, setValue, formState: { errors, isSubmitting } } = useForm<ApplicationFormData>({
    resolver: zodResolver(applicationCreateSchema),
    defaultValues: { project_id: '', application_type: 'INITIAL', target_committee_id: '' },
  })

  const selectedProjectId = watch('project_id')

  const { data: projects, isLoading: projectsLoading } = useQuery({
    queryKey: ['projects-dropdown'],
    queryFn: () => api.get('/core/projects').then((r) => r.data.data),
  })

  const { data: committees } = useQuery({
    queryKey: ['committees-dropdown'],
    queryFn: () => api.get('/committee/committees').then((r) => r.data.data),
  })

  const { data: projectDetail } = useQuery({
    queryKey: ['project-detail', selectedProjectId],
    queryFn: () => api.get(`/core/projects/${selectedProjectId}`).then((r) => r.data.data),
    enabled: !!selectedProjectId && step >= 2,
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/core/applications?save_as_draft=false', body),
    onSuccess: (res) => {
      const newId = res.data.data?.id
      uploadPendingFiles(newId)
      toast.success(t('applications.created'))
      queryClient.invalidateQueries({ queryKey: ['applications'] })
      navigate('/applications')
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('applications.createFailed')),
  })

  const saveDraftMutation = useMutation({
    mutationFn: (body: any) => api.post('/core/applications?save_as_draft=true', body),
    onSuccess: (res) => {
      const newId = res.data.data?.id
      uploadPendingFiles(newId)
      toast.success(t('applications.draftSaved'))
      queryClient.invalidateQueries({ queryKey: ['applications'] })
      navigate('/applications')
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('applications.createFailed')),
  })

  function uploadPendingFiles(appId: number) {
    if (!appId || pendingFiles.length === 0) return
    pendingFiles.forEach((pf) => {
      const fd = new FormData()
      fd.append('file', pf.file)
      fd.append('document_title', pf.title)
      fd.append('entity_type', 'Application')
      fd.append('entity_id', String(appId))
      api.post('/documents', fd, { headers: { 'Content-Type': 'multipart/form-data' } }).catch(() => {})
    })
  }

  function addPendingFile() {
    const fileInput = fileRef.current
    if (!fileInput?.files?.[0]) { toast.error(t('applications.fileRequired')); return }
    if (!uploadTitle.trim()) { toast.error(t('applications.titleRequired')); return }
    setPendingFiles([...pendingFiles, { file: fileInput.files[0], title: uploadTitle.trim() }])
    fileInput.value = ''
    setUploadTitle('')
  }

  function removePendingFile(idx: number) {
    setPendingFiles(pendingFiles.filter((_, i) => i !== idx))
  }

  const noProjects = !projectsLoading && projects && projects.length === 0

  function handleProjectChange(e: React.ChangeEvent<HTMLSelectElement>) {
    const val = e.target.value
    setValue('project_id', val)
    const proj = (projects || []).find((p: any) => String(p.id) === val)
    setSelectedProject(proj || null)
  }

  function onFinish(data: ApplicationFormData) {
    createMutation.mutate(data)
  }

  function onSaveDraft(data: ApplicationFormData) {
    saveDraftMutation.mutate(data)
  }

  function validateStep1(): boolean {
    if (!selectedProjectId) { toast.error(t('applications.selectProject')); return false }
    if (!watch('target_committee_id')) { toast.error(t('applications.selectCommittee')); return false }
    return true
  }

  return (
    <div className="max-w-3xl mx-auto">
      <h1 className="text-2xl font-bold mb-6">{t('applications.new')}</h1>

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

      <form onSubmit={handleSubmit(onFinish)}>
        {step === 1 && (
          <Card>
            <CardHeader>
              <CardTitle className="text-lg">{t('applications.wizardStep1')}</CardTitle>
              <CardDescription>{t('applications.wizardStep1Desc')}</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div>
                <label className="block text-sm font-medium mb-1">{t('applications.project')}</label>
                {noProjects ? (
                  <div className="p-3 bg-yellow-50 border border-yellow-200 rounded text-sm text-yellow-800 space-y-2">
                    <p>{t('applications.noProjects')}</p>
                    <a href="/projects/create" className="text-blue-600 hover:underline font-medium">{t('applications.createProject')}</a>
                  </div>
                ) : (
                  <select value={selectedProjectId} onChange={handleProjectChange} className="w-full p-2 border rounded text-sm" disabled={projectsLoading}>
                    <option value="">{t('applications.selectProject')}</option>
                    {(projects || []).map((p: any) => (
                      <option key={p.id} value={p.id}>{p.title_ar}</option>
                    ))}
                  </select>
                )}
                {errors.project_id && <p className="text-red-500 text-xs mt-1">{errors.project_id.message}</p>}
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
                {errors.target_committee_id && <p className="text-red-500 text-xs mt-1">{errors.target_committee_id.message}</p>}
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
                  <input type="file" ref={fileRef} className="text-sm" />
                </div>
              </div>
              <div className="flex gap-2">
                <input type="text" value={uploadTitle} onChange={(e) => setUploadTitle(e.target.value)}
                  className="flex-1 p-2 border rounded text-sm" placeholder={t('documents.titlePlaceholder')} />
                <Button type="button" variant="outline" onClick={addPendingFile}>
                  <FileUp className="w-4 h-4 mr-1" /> {t('applications.uploadAttachment')}
                </Button>
              </div>

              {pendingFiles.length > 0 && (
                <div className="space-y-2 mt-4">
                  <p className="text-sm font-medium">{t('applications.attachments')} ({pendingFiles.length})</p>
                  {pendingFiles.map((pf, i) => (
                    <div key={i} className="flex items-center justify-between text-sm border rounded p-2">
                      <div className="flex-1 min-w-0">
                        <p className="font-medium truncate">{pf.title}</p>
                        <p className="text-xs text-slate-400">{pf.file.name} ({(pf.file.size / 1024).toFixed(1)} KB)</p>
                      </div>
                      <button type="button" onClick={() => removePendingFile(i)} className="text-red-500 hover:text-red-700 ml-2">
                        <X className="w-4 h-4" />
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
              {selectedProject && (
                <dl className="grid grid-cols-2 gap-3 text-sm bg-slate-50 p-4 rounded-lg">
                  <div>
                    <dt className="text-slate-500 text-xs">{t('applications.project')}</dt>
                    <dd className="font-medium">{selectedProject.title_ar}</dd>
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
                  {pendingFiles.length > 0 && (
                    <div className="col-span-2">
                      <dt className="text-slate-500 text-xs">{t('applications.attachments')}</dt>
                      <dd className="font-medium">{pendingFiles.length} file(s)</dd>
                    </div>
                  )}
                </dl>
              )}
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
              <Button type="button" onClick={() => {
                if (step === 1 && !validateStep1()) return
                setStep((step + 1) as Step)
              }}>
                {t('applications.next')} <ChevronRight className="w-4 h-4 ml-1" />
              </Button>
            ) : (
              <div className="flex items-center gap-3">
                <Button type="button" variant="outline" onClick={handleSubmit(onSaveDraft)} disabled={saveDraftMutation.isPending}>
                  <Save className="w-4 h-4 mr-1" /> {t('applications.saveAsDraft')}
                </Button>
                <Button type="submit" disabled={createMutation.isPending || isSubmitting}>
                  <Send className="w-4 h-4 mr-1" /> {createMutation.isPending ? t('applications.submitting') : t('applications.submit')}
                </Button>
              </div>
            )}
          </div>
        </div>
      </form>
    </div>
  )
}