/*
 * صفحة شروط الاعتماد: إدارة الشروط المطلوبة
 * لتحقيق الاعتماد مع متابعة حالة كل شرط.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import { useParams, useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, Plus, CheckCircle } from 'lucide-react'
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

const createConditionSchema = z.object({
  condition_text: z.string({ message: 'Condition text is required' }).min(1),
  due_date: z.string({ message: 'Due date is required' }).min(1),
  severity: z.string().optional().default('MAJOR'),
  assessment_id: z.coerce.number().positive().optional(),
  standard_version_id: z.coerce.number().positive().optional(),
})

const resolveConditionSchema = z.object({
  status: z.string({ message: 'Status is required' }).min(1),
})

type CreateConditionForm = z.input<typeof createConditionSchema>
type ResolveConditionForm = z.input<typeof resolveConditionSchema>

const severityOptions = [
  { value: 'MINOR', labelKey: 'status.MINOR', defaultLabel: 'Minor', class: 'bg-yellow-100 text-yellow-700' },
  { value: 'MAJOR', labelKey: 'status.MAJOR', defaultLabel: 'Major', class: 'bg-orange-100 text-orange-700' },
  { value: 'CRITICAL', labelKey: 'status.CRITICAL', defaultLabel: 'Critical', class: 'bg-red-100 text-red-700' },
]

export default function ConditionsList() {
  const { t } = useTranslation()
  const { id: cycleId } = useParams()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const canMutate = useRole('SUPER_ADMIN', 'ETHICS_ADMIN')

  const [createOpen, setCreateOpen] = useState(false)
  const [resolveItem, setResolveItem] = useState<any>(null)
  const [resolveOpen, setResolveOpen] = useState(false)

  const createForm = useForm<CreateConditionForm>({
    defaultValues: { condition_text: '', due_date: '', severity: 'MAJOR' },
  })

  const resolveForm = useForm<ResolveConditionForm>({
    defaultValues: { status: '' },
  })

  const { data: cycle } = useQuery({
    queryKey: ['accreditation-cycle', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const { data: conditions, isLoading } = useQuery({
    queryKey: ['conditions', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}/conditions`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const { data: standards } = useQuery({
    queryKey: ['standards-active'],
    queryFn: () => api.get('/committee/accreditation/standards?active_only=true').then(r => r.data.data),
  })

  const { data: assessments } = useQuery({
    queryKey: ['assessments', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}/assessments`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const summary = {
    total: (conditions || []).length,
    open: (conditions || []).filter((c: any) => c.status === 'OPEN' || c.status === 'OVERDUE').length,
    overdue: (conditions || []).filter((c: any) => c.status === 'OVERDUE').length,
    resolved: (conditions || []).filter((c: any) => c.status === 'MET' || c.status === 'WAIVED').length,
  }

  const createMutation = useMutation({
    mutationFn: (body: CreateConditionForm) =>
      api.post(`/committee/accreditation/cycles/${cycleId}/conditions`, body),
    onSuccess: () => {
      toast.success(t('condition.created'))
      queryClient.invalidateQueries({ queryKey: ['conditions', cycleId] })
      setCreateOpen(false)
      createForm.reset()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('condition.createFailed')),
  })

  const resolveMutation = useMutation({
    mutationFn: ({ id, body }: { id: number; body: ResolveConditionForm }) =>
      api.patch(`/committee/accreditation/conditions/${id}/status`, body),
    onSuccess: () => {
      toast.success(t('condition.statusUpdated'))
      queryClient.invalidateQueries({ queryKey: ['conditions', cycleId] })
      setResolveOpen(false)
      setResolveItem(null)
      resolveForm.reset()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('condition.statusUpdateFailed')),
  })

  function openCreate() {
    createForm.reset({ condition_text: '', due_date: '', severity: 'MAJOR' })
    setCreateOpen(true)
  }

  function onSubmitCreate(data: CreateConditionForm) {
    createMutation.mutate(data)
  }

  function openResolve(item: any, status: string) {
    setResolveItem(item)
    resolveForm.setValue('status', status)
    setResolveOpen(true)
  }

  function onSubmitResolve(data: ResolveConditionForm) {
    if (!resolveItem) return
    resolveMutation.mutate({ id: resolveItem.id, body: data })
  }

  function canResolve(item: any): boolean {
    if (!canMutate) return false
    return item.status === 'OPEN' || item.status === 'OVERDUE'
  }

  return (
    <div>
      <button
        onClick={() => navigate(`/admin/accreditation/cycles/${cycleId}`)}
        className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4"
      >
        <ArrowLeft className="w-4 h-4" /> {t('condition.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">{t('condition.title')}</h1>
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
            <Plus className="w-4 h-4" /> {t('condition.new')}
          </button>
        )}
      </div>

      <div className="grid grid-cols-2 md:grid-cols-4 gap-3 mb-6">
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-slate-500 text-xs mb-1">{t('condition.total')}</div>
          <p className="text-xl font-bold">{summary.total}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-amber-600 text-xs mb-1">{t('condition.open')}</div>
          <p className="text-xl font-bold text-amber-700">{summary.open}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-red-600 text-xs mb-1">{t('condition.overdue')}</div>
          <p className="text-xl font-bold text-red-700">{summary.overdue}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-emerald-600 text-xs mb-1">{t('condition.resolved')}</div>
          <p className="text-xl font-bold text-emerald-700">{summary.resolved}</p>
        </div>
      </div>

      <DataTable
        searchable
        loading={isLoading}
        columns={[
          { key: 'condition_text', label: t('condition.condition'), sortable: true,
            render: (i: any) => (
              <span className="max-w-xs truncate block" title={i.condition_text}>
                {i.condition_text}
              </span>
            ),
          },
          { key: 'severity', label: t('condition.severity'), filterable: true, sortable: true,
            render: (i: any) => {
              const opt = severityOptions.find(o => o.value === i.severity)
              return (
                <span className={`text-xs px-2 py-0.5 rounded font-medium ${opt?.class || 'bg-slate-100 text-slate-700'}`}>
                  {opt ? t(opt.labelKey, { defaultValue: opt.defaultLabel }) : i.severity}
                </span>
              )
            },
          },
          { key: 'standard_name', label: t('condition.standard'), sortable: true,
            render: (i: any) => i.standard_name || i.standard_code || '-' },
          { key: 'due_date', label: t('condition.dueDate'), sortable: true,
            render: (i: any) => new Date(i.due_date).toLocaleDateString() },
          { key: 'status', label: t('condition.status'), filterable: true, sortable: true,
            render: (i: any) => <StatusBadge status={i.status} /> },
          ...([
            { key: 'actions', label: t('condition.actions'), render: (i: any) => (
              <div className="flex items-center gap-1" onClick={e => e.stopPropagation()}>
                {canResolve(i) && (
                  <button
                    onClick={() => openResolve(i, 'MET')}
                    className="flex items-center gap-1 text-xs text-emerald-600 hover:text-emerald-800 px-2 py-1 rounded border border-emerald-200 hover:bg-emerald-50"
                  >
                    <CheckCircle className="w-3 h-3" />
                    {t('condition.resolve')}
                  </button>
                )}
              </div>
            ),
            },
          ] as any),
        ]}
        data={conditions || []}
        emptyMessage={t('condition.empty')}
      />

      <Dialog open={createOpen} onOpenChange={setCreateOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('condition.create')}</DialogTitle>
          </DialogHeader>
          <form onSubmit={createForm.handleSubmit(onSubmitCreate)} className="space-y-4">
            <div className="space-y-2">
              <Label>{t('condition.condition')}</Label>
              <textarea
                {...createForm.register('condition_text')}
                className="w-full p-2 border rounded text-sm resize-none"
                rows={3}
              />
              {createForm.formState.errors.condition_text && (
                <p className="text-red-500 text-xs">{createForm.formState.errors.condition_text.message}</p>
              )}
            </div>
            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-2">
                <Label>{t('condition.dueDate')}</Label>
                <input
                  type="date"
                  {...createForm.register('due_date')}
                  className="w-full p-2 border rounded text-sm"
                />
              </div>
              <div className="space-y-2">
                <Label>{t('condition.severity')}</Label>
                <select
                  {...createForm.register('severity')}
                  className="w-full p-2 border rounded text-sm"
                >
                  {severityOptions.map((opt) => (
                    <option key={opt.value} value={opt.value}>
                      {t(opt.labelKey, { defaultValue: opt.defaultLabel })}
                    </option>
                  ))}
                </select>
              </div>
            </div>
            <div className="space-y-2">
              <Label>{t('condition.standard')}</Label>
              <select
                {...createForm.register('standard_version_id', { valueAsNumber: true })}
                className="w-full p-2 border rounded text-sm"
              >
                <option value="">{t('condition.noStandard')}</option>
                {(standards || []).map((s: any) => (
                  <option key={s.id} value={s.id}>
                    {s.name_ar || s.name_en} — {s.version_label}
                  </option>
                ))}
              </select>
            </div>
            <div className="space-y-2">
              <Label>{t('condition.assessment')}</Label>
              <select
                {...createForm.register('assessment_id', { valueAsNumber: true })}
                className="w-full p-2 border rounded text-sm"
              >
                <option value="">{t('condition.noAssessment')}</option>
                {(assessments || []).map((a: any) => (
                  <option key={a.id} value={a.id}>
                    {a.assessor_name} — {t('assessment.score')}: {a.overall_score ?? '-'}%
                  </option>
                ))}
              </select>
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

      <Dialog open={resolveOpen} onOpenChange={(open) => { if (!open) { setResolveOpen(false); setResolveItem(null) } }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('condition.resolveTitle')}</DialogTitle>
            {resolveItem && (
              <span className="text-sm text-slate-500 block">
                {resolveItem.condition_text?.substring(0, 80)}
                {resolveItem.condition_text?.length > 80 ? '...' : ''}
              </span>
            )}
          </DialogHeader>
          <form onSubmit={resolveForm.handleSubmit(onSubmitResolve)} className="space-y-4">
            <div className="space-y-2">
              <Label>{t('condition.newStatus')}</Label>
              <div className="grid grid-cols-2 gap-2">
                <button
                  type="button"
                  onClick={() => resolveForm.setValue('status', 'MET')}
                  className={`p-3 rounded text-sm text-center transition-colors ${
                    resolveForm.watch('status') === 'MET'
                      ? 'bg-emerald-600 text-white ring-2 ring-offset-2 ring-emerald-400'
                      : 'bg-emerald-100 text-emerald-700 hover:bg-emerald-200'
                  }`}
                >
                  {t('condition.markMet')}
                </button>
                <button
                  type="button"
                  onClick={() => resolveForm.setValue('status', 'WAIVED')}
                  className={`p-3 rounded text-sm text-center transition-colors ${
                    resolveForm.watch('status') === 'WAIVED'
                      ? 'bg-slate-600 text-white ring-2 ring-offset-2 ring-slate-400'
                      : 'bg-slate-100 text-slate-700 hover:bg-slate-200'
                  }`}
                >
                  {t('condition.markWaived')}
                </button>
              </div>
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={resolveMutation.isPending}>
                {resolveMutation.isPending ? t('common.saving') : t('common.save')}
              </Button>
              <Button type="button" variant="outline" onClick={() => { setResolveOpen(false); setResolveItem(null) }}>
                {t('common.cancel')}
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  )
}
