import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import api from '../api/client'
import { useAuth } from '../context/AuthContext'
import { useDashboardStream } from '../hooks/useDashboardStream'
import { FileText, FolderKanban, CalendarDays, ClipboardCheck, Bell } from 'lucide-react'
import { Button } from '../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { usePermission } from '../hooks/usePermission'

export default function Dashboard() {
  const { t } = useTranslation()
  const { user } = useAuth()
  const navigate = useNavigate()
  const canCreateApp = usePermission('application.create')
  const canCreateProject = usePermission('project.create')

  useDashboardStream()

  const { data: stats } = useQuery({
    queryKey: ['dashboard-stats'],
    queryFn: () => api.get('/reporting/dashboard/stats').then((r) => r.data.data),
  })

  const { data: unread } = useQuery({
    queryKey: ['notifications-count'],
    queryFn: () => api.get('/communication/notifications').then((r) =>
      (r.data.data || []).filter((n: any) => !n.is_read).length
    ),
  })

  const cards = [
    { labelKey: 'dashboard.applications', value: stats?.applications?.total ?? '—', icon: FileText, color: 'bg-blue-500', link: '/applications' },
    { labelKey: 'dashboard.projects', value: stats?.projects?.total ?? '—', icon: FolderKanban, color: 'bg-green-500', link: '/projects' },
    { labelKey: 'dashboard.upcomingMeetings', value: stats?.upcomingMeetings?.total ?? '—', icon: CalendarDays, color: 'bg-purple-500', link: '/committee/meetings' },
    { labelKey: 'dashboard.pendingReviews', value: stats?.pendingReviews?.pending ?? '—', icon: ClipboardCheck, color: 'bg-amber-500', link: '/committee/reviews' },
    { labelKey: 'dashboard.notifications', value: unread ?? 0, icon: Bell, color: 'bg-rose-500', link: '/notifications' },
  ]

  const statusCards = stats?.applications ? [
    { labelKey: 'dashboard.submitted', value: stats.applications.submitted, color: 'text-blue-600' },
    { labelKey: 'dashboard.underReview', value: stats.applications.under_review, color: 'text-amber-600' },
    { labelKey: 'dashboard.approved', value: stats.applications.approved, color: 'text-green-600' },
    { labelKey: 'dashboard.rejected', value: stats.applications.rejected, color: 'text-red-600' },
  ] : []

  return (
    <div>
      <h1 className="text-2xl font-bold mb-2">{t('dashboard.title')}</h1>
      <p className="text-muted-foreground mb-6">{t('dashboard.welcome', { username: user?.username, roles: user?.roles?.join(', ') })}</p>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
        {cards.map((card) => (
          <Card key={card.labelKey} onClick={() => navigate(card.link)} className="cursor-pointer hover:shadow-md transition-shadow">
            <CardContent className="flex items-center gap-4 p-4">
              <div className={`${card.color} p-3 rounded-lg`}>
                <card.icon className="text-white w-5 h-5" />
              </div>
              <div>
                <p className="text-xs text-muted-foreground">{t(card.labelKey)}</p>
                <p className="text-2xl font-bold">{card.value}</p>
              </div>
            </CardContent>
          </Card>
        ))}
      </div>

      {statusCards.length > 0 && (
        <Card className="mt-6">
          <CardHeader>
            <CardTitle className="text-sm">{t('dashboard.statusBreakdown')}</CardTitle>
          </CardHeader>
          <CardContent>
            <div className="flex flex-wrap gap-4 sm:gap-6">
              {statusCards.map((s) => (
                <div key={s.labelKey} className="text-center flex-1 min-w-[80px]">
                  <p className={`text-xl sm:text-2xl font-bold ${s.color}`}>{s.value}</p>
                  <p className="text-xs text-muted-foreground">{t(s.labelKey)}</p>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      )}

      {(canCreateApp || canCreateProject) && (
        <Card className="mt-6">
          <CardHeader>
            <CardTitle className="text-sm">{t('dashboard.quickActions')}</CardTitle>
          </CardHeader>
          <CardContent className="flex flex-wrap gap-3">
            {canCreateApp && <Button onClick={() => navigate('/applications/create')}>{t('dashboard.newApplication')}</Button>}
            {canCreateProject && <Button variant="secondary" onClick={() => navigate('/projects/create')}>{t('dashboard.newProject')}</Button>}
          </CardContent>
        </Card>
      )}
    </div>
  )
}
