/*
 * لوحة المستندات الرسمية في صفحة تعبئة النموذج:
 *   - سحب قائمة المستندات المولدة للمثيل (بدون إعادة تحميل الصفحة).
 *   - تنزيل PDF لكل مستند.
 *   - تفاصيل: الإصدارات، التوقيعات، سجل التدقيق، دورة الحياة.
 *   - توقيع المستند وإبطال/إلغاء (revoke/void) من المشرف.
 */
import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import {
  FileText, Download, Loader2, History, ScrollText, BadgeCheck,
  RefreshCw, ChevronDown,
} from 'lucide-react'
import {
  listGeneratedDocuments, getGeneratedDocumentDetail, downloadFormDocument,
  signGeneratedDocument, setDocumentLifecycle,
} from '../../api/forms'
import type { GeneratedDocumentRecord, DocumentDetail } from '../../components/forms/types'
import { Card, CardContent } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Badge } from '../../components/ui/badge'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle,
  DialogDescription, DialogFooter,
} from '../../components/ui/dialog'
import { Textarea } from '../../components/ui/textarea'
import {
  Select, SelectTrigger, SelectValue, SelectContent, SelectItem,
} from '../../components/ui/select'
import { AxiosError } from 'axios'

const DOC_STATUS_VARIANTS: Record<string, 'default' | 'success' | 'destructive' | 'warning' | 'secondary'> = {
  OFFICIAL: 'success',
  REVOKED: 'destructive',
  VOID: 'destructive',
  SUPERSEDED: 'warning',
}

function DetailRow({ label, value, mono }: { label: string; value: React.ReactNode; mono?: boolean }) {
  return (
    <div className="grid grid-cols-2 gap-2 text-sm">
      <span className="text-slate-500">{label}</span>
      <span className={mono ? 'font-mono text-right break-all' : 'text-right font-medium'}>{value}</span>
    </div>
  )
}

function LifecycleDialog({ doc, onClose }: { doc: GeneratedDocumentRecord; onClose: () => void }) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [status, setStatus] = useState<'REVOKED' | 'VOID'>('REVOKED')
  const [reason, setReason] = useState('')

  const mutation = useMutation({
    mutationFn: () => setDocumentLifecycle(doc.id, status, reason),
    onSuccess: () => {
      toast.success(t('formFill.documentStatusChanged'))
      queryClient.invalidateQueries({ queryKey: ['form-documents', Number(doc.entity_id)] })
      queryClient.invalidateQueries({ queryKey: ['form-document-detail', doc.id] })
      onClose()
    },
    onError: (err: AxiosError<{ error?: string }>) =>
      toast.error(err.response?.data?.error || t('formFill.documentStatusFailed')),
  })

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-md">
        <DialogHeader>
          <DialogTitle>{t('formFill.changeDocumentStatus')}</DialogTitle>
          <DialogDescription>{doc.document_number} — {doc.document_title}</DialogDescription>
        </DialogHeader>
        <div className="space-y-4">
          <div>
            <label className="text-sm font-medium text-slate-700">{t('formFill.lifecycleStatus')}</label>
            <Select value={status} onValueChange={(v) => setStatus(v as 'REVOKED' | 'VOID')}>
              <SelectTrigger className="mt-1">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="REVOKED">{t('formFill.statusRevoked')}</SelectItem>
                <SelectItem value="VOID">{t('formFill.statusVoid')}</SelectItem>
              </SelectContent>
            </Select>
          </div>
          <div>
            <label className="text-sm font-medium text-slate-700">{t('formFill.revocationReason')}</label>
            <Textarea
              className="mt-1"
              value={reason}
              onChange={(e) => setReason(e.target.value)}
              placeholder={t('formFill.revocationReasonPlaceholder')}
              rows={3}
            />
          </div>
        </div>
        <DialogFooter>
          <Button variant="outline" onClick={onClose}>{t('common.cancel')}</Button>
          <Button
            variant="destructive"
            disabled={!reason.trim() || mutation.isPending}
            onClick={() => mutation.mutate()}
          >
            {mutation.isPending && <Loader2 className="w-3.5 h-3.5 me-1 animate-spin" />}
            {t('common.confirm')}
          </Button>
        </DialogFooter>
      </DialogContent>
    </Dialog>
  )
}

