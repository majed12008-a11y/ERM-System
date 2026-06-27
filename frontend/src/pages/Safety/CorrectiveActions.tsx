/*
 * صفحة الإجراءات التصحيحية: إدارة الإجراءات التصحيحية
 * والوقائية للمخاطر والحوادث.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { usePermission } from '../../hooks/usePermission'
import { Button } from '../../components/ui/button'
import { Card, CardContent } from '../../components/ui/card'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter,
} from '../../components/ui/dialog'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import { Textarea } from '../../components/ui/textarea'
import { correctiveActionSchema } from '../../lib/schemas'
import { z } from 'zod'
import { useTranslation } from 'react-i18next'

type FormData = z.input<typeof correctiveActionSchema>

export default function CorrectiveActions() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [open, setOpen] = useState(false)
  const canCreate = usePermission('corrective_action.create')
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(correctiveActionSchema),
  })

  const { data: actions, isLoading } = useQuery({
    queryKey: ['corrective-actions'],
    queryFn: () => api.get('/safety/corrective-actions').then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/safety/corrective-actions', body),
    onSuccess: () => { toast.success(t('correctiveActions.created')); queryClient.invalidateQueries({ queryKey: ['corrective-actions'] }); setOpen(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('correctiveActions.createFailed')),
  })

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('correctiveActions.title')}</h1>
        {canCreate && (
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild><Button>{t('correctiveActions.new')}</Button></DialogTrigger>
          <DialogContent>
            <form onSubmit={handleSubmit((data) => createMutation.mutate(data))}>
            <DialogHeader><DialogTitle>{t('correctiveActions.createNew')}</DialogTitle></DialogHeader>
            <div className="space-y-4">
              <div><Label>{t('correctiveActions.incidentId')}</Label><Input type="number" {...register('incident_id', { valueAsNumber: true })} /></div>
              <div><Label>{t('correctiveActions.actionCode')}</Label><Input {...register('action_code')} />{errors.action_code && <p className="text-red-500 text-xs">{errors.action_code.message}</p>}</div>
              <div><Label>{t('correctiveActions.description')}</Label><Textarea {...register('description')} />{errors.description && <p className="text-red-500 text-xs">{errors.description.message}</p>}</div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>{t('correctiveActions.assignedTo')}</Label><Input type="number" {...register('assigned_to', { valueAsNumber: true })} /></div>
                <div><Label>{t('correctiveActions.priority')}</Label><Input {...register('priority')} /></div>
              </div>
              <div><Label>{t('correctiveActions.dueDate')}</Label><Input type="date" {...register('due_date')} /></div>
            </div>
            <DialogFooter>
              <Button variant="outline" type="button" onClick={() => setOpen(false)}>{t('common.cancel')}</Button>
              <Button type="submit" disabled={createMutation.isPending}>{t('common.create')}</Button>
            </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
        )}
      </div>

      <Card>
        <CardContent className="p-0">
          {isLoading ? (
            <div className="p-8 text-center text-muted-foreground">{t('common.loading')}</div>
          ) : (
            <DataTable
              searchable
              columns={[
                { key: 'action_code', label: t('correctiveActions.actionCode') },
                { key: 'description', label: t('correctiveActions.description') },
                { key: 'incident_description', label: t('correctiveActions.incident') },
                { key: 'priority', label: t('correctiveActions.priority'), filterable: true, render: (r: any) => <StatusBadge status={r.priority} /> },
                { key: 'due_date', label: t('correctiveActions.dueDate') },
                { key: 'status', label: t('correctiveActions.status'), filterable: true, render: (r: any) => <StatusBadge status={r.status} /> },
              ]}
              data={actions || []}
            />
          )}
        </CardContent>
      </Card>
    </div>
  )
}
