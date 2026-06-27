/*
 * لوحة بيانات الاعتماد: نظرة عامة على دورات الاعتماد،
 * التقييمات، الشروط، والأدلة.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState, useMemo } from 'react'
import { useForm } from 'react-hook-form'
import { useTranslation } from 'react-i18next'
import { useParams, useNavigate, Link } from 'react-router-dom'
import { toast } from 'sonner'
import {
  ArrowLeft, CheckCircle, AlertTriangle, XCircle, FileText,
  ClipboardCheck, TrendingUp, BarChart4, Send,
} from 'lucide-react'
import { z } from 'zod'
import api from '../../api/client'
import { StatusBadge } from '../../components/StatusBadge'
import { Button } from '../../components/ui/button'
import { Label } from '../../components/ui/label'
import { useRole } from '../../hooks/usePermission'
import { useAuth } from '../../context/AuthContext'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
} from '../../components/ui/dialog'

type Cycle = any
type Assessment = any
type Condition = any
type Evidence = any

const statusTransitions: Record<string, string[]> = {
  PENDING: ['UNDER_REVIEW'],
  UNDER_REVIEW: ['ACCREDITED', 'CONDITIONAL', 'SUSPENDED', 'REVOKED'],
  ACCREDITED: ['SUSPENDED', 'EXPIRED', 'REVOKED'],
  CONDITIONAL: ['ACCREDITED', 'SUSPENDED', 'REVOKED'],
  SUSPENDED: ['ACCREDITED', 'CONDITIONAL', 'REVOKED'],
  EXPIRED: ['REVOKED'],
  REVOKED: [],
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

function computeRecommendation(avgScore: number | null, openConditions: number, criticalConditions: number, totalAssessments: number) {
  if (totalAssessments === 0) return null
  if (criticalConditions > 0) return { decision: 'RECOMMEND_REJECT', labelKey: 'status.RECOMMEND_REJECT', defaultLabel: 'Recommend Reject', icon: XCircle, class: 'text-red-600 bg-red-50 border-red-200' }
  if (avgScore !== null && avgScore >= 85 && openConditions === 0) return { decision: 'RECOMMEND_APPROVE', labelKey: 'status.RECOMMEND_APPROVE', defaultLabel: 'Recommend Approve', icon: CheckCircle, class: 'text-emerald-600 bg-emerald-50 border-emerald-200' }
  if (avgScore !== null && avgScore >= 70) return { decision: 'RECOMMEND_CONDITIONAL', labelKey: 'status.RECOMMEND_CONDITIONAL', defaultLabel: 'Recommend Conditional', icon: AlertTriangle, class: 'text-amber-600 bg-amber-50 border-amber-200' }
  return { decision: 'RECOMMEND_REJECT', labelKey: 'status.RECOMMEND_REJECT', defaultLabel: 'Recommend Reject', icon: XCircle, class: 'text-red-600 bg-red-50 border-red-200' }
}

export default function Dashboard() {
  const { t } = useTranslation()
  const { id: cycleId } = useParams()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const canMutate = useRole('SUPER_ADMIN', 'ETHICS_ADMIN')
  const { user } = useAuth()

  const [statusOpen, setStatusOpen] = useState(false)

  const statusForm = useForm<any>({
    defaultValues: { to_status: '', decision: '', decided_by: user?.id || 0, decision_reason: '', valid_from: '', valid_until: '' },
  })

  const { data: cycle, isLoading: cycleLoading } = useQuery({
    queryKey: ['accreditation-cycle', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const { data: assessments } = useQuery({
    queryKey: ['assessments', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}/assessments`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const { data: evidence } = useQuery({
    queryKey: ['evidence', cycleId],
    queryFn: () => api.get(`/committee/accreditation/cycles/${cycleId}/evidence`).then(r => r.data.data),
    enabled: !!cycleId,
  })

  const conditions: Condition[] = useMemo(() => {
    return cycle?.conditions || []
  }, [cycle])

  const summary = useMemo(() => {
    const ev = (evidence || []) as Evidence[]
    const as = (assessments || []) as Assessment[]
    const co = conditions as Condition[]

    const totalEvidence = ev.length
    const acceptedEvidence = ev.filter(e => e.status === 'ACCEPTED').length
    const evidencePct = totalEvidence > 0 ? Math.round((acceptedEvidence / totalEvidence) * 100) : 0

    const scores = as.map(a => a.overall_score).filter(Boolean)
    const avgScore = scores.length > 0 ? Math.round(scores.reduce((a: number, b: number) => a + b, 0) / scores.length) : null

    const openConditions = co.filter(c => c.status === 'OPEN' || c.status === 'OVERDUE').length
    const criticalConditions = co.filter(c => c.severity === 'CRITICAL' && (c.status === 'OPEN' || c.status === 'OVERDUE')).length

    const recommendation = computeRecommendation(avgScore, openConditions, criticalConditions, as.length)

    return { evidencePct, avgScore, openConditions, criticalConditions, recommendation }
  }, [evidence, assessments, conditions])

  const statusMutation = useMutation({
    mutationFn: ({ id, body }: { id: number; body: any }) =>
      api.patch(`/committee/accreditation/cycles/${id}/status`, body),
    onSuccess: () => {
      toast.success(t('accreditation.statusUpdated'))
      queryClient.invalidateQueries({ queryKey: ['accreditation-cycle', cycleId] })
      setStatusOpen(false)
      statusForm.reset()
    },
    onError: (err: any) => {
      const msg = err.response?.status === 403 ? t('common.forbidden') : (err.response?.data?.error || t('accreditation.statusUpdateFailed'))
      toast.error(msg)
    },
  })

  function openStatusDialog(targetStatus: string) {
    statusForm.setValue('to_status', targetStatus)
    statusForm.setValue('decision', statusDecisionMap[targetStatus] || '')
    statusForm.setValue('decided_by', user?.id || 0)
    statusForm.setValue('decision_reason', '')
    statusForm.setValue('valid_from', '')
    statusForm.setValue('valid_until', '')
    setStatusOpen(true)
  }

  function onSubmitStatus(data: any) {
    if (!cycle) return
    if (reasonRequiredStatuses.has(data.to_status) && !data.decision_reason?.trim()) {
      toast.error(t('accreditation.reasonRequired'))
      return
    }
    statusMutation.mutate({ id: cycle.id, body: { to_status: data.to_status, decision: data.decision, decided_by: data.decided_by, decision_reason: data.decision_reason } })
  }

  const allowedTransitions = cycle ? statusTransitions[cycle.status] || [] : []

  if (cycleLoading) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="h-8 bg-slate-200 rounded w-1/3" />
        <div className="grid grid-cols-5 gap-3"><div className="h-24 bg-slate-200 rounded" /><div className="h-24 bg-slate-200 rounded" /><div className="h-24 bg-slate-200 rounded" /><div className="h-24 bg-slate-200 rounded" /><div className="h-24 bg-slate-200 rounded" /></div>
        <div className="h-60 bg-slate-200 rounded" />
        <div className="h-80 bg-slate-200 rounded" />
      </div>
    )
  }

  if (!cycle) {
    return (
      <div className="text-center py-12">
        <p className="text-slate-500">{t('common.noData')}</p>
        <Button variant="outline" className="mt-4" onClick={() => navigate(`/admin/accreditation/cycles`)}>
          {t('accreditation.back')}
        </Button>
      </div>
    )
  }

  const as = (assessments || []) as Assessment[]

  return (
    <div>
      <button
        onClick={() => navigate(`/admin/accreditation/cycles/${cycleId}`)}
        className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4"
      >
        <ArrowLeft className="w-4 h-4" /> {t('dashboard.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">{t('dashboard.title')}</h1>
          <p className="text-sm text-slate-500 mt-1">
            {cycle.committee_name_ar} — {t('accreditation.cycleNumber', { number: cycle.cycle_number })} — <StatusBadge status={cycle.status} />
          </p>
        </div>
      </div>

      {/* Summary Cards */}
      <div className="grid grid-cols-2 md:grid-cols-5 gap-3 mb-6">
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="flex items-center justify-center gap-1 text-xs text-blue-600 mb-1">
            <FileText className="w-3 h-3" />
            {t('dashboard.evidenceCompletion')}
          </div>
          <p className={`text-xl font-bold ${summary.evidencePct >= 80 ? 'text-emerald-700' : summary.evidencePct >= 50 ? 'text-amber-700' : 'text-red-700'}`}>
            {summary.evidencePct}%
          </p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="flex items-center justify-center gap-1 text-xs text-purple-600 mb-1">
            <TrendingUp className="w-3 h-3" />
            {t('dashboard.assessmentScore')}
          </div>
          <p className={`text-xl font-bold ${summary.avgScore !== null && summary.avgScore >= 85 ? 'text-emerald-700' : summary.avgScore !== null && summary.avgScore >= 70 ? 'text-amber-700' : 'text-red-700'}`}>
            {summary.avgScore !== null ? `${summary.avgScore}%` : '-'}
          </p>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="flex items-center justify-center gap-1 text-xs text-amber-600 mb-1">
            <AlertTriangle className="w-3 h-3" />
            {t('dashboard.openConditions')}
          </div>
          <p className={`text-xl font-bold ${summary.openConditions > 0 ? 'text-amber-700' : 'text-emerald-700'}`}>
            {summary.openConditions}
          </p>
          <Link to={`/admin/accreditation/cycles/${cycleId}/conditions`} className="text-xs text-blue-600 hover:underline block mt-1">
            {t('dashboard.viewConditions')}
          </Link>
        </div>
        <div className="bg-white rounded-lg border p-3 text-center">
          <div className="flex items-center justify-center gap-1 text-xs text-red-600 mb-1">
            <XCircle className="w-3 h-3" />
            {t('dashboard.criticalConditions')}
          </div>
          <p className={`text-xl font-bold ${summary.criticalConditions > 0 ? 'text-red-700' : 'text-emerald-700'}`}>
            {summary.criticalConditions}
          </p>
        </div>
        <div className={`bg-white rounded-lg border p-3 text-center ${summary.recommendation?.class || ''}`}>
          <div className="flex items-center justify-center gap-1 text-xs mb-1">
            <BarChart4 className="w-3 h-3" />
            {t('dashboard.recommendation')}
          </div>
          {summary.recommendation ? (
            <div className="flex items-center justify-center gap-1">
              <summary.recommendation.icon className="w-4 h-4" />
              <p className="text-sm font-bold">
                {t(summary.recommendation.labelKey, { defaultValue: summary.recommendation.defaultLabel })}
              </p>
            </div>
          ) : (
            <p className="text-sm text-slate-400">{t('dashboard.awaitingData')}</p>
          )}
        </div>
      </div>

      {/* Assessor Consensus */}
      <div className="bg-white rounded-lg border p-6 mb-6">
        <h2 className="font-semibold mb-4 flex items-center gap-2">
          <ClipboardCheck className="w-4 h-4 text-purple-600" />
          {t('dashboard.assessorConsensus')}
        </h2>
        {as.length === 0 ? (
          <p className="text-sm text-slate-500">{t('dashboard.noAssessments')}</p>
        ) : (
          <div>
            <div className="overflow-x-auto">
              <table className="w-full text-sm">
                <thead>
                  <tr className="border-b text-slate-500 text-xs uppercase">
                    <th className="text-left py-2 pr-4">{t('dashboard.assessor')}</th>
                    <th className="text-left py-2 pr-4">{t('dashboard.decision')}</th>
                    <th className="text-left py-2 pr-4">{t('dashboard.score')}</th>
                    <th className="text-left py-2 pr-4">{t('dashboard.date')}</th>
                    <th className="text-left py-2 pr-4">{t('dashboard.justification')}</th>
                  </tr>
                </thead>
                <tbody>
                  {as.map((a: Assessment) => (
                    <tr key={a.id} className="border-b last:border-0 hover:bg-slate-50">
                      <td className="py-2 pr-4 font-medium">{a.assessor_name}</td>
                      <td className="py-2 pr-4"><StatusBadge status={a.overall_decision} /></td>
                      <td className="py-2 pr-4">{a.overall_score !== null ? `${a.overall_score}%` : '-'}</td>
                      <td className="py-2 pr-4 text-slate-500">{a.assessed_at ? new Date(a.assessed_at).toLocaleDateString() : '-'}</td>
                      <td className="py-2 pr-4 text-slate-500 max-w-xs truncate">{a.overall_justification || '-'}</td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
            {as.length > 1 && (
              <p className="text-xs text-slate-500 mt-3">
                {t('dashboard.consensusCount', { count: as.filter(a => a.overall_decision === 'RECOMMEND_APPROVE').length, total: as.length })}
              </p>
            )}
          </div>
        )}
      </div>

      {/* Conditions Impact */}
      <div className="bg-white rounded-lg border p-6 mb-6">
        <h2 className="font-semibold mb-4 flex items-center gap-2">
          <AlertTriangle className="w-4 h-4 text-amber-600" />
          {t('dashboard.conditionsImpact')}
        </h2>
        {conditions.length === 0 ? (
          <p className="text-sm text-slate-500">{t('dashboard.noConditions')}</p>
        ) : (
          <div>
            <div className="grid grid-cols-3 gap-3 mb-4">
              <div className="bg-slate-50 rounded p-3 text-center">
                <div className="text-xs text-slate-500">{t('dashboard.bySeverity.minor')}</div>
                <p className="text-lg font-bold text-yellow-700">{conditions.filter(c => c.severity === 'MINOR').length}</p>
              </div>
              <div className="bg-slate-50 rounded p-3 text-center">
                <div className="text-xs text-slate-500">{t('dashboard.bySeverity.major')}</div>
                <p className="text-lg font-bold text-orange-700">{conditions.filter(c => c.severity === 'MAJOR').length}</p>
              </div>
              <div className="bg-slate-50 rounded p-3 text-center">
                <div className="text-xs text-slate-500">{t('dashboard.bySeverity.critical')}</div>
                <p className="text-lg font-bold text-red-700">{conditions.filter(c => c.severity === 'CRITICAL').length}</p>
              </div>
            </div>
            <div className="space-y-2 max-h-48 overflow-y-auto">
              {conditions.map((c: Condition) => (
                <div key={c.id} className="flex items-center gap-2 text-sm p-2 bg-slate-50 rounded">
                  <StatusBadge status={c.status} />
                  <span className="text-xs px-1.5 py-0.5 rounded font-medium bg-slate-200 text-slate-700">{c.severity}</span>
                  <span className="text-slate-600 flex-1 truncate">{c.condition_text}</span>
                  <span className="text-xs text-slate-400">{new Date(c.due_date).toLocaleDateString()}</span>
                </div>
              ))}
            </div>
          </div>
        )}
      </div>

      {/* Final Decision Panel */}
      <div className="bg-white rounded-lg border p-6">
        <h2 className="font-semibold mb-4 flex items-center gap-2">
          <Send className="w-4 h-4 text-blue-600" />
          {t('dashboard.finalDecision')}
        </h2>
        <p className="text-sm text-slate-500 mb-4">{t('dashboard.finalDecisionDesc')}</p>

        {allowedTransitions.length === 0 ? (
          <div className="bg-slate-50 rounded p-4 text-center text-sm text-slate-500">
            {cycle.status === 'EXPIRED' && t('dashboard.expiredNote')}
            {cycle.status === 'REVOKED' && t('dashboard.revokedNote')}
            {!['EXPIRED', 'REVOKED'].includes(cycle.status) && t('dashboard.noTransitions')}
          </div>
        ) : (
          <div className="grid grid-cols-2 md:grid-cols-4 gap-3">
            {allowedTransitions.map((targetStatus: string) => {
              const isActive = statusForm.watch('to_status') === targetStatus
              return (
                <button
                  key={targetStatus}
                  type="button"
                  disabled={!canMutate}
                  onClick={() => openStatusDialog(targetStatus)}
                  className={`p-4 rounded-lg border-2 text-center transition-all ${
                    isActive
                      ? 'border-blue-500 bg-blue-50 shadow-sm'
                      : 'border-slate-200 hover:border-slate-300 bg-white'
                  } ${!canMutate ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}`}
                >
                  <div className="mb-2 flex justify-center">
                    <StatusBadge status={targetStatus} />
                  </div>
                  <p className="text-xs text-slate-500">
                    {t(statusDecisionMap[targetStatus] ? `dashboard.action.${statusDecisionMap[targetStatus].toLowerCase()}` : '', {
                      defaultValue: statusDecisionMap[targetStatus] || targetStatus,
                    })}
                  </p>
                </button>
              )
            })}
          </div>
        )}

        {!canMutate && (
          <p className="text-xs text-slate-400 mt-3 text-center">
            {t('dashboard.adminOnly')}
          </p>
        )}
      </div>

      {/* Status Transition Dialog */}
      <Dialog open={statusOpen} onOpenChange={(open) => { if (!open) { setStatusOpen(false) } }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle>
              {t('dashboard.issueDecision')}
              <span className="text-sm font-normal text-slate-500 block">
                {cycle.committee_name_ar} — <StatusBadge status={cycle.status} /> <span className="text-slate-400">→</span> <StatusBadge status={statusForm.watch('to_status')} />
              </span>
            </DialogTitle>
          </DialogHeader>
          <form onSubmit={statusForm.handleSubmit(onSubmitStatus)} className="space-y-4">
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
            <div className="grid grid-cols-2 gap-3">
              <div className="space-y-2">
                <Label>{t('dashboard.validFrom')}</Label>
                <input
                  type="date"
                  {...statusForm.register('valid_from')}
                  className="w-full p-2 border rounded text-sm"
                />
              </div>
              <div className="space-y-2">
                <Label>{t('dashboard.validUntil')}</Label>
                <input
                  type="date"
                  {...statusForm.register('valid_until')}
                  className="w-full p-2 border rounded text-sm"
                />
              </div>
            </div>
            <div className="bg-amber-50 border border-amber-200 rounded p-3 text-xs text-amber-800">
              {t('dashboard.decisionWarning')}
            </div>
            <div className="flex gap-3">
              <Button type="submit" disabled={statusMutation.isPending}>
                {statusMutation.isPending ? t('common.saving') : t('dashboard.issueDecision')}
              </Button>
              <Button type="button" variant="outline" onClick={() => setStatusOpen(false)}>
                {t('common.cancel')}
              </Button>
            </div>
          </form>
        </DialogContent>
      </Dialog>
    </div>
  )
}