function DocumentDetailDialog({ doc, onClose }: { doc: GeneratedDocumentRecord; onClose: () => void }) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [showLifecycle, setShowLifecycle] = useState(false)

  const { data, isLoading } = useQuery({
    queryKey: ['form-document-detail', doc.id],
    queryFn: () => getGeneratedDocumentDetail(doc.id),
  })

  const signMutation = useMutation({
    mutationFn: () => signGeneratedDocument(doc.id, 'APPROVER'),
    onSuccess: () => {
      toast.success(t('formFill.documentSigned'))
      queryClient.invalidateQueries({ queryKey: ['form-document-detail', doc.id] })
      queryClient.invalidateQueries({ queryKey: ['form-documents', Number(doc.entity_id)] })
    },
    onError: (err: AxiosError<{ error?: string }>) =>
      toast.error(err.response?.data?.error || t('formFill.signFailed')),
  })

  const detail = data as DocumentDetail | undefined
  const canManageLifecycle = doc.status === 'OFFICIAL'

  return (
    <Dialog open onOpenChange={onClose}>
      <DialogContent className="max-w-2xl max-h-[85vh] overflow-y-auto">
        <DialogHeader>
          <DialogTitle className="flex items-center gap-2">
            <FileText className="w-4 h-4 text-blue-600" />
            {doc.document_number}
            <Badge variant={DOC_STATUS_VARIANTS[doc.status] || 'default'}>
              {t(`formFill.docStatus.${doc.status}`)}
            </Badge>
          </DialogTitle>
          <DialogDescription>{doc.document_title}</DialogDescription>
        </DialogHeader>

        <div className="space-y-5">
          <div className="space-y-2 rounded-md border p-4">
            <h3 className="text-sm font-semibold text-slate-700 flex items-center gap-1.5">
              <FileText className="w-3.5 h-3.5" /> {t('formFill.documentMeta')}
            </h3>
            <DetailRow label={t('formFill.docLanguage')} value={doc.language === 'ar' ? 'العربية' : 'English'} />
            <DetailRow label={t('formFill.docVersion')} value={doc.current_version_no} />
            <DetailRow label={t('formFill.docTemplate')} value={`${doc.template_code} (v${doc.template_version})`} mono />
            <DetailRow label={t('formFill.docUuid')} value={doc.document_uuid} mono />
            <DetailRow label={t('formFill.docFingerprint')} value={doc.checksum_sha256} mono />
            {doc.superseded_by_document_id && (
              <DetailRow label={t('formFill.docSupersededBy')} value={doc.superseded_by_document_id} />
            )}
            {doc.revocation_reason && (
              <DetailRow label={t('formFill.revocationReason')} value={doc.revocation_reason} />
            )}
          </div>

          {isLoading && <p className="text-sm text-slate-400">{t('common.loading')}</p>}

          {detail && (
            <>
              <div className="space-y-2 rounded-md border p-4">
                <h3 className="text-sm font-semibold text-slate-700 flex items-center gap-1.5">
                  <History className="w-3.5 h-3.5" /> {t('formFill.versions')}
                </h3>
                {detail.versions.length === 0 ? (
                  <p className="text-xs text-slate-400">{t('formFill.noVersions')}</p>
                ) : (
                  detail.versions.map((v) => (
                    <div key={v.id} className="flex items-center justify-between text-sm">
                      <div>
                        <span className="font-medium">v{v.version_no}</span>
                        <span className="text-xs text-slate-400 ms-2">{v.file_name}</span>
                      </div>
                      <Button
                        size="sm"
                        variant="ghost"
                        onClick={() => downloadFormDocument(doc.id, v.file_name)}
                      >
                        <Download className="w-3 h-3 ms-1" />
                      </Button>
                    </div>
                  ))
                )}
              </div>

              <div className="space-y-2 rounded-md border p-4">
                <h3 className="text-sm font-semibold text-slate-700 flex items-center gap-1.5">
                  <BadgeCheck className="w-3.5 h-3.5" /> {t('formFill.signatures')}
                </h3>
                {detail.signatures.length === 0 ? (
                  <p className="text-xs text-slate-400">{t('formFill.noSignatures')}</p>
                ) : (
                  detail.signatures.map((s) => (
                    <div key={s.id} className="flex items-center justify-between text-sm">
                      <span>{s.signer_name || `#${s.signer_id}`} <span className="text-xs text-slate-400">({s.signature_type})</span></span>
                      <span className="text-xs text-slate-400">{new Date(s.signed_at).toLocaleString()}</span>
                    </div>
                  ))
                )}
              </div>

              <div className="space-y-2 rounded-md border p-4">
                <h3 className="text-sm font-semibold text-slate-700 flex items-center gap-1.5">
                  <ScrollText className="w-3.5 h-3.5" /> {t('formFill.auditTrail')}
                </h3>
                {detail.audit.length === 0 ? (
                  <p className="text-xs text-slate-400">{t('formFill.noAudit')}</p>
                ) : (
                  <ul className="space-y-1.5">
                    {detail.audit.map((a) => (
                      <li key={a.id} className="text-xs">
                        <span className="font-mono font-medium text-blue-700">{a.action_type}</span>
                        <span className="text-slate-400 ms-2">{a.actor_name || `#${a.action_by}`}</span>
                        <span className="text-slate-400 ms-2">{new Date(a.action_timestamp).toLocaleString()}</span>
                      </li>
                    ))}
                  </ul>
                )}
              </div>
            </>
          )}
        </div>

        <DialogFooter className="flex-wrap gap-2">
          <Button variant="outline" size="sm" onClick={() => downloadFormDocument(doc.id, doc.file_name)}>
            <Download className="w-3.5 h-3.5 ms-1" /> {t('common.download')}
          </Button>
          {doc.status === 'OFFICIAL' && (
            <>
              <Button variant="outline" size="sm" disabled={signMutation.isPending} onClick={() => signMutation.mutate()}>
                {signMutation.isPending ? <Loader2 className="w-3.5 h-3.5 me-1 animate-spin" /> : <BadgeCheck className="w-3.5 h-3.5 me-1" />}
                {t('formFill.signDocument')}
              </Button>
              <Button variant="destructive" size="sm" onClick={() => setShowLifecycle(true)}>
                {t('formFill.manageLifecycle')}
              </Button>
            </>
          )}
        </DialogFooter>
      </DialogContent>
      {showLifecycle && canManageLifecycle && (
        <LifecycleDialog doc={doc} onClose={() => setShowLifecycle(false)} />
      )}
    </Dialog>
  )
}

