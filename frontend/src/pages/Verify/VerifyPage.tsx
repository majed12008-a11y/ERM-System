import { useSearchParams } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { verify } from '../../sdk/public/verify.sdk'
import type { CertificateVerificationData } from '../../sdk/public/verify.sdk'
import { verifyDocument } from '../../sdk/public/document-verify.sdk'
import type { DocumentVerificationData } from '../../sdk/public/document-verify.sdk'
import { Card, CardContent, CardHeader } from '../../components/ui/card'
import { Badge } from '../../components/ui/badge'
import { Button } from '../../components/ui/button'
import { Shield, ShieldX, FileText, Search, FileCheck2 } from 'lucide-react'
import { AxiosError } from 'axios'

function formatDate(value: string | null | undefined): string {
  if (!value) return '—'
  return new Date(value).toLocaleDateString()
}

function CertificateResult({ data, onPrint }: { data: CertificateVerificationData; onPrint: () => void }) {
  const { t } = useTranslation()
  const isValid = data.status === 'ISSUED'
  const isRevoked = data.status === 'REVOKED'
  const isSuperseded = data.status === 'SUPERSEDED'

  return (
    <>
      <CardHeader className="text-center border-b pb-4">
        <div className="flex justify-center mb-3">
          {isValid ? <Shield className="w-16 h-16 text-green-500" /> : <ShieldX className="w-16 h-16 text-red-500" />}
        </div>
        <Badge variant={isValid ? 'success' : 'destructive'} className="text-sm px-3 py-1">
          {isRevoked ? t('verify.revoked') : isSuperseded ? t('verify.superseded') : t('verify.valid')}
        </Badge>
      </CardHeader>

      <CardContent className="pt-4 space-y-3">
        <div className="grid grid-cols-2 gap-2 text-sm">
          <span className="text-slate-500">{t('verify.serialNumber')}</span>
          <span className="font-mono text-right">{data.serialNumber}</span>
          <span className="text-slate-500">{t('verify.applicationNumber')}</span>
          <span className="text-right font-medium">{data.applicationNumber}</span>
          <span className="text-slate-500">{t('verify.researcherName')}</span>
          <span className="text-right font-medium">{data.researcherName}</span>
          <span className="text-slate-500">{t('verify.projectTitle')}</span>
          <span className="text-right font-medium">{data.projectTitle}</span>
          <span className="text-slate-500">{t('verify.committeeName')}</span>
          <span className="text-right">{data.committeeName}</span>
          <span className="text-slate-500">{t('verify.issuingAuthority')}</span>
          <span className="text-right">{data.issuingAuthority}</span>
          <span className="text-slate-500">{t('verify.institution')}</span>
          <span className="text-right">{data.institutionName}</span>
          <span className="text-slate-500">{t('verify.issuedAt')}</span>
          <span className="text-right">{formatDate(data.issuedAt)}</span>
        </div>

        {isRevoked && data.revokedAt && (
          <div className="bg-red-50 border border-red-200 rounded p-3 text-sm text-red-700">
            <p className="font-medium">{t('verify.revokedAt')}: {formatDate(data.revokedAt)}</p>
            {data.revocationReason && <p className="mt-1">{t('verify.revocationReason')}: {data.revocationReason}</p>}
          </div>
        )}

        {isSuperseded && data.supersededBySerial && (
          <div className="bg-yellow-50 border border-yellow-200 rounded p-3 text-sm text-yellow-700">
            <p>{t('verify.supersededBy')}: {data.supersededBySerial}</p>
            <Button variant="link" className="text-xs p-0 h-auto" onClick={() => window.open(`/verify?serial=${data.supersededBySerial}`, '_self')}>
              {t('verify.viewNewVersion')}
            </Button>
          </div>
        )}

        <div className="text-center text-xs text-slate-400 pt-2 border-t">
          {t('verify.verifiedAt')}: {new Date().toLocaleString()}
        </div>

        <div className="flex justify-center pt-2">
          <Button variant="outline" size="sm" onClick={onPrint}>
            <FileText className="w-4 h-4 ml-1" />
            {t('verify.printReport')}
          </Button>
        </div>
      </CardContent>
    </>
  )
}

