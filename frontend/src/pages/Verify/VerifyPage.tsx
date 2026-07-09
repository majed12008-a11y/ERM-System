import { useSearchParams } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { verify } from '../../sdk/public/verify.sdk'
import type { CertificateVerificationData } from '../../sdk/public/verify.sdk'
import { Card, CardContent, CardHeader } from '../../components/ui/card'
import { Badge } from '../../components/ui/badge'
import { Button } from '../../components/ui/button'
import { Shield, ShieldX, FileText, Search } from 'lucide-react'
import { AxiosError } from 'axios'

export default function VerifyPage() {
  const { t } = useTranslation()
  const [searchParams] = useSearchParams()
  const serial = searchParams.get('serial')

  const { data, isLoading, error } = useQuery({
    queryKey: ['certificate-verify', serial],
    queryFn: async () => {
      const res = await verify.check(serial!)
      return res.data.data as CertificateVerificationData
    },
    enabled: !!serial,
    retry: 1,
  })

  if (!serial) {
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

  const isValid = data.status === 'ISSUED'
  const isRevoked = data.status === 'REVOKED'
  const isSuperseded = data.status === 'SUPERSEDED'

  return (
    <div className="min-h-screen flex items-center justify-center bg-slate-50 p-4" dir="auto">
      <Card className="w-full max-w-lg">
        <CardHeader className="text-center border-b pb-4">
          <div className="flex justify-center mb-3">
            {isValid ? (
              <Shield className="w-16 h-16 text-green-500" />
            ) : (
              <ShieldX className="w-16 h-16 text-red-500" />
            )}
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
            <span className="text-right">{new Date(data.issuedAt).toLocaleDateString()}</span>
          </div>

          {isRevoked && data.revokedAt && (
            <div className="bg-red-50 border border-red-200 rounded p-3 text-sm text-red-700">
              <p className="font-medium">{t('verify.revokedAt')}: {new Date(data.revokedAt).toLocaleDateString()}</p>
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
            {t('verify.verifiedAt')}: {new Date(data.verifiedAt).toLocaleString()}
          </div>

          <div className="flex justify-center pt-2">
            <Button variant="outline" size="sm" onClick={() => window.print()}>
              <FileText className="w-4 h-4 ml-1" />
              {t('verify.printReport')}
            </Button>
          </div>
        </CardContent>
      </Card>
    </div>
  )
}
