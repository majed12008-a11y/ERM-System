import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import { useTranslation } from 'react-i18next'
import api from '../api/client'
import { StatusBadge } from './StatusBadge'
import { Button } from './ui/button'
import { Card, CardContent, CardHeader, CardTitle } from './ui/card'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter,
} from './ui/dialog'
import { Input } from './ui/input'
import { Label } from './ui/label'
import { Textarea } from './ui/textarea'
import { AlertCircle, Shield, Activity } from 'lucide-react'
import { z } from 'zod'

const riskItemSchema = z.object({
  risk_category_id: z.coerce.number().min(1, 'Select category'),
  risk_description: z.string().min(1, 'Description required').max(2000),
  probability: z.coerce.number().int().min(1).max(5),
  severity: z.coerce.number().int().min(1).max(5),
  mitigation_plan: z.string().optional().default(''),
  is_acceptable: z.boolean().optional().default(false),
})

const createAssessmentSchema = z.object({
  overall_risk_level: z.enum(['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']),
  recommendation: z.string().optional().default(''),
  summary: z.string().optional().default(''),
})

const PROBABILITY_LABELS = ['', 'نادر (1)', 'غير محتمل (2)', 'محتمل (3)', 'مرجح (4)', 'شبه مؤكد (5)']
const SEVERITY_LABELS = ['', 'طفيف (1)', 'بسيط (2)', 'متوسط (3)', 'شديد (4)', 'كارثي (5)']

function riskLevelColor(level: string) {
  switch (level) {
    case 'LOW': return 'bg-green-100 text-green-800 border-green-300'
    case 'MEDIUM': return 'bg-yellow-100 text-yellow-800 border-yellow-300'
    case 'HIGH': return 'bg-orange-100 text-orange-800 border-orange-300'
    case 'CRITICAL': return 'bg-red-100 text-red-800 border-red-300'
    default: return 'bg-slate-100 text-slate-800 border-slate-300'
  }
}

function matrixColor(score: number) {
  if (score >= 15) return 'bg-red-600 text-white'
  if (score >= 10) return 'bg-red-400 text-white'
  if (score >= 6) return 'bg-orange-400 text-white'
  if (score >= 4) return 'bg-yellow-400 text-black'
  return 'bg-green-400 text-black'
}

