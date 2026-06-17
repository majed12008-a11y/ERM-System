import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { z } from 'zod'
import api from '../../api/client'
import { applicationCreateSchema } from '../../lib/schemas'

type ApplicationFormData = z.input<typeof applicationCreateSchema>

export default function ApplicationCreate() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<ApplicationFormData>({
    resolver: zodResolver(applicationCreateSchema),
    defaultValues: { project_id: '', application_type: 'INITIAL', target_committee_id: '' },
  })

  const { data: projects, isLoading: projectsLoading } = useQuery({
    queryKey: ['projects-dropdown'],
    queryFn: () => api.get('/core/projects').then((r) => r.data.data),
  })

  const { data: committees } = useQuery({
    queryKey: ['committees-dropdown'],
    queryFn: () => api.get('/committee/committees').then((r) => r.data.data),
  })

  const mutation = useMutation({
    mutationFn: (body: any) => api.post('/core/applications', body),
    onSuccess: () => { toast.success(t('applications.created')); queryClient.invalidateQueries({ queryKey: ['applications'] }); navigate('/applications') },
    onError: (err: any) => toast.error(err.response?.data?.error || t('applications.createFailed')),
  })

  function onSubmit(data: ApplicationFormData) {
    mutation.mutate(data)
  }

  const noProjects = !projectsLoading && projects && projects.length === 0

  return (
    <div className="max-w-lg">
      <h1 className="text-2xl font-bold mb-6">{t('applications.new')}</h1>
      <form onSubmit={handleSubmit(onSubmit)} className="bg-white p-6 rounded-lg shadow space-y-4">
        <div>
          <label className="block text-sm font-medium mb-1">{t('applications.project')}</label>
          {noProjects ? (
            <div className="p-3 bg-yellow-50 border border-yellow-200 rounded text-sm text-yellow-800 space-y-2">
              <p>{t('applications.noProjects')}</p>
              <a href="/projects/create" className="text-blue-600 hover:underline font-medium">{t('applications.createProject')}</a>
            </div>
          ) : (
            <select {...register('project_id')} className="w-full p-2 border rounded text-sm" disabled={projectsLoading}>
              <option value="">{t('applications.selectProject')}</option>
              {(projects || []).map((p: any) => (
                <option key={p.id} value={p.id}>{p.title_ar}</option>
              ))}
            </select>
          )}
          {errors.project_id && <p className="text-red-500 text-xs">{errors.project_id.message}</p>}
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">{t('applications.applicationType')}</label>
          <select {...register('application_type')} className="w-full p-2 border rounded text-sm">
            <option value="INITIAL">{t('applications.initialReview')}</option>
            <option value="AMENDMENT">{t('applications.amendment')}</option>
            <option value="RENEWAL">{t('applications.renewal')}</option>
            <option value="EXPEDITED">{t('applications.expedited')}</option>
          </select>
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">{t('applications.targetCommittee')}</label>
          <select {...register('target_committee_id')} className="w-full p-2 border rounded text-sm">
            <option value="">{t('applications.selectCommittee')}</option>
            {(committees || []).map((c: any) => (
              <option key={c.id} value={c.id}>{c.committee_name_ar}</option>
            ))}
          </select>
          {errors.target_committee_id && <p className="text-red-500 text-xs">{errors.target_committee_id.message}</p>}
        </div>
        <div className="flex gap-3">
          <button type="submit" disabled={mutation.isPending || isSubmitting}
            className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm disabled:opacity-50">
            {mutation.isPending ? t('applications.submitting') : t('common.submit')}
          </button>
          <button type="button" onClick={() => navigate('/applications')}
            className="bg-slate-200 text-slate-700 px-4 py-2 rounded hover:bg-slate-300 text-sm">
            {t('common.cancel')}
          </button>
        </div>
      </form>
    </div>
  )
}
