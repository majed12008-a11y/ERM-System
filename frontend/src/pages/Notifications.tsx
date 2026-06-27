/*
 * صفحة الإشعارات: عرض وإدارة جميع الإشعارات
 * المرسلة للمستخدم الحالي.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { toast } from 'sonner'
import api from '../api/client'
import DataTable from '../components/DataTable'
import ConfirmDialog from '../components/ConfirmDialog'
import { Bell, Check, CheckCheck, Trash2, Mail, MailOpen } from 'lucide-react'
import { Button } from '../components/ui/button'
import { useTranslation } from 'react-i18next'

export default function Notifications() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()

  const { data, isLoading } = useQuery({
    queryKey: ['notifications'],
    queryFn: () => api.get('/communication/notifications').then((r) => r.data.data),
  })

  const markRead = useMutation({
    mutationFn: (id: number) => api.patch(`/communication/notifications/${id}/read`),
    onSuccess: () => { toast.success(t('notifications.markedRead')); queryClient.invalidateQueries({ queryKey: ['notifications'] }) },
  })

  const markAllRead = useMutation({
    mutationFn: () => api.patch('/communication/notifications/read-all'),
    onSuccess: () => { toast.success(t('notifications.allMarkedRead')); queryClient.invalidateQueries({ queryKey: ['notifications'] }) },
  })

  const deleteNotif = useMutation({
    mutationFn: (id: number) => api.delete(`/communication/notifications/${id}`),
    onSuccess: () => { toast.success(t('notifications.deleted')); queryClient.invalidateQueries({ queryKey: ['notifications'] }); setDeleteTarget(null) },
  })

  const [deleteTarget, setDeleteTarget] = useState<number | null>(null)

  const notifications = data || []
  const unread = notifications.filter((n: any) => !n.is_read).length

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Bell className="w-6 h-6 text-blue-600" />
          <h1 className="text-2xl font-bold">{t('notifications.title')}</h1>
          {unread > 0 && (
            <span className="bg-red-100 text-red-700 text-xs px-2 py-1 rounded-full">{t('notifications.unread', { count: unread })}</span>
          )}
        </div>
        {unread > 0 && (
          <Button variant="outline" size="sm" onClick={() => markAllRead.mutate()} disabled={markAllRead.isPending}>
            <CheckCheck className="w-4 h-4 mr-1" /> {t('notifications.markAllRead')}
          </Button>
        )}
      </div>

      {isLoading ? (
        <p className="text-slate-400">{t('common.loading')}</p>
      ) : (
        <DataTable
          columns={[
            { key: 'is_read', label: '', render: (i) => i.is_read
              ? <MailOpen className="w-4 h-4 text-slate-300" />
              : <Mail className="w-4 h-4 text-blue-500" />
            },
            { key: 'subject', label: t('notifications.titleColumn'), render: (i) => (
              <div className="flex items-center gap-2">
                <span className={i.is_read ? 'text-slate-600' : 'font-semibold'}>{i.subject}</span>
                {!i.is_read && <span className="bg-blue-100 text-blue-700 text-[10px] px-1.5 py-0.5 rounded">{t('notifications.new')}</span>}
              </div>
            )},
            { key: 'message_body', label: t('notifications.message'), render: (i) => (
              <span className="text-sm text-slate-500 truncate max-w-xs block">{i.message_body}</span>
            )},
            { key: 'created_at', label: t('notifications.date'), render: (i) => (
              <span className="text-xs text-slate-400">{new Date(i.created_at).toLocaleString()}</span>
            )},
            { key: 'actions', label: '', render: (i) => (
              <div className="flex items-center gap-1">
                {!i.is_read && (
                  <button onClick={(e) => { e.stopPropagation(); markRead.mutate(i.id) }}
                    className="p-1 text-blue-600 hover:text-blue-800 rounded hover:bg-blue-50" title={t('notifications.markRead')}>
                    <Check className="w-4 h-4" />
                  </button>
                )}
                <button onClick={(e) => { e.stopPropagation(); setDeleteTarget(i.id) }}
                  className="p-1 text-red-500 hover:text-red-700 rounded hover:bg-red-50" title={t('notifications.delete')}>
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            )},
          ]}
          data={notifications}
          pageSize={15}
        />
      )}

      <ConfirmDialog
        open={deleteTarget !== null}
        onOpenChange={(o) => { if (!o) setDeleteTarget(null) }}
        title={t('notifications.deleteTitle')}
        description={t('notifications.deleteConfirm')}
        onConfirm={() => deleteTarget && deleteNotif.mutate(deleteTarget)}
        loading={deleteNotif.isPending}
      />
    </div>
  )
}
