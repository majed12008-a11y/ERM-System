/*
 * صفحة سجل المخاطر: إنشاء وتحديث وإدارة المخاطر
 * المرتبطة بالأبحاث والمشاريع.
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
import { riskRegisterSchema } from '../../lib/schemas'
import { z } from 'zod'
import { useTranslation } from 'react-i18next'

type RiskFormData = z.input<typeof riskRegisterSchema>

export default function RiskRegister() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [open, setOpen] = useState(false)
  const canCreate = usePermission('risk.create')
  const { register, handleSubmit, reset, formState: { errors } } = useForm<RiskFormData>({
    resolver: zodResolver(riskRegisterSchema),
  })

  const { data: risks, isLoading } = useQuery({
    queryKey: ['risk-register'],
    queryFn: () => api.get('/safety/risk-register').then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/safety/risk-register', body),
    onSuccess: () => { toast.success(t('riskRegister.created')); queryClient.invalidateQueries({ queryKey: ['risk-register'] }); setOpen(false); reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('riskRegister.createFailed')),
  })

  const severityBadge = (level: string) => {
    return <StatusBadge status={level} />
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('riskRegister.title')}</h1>
        {canCreate && (
        <Dialog open={open} onOpenChange={setOpen}>
          <DialogTrigger asChild><Button>{t('riskRegister.new')}</Button></DialogTrigger>
          <DialogContent>
            <form onSubmit={handleSubmit((data) => createMutation.mutate(data))}>
            <DialogHeader><DialogTitle>{t('riskRegister.registerNew')}</DialogTitle></DialogHeader>
            <div className="space-y-4">
              <div><Label>{t('riskRegister.riskCode')}</Label><Input {...register('risk_code')} />{errors.risk_code && <p className="text-red-500 text-xs">{errors.risk_code.message}</p>}</div>
              <div><Label>{t('riskRegister.titleLabel')}</Label><Input {...register('risk_title')} />{errors.risk_title && <p className="text-red-500 text-xs">{errors.risk_title.message}</p>}</div>
              <div><Label>{t('riskRegister.description')}</Label><Textarea {...register('risk_description')} /></div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>{t('riskRegister.likelihood')}</Label><Input type="number" min={1} max={5} {...register('likelihood', { valueAsNumber: true })} /></div>
                <div><Label>{t('riskRegister.impact')}</Label><Input type="number" min={1} max={5} {...register('impact', { valueAsNumber: true })} /></div>
              </div>
              <div><Label>{t('riskRegister.ownerId')}</Label><Input type="number" {...register('owner_id', { valueAsNumber: true })} /></div>
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
                { key: 'risk_code', label: t('riskRegister.code') },
                { key: 'risk_title', label: t('riskRegister.title') },
                { key: 'risk_level', label: t('riskRegister.level'), filterable: true, render: (r: any) => severityBadge(r.risk_level) },
                { key: 'likelihood', label: t('riskRegister.l') },
                { key: 'impact', label: t('riskRegister.i') },
                { key: 'risk_score', label: t('riskRegister.score') },
                { key: 'owner_name', label: t('riskRegister.owner') },
                { key: 'status', label: t('riskRegister.status'), filterable: true, render: (r: any) => <StatusBadge status={r.status} /> },
              ]}
              data={risks || []}
            />
          )}
        </CardContent>
      </Card>
    </div>
  )
}
