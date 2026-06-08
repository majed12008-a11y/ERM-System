import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import api from '../../api/client'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Shield, Users, FileText, FolderKanban, Building2, ClipboardCheck, CalendarDays, Activity, ListChecks } from 'lucide-react'
import DataTable from '../../components/DataTable'
import { useTranslation } from 'react-i18next'

export default function AdminDashboard() {
  const { t } = useTranslation()
  const [auditAction, setAuditAction] = useState('')
  const [auditPage, setAuditPage] = useState(1)

  const { data: stats } = useQuery({
    queryKey: ['admin-stats'],
    queryFn: () => api.get('/admin/stats').then(r => r.data.data),
  })

  const { data: recentActivity } = useQuery({
    queryKey: ['admin-recent-activity'],
    queryFn: () => api.get('/admin/recent-activity').then(r => r.data.data),
    refetchInterval: 10000,
  })

  const { data: auditLog } = useQuery({
    queryKey: ['admin-audit-log', auditAction, auditPage],
    queryFn: () => api.get('/admin/audit-log', { params: { action: auditAction || undefined, page: auditPage, limit: 20 } }).then(r => r.data),
  })

  const { data: auditActions } = useQuery({
    queryKey: ['admin-audit-actions'],
    queryFn: () => api.get('/admin/audit-log/actions').then(r => r.data.data),
  })

  const statCards = [
    { label: t('admin.users'), value: stats?.users?.total ?? '—', sub: t('admin.activeUsers', { count: stats?.users?.active ?? 0 }), icon: Users, color: 'bg-blue-500' },
    { label: t('admin.applications'), value: stats?.applications?.total ?? '—', icon: FileText, color: 'bg-green-500' },
    { label: t('admin.projects'), value: stats?.projects?.total ?? '—', icon: FolderKanban, color: 'bg-purple-500' },
    { label: t('admin.committees'), value: stats?.committees?.total ?? '—', icon: Building2, color: 'bg-amber-500' },
    { label: t('admin.reviews'), value: stats?.reviews?.total ?? '—', icon: ClipboardCheck, color: 'bg-rose-500' },
    { label: t('admin.meetings'), value: stats?.meetings?.total ?? '—', icon: CalendarDays, color: 'bg-cyan-500' },
  ]

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <Shield className="w-6 h-6 text-blue-600" />
        <h1 className="text-2xl font-bold">{t('admin.title')}</h1>
      </div>

      <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-6 gap-4 mb-6">
        {statCards.map(c => (
          <div key={c.label} className="bg-white rounded-lg shadow p-4">
            <div className="flex items-center gap-2 mb-2">
              <div className={`${c.color} p-1.5 rounded text-white`}><c.icon className="w-4 h-4" /></div>
              <span className="text-xs text-slate-500">{c.label}</span>
            </div>
            <p className="text-2xl font-bold">{c.value}</p>
            {c.sub && <p className="text-xs text-green-600">{c.sub}</p>}
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-6">
        <Card>
          <CardHeader><CardTitle className="text-sm flex items-center gap-2"><Activity className="w-4 h-4" /> {t('admin.recentActivity')}</CardTitle></CardHeader>
          <CardContent>
            {recentActivity && recentActivity.length > 0 ? (
              <div className="space-y-2">
                {recentActivity.map((a: any) => (
                  <div key={a.id} className="flex items-center gap-3 text-sm border-b pb-2 last:border-0">
                    <div className="w-2 h-2 rounded-full bg-blue-500 flex-shrink-0" />
                    <div className="flex-1 min-w-0">
                      <p className="truncate"><span className="font-medium">{a.username || 'System'}</span> {a.action_type}</p>
                      {a.entity_type && <p className="text-xs text-slate-400">{a.entity_type} #{a.entity_id}</p>}
                    </div>
                    <span className="text-xs text-slate-400 flex-shrink-0">{new Date(a.created_at).toLocaleString()}</span>
                  </div>
                ))}
              </div>
            ) : <p className="text-sm text-slate-400">{t('admin.noRecentActivity')}</p>}
          </CardContent>
        </Card>

        <Card>
          <CardHeader><CardTitle className="text-sm flex items-center gap-2"><ListChecks className="w-4 h-4" /> {t('admin.auditLog')}</CardTitle></CardHeader>
          <CardContent>
            <div className="flex gap-2 mb-3">
              <select value={auditAction} onChange={e => { setAuditAction(e.target.value); setAuditPage(1) }} className="p-1.5 border rounded text-sm flex-1">
                <option value="">{t('admin.allActions')}</option>
                {auditActions?.map((a: string) => <option key={a} value={a}>{a}</option>)}
              </select>
            </div>
            <DataTable
              columns={[
                { key: 'username', label: t('admin.user') },
                { key: 'action_type', label: t('admin.action') },
                { key: 'entity_type', label: t('admin.entity') },
                { key: 'created_at', label: t('admin.time'), render: r => new Date(r.created_at).toLocaleString() },
              ]}
              data={auditLog?.data || []}
            />
            {auditLog?.total > 20 && (
              <div className="flex items-center justify-between mt-3 text-sm text-slate-500">
                <span>{t('admin.records', { count: auditLog.total })}</span>
                <div className="flex gap-2">
                  <Button size="sm" variant="outline" disabled={auditPage <= 1} onClick={() => setAuditPage(p => p - 1)}>{t('admin.previous')}</Button>
                  <Button size="sm" variant="outline" disabled={auditPage * 20 >= auditLog.total} onClick={() => setAuditPage(p => p + 1)}>{t('admin.next')}</Button>
                </div>
              </div>
            )}
          </CardContent>
        </Card>
      </div>
    </div>
  )
}