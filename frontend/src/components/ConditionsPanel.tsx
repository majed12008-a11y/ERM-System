import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState, useRef } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { conditions } from '../sdk/domains/conditions.sdk'
import { StatusBadge } from './StatusBadge'
import { Button } from './ui/button'
import { Card, CardContent, CardHeader, CardTitle } from './ui/card'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter,
} from './ui/dialog'
import { Label } from './ui/label'
import { Textarea } from './ui/textarea'
import { useAuth } from '../context/AuthContext'
import { AlertCircle, ListChecks, Clock, FileText, ChevronDown, ChevronRight, Trash2 } from 'lucide-react'
import { z } from 'zod'
import { AxiosError } from 'axios'
import type { ApplicationCondition } from '../sdk/core/types'

const createConditionSchema = z.object({
  condition_text: z.string().min(1, 'condition.textRequired'),
  severity: z.enum(['CRITICAL', 'MAJOR', 'MINOR']),
  category: z.string().optional().default(''),
  due_date: z.string().optional().default(''),
})

function severityColor(severity: string) {
  switch (severity) {
    case 'CRITICAL': return 'bg-red-100 text-red-800 border-red-300'
    case 'MAJOR': return 'bg-orange-100 text-orange-800 border-orange-300'
    case 'MINOR': return 'bg-yellow-100 text-yellow-800 border-yellow-300'
    default: return 'bg-slate-100 text-slate-800 border-slate-300'
  }
}

function isOverdue(dueDate: string | null): boolean {
  if (!dueDate) return false
  return new Date(dueDate) < new Date()
}

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

