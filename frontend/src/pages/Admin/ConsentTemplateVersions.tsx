/*
 * صفحة إصدارات قوالب الموافقة: إدارة إصدارات القوالب
 * وتتبع التغييرات واستعراض الإصدارات السابقة.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useParams, useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { Button } from '../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '../../components/ui/dialog'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import { Textarea } from '../../components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../../components/ui/select'
import { StatusBadge } from '../../components/StatusBadge'
import { ArrowLeft, Plus, CheckCircle, Ban } from 'lucide-react'

const STATUS_COLORS: Record<string, string> = {
  DRAFT: 'bg-gray-100 text-gray-800',
  UNDER_REVIEW: 'bg-yellow-100 text-yellow-800',
  APPROVED: 'bg-green-100 text-green-800',
  RETIRED: 'bg-red-100 text-red-800',
}

export default function ConsentTemplateVersions() {
  const { t } = useTranslation()
  const { id: templateId } = useParams()
  const navigate = useNavigate()
  const queryClient = useQueryClient()

  const [openCreate, setOpenCreate] = useState(false)
  const [form, setForm] = useState({ version_no: 1, language: 'ar', title: '', content: '', change_summary: '' })

  const { data: template } = useQuery({
    queryKey: ['consent-template', templateId],
    queryFn: () => api.get(`/committee/consent/templates/${templateId}`).then(r => r.data.data),
    enabled: !!templateId,
  })

  const { data: versions, isLoading } = useQuery({
    queryKey: ['consent-versions', templateId],
    queryFn: () => api.get(`/committee/consent/templates/${templateId}/versions`).then(r => r.data.data),
    enabled: !!templateId,
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post(`/committee/consent/templates/${templateId}/versions`, body),
    onSuccess: () => {
      toast.success(t('consent.versionCreated'))
      queryClient.invalidateQueries({ queryKey: ['consent-versions', templateId] })
      setOpenCreate(false); setForm({ version_no: 1, language: 'ar', title: '', content: '', change_summary: '' })
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const approveMutation = useMutation({
    mutationFn: (versionId: number) => api.post(`/committee/consent/versions/${versionId}/approve`),
    onSuccess: () => {
      toast.success(t('consent.versionApproved'))
      queryClient.invalidateQueries({ queryKey: ['consent-versions', templateId] })
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const retireMutation = useMutation({
    mutationFn: (versionId: number) => api.post(`/committee/consent/versions/${versionId}/retire`),
    onSuccess: () => {
      toast.success(t('consent.versionRetired'))
      queryClient.invalidateQueries({ queryKey: ['consent-versions', templateId] })
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const columns = [
    { key: 'version_no', label: t('consent.versionNo') },
    { key: 'language', label: t('consent.language'), render: (item: any) => t(`consent.${item.language}`) },
    { key: 'title', label: t('consent.titleLocalized') },
    {
      key: 'status', label: t('consent.status'), render: (item: any) => (
        <StatusBadge status={item.status} colorMap={STATUS_COLORS} />
      )
    },
    { key: 'change_summary', label: t('consent.changeSummary') },
    {
      key: 'actions', label: '', render: (item: any) => (
        <div className="flex gap-2 justify-end">
          {(item.status === 'DRAFT' || item.status === 'UNDER_REVIEW') && (
            <Button variant="outline" size="sm" onClick={() => approveMutation.mutate(item.id)}>
              <CheckCircle className="w-4 h-4 ml-1" />{t('consent.approveVersion')}
            </Button>
          )}
          {item.status === 'APPROVED' && (
            <Button variant="outline" size="sm" onClick={() => retireMutation.mutate(item.id)}>
              <Ban className="w-4 h-4 ml-1" />{t('consent.retireVersion')}
            </Button>
          )}
        </div>
      )
    },
  ]

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <Button variant="ghost" size="sm" onClick={() => navigate('/admin/consent-templates')}>
            <ArrowLeft className="w-4 h-4 ml-1" />
          </Button>
          <div>
            <h1 className="text-2xl font-bold">{template?.name_ar || t('consent.versions')}</h1>
            <p className="text-sm text-gray-500">{template?.name_en}</p>
          </div>
        </div>
        <Button onClick={() => setOpenCreate(true)}>
          <Plus className="w-4 h-4 ml-2" />{t('consent.createVersion')}
        </Button>
      </div>

      <Card>
        <CardContent className="p-0">
          <DataTable columns={columns} data={versions || []} isLoading={isLoading} />
        </CardContent>
      </Card>

      <Dialog open={openCreate} onOpenChange={setOpenCreate}>
        <DialogContent>
          <DialogHeader><DialogTitle>{t('consent.newVersion')}</DialogTitle></DialogHeader>
          <div className="grid gap-4 py-4">
            <div>
              <Label>{t('consent.versionNo')}</Label>
              <Input type="number" value={form.version_no} onChange={e => setForm({ ...form, version_no: parseInt(e.target.value) || 1 })} />
            </div>
            <div>
              <Label>{t('consent.language')}</Label>
              <Select value={form.language} onValueChange={v => setForm({ ...form, language: v })}>
                <SelectTrigger><SelectValue /></SelectTrigger>
                <SelectContent>
                  <SelectItem value="ar">{t('consent.ar')}</SelectItem>
                  <SelectItem value="en">{t('consent.en')}</SelectItem>
                </SelectContent>
              </Select>
            </div>
            <div>
              <Label>{t('consent.titleLocalized')}</Label>
              <Input value={form.title} onChange={e => setForm({ ...form, title: e.target.value })} />
            </div>
            <div>
              <Label>{t('consent.content')}</Label>
              <Textarea value={form.content} onChange={e => setForm({ ...form, content: e.target.value })} rows={4} />
            </div>
            <div>
              <Label>{t('consent.changeSummary')}</Label>
              <Textarea value={form.change_summary} onChange={e => setForm({ ...form, change_summary: e.target.value })} />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpenCreate(false)}>{t('common.cancel')}</Button>
            <Button onClick={() => createMutation.mutate(form)}>{t('common.save')}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
