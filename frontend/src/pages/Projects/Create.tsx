import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate } from 'react-router-dom'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../../api/client'
import { projectCreateSchema } from '../../lib/schemas'

type ProjectFormData = {
  title_ar: string; title_en?: string; abstract_ar?: string; abstract_en?: string
  objectives: string; research_category?: string; risk_level?: string
  start_date?: string; expected_end_date?: string
}

export default function ProjectCreate() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<ProjectFormData>({
    resolver: zodResolver(projectCreateSchema),
    defaultValues: { title_ar: '', title_en: '', abstract_ar: '', abstract_en: '', objectives: '', research_category: '', risk_level: '', start_date: '', expected_end_date: '' },
  })

  const mutation = useMutation({
    mutationFn: (body: any) => api.post('/core/projects', body),
    onSuccess: () => { toast.success(t('projects.created')); queryClient.invalidateQueries({ queryKey: ['projects'] }); navigate('/projects') },
    onError: (err: any) => toast.error(err.response?.data?.error || t('projects.createFailed')),
  })

  function onSubmit(data: ProjectFormData) {
    mutation.mutate(data)
  }

  return (
    <div className="max-w-2xl">
      <h1 className="text-2xl font-bold mb-6">{t('projects.new')}</h1>
      <form onSubmit={handleSubmit(onSubmit)} className="bg-white p-6 rounded-lg shadow space-y-4">
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">{t('projects.titleAr')}</label>
            <input {...register('title_ar')} className="w-full p-2 border rounded text-sm" />
            {errors.title_ar && <p className="text-red-500 text-xs">{errors.title_ar.message}</p>}
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">{t('projects.titleEn')}</label>
            <input {...register('title_en')} className="w-full p-2 border rounded text-sm" />
          </div>
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">{t('projects.abstractAr')}</label>
          <textarea {...register('abstract_ar')} className="w-full p-2 border rounded text-sm" rows={3} />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">{t('projects.abstractEn')}</label>
          <textarea {...register('abstract_en')} className="w-full p-2 border rounded text-sm" rows={3} />
        </div>
        <div>
          <label className="block text-sm font-medium mb-1">{t('projects.objectives')}</label>
          <textarea {...register('objectives')} className="w-full p-2 border rounded text-sm" rows={3} />
          {errors.objectives && <p className="text-red-500 text-xs">{errors.objectives.message}</p>}
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">{t('projects.startDate')}</label>
            <input type="date" {...register('start_date')} className="w-full p-2 border rounded text-sm" />
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">{t('projects.expectedEndDate')}</label>
            <input type="date" {...register('expected_end_date')} className="w-full p-2 border rounded text-sm" />
          </div>
        </div>
        <div className="grid grid-cols-2 gap-4">
          <div>
            <label className="block text-sm font-medium mb-1">{t('projects.researchCategory')}</label>
            <select {...register('research_category')} className="w-full p-2 border rounded text-sm">
              <option value="">{t('projects.select')}</option>
              <option value="BIOMEDICAL">{t('projects.biomedical')}</option>
              <option value="SOCIAL">{t('projects.social')}</option>
              <option value="BEHAVIORAL">{t('projects.behavioral')}</option>
              <option value="EPIDEMIOLOGICAL">{t('projects.epidemiological')}</option>
              <option value="GENETIC">{t('projects.genetic')}</option>
            </select>
          </div>
          <div>
            <label className="block text-sm font-medium mb-1">{t('projects.riskLevel')}</label>
            <select {...register('risk_level')} className="w-full p-2 border rounded text-sm">
              <option value="">{t('projects.select')}</option>
              <option value="MINIMAL">{t('projects.minimal')}</option>
              <option value="LOW">{t('projects.low')}</option>
              <option value="MODERATE">{t('projects.moderate')}</option>
              <option value="HIGH">{t('projects.high')}</option>
            </select>
          </div>
        </div>
        <div className="flex gap-3">
          <button type="submit" disabled={mutation.isPending || isSubmitting}
            className="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm disabled:opacity-50">
            {mutation.isPending ? t('projects.creating') : t('common.create')}
          </button>
          <button type="button" onClick={() => navigate('/projects')}
            className="bg-slate-200 text-slate-700 px-4 py-2 rounded hover:bg-slate-300 text-sm">{t('common.cancel')}</button>
        </div>
      </form>
    </div>
  )
}
