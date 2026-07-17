import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useAuth } from '../context/AuthContext'
import { useDashboardStream } from '../hooks/useDashboardStream'
import { reporting } from '../sdk/domains/reporting.sdk'
import { admin } from '../sdk/domains/admin.sdk'
import { notifications } from '../sdk/domains/communication.sdk'
import {
  FileText, FolderKanban, CalendarDays, ClipboardCheck, Bell,
  BarChart3, ArrowRight, History, CheckCircle2, AlertTriangle
} from 'lucide-react'
import { Button } from '../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { usePermission } from '../hooks/usePermission'
import {
  BarChart, Bar, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer
} from 'recharts'

const kpiConfig = [
  { labelKey: 'dashboard.applications', icon: FileText, bg: '#0a2540', link: '/applications', key: ['applications', 'total'] },
  { labelKey: 'dashboard.projects', icon: FolderKanban, bg: '#1a8a3f', link: '/projects', key: ['projects', 'total'] },
  { labelKey: 'dashboard.upcomingMeetings', icon: CalendarDays, bg: '#0d9488', link: '/committee/meetings', key: ['upcomingMeetings', 'total'] },
  { labelKey: 'dashboard.pendingReviews', icon: ClipboardCheck, bg: '#d97706', link: '/committee/reviews', key: ['pendingReviews', 'pending'] },
  { labelKey: 'dashboard.notifications', icon: Bell, bg: '#dc2626', link: '/notifications', key: null },
]

function getNested(obj: any, path: string[]): any {
  return path ? path.reduce((o, k) => (o ?? {})[k], obj) : null
}

