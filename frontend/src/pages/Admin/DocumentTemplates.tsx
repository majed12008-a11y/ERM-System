/*
 * صفحة إدارة قوالب الشهادات/المستندات: إنشاء وتعديل
 * وإيقاف قوالب المستندات المستخدمة في إصدار الشهادات
 * والمستندات الرسمية (Handlebars/HTML).
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { Button } from '../../components/ui/button'
import { Card, CardContent } from '../../components/ui/card'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '../../components/ui/dialog'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import { Textarea } from '../../components/ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '../../components/ui/select'
import ConfirmDialog from '../../components/ConfirmDialog'
import { Plus, Pencil, Trash2, FileStack, Eye } from 'lucide-react'
import { AxiosError } from 'axios'
import type { TFunction } from 'i18next'

const TEMPLATE_TYPES = ['HTML', 'PDF', 'TEXT']

interface DocTemplate {
  id: number
  template_code: string
  template_name: string
  template_type: string
  template_content: string
  version_no: number
  is_active: boolean
}

type TemplateFormValues = {
  template_code: string
  template_name: string
  template_type: string
  template_content: string
  is_active: boolean
}

type TemplateColumn = {
  key: string
  label: string
  render?: (item: DocTemplate) => React.ReactNode
}

export default function DocumentTemplates() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()

  const [openCreate, setOpenCreate] = useState(false)
  const [openEdit, setOpenEdit] = useState<DocTemplate | null>(null)
  const [viewing, setViewing] = useState<DocTemplate | null>(null)
  const [retireTarget, setRetireTarget] = useState<DocTemplate | null>(null)
  const [form, setForm] = useState<TemplateFormValues>({
    template_code: '', template_name: '', template_type: 'HTML',
    template_content: '', is_active: true,
  })

  const { data: templates, isLoading } = useQuery<DocTemplate[]>({
    queryKey: ['document-templates'],
    queryFn: () => api.get('/documents/templates').then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: (body: TemplateFormValues) => api.post('/documents/templates', body),
    onSuccess: () => {
      toast.success(t('documentTemplates.created'))
      queryClient.invalidateQueries({ queryKey: ['document-templates'] })
      setOpenCreate(false); resetForm()
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('documentTemplates.createFailed')),
  })

  const updateMutation = useMutation({
    mutationFn: (body: TemplateFormValues & { id: number }) => api.put(`/documents/templates/${body.id}`, body),
    onSuccess: () => {
      toast.success(t('documentTemplates.updated'))
      queryClient.invalidateQueries({ queryKey: ['document-templates'] })
      setOpenEdit(null); resetForm()
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('documentTemplates.updateFailed')),
  })

  const retireMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/documents/templates/${id}`),
    onSuccess: () => {
      toast.success(t('documentTemplates.retired'))
      queryClient.invalidateQueries({ queryKey: ['document-templates'] })
      setRetireTarget(null)
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('common.error')),
  })

  function resetForm() {
    setForm({ template_code: '', template_name: '', template_type: 'HTML', template_content: '', is_active: true })
  }

  function openEditDialog(tpl: DocTemplate) {
    setForm({
      template_code: tpl.template_code,
      template_name: tpl.template_name,
      template_type: tpl.template_type,
      template_content: tpl.template_content,
      is_active: tpl.is_active,
    })
    setOpenEdit(tpl)
  }

  const columns: TemplateColumn[] = [
    { key: 'template_code', label: t('documentTemplates.code') },
    { key: 'template_name', label: t('documentTemplates.name') },
    { key: 'template_type', label: t('documentTemplates.type'), render: (item) => t(`documentTemplates.type${item.template_type?.toUpperCase()}`) },
    { key: 'version_no', label: t('documentTemplates.version') },
    {
      key: 'is_active', label: t('documentTemplates.active'),
      render: (item) => item.is_active
        ? <span className="text-green-600 text-sm">{t('documentTemplates.active')}</span>
        : <span className="text-slate-400 text-sm">{t('documentTemplates.inactive')}</span>,
    },
    {
      key: 'actions', label: '', render: (item) => (
        <div className="flex gap-2 justify-end">
          <Button variant="outline" size="sm" onClick={() => setViewing(item)}>
            <Eye className="w-4 h-4" />
          </Button>
          <Button variant="outline" size="sm" onClick={() => openEditDialog(item)}>
            <Pencil className="w-4 h-4" />
          </Button>
          {item.is_active && (
            <Button variant="destructive" size="sm" onClick={() => setRetireTarget(item)}>
              <Trash2 className="w-4 h-4" />
            </Button>
          )}
        </div>
      ),
    },
  ]

  const editing = openEdit

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <FileStack className="w-6 h-6 text-blue-600" />
          <h1 className="text-2xl font-bold">{t('documentTemplates.title')}</h1>
        </div>
        <Button onClick={() => { resetForm(); setOpenCreate(true) }}>
          <Plus className="w-4 h-4 ml-2" />{t('documentTemplates.new')}
        </Button>
      </div>

      <Card>
        <CardContent className="p-0">
          <DataTable columns={columns} data={templates || []} isLoading={isLoading} />
        </CardContent>
      </Card>

      <Dialog open={openCreate} onOpenChange={setOpenCreate}>
        <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
          <DialogHeader><DialogTitle>{t('documentTemplates.create')}</DialogTitle></DialogHeader>
          <TemplateForm form={form} setForm={setForm} t={t} />
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpenCreate(false)}>{t('common.cancel')}</Button>
            <Button onClick={() => createMutation.mutate(form)}>{t('common.save')}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {editing && (
        <Dialog open={true} onOpenChange={(v) => { if (!v) { setOpenEdit(null); resetForm() } }}>
          <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
            <DialogHeader><DialogTitle>{t('documentTemplates.edit')}</DialogTitle></DialogHeader>
            <TemplateForm form={form} setForm={setForm} t={t} />
            <DialogFooter>
              <Button variant="outline" onClick={() => setOpenEdit(null)}>{t('common.cancel')}</Button>
              <Button onClick={() => updateMutation.mutate({ ...form, id: editing.id })}>{t('common.save')}</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      <Dialog open={!!viewing} onOpenChange={(v) => { if (!v) setViewing(null) }}>
        <DialogContent className="max-w-3xl max-h-[80vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{viewing?.template_name}</DialogTitle>
          </DialogHeader>
          <pre className="text-xs bg-slate-50 border rounded p-4 overflow-auto whitespace-pre-wrap font-mono max-h-[55vh]">
            {viewing?.template_content}
          </pre>
        </DialogContent>
      </Dialog>

      <ConfirmDialog
        open={!!retireTarget}
        onOpenChange={(o) => { if (!o) setRetireTarget(null) }}
        title={t('documentTemplates.retired')}
        description={t('documentTemplates.confirmRetire')}
        onConfirm={() => retireTarget && retireMutation.mutate(retireTarget.id)}
        loading={retireMutation.isPending}
      />
    </div>
  )
}

function TemplateForm({ form, setForm, t }: { form: TemplateFormValues; setForm: (f: TemplateFormValues) => void; t: TFunction }) {
  return (
    <div className="grid gap-4 py-4">
      <div>
        <Label>{t('documentTemplates.code')}</Label>
        <Input value={form.template_code} onChange={e => setForm({ ...form, template_code: e.target.value })} placeholder={t('documentTemplates.codePlaceholder')} />
      </div>
      <div>
        <Label>{t('documentTemplates.name')}</Label>
        <Input value={form.template_name} onChange={e => setForm({ ...form, template_name: e.target.value })} placeholder={t('documentTemplates.namePlaceholder')} />
      </div>
      <div>
        <Label>{t('documentTemplates.type')}</Label>
        <Select value={form.template_type} onValueChange={v => setForm({ ...form, template_type: v })}>
          <SelectTrigger><SelectValue /></SelectTrigger>
          <SelectContent>
            {TEMPLATE_TYPES.map(tt => (
              <SelectItem key={tt} value={tt}>{t(`documentTemplates.type${tt}`)}</SelectItem>
            ))}
          </SelectContent>
        </Select>
      </div>
      <div>
        <Label>{t('documentTemplates.content')}</Label>
        <Textarea rows={10} value={form.template_content} onChange={e => setForm({ ...form, template_content: e.target.value })} placeholder={t('documentTemplates.contentPlaceholder')} />
      </div>
    </div>
  )
}
