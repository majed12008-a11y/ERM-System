/*
 * صفحة اللجان: قائمة اللجان مع إمكانية إنشاء لجان جديدة،
 * عرض التفاصيل، وإدارة الأعضاء.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useTranslation } from 'react-i18next'
import { useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { Plus, Pencil } from 'lucide-react'
import { usePermission } from '../../hooks/usePermission'
import { z } from 'zod'

const committeeSchema = z.object({
  committee_code: z.string({ message: 'Code is required' }).min(1),
  committee_name_ar: z.string({ message: 'Arabic name is required' }).min(1),
  committee_name_en: z.string().optional().default(''),
  institution_id: z.string({ message: 'Institution is required' }).min(1),
  committee_type_id: z.string({ message: 'Type is required' }).min(1),
  is_active: z.boolean().optional().default(true),
})

type CommitteeFormData = z.input<typeof committeeSchema>

export default function Committees() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const navigate = useNavigate()
  const [showCreate, setShowCreate] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const canCreate = usePermission('user.create')
  const canUpdate = usePermission('user.update')

  const { register, handleSubmit, reset, formState: { errors } } = useForm<CommitteeFormData>({
    resolver: zodResolver(committeeSchema),
    defaultValues: { committee_code: '', committee_name_ar: '', committee_name_en: '', institution_id: '', committee_type_id: '', is_active: true },
  })

  const editForm = useForm<any>({
    defaultValues: { committee_name_ar: '', committee_name_en: '', institution_id: '', committee_type_id: '', is_active: true },
  })

  const { data: committees, isLoading } = useQuery({
    queryKey: ['committees'],
    queryFn: () => api.get('/committee/committees').then(r => r.data.data),
  })

  const { data: institutions } = useQuery({
    queryKey: ['institutions'],
    queryFn: () => api.get('/reference/institutions-registry').then(r => r.data.data || []),
  })

  const { data: committeeTypes } = useQuery({
    queryKey: ['committee-types'],
    queryFn: () => api.get('/committee/committees/committee-types').then(r => r.data.data || []),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/committee/committees', body),
    onSuccess: () => { toast.success(t('committees.created')); queryClient.invalidateQueries({ queryKey: ['committees'] }); setShowCreate(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('committees.createFailed')),
  })

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: number; data: any }) => api.put(`/committee/committees/${id}`, data),
    onSuccess: () => { toast.success(t('committees.updated')); queryClient.invalidateQueries({ queryKey: ['committees'] }); setEditId(null) },
    onError: (err: any) => toast.error(err.response?.data?.error || t('committees.updateFailed')),
  })

  function openEdit(c: any) {
    editForm.reset({
      committee_name_ar: c.committee_name_ar || '',
      committee_name_en: c.committee_name_en || '',
      institution_id: c.institution_id ? String(c.institution_id) : '',
      committee_type_id: c.committee_type_id ? String(c.committee_type_id) : '',
      is_active: c.is_active ?? true,
    })
    setEditId(c.id)
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('committees.title')}</h1>
        {canCreate && (
          <button onClick={() => setShowCreate(!showCreate)}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
            <Plus className="w-4 h-4" /> {t('committees.new')}
          </button>
        )}
      </div>

      {editId && (
        <div className="fixed inset-0 bg-black/80 z-50 flex items-center justify-center" onClick={() => setEditId(null)}>
          <div className="bg-white rounded-lg p-6 max-w-lg w-full mx-4 shadow-xl" onClick={e => e.stopPropagation()}>
            <h2 className="font-semibold mb-4">{t('committees.edit')}</h2>
            <form onSubmit={editForm.handleSubmit((data) => updateMutation.mutate({ id: editId, data }))} className="space-y-3">
              <div className="grid grid-cols-2 gap-3">
                <input placeholder={t('committees.nameAr')} {...editForm.register('committee_name_ar')} className="p-2 border rounded text-sm" />
                <input placeholder={t('committees.nameEn')} {...editForm.register('committee_name_en')} className="p-2 border rounded text-sm" />
              </div>
              <select {...editForm.register('institution_id')} className="w-full p-2 border rounded text-sm">
                <option value="">{t('committees.selectInstitution')}</option>
                {(institutions || []).map((i: any) => <option key={i.id} value={String(i.id)}>{i.name_ar || i.name_en}</option>)}
              </select>
              <div className="grid grid-cols-2 gap-3">
                <select {...editForm.register('committee_type_id')} className="p-2 border rounded text-sm">
                  <option value="">{t('committees.selectType')}</option>
                  {(committeeTypes || []).map((ct: any) => <option key={ct.id} value={String(ct.id)}>{ct.type_name}</option>)}
                </select>
                <label className="flex items-center gap-2 text-sm">
                  <input type="checkbox" {...editForm.register('is_active')} />
                  {t('committees.active')}
                </label>
              </div>
              <div className="flex gap-3">
                <button type="submit" disabled={updateMutation.isPending} className="bg-blue-600 text-white px-4 py-2 rounded text-sm disabled:opacity-50">
                  {updateMutation.isPending ? t('common.saving') : t('common.save')}
                </button>
                <button type="button" onClick={() => setEditId(null)} className="bg-slate-200 text-slate-700 px-4 py-2 rounded text-sm">{t('common.cancel')}</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {showCreate && (
        <div className="bg-white p-6 rounded-lg shadow mb-6 max-w-lg">
          <h2 className="font-semibold mb-4">{t('committees.create')}</h2>
          <form onSubmit={handleSubmit((data) => createMutation.mutate(data))} className="space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <div><input placeholder={t('committees.codePlaceholder')} {...register('committee_code')} className="w-full p-2 border rounded text-sm" />{errors.committee_code && <p className="text-red-500 text-xs">{errors.committee_code.message}</p>}</div>
              <div><input placeholder={t('committees.nameAr')} {...register('committee_name_ar')} className="w-full p-2 border rounded text-sm" />{errors.committee_name_ar && <p className="text-red-500 text-xs">{errors.committee_name_ar.message}</p>}</div>
            </div>
            <input placeholder={t('committees.nameEn')} {...register('committee_name_en')} className="w-full p-2 border rounded text-sm" />
            <div className="grid grid-cols-2 gap-3">
              <select {...register('institution_id')} className="p-2 border rounded text-sm">
                <option value="">{t('committees.selectInstitution')}</option>
                {(institutions || []).map((i: any) => <option key={i.id} value={String(i.id)}>{i.name_ar || i.name_en}</option>)}
              </select>
              <select {...register('committee_type_id')} className="p-2 border rounded text-sm">
                <option value="">{t('committees.selectType')}</option>
                {(committeeTypes || []).map((ct: any) => <option key={ct.id} value={String(ct.id)}>{ct.type_name}</option>)}
              </select>
            </div>
            <div className="flex gap-3">
              <button type="submit" disabled={createMutation.isPending} className="bg-blue-600 text-white px-4 py-2 rounded text-sm disabled:opacity-50">
                {createMutation.isPending ? t('common.creating') : t('common.create')}
              </button>
              <button type="button" onClick={() => setShowCreate(false)} className="bg-slate-200 text-slate-700 px-4 py-2 rounded text-sm">{t('common.cancel')}</button>
            </div>
          </form>
        </div>
      )}

      <DataTable
        searchable
        loading={isLoading}
        onRowClick={(c: any) => navigate(`/committee/committees/${c.id}`)}
        columns={[
          { key: 'committee_code', label: t('committees.code'), sortable: true },
          { key: 'committee_name_ar', label: t('committees.nameAr'), sortable: true },
          { key: 'committee_name_en', label: t('committees.nameEn') },
          { key: 'committee_type_name', label: t('committees.type'), filterable: true },
          { key: 'institution_name', label: t('committees.institution'), sortable: true },
          { key: 'member_count', label: t('committees.members') },
          ...(canUpdate ? [{ key: 'actions' as string, label: '', render: (i: any) => <button onClick={(e) => { e.stopPropagation(); openEdit(i) }} className="text-slate-400 hover:text-blue-600"><Pencil className="w-4 h-4" /></button> }] : []),
        ]}
        data={committees || []}
        emptyMessage={t('committees.empty')}
      />
    </div>
  )
}
