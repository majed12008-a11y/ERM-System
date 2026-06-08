import { useState } from 'react'
import { Outlet, NavLink, useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useAuth } from '../context/AuthContext'
import { useQuery } from '@tanstack/react-query'
import api from '../api/client'
import { useNotificationStream } from '../hooks/useNotificationStream'
import {
  LayoutDashboard, FileText, FolderKanban, Users, Shield,
  CalendarDays, ClipboardCheck, Bell, LogOut, Menu, X,
  AlertTriangle, Search, Database, UserCircle, FileUp, BarChart3, MessageSquare, ShieldCheck, PenSquare
} from 'lucide-react'
import { cn } from '../lib/utils'

interface NavItem {
  to: string
  labelKey: string
  icon: React.ComponentType<{ className?: string }>
  permission?: string
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

  const navItems: NavItem[] = [
    { to: '/', labelKey: 'nav.dashboard', icon: LayoutDashboard },
    { to: '/applications', labelKey: 'nav.applications', icon: FileText, permission: 'application.view' },
    { to: '/projects', labelKey: 'nav.projects', icon: FolderKanban, permission: 'project.view' },
    { to: '/committee/committees', labelKey: 'nav.committees', icon: Shield, permission: 'user.view' },
    { to: '/committee/meetings', labelKey: 'nav.meetings', icon: CalendarDays, permission: 'meeting.view' },
    { to: '/committee/reviews', labelKey: 'nav.myReviews', icon: ClipboardCheck, permission: 'review.view' },
    { to: '/review-forms', labelKey: 'nav.reviewForms', icon: ClipboardCheck, permission: 'review.view' },
    { to: '/e-signatures', labelKey: 'nav.eSignatures', icon: PenSquare, permission: 'review.view' },
    { to: '/notifications', labelKey: 'nav.notifications', icon: Bell },
    { to: '/users', labelKey: 'nav.users', icon: Users, permission: 'user.view' },
    { to: '/roles', labelKey: 'nav.roles', icon: Shield, permission: 'role.view' },
    { to: '/risk-register', labelKey: 'nav.riskRegister', icon: AlertTriangle, permission: 'risk.view' },
    { to: '/saved-searches', labelKey: 'nav.savedSearches', icon: Search },
    { to: '/registry', labelKey: 'nav.registry', icon: Database },
    { to: '/messages', labelKey: 'nav.messages', icon: MessageSquare },
    { to: '/admin', labelKey: 'nav.admin', icon: ShieldCheck, permission: 'user.view' },
    { to: '/documents', labelKey: 'nav.documents', icon: FileUp },
    { to: '/reports', labelKey: 'nav.reports', icon: BarChart3 },
    { to: '/profile', labelKey: 'nav.profile', icon: UserCircle },
  ]

  const visibleItems = navItems.filter((item) => {
    if (!item.permission) return true
    return user?.permissions?.includes(item.permission)
  })

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
        {visibleItems.map((item) => (
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