export default function DocumentPanel({ instanceId, canGenerate, onGenerate }: {
  instanceId: number
  canGenerate: boolean
  onGenerate: (language: string) => void
}) {
  const { t } = useTranslation()
  const [selected, setSelected] = useState<GeneratedDocumentRecord | null>(null)
  const [generatePending, setGeneratePending] = useState<string | null>(null)

  const { data, isLoading } = useQuery({
    queryKey: ['form-documents', instanceId],
    queryFn: () => listGeneratedDocuments(instanceId),
  })

  const docs = data || []

  return (
    <Card>
      <CardContent className="p-5 space-y-4">
        <div className="flex items-center justify-between flex-wrap gap-3">
          <h2 className="text-base font-semibold text-slate-800">{t('formFill.officialDocuments')}</h2>
          {canGenerate && (
            <div className="flex items-center gap-2">
              {(['ar', 'en'] as const).map((lang) => (
                <Button
                  key={lang}
                  size="sm"
                  variant="outline"
                  disabled={generatePending !== null}
                  onClick={() => {
                    setGeneratePending(lang)
                    onGenerate(lang)
                  }}
                >
                  {generatePending === lang ? (
                    <Loader2 className="w-3.5 h-3.5 me-1 animate-spin" />
                  ) : (
                    <RefreshCw className="w-3.5 h-3.5 me-1" />
                  )}
                  {lang === 'ar' ? t('formFill.generateAr') : t('formFill.generateEn')}
                </Button>
              ))}
            </div>
          )}
        </div>

        {isLoading ? (
          <p className="text-sm text-slate-400">{t('common.loading')}</p>
        ) : docs.length === 0 ? (
          <p className="text-sm text-slate-400">{t('formFill.noDocuments')}</p>
        ) : (
          <div className="space-y-2">
            {docs.map((doc) => (
              <div key={doc.id} className="flex items-center justify-between rounded-md border p-3 text-sm">
                <div className="flex items-center gap-3 min-w-0">
                  <FileText className="w-4 h-4 text-slate-400 shrink-0" />
                  <div className="min-w-0">
                    <p className="font-medium truncate">{doc.document_number}</p>
                    <p className="text-xs text-slate-400 truncate">
                      {doc.file_name} • {doc.language} • v{doc.current_version_no}
                    </p>
                  </div>
                </div>
                <div className="flex items-center gap-2 shrink-0">
                  <Badge variant={DOC_STATUS_VARIANTS[doc.status] || 'default'}>
                    {t(`formFill.docStatus.${doc.status}`)}
                  </Badge>
                  <Button size="sm" variant="ghost" onClick={() => setSelected(doc)}>
                    <ChevronDown className="w-3.5 h-3.5 ms-1" /> {t('formFill.details')}
                  </Button>
                </div>
              </div>
            ))}
          </div>
        )}
      </CardContent>

      {selected && (
        <DocumentDetailDialog doc={selected} onClose={() => setSelected(null)} />
      )}
    </Card>
  )
}
