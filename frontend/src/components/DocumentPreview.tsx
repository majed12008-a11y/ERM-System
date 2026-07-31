/*
 * مكون معاينة المستندات: عرض PDF والصور مباشرة
 * في نافذة منبثقة مع دعم RTL و التنقل بلوحة المفاتيح.
 */
import { useState, useEffect, useCallback } from 'react'
import { useTranslation } from 'react-i18next'
import { Download, FileText, AlertCircle } from 'lucide-react'
import { Dialog, DialogContent, DialogHeader, DialogTitle } from './ui/dialog'
import { Button } from './ui/button'
import { documents } from '../sdk/domains/documents.sdk'
import { usePermission } from '../hooks/usePermission'
import type { Document } from '../sdk/core/types'

const PREVIEWABLE_TYPES = ['application/pdf', 'image/jpeg', 'image/png', 'image/tiff']

interface DocumentPreviewProps {
  document: Document | null
  open: boolean
  onOpenChange: (open: boolean) => void
}

export default function DocumentPreview({ document: doc, open, onOpenChange }: DocumentPreviewProps) {
  const { t } = useTranslation()
  const canDownload = usePermission('document.download')
  const [previewUrl, setPreviewUrl] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(false)

  const canPreview = doc ? PREVIEWABLE_TYPES.includes(doc.mime_type) : false

  useEffect(() => {
    if (!open || !doc) { setPreviewUrl(null); setError(null); return }
    if (!canPreview) return

    let cancelled = false
    setLoading(true)
    setError(null)

    documents.preview(doc.id).then(res => {
      if (cancelled) return
      const blob = new Blob([res.data as BlobPart], { type: doc.mime_type })
      const url = URL.createObjectURL(blob)
      setPreviewUrl(url)
      setLoading(false)
    }).catch(() => {
      if (cancelled) return
      setError(t('documents.previewNotSupported'))
      setLoading(false)
    })

    return () => { cancelled = true }
  }, [open, doc, canPreview, t])

  useEffect(() => {
    return () => { if (previewUrl) URL.revokeObjectURL(previewUrl) }
  }, [previewUrl])

  const handleDownload = useCallback(async () => {
    if (!doc) return
    try {
      const res = await documents.download(doc.id)
      const blob = new Blob([res.data as BlobPart], { type: doc.mime_type })
      const url = URL.createObjectURL(blob)
      const a = document.createElement('a')
      a.href = url
      a.download = doc.file_name
      a.click()
      URL.revokeObjectURL(url)
    } catch { /* handled by query client */ }
  }, [doc])

  if (!doc) return null

  return (
    <Dialog open={open} onOpenChange={onOpenChange}>
      <DialogContent className="max-w-4xl max-h-[90vh] p-0 overflow-hidden">
        <DialogHeader className="p-4 border-b">
          <DialogTitle className="flex items-center gap-2 text-sm">
            <FileText className="w-4 h-4" />
            <span className="truncate">{doc.document_title}</span>
          </DialogTitle>
          <div className="flex items-center gap-2 mt-1">
            {canDownload && (
              <Button size="sm" variant="outline" onClick={handleDownload}>
                <Download className="w-3 h-3 mr-1" />
                {t('documents.download')}
              </Button>
            )}
          </div>
        </DialogHeader>

        <div className="flex-1 overflow-auto" style={{ minHeight: '400px', maxHeight: '70vh' }}>
          {loading && (
            <div className="flex items-center justify-center h-64 text-slate-400">
              <span className="text-sm">{t('documents.loading')}</span>
            </div>
          )}

          {error && (
            <div className="flex flex-col items-center justify-center h-64 text-slate-400">
              <AlertCircle className="w-8 h-8 mb-2" />
              <p className="text-sm">{error}</p>
            </div>
          )}

          {!loading && !error && !canPreview && (
            <div className="flex flex-col items-center justify-center h-64 text-slate-400">
              <FileText className="w-12 h-12 mb-3 opacity-30" />
              <p className="text-sm">{t('documents.previewNotSupported')}</p>
            </div>
          )}

          {!loading && !error && canPreview && previewUrl && doc.mime_type === 'application/pdf' && (
            <iframe src={previewUrl} className="w-full h-full border-0" style={{ minHeight: '600px' }} title={doc.document_title} />
          )}

          {!loading && !error && canPreview && previewUrl && doc.mime_type !== 'application/pdf' && (
            <img src={previewUrl} alt={doc.document_title} className="max-w-full mx-auto p-4" style={{ maxHeight: '65vh', objectFit: 'contain' }} />
          )}
        </div>
      </DialogContent>
    </Dialog>
  )
}
