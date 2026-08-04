import { useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { AxiosError } from 'axios'
import { Shield, ShieldX, Search, FileText, CheckCircle2, Fingerprint, Users, History, Database, Link2 } from 'lucide-react'
import { Card, CardContent, CardHeader } from '../../components/ui/card'
import { Badge } from '../../components/ui/badge'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { verifyReference } from '../../sdk/public/verification.sdk'
import type { VerificationResult, VerificationStatus } from '../../sdk/public/verification.sdk'

const STATUS_VARIANTS: Record<VerificationStatus, 'success' | 'warning' | 'destructive' | 'secondary'> = {
  VALID: 'success',
  MODIFIED: 'warning',
  INVALID: 'destructive',
  UNKNOWN: 'secondary',
  REVOKED: 'destructive',
  SUPERSEDED: 'warning',
  EXPIRED: 'destructive',
}

function formatDate(value?: string | null): string {
  if (!value) return '—'
  const d = new Date(value)
  return isNaN(d.getTime()) ? String(value) : d.toLocaleString()
}

function KeyValue({ label, value }: { label: string; value?: string | number | null }) {
  if (value === undefined || value === null || value === '') return null
  return (
    <div className="flex justify-between gap-4 text-sm py-1">
      <span className="text-slate-500 shrink-0">{label}</span>
      <span className="text-right font-medium break-words">{value}</span>
    </div>
  )
}

function SectionCard({ title, icon, children }: { title: string; icon: React.ReactNode; children: React.ReactNode }) {
  return (
    <div className="rounded-lg border border-slate-200 bg-white p-4">
      <div className="flex items-center gap-2 mb-3">
        {icon}
        <h3 className="text-sm font-semibold text-slate-700">{title}</h3>
      </div>
      {children}
    </div>
  )
}

function StatusBadge({ status }: { status: VerificationStatus }) {
  const { t } = useTranslation()
  return (
    <Badge variant={STATUS_VARIANTS[status] ?? 'secondary'} className="text-sm px-3 py-1">
      {t(`verify.status.${status}`)}
    </Badge>
  )
}

function truncate(value: string, max = 24): string {
  return value.length > max ? `${value.slice(0, max)}…` : value
}

function IntegritySection({ integrity }: { integrity: NonNullable<VerificationResult['integrity']> }) {
  const { t } = useTranslation()
  return (
    <SectionCard title={t('verify.section.integrity')} icon={<Fingerprint className="w-4 h-4 text-slate-500" />}>
      {integrity.checksumVerified !== undefined && (
        <div className="flex items-center gap-2 text-sm text-green-700 mb-2">
          <CheckCircle2 className="w-4 h-4" />
          <span>{t('verify.integrityVerified')}</span>
        </div>
      )}
      {integrity.checksumAlgorithm && <KeyValue label={t('verify.algorithm')} value={integrity.checksumAlgorithm} />}
      {integrity.checksumValue && (
        <KeyValue label={t('verify.checksum')} value={truncate(integrity.checksumValue)} />
      )}
      {integrity.qrStatus && <KeyValue label={t('verify.qrStatus')} value={integrity.qrStatus} />}
    </SectionCard>
  )
}

function SignaturesSection({ signatures }: { signatures: NonNullable<VerificationResult['signatures']> }) {
  const { t } = useTranslation()
  return (
    <SectionCard title={t('verify.section.signatures')} icon={<Users className="w-4 h-4 text-slate-500" />}>
      <div className="flex gap-4 text-sm mb-3">
        <span className="text-slate-500">
          {t('verify.signaturesStatus')}:{' '}
          <span className="font-medium text-slate-800">{t(`verify.sigStatus.${signatures.status}`)}</span>
        </span>
        <span className="text-slate-500">
          {t('verify.requiredCount')}: <span className="font-medium text-slate-800">{signatures.requiredCount}</span>
        </span>
        <span className="text-slate-500">
          {t('verify.completedCount')}: <span className="font-medium text-slate-800">{signatures.completedCount}</span>
        </span>
      </div>
      <div className="space-y-2">
        {signatures.timeline.map((sig, idx) => (
          <div key={idx} className="flex items-center justify-between text-sm border rounded p-2">
            <div className="flex items-center gap-2">
              <span className="font-medium">{sig.signerName || sig.signerTitle || `#${idx + 1}`}</span>
              {sig.signatureType && <Badge variant="outline">{sig.signatureType}</Badge>}
              {sig.isRequired !== undefined && (
                <span className="text-xs text-slate-400">
                  {sig.isRequired ? t('verify.required') : t('verify.optional')}
                </span>
              )}
            </div>
            <div className="flex items-center gap-3">
              {sig.status && (
                <Badge variant={sig.status === 'SIGNED' ? 'success' : 'secondary'}>{sig.status}</Badge>
              )}
              {sig.signedAt && <span className="text-xs text-slate-400">{formatDate(sig.signedAt)}</span>}
            </div>
          </div>
        ))}
      </div>
    </SectionCard>
  )
}

function HistorySection({ history }: { history: NonNullable<VerificationResult['history']> }) {
  const { t } = useTranslation()
  return (
    <SectionCard title={t('verify.section.history')} icon={<History className="w-4 h-4 text-slate-500" />}>
      {history.supersededBy && (
        <div className="bg-yellow-50 border border-yellow-200 rounded p-3 text-sm text-yellow-700 mb-2">
          <p className="font-medium">
            {t('verify.supersededBy')}: <span className="font-mono">{history.supersededBy}</span>
          </p>
          <Button variant="link" className="text-xs p-0 h-auto" onClick={() => window.open(`/verify?ref=${encodeURIComponent(history.supersededBy!)}`, '_self')}>
            {t('verify.viewNewVersion')}
          </Button>
        </div>
      )}
      {history.previousVersion && (
        <KeyValue label={t('verify.previousVersion')} value={history.previousVersion} />
      )}
      {history.versions && history.versions.length > 0 && (
        <div className="text-sm mb-2">
          <span className="text-slate-500">{t('verify.versions')}:</span>
          <div className="flex flex-wrap gap-2 mt-1">
            {history.versions.map((v) => (
              <Badge key={v.versionNo} variant="outline">
                v{v.versionNo}
                {v.issuedAt ? ` · ${formatDate(v.issuedAt)}` : ''}
              </Badge>
            ))}
          </div>
        </div>
      )}
      {history.audit && history.audit.length > 0 && (
        <div className="text-sm">
          <span className="text-slate-500">{t('verify.audit')}:</span>
          <div className="mt-1 space-y-1">
            {history.audit.map((a, idx) => (
              <div key={idx} className="flex justify-between gap-2 py-1 border-b border-slate-100 last:border-0">
                <span className="font-medium">{a.actionType || a.versionNo}</span>
                <span className="text-slate-400">
                  {a.actorName}
                  {a.timestamp ? ` · ${formatDate(a.timestamp)}` : ''}
                </span>
              </div>
            ))}
          </div>
        </div>
      )}
    </SectionCard>
  )
}

function MetadataSection({ metadata }: { metadata: Record<string, unknown> }) {
  const { t } = useTranslation()
  const entries = Object.entries(metadata).filter(([, v]) => v !== undefined && v !== null && v !== '')
  if (entries.length === 0) return null
  return (
    <SectionCard title={t('verify.section.metadata')} icon={<Database className="w-4 h-4 text-slate-500" />}>
      {entries.map(([k, v]) => (
        <KeyValue
          key={k}
          label={k}
          value={typeof v === 'object' ? JSON.stringify(v) : String(v)}
        />
      ))}
    </SectionCard>
  )
}

function ResultView({ result }: { result: VerificationResult }) {
  const { t } = useTranslation()
  const { identity, lifecycle, verification, links } = result
  const primaryRef = identity.serialNumber || identity.documentNumber || result.reference

  return (
    <>
      <CardHeader className="text-center border-b pb-4">
        <div className="flex justify-center mb-3">
          {verification.status === 'VALID' ? (
            <Shield className="w-16 h-16 text-green-500" />
          ) : (
            <ShieldX className="w-16 h-16 text-red-500" />
          )}
        </div>
        <div className="flex justify-center mb-2">
          <StatusBadge status={verification.status} />
        </div>
        <p className="text-xs text-slate-400 font-mono break-all">{primaryRef}</p>
      </CardHeader>

      <CardContent className="pt-4 space-y-3">
        {(identity.title || identity.subject) && (
          <div className="text-center mb-1">
            <h2 className="text-lg font-semibold text-slate-800">{identity.title || identity.subject}</h2>
          </div>
        )}

        <SectionCard title={t('verify.section.identity')} icon={<FileText className="w-4 h-4 text-slate-500" />}>
          {identity.serialNumber && <KeyValue label={t('verify.serialNumber')} value={identity.serialNumber} />}
          {identity.documentNumber && <KeyValue label={t('verify.docNumber')} value={identity.documentNumber} />}
          {identity.type && <KeyValue label={t('verify.type')} value={identity.type} />}
          {identity.language && <KeyValue label={t('verify.language')} value={identity.language === 'ar' ? 'العربية' : identity.language} />}
          {identity.issuerName && <KeyValue label={t('verify.issuerName')} value={identity.issuerName} />}
          {identity.documentVersion !== undefined && <KeyValue label={t('verify.documentVersion')} value={identity.documentVersion} />}
          {identity.templateCode && <KeyValue label={t('verify.templateCode')} value={identity.templateCode} />}
          {identity.templateVersion !== undefined && <KeyValue label={t('verify.templateVersion')} value={identity.templateVersion} />}
          {identity.entityType && <KeyValue label={t('verify.entityType')} value={identity.entityType} />}
          {identity.entityId !== undefined && <KeyValue label={t('verify.entityId')} value={identity.entityId} />}
        </SectionCard>

        <SectionCard title={t('verify.section.lifecycle')} icon={<CheckCircle2 className="w-4 h-4 text-slate-500" />}>
          {lifecycle.status && <KeyValue label={t('verify.lifecycleStatus')} value={lifecycle.status} />}
          {lifecycle.issuedAt && <KeyValue label={t('verify.issuedAt')} value={formatDate(lifecycle.issuedAt)} />}
          {lifecycle.effectiveAt && <KeyValue label={t('verify.effectiveAt')} value={formatDate(lifecycle.effectiveAt)} />}
          {lifecycle.expiresAt && <KeyValue label={t('verify.expiresAt')} value={formatDate(lifecycle.expiresAt)} />}
          {lifecycle.revokedAt && <KeyValue label={t('verify.revokedAt')} value={formatDate(lifecycle.revokedAt)} />}
          {lifecycle.revocationReason && (
            <div className="bg-red-50 border border-red-200 rounded p-3 text-sm text-red-700 mt-1">
              <span className="font-medium">{t('verify.revocationReason')}: </span>
              {lifecycle.revocationReason}
            </div>
          )}
          {lifecycle.archivedAt && <KeyValue label={t('verify.archivedAt')} value={formatDate(lifecycle.archivedAt)} />}
        </SectionCard>

        {result.integrity && <IntegritySection integrity={result.integrity} />}
        {result.signatures && <SignaturesSection signatures={result.signatures} />}
        {result.history && <HistorySection history={result.history} />}
        {result.metadata && <MetadataSection metadata={result.metadata} />}

        {links?.supersededBy && (
          <div className="flex justify-center">
            <Button variant="link" size="sm" onClick={() => window.open(`/verify?ref=${encodeURIComponent(links.supersededBy!)}`, '_self')}>
              <Link2 className="w-4 h-4 ml-1" />
              {t('verify.viewNewVersion')}
            </Button>
          </div>
        )}

        <div className="text-center text-xs text-slate-400 pt-2 border-t">
          {t('verify.verifiedAt')}: {formatDate(verification.timestamp || result.verifiedAt)}
          {result.schemaVersion ? ` · ${t('verify.schemaVersion')} ${result.schemaVersion}` : ''}
        </div>

        <div className="flex justify-center pt-1">
          <Button variant="outline" size="sm" onClick={() => window.print()}>
            <FileText className="w-4 h-4 ml-1" />
            {t('verify.printReport')}
          </Button>
        </div>
      </CardContent>
    </>
  )
}

export default function VerifyPage() {
  const { t } = useTranslation()
  const [searchParams, setSearchParams] = useSearchParams()
  const ref = searchParams.get('ref') || searchParams.get('serial')
  const [input, setInput] = useState(ref ?? '')

  const { data, isLoading, error } = useQuery({
    queryKey: ['verify-reference', ref],
    queryFn: async () => {
      const res = await verifyReference.check(ref!)
      return res.data.data as VerificationResult
    },
    enabled: !!ref,
    retry: 1,
  })

  const submit = (e: React.FormEvent) => {
    e.preventDefault()
    const value = input.trim()
    if (value) setSearchParams({ ref: value })
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4" dir="auto">
      <div className="w-full max-w-xl">
        <div className="text-center mb-6">
          <div className="flex justify-center mb-3">
            <Shield className="w-12 h-12 text-slate-400" />
          </div>
          <h1 className="text-2xl font-bold text-slate-800 mb-1">{t('verify.portalTitle')}</h1>
          <p className="text-sm text-slate-500">{t('verify.enterReference')}</p>
        </div>

        <Card>
          {!ref && (
            <CardContent className="pt-6">
              <form onSubmit={submit} className="flex gap-2">
                <Input
                  value={input}
                  onChange={(e) => setInput(e.target.value)}
                  placeholder={t('verify.placeholder')}
                  dir="ltr"
                  className="font-mono"
                />
                <Button type="submit">
                  <Search className="w-4 h-4 ml-1" />
                  {t('verify.check')}
                </Button>
              </form>
            </CardContent>
          )}

          {ref && isLoading && (
            <CardContent className="pt-6 text-center">
              <p className="text-slate-500">{t('common.loading')}</p>
            </CardContent>
          )}

          {ref && !isLoading && data && <ResultView result={data} />}

          {ref && !isLoading && (error || !data) && (
            <CardContent className="pt-6 text-center">
              <ShieldX className="w-16 h-16 mx-auto text-red-300 mb-4" />
              <h2 className="text-xl font-bold text-red-600 mb-2">
                {(error as AxiosError)?.response?.status === 404
                  ? t('verify.notFoundTitle')
                  : t('verify.errorTitle')}
              </h2>
              <p className="text-sm text-slate-500">
                {(error as AxiosError)?.response?.status === 404
                  ? t('verify.notFoundDescription')
                  : t('verify.errorDescription')}
              </p>
              <Button variant="outline" size="sm" className="mt-4" onClick={() => { setInput(''); setSearchParams({}) }}>
                {t('verify.tryAgain')}
              </Button>
            </CardContent>
          )}
        </Card>

        {!ref && (
          <p className="text-center text-xs text-slate-400 mt-4">
            {t('verify.exampleHint')}
          </p>
        )}
      </div>
    </div>
  )
}
