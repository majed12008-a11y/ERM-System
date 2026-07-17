/*
 * صفحة التقارير: تقارير وإحصائيات عن الطلبات والمشاريع
 * واللجان مع إمكانية التصفية والبحث.
 */
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { useQuery } from '@tanstack/react-query'
import { reporting } from '../../sdk/domains/reporting.sdk'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import DataTable from '../../components/DataTable'
import DocumentGenerationSection from '../../components/DocumentGenerationSection'
import type { DocumentAction } from '../../components/DocumentGenerationSection'
import { BarChart3, Download, FileText, Building2, ListChecks, TrendingUp, AlertCircle } from 'lucide-react'
import { BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, PieChart, Pie, Cell, LineChart, Line } from 'recharts'
import { useTranslation } from 'react-i18next'

const STATUS_COLORS: Record<string, string> = {
  SUBMITTED: '#f59e0b', UNDER_REVIEW: '#3b82f6', APPROVED: '#10b981',
  REJECTED: '#ef4444', CONDITIONAL: '#8b5cf6', WITHDRAWN: '#6b7280', CLOSED: '#374151',
}

const allStatuses = ['SUBMITTED', 'UNDER_REVIEW', 'APPROVED', 'REJECTED', 'CONDITIONAL', 'WITHDRAWN', 'CLOSED']

type FilterData = { statusFilter: string; dateFrom: string; dateTo: string; search: string }

