import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { Plus } from 'lucide-react'
import { usePermission } from '../../hooks/usePermission'

export default function ApplicationList() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const canCreate = usePermission('application.create')
  const { data, isLoading } = useQuery({
    queryKey: ['applications'],
    queryFn: () => api.get('/core/applications').then((r) => r.data.data),
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
          ]}
          data={data || []}
          onRowClick={(item) => navigate(`/applications/${item.id}`)}
          emptyMessage={t('applications.empty')}
        />
    </div>
  )
}
