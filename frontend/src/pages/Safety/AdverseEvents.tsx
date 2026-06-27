/*
 * صفحة الأحداث الضارة: تسجيل وإدارة الأحداث الضارة
 * في الأبحاث والإبلاغ عنها.
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
import { adverseEventSchema } from '../../lib/schemas'
import { z } from 'zod'
import { useTranslation } from 'react-i18next'

type FormData = z.input<typeof adverseEventSchema>

export default function AdverseEvents() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [open, setOpen] = useState(false)
  const canCreate = usePermission('adverse_event.create')
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(adverseEventSchema),
  })

  const { data: events, isLoading } = useQuery({
    queryKey: ['adverse-events'],
    queryFn: () => api.get('/safety/adverse-events').then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/safety/adverse-events', body),
    onSuccess: () => { toast.success(t('adverseEvents.created')); queryClient.invalidateQueries({ queryKey: ['adverse-events'] }); setOpen(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('adverseEvents.createFailed')),
  })

  const severityBadge = (s: string) => <StatusBadge status={s} />

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('adverseEvents.title')}</h1>
        {canCreate && (
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild><Button>{t('adverseEvents.report')}</Button></DialogTrigger>
          <DialogContent>
            <form onSubmit={handleSubmit((data) => createMutation.mutate(data))}>
            <DialogHeader><DialogTitle>{t('adverseEvents.reportNew')}</DialogTitle></DialogHeader>
            <div className="space-y-4">
              <div><Label>{t('adverseEvents.applicationId')}</Label><Input type="number" {...register('application_id', { valueAsNumber: true })} />{errors.application_id && <p className="text-red-500 text-xs">{errors.application_id.message}</p>}</div>
              <div><Label>{t('adverseEvents.eventNumber')}</Label><Input {...register('event_number')} />{errors.event_number && <p className="text-red-500 text-xs">{errors.event_number.message}</p>}</div>
              <div><Label>{t('adverseEvents.eventDate')}</Label><Input type="date" {...register('event_date')} />{errors.event_date && <p className="text-red-500 text-xs">{errors.event_date.message}</p>}</div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>{t('adverseEvents.eventType')}</Label><Input {...register('event_type')} />{errors.event_type && <p className="text-red-500 text-xs">{errors.event_type.message}</p>}</div>
                <div><Label>{t('adverseEvents.severity')}</Label><Input {...register('severity')} />{errors.severity && <p className="text-red-500 text-xs">{errors.severity.message}</p>}</div>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>{t('adverseEvents.expectedness')}</Label><Input {...register('expectedness')} /></div>
                <div><Label>{t('adverseEvents.relatedness')}</Label><Input {...register('relatedness')} /></div>
              </div>
              <div><Label>{t('adverseEvents.description')}</Label><Textarea {...register('description')} />{errors.description && <p className="text-red-500 text-xs">{errors.description.message}</p>}</div>
              <div><Label>{t('adverseEvents.outcomeStatus')}</Label><Input {...register('outcome_status')} /></div>
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
                { key: 'event_number', label: t('adverseEvents.eventNumber') },
                { key: 'event_type', label: t('adverseEvents.eventType'), filterable: true },
                { key: 'severity', label: t('adverseEvents.severity'), filterable: true, render: (r: any) => severityBadge(r.severity) },
                { key: 'expectedness', label: t('adverseEvents.expectedness') },
                { key: 'relatedness', label: t('adverseEvents.relatedness') },
                { key: 'outcome_status', label: t('adverseEvents.outcomeStatus') },
                { key: 'application_number', label: t('adverseEvents.application') },
                { key: 'project_title', label: t('adverseEvents.project') },
                { key: 'event_date', label: t('adverseEvents.eventDate') },
              ]}
              data={events || []}
            />
          )}
        </CardContent>
      </Card>
    </div>
  )
}
