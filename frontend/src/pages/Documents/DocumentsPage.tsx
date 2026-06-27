/*
 * صفحة المستندات: رفع، تنزيل، إدارة الملفات
 * مع تصنيفها حسب الأنواع والكيانات المرتبطة.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState, useRef } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import ConfirmDialog from '../../components/ConfirmDialog'
import { FileUp, Trash2 } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger, DialogFooter } from '../../components/ui/dialog'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import { documentUploadSchema } from '../../lib/schemas'
import { useTranslation } from 'react-i18next'

type UploadFormData = { document_type_id?: string; entity_type?: string; entity_id?: string; document_title?: string }

export default function DocumentsPage() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const fileRef = useRef<HTMLInputElement>(null)
  const [open, setOpen] = useState(false)
  const [file, setFile] = useState<File | null>(null)

  const { register, handleSubmit, reset: resetForm } = useForm<UploadFormData>({
    resolver: zodResolver(documentUploadSchema),
  })

  const { data: documents, isLoading } = useQuery({
    queryKey: ['documents'],
    queryFn: () => api.get('/documents').then((r) => r.data.data),
  })

  const { data: types } = useQuery({
    queryKey: ['document-types'],
    queryFn: () => api.get('/documents/types').then((r) => r.data.data),
  })

  const uploadMutation = useMutation({
    mutationFn: (formData: FormData) => api.post('/documents', formData, { headers: { 'Content-Type': 'multipart/form-data' } }),
    onSuccess: () => { toast.success(t('documents.uploaded')); queryClient.invalidateQueries({ queryKey: ['documents'] }); setOpen(false); resetForm() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('documents.uploadFailed')),
  })

  const [deleteTarget, setDeleteTarget] = useState<number | null>(null)
  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/documents/${id}`),
    onSuccess: () => { toast.success(t('documents.deleted')); queryClient.invalidateQueries({ queryKey: ['documents'] }); setDeleteTarget(null) },
  })

  function resetAll() {
    resetForm()
    setFile(null)
  }

  function onUpload(data: UploadFormData) {
    if (!file) { toast.error(t('documents.selectFile')); return }
    const fd = new FormData()
    fd.append('file', file)
    if (data.document_title) fd.append('document_title', data.document_title)
    if (data.document_type_id) fd.append('document_type_id', data.document_type_id)
    if (data.entity_type) fd.append('entity_type', data.entity_type)
    if (data.entity_id) fd.append('entity_id', data.entity_id)
    uploadMutation.mutate(fd)
  }

  function formatSize(bytes: number) {
    if (!bytes) return '—'
    if (bytes < 1024) return `${bytes} B`
    if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
    return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('documents.title')}</h1>
        <Dialog open={open} onOpenChange={(o) => { setOpen(o); if (!o) resetAll() }}>
          <DialogTrigger asChild><Button><FileUp className="w-4 h-4 mr-1" /> {t('documents.upload')}</Button></DialogTrigger>
          <form onSubmit={handleSubmit(onUpload)}>
          <DialogContent>
            <DialogHeader><DialogTitle>{t('documents.uploadTitle')}</DialogTitle></DialogHeader>
            <div className="space-y-4">
              <div><Label>{t('documents.file')}</Label><input type="file" ref={fileRef} onChange={(e) => setFile(e.target.files?.[0] || null)} className="w-full text-sm" /></div>
              <div><Label>{t('documents.titleLabel')}</Label><Input {...register('document_title')} placeholder={t('documents.titlePlaceholder')} /></div>
              <div><Label>{t('documents.type')}</Label>
                <select {...register('document_type_id')} className="w-full p-2 border rounded text-sm">
                  <option value="">{t('documents.selectType')}</option>
                  {(types || []).map((t: any) => <option key={t.id} value={t.id}>{t.type_name_ar || t.type_code}</option>)}
                </select>
              </div>
              <div className="grid grid-cols-2 gap-4">
                <div><Label>{t('documents.entityType')}</Label>
                  <select {...register('entity_type')} className="w-full p-2 border rounded text-sm">
                    <option value="">{t('documents.none')}</option>
                    <option value="Application">{t('documents.application')}</option>
                    <option value="Project">{t('documents.project')}</option>
                  </select>
                </div>
                <div><Label>{t('documents.entityId')}</Label><Input type="number" {...register('entity_id')} /></div>
              </div>
            </div>
            <DialogFooter>
              <Button variant="outline" type="button" onClick={() => setOpen(false)}>{t('common.cancel')}</Button>
              <Button type="submit" disabled={uploadMutation.isPending}>{uploadMutation.isPending ? t('common.uploading') : t('common.upload')}</Button>
            </DialogFooter>
          </DialogContent>
          </form>
        </Dialog>
      </div>

        <DataTable
          searchable
          loading={isLoading}
          columns={[
            { key: 'document_title', label: t('documents.titleLabel'), sortable: true },
            { key: 'type_name_ar', label: t('documents.type'), sortable: true },
            { key: 'entity_type', label: t('documents.entity'), render: (d: any) => d.entity_type ? `${d.entity_type} #${d.entity_id}` : '—' },
            { key: 'file_name', label: t('documents.fileName'), sortable: true },
            { key: 'file_size_bytes', label: t('documents.size'), sortable: true, render: (d: any) => formatSize(d.file_size_bytes) },
            { key: 'uploaded_by_username', label: t('documents.uploadedBy'), sortable: true },
            { key: 'uploaded_at', label: t('documents.date'), sortable: true, render: (d: any) => new Date(d.uploaded_at).toLocaleDateString() },
            { key: 'actions', label: '', render: (d: any) => (
              <button onClick={() => setDeleteTarget(d.id)} className="text-red-500 hover:text-red-700">
                <Trash2 className="w-4 h-4" />
              </button>
            )},
          ]}
          data={documents || []}
          emptyMessage={t('documents.empty')}
        />

      <ConfirmDialog
        open={deleteTarget !== null}
        onOpenChange={(o) => { if (!o) setDeleteTarget(null) }}
        title={t('documents.deleteTitle')}
        description={t('documents.deleteConfirm')}
        onConfirm={() => deleteTarget && deleteMutation.mutate(deleteTarget)}
        loading={deleteMutation.isPending}
      />
    </div>
  )
}
