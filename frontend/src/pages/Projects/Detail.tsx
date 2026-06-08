import { useParams, useNavigate } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { useAuth } from '../../context/AuthContext'
import { ArrowLeft, FileText, FolderKanban, Calendar, User, BarChart3, Plus } from 'lucide-react'
import { PageSkeleton } from '../../components/LoadingSkeleton'

export default function ProjectDetail() {
  const { t } = useTranslation()
  const { id } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()

  const { data: project, isLoading } = useQuery({
    queryKey: ['project', id],
    queryFn: () => api.get(`/core/projects/${id}`).then((r) => r.data.data),
  })

  const { data: applications } = useQuery({
    queryKey: ['project-applications', id],
    queryFn: () => api.get(`/core/projects/${id}/applications`).then((r) => r.data.data),
    enabled: !!id,
  })

  const { data: stats } = useQuery({
    queryKey: ['project-app-stats', id],
    queryFn: () => api.get(`/core/projects/${id}/stats`).then((r) => r.data.data),
    enabled: !!id,
  })

  if (isLoading) return <PageSkeleton />
  if (!project) return <p className="text-red-500">{t('projects.notFound')}</p>

  const canCreate = user?.permissions?.includes('application.create')

  return (
    <div>
      <button onClick={() => navigate('/projects')}
        className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4">
        <ArrowLeft className="w-4 h-4" /> {t('projects.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{project.title_ar || project.title_en}</h1>
        {canCreate && (
          <Button size="sm" onClick={() => navigate(`/applications/create?projectId=${id}`)}>
            <Plus className="w-3 h-3 me-1" /> {t('projects.newApplication')}
          </Button>
        )}
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="bg-white rounded-lg shadow p-4 flex items-center gap-3">
          <div className="bg-slate-100 p-2 rounded"><FolderKanban className="w-5 h-5 text-slate-600" /></div>
          <div><p className="text-xs text-slate-500">{t('projects.code')}</p><p className="text-sm font-medium">{project.project_code}</p></div>
        </div>
        <div className="bg-white rounded-lg shadow p-4 flex items-center gap-3">
          <div className="bg-slate-100 p-2 rounded"><User className="w-5 h-5 text-slate-600" /></div>
          <div><p className="text-xs text-slate-500">{t('projects.pi')}</p><p className="text-sm font-medium">{project.pi_username || '\u2014'}</p></div>
        </div>
        <div className="bg-white rounded-lg shadow p-4 flex items-center gap-3">
          <div className="bg-slate-100 p-2 rounded"><BarChart3 className="w-5 h-5 text-slate-600" /></div>
          <div><p className="text-xs text-slate-500">{t('projects.category')}</p><p className="text-sm font-medium">{project.research_category || '\u2014'}</p></div>
        </div>
        <div className="bg-white rounded-lg shadow p-4 flex items-center gap-3">
          <div className="bg-slate-100 p-2 rounded"><Calendar className="w-5 h-5 text-slate-600" /></div>
          <div><p className="text-xs text-slate-500">{t('projects.riskLevel')}</p><p className="text-sm font-medium">{project.risk_level || '\u2014'}</p></div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
        <div className="lg:col-span-2">
          <Card>
            <CardHeader><CardTitle className="text-sm">{t('projects.details')}</CardTitle></CardHeader>
            <CardContent className="text-sm space-y-3">
              <div><span className="text-slate-500">{t('projects.titleArLabel')}</span> <span className="font-medium">{project.title_ar}</span></div>
              <div><span className="text-slate-500">{t('projects.titleEnLabel')}</span> <span className="font-medium">{project.title_en || '\u2014'}</span></div>
              <div><span className="text-slate-500">{t('projects.institutionLabel')}</span> <span className="font-medium">{project.institution_name || '\u2014'}</span></div>
              <div><span className="text-slate-500">{t('projects.startDateLabel')}</span> <span className="font-medium">{project.start_date ? new Date(project.start_date).toLocaleDateString() : '\u2014'}</span></div>
              <div><span className="text-slate-500">{t('projects.expectedEndLabel')}</span> <span className="font-medium">{project.expected_end_date ? new Date(project.expected_end_date).toLocaleDateString() : '\u2014'}</span></div>
              <div className="pt-2 border-t">
                <p className="text-slate-500 mb-1">{t('projects.abstract')}</p>
                <p className="text-slate-600">{project.abstract_ar || project.abstract_en || t('projects.noAbstract')}</p>
              </div>
              {project.objectives && (
                <div className="pt-2 border-t">
                  <p className="text-slate-500 mb-1">{t('projects.objectives')}</p>
                  <p className="text-slate-600 whitespace-pre-wrap">{project.objectives}</p>
                </div>
              )}
            </CardContent>
          </Card>
        </div>

        <div>
          <Card>
            <CardHeader><CardTitle className="text-sm flex items-center gap-2"><BarChart3 className="w-4 h-4" /> {t('projects.applicationStatus')}</CardTitle></CardHeader>
            <CardContent>
              {stats && stats.length > 0 ? (
                <div className="space-y-2">
                  {stats.map((s: any) => (
                    <div key={s.current_status} className="flex items-center justify-between text-sm border-b pb-1 last:border-0">
                      <span><StatusBadge status={s.current_status} /></span>
                      <span className="font-bold text-blue-600">{s.count}</span>
                    </div>
                  ))}
                </div>
              ) : <p className="text-sm text-slate-400">{t('projects.noApplications')}</p>}
            </CardContent>
          </Card>
        </div>
      </div>

      <Card>
        <CardHeader><CardTitle className="text-sm flex items-center gap-2"><FileText className="w-4 h-4" /> {t('projects.relatedApplications')}</CardTitle></CardHeader>
        <CardContent>
          <DataTable
            columns={[
              { key: 'application_number', label: t('projects.number') },
              { key: 'application_type', label: t('projects.type') },
              { key: 'current_status', label: t('projects.status'), render: (i) => <StatusBadge status={i.current_status} /> },
              { key: 'committee_name', label: t('projects.committee') },
              { key: 'created_at', label: t('projects.date'), render: (i) => new Date(i.created_at).toLocaleDateString() },
            ]}
            data={applications || []}
            onRowClick={(item) => navigate(`/applications/${item.id}`)}
          />
        </CardContent>
      </Card>
    </div>
  )
}
