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
import { Plus, Pencil, Trash2, FileStack, Eye, CopyPlus, Star, StarOff } from 'lucide-react'
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
  language?: string
  document_category?: string | null
  is_default?: boolean
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
  const [newVersionTarget, setNewVersionTarget] = useState<DocTemplate | null>(null)
  const [newVersionContent, setNewVersionContent] = useState('')
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

  const newVersionMutation = useMutation({
    mutationFn: ({ id, template_content, template_name }: { id: number; template_content: string; template_name?: string }) =>
      api.post(`/documents/templates/${id}/new-version`, { template_content, template_name }),
    onSuccess: () => {
      toast.success(t('documentTemplates.versionCreated'))
      queryClient.invalidateQueries({ queryKey: ['document-templates'] })
      setNewVersionTarget(null)
      setNewVersionContent('')
    },
    onError: (err: AxiosError<{ error?: string }>) => toast.error(err.response?.data?.error || t('documentTemplates.versionFailed')),
  })

  const setDefaultMutation = useMutation({
    mutationFn: (id: number) => api.post(`/documents/templates/${id}/set-default`),
    onSuccess: () => {
      toast.success(t('documentTemplates.defaultSet'))
      queryClient.invalidateQueries({ queryKey: ['document-templates'] })
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
    {
      key: 'language', label: t('documentTemplates.language'),
      render: (item) => item.language === 'en' ? 'English' : 'العربية',
    },
    { key: 'version_no', label: t('documentTemplates.version') },
    {
      key: 'is_default', label: t('documentTemplates.default'),
      render: (item) => item.is_default
        ? <span className="text-amber-500 flex items-center gap-1 text-sm"><Star className="w-3.5 h-3.5" />{t('documentTemplates.default')}</span>
        : <span className="text-slate-400 text-sm">{t('documentTemplates.notDefault')}</span>,
    },
    {
      key: 'is_active', label: t('documentTemplates.active'),
      render: (item) => item.is_active
        ? <span className="text-green-600 text-sm">{t('documentTemplates.active')}</span>
        : <span className="text-slate-400 text-sm">{t('documentTemplates.inactive')}</span>,
    },
    {
      key: 'actions', label: '', render: (item) => (
        <div className="flex gap-2 justify-end">
          <Button variant="outline" size="sm" title={t('documentTemplates.view')} onClick={() => setViewing(item)}>
            <Eye className="w-4 h-4" />
          </Button>
          <Button variant="outline" size="sm" title={t('documentTemplates.edit')} onClick={() => openEditDialog(item)}>
            <Pencil className="w-4 h-4" />
          </Button>
          {item.is_active && (
            <Button variant="outline" size="sm" title={t('documentTemplates.newVersion')} onClick={() => { setNewVersionTarget(item); setNewVersionContent(item.template_content) }}>
              <CopyPlus className="w-4 h-4" />
            </Button>
          )}
          {item.is_active && !item.is_default && (
            <Button variant="outline" size="sm" title={t('documentTemplates.setDefault')} onClick={() => setDefaultMutation.mutate(item.id)}>
              <StarOff className="w-4 h-4" />
            </Button>
          )}
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

      <Dialog open={!!newVersionTarget} onOpenChange={(v) => { if (!v) { setNewVersionTarget(null); setNewVersionContent('') } }}>
        <DialogContent className="max-w-2xl max-h-[80vh] overflow-y-auto">
          <DialogHeader>
            <DialogTitle>{t('documentTemplates.newVersionTitle')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-3 py-2">
            <p className="text-sm text-slate-500">
              {newVersionTarget?.template_code} • v{newVersionTarget?.version_no} → v{(newVersionTarget?.version_no || 0) + 1}
              {' '}• {newVersionTarget?.language === 'en' ? 'English' : 'العربية'}
            </p>
            <div>
              <Label>{t('documentTemplates.content')}</Label>
              <Textarea rows={12} className="mt-1 font-mono text-xs" value={newVersionContent} onChange={e => setNewVersionContent(e.target.value)} />
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => { setNewVersionTarget(null); setNewVersionContent('') }}>{t('common.cancel')}</Button>
            <Button
              disabled={!newVersionContent.trim() || newVersionMutation.isPending}
              onClick={() => newVersionTarget && newVersionMutation.mutate({ id: newVersionTarget.id, template_content: newVersionContent })}
            >
              {t('documentTemplates.createVersion')}
            </Button>
          </DialogFooter>
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
