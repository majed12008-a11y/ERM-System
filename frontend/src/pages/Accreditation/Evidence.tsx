/*
 * صفحة أدلة الاعتماد: رفع وإدارة الوثائق والأدلة
 * المقدمة لدعم طلب الاعتماد.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useTranslation } from 'react-i18next'
import { useParams, useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, Upload, Trash2, FileText } from 'lucide-react'
import { z } from 'zod'
import api from '../../api/client'
import { useAuth } from '../../context/AuthContext'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { Button } from '../../components/ui/button'
import { Label } from '../../components/ui/label'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from '../../components/ui/dialog'

const createEvidenceSchema = z.object({
  standard_version_id: z.coerce.number({ message: 'Standard is required' }),
  notes: z.string().optional().default(''),
})

const updateEvidenceStatusSchema = z.object({
  status: z.string({ message: 'Status is required' }).min(1),
  review_notes: z.string().optional().default(''),
})

type CreateEvidenceForm = z.input<typeof createEvidenceSchema>
type UpdateStatusForm = z.input<typeof updateEvidenceStatusSchema>

const allowedStatusActions = [
  { status: 'ACCEPTED', labelKey: 'evidence.approve', variant: 'bg-emerald-600 hover:bg-emerald-700' },
  { status: 'REJECTED', labelKey: 'evidence.reject', variant: 'bg-red-600 hover:bg-red-700' },
  { status: 'SUBMITTED', labelKey: 'evidence.submitted', variant: 'bg-blue-600 hover:bg-blue-700' },
]

export default function Evidence() {
  const { t } = useTranslation()
  const { id: cycleId } = useParams()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { user } = useAuth()

  const [uploadOpen, setUploadOpen] = useState(false)
  const [reviewItem, setReviewItem] = useState<any>(null)
  const [reviewOpen, setReviewOpen] = useState(false)

  const uploadForm = useForm<CreateEvidenceForm>({
    resolver: zodResolver(createEvidenceSchema),
    defaultValues: { standard_version_id: undefined, notes: '' },
  })

  const reviewForm = useForm<UpdateStatusForm>({
    resolver: zodResolver(updateEvidenceStatusSchema),
    defaultValues: { status: '', review_notes: '' },
  })

  const { data: cycle } = useQuery({
    queryKey: ['accreditation-cycle', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const { data: evidence, isLoading } = useQuery({
    queryKey: ['evidence', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}/evidence`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const { data: standards } = useQuery({
    queryKey: ['standards-active'],
    queryFn: () => api.get('/committee/accreditation/standards?active_only=true').then(r => r.data.data),
  })

  const isAdmin = ['SUPER_ADMIN', 'ETHICS_ADMIN'].some(r => (user.roles || []).includes(r))

  const summary = {
    total: (evidence || []).length,
    accepted: (evidence || []).filter((e: any) => e.status === 'ACCEPTED').length,
    rejected: (evidence || []).filter((e: any) => e.status === 'REJECTED').length,
    pending: (evidence || []).filter((e: any) => e.status === 'PENDING' || e.status === 'SUBMITTED').length,
  }
  const completionRate = summary.total > 0 ? Math.round((summary.accepted / summary.total) * 100) : 0

  const uploadMutation = useMutation({
    mutationFn: (body: CreateEvidenceForm) =>
      api.post(`/committee/accreditation/cycles/${cycleId}/evidence`, body),
    onSuccess: () => {
      toast.success(t('evidence.created'))
      queryClient.invalidateQueries({ queryKey: ['evidence', cycleId] })
      setUploadOpen(false)
      uploadForm.reset()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('evidence.createFailed')),
  })

  const statusMutation = useMutation({
    mutationFn: ({ id, body }: { id: number; body: UpdateStatusForm }) =>
      api.patch(`/committee/accreditation/evidence/${id}/status`, body),
    onSuccess: () => {
      toast.success(t('evidence.statusUpdated'))
      queryClient.invalidateQueries({ queryKey: ['evidence', cycleId] })
      setReviewOpen(false)
      setReviewItem(null)
      reviewForm.reset()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('evidence.statusUpdateFailed')),
  })

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/committee/accreditation/evidence/${id}`),
    onSuccess: () => {
      toast.success(t('evidence.deleted'))
      queryClient.invalidateQueries({ queryKey: ['evidence', cycleId] })
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('evidence.deleteFailed')),
  })

  function openReview(item: any, action: string) {
    setReviewItem(item)
    reviewForm.setValue('status', action)
    reviewForm.setValue('review_notes', '')
    setReviewOpen(true)
  }

  function onSubmitReview(data: UpdateStatusForm) {
    if (!reviewItem) return
    statusMutation.mutate({ id: reviewItem.id, body: data })
  }

  function canReview(item: any): boolean {
    if (!isAdmin) return false
    return ['PENDING', 'SUBMITTED'].includes(item.status)
  }

  return (
    <div>
      <button
        onClick={() => navigate(`/admin/accreditation/cycles/${cycleId}`)}
        className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4"
      >
        <ArrowLeft className="w-4 h-4" /> {t('evidence.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">{t('evidence.title')}</h1>
          {cycle && (
            <p className="text-sm text-slate-500 mt-1">
              {cycle.committee_name_ar} — {t('accreditation.cycleNumber', { number: cycle.cycle_number })}
            </p>
          )}
        </div>
        <button
          onClick={() => setUploadOpen(true)}
          className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm"
        >
          <Upload className="w-4 h-4" /> {t('evidence.upload')}
        </button>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-5 gap-3 mb-6">
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="flex items-center justify-center gap-1 text-slate-500 text-xs mb-1">
            <FileText className="w-3 h-3" />
            {t('evidence.total')}
          </div>
          <p className="text-xl font-bold">{summary.total}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-emerald-600 text-xs mb-1">{t('evidence.accepted')}</div>
          <p className="text-xl font-bold text-emerald-700">{summary.accepted}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-red-600 text-xs mb-1">{t('evidence.rejected')}</div>
          <p className="text-xl font-bold text-red-700">{summary.rejected}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-amber-600 text-xs mb-1">{t('evidence.pending')}</div>
          <p className="text-xl font-bold text-amber-700">{summary.pending}</p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="text-blue-600 text-xs mb-1">{t('evidence.completion')}</div>
          <p className={`text-xl font-bold ${completionRate >= 80 ? 'text-emerald-700' : completionRate >= 50 ? 'text-amber-700' : 'text-slate-700'}`}>
            {completionRate}%
          </p>
        </div>
      </div>

      <DataTable
        searchable
        loading={isLoading}
        columns={[
          { key: 'standard_name', label: t('evidence.standard'), sortable: true,
            render: (i: any) => i.standard_name || i.standard_code || '-' },
          { key: 'status', label: t('evidence.status'), filterable: true, sortable: true,
            render: (i: any) => <StatusBadge status={i.status} /> },
          { key: 'uploader_name', label: t('evidence.uploadedBy'), sortable: true },
          { key: 'uploaded_at', label: t('evidence.uploadedAt'), sortable: true,
            render: (i: any) => new Date(i.uploaded_at).toLocaleDateString() },
          { key: 'notes', label: t('evidence.notes'),
            render: (i: any) => i.notes || '-' },
          ...([
            { key: 'actions', label: t('evidence.actions'),
              render: (i: any) => (
                <div className="flex items-center gap-1" onClick={e => e.stopPropagation()}>
                  {canReview(i) && (
                    <button
                      onClick={() => { setReviewItem(i); setReviewOpen(true) }}
                      className="text-xs text-blue-600 hover:text-blue-800 px-2 py-1 rounded border border-blue-200 hover:bg-blue-50"
                    >
                      {t('evidence.review')}
                    </button>
                  )}
                  {isAdmin && (
                    <button
                      onClick={() => { if (confirm(t('confirmDialog.areYouSure'))) deleteMutation.mutate(i.id) }}
                      className="text-slate-400 hover:text-red-600 p-1"
                    >
                      <Trash2 className="w-4 h-4" />
                    </button>
                  )}
                </div>
              ),
            },
          ] as any),
        ]}
        data={evidence || []}
        emptyMessage={t('evidence.empty')}
      />

      <Dialog open={uploadOpen} onOpenChange={setUploadOpen}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('evidence.uploadNew')}</DialogTitle>
          </DialogHeader>
          <form onSubmit={uploadForm.handleSubmit((data) => uploadMutation.mutate(data))} className="space-y-4">
            <div className="space-y-2">
              <Label>{t('evidence.standard')}</Label>
              <select
                {...uploadForm.register('standard_version_id', { valueAsNumber: true })}
                className="w-full p-2 border rounded text-sm"
              >
                <option value="">{t('evidence.selectStandard')}</option>
                {(standards || []).map((s: any) => (
                  <option key={s.id} value={s.id}>
                    {s.name_ar || s.name_en} — {s.version_label}
                  </option>
                ))}
              </select>
              {uploadForm.formState.errors.standard_version_id && (
                <p className="text-red-500 text-xs">{uploadForm.formState.errors.standard_version_id.message}</p>
              )}
            </div>
            <div className="space-y-2">
              <Label>{t('evidence.notes')}</Label>
              <textarea
                {...uploadForm.register('notes')}
                className="w-full p-2 border rounded text-sm resize-none"
                rows={3}
              />
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={uploadMutation.isPending}>
                {uploadMutation.isPending ? t('common.uploading') : t('evidence.upload')}
              </Button>
              <Button type="button" variant="outline" onClick={() => setUploadOpen(false)}>
                {t('common.cancel')}
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>

      <Dialog open={reviewOpen} onOpenChange={(open) => { if (!open) setReviewOpen(false) }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>{t('evidence.reviewEvidence')}</DialogTitle>
            {reviewItem && (
              <span className="text-sm text-slate-500 block">
                {reviewItem.standard_name || reviewItem.standard_code} — <StatusBadge status={reviewItem.status} />
              </span>
            )}
          </DialogHeader>
          <form onSubmit={reviewForm.handleSubmit(onSubmitReview)} className="space-y-4">
            <div className="space-y-2">
              <Label>{t('evidence.status')}</Label>
              <div className="grid grid-cols-3 gap-2">
                {allowedStatusActions.map((action) => (
                  <button
                    key={action.status}
                    type="button"
                    onClick={() => reviewForm.setValue('status', action.status)}
                    className={`p-2 rounded text-xs text-white text-center transition-colors ${
                      reviewForm.watch('status') === action.status
                        ? action.variant + ' ring-2 ring-offset-2 ring-blue-400'
                        : action.variant + ' opacity-70'
                    }`}
                  >
                    {t(action.labelKey)}
                  </button>
                ))}
              </div>
            </div>
            <div className="space-y-2">
              <Label>{t('evidence.reviewNotes')}</Label>
              <textarea
                {...reviewForm.register('review_notes')}
                className="w-full p-2 border rounded text-sm resize-none"
                rows={3}
              />
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={statusMutation.isPending}>
                {statusMutation.isPending ? t('common.saving') : t('common.save')}
              </Button>
              <Button type="button" variant="outline" onClick={() => setReviewOpen(false)}>
                {t('common.cancel')}
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  )
}
