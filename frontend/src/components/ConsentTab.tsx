import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../api/client'
import { StatusBadge } from './StatusBadge'
import { Button } from './ui/button'
import { Card, CardContent, CardHeader, CardTitle } from './ui/card'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from './ui/dialog'
import { Label } from './ui/label'
import { Textarea } from './ui/textarea'
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from './ui/select'
import { Badge } from './ui/badge'
import { ClipboardList, CheckCircle, AlertTriangle, XCircle, Edit3 } from 'lucide-react'

const CONSENT_STATUS_COLORS: Record<string, string> = {
  PENDING: 'bg-gray-100 text-gray-800',
  APPROVED: 'bg-green-100 text-green-800',
  MINOR_REVISION: 'bg-yellow-100 text-yellow-800',
  MAJOR_REVISION: 'bg-orange-100 text-orange-800',
  REJECTED: 'bg-red-100 text-red-800',
}

const DECISIONS = ['APPROVED', 'MINOR_REVISION', 'MAJOR_REVISION', 'REJECTED']

export default function ConsentTab({ applicationId, canAssign, canReview, reviewerId }: {
  applicationId: string | number
  canAssign?: boolean
  canReview?: boolean
  reviewerId?: number
}) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()

  const [openAssign, setOpenAssign] = useState(false)
  const [openReview, setOpenReview] = useState<any>(null)
  const [selectedVersionId, setSelectedVersionId] = useState('')
  const [isRequired, setIsRequired] = useState(true)
  const [reviewDecision, setReviewDecision] = useState('APPROVED')
  const [reviewComment, setReviewComment] = useState('')

  const { data: consents, isLoading } = useQuery({
    queryKey: ['app-consents', applicationId],
    queryFn: () => api.get(`/committee/consent/application-consents/${applicationId}`).then(r => r.data.data),
    enabled: !!applicationId,
  })

  const { data: templates } = useQuery({
    queryKey: ['consent-templates'],
    queryFn: () => api.get('/committee/consent/templates').then(r => r.data.data),
  })

  const { data: allVersions } = useQuery({
    queryKey: ['all-consent-versions', templates],
    queryFn: async () => {
      if (!templates?.length) return []
      const results = await Promise.all(
        templates.map((t: any) =>
          api.get(`/committee/consent/templates/${t.id}/versions`).then(r => r.data.data)
        )
      )
      return results.flat().filter((v: any) => v.status === 'APPROVED')
    },
    enabled: !!templates?.length,
  })

  const assignMutation = useMutation({
    mutationFn: (body: any) => api.post('/committee/consent/application-consents', body),
    onSuccess: () => {
      toast.success(t('consent.consentAssigned'))
      queryClient.invalidateQueries({ queryKey: ['app-consents', applicationId] })
      setOpenAssign(false)
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const reviewMutation = useMutation({
    mutationFn: (body: any) => api.post('/committee/consent/reviews', body),
    onSuccess: () => {
      toast.success(t('consent.reviewSubmitted'))
      queryClient.invalidateQueries({ queryKey: ['app-consents', applicationId] })
      setOpenReview(null); setReviewComment(''); setReviewDecision('APPROVED')
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  function handleAssign() {
    if (!selectedVersionId) return
    assignMutation.mutate({
      application_id: Number(applicationId),
      consent_version_id: Number(selectedVersionId),
      is_required: isRequired,
    })
  }

  function handleSubmitReview() {
    if (!openReview) return
    reviewMutation.mutate({
      application_consent_id: openReview.id,
      decision: reviewDecision,
      comment: reviewComment,
    })
  }

  if (isLoading) return <Card><CardContent className="p-6 text-center text-gray-500">{t('common.loading')}</CardContent></Card>

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between">
        <h3 className="text-lg font-semibold flex items-center gap-2">
          <ClipboardList className="w-5 h-5" />{t('consent.assignedTemplates')}
        </h3>
        {canAssign && (
          <Button size="sm" onClick={() => setOpenAssign(true)}>
            {t('consent.assignTemplate')}
          </Button>
        )}
      </div>

      {(!consents || consents.length === 0) ? (
        <p className="text-gray-500 text-sm">{t('consent.noTemplates')}</p>
      ) : (
        <div className="space-y-3">
          {consents.map((ac: any) => (
            <Card key={ac.id}>
              <CardContent className="p-4">
                <div className="flex items-start justify-between">
                  <div className="space-y-1">
                    <div className="flex items-center gap-2">
                      <span className="font-medium">{ac.template_name_ar}</span>
                      <StatusBadge status={ac.status} colorMap={CONSENT_STATUS_COLORS} />
                      {ac.is_required ? (
                        <Badge variant="outline" className="text-xs">{t('consent.required')}</Badge>
                      ) : (
                        <Badge variant="outline" className="text-xs bg-gray-50">{t('consent.optional')}</Badge>
                      )}
                    </div>
                    <div className="text-sm text-gray-500">
                      {t('consent.versionNo')} {ac.version_no} · {t(`consent.${ac.language}`)} · {ac.template_code}
                    </div>
                    {ac.reviewer_name && (
                      <div className="text-sm text-gray-500">{t('risk.assessedBy')}: {ac.reviewer_name}</div>
                    )}
                  </div>
                  <div className="flex gap-2">
                    {canReview && (ac.status === 'PENDING' || ac.status === 'MINOR_REVISION' || ac.status === 'MAJOR_REVISION') && (
                      <Button size="sm" variant="outline" onClick={() => { setOpenReview(ac); setReviewDecision('APPROVED'); setReviewComment('') }}>
                        <Edit3 className="w-4 h-4 ml-1" />{t('consent.reviewConsent')}
                      </Button>
                    )}
                  </div>
                </div>

                {/* Review History */}
                {ac.review_comments && ac.review_comments.length > 0 && (
                  <div className="mt-3 pt-3 border-t space-y-2">
                    <span className="text-xs font-medium text-gray-500">{t('consent.reviewHistory')}</span>
                    {ac.review_comments.slice(0, 3).map((rc: any) => (
                      <div key={rc.id} className="text-sm bg-gray-50 rounded p-2">
                        <div className="flex items-center gap-2">
                          <DecisionIcon decision={rc.decision} />
                          <span className="font-medium">{rc.reviewer_name}</span>
                          <span className="text-xs text-gray-400">{new Date(rc.created_at).toLocaleDateString()}</span>
                        </div>
                        <p className="text-gray-600 mt-1">{rc.comment}</p>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          ))}
        </div>
      )}

      <Dialog open={openAssign} onOpenChange={setOpenAssign}>
        <DialogContent>
          <DialogHeader><DialogTitle>{t('consent.assignTemplate')}</DialogTitle></DialogHeader>
          <div className="grid gap-4 py-4">
            <div>
              <Label>{t('consent.consentType')}</Label>
              <Select value={selectedVersionId} onValueChange={setSelectedVersionId}>
                <SelectTrigger><SelectValue placeholder={t('common.select')} /></SelectTrigger>
                <SelectContent>
                  {allVersions?.map((v: any) => (
                    <SelectItem key={v.id} value={String(v.id)}>
                      {v.title} (v{v.version_no} · {t(`consent.${v.language}`)})
                    </SelectItem>
                  ))}
                </SelectContent>
              </Select>
            </div>
            <div className="flex items-center gap-2">
              <input type="checkbox" id="isRequired" checked={isRequired} onChange={e => setIsRequired(e.target.checked)} className="rounded" />
              <Label htmlFor="isRequired" className="mb-0">{t('consent.isRequired')}</Label>
            </div>
          </div>
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpenAssign(false)}>{t('common.cancel')}</Button>
            <Button onClick={handleAssign}>{t('common.save')}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      <Dialog open={!!openReview} onOpenChange={(v) => { if (!v) setOpenReview(null) }}>
        <DialogContent>
          <DialogHeader><DialogTitle>{t('consent.reviewConsent')}</DialogTitle></DialogHeader>
          {openReview && (
            <div className="space-y-4 py-4">
              <div className="text-sm">
                <span className="font-medium">{openReview.template_name_ar}</span>
                <span className="text-gray-500 ml-2">(v{openReview.version_no} · {t(`consent.${openReview.language}`)})</span>
              </div>
              <div>
                <Label>{t('consent.reviewDecision')}</Label>
                <Select value={reviewDecision} onValueChange={setReviewDecision}>
                  <SelectTrigger><SelectValue /></SelectTrigger>
                  <SelectContent>
                    {DECISIONS.map(d => (
                      <SelectItem key={d} value={d}>
                        <div className="flex items-center gap-2">
                          <DecisionIcon decision={d} />
                          <span>{t(`consent.${d === 'APPROVED' ? 'approved' : d === 'MINOR_REVISION' ? 'minorRevision' : d === 'MAJOR_REVISION' ? 'majorRevision' : 'rejected'}`)}</span>
                        </div>
                      </SelectItem>
                    ))}
                  </SelectContent>
                </Select>
              </div>
              <div>
                <Label>{t('consent.reviewComment')}</Label>
                <Textarea value={reviewComment} onChange={e => setReviewComment(e.target.value)} rows={4} />
              </div>
            </div>
          )}
          <DialogFooter>
            <Button variant="outline" onClick={() => setOpenReview(null)}>{t('common.cancel')}</Button>
            <Button onClick={handleSubmitReview}>{t('consent.submitReview')}</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}

function DecisionIcon({ decision }: { decision: string }) {
  switch (decision) {
    case 'APPROVED': return <CheckCircle className="w-4 h-4 text-green-600" />
    case 'MINOR_REVISION': return <AlertTriangle className="w-4 h-4 text-yellow-600" />
    case 'MAJOR_REVISION': return <AlertTriangle className="w-4 h-4 text-orange-600" />
    case 'REJECTED': return <XCircle className="w-4 h-4 text-red-600" />
    default: return null
  }
}
