/*
 * صفحة حوادث المخاطر: تسجيل حوادث المخاطر
 * وربطها بالمخاطر المسجلة في السجل.
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
import { riskIncidentSchema } from '../../lib/schemas'
import { z } from 'zod'
import { useTranslation } from 'react-i18next'

type FormData = z.input<typeof riskIncidentSchema>

export default function RiskIncidents() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [open, setOpen] = useState(false)
  const canCreate = usePermission('incident.create')
  const { register, handleSubmit, reset, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(riskIncidentSchema),
  })

  const { data: incidents, isLoading } = useQuery({
    queryKey: ['risk-incidents'],
    queryFn: () => api.get('/safety/risk-incidents').then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/safety/risk-incidents', body),
    onSuccess: () => { toast.success(t('riskIncidents.created')); queryClient.invalidateQueries({ queryKey: ['risk-incidents'] }); setOpen(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('riskIncidents.createFailed')),
  })

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('riskIncidents.title')}</h1>
        {canCreate && (
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild><Button>{t('riskIncidents.report')}</Button></DialogTrigger>
          <DialogContent>
            <form onSubmit={handleSubmit((data) => createMutation.mutate(data))}>
            <DialogHeader><DialogTitle>{t('riskIncidents.reportNew')}</DialogTitle></DialogHeader>
            <div className="space-y-4">
              <div><Label>{t('riskIncidents.riskId')}</Label><Input type="number" {...register('risk_id', { valueAsNumber: true })} />{errors.risk_id && <p className="text-red-500 text-xs">{errors.risk_id.message}</p>}</div>
              <div><Label>{t('riskIncidents.incidentCode')}</Label><Input {...register('incident_code')} />{errors.incident_code && <p className="text-red-500 text-xs">{errors.incident_code.message}</p>}</div>
              <div><Label>{t('riskIncidents.incidentDate')}</Label><Input type="datetime-local" {...register('incident_date')} />{errors.incident_date && <p className="text-red-500 text-xs">{errors.incident_date.message}</p>}</div>
              <div><Label>{t('riskIncidents.description')}</Label><Textarea {...register('description')} />{errors.description && <p className="text-red-500 text-xs">{errors.description.message}</p>}</div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>{t('riskIncidents.severity')}</Label><Input {...register('severity')} /></div>
                <div><Label>{t('riskIncidents.rootCause')}</Label><Input {...register('root_cause')} /></div>
              </div>
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
                { key: 'incident_code', label: t('riskIncidents.incidentCode') },
                { key: 'risk_code', label: t('riskIncidents.riskCode') },
                { key: 'risk_title', label: t('riskIncidents.riskTitle') },
                { key: 'incident_date', label: t('riskIncidents.incidentDate') },
                { key: 'severity', label: t('riskIncidents.severityR'), filterable: true, render: (r: any) => <StatusBadge status={r.severity} /> },
                { key: 'status', label: t('riskIncidents.status'), filterable: true, render: (r: any) => <StatusBadge status={r.status} /> },
                { key: 'reported_by_name', label: t('riskIncidents.reportedBy') },
              ]}
              data={incidents || []}
            />
          )}
        </CardContent>
      </Card>
    </div>
  )
}
