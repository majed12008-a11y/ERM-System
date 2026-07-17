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
import { committees } from '../../sdk/domains/committee.sdk'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { Button } from '../../components/ui/button'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '../../components/ui/dialog'
import { Plus, Pencil, Trash2 } from 'lucide-react'
import { usePermission } from '../../hooks/usePermission'
import { z } from 'zod'
import { AxiosError } from 'axios'

const committeeSchema = z.object({
  committee_code: z.string().min(1, { message: 'Code is required' }),
  committee_name_ar: z.string().min(1, { message: 'Arabic name is required' }),
  committee_name_en: z.string().optional().default(''),
  institution_id: z.string().min(1, { message: 'Institution is required' }),
  committee_type_id: z.string().min(1, { message: 'Type is required' }),
  is_active: z.boolean().optional().default(true),
})

type CommitteeFormData = z.input<typeof committeeSchema>

export default function Committees() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const navigate = useNavigate()
  const [showCreate, setShowCreate] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const [deactivateId, setDeactivateId] = useState<number | null>(null)
  const canCreate = usePermission('user.create')
  const canUpdate = usePermission('user.update')

  const { register, handleSubmit, reset, formState: { errors } } = useForm<CommitteeFormData>({
    resolver: zodResolver(committeeSchema),
    defaultValues: { committee_code: '', committee_name_ar: '', committee_name_en: '', institution_id: '', committee_type_id: '', is_active: true },
  })

  const editForm = useForm<CommitteeFormData>({
    resolver: zodResolver(committeeSchema),
    defaultValues: { committee_code: '', committee_name_ar: '', committee_name_en: '', institution_id: '', committee_type_id: '', is_active: true },
  })

  const { data, isLoading } = useQuery({
    queryKey: ['committees'],
    queryFn: () => committees.list().then((r) => r.data.data),
  })

  const { data: institutions } = useQuery({
    queryKey: ['institutions'],
    queryFn: () => api.get('/reference/institutions-registry').then((r) => r.data.data || []),
  })

  const { data: committeeTypes } = useQuery({
    queryKey: ['committee-types'],
    queryFn: () => committees.listTypes().then((r) => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: CommitteeFormData) => committees.create({
      committee_code: body.committee_code,
      committee_name_ar: body.committee_name_ar,
      committee_name_en: body.committee_name_en || undefined,
      institution_id: Number(body.institution_id),
      committee_type_id: Number(body.committee_type_id),
      is_active: body.is_active,
    }),
    onSuccess: () => {
      toast.success(t('committees.created'))
      queryClient.invalidateQueries({ queryKey: ['committees'] })
      setShowCreate(false)
      reset()
    },
    onError: (err: AxiosError<{ error?: string }>) => {
      toast.error(err.response?.data?.error || t('committees.createFailed'))
    },
  })

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: number; data: CommitteeFormData }) => committees.update(id, {
      committee_name_ar: data.committee_name_ar,
      committee_name_en: data.committee_name_en || undefined,
      institution_id: Number(data.institution_id),
      committee_type_id: Number(data.committee_type_id),
      is_active: data.is_active,
    }),
    onSuccess: () => {
      toast.success(t('committees.updated'))
      queryClient.invalidateQueries({ queryKey: ['committees'] })
      setEditId(null)
    },
    onError: (err: AxiosError<{ error?: string }>) => {
      toast.error(err.response?.data?.error || t('committees.updateFailed'))
    },
  })

  const deactivateMutation = useMutation({
    mutationFn: (id: number) => committees.deactivate(id),
    onSuccess: () => {
      toast.success(t('committees.deleted'))
      queryClient.invalidateQueries({ queryKey: ['committees'] })
      setDeactivateId(null)
    },
    onError: (err: AxiosError<{ error?: string }>) => {
      toast.error(err.response?.data?.error || t('committees.deleteFailed'))
    },
  })

  function openEdit(c: any) {
    editForm.reset({
      committee_code: c.committee_code || '',
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
          <button onClick={() => setShowCreate(true)}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
            <Plus className="w-4 h-4" /> {t('committees.new')}
          </button>
        )}
      </div>

      <Dialog open={showCreate} onOpenChange={setShowCreate}>
        <DialogContent>
          <DialogHeader><DialogTitle>{t('committees.create')}</DialogTitle></DialogHeader>
          <form onSubmit={handleSubmit((data) => createMutation.mutate(data))} className="space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <div>
                <input placeholder={t('committees.codePlaceholder')} {...register('committee_code')} className="w-full p-2 border rounded text-sm" />
                {errors.committee_code && <p className="text-red-500 text-xs">{errors.committee_code.message}</p>}
              </div>
              <div>
                <input placeholder={t('committees.nameAr')} {...register('committee_name_ar')} className="w-full p-2 border rounded text-sm" />
                {errors.committee_name_ar && <p className="text-red-500 text-xs">{errors.committee_name_ar.message}</p>}
              </div>
            </div>
            <input placeholder={t('committees.nameEn')} {...register('committee_name_en')} className="w-full p-2 border rounded text-sm" />
            <div className="grid grid-cols-2 gap-3">
              <div>
                <select {...register('institution_id')} className="w-full p-2 border rounded text-sm">
                  <option value="">{t('committees.selectInstitution')}</option>
                  {(institutions || []).map((i: any) => <option key={i.id} value={String(i.id)}>{i.name_ar || i.name_en}</option>)}
                </select>
                {errors.institution_id && <p className="text-red-500 text-xs">{errors.institution_id.message}</p>}
              </div>
              <div>
                <select {...register('committee_type_id')} className="w-full p-2 border rounded text-sm">
                  <option value="">{t('committees.selectType')}</option>
                  {(committeeTypes || []).map((ct: any) => <option key={ct.id} value={String(ct.id)}>{ct.name_ar}</option>)}
                </select>
                {errors.committee_type_id && <p className="text-red-500 text-xs">{errors.committee_type_id.message}</p>}
              </div>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setShowCreate(false)}>{t('common.cancel')}</Button>
              <Button type="submit" disabled={createMutation.isPending}>
                {createMutation.isPending ? t('common.creating') : t('common.create')}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      <Dialog open={editId !== null} onOpenChange={() => setEditId(null)}>
        <DialogContent>
          <DialogHeader><DialogTitle>{t('committees.edit')}</DialogTitle></DialogHeader>
          <form onSubmit={editForm.handleSubmit((data) => editId && updateMutation.mutate({ id: editId, data }))} className="space-y-3">
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
                {(committeeTypes || []).map((ct: any) => <option key={ct.id} value={String(ct.id)}>{ct.name_ar}</option>)}
              </select>
              <label className="flex items-center gap-2 text-sm">
                <input type="checkbox" {...editForm.register('is_active')} />
                {t('committees.active')}
              </label>
            </div>
            <DialogFooter>
              <Button type="button" variant="outline" onClick={() => setEditId(null)}>{t('common.cancel')}</Button>
              <Button type="submit" disabled={updateMutation.isPending}>
                {updateMutation.isPending ? t('common.saving') : t('common.save')}
              </Button>
            </DialogFooter>
          </form>
        </DialogContent>
      </Dialog>

      <Dialog open={deactivateId !== null} onOpenChange={() => setDeactivateId(null)}>
        <DialogContent>
          <DialogHeader><DialogTitle>{t('committees.delete')}</DialogTitle></DialogHeader>
          <p className="text-sm text-slate-600">{t('committees.deleteConfirm')}</p>
          <DialogFooter>
            <Button variant="outline" onClick={() => setDeactivateId(null)}>{t('common.cancel')}</Button>
            <Button variant="destructive" onClick={() => deactivateId && deactivateMutation.mutate(deactivateId)} disabled={deactivateMutation.isPending}>
              {deactivateMutation.isPending ? t('common.deleting') : t('common.delete')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

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
          { key: 'is_active', label: t('common.status'), render: (i: any) => <StatusBadge status={i.is_active ? 'ACTIVE' : 'INACTIVE'} /> },
          ...(canUpdate ? [{ key: 'actions' as string, label: '', render: (i: any) => (
            <div className="flex items-center gap-1" onClick={(e) => e.stopPropagation()}>
              <button onClick={() => openEdit(i)} className="p-1 text-slate-400 hover:text-blue-600 hover:bg-blue-50 rounded" title={t('common.edit')}>
                <Pencil className="w-4 h-4" />
              </button>
              <button onClick={() => setDeactivateId(i.id)} className="p-1 text-slate-400 hover:text-red-600 hover:bg-red-50 rounded" title={t('common.delete')}>
                <Trash2 className="w-4 h-4" />
              </button>
            </div>
          ) }] : []),
        ]}
        data={data || []}
        emptyMessage={t('committees.empty')}
      />
    </div>
  )
}
