/*
 * صفحة دورات الاعتماد: إنشاء وإدارة دورات الاعتماد
 * المؤسسي للجنة الأخلاقيات.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useTranslation } from 'react-i18next'
import { useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import { Plus, Eye } from 'lucide-react'
import { z } from 'zod'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { useAuth } from '../../context/AuthContext'
import { useRole } from '../../hooks/usePermission'
import { Button } from '../../components/ui/button'
import { Label } from '../../components/ui/label'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger,
} from '../../components/ui/dialog'
import { createCycleSchema, updateCycleStatusSchema } from '../../lib/schemas'

type CreateFormData = z.input<typeof createCycleSchema>
type StatusFormData = z.input<typeof updateCycleStatusSchema>

const statusTransitions: Record<string, string[]> = {
  PENDING: ['UNDER_REVIEW'],
  UNDER_REVIEW: ['ACCREDITED', 'CONDITIONAL', 'SUSPENDED', 'REVOKED'],
  ACCREDITED: ['SUSPENDED', 'EXPIRED', 'REVOKED'],
  CONDITIONAL: ['ACCREDITED', 'SUSPENDED', 'REVOKED'],
  SUSPENDED: ['ACCREDITED', 'CONDITIONAL', 'REVOKED'],
  EXPIRED: ['REVOKED'],
  REVOKED: [],
}

function canTransition(from: string, to: string): boolean {
  return statusTransitions[from]?.includes(to) ?? false
}

function hasTransitions(status: string): boolean {
  return (statusTransitions[status]?.length ?? 0) > 0
}

const statusDecisionMap: Record<string, string> = {
  UNDER_REVIEW: 'SUBMIT',
  ACCREDITED: 'APPROVE',
  CONDITIONAL: 'CONDITIONAL',
  SUSPENDED: 'SUSPEND',
  EXPIRED: 'EXPIRE',
  REVOKED: 'REVOKE',
}

const reasonRequiredStatuses = new Set(['CONDITIONAL', 'SUSPENDED', 'REVOKED'])

export default function CyclesList() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { user } = useAuth()
  const canMutate = useRole('SUPER_ADMIN', 'ETHICS_ADMIN')

  const [createOpen, setCreateOpen] = useState(false)
  const [statusOpen, setStatusOpen] = useState(false)
  const [selectedCycle, setSelectedCycle] = useState<any>(null)

  const createForm = useForm<CreateFormData>({
    resolver: zodResolver(createCycleSchema),
    defaultValues: { committee_id: undefined, standard_version_id: undefined },
  })

  const statusForm = useForm<StatusFormData>({
    resolver: zodResolver(updateCycleStatusSchema),
    defaultValues: { to_status: '', decision: '', decided_by: user?.id || 0, decision_reason: '' },
  })

  const { data: cycles, isLoading } = useQuery({
    queryKey: ['accreditation-cycles'],
    queryFn: () => api.get('/committee/accreditation/cycles').then(r => r.data.data),
  })

  const { data: committees } = useQuery({
    queryKey: ['committees-dropdown'],
    queryFn: () => api.get('/committee/committees').then(r => r.data.data),
  })

  const { data: standards } = useQuery({
    queryKey: ['standards-active'],
    queryFn: () => api.get('/committee/accreditation/standards?active_only=true').then(r => r.data.data),
  })

  function handleError(err: any, fallback: string) {
    if (err.response?.status === 403) {
      toast.error(t('common.forbidden'))
    } else {
      toast.error(err.response?.data?.error || fallback)
    }
  }

  const createMutation = useMutation({
    mutationFn: (body: CreateFormData) => api.post('/committee/accreditation/cycles', body),
    onSuccess: () => {
      toast.success(t('accreditation.created'))
      queryClient.invalidateQueries({ queryKey: ['accreditation-cycles'] })
      setCreateOpen(false)
      createForm.reset()
    },
    onError: (err: any) => handleError(err, t('accreditation.createFailed')),
  })

  const statusMutation = useMutation({
    mutationFn: ({ id, body }: { id: number; body: StatusFormData }) =>
      api.patch(`/committee/accreditation/cycles/${id}/status`, body),
    onSuccess: () => {
      toast.success(t('accreditation.statusUpdated'))
      queryClient.invalidateQueries({ queryKey: ['accreditation-cycles'] })
      setStatusOpen(false)
      setSelectedCycle(null)
      statusForm.reset()
    },
    onError: (err: any) => handleError(err, t('accreditation.statusUpdateFailed')),
  })

  function openStatusDialog(cycle: any) {
    setSelectedCycle(cycle)
    statusForm.setValue('decided_by', user?.id || 0)
    statusForm.setValue('to_status', '')
    statusForm.setValue('decision', '')
    statusForm.setValue('decision_reason', '')
    setStatusOpen(true)
  }

  function onStatusSelect(targetStatus: string) {
    statusForm.setValue('to_status', targetStatus)
    statusForm.setValue('decision', statusDecisionMap[targetStatus] || '')
  }

  function onSubmitStatus(data: StatusFormData) {
    if (!selectedCycle) return
    if (reasonRequiredStatuses.has(data.to_status) && !data.decision_reason?.trim()) {
      toast.error(t('accreditation.reasonRequired'))
      return
    }
    statusMutation.mutate({ id: selectedCycle.id, body: data })
  }

  const allowedTransitions = selectedCycle ? statusTransitions[selectedCycle.status] || [] : []

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('accreditation.cycles')}</h1>
        {canMutate && (
          <Dialog open={createOpen} onOpenChange={setCreateOpen}>
            <DialogTrigger asChild>
              <button className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
                <Plus className="w-4 h-4" /> {t('accreditation.new')}
              </button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader>
                <DialogTitle>{t('accreditation.create')}</DialogTitle>
              </DialogHeader>
              <form onSubmit={createForm.handleSubmit((data) => createMutation.mutate(data))} className="space-y-4">
                <div className="space-y-2">
                  <Label>{t('accreditation.committee')}</Label>
                  <select
                    {...createForm.register('committee_id', { valueAsNumber: true })}
                    className="w-full p-2 border rounded text-sm"
                  >
                    <option value="">{t('accreditation.selectCommittee')}</option>
                    {(committees || []).map((c: any) => (
                      <option key={c.id} value={c.id}>{c.committee_name_ar || c.committee_name_en}</option>
                    ))}
                  </select>
                  {createForm.formState.errors.committee_id && (
                    <p className="text-red-500 text-xs">{createForm.formState.errors.committee_id.message}</p>
                  )}
                </div>
                <div className="space-y-2">
                  <Label>{t('accreditation.standardVersion')}</Label>
                  <select
                    {...createForm.register('standard_version_id', { valueAsNumber: true })}
                    className="w-full p-2 border rounded text-sm"
                  >
                    <option value="">{t('accreditation.selectStandardVersion')}</option>
                    {(standards || []).map((s: any) => (
                      <option key={s.id} value={s.id}>
                        {s.name_ar || s.name_en} — {s.version_label}
                      </option>
                    ))}
                  </select>
                  {createForm.formState.errors.standard_version_id && (
                    <p className="text-red-500 text-xs">{createForm.formState.errors.standard_version_id.message}</p>
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
        )}
      </div>

      <DataTable
        searchable
        loading={isLoading}
        columns={[
          { key: 'committee_name_ar', label: t('accreditation.committee'), sortable: true },
          { key: 'cycle_number', label: t('accreditation.cycle'), sortable: true,
            render: (i: any) => t('accreditation.cycleNumber', { number: i.cycle_number }) },
          { key: 'version_label', label: t('accreditation.standardVersion'), sortable: true },
          { key: 'status', label: t('accreditation.status'), filterable: true, sortable: true,
            render: (i: any) => <StatusBadge status={i.status} /> },
          { key: 'valid_from', label: t('accreditation.validFrom'), sortable: true,
            render: (i: any) => i.valid_from ? new Date(i.valid_from).toLocaleDateString() : '-' },
          { key: 'valid_until', label: t('accreditation.validUntil'), sortable: true,
            render: (i: any) => i.valid_until ? new Date(i.valid_until).toLocaleDateString() : '-' },
          { key: 'created_at', label: t('accreditation.createdAt'), sortable: true,
            render: (i: any) => new Date(i.created_at).toLocaleDateString() },
          ...([
            { key: 'actions', label: t('accreditation.actions'), render: (i: any) => (
              <div className="flex items-center gap-1" onClick={e => e.stopPropagation()}>
                <button
                  onClick={() => navigate(`/admin/accreditation/cycles/${i.id}`)}
                  className="text-slate-400 hover:text-blue-600 p-1"
                  title={t('accreditation.view')}
                >
                  <Eye className="w-4 h-4" />
                </button>
                {canMutate && hasTransitions(i.status) && (
                  <button
                    onClick={() => openStatusDialog(i)}
                    className="text-slate-400 hover:text-amber-600 p-1 text-xs"
                    title={t('accreditation.changeStatus')}
                  >
                    {t('accreditation.changeStatus')}
                  </button>
                )}
              </div>
            ),
          }] as any),
        ]}
        data={cycles || []}
        onRowClick={(item: any) => navigate(`/admin/accreditation/cycles/${item.id}`)}
        emptyMessage={t('accreditation.empty')}
      />

      <Dialog open={statusOpen} onOpenChange={(open) => { if (!open) { setStatusOpen(false); setSelectedCycle(null) } }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {t('accreditation.changeStatus')}
              {selectedCycle && (
                <span className="text-sm font-normal text-slate-500 block">
                  {selectedCycle.committee_name_ar} — {t('accreditation.cycleNumber', { number: selectedCycle.cycle_number })}
                  {' '}<StatusBadge status={selectedCycle.status} />
                </span>
              )}
            </DialogTitle>
          </DialogHeader>
          <form onSubmit={statusForm.handleSubmit(onSubmitStatus)} className="space-y-4">
            <div className="space-y-2">
              <Label>{t('accreditation.transitionTo')}</Label>
              {allowedTransitions.length === 0 ? (
                <p className="text-sm text-slate-500">{t('common.noData')}</p>
              ) : (
                <div className="grid grid-cols-2 gap-2">
                  {allowedTransitions.map((status: string) => (
                    <button
                      key={status}
                      type="button"
                      onClick={() => onStatusSelect(status)}
                      className={`p-2 rounded border text-sm text-center transition-colors ${
                        statusForm.watch('to_status') === status
                          ? 'border-blue-500 bg-blue-50 text-blue-700'
                          : 'border-slate-200 hover:border-slate-300'
                      }`}
                    >
                      <StatusBadge status={status} />
                    </button>
                  ))}
                </div>
              )}
              {statusForm.formState.errors.to_status && (
                <p className="text-red-500 text-xs">{statusForm.formState.errors.to_status.message}</p>
              )}
            </div>
            <div className="space-y-2">
              <Label>
                {t('accreditation.decisionReason')}
                {statusForm.watch('to_status') && reasonRequiredStatuses.has(statusForm.watch('to_status'))
                  ? <span className="text-red-500"> *</span>
                  : <span className="text-slate-400"> ({t('common.optional')})</span>
                }
              </Label>
              <textarea
                {...statusForm.register('decision_reason')}
                className="w-full p-2 border rounded text-sm resize-none"
                rows={3}
              />
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={statusMutation.isPending || allowedTransitions.length === 0}>
                {statusMutation.isPending ? t('common.saving') : t('common.save')}
              </Button>
              <Button type="button" variant="outline" onClick={() => { setStatusOpen(false); setSelectedCycle(null) }}>
                {t('common.cancel')}
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  )
}
