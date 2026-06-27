/*
 * صفحة التوقيعات الإلكترونية: إدارة وعرض التوقيعات
 * الإلكترونية للمستندات والموافقات.
 */
import { useState } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import api from '../../api/client'
import { Card, CardContent } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { PenSquare, FileSignature, CheckCircle, FileText } from 'lucide-react'
import { useTranslation } from 'react-i18next'

export default function ESignaturesPage() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [signingId, setSigningId] = useState<number | null>(null)
  const [signError, setSignError] = useState('')

  const { data: documents } = useQuery({
    queryKey: ['documents'],
    queryFn: () => api.get('/documents').then(r => r.data.data || []),
  })

  const signMutation = useMutation({
    mutationFn: (id: number) => api.post(`/documents/${id}/sign`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['documents'] }); setSigningId(null); setSignError('') },
    onError: (err: any) => setSignError(err.response?.data?.error || t('signatures.failed')),
  })

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <PenSquare className="w-6 h-6 text-blue-600" />
        <h1 className="text-2xl font-bold">{t('signatures.title')}</h1>
      </div>

      {signError && <p className="text-red-500 text-sm mb-4">{signError}</p>}

      <div className="space-y-3">
        {documents && documents.length > 0 ? documents.map((doc: any) => (
          <DocumentSignCard key={doc.id} doc={doc} onSign={(id) => signMutation.mutate(id)} signingId={signingId} />
        )) : (
          <Card><CardContent className="p-12 text-center text-slate-400"><FileSignature className="w-12 h-12 mx-auto mb-3 opacity-30" /><p>{t('signatures.empty')}</p></CardContent></Card>
        )}
      </div>
    </div>
  )
}

function DocumentSignCard({ doc, onSign, signingId }: { doc: any; onSign: (id: number) => void; signingId: number | null }) {
  const { t } = useTranslation()
  const { data: signatures } = useQuery({
    queryKey: ['doc-signatures', doc.id],
    queryFn: () => api.get(`/documents/${doc.id}/signatures`).then(r => r.data.data),
  })

  const sigCount = signatures?.length || 0

  return (
    <Card>
      <CardContent className="p-4">
        <div className="flex items-start justify-between">
          <div className="flex items-center gap-3">
            <div className="bg-blue-100 p-2 rounded">
              <FileText className="w-5 h-5 text-blue-600" />
            </div>
            <div>
              <p className="font-medium text-sm">{doc.document_title}</p>
              <p className="text-xs text-slate-400">{doc.type_name_ar || doc.file_name} • {t('signatures.count', { count: sigCount })}</p>
            </div>
          </div>
          <Button size="sm" onClick={() => onSign(doc.id)} disabled={signingId === doc.id}>
            {signingId === doc.id ? t('signatures.signing') : <><PenSquare className="w-3 h-3 mr-1" /> {t('signatures.sign')}</>}
          </Button>
        </div>

        {signatures && signatures.length > 0 && (
          <div className="mt-3 pt-3 border-t space-y-1">
            {signatures.map((s: any) => (
              <div key={s.id} className="flex items-center gap-2 text-xs text-slate-500">
                <CheckCircle className="w-3 h-3 text-green-500" />
                <span className="font-medium">{s.signer_name}</span>
                <span>• {new Date(s.signed_at).toLocaleString()}</span>
                <span className="text-slate-300">({s.signature_type})</span>
              </div>
            ))}
          </div>
        )}
      </CardContent>
    </Card>
  )
}