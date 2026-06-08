import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { Plus } from 'lucide-react'
import { usePermission } from '../../hooks/usePermission'

export default function ProjectList() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const canCreate = usePermission('project.create')
  const { data, isLoading } = useQuery({
    queryKey: ['projects'],
    queryFn: () => api.get('/core/projects').then((r) => r.data.data),
  })

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('projects.title')}</h1>
        {canCreate && (
          <button onClick={() => navigate('/projects/create')}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
            <Plus className="w-4 h-4" /> {t('projects.new')}
          </button>
        )}
      </div>

        <DataTable
          searchable
          loading={isLoading}
          columns={[
            { key: 'project_code', label: t('projects.code'), sortable: true },
            { key: 'title_ar', label: t('projects.titleAr'), sortable: true },
            { key: 'title_en', label: t('projects.titleEn'), sortable: true },
            { key: 'research_category', label: t('projects.category'), filterable: true, sortable: true },
            { key: 'risk_level', label: t('projects.riskLevel'), filterable: true, sortable: true },
            { key: 'institution_name', label: t('projects.institution'), sortable: true },
            { key: 'pi_username', label: t('projects.pi'), sortable: true },
          ]}
          data={data || []}
          onRowClick={(item) => navigate(`/projects/${item.id}`)}
          emptyMessage={t('projects.empty')}
        />
    </div>
  )
}
