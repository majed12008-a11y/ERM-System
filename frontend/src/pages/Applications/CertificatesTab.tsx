import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { certificates } from '../../sdk'
import type { ApprovalCertificate } from '../../sdk'
import { useAuth } from '../../context/AuthContext'
import { AxiosError } from 'axios'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Badge } from '../../components/ui/badge'
import { FileText, Download, RotateCcw, XCircle, RefreshCw } from 'lucide-react'
import { useState } from 'react'

interface CertificatesTabProps {
  applicationId: string | number
}

const STATUS_VARIANTS: Record<string, 'default' | 'success' | 'warning' | 'destructive' | 'secondary'> = {
  ISSUED: 'success',
  REVOKED: 'destructive',
  SUPERSEDED: 'warning',
  FAILED: 'destructive',
  GENERATING: 'default',
  DRAFT: 'secondary',
}

export default function CertificatesTab({ applicationId }: CertificatesTabProps) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const { user } = useAuth()
  const [revokingId, setRevokingId] = useState<number | null>(null)
  const [revokeReason, setRevokeReason] = useState('')

  const isAdmin = user?.roles?.some(r => ['SUPER_ADMIN', 'ETHICS_ADMIN'].includes(r))

  const { data: certsRes, isLoading } = useQuery({
    queryKey: ['application-certificates', applicationId],
    queryFn: () => certificates.list(Number(applicationId)),
    enabled: !!applicationId,
  })

  const certs: ApprovalCertificate[] = certsRes?.data?.data || []

  const downloadMutation = useMutation({
    mutationFn: (certId: number) => certificates.download(certId),
    onSuccess: (res, certId) => {
      const cert = certs.find(c => c.id === certId)
      const url = window.URL.createObjectURL(new Blob([res.data]))
      const a = document.createElement('a')
      a.href = url
      a.download = cert ? `${cert.serial_number}.pdf` : `certificate-${certId}.pdf`
      a.click()
      window.URL.revokeObjectURL(url)
    },
    onError: (err: AxiosError) => {
      toast.error((err.response?.data as any)?.error || t('common.error'))
    },
  })

  const retryMutation = useMutation({
    mutationFn: (certId: number) => certificates.retry(certId),
    onSuccess: () => {
      toast.success(t('certificates.retrySuccess'))
      queryClient.invalidateQueries({ queryKey: ['application-certificates', applicationId] })
    },
    onError: (err: AxiosError) => {
      toast.error((err.response?.data as any)?.error || t('common.error'))
    },
  })

  const reissueMutation = useMutation({
    mutationFn: (certId: number) => certificates.reissue(certId),
    onSuccess: () => {
      toast.success(t('certificates.reissueSuccess'))
      queryClient.invalidateQueries({ queryKey: ['application-certificates', applicationId] })
    },
    onError: (err: AxiosError) => {
      toast.error((err.response?.data as any)?.error || t('common.error'))
    },
  })

  const revokeMutation = useMutation({
    mutationFn: ({ certId, reason }: { certId: number; reason: string }) =>
      certificates.revoke(certId, reason),
    onSuccess: () => {
      toast.success(t('certificates.revokeSuccess'))
      setRevokingId(null)
      setRevokeReason('')
      queryClient.invalidateQueries({ queryKey: ['application-certificates', applicationId] })
    },
    onError: (err: AxiosError) => {
      toast.error((err.response?.data as any)?.error || t('common.error'))
    },
  })

  if (isLoading) return <div className="text-sm text-slate-500 p-4">{t('common.loading')}</div>

  if (certs.length === 0) {
    return (
      <Card>
        <CardHeader><CardTitle className="text-sm flex items-center gap-2"><FileText className="w-4 h-4" /> {t('certificates.title')}</CardTitle></CardHeader>
        <CardContent>
          <p className="text-sm text-slate-500">{t('certificates.noCertificates')}</p>
        </CardContent>
      </Card>
    )
  }

  return (
    <Card>
      <CardHeader><CardTitle className="text-sm flex items-center gap-2"><FileText className="w-4 h-4" /> {t('certificates.title')}</CardTitle></CardHeader>
      <CardContent>
        <div className="space-y-3">
          {certs.map((cert) => (
            <div key={cert.id} className="border rounded-lg p-3 flex items-start justify-between gap-4">
              <div className="space-y-1 min-w-0">
                <div className="flex items-center gap-2">
                  <span className="font-medium text-sm">{cert.serial_number}</span>
                  <Badge variant={STATUS_VARIANTS[cert.status] || 'secondary'}>
                    {t(`certificates.status.${cert.status}`)}
                  </Badge>
                </div>
                <p className="text-xs text-slate-500">{t('certificates.issuedAt')}: {new Date(cert.issued_at).toLocaleDateString()}</p>
                {cert.revoked_at && (
                  <p className="text-xs text-red-500">{t('certificates.revokedAt')}: {new Date(cert.revoked_at).toLocaleDateString()}</p>
                )}
                {cert.revocation_reason && (
                  <p className="text-xs text-red-500">{t('certificates.revocationReason')}: {cert.revocation_reason}</p>
                )}
                {cert.status === 'FAILED' && cert.generation_error && (
                  <p className="text-xs text-red-400">{cert.generation_error?.message}</p>
                )}
              </div>

              <div className="flex items-center gap-1 shrink-0">
                {cert.status === 'ISSUED' && (
                  <Button variant="ghost" size="sm" onClick={() => downloadMutation.mutate(cert.id)}>
                    <Download className="w-4 h-4" />
                  </Button>
                )}

                {isAdmin && cert.status === 'FAILED' && (
                  <Button variant="ghost" size="sm" onClick={() => retryMutation.mutate(cert.id)}>
                    <RefreshCw className="w-4 h-4" />
                  </Button>
                )}

                {isAdmin && cert.status === 'ISSUED' && (
                  <>
                    <Button variant="ghost" size="sm" onClick={() => reissueMutation.mutate(cert.id)}>
                      <RotateCcw className="w-4 h-4" />
                    </Button>

                    {revokingId === cert.id ? (
                      <div className="flex items-center gap-1">
                        <input
                          type="text"
                          className="w-32 h-7 text-xs border rounded px-1"
                          placeholder={t('certificates.revokeReasonPlaceholder')}
                          value={revokeReason}
                          onChange={(e) => setRevokeReason(e.target.value)}
                        />
                        <Button
                          variant="destructive"
                          size="sm"
                          disabled={!revokeReason.trim()}
                          onClick={() => revokeMutation.mutate({ certId: cert.id, reason: revokeReason.trim() })}
                        >
                          {t('common.confirm')}
                        </Button>
                        <Button variant="ghost" size="sm" onClick={() => { setRevokingId(null); setRevokeReason('') }}>
                          {t('common.cancel')}
                        </Button>
                      </div>
                    ) : (
                      <Button variant="ghost" size="sm" onClick={() => setRevokingId(cert.id)}>
                        <XCircle className="w-4 h-4" />
                      </Button>
                    )}
                  </>
                )}
              </div>
            </div>
          ))}
        </div>
      </CardContent>
    </Card>
  )
}
