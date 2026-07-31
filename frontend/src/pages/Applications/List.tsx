/*
 * صفحة عرض طلبات البحث: جدول مزود بالترقيم والبحث والتصفية
 * حسب الحالة والنوع والتاريخ.
 */
import { useState } from 'react'
import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { applications } from '../../sdk/domains/applications.sdk'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { Plus, Pencil, Send } from 'lucide-react'
import { usePermission } from '../../hooks/usePermission'

export default function ApplicationList() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const canCreate = usePermission('application.create')
  const [statusFilter, setStatusFilter] = useState('')
  const { data, isLoading } = useQuery({
    queryKey: ['applications', statusFilter],
    queryFn: () => applications.list(statusFilter ? { status: statusFilter } : undefined).then((r) => r.data.data),
  })

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('applications.title')}</h1>
        {canCreate && (
          <button onClick={() => navigate('/applications/create')}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
            <Plus className="w-4 h-4" /> {t('applications.new')}
          </button>
        )}
      </div>

      <div className="flex items-center gap-2 mb-3">
        <span className="text-sm text-slate-500">{t('common.status')}:</span>
        <select
          value={statusFilter}
          onChange={e => setStatusFilter(e.target.value)}
          className="p-1.5 border rounded text-sm bg-card"
        >
          <option value="">{t('common.all')}</option>
          <option value="DRAFT">{t('status.DRAFT')}</option>
          <option value="SUBMITTED">{t('status.SUBMITTED')}</option>
          <option value="INITIAL_REVIEW">{t('applications.initialReview')}</option>
          <option value="APPROVED">{t('status.APPROVED')}</option>
          <option value="REJECTED">{t('status.REJECTED')}</option>
          <option value="RETURNED">{t('applications.editDraft')}</option>
          <option value="WITHDRAWN">{t('status.WITHDRAWN')}</option>
        </select>
      </div>

        <DataTable
          searchable
          loading={isLoading}
          columns={[
            { key: 'application_number', label: t('applications.number'), sortable: true },
            { key: 'project_title', label: t('applications.project'), sortable: true },
            { key: 'application_type', label: t('applications.type'), filterable: true, sortable: true },
            { key: 'current_status', label: t('applications.status'), filterable: true, sortable: true, render: (i) => <StatusBadge status={i.current_status} /> },
            { key: 'submitted_by_username', label: t('applications.submittedBy'), sortable: true },
            { key: 'created_at', label: t('applications.date'), sortable: true, render: (i) => new Date(i.created_at).toLocaleDateString() },
            { key: 'actions', label: '', render: (i: any) => (
              <div className="flex items-center gap-1" onClick={(e) => e.stopPropagation()}>
                {i.current_status === 'DRAFT' && (
                  <>
                    <button onClick={() => navigate(`/applications/${i.id}/edit`)}
                      className="p-1 text-slate-500 hover:text-blue-600 hover:bg-blue-50 rounded" title={t('applications.edit')}>
                      <Pencil className="w-4 h-4" />
                    </button>
                    <button onClick={() => navigate(`/applications/${i.id}/edit`)}
                      className="p-1 text-slate-500 hover:text-green-600 hover:bg-green-50 rounded" title={t('applications.submit')}>
                      <Send className="w-4 h-4" />
                    </button>
                  </>
                )}
              </div>
            )},
          ]}
          data={data || []}
          onRowClick={(item) => navigate(`/applications/${item.id}`)}
          emptyMessage={t('applications.empty')}
        />
    </div>
  )
}
