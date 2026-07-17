/*
 * صفحة المستندات: رفع، تنزيل، إدارة الملفات
 * مع تصنيفها حسب الأنواع والكيانات المرتبطة.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState, useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { FileUp, Trash2, Eye, Download, AlertCircle, RefreshCw } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from '../../components/ui/dialog'
import ConfirmDialog from '../../components/ConfirmDialog'
import DocumentUpload from '../../components/DocumentUpload'
import DocumentPreview from '../../components/DocumentPreview'
import DataTable from '../../components/DataTable'
import { documents } from '../../sdk/domains/documents.sdk'
import { usePermission } from '../../hooks/usePermission'
import type { Document } from '../../sdk/core/types'

function formatSize(bytes?: number | null) {
  if (!bytes) return '—'
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

export default function DocumentsPage() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const canUpload = usePermission('document.upload')
  const canDelete = usePermission('document.delete')
  const canDownload = usePermission('document.download')

  const [openUpload, setOpenUpload] = useState(false)
  const [deleteTarget, setDeleteTarget] = useState<Document | null>(null)
  const [previewDoc, setPreviewDoc] = useState<Document | null>(null)
  const [typeFilter, setTypeFilter] = useState<string>('')

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ['documents'],
    queryFn: () => documents.list({ page: 1, limit: 1000 }).then(r => r.data),
  })

  const { data: types } = useQuery({
    queryKey: ['document-types'],
    queryFn: () => documents.getTypes().then(r => r.data.data),
  })

  const allDocs = useMemo(() => {
    const list = (data?.data || []) as Document[]
    if (!typeFilter) return list
    return list.filter((d: Document) => String(d.document_type_id) === typeFilter)
  }, [data, typeFilter])

  const deleteMutation = useMutation({
    mutationFn: (id: number) => documents.delete(id),
    onSuccess: () => {
      toast.success(t('documents.deleted'))
      queryClient.invalidateQueries({ queryKey: ['documents'] })
      setDeleteTarget(null)
    },
    onError: () => toast.error(t('documents.deleteFailed')),
  })

  const handleDownload = async (doc: Document) => {
    try {
      const res = await documents.download(doc.id)
      const blob = new Blob([res.data as BlobPart], { type: doc.mime_type })
      const url = URL.createObjectURL(blob)
      const a = window.document.createElement('a')
      a.href = url
      a.download = doc.file_name
      a.click()
      URL.revokeObjectURL(url)
    } catch { /* error handled by interceptor */ }
  }

  const columns = useMemo(() => [
    { key: 'document_title', label: t('documents.titleLabel'), sortable: true },
    { key: 'type_name_ar', label: t('documents.type'), sortable: true, filterable: true },
    { key: 'entity_type', label: t('documents.entity'), render: (d: Document) => d.entity_type ? `${d.entity_type} #${d.entity_id}` : '—' },
    { key: 'file_name', label: t('documents.fileName'), sortable: true },
    { key: 'mime_type', label: t('documents.mimeType') },
    { key: 'file_size_bytes', label: t('documents.size'), sortable: true, render: (d: Document) => formatSize(d.file_size_bytes) },
    { key: 'uploaded_by_username', label: t('documents.uploadedBy'), sortable: true },
    { key: 'uploaded_at', label: t('documents.date'), sortable: true, render: (d: Document) => new Date(d.uploaded_at).toLocaleDateString() },
    {
      key: 'actions', label: '', render: (d: Document) => (
        <div className="flex items-center gap-1">
          <button onClick={() => setPreviewDoc(d)} className="p-1 text-slate-400 hover:text-blue-600" aria-label={t('documents.preview')}>
            <Eye className="w-4 h-4" />
          </button>
          {canDownload && (
            <button onClick={() => handleDownload(d)} className="p-1 text-slate-400 hover:text-green-600" aria-label={t('documents.download')}>
              <Download className="w-4 h-4" />
            </button>
          )}
          {canDelete && (
            <button onClick={() => setDeleteTarget(d)} className="p-1 text-slate-400 hover:text-red-600" aria-label={t('common.delete')}>
              <Trash2 className="w-4 h-4" />
            </button>
          )}
        </div>
      ),
    },
  ], [t, canDownload, canDelete])

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('documents.title')}</h1>
        {canUpload && (
          <Dialog open={openUpload} onOpenChange={setOpenUpload}>
            <DialogTrigger asChild>
              <Button><FileUp className="w-4 h-4 mr-1" /> {t('documents.upload')}</Button>
            </DialogTrigger>
            <DialogContent>
              <DialogHeader><DialogTitle>{t('documents.uploadTitle')}</DialogTitle></DialogHeader>
              <DocumentUpload onUploaded={() => setOpenUpload(false)} />
            </DialogContent>
          </Dialog>
        )}
      </div>

      <div className="flex items-center gap-3 mb-4">
        <select
          value={typeFilter}
          onChange={(e) => setTypeFilter(e.target.value)}
          className="p-2 border rounded text-sm"
          aria-label={t('documents.type')}
        >
          <option value="">{t('documents.allTypes')}</option>
          {(types || []).map((tp: any) => (
            <option key={tp.id} value={String(tp.id)}>{tp.type_name_ar}</option>
          ))}
        </select>
      </div>

      {isError && (
        <div className="flex flex-col items-center justify-center p-12 text-center">
          <AlertCircle className="w-10 h-10 text-red-400 mb-3" />
          <p className="text-sm text-slate-600 mb-3">{t('documents.error')}</p>
          <Button variant="outline" size="sm" onClick={() => refetch()}>
            <RefreshCw className="w-3 h-3 mr-1" /> {t('documents.retry')}
          </Button>
        </div>
      )}

      {!isError && (
        <DataTable
          searchable
          loading={isLoading}
          columns={columns}
          data={allDocs}
          emptyMessage={t('documents.empty')}
        />
      )}

      <ConfirmDialog
        open={deleteTarget !== null}
        onOpenChange={(o) => { if (!o) setDeleteTarget(null) }}
        title={t('documents.deleteTitle')}
        description={t('documents.deleteConfirm')}
        onConfirm={() => deleteTarget && deleteMutation.mutate(deleteTarget.id)}
        loading={deleteMutation.isPending}
      />

      <DocumentPreview document={previewDoc} open={previewDoc !== null} onOpenChange={(o) => { if (!o) setPreviewDoc(null) }} />
    </div>
  )
}
