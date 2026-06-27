/*
 * التخطيط الرئيسي للتطبيق: شريط التنقل، القائمة الجانبية،
 * ومحتوى الصفحة. يدعم التبديل بين اللغات (عربي/إنجليزي)
 * والوضع الليلي.
 */
import { useState, useMemo } from 'react'
import { Outlet, NavLink, useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { useAuth } from '../context/AuthContext'
import { useQuery } from '@tanstack/react-query'
import { useNotificationStream } from '../hooks/useNotificationStream'
import api from '../api/client'
import {
  LayoutDashboard, FileText, FolderKanban, Users, Shield,
  CalendarDays, ClipboardCheck, ClipboardList, Bell, LogOut, Menu, X,
  AlertTriangle, AlertCircle, AlertOctagon, CheckCircle, Search, Database,
  UserCircle, FileUp, BarChart3, MessageSquare, ShieldCheck, PenSquare, BookOpen, Hash,
  HardDrive, KeyRound, BookMarked, Settings2, Building2
} from 'lucide-react'
import { cn } from '../lib/utils'

interface NavItem {
  to: string
  labelKey: string
  icon: React.ComponentType<{ className?: string }>
  permission?: string
}

interface NavSection {
  section: string
  labelKey: string
  items: NavItem[]
}

export default function RootLayout() {
  const { t } = useTranslation()
  const { logout, user } = useAuth()
  const navigate = useNavigate()
  const [sidebarOpen, setSidebarOpen] = useState(false)

  useNotificationStream()

  const { data: notifications } = useQuery({
    queryKey: ['notifications-count'],
    queryFn: () => api.get('/communication/notifications').then((r) =>
      (r.data.data || []).filter((n: any) => !n.is_read).length
    ),
    refetchInterval: 300000,
  })

  function handleLogout() {
    logout()
    navigate('/login')
  }

  function closeSidebar() {
    setSidebarOpen(false)
  }

  const sections: NavSection[] = [
    {
      section: 'main',
      labelKey: 'nav.sectionMain',
      items: [
        { to: '/', labelKey: 'nav.dashboard', icon: LayoutDashboard },
      ],
    },
    {
      section: 'applications',
      labelKey: 'nav.sectionApplications',
      items: [
        { to: '/applications', labelKey: 'nav.applications', icon: FileText, permission: 'application.view' },
        { to: '/projects', labelKey: 'nav.projects', icon: FolderKanban, permission: 'project.view' },
      ],
    },
    {
      section: 'committee',
      labelKey: 'nav.sectionCommittee',
      items: [
        { to: '/committee/committees', labelKey: 'nav.committees', icon: Building2, permission: 'user.view' },
        { to: '/committee/meetings', labelKey: 'nav.meetings', icon: CalendarDays, permission: 'meeting.view' },
        { to: '/committee/reviews', labelKey: 'nav.myReviews', icon: ClipboardList, permission: 'review.view' },
        { to: '/admin/accreditation/cycles', labelKey: 'nav.accreditationCycles', icon: ShieldCheck, permission: 'user.view' },
        { to: '/review-forms', labelKey: 'nav.reviewForms', icon: ClipboardCheck, permission: 'review.view' },
        { to: '/e-signatures', labelKey: 'nav.eSignatures', icon: PenSquare, permission: 'review.view' },
      ],
    },
    {
      section: 'safety',
      labelKey: 'nav.sectionSafety',
      items: [
        { to: '/risk-register', labelKey: 'nav.riskRegister', icon: AlertTriangle, permission: 'risk.view' },
        { to: '/safety/adverse-events', labelKey: 'nav.adverseEvents', icon: AlertCircle, permission: 'adverse_event.view' },
        { to: '/safety/risk-incidents', labelKey: 'nav.riskIncidents', icon: AlertOctagon, permission: 'incident.view' },
        { to: '/safety/corrective-actions', labelKey: 'nav.correctiveActions', icon: CheckCircle, permission: 'corrective_action.view' },
      ],
    },
    {
      section: 'communication',
      labelKey: 'nav.sectionCommunication',
      items: [
        { to: '/notifications', labelKey: 'nav.notifications', icon: Bell },
        { to: '/messages', labelKey: 'nav.messages', icon: MessageSquare },
      ],
    },
    {
      section: 'tools',
      labelKey: 'nav.sectionTools',
      items: [
        { to: '/saved-searches', labelKey: 'nav.savedSearches', icon: Search },
        { to: '/registry', labelKey: 'nav.registry', icon: BookMarked },
        { to: '/documents', labelKey: 'nav.documents', icon: FileUp },
        { to: '/reports', labelKey: 'nav.reports', icon: BarChart3 },
      ],
    },
    {
      section: 'administration',
      labelKey: 'nav.sectionAdministration',
      items: [
        { to: '/admin', labelKey: 'nav.admin', icon: ShieldCheck, permission: 'user.view' },
        { to: '/users', labelKey: 'nav.users', icon: Users, permission: 'user.view' },
        { to: '/roles', labelKey: 'nav.roles', icon: KeyRound, permission: 'role.view' },
        { to: '/admin/notification-channels', labelKey: 'nav.notificationChannels', icon: Settings2, permission: 'user.view' },
        { to: '/admin/reference-data', labelKey: 'nav.referenceData', icon: BookOpen, permission: 'user.view' },
        { to: '/admin/backup', labelKey: 'nav.backup', icon: HardDrive, permission: 'user.view' },
      ],
    },
    {
      section: 'user',
      labelKey: 'nav.sectionUser',
      items: [
        { to: '/profile', labelKey: 'nav.profile', icon: UserCircle },
      ],
    },
  ]

  const visibleSections = useMemo(() => {
    return sections
      .map(s => ({
        ...s,
        items: s.items.filter(item => {
          if (!item.permission) return true
          return user?.permissions?.includes(item.permission)
        }),
      }))
      .filter(s => s.items.length > 0)
  }, [user, sections])

  const sidebar = (
    <aside className="w-64 bg-slate-800 text-white flex flex-col h-full">
      <div className="p-4 border-b border-slate-700 flex items-center justify-between">
        <div>
          <h2 className="font-bold text-lg">{t('app.titleShort')}</h2>
          <p className="text-xs text-slate-400">{user?.username}</p>
        </div>
        <button onClick={closeSidebar} className="md:hidden text-slate-400 hover:text-white">
          <X className="w-5 h-5" />
        </button>
      </div>
      <nav className="flex-1 p-2 space-y-1 overflow-y-auto">
        {visibleSections.map((section, si) => (
          <div key={section.section}>
            {si > 0 && <div className="border-t border-slate-700/50 my-2" />}
            <p className="px-3 pt-1 pb-1 text-xs font-semibold uppercase tracking-wider text-slate-500">
              {t(section.labelKey)}
            </p>
            {section.items.map((item) => (
              <NavLink
                key={item.to}
                to={item.to}
                end={item.to === '/'}
                onClick={closeSidebar}
                className={({ isActive }) =>
                  cn('flex items-center gap-3 px-3 py-2 rounded text-sm transition-colors relative',
                    isActive ? 'bg-blue-600 text-white' : 'text-slate-300 hover:bg-slate-700')
                }
              >
                <item.icon className="w-4 h-4 shrink-0" />
                <span className="truncate">{t(item.labelKey)}</span>
                {item.to === '/notifications' && (notifications || 0) > 0 && (
                  <span className="ms-auto bg-red-500 text-white text-xs w-5 h-5 rounded-full flex items-center justify-center shrink-0">
                    {notifications}
                  </span>
                )}
              </NavLink>
            ))}
          </div>
        ))}
      </nav>
      <div className="p-2 border-t border-slate-700">
        <button onClick={handleLogout}
          className="flex items-center gap-3 px-3 py-2 rounded text-sm text-slate-300 hover:bg-slate-700 w-full">
          <LogOut className="w-4 h-4 shrink-0" /> {t('nav.logout')}
        </button>
      </div>
    </aside>
  )

  return (
    <div className="flex h-screen bg-slate-50">
      {sidebarOpen && (
        <div className="fixed inset-0 bg-black/50 z-40 md:hidden" onClick={closeSidebar} />
      )}
      <div className={cn(
        'fixed inset-y-0 start-0 z-50 w-64 transform transition-transform duration-200 md:hidden',
        sidebarOpen ? 'translate-x-0' : 'ltr:-translate-x-full rtl:translate-x-full'
      )}>
        {sidebar}
      </div>
      <div className="hidden md:flex shrink-0">{sidebar}</div>
      {user && !user.is_email_verified && (
          <div className="bg-amber-50 border-b border-amber-200 px-4 py-2 text-sm text-amber-800 flex items-center gap-2">
            <AlertTriangle className="w-4 h-4 shrink-0" />
            <span>{t('verifyEmail.banner')}</span>
            <button
              onClick={async () => {
                try {
                  await api.post('/security/auth/resend-verification')
                  toast.success(t('verifyEmail.resendSuccess'))
                } catch { toast.error(t('verifyEmail.resendFailed')) }
              }}
              className="ms-auto text-amber-700 underline hover:text-amber-900 shrink-0"
            >
              {t('verifyEmail.resend')}
            </button>
          </div>
        )}
      <main className="flex-1 flex flex-col min-w-0">
        <div className="flex items-center gap-3 p-3 border-b bg-white md:hidden">
          <button onClick={() => setSidebarOpen(true)} className="p-1 hover:bg-slate-100 rounded">
            <Menu className="w-5 h-5" />
          </button>
          <h2 className="font-bold text-lg">{t('app.titleShort')}</h2>
        </div>
        <div className="flex-1 overflow-auto p-4 md:p-6">
          <Outlet />
        </div>
      </main>
    </div>
  )
}