export default function Dashboard() {
  const { t } = useTranslation()
  const { user } = useAuth()
  const navigate = useNavigate()
  const canCreateApp = usePermission('application.create')

  useDashboardStream()

  const statsQuery = useQuery({
    queryKey: ['dashboard-stats'],
    queryFn: () => reporting.getDashboardStats().then(r => r.data.data),
  })

  const unreadQuery = useQuery({
    queryKey: ['notifications-count'],
    queryFn: () => notifications.getUnreadCount().then(r => r.data.data.count),
  })

  const trendQuery = useQuery({
    queryKey: ['report-trend'],
    queryFn: () => reporting.getApplicationsTrend().then(r => r.data.data),
  })

  const activityQuery = useQuery({
    queryKey: ['recent-activity'],
    queryFn: () => admin.getRecentActivity().then(r => r.data.data),
  })

  const stats = statsQuery.data
  const trendData = trendQuery.data || []
  const activity = activityQuery.data || []
  const pendingCount = stats?.pendingReviews?.pending ?? 0

  const quickActions = [
    { labelKey: 'dashboard.newApplication', icon: FileText, link: '/applications/create', show: canCreateApp },
    { labelKey: 'dashboard.pendingReviews', icon: ClipboardCheck, link: '/committee/reviews', show: true },
    { labelKey: 'dashboard.reports', icon: BarChart3, link: '/reports', show: true },
    { labelKey: 'dashboard.scheduleMeeting', icon: CalendarDays, link: '/committee/meetings', show: true },
  ].filter(a => a.show)

  const renderError = (msg: string) => (
    <div role="alert" className="bg-danger-light text-danger rounded-lg px-4 py-3 text-sm flex items-center gap-2 mb-4">
      <AlertTriangle className="w-4 h-4 shrink-0" />
      <span>{msg}</span>
      <Button variant="ghost" size="sm" className="ms-auto" onClick={() => window.location.reload()}>
        {t('common.retry')}
      </Button>
    </div>
  )

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-foreground">{t('dashboard.title')}</h1>
        <p className="text-muted-foreground text-sm mt-1">
          {t('dashboard.welcome', { username: user?.username, roles: user?.roles?.join(', ') })}
        </p>
      </div>

      {/* KPI Cards */}
      {statsQuery.isPending ? (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
          {Array.from({ length: 5 }).map((_, i) => (
            <div key={i} className="rounded-xl bg-muted p-6 space-y-3 animate-pulse">
              <div className="h-10 w-10 bg-muted-foreground/20 rounded-lg" />
              <div className="h-4 bg-muted-foreground/20 rounded w-1/2" />
              <div className="h-8 bg-muted-foreground/20 rounded w-1/3" />
            </div>
          ))}
        </div>
      ) : statsQuery.isError ? (
        renderError(t('dashboard.loadError'))
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
          {kpiConfig.map((cfg) => {
            const value = cfg.key ? (getNested(stats, cfg.key) ?? '—') : (unreadQuery.data ?? 0)
            const Icon = cfg.icon
            return (
              <Card
                key={cfg.labelKey}
                onClick={() => navigate(cfg.link)}
                className="cursor-pointer hover:shadow-md transition-all overflow-hidden border-0"
              >
                <CardContent className="p-0">
                  <div
                    className="p-5 text-white"
                    style={{ backgroundColor: cfg.bg }}
                  >
                    <Icon className="w-8 h-8 mb-3 opacity-30" />
                    <p className="text-sm font-medium opacity-90">{t(cfg.labelKey)}</p>
                    <p className="text-3xl font-bold mt-1">{value}</p>
                  </div>
                </CardContent>
              </Card>
            )
          })}
        </div>
      )}

      {/* Content grid */}
      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mt-6">

        {/* Chart — spans 2 cols */}
        <Card className="lg:col-span-2">
          <CardHeader>
            <CardTitle className="text-sm font-semibold">{t('dashboard.applicationsTrend')}</CardTitle>
          </CardHeader>
          <CardContent>
            {trendQuery.isPending ? (
              <div className="h-[280px] bg-muted rounded animate-pulse" />
            ) : trendQuery.isError ? (
              <p className="text-sm text-muted-foreground">{t('common.error')}</p>
            ) : trendData.length > 0 ? (
              <ResponsiveContainer width="100%" height={280}>
                <BarChart data={trendData}>
                  <CartesianGrid strokeDasharray="3 3" stroke="hsl(var(--border))" />
                  <XAxis dataKey="month" tick={{ fontSize: 12 }} stroke="hsl(var(--muted-foreground))" />
                  <YAxis tick={{ fontSize: 12 }} stroke="hsl(var(--muted-foreground))" />
                  <Tooltip
                    contentStyle={{
                      backgroundColor: 'hsl(var(--card))',
                      border: '1px solid hsl(var(--border))',
                      borderRadius: '0.5rem',
                      fontSize: '0.875rem',
                    }}
                  />
                  <Bar dataKey="count" fill="#0a2540" radius={[4, 4, 0, 0]} maxBarSize={40} />
                </BarChart>
              </ResponsiveContainer>
            ) : (
              <p className="text-sm text-muted-foreground">{t('reports.noData')}</p>
            )}
          </CardContent>
        </Card>

        {/* Recent Activity */}
        <Card>
          <CardHeader>
            <CardTitle className="text-sm font-semibold">{t('dashboard.recentActivity')}</CardTitle>
          </CardHeader>
          <CardContent>
            {activityQuery.isPending ? (
              <div className="space-y-3">{Array.from({ length: 4 }).map((_, i) => <div key={i} className="h-10 bg-muted rounded animate-pulse" />)}</div>
            ) : activity.length > 0 ? (
              <div className="space-y-3 max-h-64 overflow-y-auto">
                {activity.slice(0, 5).map((a: any) => (
                  <div key={a.id} className="flex items-start gap-3 text-sm border-b pb-2 last:border-0">
                    <CheckCircle2 className="w-4 h-4 text-muted-foreground shrink-0 mt-0.5" />
                    <div className="min-w-0">
                      <p className="font-medium truncate">{a.username || t('dashboard.system')}</p>
                      <p className="text-muted-foreground text-xs truncate">{a.action} — {a.entity_type}</p>
                      <p className="text-muted-foreground text-xs">{new Date(a.created_at).toLocaleString()}</p>
                    </div>
                  </div>
                ))}
              </div>
            ) : (
              <div className="flex flex-col items-center justify-center py-8 text-center">
                <History className="w-10 h-10 text-muted-foreground/40 mb-3" />
                <p className="text-sm text-muted-foreground">{t('dashboard.noRecentActivity')}</p>
              </div>
            )}
          </CardContent>
        </Card>

        {/* Quick Actions */}
        <Card>
          <CardHeader>
            <CardTitle className="text-sm font-semibold">{t('dashboard.quickActions')}</CardTitle>
          </CardHeader>
          <CardContent className="space-y-2">
            {quickActions.map((action) => {
              const Icon = action.icon
              return (
                <button
                  key={action.labelKey}
                  onClick={() => navigate(action.link)}
                  className="w-full flex items-center gap-3 px-4 py-3 rounded-lg border hover:shadow-sm hover:border-primary/20 transition-all text-start group"
                >
                  <Icon className="w-5 h-5 text-primary shrink-0" />
                  <span className="text-sm font-medium flex-1">{t(action.labelKey)}</span>
                  <ArrowRight className="w-4 h-4 text-muted-foreground group-hover:text-primary transition-colors" />
                </button>
              )
            })}
          </CardContent>
        </Card>

        {/* Pending Reviews */}
        <Card>
          <CardHeader>
            <CardTitle className="text-sm font-semibold">{t('dashboard.pendingReviews')}</CardTitle>
          </CardHeader>
          <CardContent>
            {statsQuery.isPending ? (
              <div className="h-24 bg-muted rounded animate-pulse" />
            ) : pendingCount > 0 ? (
              <div className="flex flex-col items-center justify-center py-4">
                <p className="text-4xl font-bold text-primary">{pendingCount}</p>
                <p className="text-sm text-muted-foreground mt-1">{t('dashboard.pendingReviewItems')}</p>
                <Button variant="outline" size="sm" className="mt-3" onClick={() => navigate('/committee/reviews')}>
                  {t('dashboard.viewAll')}
                </Button>
              </div>
            ) : (
              <div className="flex flex-col items-center justify-center py-8 text-center">
                <CheckCircle2 className="w-10 h-10 text-muted-foreground/40 mb-3" />
                <p className="text-sm text-muted-foreground">{t('dashboard.allCaughtUp')}</p>
              </div>
            )}
          </CardContent>
        </Card>

      </div>
    </div>
  )
}
