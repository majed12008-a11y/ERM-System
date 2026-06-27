/*
 * صفحة تقييمات الاعتماد: إنشاء وإدارة تقييمات
 * أداء اللجنة وفق معايير الاعتماد.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import { useParams, useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, Plus, Eye } from 'lucide-react'
import { z } from 'zod'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { Button } from '../../components/ui/button'
import { Label } from '../../components/ui/label'
import { useRole } from '../../hooks/usePermission'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from '../../components/ui/dialog'

const createAssessmentSchema = z.object({
  overall_decision: z.string({ message: 'Overall decision is required' }).min(1),
  overall_justification: z.string().optional().default(''),
  items: z.array(z.object({
    standard_version_id: z.coerce.number(),
    is_met: z.boolean().default(false),
    score: z.coerce.number().int().min(1).max(5).optional(),
    findings: z.string().optional().default(''),
  })),
})

type AssessmentFormData = z.input<typeof createAssessmentSchema>

const decisionOptions = [
  { value: 'RECOMMEND_APPROVE', labelKey: 'status.RECOMMEND_APPROVE', defaultLabel: 'Recommend Approve' },
  { value: 'RECOMMEND_CONDITIONAL', labelKey: 'status.RECOMMEND_CONDITIONAL', defaultLabel: 'Recommend Conditional' },
  { value: 'RECOMMEND_REJECT', labelKey: 'status.RECOMMEND_REJECT', defaultLabel: 'Recommend Reject' },
  { value: 'DEFER', labelKey: 'status.DEFER', defaultLabel: 'Defer' },
]

const scoreDescriptions = [
  { value: 1, label: 'Non-Compliant' },
  { value: 2, label: 'Partially Compliant' },
  { value: 3, label: 'Compliant' },
  { value: 4, label: 'Exceeds Requirements' },
]

export default function AssessmentsList() {
  const { t } = useTranslation()
  const { id: cycleId } = useParams()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const canMutate = useRole('SUPER_ADMIN', 'ETHICS_ADMIN')

  const [createOpen, setCreateOpen] = useState(false)
  const [viewItem, setViewItem] = useState<any>(null)
  const [viewOpen, setViewOpen] = useState(false)

  const createForm = useForm<AssessmentFormData>({
    defaultValues: { overall_decision: '', overall_justification: '', items: [] },
  })

  const { data: cycle } = useQuery({
    queryKey: ['accreditation-cycle', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const { data: assessments, isLoading } = useQuery({
    queryKey: ['assessments', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}/assessments`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const { data: standards } = useQuery({
    queryKey: ['standards-active'],
    queryFn: () => api.get('/committee/accreditation/standards?active_only=true').then(r => r.data.data),
  })

  const scores = (assessments || []).map((a: any) => a.overall_score).filter(Boolean)
  const avgScore = scores.length > 0 ? Math.round(scores.reduce((a: number, b: number) => a + b, 0) / scores.length) : 0
  const completedCount = (assessments || []).filter((a: any) => a.items?.length > 0).length

  const createMutation = useMutation({
    mutationFn: (body: AssessmentFormData) =>
      api.post(`/committee/accreditation/cycles/${cycleId}/assessments`, body),
    onSuccess: () => {
      toast.success(t('assessment.created'))
      queryClient.invalidateQueries({ queryKey: ['assessments', cycleId] })
      setCreateOpen(false)
      createForm.reset()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('assessment.createFailed')),
  })

  function openCreate() {
    createForm.reset({ overall_decision: '', overall_justification: '', items: (standards || []).map((s: any) => ({
      standard_version_id: s.id,
      is_met: false,
      score: undefined,
      findings: '',
    })) })
    setCreateOpen(true)
  }

  function onSubmitCreate(data: AssessmentFormData) {
    const hasScore = data.items.some(i => i.score !== undefined && i.score !== null)
    createMutation.mutate({
      ...data,
      items: hasScore ? data.items : undefined,
    })
  }

  function viewAssessment(item: any) {
    setViewItem(item)
    setViewOpen(true)
  }

  const totalScore = viewItem?.items?.reduce((s: number, i: any) => s + (i.score || 0), 0) ?? 0
  const maxScore = (viewItem?.items?.length || 1) * 4
  const pctScore = maxScore > 0 ? Math.round((totalScore / maxScore) * 100) : 0

  return (
    <div>
      <button
        onClick={() => navigate(`/admin/accreditation/cycles/${cycleId}`)}
        className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4"
      >
        <ArrowLeft className="w-4 h-4" /> {t('assessment.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">{t('assessment.title')}</h1>
          {cycle && (
            <p className="text-sm text-slate-500 mt-1">
              {cycle.committee_name_ar} — {t('accreditation.cycleNumber', { number: cycle.cycle_number })}
            </p>
          )}
        </div>
        {canMutate && (
          <button
            onClick={openCreate}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm"
          >
            <Plus className="w-4 h-4" /> {t('assessment.new')}
          </button>
        )}
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-slate-500 text-xs mb-1">{t('assessment.total')}</div>
          <p className="text-xl font-bold">{(assessments || []).length}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-emerald-600 text-xs mb-1">{t('assessment.completed')}</div>
          <p className="text-xl font-bold text-emerald-700">{completedCount}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-amber-600 text-xs mb-1">{t('assessment.pending')}</div>
          <p className="text-xl font-bold text-amber-700">{(assessments || []).length - completedCount}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-blue-600 text-xs mb-1">{t('assessment.avgScore')}</div>
          <p className="text-xl font-bold text-blue-700">{avgScore}%</p>
        </div>
      </div>

      <DataTable
        searchable
        loading={isLoading}
        columns={[
          { key: 'assessor_name', label: t('assessment.assessor'), sortable: true },
          { key: 'overall_decision', label: t('assessment.overallDecision'), filterable: true, sortable: true,
            render: (i: any) => <StatusBadge status={i.overall_decision} /> },
          { key: 'overall_score', label: t('assessment.score'), sortable: true,
            render: (i: any) => i.overall_score ? `${i.overall_score}%` : '-' },
          { key: 'assessed_at', label: t('assessment.date'), sortable: true,
            render: (i: any) => new Date(i.assessed_at).toLocaleDateString() },
          ...([
            { key: 'actions', label: t('assessment.actions'), render: (i: any) => (
              <div className="flex items-center gap-1" onClick={e => e.stopPropagation()}>
                <button onClick={() => viewAssessment(i)}
                  className="text-slate-400 hover:text-blue-600 p-1" title={t('assessment.view')}>
                  <Eye className="w-4 h-4" />
                </button>
              </div>
            ),
            },
          ] as any),
        ]}
        data={assessments || []}
        onRowClick={(item: any) => viewAssessment(item)}
        emptyMessage={t('assessment.empty')}
      />

      <Dialog open={createOpen} onOpenChange={setCreateOpen}>
        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{t('assessment.create')}</DialogTitle>
          </DialogHeader>
          <form onSubmit={createForm.handleSubmit(onSubmitCreate)} className="space-y-4">
            <div className="space-y-2">
              <Label>{t('assessment.overallDecision')}</Label>
              <select
                {...createForm.register('overall_decision')}
                className="w-full p-2 border rounded text-sm"
              >
                <option value="">{t('assessment.selectDecision')}</option>
                {decisionOptions.map((opt) => (
                  <option key={opt.value} value={opt.value}>
                    {t(opt.labelKey, { defaultValue: opt.defaultLabel })}
                  </option>
                ))}
              </select>
              {createForm.formState.errors.overall_decision && (
                <p className="text-red-500 text-xs">{createForm.formState.errors.overall_decision.message}</p>
              )}
            </div>

            <div className="space-y-2">
              <Label>{t('assessment.overallJustification')}</Label>
              <textarea
                {...createForm.register('overall_justification')}
                className="w-full p-2 border rounded text-sm resize-none"
                rows={2}
              />
            </div>

            <div>
              <Label className="mb-2 block">{t('assessment.standard')}</Label>
              {(standards || []).length === 0 ? (
                <p className="text-sm text-slate-500">{t('assessment.noStandards')}</p>
              ) : (
                <div className="space-y-3 max-h-80 overflow-y-auto border rounded p-3">
                  {(standards || []).map((s: any, index: number) => (
                    <div key={s.id} className="p-3 bg-slate-50 rounded text-sm space-y-2">
                      <div className="font-medium text-xs text-slate-600">{s.name_ar || s.name_en} ({s.code})</div>
                      <div className="flex flex-wrap items-center gap-4">
                        <label className="flex items-center gap-1.5 text-xs">
                          <input
                            type="checkbox"
                            {...createForm.register(`items.${index}.is_met`)}
                          />
                          {t('assessment.isMet')}
                        </label>
                        <select
                          {...createForm.register(`items.${index}.score`, { valueAsNumber: true })}
                          className="p-1 border rounded text-xs"
                        >
                          <option value="">{t('assessment.scoreLabel')}</option>
                          {scoreDescriptions.map((sd) => (
                            <option key={sd.value} value={sd.value}>{sd.value} — {sd.label}</option>
                          ))}
                        </select>
                      </div>
                      <textarea
                        {...createForm.register(`items.${index}.findings`)}
                        placeholder={t('assessment.findings')}
                        className="w-full p-1.5 border rounded text-xs resize-none"
                        rows={1}
                      />
                    </div>
                  ))}
                </div>
              )}
            </div>

            <div className="flex gap-3">
              <Button type="submit" disabled={createMutation.isPending}>
                {createMutation.isPending ? t('common.creating') : t('common.create')}
              </Button>
              <Button type="button" variant="outline" onClick={() => setCreateOpen(false)}>
                {t('common.cancel')}
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>

      <Dialog open={viewOpen} onOpenChange={(open) => { if (!open) { setViewOpen(false); setViewItem(null) } }}>
        <DialogContent className="max-w-2xl max-h-[90vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{t('assessment.view')}</DialogTitle>
            {viewItem && (
              <span className="text-sm text-slate-500 block">
                {viewItem.assessor_name} — <StatusBadge status={viewItem.overall_decision} />
              </span>
            )}
          </DialogHeader>
          {viewItem && (
            <div className="space-y-4">
              <div className="grid grid-cols-3 gap-3">
                <div className="bg-slate-50 rounded p-3 text-center">
                  <div className="text-xs text-slate-500">{t('assessment.score')}</div>
                  <p className="text-lg font-bold">{viewItem.overall_score ?? '-'}%</p>
                </div>
                <div className="bg-slate-50 rounded p-3 text-center">
                  <div className="text-xs text-slate-500">{t('assessment.overallDecision')}</div>
                  <p className="text-lg font-bold"><StatusBadge status={viewItem.overall_decision} /></p>
                </div>
                <div className="bg-slate-50 rounded p-3 text-center">
                  <div className="text-xs text-slate-500">{t('assessment.date')}</div>
                  <p className="text-lg font-bold">{new Date(viewItem.assessed_at).toLocaleDateString()}</p>
                </div>
              </div>

              {viewItem.overall_justification && (
                <div>
                  <Label>{t('assessment.overallJustification')}</Label>
                  <p className="text-sm text-slate-700 mt-1">{viewItem.overall_justification}</p>
                </div>
              )}

              <div>
                <Label className="mb-2 block">{t('assessment.standard')}</Label>
                {(!viewItem.items || viewItem.items.length === 0) ? (
                  <p className="text-sm text-slate-500">{t('assessment.noStandards')}</p>
                ) : (
                  <div className="space-y-2">
                    {viewItem.items.map((item: any, i: number) => (
                      <div key={item.id || i} className="p-3 bg-slate-50 rounded text-sm">
                        <div className="flex items-center justify-between">
                          <span className="font-medium text-xs">{item.name_ar || item.code}</span>
                          <div className="flex items-center gap-3">
                            {item.is_met !== undefined && (
                              <span className={`text-xs px-2 py-0.5 rounded ${item.is_met ? 'bg-emerald-100 text-emerald-700' : 'bg-red-100 text-red-700'}`}>
                                {item.is_met ? t('common.yes') : t('common.no')}
                              </span>
                            )}
                            {item.score !== undefined && item.score !== null && (
                              <span className="text-xs font-bold text-slate-600">{item.score}/4</span>
                            )}
                          </div>
                        </div>
                        {item.findings && (
                          <p className="text-xs text-slate-500 mt-1">{item.findings}</p>
                        )}
                      </div>
                    ))}
                    <div className="text-xs text-slate-500 text-right pt-1">
                      {t('assessment.score')}: {totalScore}/{maxScore} ({pctScore}%)
                    </div>
                  </div>
                )}
              </div>
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  )
}
