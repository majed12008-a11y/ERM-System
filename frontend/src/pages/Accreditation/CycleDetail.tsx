/*
 * صفحة تفاصيل دورة الاعتماد: عرض معلومات الدورة،
 * التقييمات، الشروط، والأدلة المرتبطة.
 */
import { useQuery } from '@tanstack/react-query'
import { useParams, useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { ArrowLeft, ClipboardCheck, AlertCircle, FileText, Upload, ClipboardList, AlertTriangle, BarChart4 } from 'lucide-react'
import api from '../../api/client'
import { StatusBadge } from '../../components/StatusBadge'
import { Button } from '../../components/ui/button'

export default function CycleDetail() {
  const { t } = useTranslation()
  const { id } = useParams()
  const navigate = useNavigate()

  const { data: cycle, isLoading } = useQuery({
    queryKey: ['accreditation-cycle', id],
    queryFn: () => api.get(`/committee/accreditation/cycles/${id}`).then(r => r.data.data),
    enabled: !!id,
  })

  if (isLoading) {
    return (
      <div className="space-y-4 animate-pulse">
        <div className="h-8 bg-slate-200 rounded w-1/3" />
        <div className="h-40 bg-slate-200 rounded" />
        <div className="h-60 bg-slate-200 rounded" />
      </div>
    )
  }

  if (!cycle) {
    return (
      <div className="text-center py-12">
        <p className="text-slate-500">{t('common.noData')}</p>
        <Button variant="outline" className="mt-4" onClick={() => navigate('/admin/accreditation/cycles')}>
          {t('accreditation.back')}
        </Button>
      </div>
    )
  }

  return (
    <div>
      <button
        onClick={() => navigate('/admin/accreditation/cycles')}
        className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4"
      >
        <ArrowLeft className="w-4 h-4" /> {t('accreditation.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">{cycle.committee_name_ar}</h1>
          <p className="text-sm text-slate-500 mt-1">
            {t('accreditation.cycleNumber', { number: cycle.cycle_number })} — {cycle.version_label}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <StatusBadge status={cycle.status} />
          <div className="flex items-center gap-2">
            <button
              onClick={() => navigate(`/admin/accreditation/cycles/${id}/evidence`)}
              className="flex items-center gap-1 text-sm bg-white border border-slate-200 text-slate-600 px-3 py-1.5 rounded hover:bg-slate-50"
            >
              <Upload className="w-4 h-4" />
              {t('evidence.title')}
            </button>
            <button
              onClick={() => navigate(`/admin/accreditation/cycles/${id}/assessments`)}
              className="flex items-center gap-1 text-sm bg-white border border-slate-200 text-slate-600 px-3 py-1.5 rounded hover:bg-slate-50"
            >
              <ClipboardList className="w-4 h-4" />
              {t('assessment.title')}
            </button>
            <button
              onClick={() => navigate(`/admin/accreditation/cycles/${id}/conditions`)}
              className="flex items-center gap-1 text-sm bg-white border border-slate-200 text-slate-600 px-3 py-1.5 rounded hover:bg-slate-50"
            >
              <AlertTriangle className="w-4 h-4" />
              {t('condition.title')}
            </button>
            <button
              onClick={() => navigate(`/admin/accreditation/cycles/${id}/dashboard`)}
              className="flex items-center gap-1 text-sm bg-blue-600 text-white px-3 py-1.5 rounded hover:bg-blue-700"
            >
              <BarChart4 className="w-4 h-4" />
              {t('dashboard.title')}
            </button>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div className="bg-white rounded-lg border p-4">
          <div className="flex items-center gap-2 text-slate-500 text-sm mb-1">
            <ClipboardCheck className="w-4 h-4" />
            {t('accreditation.assessmentCount')}
          </div>
          <p className="text-2xl font-bold">{cycle.assessment_count || 0}</p>
        </div>
        <div className="bg-white rounded-lg border p-4">
          <div className="flex items-center gap-2 text-slate-500 text-sm mb-1">
            <AlertCircle className="w-4 h-4" />
            {t('accreditation.openConditions')}
          </div>
          <p className="text-2xl font-bold">{cycle.open_conditions || 0}</p>
        </div>
        <div className="bg-white rounded-lg border p-4">
          <div className="flex items-center gap-2 text-slate-500 text-sm mb-1">
            <FileText className="w-4 h-4" />
            {t('accreditation.institution')}
          </div>
          <p className="text-sm font-medium">{cycle.institution_name}</p>
        </div>
      </div>

      <div className="bg-white rounded-lg border p-6 mb-6">
        <h2 className="font-semibold mb-4">{t('accreditation.detail')}</h2>
        <dl className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
          <div>
            <dt className="text-slate-500">{t('accreditation.committee')}</dt>
            <dd className="font-medium">{cycle.committee_name_ar}</dd>
          </div>
          <div>
            <dt className="text-slate-500">{t('accreditation.standardVersion')}</dt>
            <dd className="font-medium">{cycle.version_label} ({t('common.from')} {new Date(cycle.effective_from).toLocaleDateString()})</dd>
          </div>
          <div>
            <dt className="text-slate-500">{t('accreditation.validFrom')}</dt>
            <dd className="font-medium">{cycle.valid_from ? new Date(cycle.valid_from).toLocaleDateString() : '-'}</dd>
          </div>
          <div>
            <dt className="text-slate-500">{t('accreditation.validUntil')}</dt>
            <dd className="font-medium">{cycle.valid_until ? new Date(cycle.valid_until).toLocaleDateString() : '-'}</dd>
          </div>
          {cycle.notes && (
            <div className="md:col-span-2">
              <dt className="text-slate-500">{t('common.notes')}</dt>
              <dd className="font-medium">{cycle.notes}</dd>
            </div>
          )}
        </dl>
      </div>

      <div className="bg-white rounded-lg border p-6">
        <h2 className="font-semibold mb-4">{t('accreditation.decisionHistory')}</h2>
        {(!cycle.decisions || cycle.decisions.length === 0) ? (
          <p className="text-sm text-slate-500">{t('accreditation.noDecisions')}</p>
        ) : (
          <div className="space-y-3">
            {cycle.decisions.map((d: any, i: number) => (
              <div key={d.id || i} className="flex items-start gap-3 p-3 bg-slate-50 rounded text-sm">
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2 flex-wrap">
                    {d.from_status && <StatusBadge status={d.from_status} />}
                    <span className="text-slate-400">→</span>
                    <StatusBadge status={d.to_status} />
                    <span className="text-slate-400 text-xs">({d.decision})</span>
                  </div>
                  {d.decider_name && (
                    <p className="text-xs text-slate-500 mt-1">{d.decider_name}</p>
                  )}
                  {d.decision_reason && (
                    <p className="text-xs text-slate-600 mt-1">{d.decision_reason}</p>
                  )}
                </div>
                <span className="text-xs text-slate-400 shrink-0">
                  {new Date(d.created_at).toLocaleDateString()}
                </span>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}