function DocumentResult({ data, onPrint }: { data: DocumentVerificationData; onPrint: () => void }) {
  const { t } = useTranslation()
  const isOfficial = data.status === 'OFFICIAL'
  const isRevoked = data.status === 'REVOKED'
  const isVoid = data.status === 'VOID'
  const isSuperseded = data.status === 'SUPERSEDED'
  const invalid = isRevoked || isVoid

  return (
    <>
      <CardHeader className="text-center border-b pb-4">
        <div className="flex justify-center mb-3">
          {isOfficial ? <FileCheck2 className="w-16 h-16 text-green-500" /> : <ShieldX className="w-16 h-16 text-red-500" />}
        </div>
        <Badge variant={isOfficial ? 'success' : 'destructive'} className="text-sm px-3 py-1">
          {isSuperseded ? t('verify.docSuperseded') : invalid ? t('verify.docRevoked') : t('verify.docOfficial')}
        </Badge>
      </CardHeader>

      <CardContent className="pt-4 space-y-3">
        <div className="grid grid-cols-2 gap-2 text-sm">
          <span className="text-slate-500">{t('verify.docNumber')}</span>
          <span className="font-mono text-right">{data.document_number}</span>
          <span className="text-slate-500">{t('verify.docTitle')}</span>
          <span className="text-right font-medium">{data.document_title}</span>
          <span className="text-slate-500">{t('verify.docType')}</span>
          <span className="text-right">{data.document_type}</span>
          <span className="text-slate-500">{t('verify.docLanguage')}</span>
          <span className="text-right">{data.language === 'ar' ? 'العربية' : 'English'}</span>
          <span className="text-slate-500">{t('verify.docVersion')}</span>
          <span className="text-right">{data.version_no}</span>
          <span className="text-slate-500">{t('verify.docIssuedBy')}</span>
          <span className="text-right">{data.issued_by_name}</span>
          <span className="text-slate-500">{t('verify.docTemplateVersion')}</span>
          <span className="text-right">{data.template_version}</span>
          <span className="text-slate-500">{t('verify.issuedAt')}</span>
          <span className="text-right">{formatDate(data.issued_at)}</span>
        </div>

        {data.checksum_sha256 && (
          <div className="bg-slate-50 border border-slate-200 rounded p-3 text-xs">
            <span className="text-slate-500">{t('verify.docFingerprint')}: </span>
            <span className="font-mono break-all">{data.checksum_sha256}</span>
          </div>
        )}

        {(isRevoked || isVoid) && (
          <div className="bg-red-50 border border-red-200 rounded p-3 text-sm text-red-700">
            {data.revoked_at && (
              <p className="font-medium">{t('verify.revokedAt')}: {formatDate(data.revoked_at)}</p>
            )}
            {data.revocation_reason && <p className="mt-1">{t('verify.revocationReason')}: {data.revocation_reason}</p>}
          </div>
        )}

        {isSuperseded && data.superseded_by_number && (
          <div className="bg-yellow-50 border border-yellow-200 rounded p-3 text-sm text-yellow-700">
            <p>{t('verify.docSupersededBy')}: {data.superseded_by_number}</p>
            <Button variant="link" className="text-xs p-0 h-auto" onClick={() => window.open(`/verify?ref=${data.superseded_by_number}`, '_self')}>
              {t('verify.viewNewVersion')}
            </Button>
          </div>
        )}

        <div className="text-center text-xs text-slate-400 pt-2 border-t">
          {t('verify.verifiedAt')}: {new Date().toLocaleString()}
        </div>

        <div className="flex justify-center pt-2">
          <Button variant="outline" size="sm" onClick={onPrint}>
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
  const [searchParams] = useSearchParams()
  const serial = searchParams.get('serial')
  const ref = searchParams.get('ref')
  const isDocument = Boolean(ref && !serial)

  const { data, isLoading, error } = useQuery({
    queryKey: isDocument ? ['document-verify', ref] : ['certificate-verify', serial],
    queryFn: async () => {
      if (isDocument) {
        const res = await verifyDocument.check(ref!)
        return { document: res.data.data as DocumentVerificationData }
      }
      const res = await verify.check(serial!)
      return { certificate: res.data.data as CertificateVerificationData }
    },
    enabled: !!serial || !!ref,
    retry: 1,
  })

  if (!serial && !ref) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4" dir="auto">
        <Card className="w-full max-w-md">
          <CardContent className="pt-6 text-center">
            <Search className="w-12 h-12 mx-auto text-slate-300 mb-4" />
            <p className="text-slate-500">{t('verify.enterSerial')}</p>
          </CardContent>
        </Card>
      </div>
    )
  }

  if (isLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4" dir="auto">
        <Card className="w-full max-w-md">
          <CardContent className="pt-6 text-center">
            <p className="text-slate-500">{t('common.loading')}</p>
          </CardContent>
        </Card>
      </div>
    )
  }

  const notFound = error && (error as AxiosError)?.response?.status === 404

  if (notFound || !data) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4" dir="auto">
        <Card className="w-full max-w-md">
          <CardContent className="pt-6 text-center">
            <ShieldX className="w-16 h-16 mx-auto text-red-300 mb-4" />
            <h1 className="text-xl font-bold text-red-600 mb-2">{t('verify.notFound')}</h1>
            <p className="text-sm text-slate-500">{t('verify.notFoundDescription')}</p>
          </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4" dir="auto">
      <Card className="w-full max-w-lg">
        {isDocument && data.document ? (
          <DocumentResult data={data.document} onPrint={() => window.print()} />
        ) : data.certificate ? (
          <CertificateResult data={data.certificate} onPrint={() => window.print()} />
        ) : null}
      </Card>
    </div>
  )
}
