/*
 * مكون رفع المستندات المشترك: سحب وإفلت، تقدم،
 * تحقق، إعادة محاولة، ودعم اللغتين العربية والإنجليزية.
 */
import { useCallback, useRef, useState } from 'react'
import { useTranslation } from 'react-i18next'
import { useMutation, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import { Upload, X, FileText, CheckCircle } from 'lucide-react'
import { Button } from './ui/button'
import { documents } from '../sdk/domains/documents.sdk'
import { usePermission } from '../hooks/usePermission'
import { cn } from '../lib/utils'

const ALLOWED_MIME = [
  'application/pdf', 'image/jpeg', 'image/png', 'image/tiff',
  'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
  'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  'text/plain',
]
const MAX_SIZE = 10 * 1024 * 1024

interface PendingFile {
  file: File
  status: 'pending' | 'uploading' | 'done' | 'error'
  progress: number
  error?: string
  docId?: number
}

interface DocumentUploadProps {
  entityType?: string
  entityId?: number
  documentTypeId?: number
  onUploaded?: () => void
}

export default function DocumentUpload({ entityType, entityId, documentTypeId, onUploaded }: DocumentUploadProps) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const canUpload = usePermission('document.upload')
  const inputRef = useRef<HTMLInputElement>(null)
  const [dragOver, setDragOver] = useState(false)
  const [pending, setPending] = useState<PendingFile[]>([])

  const uploadMutation = useMutation({
    mutationFn: async (pf: PendingFile) => {
      const fd = new FormData()
      fd.append('file', pf.file)
      if (documentTypeId) fd.append('document_type_id', String(documentTypeId))
      if (entityType) fd.append('entity_type', entityType)
      if (entityId) fd.append('entity_id', String(entityId))
      fd.append('document_title', pf.file.name)
      return documents.upload(fd)
    },
    onSuccess: (_res, pf) => {
      setPending(prev => prev.map(p => p.file === pf.file ? { ...p, status: 'done' as const, progress: 100 } : p))
      toast.success(t('documents.uploadSuccess'))
      queryClient.invalidateQueries({ queryKey: ['documents'] })
      onUploaded?.()
    },
    onError: (err: Error, pf) => {
      setPending(prev => prev.map(p => p.file === pf.file ? { ...p, status: 'error' as const, error: err.message } : p))
      toast.error(t('documents.uploadError'))
    },
  })

  const validate = useCallback((f: File): string | null => {
    if (!ALLOWED_MIME.includes(f.type)) return t('documents.allowedTypes')
    if (f.size > MAX_SIZE) return t('documents.maxSize')
    return null
  }, [t])

  const addFiles = useCallback((files: FileList | File[]) => {
    const arr = Array.from(files)
    const valid: PendingFile[] = []
    for (const f of arr) {
      const err = validate(f)
      if (err) { toast.error(`${f.name}: ${err}`); continue }
      if (pending.some(p => p.file.name === f.name && p.file.size === f.size)) continue
      valid.push({ file: f, status: 'pending', progress: 0 })
    }
    if (valid.length === 0) return
    setPending(prev => [...prev, ...valid])
  }, [validate, pending])

  const removePending = useCallback((file: File) => {
    setPending(prev => prev.filter(p => p.file !== file))
  }, [])

  const uploadAll = useCallback(() => {
    pending.filter(p => p.status === 'pending' || p.status === 'error').forEach(pf => {
      setPending(prev => prev.map(p => p.file === pf.file ? { ...p, status: 'uploading' as const, progress: 50 } : p))
      uploadMutation.mutate(pf)
    })
  }, [pending, uploadMutation])

  const retryFile = useCallback((pf: PendingFile) => {
    setPending(prev => prev.map(p => p.file === pf.file ? { ...p, status: 'uploading' as const, progress: 50, error: undefined } : p))
    uploadMutation.mutate(pf)
  }, [uploadMutation])

  const onDrop = useCallback((e: React.DragEvent) => {
    e.preventDefault()
    setDragOver(false)
    if (e.dataTransfer.files.length > 0) addFiles(e.dataTransfer.files)
  }, [addFiles])

  const onDragOver = useCallback((e: React.DragEvent) => { e.preventDefault(); setDragOver(true) }, [])
  const onDragLeave = useCallback(() => setDragOver(false), [])

  if (!canUpload) return null

  const hasPending = pending.some(p => p.status === 'pending' || p.status === 'error')
  const allDone = pending.length > 0 && pending.every(p => p.status === 'done')

  return (
    <div className="space-y-3">
      <div
        onDrop={onDrop}
        onDragOver={onDragOver}
        onDragLeave={onDragLeave}
        onClick={() => inputRef.current?.click()}
        onKeyDown={(e) => { if (e.key === 'Enter' || e.key === ' ') inputRef.current?.click() }}
        role="button"
        tabIndex={0}
        aria-label={t('documents.dragDrop')}
        className={cn(
          'border-2 border-dashed rounded-lg p-6 text-center cursor-pointer transition-colors',
          dragOver ? 'border-blue-500 bg-blue-50 dark:bg-blue-950' : 'border-slate-300 dark:border-slate-600 hover:border-slate-400',
        )}
      >
        <Upload className="w-8 h-8 mx-auto mb-2 text-slate-400" />
        <p className="text-sm text-slate-600 dark:text-slate-400">{t('documents.dragDrop')}</p>
        <p className="text-xs text-slate-400 mt-1">{t('documents.allowedTypes')}</p>
        <p className="text-xs text-slate-400">{t('documents.maxSize')}</p>
        <input
          ref={inputRef}
          type="file"
          multiple
          accept={ALLOWED_MIME.join(',')}
          onChange={(e) => { if (e.target.files) addFiles(e.target.files); e.target.value = '' }}
          className="hidden"
        />
      </div>

      {pending.length > 0 && (
        <div className="space-y-2">
          {pending.map((pf, i) => (
            <div key={`${pf.file.name}-${i}`} className="flex items-center gap-2 p-2 bg-slate-50 dark:bg-slate-800 rounded text-sm">
              <FileText className="w-4 h-4 text-slate-400 shrink-0" />
              <span className="truncate flex-1">{pf.file.name}</span>
              <span className="text-xs text-slate-400 shrink-0">{(pf.file.size / 1024).toFixed(0)} KB</span>
              {pf.status === 'done' && <CheckCircle className="w-4 h-4 text-green-500 shrink-0" />}
              {pf.status === 'error' && (
                <button onClick={() => retryFile(pf)} className="text-xs text-blue-600 hover:underline shrink-0" aria-label={t('documents.retry')}>
                  {t('documents.retry')}
                </button>
              )}
              {pf.status === 'uploading' && <span className="text-xs text-blue-500 shrink-0">{t('documents.uploading')}</span>}
              <button onClick={() => removePending(pf.file)} className="text-slate-400 hover:text-red-500 shrink-0" aria-label={t('documents.removeFile')}>
                <X className="w-3 h-3" />
              </button>
            </div>
          ))}
          <div className="flex gap-2">
            <Button size="sm" onClick={uploadAll} disabled={!hasPending || uploadMutation.isPending}>
              {uploadMutation.isPending ? t('documents.uploading') : t('documents.upload')}
            </Button>
            <Button size="sm" variant="outline" onClick={() => setPending([])}>
              {t('common.cancel')}
            </Button>
          </div>
        </div>
      )}

      {allDone && (
        <div className="flex items-center gap-2 text-green-600 text-sm">
          <CheckCircle className="w-4 h-4" />
          <span>{t('documents.uploadSuccess')}</span>
        </div>
      )}
    </div>
  )
}