export default function ReportsPage() {
  const { t } = useTranslation()
  const [tab, setTab] = useState<'applications' | 'committees' | 'status' | 'charts'>('applications')
  const { register, watch } = useForm<FilterData>({
    defaultValues: { statusFilter: '', dateFrom: '', dateTo: '', search: '' },
  })
  const statusFilter = watch('statusFilter')
  const dateFrom = watch('dateFrom')
  const dateTo = watch('dateTo')
  const search = watch('search')

  const appsQuery = useQuery({
    queryKey: ['report-apps', statusFilter, dateFrom, dateTo, search],
    queryFn: () => reporting.getApplications({
      status: statusFilter || undefined, from: dateFrom || undefined,
      to: dateTo || undefined, search: search || undefined,
    }).then(r => r.data),
    enabled: tab === 'applications',
  })

  const committeesQuery = useQuery({
    queryKey: ['report-committees'],
    queryFn: () => reporting.getCommittees().then(r => r.data),
    enabled: tab === 'committees',
  })

  const statusQuery = useQuery({
    queryKey: ['report-status-summary'],
    queryFn: () => reporting.getStatusSummary().then(r => r.data),
    enabled: tab === 'status' || tab === 'charts',
  })

  const trendQuery = useQuery({
    queryKey: ['report-trend'],
    queryFn: () => reporting.getApplicationsTrend().then(r => r.data),
    enabled: tab === 'charts',
  })

  async function exportCSV() {
    const res = await reporting.exportApplications()
    const url = window.URL.createObjectURL(new Blob([res.data]))
    const a = document.createElement('a')
    a.href = url
    a.download = 'applications.csv'
    a.click()
    window.URL.revokeObjectURL(url)
  }

  const reportActions: DocumentAction[] = [
    { key: 'annual', labelKey: 'reports.docAnnual', templateCode: 'report.annual', getVariables: () => ({ report_type: 'annual', year: new Date().getFullYear() }) },
  ]

  const tabs = [
    { key: 'applications' as const, label: t('reports.applicationsReport'), icon: FileText },
    { key: 'committees' as const, label: t('reports.committeeStats'), icon: Building2 },
    { key: 'status' as const, label: t('reports.statusSummary'), icon: ListChecks },
    { key: 'charts' as const, label: t('reports.chartsTrends'), icon: TrendingUp },
  ]

  const renderError = (msg: string) => (
    <div className="flex items-center gap-2 text-red-600 text-sm p-4">
      <AlertCircle className="w-4 h-4" />
      <span>{msg}</span>
    </div>
  )

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <BarChart3 className="w-6 h-6 text-blue-600" />
        <h1 className="text-2xl font-bold">{t('reports.title')}</h1>
      </div>

      <div className="flex gap-2 mb-6 border-b pb-2">
        {tabs.map(t => (
          <button key={t.key} onClick={() => setTab(t.key)}
            className={`px-4 py-2 text-sm rounded-t font-medium ${tab === t.key ? 'bg-white border border-b-0 border-slate-200 text-blue-600' : 'text-slate-500 hover:text-slate-700'}`}>
            <t.icon className="w-4 h-4 inline mr-1" />{t.label}
          </button>
        ))}
      </div>

      {tab === 'applications' && (
        <div>
          <div className="flex gap-3 mb-4 items-end flex-wrap">
            <div>
              <label className="block text-xs text-slate-500 mb-1">{t('reports.status')}</label>
              <select {...register('statusFilter')} className="p-2 border rounded text-sm">
                <option value="">{t('reports.all')}</option>
                {allStatuses.map(s => <option key={s} value={s}>{s}</option>)}
              </select>
            </div>
            <div>
              <label className="block text-xs text-slate-500 mb-1">{t('common.from')}</label>
              <input type="date" {...register('dateFrom')} className="p-2 border rounded text-sm" />
            </div>
            <div>
              <label className="block text-xs text-slate-500 mb-1">{t('common.to')}</label>
              <input type="date" {...register('dateTo')} className="p-2 border rounded text-sm" />
            </div>
            <div>
              <label className="block text-xs text-slate-500 mb-1">{t('common.search')}</label>
              <Input placeholder={t('reports.search')} {...register('search')} className="text-sm" />
            </div>
            <Button variant="outline" size="sm" onClick={exportCSV}><Download className="w-3 h-3 mr-1" />{t('reports.exportCsv')}</Button>
          </div>
          {appsQuery.isError ? renderError(t('common.error')) : (
            <DataTable
              columns={[
                { key: 'application_number', label: t('reports.appNumber') },
                { key: 'project_title', label: t('reports.project') },
                { key: 'current_status', label: t('reports.status') },
                { key: 'application_type', label: t('reports.type') },
                { key: 'committee_name', label: t('reports.committee') },
                { key: 'created_at', label: t('reports.created'), render: (r: any) => new Date(r.created_at).toLocaleDateString() },
              ]}
              data={appsQuery.data?.data || []}
              loading={appsQuery.isLoading}
            />
          )}
        </div>
      )}

      {tab === 'committees' && (
        <div>
          {committeesQuery.isError ? renderError(t('common.error')) : (
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {committeesQuery.isLoading ? (
                Array.from({ length: 3 }).map((_, i) => (
                  <Card key={i}><CardContent className="p-6 animate-pulse"><div className="h-20 bg-slate-100 rounded" /></CardContent></Card>
                ))
              ) : committeesQuery.data?.data && committeesQuery.data.data.length > 0 ? committeesQuery.data.data.map((c: any) => (
                <Card key={c.id}>
                  <CardHeader><CardTitle className="text-sm">{c.committee_name_ar}</CardTitle></CardHeader>
                  <CardContent className="text-sm space-y-2">
                    <p><span className="text-slate-500">{t('reports.typeLabel')}</span> {c.committee_type || '-'}</p>
                    <p><span className="text-slate-500">{t('reports.totalReviews')}</span> {c.total_reviews}</p>
                    <p><span className="text-slate-500">{t('reports.totalMeetings')}</span> {c.total_meetings}</p>
                  </CardContent>
                </Card>
              )) : <p className="text-slate-400">{t('reports.noCommitteeData')}</p>}
            </div>
          )}
        </div>
      )}

      {tab === 'status' && (
        <div className="max-w-md">
          {statusQuery.isError ? renderError(t('common.error')) : (
            <Card>
              <CardHeader><CardTitle className="text-sm">{t('reports.statusBreakdown')}</CardTitle></CardHeader>
              <CardContent>
                {statusQuery.isLoading ? (
                  <div className="space-y-3">{Array.from({ length: 5 }).map((_, i) => <div key={i} className="h-8 bg-slate-100 rounded animate-pulse" />)}</div>
                ) : statusQuery.data?.data && statusQuery.data.data.length > 0 ? (
                  <div className="space-y-3">
                    {statusQuery.data.data.map((s: any) => (
                      <div key={s.current_status} className="flex items-center justify-between text-sm border-b pb-2 last:border-0">
                        <span className="font-medium">{s.current_status}</span>
                        <span className="text-lg font-bold text-blue-600">{s.count}</span>
                      </div>
                    ))}
                  </div>
                ) : <p className="text-slate-400">{t('reports.noData')}</p>}
              </CardContent>
            </Card>
          )}
        </div>
      )}

      {tab === 'charts' && (
        <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <Card>
            <CardHeader><CardTitle className="text-sm">{t('reports.statusDistribution')}</CardTitle></CardHeader>
            <CardContent>
              {statusQuery.isError ? renderError(t('common.error')) : statusQuery.isLoading ? (
                <div className="h-[300px] bg-slate-100 rounded animate-pulse" />
              ) : statusQuery.data?.data && statusQuery.data.data.length > 0 ? (
                <ResponsiveContainer width="100%" height={300}>
                  <PieChart>
                    <Pie data={statusQuery.data.data} dataKey="count" nameKey="current_status" cx="50%" cy="50%" outerRadius={100} label={({ name, value }: any) => `${name}: ${value}`}>
                      {statusQuery.data.data.map((s: any) => <Cell key={s.current_status} fill={STATUS_COLORS[s.current_status] || '#94a3b8'} />)}
                    </Pie>
                    <Tooltip />
                  </PieChart>
                </ResponsiveContainer>
              ) : <p className="text-sm text-slate-400">{t('reports.noData')}</p>}
            </CardContent>
          </Card>

          <Card>
            <CardHeader><CardTitle className="text-sm">{t('reports.statusBarChart')}</CardTitle></CardHeader>
            <CardContent>
              {statusQuery.isError ? renderError(t('common.error')) : statusQuery.isLoading ? (
                <div className="h-[300px] bg-slate-100 rounded animate-pulse" />
              ) : statusQuery.data?.data && statusQuery.data.data.length > 0 ? (
                <ResponsiveContainer width="100%" height={300}>
                  <BarChart data={statusQuery.data.data}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="current_status" tick={{ fontSize: 12 }} />
                    <YAxis />
                    <Tooltip />
                    <Bar dataKey="count" radius={[4, 4, 0, 0]}>
                      {statusQuery.data.data.map((s: any) => <Cell key={s.current_status} fill={STATUS_COLORS[s.current_status] || '#94a3b8'} />)}
                    </Bar>
                  </BarChart>
                </ResponsiveContainer>
              ) : <p className="text-sm text-slate-400">{t('reports.noData')}</p>}
            </CardContent>
          </Card>

          <Card className="lg:col-span-2">
            <CardHeader><CardTitle className="text-sm">{t('reports.monthlyTrend')}</CardTitle></CardHeader>
            <CardContent>
              {trendQuery.isError ? renderError(t('common.error')) : trendQuery.isLoading ? (
                <div className="h-[300px] bg-slate-100 rounded animate-pulse" />
              ) : trendQuery.data?.data && trendQuery.data.data.length > 0 ? (
                <ResponsiveContainer width="100%" height={300}>
                  <LineChart data={trendQuery.data.data}>
                    <CartesianGrid strokeDasharray="3 3" />
                    <XAxis dataKey="month" tick={{ fontSize: 12 }} />
                    <YAxis />
                    <Tooltip />
                    <Line type="monotone" dataKey="count" stroke="#3b82f6" strokeWidth={2} dot={{ r: 4 }} />
                  </LineChart>
                </ResponsiveContainer>
              ) : <p className="text-sm text-slate-400">{t('reports.noData')}</p>}
            </CardContent>
          </Card>
        </div>
      )}

      <DocumentGenerationSection actions={reportActions} />
    </div>
  )
}