export default function ConditionsPanel({ applicationId, submittedBy }: { applicationId: string | number; submittedBy?: number }) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const { user } = useAuth()
  const [openCreate, setOpenCreate] = useState(false)
  const [resolveTarget, setResolveTarget] = useState<ApplicationCondition | null>(null)
  const [deleteTarget, setDeleteTarget] = useState<ApplicationCondition | null>(null)
  const [resolveStatus, setResolveStatus] = useState<'MET' | 'NOT_MET' | 'WAIVED'>('MET')
  const [expandedEvidence, setExpandedEvidence] = useState<Set<number>>(new Set())
  const [deleteEvidenceTarget, setDeleteEvidenceTarget] = useState<{ conditionId: number; evidenceId: number } | null>(null)
  const fileInputRef = useRef<HTMLInputElement>(null)

  const canManage = user?.roles?.some(r => ['SUPER_ADMIN', 'ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'REVIEWER'].includes(r))
  const isApplicant = submittedBy !== undefined && submittedBy === user?.id
  const canUploadEvidence = isApplicant || canManage

  const createForm = useForm<z.input<typeof createConditionSchema>>({
    resolver: zodResolver(createConditionSchema),
    defaultValues: { condition_text: '', severity: 'MAJOR', category: '', due_date: '' },
  })

  const { data: conditionList, isLoading } = useQuery({
    queryKey: ['application-conditions', applicationId],
    queryFn: () => conditions.list(Number(applicationId)).then(r => r.data.data),
    enabled: !!applicationId,
  })

  const { data: evaluation } = useQuery({
    queryKey: ['condition-evaluation', applicationId],
    queryFn: () => conditions.getSummary(Number(applicationId)).then(r => r.data.data),
    enabled: !!applicationId,
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => conditions.create(Number(applicationId), body),
    onSuccess: () => {
      toast.success(t('condition.created'))
      queryClient.invalidateQueries({ queryKey: ['application-conditions', applicationId] })
      queryClient.invalidateQueries({ queryKey: ['condition-evaluation', applicationId] })
      setOpenCreate(false)
      createForm.reset()
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('condition.createFailed')),
  })

  const resolveMutation = useMutation({
    mutationFn: ({ conditionId, status }: { conditionId: number, status: string }) =>
      conditions.resolve(Number(applicationId), conditionId, { status: status as any }),
    onSuccess: () => {
      toast.success(t('condition.statusUpdated'))
      queryClient.invalidateQueries({ queryKey: ['application-conditions', applicationId] })
      queryClient.invalidateQueries({ queryKey: ['condition-evaluation', applicationId] })
      setResolveTarget(null)
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('condition.statusUpdateFailed')),
  })

  const deleteMutation = useMutation({
    mutationFn: (conditionId: number) => conditions.delete(Number(applicationId), conditionId),
    onSuccess: () => {
      toast.success(t('condition.deleted'))
      queryClient.invalidateQueries({ queryKey: ['application-conditions', applicationId] })
      queryClient.invalidateQueries({ queryKey: ['condition-evaluation', applicationId] })
      setDeleteTarget(null)
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('condition.deleteFailed')),
  })

  const evidenceUploadMutation = useMutation({
    mutationFn: ({ conditionId, file }: { conditionId: number; file: File }) => {
      const formData = new FormData()
      formData.append('file', file)
      return conditions.uploadEvidence(Number(applicationId), conditionId, formData)
    },
    onSuccess: () => {
      toast.success(t('condition.evidence.uploaded'))
      queryClient.invalidateQueries({ queryKey: ['condition-evidence'] })
      queryClient.invalidateQueries({ queryKey: ['condition-evaluation', applicationId] })
      if (fileInputRef.current) fileInputRef.current.value = ''
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('condition.evidence.uploadFailed')),
  })

  const evidenceDeleteMutation = useMutation({
    mutationFn: ({ conditionId, evidenceId }: { conditionId: number; evidenceId: number }) =>
      conditions.deleteEvidence(Number(applicationId), conditionId, evidenceId),
    onSuccess: () => {
      toast.success(t('condition.evidence.deleted'))
      queryClient.invalidateQueries({ queryKey: ['condition-evidence'] })
      queryClient.invalidateQueries({ queryKey: ['condition-evaluation', applicationId] })
      setDeleteEvidenceTarget(null)
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('condition.evidence.deleteFailed')),
  })

  const stats = evaluation || { total: 0, open: 0, met: 0, notMet: 0, waived: 0, allSatisfied: false, canApprove: false, canReject: false, canSubmitEvidence: false, unmetConditionIds: [], missingEvidenceIds: [] }
  const resolved = stats.met + stats.waived
  const overdue = (conditionList || []).filter(c => c.status === 'OPEN' && isOverdue(c.due_date)).length

  const summaryCards = [
    { label: t('condition.total'), value: stats.total, color: 'bg-blue-50 text-blue-700' },
    { label: t('condition.open'), value: stats.open, color: 'bg-yellow-50 text-yellow-700' },
    { label: t('condition.resolved'), value: resolved, color: 'bg-green-50 text-green-700' },
    { label: t('condition.overdue'), value: overdue, color: 'bg-red-50 text-red-700' },
  ]

  if (isLoading) return null

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-sm flex items-center gap-2">
          <ListChecks className="w-4 h-4" /> {t('condition.title')}
        </CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="grid grid-cols-2 lg:grid-cols-4 gap-3">
          {summaryCards.map(card => (
            <div key={card.label} className={`rounded-lg p-3 text-center ${card.color}`}>
              <p className="text-2xl font-bold">{card.value}</p>
              <p className="text-xs">{card.label}</p>
            </div>
          ))}
        </div>

        {canManage && (
          <Dialog open={openCreate} onOpenChange={setOpenCreate}>
            <DialogTrigger asChild>
              <Button size="sm">{t('condition.create')}</Button>
            </DialogTrigger>
            <DialogContent>
              <form onSubmit={createForm.handleSubmit((data) => createMutation.mutate(data))}>
                <DialogHeader><DialogTitle>{t('condition.new')}</DialogTitle></DialogHeader>
                <div className="space-y-3 py-2">
                  <div>
                    <Label>{t('condition.condition')}</Label>
                    <Textarea {...createForm.register('condition_text')} rows={3} />
                  </div>
                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <Label>{t('condition.severity')}</Label>
                      <select {...createForm.register('severity')} className="w-full p-2 border rounded text-sm">
                        <option value="CRITICAL">{t('status.CRITICAL')}</option>
                        <option value="MAJOR">{t('status.MAJOR')}</option>
                        <option value="MINOR">{t('status.MINOR')}</option>
                      </select>
                    </div>
                    <div>
                      <Label>{t('condition.category')}</Label>
                      <input {...createForm.register('category')} className="w-full p-2 border rounded text-sm" />
                    </div>
                  </div>
                  <div>
                    <Label>{t('condition.dueDate')}</Label>
                    <input type="date" {...createForm.register('due_date')} className="w-full p-2 border rounded text-sm" />
                  </div>
                </div>
                <DialogFooter>
                  <Button variant="outline" type="button" onClick={() => setOpenCreate(false)}>{t('common.cancel')}</Button>
                  <Button type="submit" disabled={createMutation.isPending}>{t('common.create')}</Button>
                </DialogFooter>
              </form>
            </DialogContent>
          </Dialog>
        )}

        {(!conditionList || conditionList.length === 0) ? (
          <div className="text-center py-6">
            <AlertCircle className="w-8 h-8 text-slate-300 mx-auto mb-2" />
            <p className="text-sm text-slate-400">{t('condition.empty')}</p>
          </div>
        ) : (
          <div className="space-y-3">
            {conditionList.map(condition => (
              <div key={condition.id} className="border rounded-lg p-3 space-y-2">
                <div className="flex items-start justify-between gap-2">
                  <div className="flex-1 min-w-0">
                    <p className="text-sm font-medium">{condition.condition_text}</p>
                    <div className="flex items-center gap-2 mt-1 flex-wrap">
                      <span className={`text-xs px-2 py-0.5 rounded-full border ${severityColor(condition.severity)}`}>
                        {t(`status.${condition.severity}`)}
                      </span>
                      {condition.category && (
                        <span className="text-xs text-slate-500">{condition.category}</span>
                      )}
                      {condition.due_date && (
                        <span className="text-xs text-slate-400 flex items-center gap-1">
                          <Clock className="w-3 h-3" /> {new Date(condition.due_date).toLocaleDateString()}
                        </span>
                      )}
                    </div>
                  </div>
                  <div className="flex items-center gap-2 shrink-0">
                    <StatusBadge status={condition.status} />
                    {canManage && condition.status === 'OPEN' && (
                      <Button variant="outline" size="sm" onClick={() => { setResolveTarget(condition); setResolveStatus('MET') }}>
                        {t('condition.resolve')}
                      </Button>
                    )}
                    {canManage && condition.status === 'OPEN' && (
                      <Button variant="ghost" size="sm" className="text-red-500 hover:text-red-700" onClick={() => setDeleteTarget(condition)}>
                        {t('common.delete')}
                      </Button>
                    )}
                  </div>
                </div>
                <div className="border-t pt-2 mt-1">
                  <button
                    className="flex items-center gap-1 text-xs text-slate-500 hover:text-slate-700"
                    onClick={() => {
                      const next = new Set(expandedEvidence)
                      if (next.has(condition.id)) next.delete(condition.id)
                      else next.add(condition.id)
                      setExpandedEvidence(next)
                    }}
                  >
                    {expandedEvidence.has(condition.id) ? <ChevronDown className="w-3 h-3" /> : <ChevronRight className="w-3 h-3" />}
                    <FileText className="w-3 h-3" /> {t('condition.evidence.title')}
                  </button>
                  {expandedEvidence.has(condition.id) && (
                    <div className="mt-2 space-y-2">
                      {canUploadEvidence && condition.status === 'OPEN' && (
                        <div className="flex items-center gap-2">
                          <input
                            ref={fileInputRef}
                            type="file"
                            accept=".pdf,.jpg,.jpeg,.png,.tiff"
                            className="text-xs flex-1"
                            onChange={(e) => {
                              const file = e.target.files?.[0]
                              if (file) {
                                evidenceUploadMutation.mutate({ conditionId: condition.id, file })
                              }
                            }}
                          />
                        </div>
                      )}
                      <EvidenceList
                        applicationId={Number(applicationId)}
                        conditionId={condition.id}
                        canDelete={!!canUploadEvidence}
                        onDelete={(evidenceId) => setDeleteEvidenceTarget({ conditionId: condition.id, evidenceId })}
                      />
                    </div>
                  )}
                </div>
              </div>
            ))}
          </div>
        )}

        <Dialog open={!!resolveTarget} onOpenChange={(open) => { if (!open) setResolveTarget(null) }}>
          <DialogContent>
            <DialogHeader><DialogTitle>{t('condition.resolveTitle')}</DialogTitle></DialogHeader>
            <div className="space-y-3 py-2">
              <p className="text-sm font-medium">{resolveTarget?.condition_text}</p>
              <div>
                <Label>{t('condition.newStatus')}</Label>
                <select value={resolveStatus} onChange={e => setResolveStatus(e.target.value as 'MET' | 'NOT_MET' | 'WAIVED')} className="w-full p-2 border rounded text-sm">
                  <option value="MET">{t('condition.markMet')}</option>
                  <option value="NOT_MET">{t('condition.markNotMet')}</option>
                  <option value="WAIVED">{t('condition.markWaived')}</option>
                </select>
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" onClick={() => setResolveTarget(null)}>{t('common.cancel')}</Button>
              <Button onClick={() => resolveTarget && resolveMutation.mutate({ conditionId: resolveTarget.id, status: resolveStatus })} disabled={resolveMutation.isPending}>
                {t('common.confirm')}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>

        <Dialog open={!!deleteTarget} onOpenChange={(open) => { if (!open) setDeleteTarget(null) }}>
          <DialogContent>
            <DialogHeader><DialogTitle>{t('common.confirm')}</DialogTitle></DialogHeader>
            <p className="text-sm">{t('common.confirmDelete')}</p>
            <DialogFooter>
              <Button variant="outline" onClick={() => setDeleteTarget(null)}>{t('common.cancel')}</Button>
              <Button variant="destructive" onClick={() => deleteTarget && deleteMutation.mutate(deleteTarget.id)} disabled={deleteMutation.isPending}>
                {t('common.delete')}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>

        <Dialog open={!!deleteEvidenceTarget} onOpenChange={(open) => { if (!open) setDeleteEvidenceTarget(null) }}>
          <DialogContent>
            <DialogHeader><DialogTitle>{t('common.confirm')}</DialogTitle></DialogHeader>
            <p className="text-sm">{t('common.confirmDelete')}</p>
            <DialogFooter>
              <Button variant="outline" onClick={() => setDeleteEvidenceTarget(null)}>{t('common.cancel')}</Button>
              <Button variant="destructive" onClick={() => deleteEvidenceTarget && evidenceDeleteMutation.mutate(deleteEvidenceTarget)} disabled={evidenceDeleteMutation.isPending}>
                {t('common.delete')}
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </CardContent>
    </Card>
  )
}

