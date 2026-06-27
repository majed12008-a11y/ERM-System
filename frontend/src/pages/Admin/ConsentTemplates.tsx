/*
 * صفحة قوالب الموافقة المستنيرة: إنشاء وإدارة قوالب
 * نماذج الموافقة المستخدمة في الأبحاث.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useNavigate } from 'react-router-dom'
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
import { Plus, Pencil, Trash2, FileText } from 'lucide-react'

const CONSENT_TYPES = ['WRITTEN', 'ELECTRONIC', 'VERBAL', 'GUARDIAN', 'ASSENT', 'WAIVER', 'DEFERRED']

export default function ConsentTemplates() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const navigate = useNavigate()

  const [openCreate, setOpenCreate] = useState(false)
  const [openEdit, setOpenEdit] = useState<any>(null)
  const [form, setForm] = useState({ code: '', name_ar: '', name_en: '', description: '', consent_type: 'WRITTEN' })

  const { data: templates, isLoading } = useQuery({
    queryKey: ['consent-templates'],
    queryFn: () => api.get('/committee/consent/templates').then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post('/committee/consent/templates', body),
    onSuccess: () => {
      toast.success(t('consent.templateCreated'))
      queryClient.invalidateQueries({ queryKey: ['consent-templates'] })
      setOpenCreate(false); resetForm()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const updateMutation = useMutation({
    mutationFn: (body: any) => api.put(`/committee/consent/templates/${body.id}`, body),
    onSuccess: () => {
      toast.success(t('consent.templateUpdated'))
      queryClient.invalidateQueries({ queryKey: ['consent-templates'] })
      setOpenEdit(null); resetForm()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/committee/consent/templates/${id}`),
    onSuccess: () => {
      toast.success(t('consent.templateRetired'))
      queryClient.invalidateQueries({ queryKey: ['consent-templates'] })
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  function resetForm() {
    setForm({ code: '', name_ar: '', name_en: '', description: '', consent_type: 'WRITTEN' })
  }

  function openEditDialog(tpl: any) {
    setForm({
      code: tpl.code, name_ar: tpl.name_ar, name_en: tpl.name_en,
      description: tpl.description || '', consent_type: tpl.consent_type
    })
    setOpenEdit(tpl)
  }

  const columns = [
    { key: 'code', label: t('consent.templateCode') },
    { key: 'name_ar', label: t('consent.templateNameAr') },
    { key: 'name_en', label: t('consent.templateNameEn') },
    { key: 'consent_type', label: t('consent.consentType'), render: (item: any) => t(`consent.${item.consent_type.toLowerCase()}`) },
    {
      key: 'actions', label: '', render: (item: any) => (
        <div className="flex gap-2 justify-end">
          <Button variant="outline" size="sm" onClick={() => navigate(`/admin/consent-templates/${item.id}/versions`)}>
            <FileText className="w-4 h-4 ml-1" />{t('consent.versions')}
          </Button>
          <Button variant="outline" size="sm" onClick={() => openEditDialog(item)}>
            <Pencil className="w-4 h-4" />
          </Button>
          <Button variant="destructive" size="sm" onClick={() => deleteMutation.mutate(item.id)}>
            <Trash2 className="w-4 h-4" />
          </Button>
        </div>
      )
    },
  ]

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <FileText className="w-6 h-6 text-blue-600" />
          <h1 className="text-2xl font-bold">{t('consent.templates')}</h1>
        </div>
        <Button onClick={() => { resetForm(); setOpenCreate(true) }}>
          <Plus className="w-4 h-4 ml-2" />{t('consent.newTemplate')}
        </Button>
      </div>

      <Card>
        <CardContent className="p-0">
          <DataTable columns={columns} data={templates || []} isLoading={isLoading} />
        </CardContent>
      </Card>

      <Dialog open={openCreate} onOpenChange={setOpenCreate}>
        <DialogContent>
          <DialogHeader><DialogTitle>{t('consent.newTemplate')}</DialogTitle></DialogHeader>
          <CreateEditForm form={form} setForm={setForm} t={t} />
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpenCreate(false)}>{t('common.cancel')}</Button>
            <Button onClick={() => createMutation.mutate(form)}>{t('common.save')}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={!!openEdit} onOpenChange={(v) => { if (!v) setOpenEdit(null) }}>
        <DialogContent>
          <DialogHeader><DialogTitle>{t('consent.editTemplate')}</DialogTitle></DialogHeader>
          <CreateEditForm form={form} setForm={setForm} t={t} />
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpenEdit(null)}>{t('common.cancel')}</Button>
            <Button onClick={() => updateMutation.mutate({ ...form, id: openEdit?.id })}>{t('common.save')}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}

function CreateEditForm({ form, setForm, t }: { form: any; setForm: (f: any) => void; t: (k: string) => string }) {
  return (
    <div className="grid gap-4 py-4">
      <div>
        <Label>{t('consent.templateCode')}</Label>
        <Input value={form.code} onChange={e => setForm({ ...form, code: e.target.value })} placeholder="CLINICAL_TRIAL" />
      </div>
      <div>
        <Label>{t('consent.templateNameAr')}</Label>
        <Input value={form.name_ar} onChange={e => setForm({ ...form, name_ar: e.target.value })} />
      </div>
      <div>
        <Label>{t('consent.templateNameEn')}</Label>
        <Input value={form.name_en} onChange={e => setForm({ ...form, name_en: e.target.value })} />
      </div>
      <div>
        <Label>{t('consent.description')}</Label>
        <Textarea value={form.description} onChange={e => setForm({ ...form, description: e.target.value })} />
      </div>
      <div>
        <Label>{t('consent.consentType')}</Label>
        <Select value={form.consent_type} onValueChange={v => setForm({ ...form, consent_type: v })}>
          <SelectTrigger><SelectValue /></SelectTrigger>
          <SelectContent>
            {CONSENT_TYPES.map(ct => (
              <SelectItem key={ct} value={ct}>{t(`consent.${ct.toLowerCase()}`)}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
    </div>
  )
}
