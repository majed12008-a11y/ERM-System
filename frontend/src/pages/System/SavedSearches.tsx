/*
 * صفحة عمليات البحث المحفوظة: عرض وتشغيل وإدارة
 * عمليات البحث المخزنة للمستخدم.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import ConfirmDialog from '../../components/ConfirmDialog'
import { Button } from '../../components/ui/button'
import { Card, CardContent } from '../../components/ui/card'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter,
} from '../../components/ui/dialog'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../../components/ui/select'
import { savedSearchSchema } from '../../lib/schemas'
import { Trash2 } from 'lucide-react'
import { useTranslation } from 'react-i18next'

type SearchFormData = { name: string; search_type: string; criteria?: string; is_shared?: boolean }

export default function SavedSearches() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [open, setOpen] = useState(false)
  const { register, handleSubmit, setValue, watch, reset, formState: { errors } } = useForm<SearchFormData>({
    resolver: zodResolver(savedSearchSchema),
    defaultValues: { name: '', search_type: 'applications', criteria: '{}', is_shared: false },
  })
  const entityType = watch('search_type')
  const isShared = watch('is_shared')

  const { data: searches, isLoading } = useQuery({
    queryKey: ['saved-searches'],
    queryFn: () => api.get('/system/saved-searches').then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/system/saved-searches', body),
    onSuccess: () => { toast.success(t('savedSearches.saved')); queryClient.invalidateQueries({ queryKey: ['saved-searches'] }); setOpen(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('savedSearches.saveFailed')),
  })

  const [deleteTarget, setDeleteTarget] = useState<number | null>(null)
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/system/saved-searches/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['saved-searches'] }); setDeleteTarget(null) },
  })

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('savedSearches.title')}</h1>
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild><Button>{t('savedSearches.new')}</Button></DialogTrigger>
          <DialogContent>
            <form onSubmit={handleSubmit((data) => createMutation.mutate(data))}>
            <DialogHeader><DialogTitle>{t('savedSearches.save')}</DialogTitle></DialogHeader>
            <div className="space-y-4">
              <div><Label>{t('savedSearches.name')}</Label><Input {...register('name')} />{errors.name && <p className="text-red-500 text-xs">{errors.name.message}</p>}</div>
              <div><Label>{t('savedSearches.entityType')}</Label>
                <Select value={entityType} onValueChange={v => setValue('search_type', v, { shouldDirty: true })}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    <SelectItem value="applications">{t('savedSearches.applications')}</SelectItem>
                    <SelectItem value="projects">{t('savedSearches.projects')}</SelectItem>
                    <SelectItem value="users">{t('savedSearches.users')}</SelectItem>
                  </SelectContent>
                </Select>
              </div>
              <div><Label>{t('savedSearches.criteria')}</Label><Input {...register('criteria')} /></div>
              <label className="flex items-center gap-2">
                <input type="checkbox" checked={!!isShared} onChange={e => setValue('is_shared', e.target.checked, { shouldDirty: true })} />
                <span className="text-sm">{t('savedSearches.share')}</span>
              </label>
            </div>
            <DialogFooter>
              <Button variant="outline" type="button" onClick={() => setOpen(false)}>{t('common.cancel')}</Button>
              <Button type="submit" disabled={createMutation.isPending}>{t('common.save')}</Button>
            </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      <Card>
        <CardContent className="p-0">
          {isLoading ? (
            <div className="p-8 text-center text-muted-foreground">{t('common.loading')}</div>
          ) : (
            <DataTable
              columns={[
                { key: 'name', label: t('savedSearches.name') },
                { key: 'search_type', label: t('savedSearches.type') },
                { key: 'is_shared', label: t('savedSearches.shared'), render: (s: any) => s.is_shared ? t('common.yes') : t('common.no') },
                { key: 'created_at', label: t('savedSearches.created'), render: (s: any) => s.created_at ? new Date(s.created_at).toLocaleDateString() : '-' },
                { key: 'actions', label: '', render: (s: any) => (
                  <Button variant="ghost" size="icon" onClick={() => setDeleteTarget(s.id)}>
                    <Trash2 className="w-4 h-4 text-destructive" />
                  </Button>
                )},
              ]}
              data={searches || []}
            />
          )}
        </CardContent>
      </Card>

      <ConfirmDialog
        open={deleteTarget !== null}
        onOpenChange={(o) => { if (!o) setDeleteTarget(null) }}
        title={t('savedSearches.deleteTitle')}
        description={t('savedSearches.deleteConfirm')}
        onConfirm={() => deleteTarget && deleteMutation.mutate(deleteTarget)}
        loading={deleteMutation.isPending}
      />
    </div>
  )
}
