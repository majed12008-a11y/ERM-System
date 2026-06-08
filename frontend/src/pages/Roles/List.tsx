import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../../api/client'
import { Shield, Plus, Pencil } from 'lucide-react'
import { usePermission } from '../../hooks/usePermission'
import { z } from 'zod'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from '../../components/ui/dialog'
import { Button } from '../../components/ui/button'

const roleCreateSchema = z.object({
  code: z.string({ message: 'Code is required' }).min(1).max(50),
  name_ar: z.string({ message: 'Arabic name is required' }).min(1).max(200),
  name_en: z.string().max(200).optional().default(''),
  description: z.string().max(500).optional().default(''),
})

type RoleCreateFormData = z.input<typeof roleCreateSchema>

interface Permission {
  id: number
  permission_code: string
  module_name: string
  action_name: string
  description: string
  granted?: boolean
}

interface Role {
  id: number
  code: string
  name_ar: string
  name_en: string
  description?: string
  is_active: boolean
  is_system_role: boolean
}

export default function RoleList() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [selectedRole, setSelectedRole] = useState<Role | null>(null)
  const [permissions, setPermissions] = useState<Permission[]>([])
  const [error, setError] = useState('')
  const [saving, setSaving] = useState(false)
  const [showCreate, setShowCreate] = useState(false)
  const [editId, setEditId] = useState<number | null>(null)
  const canCreate = usePermission('role.create')
  const canUpdate = usePermission('role.update')

  const { register, handleSubmit, reset, formState: { errors } } = useForm<RoleCreateFormData>({
    resolver: zodResolver(roleCreateSchema),
    defaultValues: { code: '', name_ar: '', name_en: '', description: '' },
  })

  const editForm = useForm<any>({
    defaultValues: { name_ar: '', name_en: '', description: '', is_active: true },
  })

  const { data: roles, isLoading: rolesLoading } = useQuery({
    queryKey: ['roles'],
    queryFn: () => api.get('/security/roles').then((r) => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/security/roles', body),
    onSuccess: () => { toast.success(t('roles.created')); queryClient.invalidateQueries({ queryKey: ['roles'] }); setShowCreate(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('roles.createFailed')),
  })

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: number; data: any }) => api.put(`/security/roles/${id}`, data),
    onSuccess: () => { toast.success(t('roles.updated')); queryClient.invalidateQueries({ queryKey: ['roles'] }); setEditId(null) },
    onError: (err: any) => toast.error(err.response?.data?.error || t('roles.updateFailed')),
  })

  function openPermissions(role: Role) {
    setEditId(null)
    setSelectedRole(role)
    setError('')
    api.get(`/security/permissions/role/${role.id}`).then((r) => {
      setPermissions(r.data.data)
    }).catch((err) => {
      setError(err.response?.data?.error || t('roles.loadPermsFailed'))
    })
  }

  function togglePermission(permId: number) {
    setPermissions((prev) =>
      prev.map((p) => (p.id === permId ? { ...p, granted: !p.granted } : p))
    )
  }

  function savePermissions() {
    if (!selectedRole) return
    setSaving(true)
    setError('')
    const permission_ids = permissions.filter((p) => p.granted).map((p) => p.id)
    api.put(`/security/permissions/role/${selectedRole.id}`, { permission_ids })
      .then(() => {
        queryClient.invalidateQueries({ queryKey: ['roles'] })
        setSelectedRole(null)
        setPermissions([])
      })
      .catch((err) => {
        setError(err.response?.data?.error || t('roles.savePermsFailed'))
      })
      .finally(() => setSaving(false))
  }

  function openEdit(role: Role) {
    setSelectedRole(null)
    setPermissions([])
    editForm.reset({
      name_ar: role.name_ar || '',
      name_en: role.name_en || '',
      description: role.description || '',
      is_active: role.is_active ?? true,
    })
    setEditId(role.id)
  }

  const modules = permissions.reduce<Record<string, Permission[]>>((acc, p) => {
    const m = p.module_name || 'other'
    if (!acc[m]) acc[m] = []
    acc[m].push(p)
    return acc
  }, {})

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('roles.title')}</h1>
        {canCreate && (
          <button onClick={() => setShowCreate(!showCreate)}
            className="flex items-center gap-2 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 text-sm">
            <Plus className="w-4 h-4" /> {t('roles.new')}
          </button>
        )}
      </div>

      {editId && (
        <div className="fixed inset-0 bg-black/80 z-50 flex items-center justify-center" onClick={() => setEditId(null)}>
          <div className="bg-white rounded-lg p-6 max-w-lg w-full mx-4 shadow-xl" onClick={e => e.stopPropagation()}>
            <h2 className="font-semibold mb-4">{t('roles.edit')}</h2>
            <form onSubmit={editForm.handleSubmit((data) => updateMutation.mutate({ id: editId, data }))} className="space-y-3">
              <div className="grid grid-cols-2 gap-3">
                <input placeholder={t('roles.nameAr')} {...editForm.register('name_ar')} className="p-2 border rounded text-sm" />
                <input placeholder={t('roles.nameEn')} {...editForm.register('name_en')} className="p-2 border rounded text-sm" />
              </div>
              <input placeholder={t('roles.description')} {...editForm.register('description')} className="w-full p-2 border rounded text-sm" />
              <label className="flex items-center gap-2 text-sm">
                <input type="checkbox" {...editForm.register('is_active')} />
                {t('roles.active')}
              </label>
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
          <h2 className="font-semibold mb-4">{t('roles.create')}</h2>
          <form onSubmit={handleSubmit((data) => createMutation.mutate(data))} className="space-y-3">
            <div className="grid grid-cols-2 gap-3">
              <div><input placeholder={t('roles.code')} {...register('code')} className="w-full p-2 border rounded text-sm" />{errors.code && <p className="text-red-500 text-xs">{errors.code.message}</p>}</div>
              <div><input placeholder={t('roles.nameAr')} {...register('name_ar')} className="w-full p-2 border rounded text-sm" />{errors.name_ar && <p className="text-red-500 text-xs">{errors.name_ar.message}</p>}</div>
            </div>
            <input placeholder={t('roles.nameEn')} {...register('name_en')} className="w-full p-2 border rounded text-sm" />
            <input placeholder={t('roles.description')} {...register('description')} className="w-full p-2 border rounded text-sm" />
            <div className="flex gap-3">
              <button type="submit" disabled={createMutation.isPending} className="bg-blue-600 text-white px-4 py-2 rounded text-sm disabled:opacity-50">
                {createMutation.isPending ? t('common.creating') : t('common.create')}
              </button>
              <button type="button" onClick={() => setShowCreate(false)} className="bg-slate-200 text-slate-700 px-4 py-2 rounded text-sm">{t('common.cancel')}</button>
            </div>
          </form>
        </div>
      )}

      {rolesLoading ? (
        <p className="text-slate-400">{t('common.loading')}</p>
      ) : (
        <div className="rounded-lg border overflow-hidden">
          <table className="w-full text-sm">
            <thead className="bg-slate-50">
              <tr>
                <th className="text-start px-4 py-3 font-medium">{t('roles.code')}</th>
                <th className="text-start px-4 py-3 font-medium">{t('roles.nameAr')}</th>
                <th className="text-start px-4 py-3 font-medium">{t('roles.active')}</th>
                <th className="text-start px-4 py-3 font-medium">{t('roles.permissions')}</th>
                {canUpdate && <th className="px-4 py-3 font-medium"></th>}
              </tr>
            </thead>
            <tbody>
              {(roles || []).map((role: Role) => (
                <tr key={role.id} className="border-t hover:bg-slate-50">
                  <td className="px-4 py-3 font-mono text-xs">{role.code}</td>
                  <td className="px-4 py-3">{role.name_ar}</td>
                  <td className="px-4 py-3">{role.is_active ? <span className="text-green-600">{'\u2713'}</span> : '\u2014'}</td>
                  <td className="px-4 py-3">
                    <Button variant="outline" size="sm" onClick={() => openPermissions(role)}>
                      <Shield className="w-3 h-3 me-1" /> {t('roles.manage')}
                    </Button>
                  </td>
                  {canUpdate && (
                    <td className="px-4 py-3">
                      <button onClick={() => openEdit(role)} className="text-slate-400 hover:text-blue-600"><Pencil className="w-4 h-4" /></button>
                    </td>
                  )}
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      <Dialog open={!!selectedRole} onOpenChange={(o) => { if (!o) { setSelectedRole(null); setPermissions([]) } }}>
        <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{t('roles.permissionsTitle', { name: selectedRole?.name_ar || selectedRole?.code })}</DialogTitle>
          </DialogHeader>

          {error && <p className="text-red-500 text-sm mb-2">{error}</p>}

          {permissions.length === 0 && !error ? (
            <p className="text-slate-400 text-sm py-4">{t('roles.loadingPerms')}</p>
          ) : (
            <div className="space-y-4">
              {Object.entries(modules).map(([module, perms]) => (
                <div key={module}>
                  <h3 className="font-semibold text-sm capitalize mb-2 text-slate-700 border-b pb-1">
                    {module}
                  </h3>
                  <div className="grid grid-cols-1 gap-1.5">
                    {perms.map((perm) => (
                      <label key={perm.id} className="flex items-center gap-2 text-sm px-2 py-1 rounded hover:bg-slate-50 cursor-pointer">
                        <input type="checkbox" checked={perm.granted || false} onChange={() => togglePermission(perm.id)} className="rounded border-slate-300" />
                        <span className="font-mono text-xs text-slate-500 min-w-[140px]">{perm.permission_code}</span>
                        <span className="text-slate-700">{perm.description}</span>
                      </label>
                    ))}
                  </div>
                </div>
              ))}
            </div>
          )}

          <DialogFooter>
            <Button variant="outline" onClick={() => { setSelectedRole(null); setPermissions([]) }}>{t('common.cancel')}</Button>
            <Button onClick={savePermissions} disabled={saving || permissions.length === 0}>
              {saving ? t('common.saving') : t('common.save')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