export default function RiskAssessment({ applicationId, reviewerId }: { applicationId: string | number, reviewerId?: number }) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [openCreate, setOpenCreate] = useState(false)
  const [openAddItem, setOpenAddItem] = useState(false)

  const createForm = useForm<z.input<typeof createAssessmentSchema>>({
    resolver: zodResolver(createAssessmentSchema),
    defaultValues: { overall_risk_level: 'MEDIUM', recommendation: '', summary: '' },
  })

  const itemForm = useForm<z.input<typeof riskItemSchema>>({
    resolver: zodResolver(riskItemSchema),
  })

  const { data: assessment, isLoading } = useQuery({
    queryKey: ['ethics-risk', applicationId],
    queryFn: () => api.get(`/committee/ethics-risk/application/${applicationId}`).then(r => r.data.data).catch(() => null),
    enabled: !!applicationId,
  })

  const { data: categories } = useQuery({
    queryKey: ['risk-categories'],
    queryFn: () => api.get('/committee/ethics-risk/categories').then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/committee/ethics-risk', body),
    onSuccess: () => {
      toast.success(t('risk.assessmentCreated'))
      queryClient.invalidateQueries({ queryKey: ['ethics-risk', applicationId] })
      setOpenCreate(false)
      createForm.reset()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const addItemMutation = useMutation({
    mutationFn: (body: any) => api.post(`/committee/ethics-risk/${assessment.id}/items`, body),
    onSuccess: () => {
      toast.success(t('risk.itemAdded'))
      queryClient.invalidateQueries({ queryKey: ['ethics-risk', applicationId] })
      setOpenAddItem(false)
      itemForm.reset()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  if (isLoading) return null

  const renderMatrix = () => {
    const rows = []
    for (let sev = 5; sev >= 1; sev--) {
      const cells = []
      for (let prob = 1; prob <= 5; prob++) {
        const score = prob * sev
        cells.push(
          <div key={`${prob}-${sev}`} className={`w-8 h-8 flex items-center justify-center text-xs font-bold rounded ${matrixColor(score)}`}>
            {score}
          </div>
        )
      }
      rows.push(
        <div key={sev} className="flex items-center gap-1">
          <span className="text-xs w-20 text-right mr-1">{SEVERITY_LABELS[sev]}</span>
          {cells}
        </div>
      )
    }
    return (
      <div className="space-y-1">
        <div className="flex items-center gap-1 mb-1">
          <span className="text-xs w-20 text-right mr-1" />
          {[1,2,3,4,5].map(p => <div key={p} className="w-8 text-center text-[10px]">{p}</div>)}
        </div>
        {rows}
        <div className="flex items-center gap-1 mt-1">
          <span className="text-xs w-20 text-right mr-1" />
          {['1','2','3','4','5'].map(p => <div key={p} className="w-8 text-center text-[10px] text-slate-400">P{p}</div>)}
        </div>
      </div>
    )
  }

  const renderAssessment = () => {
    if (!assessment) return null
    const items = assessment.items || []
    const maxScore = Math.max(...items.map((i: any) => i.risk_score || 0), 0)
    return (
      <div className="space-y-4">
        <div className="flex items-center gap-3">
          <span className={`text-sm font-bold px-3 py-1 rounded-full border ${riskLevelColor(assessment.overall_risk_level)}`}>
            {assessment.overall_risk_level}
          </span>
          {assessment.overall_risk_score && (
            <span className="text-xs text-slate-500">{t('risk.maxScore')}: {maxScore}</span>
          )}
          {assessment.recommendation && (
            <span className="text-xs text-slate-500">{t('risk.recommendation')}: {assessment.recommendation}</span>
          )}
        </div>

        {assessment.summary && (
          <p className="text-sm text-slate-600 bg-slate-50 p-2 rounded">{assessment.summary}</p>
        )}
        <p className="text-xs text-slate-400">{t('risk.assessedBy')}: {assessment.assessor_name} | {new Date(assessment.assessment_date).toLocaleDateString()}</p>

        {items.length > 0 && (
          <div>
            <h4 className="text-xs font-semibold text-slate-500 mb-2">{t('risk.riskItems')}</h4>
            <div className="space-y-2">
              {items.map((item: any) => (
                <div key={item.id} className="text-xs border rounded p-2">
                  <div className="flex items-center justify-between">
                    <span className="font-medium text-slate-700">{item.category_name}</span>
                    <div className="flex items-center gap-2">
                      <span className="text-[10px] bg-slate-100 px-1.5 py-0.5 rounded">{t('risk.probabilityLabel')}: {item.probability}</span>
                      <span className="text-[10px] bg-slate-100 px-1.5 py-0.5 rounded">{t('risk.severityLabel')}: {item.severity}</span>
                      <span className={`text-[10px] font-bold px-1.5 py-0.5 rounded ${matrixColor(item.risk_score)}`}>{item.risk_score}</span>
                    </div>
                  </div>
                  <p className="text-slate-600 mt-1">{item.risk_description}</p>
                  {item.mitigation_plan && (
                    <div className="mt-1 text-slate-500">
                      <span className="font-medium">{t('risk.mitigation')}:</span> {item.mitigation_plan}
                    </div>
                  )}
                  {item.residual_probability && (
                    <div className="mt-1 text-slate-500">
                      <span className="font-medium">{t('risk.residualRisk')}:</span> P={item.residual_probability} x S={item.residual_severity} = {item.residual_score}
                      {item.is_acceptable && <span className="text-green-600 mr-1"> ({t('risk.acceptable')})</span>}
                    </div>
                  )}
                </div>
              ))}
            </div>
          </div>
        )}

        <div className="border-t pt-3">
          <p className="text-xs font-medium text-slate-500 mb-2">{t('risk.matrix')}</p>
          {renderMatrix()}
        </div>

        <Dialog open={openAddItem} onOpenChange={setOpenAddItem}>
          <DialogTrigger asChild>
            <Button variant="outline" size="sm">{t('risk.addItem')}</Button>
          </DialogTrigger>
          <DialogContent>
            <form onSubmit={itemForm.handleSubmit((data) => addItemMutation.mutate({ ...data, assessment_id: assessment.id }))}>
              <DialogHeader><DialogTitle>{t('risk.addRiskItem')}</DialogTitle></DialogHeader>
              <div className="space-y-3 py-2">
                <div>
                  <Label>{t('risk.category')}</Label>
                  <select {...itemForm.register('risk_category_id', { valueAsNumber: true })} className="w-full p-2 border rounded text-sm">
                    <option value="">{t('projects.select')}</option>
                    {(categories || []).map((c: any) => (
                      <option key={c.id} value={c.id}>{c.category_name}</option>
                    ))}
                  </select>
                </div>
                <div><Label>{t('risk.description')}</Label><Textarea {...itemForm.register('risk_description')} /></div>
                <div className="grid grid-cols-2 gap-3">
                  <div>
                    <Label>{t('risk.probability')}</Label>
                    <select {...itemForm.register('probability', { valueAsNumber: true })} className="w-full p-2 border rounded text-sm">
                      {[1,2,3,4,5].map(p => <option key={p} value={p}>{PROBABILITY_LABELS[p]}</option>)}
                    </select>
                  </div>
                  <div>
                    <Label>{t('risk.severity')}</Label>
                    <select {...itemForm.register('severity', { valueAsNumber: true })} className="w-full p-2 border rounded text-sm">
                      {[1,2,3,4,5].map(s => <option key={s} value={s}>{SEVERITY_LABELS[s]}</option>)}
                    </select>
                  </div>
                </div>
                <div><Label>{t('risk.mitigationPlan')}</Label><Textarea {...itemForm.register('mitigation_plan')} /></div>
              </div>
              <DialogFooter>
                <Button variant="outline" type="button" onClick={() => setOpenAddItem(false)}>{t('common.cancel')}</Button>
                <Button type="submit" disabled={addItemMutation.isPending}>{t('common.add')}</Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>
    )
  }

  return (
    <Card>
      <CardHeader>
        <CardTitle className="text-sm flex items-center gap-2">
          <Shield className="w-4 h-4" /> {t('risk.ethicsRiskAssessment')}
        </CardTitle>
      </CardHeader>
      <CardContent>
        {assessment ? renderAssessment() : (
          <div className="text-center py-4">
            <AlertCircle className="w-8 h-8 text-slate-300 mx-auto mb-2" />
            <p className="text-sm text-slate-400 mb-3">{t('risk.noAssessment')}</p>
            <Dialog open={openCreate} onOpenChange={setOpenCreate}>
              <DialogTrigger asChild>
                <Button size="sm">{t('risk.createAssessment')}</Button>
              </DialogTrigger>
              <DialogContent>
                <form onSubmit={createForm.handleSubmit((data) => {
                  createMutation.mutate({
                    application_id: Number(applicationId),
                    ...data,
                    items: [],
                  })
                })}>
                  <DialogHeader><DialogTitle>{t('risk.newAssessment')}</DialogTitle></DialogHeader>
                  <div className="space-y-3 py-2">
                    <div>
                      <Label>{t('risk.overallLevel')}</Label>
                      <select {...createForm.register('overall_risk_level')} className="w-full p-2 border rounded text-sm">
                        <option value="LOW">{t('risk.low')}</option>
                        <option value="MEDIUM">{t('risk.medium')}</option>
                        <option value="HIGH">{t('risk.high')}</option>
                        <option value="CRITICAL">{t('risk.critical')}</option>
                      </select>
                    </div>
                    <div>
                      <Label>{t('risk.recommendation')}</Label>
                      <select {...createForm.register('recommendation')} className="w-full p-2 border rounded text-sm">
                        <option value="">{t('projects.select')}</option>
                        <option value="APPROVED">{t('risk.approved')}</option>
                        <option value="APPROVE_WITH_MONITORING">{t('risk.approveWithMonitoring')}</option>
                        <option value="CONDITIONAL">{t('applications.conditional')}</option>
                        <option value="REJECT">{t('applications.reject')}</option>
                      </select>
                    </div>
                    <div><Label>{t('risk.summary')}</Label><Textarea rows={4} {...createForm.register('summary')} placeholder={t('risk.summaryPlaceholder')} /></div>
                  </div>
                  <DialogFooter>
                    <Button variant="outline" type="button" onClick={() => setOpenCreate(false)}>{t('common.cancel')}</Button>
                    <Button type="submit" disabled={createMutation.isPending}>{t('common.create')}</Button>
                  </DialogFooter>
                </form>
              </DialogContent>
            </Dialog>
          </div>
        )}
      </CardContent>
    </Card>
  )
}
