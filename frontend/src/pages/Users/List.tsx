import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState, useEffect } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { Plus, Pencil } from 'lucide-react'
import { usePermission } from '../../hooks/usePermission'
import { createUserSchema } from '../../lib/schemas'
import { z } from 'zod'

type UserFormData = z.input<typeof createUserSchema>

export default function UserList() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [showCreate, setShowCreate] = useState(false)
  const [editUserId, setEditUserId] = useState<number | null>(null)
  const canCreate = usePermission('user.create')
  const canUpdate = usePermission('user.update')

  const { register, handleSubmit, setValue, watch, reset, formState: { errors, isSubmitting } } = useForm<UserFormData>({
    resolver: zodResolver(createUserSchema),
    defaultValues: { username: '', email: '', password: '', role_codes: [], first_name_ar: '', last_name_ar: '', first_name_en: '', last_name_en: '', mobile: '', institution_id: '', department_id: '' },
  })
  const roleCodes = watch('role_codes')

  const editForm = useForm<any>({
    defaultValues: { email: '', first_name_ar: '', last_name_ar: '', first_name_en: '', last_name_en: '', mobile: '', institution_id: '', department_id: '', status: 'ACTIVE', role_codes: [] },
  })
  const editRoleCodes = editForm.watch('role_codes')

  const { data, isLoading } = useQuery({
    queryKey: ['users'],
    queryFn: () => api.get('/security/users').then((r) => r.data.data),
  })

  const { data: editUser } = useQuery({
    queryKey: ['user', editUserId],
    queryFn: () => api.get(`/security/users/${editUserId}`).then((r) => r.data.data),
    enabled: !!editUserId,
  })

  useEffect(() => {
    if (editUser) {
      editForm.reset({
        email: editUser.email || '',
        first_name_ar: editUser.first_name_ar || '',
        last_name_ar: editUser.last_name_ar || '',
        first_name_en: editUser.first_name_en || '',
        last_name_en: editUser.last_name_en || '',
        mobile: editUser.mobile || '',
        institution_id: editUser.institution_id ? String(editUser.institution_id) : '',
        department_id: editUser.department_id ? String(editUser.department_id) : '',
        status: editUser.status || 'ACTIVE',
        role_codes: (editUser.roles || []).map((r: any) => r.code),
      })
    }
  }, [editUser, editForm])

  const { data: roles } = useQuery({
    queryKey: ['roles'],
    queryFn: () => api.get('/security/roles').then((r) => r.data.data || []),
  })

  const { data: institutions } = useQuery({
    queryKey: ['institutions'],
    queryFn: () => api.get('/reference/institutions-registry').then((r) => r.data.data || []),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/security/users', body),
    onSuccess: () => { toast.success(t('users.created')); queryClient.invalidateQueries({ queryKey: ['users'] }); setShowCreate(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('users.createFailed')),
  })

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: number; data: any }) => api.put(`/security/users/${id}`, data),
    onSuccess: () => { toast.success(t('users.updated')); queryClient.invalidateQueries({ queryKey: ['users'] }); setEditUserId(null) },
    onError: (err: any) => toast.error(err.response?.data?.error || t('users.updateFailed')),
  })

  function toggleRole(code: string) {
    const current = roleCodes || []
    if (current.includes(code)) setValue('role_codes', current.filter(c => c !== code), { shouldDirty: true })
    else setValue('role_codes', [...current, code], { shouldDirty: true })
  }

  function toggleEditRole(code: string) {
    const current = editRoleCodes || []
    if (current.includes(code)) editForm.setValue('role_codes', current.filter((c: string) => c !== code), { shouldDirty: true })
    else editForm.setValue('role_codes', [...current, code], { shouldDirty: true })
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('users.title')}</h1>
        {canCreate && (
          <button onClick={() => setShowCreate(!showCreate)}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
            <Plus className="w-4 h-4" /> {t('users.new')}
          </button>
        )}
      </div>

      {editUserId && editUser && (
        <div className="fixed inset-0 bg-black/80 z-50 flex items-center justify-center" onClick={() => setEditUserId(null)}>
          <div className="bg-white rounded-lg p-6 max-w-lg w-full mx-4 shadow-xl" onClick={e => e.stopPropagation()}>
            <h2 className="font-semibold mb-4">{t('users.edit', { username: editUser.username })}</h2>
            <form onSubmit={editForm.handleSubmit((data) => updateMutation.mutate({ id: editUserId, data }))} className="space-y-3">
              <div className="grid grid-cols-2 gap-3">
                <input placeholder={t('users.email')} {...editForm.register('email')} className="p-2 border rounded text-sm" />
                <select {...editForm.register('status')} className="p-2 border rounded text-sm">
                  <option value="ACTIVE">{t('common.active')}</option>
                  <option value="INACTIVE">{t('common.inactive')}</option>
                  <option value="SUSPENDED">{t('common.suspended')}</option>
                </select>
              </div>
              <div className="grid grid-cols-2 gap-3">
                <input placeholder={t('users.firstNameAr')} {...editForm.register('first_name_ar')} className="p-2 border rounded text-sm" />
                <input placeholder={t('users.lastNameAr')} {...editForm.register('last_name_ar')} className="p-2 border rounded text-sm" />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <input placeholder={t('users.firstNameEn')} {...editForm.register('first_name_en')} className="p-2 border rounded text-sm" />
                <input placeholder={t('users.lastNameEn')} {...editForm.register('last_name_en')} className="p-2 border rounded text-sm" />
              </div>
              <div className="grid grid-cols-2 gap-3">
                <input placeholder={t('users.mobile')} type="tel" {...editForm.register('mobile')} className="p-2 border rounded text-sm" />
                <select {...editForm.register('institution_id')} className="p-2 border rounded text-sm">
                  <option value="">{t('users.selectInstitution')}</option>
                  {(institutions || []).map((i: any) => <option key={i.id} value={String(i.id)}>{i.name_ar || i.name_en}</option>)}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('users.rolesLabel')}</label>
                <div className="flex flex-wrap gap-2">
                  {(roles || []).filter((r: any) => r.is_active).map((r: any) => (
                    <label key={r.code} className="flex items-center gap-1 text-sm">
                      <input type="checkbox" checked={(editRoleCodes || []).includes(r.code)} onChange={() => toggleEditRole(r.code)} />
                      {r.name_ar || r.code}
                    </label>
                  ))}
                </div>
              </div>
              <div className="flex gap-3">
                <button type="submit" disabled={updateMutation.isPending}
                  className="bg-blue-600 text-white px-4 py-2 rounded text-sm disabled:opacity-50">
                  {updateMutation.isPending ? t('common.saving') : t('common.save')}
                </button>
                <button type="button" onClick={() => setEditUserId(null)}
                  className="bg-slate-200 text-slate-700 px-4 py-2 rounded text-sm">{t('common.cancel')}</button>
              </div>
            </form>
          </div>
        </div>
      )}

      {showCreate && (
        <div className="bg-white p-6 rounded-lg shadow mb-6 max-w-lg">
          <h2 className="font-semibold mb-4">{t('users.create')}</h2>
          <form onSubmit={handleSubmit((data) => createMutation.mutate(data))} className="space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <div><input placeholder={t('users.username')} {...register('username')} className="w-full p-2 border rounded text-sm" />{errors.username && <p className="text-red-500 text-xs">{errors.username.message}</p>}</div>
              <div><input placeholder={t('users.email')} type="email" {...register('email')} className="w-full p-2 border rounded text-sm" />{errors.email && <p className="text-red-500 text-xs">{errors.email.message}</p>}</div>
            </div>
            <div className="grid grid-cols-2 gap-3">
              <input placeholder={t('users.firstNameAr')} {...register('first_name_ar')} className="p-2 border rounded text-sm" />
              <input placeholder={t('users.lastNameAr')} {...register('last_name_ar')} className="p-2 border rounded text-sm" />
            </div>
            <div className="grid grid-cols-2 gap-3">
              <input placeholder={t('users.firstNameEn')} {...register('first_name_en')} className="p-2 border rounded text-sm" />
              <input placeholder={t('users.lastNameEn')} {...register('last_name_en')} className="p-2 border rounded text-sm" />
            </div>
            <div className="grid grid-cols-2 gap-3">
              <input placeholder={t('users.mobile')} type="tel" {...register('mobile')} className="p-2 border rounded text-sm" />
              <select {...register('institution_id')} className="p-2 border rounded text-sm">
                <option value="">{t('users.selectInstitution')}</option>
                {(institutions || []).map((i: any) => <option key={i.id} value={String(i.id)}>{i.name_ar || i.name_en}</option>)}
              </select>
            </div>
            <div><input placeholder={t('users.password')} type="password" {...register('password')} className="w-full p-2 border rounded text-sm" />{errors.password && <p className="text-red-500 text-xs">{errors.password.message}</p>}</div>
            <div>
              <label className="block text-sm font-medium mb-1">{t('users.rolesLabel')}</label>
              <div className="flex flex-wrap gap-2">
                {(roles || []).filter((r: any) => r.is_active).map((r: any) => (
                  <label key={r.code} className="flex items-center gap-1 text-sm">
                    <input type="checkbox" checked={(roleCodes || []).includes(r.code)} onChange={() => toggleRole(r.code)} />
                    {r.name_ar || r.code}
                  </label>
                ))}
              </div>
            </div>
            <div className="flex gap-3">
              <button type="submit" disabled={createMutation.isPending || isSubmitting}
                className="bg-blue-600 text-white px-4 py-2 rounded text-sm disabled:opacity-50">
                {createMutation.isPending ? t('common.creating') : t('common.create')}
              </button>
              <button type="button" onClick={() => setShowCreate(false)}
                className="bg-slate-200 text-slate-700 px-4 py-2 rounded text-sm">{t('common.cancel')}</button>
            </div>
          </form>
        </div>
      )}

        <DataTable
          searchable
          loading={isLoading}
          columns={[
            { key: 'username', label: t('users.username'), sortable: true },
            { key: 'email', label: t('users.email'), sortable: true },
            { key: 'status', label: t('users.status'), filterable: true, sortable: true, render: (i) => <span className={`text-xs px-2 py-1 rounded ${i.status === 'ACTIVE' ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-700'}`}>{i.status}</span> },
            { key: 'roles', label: t('users.roles'), render: (i) => (i.roles || []).join(', ') },
            { key: 'institution_name', label: t('users.institution'), sortable: true },
            { key: 'last_login_at', label: t('users.lastLogin'), sortable: true, render: (i) => i.last_login_at ? new Date(i.last_login_at).toLocaleDateString() : '\u2014' },
            ...(canUpdate ? [{ key: 'actions' as string, label: '', render: (i: any) => <button onClick={() => setEditUserId(i.id)} className="text-slate-400 hover:text-blue-600"><Pencil className="w-4 h-4" /></button> }] : []),
          ]}
          data={data || []}
          emptyMessage={t('users.empty')}
        />
    </div>
  )
}