function EvidenceList({ applicationId, conditionId, canDelete, onDelete }: {
  applicationId: number; conditionId: number; canDelete: boolean; onDelete: (evidenceId: number) => void
}) {
  const { t } = useTranslation()
  const { data: evidence, isLoading } = useQuery({
    queryKey: ['condition-evidence', applicationId, conditionId],
    queryFn: () => conditions.listEvidence(applicationId, conditionId).then(r => r.data.data),
    enabled: true,
  })

  if (isLoading) return <p className="text-xs text-slate-400">{t('common.loading')}</p>
  if (!evidence || evidence.length === 0) return <p className="text-xs text-slate-400">{t('condition.evidence.empty')}</p>

  return (
    <div className="space-y-1">
      {evidence.map(doc => (
        <div key={doc.id} className="flex items-center justify-between gap-2 text-xs text-slate-600 bg-slate-50 rounded px-2 py-1">
          <div className="flex items-center gap-2 min-w-0">
            <FileText className="w-3 h-3 shrink-0" />
            <span className="truncate">{doc.file_name}</span>
            {doc.file_size_bytes && <span className="text-slate-400 shrink-0">({formatFileSize(doc.file_size_bytes)})</span>}
          </div>
          <div className="flex items-center gap-2 shrink-0">
            <span className="text-slate-400">{doc.uploaded_by_username || ''}</span>
            {canDelete && (
              <button className="text-red-400 hover:text-red-600" onClick={() => onDelete(doc.id)}>
                <Trash2 className="w-3 h-3" />
              </button>
            )}
          </div>
        </div>
      ))}
    </div>
  )
}
