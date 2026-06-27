/*
 * صفحة تفاصيل طلب البحث: عرض كامل للطلب مع المستندات،
 * المراجعات، سير العمل، وإمكانية تحديث الحالة.
 */
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../../api/client'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import { StatusBadge } from '../../components/StatusBadge'
import RiskAssessment from '../../components/RiskAssessment'
import ConsentTab from '../../components/ConsentTab'
import { useAuth } from '../../context/AuthContext'
import { workflowTransitionSchema, reviewSubmissionSchema, committeeDecisionSchema } from '../../lib/schemas'
import {
  ArrowLeft, FileText, User, Calendar, Building2,
  BookOpen, Users, FileUp, Gavel, Pencil, Send
} from 'lucide-react'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { z } from 'zod'

type TransitionFormData = z.input<typeof workflowTransitionSchema>
type ReviewFormData = z.input<typeof reviewSubmissionSchema>
type DecisionFormData = z.input<typeof committeeDecisionSchema>

export default function ApplicationDetail() {
  const { t } = useTranslation()
  const { id } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()
  const queryClient = useQueryClient()

  const transitionForm = useForm<TransitionFormData>({
    resolver: zodResolver(workflowTransitionSchema),
    defaultValues: { transition_code: '', comment: '' },
  })
  const submitReviewForm = useForm<ReviewFormData>({
    resolver: zodResolver(reviewSubmissionSchema),
    defaultValues: { recommendation_type: 'APPROVE', justification: '', comment_text: '' },
  })
  const decisionForm = useForm<DecisionFormData>({
    resolver: zodResolver(committeeDecisionSchema),
    defaultValues: { decision: 'APPROVED', notes: '' },
  })

  const { data: app, isLoading } = useQuery({
    queryKey: ['application', id],
    queryFn: () => api.get(`/core/applications/${id}`).then((r) => r.data.data),
  })

  const { data: workflow } = useQuery({
    queryKey: ['workflow-instance', 'Application', id],
    queryFn: () => api.get(`/workflow/instances/Application/${id}`).then((r) => r.data.data),
    enabled: !!id,
  })

  const { data: availableTransitions } = useQuery({
    queryKey: ['available-transitions', 'Application', id],
    queryFn: () => api.get(`/workflow/available-transitions/Application/${id}`).then((r) => r.data.data),
    enabled: !!id,
  })

  const { data: reviews } = useQuery({
    queryKey: ['application-reviews', id],
    queryFn: () => api.get(`/committee/reviews/application/${id}`).then((r) => r.data.data),
    enabled: !!id,
  })

  const { data: documents } = useQuery({
    queryKey: ['application-documents', id],
    queryFn: () => api.get(`/documents/entity/Application/${id}`).then((r) => r.data.data),
    enabled: !!id,
  })

  const { data: recommendations } = useQuery({
    queryKey: ['recommendations', id],
    queryFn: () => api.get(`/committee/reviews/application/${id}/recommendations`).then((r) => r.data.data),
    enabled: !!id,
  })

  const { data: comments } = useQuery({
    queryKey: ['review-comments', id],
    queryFn: () => api.get(`/committee/reviews/application/${id}/comments`).then((r) => r.data.data),
    enabled: !!id,
  })

  const transitions = availableTransitions?.transitions || []
  const canTransition = transitions.length > 0

  const selectedTransCode = transitionForm.watch('transition_code')
  const selectedTrans = transitions.find((t: any) => t.transition_code === selectedTransCode)

  function onTransition(data: TransitionFormData) {
    api.patch(`/core/applications/${id}/status`, {
      transition_code: data.transition_code,
      comment: data.comment || undefined,
    }).then(() => {
      toast.success(t('applications.statusUpdated'))
      queryClient.invalidateQueries({ queryKey: ['application', id] })
      queryClient.invalidateQueries({ queryKey: ['workflow-instance', 'Application', id] })
      queryClient.invalidateQueries({ queryKey: ['available-transitions', 'Application', id] })
      queryClient.invalidateQueries({ queryKey: ['application-reviews', id] })
      transitionForm.reset()
    }).catch((err: any) => {
      toast.error(err.response?.data?.error || t('applications.statusUpdateFailed'))
    })
  }

  const myAssignment = reviews?.find((r: any) => r.reviewer_id === user?.id && r.status_code !== 'COMPLETED')

  const [submitting, setSubmitting] = useState(false)
  const [formAnswers, setFormAnswers] = useState<Record<number, { text: string; score: number }>>({})

  const { data: reviewForm } = useQuery({
    queryKey: ['review-form-for-type', myAssignment?.review_type],
    queryFn: () => api.get('/committee/reviews/forms').then(r => (r.data.data || []).find((f: any) => f.review_type === myAssignment!.review_type && f.is_active)),
    enabled: !!myAssignment,
  })

  const { data: formQuestions } = useQuery({
    queryKey: ['form-questions-for-review', reviewForm?.id],
    queryFn: () => api.get(`/committee/reviews/forms/${reviewForm!.id}/questions`).then(r => r.data.data),
    enabled: !!reviewForm?.id,
  })

  async function onReview(data: ReviewFormData) {
    if (!myAssignment) return
    setSubmitting(true)
    try {
      const body: any = { recommendation_type: data.recommendation_type }
      if (data.justification) body.justification = data.justification
      if (data.comment_text) body.comment_text = data.comment_text
      if (formQuestions && formQuestions.length > 0) {
        body.answers = formQuestions.map((q: any) => ({
          question_id: q.id,
          answer_text: formAnswers[q.id]?.text || null,
          answer_score: formAnswers[q.id]?.score || null,
        }))
      }
      await api.post(`/committee/reviews/${myAssignment.id}/submit`, body)
      toast.success(t('applications.reviewSubmitted'))
      submitReviewForm.reset()
      setFormAnswers({})
      queryClient.invalidateQueries({ queryKey: ['application-reviews', id] })
      queryClient.invalidateQueries({ queryKey: ['recommendations', id] })
      queryClient.invalidateQueries({ queryKey: ['my-reviews'] })
    } catch (err: any) {
      toast.error(err.response?.data?.error || t('applications.reviewFailed'))
    } finally {
      setSubmitting(false)
    }
  }

  const canDecide = user?.roles?.some((r) => ['ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'].includes(r))

  const [deciding, setDeciding] = useState(false)
  function onDecision(data: DecisionFormData) {
    setDeciding(true)
    api.post(`/core/applications/${id}/committee-decision`, { decision: data.decision, notes: data.notes })
      .then(() => {
        toast.success(t('applications.decisionSubmitted', { status: data.decision }))
        queryClient.invalidateQueries({ queryKey: ['application', id] })
        queryClient.invalidateQueries({ queryKey: ['application-reviews', id] })
        queryClient.invalidateQueries({ queryKey: ['pending-review-count', id] })
        decisionForm.reset()
      }).catch((err: any) => {
        toast.error(err.response?.data?.error || t('applications.decisionFailed'))
      }).finally(() => setDeciding(false))
  }

  const { data: pendingCount } = useQuery({
    queryKey: ['pending-review-count', id],
    queryFn: () => api.get(`/committee/reviews/application/${id}`).then((r) =>
      (r.data.data || []).filter((a: any) => a.status_code !== 'COMPLETED').length
    ),
    enabled: !!id && canDecide,
  })

  if (isLoading) return <PageSkeleton />
  if (!app) return <p className="text-red-500">{t('applications.notFound')}</p>
  const infoCards = [
    { labelKey: 'applications.number', value: app.application_number, icon: FileText },
    { labelKey: 'applications.project', value: app.project_title, icon: Building2 },
    { labelKey: 'applications.committee', value: app.committee_name, icon: Users },
    { labelKey: 'applications.submittedBy', value: app.submitted_by_username, icon: User },
    { labelKey: 'applications.submitted', value: new Date(app.created_at).toLocaleDateString(), icon: Calendar },
  ]

  return (
    <div>
      <button onClick={() => navigate('/applications')}
        className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4">
        <ArrowLeft className="w-4 h-4" /> {t('applications.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{t('applications.number')}{app.application_number}</h1>
        <div className="flex items-center gap-3">
          <StatusBadge status={app.current_status} />
          {app.current_status === 'DRAFT' && (
            <div className="flex items-center gap-2">
              <Button variant="outline" size="sm" onClick={() => navigate(`/applications/${id}/edit`)}>
                <Pencil className="w-4 h-4 mr-1" /> {t('applications.editDraft')}
              </Button>
            </div>
          )}
          {canTransition && (
            <form onSubmit={transitionForm.handleSubmit(onTransition)} className="flex items-center gap-2">
              <select {...transitionForm.register('transition_code')} className="text-sm border rounded p-1.5">
                <option value="">{t('applications.selectAction')}</option>
                {transitions.map((t: any) => (
                  <option key={t.transition_code} value={t.transition_code}>{t.transition_name}</option>
                ))}
              </select>
              {selectedTrans?.requires_comment && (
                <input {...transitionForm.register('comment')} placeholder={t('applications.comment')} className="text-sm border rounded p-1.5 w-40" />
              )}
              <Button type="submit" size="sm" disabled={!selectedTransCode}>{t('applications.go')}</Button>
            </form>
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4 mb-6">
        {infoCards.map((card) => (
          <div key={card.labelKey} className="bg-white rounded-lg shadow p-4 flex items-center gap-3">
            <div className="bg-slate-100 p-2 rounded">
              <card.icon className="w-5 h-5 text-slate-600" />
            </div>
            <div>
              <p className="text-xs text-slate-500">{t(card.labelKey)}</p>
              <p className="text-sm font-medium">{card.value || '\u2014'}</p>
            </div>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader><CardTitle className="text-sm">{t('applications.details')}</CardTitle></CardHeader>
            <CardContent>
              <dl className="grid grid-cols-2 gap-4 text-sm">
                <div><dt className="text-slate-500 text-xs">{t('applications.type')}</dt><dd className="font-medium">{app.application_type}</dd></div>
                <div><dt className="text-slate-500 text-xs">{t('applications.status')}</dt><dd><StatusBadge status={app.current_status} /></dd></div>
                <div><dt className="text-slate-500 text-xs">{t('applications.projectCode')}</dt><dd className="font-medium">{app.project_code}</dd></div>
                <div><dt className="text-slate-500 text-xs">{t('applications.committee')}</dt><dd className="font-medium">{app.committee_name || '\u2014'}</dd></div>
                <div><dt className="text-slate-500 text-xs">{t('applications.submitted')}</dt><dd className="font-medium">{new Date(app.created_at).toLocaleString()}</dd></div>
                <div><dt className="text-slate-500 text-xs">{t('applications.lastUpdated')}</dt><dd className="font-medium">{new Date(app.updated_at).toLocaleString()}</dd></div>
              </dl>
            </CardContent>
          </Card>

          <Card>
            <CardHeader><CardTitle className="text-sm">{t('applications.projectDetails')}</CardTitle></CardHeader>
            <CardContent>
              <dl className="grid grid-cols-2 gap-4 text-sm">
                <div className="col-span-2"><dt className="text-slate-500 text-xs">{t('applications.titleAr')}</dt><dd className="font-medium">{app.project_title}</dd></div>
                <div className="col-span-2"><dt className="text-slate-500 text-xs">{t('applications.titleEn')}</dt><dd className="font-medium">{app.project_title_en || '\u2014'}</dd></div>
                <div><dt className="text-slate-500 text-xs">{t('applications.researchCategory')}</dt><dd className="font-medium">{app.research_category || '\u2014'}</dd></div>
                <div><dt className="text-slate-500 text-xs">{t('applications.riskLevel')}</dt><dd className="font-medium">{app.project_risk_level || '\u2014'}</dd></div>
                <div className="col-span-2"><dt className="text-slate-500 text-xs">{t('applications.objectives')}</dt><dd className="font-medium text-sm">{app.project_objectives || '\u2014'}</dd></div>
              </dl>
            </CardContent>
          </Card>

          <RiskAssessment applicationId={id!} reviewerId={user?.id} />

          <Card>
            <CardHeader><CardTitle className="text-sm flex items-center gap-2"><FileText className="w-4 h-4" /> {t('consent.title')}</CardTitle></CardHeader>
            <CardContent>
              <ConsentTab
                applicationId={id!}
                canAssign={user?.role === 'ETHICS_ADMIN' || user?.role === 'COMMITTEE_CHAIR' || user?.role === 'SUPER_ADMIN'}
                canReview={user?.role === 'REVIEWER' || user?.role === 'COMMITTEE_CHAIR' || user?.role === 'ETHICS_ADMIN' || user?.role === 'SUPER_ADMIN'}
                reviewerId={user?.id}
              />
            </CardContent>
          </Card>

          {(reviews && reviews.length > 0) && (
            <Card>
              <CardHeader><CardTitle className="text-sm flex items-center gap-2"><BookOpen className="w-4 h-4" /> {t('applications.reviews')}</CardTitle></CardHeader>
              <CardContent>
                <div className="space-y-3">
                  {reviews.map((r: any) => (
                    <div key={r.id} className="flex items-center justify-between text-sm border-b pb-2 last:border-0">
                      <div>
                        <p className="font-medium">{r.reviewer_name}</p>
                        <p className="text-xs text-slate-400">{r.review_type} {'\u2022'} {new Date(r.assigned_at).toLocaleDateString()}</p>
                      </div>
                      <StatusBadge status={r.status_code || r.status} />
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          {(documents && documents.length > 0) && (
            <Card>
              <CardHeader><CardTitle className="text-sm flex items-center gap-2"><FileUp className="w-4 h-4" /> {t('applications.documents')}</CardTitle></CardHeader>
              <CardContent>
                <div className="space-y-2">
                  {documents.map((d: any) => (
                    <div key={d.id} className="flex items-center justify-between text-sm border-b pb-2 last:border-0">
                      <div>
                        <p className="font-medium">{d.document_title}</p>
                        <p className="text-xs text-slate-400">{d.type_name_ar} {'\u2022'} {d.file_name}</p>
                      </div>
                      <span className="text-xs text-slate-400">{d.uploaded_by_username}</span>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader><CardTitle className="text-sm">{t('applications.workflowTimeline')}</CardTitle></CardHeader>
            <CardContent>
              {workflow && workflow.length > 0 ? (
                <div className="space-y-3">
                  {workflow.map((w: any, i: number) => (
                    <div key={i} className="flex gap-3">
                      <div className="flex flex-col items-center">
                        <div className={`w-3 h-3 rounded-full ${i === 0 ? 'bg-blue-500' : 'bg-slate-300'}`} />
                        {i < workflow.length - 1 && <div className="w-0.5 h-8 bg-blue-200" />}
                      </div>
                      <div>
                        <p className="text-sm font-medium">{w.current_state_name}</p>
                        <p className="text-xs text-slate-400">{new Date(w.created_at).toLocaleString()}</p>
                      </div>
                    </div>
                  ))}
                </div>
              ) : (
                <p className="text-sm text-slate-400">{t('applications.noWorkflow')}</p>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader><CardTitle className="text-sm">{t('applications.submitterInfo')}</CardTitle></CardHeader>
            <CardContent className="text-sm space-y-2">
              <div><span className="text-slate-500">{t('applications.name')}</span> <span className="font-medium">{app.submitted_by_username}</span></div>
              <div><span className="text-slate-500">{t('applications.email')}</span> <span className="font-medium">{app.submitted_by_email || '\u2014'}</span></div>
            </CardContent>
          </Card>

          {canDecide && (
            <Card>
              <CardHeader><CardTitle className="text-sm flex items-center gap-2"><Gavel className="w-4 h-4" /> {t('applications.committeeDecision')}</CardTitle></CardHeader>
              <CardContent className="space-y-3">
                {pendingCount > 0 && (
                  <p className="text-amber-600 text-xs bg-amber-50 p-2 rounded">{t('applications.pendingWarning', { count: pendingCount })}</p>
                )}
                <form onSubmit={decisionForm.handleSubmit(onDecision)} className="space-y-3">
                  <div>
                    <label className="block text-xs text-slate-500 mb-1">{t('applications.finalDecision')}</label>
                    <select {...decisionForm.register('decision')} className="w-full p-2 border rounded text-sm">
                      <option value="APPROVED">{t('applications.approve')}</option>
                      <option value="REJECTED">{t('applications.reject')}</option>
                      <option value="CONDITIONAL">{t('applications.conditionalApproval')}</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs text-slate-500 mb-1">{t('applications.notes')} ({t('common.optional')})</label>
                    <textarea {...decisionForm.register('notes')} className="w-full p-2 border rounded text-sm" rows={2} />
                  </div>
                  <Button type="submit" size="sm" className="w-full" disabled={deciding || pendingCount > 0}>
                    {deciding ? t('applications.submitting') : t('applications.submitDecision')}
                  </Button>
                </form>
              </CardContent>
            </Card>
          )}

          {myAssignment && (
            <Card>
              <CardHeader><CardTitle className="text-sm">{t('applications.submitYourReview')}</CardTitle></CardHeader>
              <CardContent className="space-y-3">
                <form onSubmit={submitReviewForm.handleSubmit(onReview)} className="space-y-3">
                  <div>
                    <label className="block text-xs text-slate-500 mb-1">{t('applications.recommendation')}</label>
                    <select {...submitReviewForm.register('recommendation_type')} className="w-full p-2 border rounded text-sm">
                      <option value="APPROVE">{t('applications.approve')}</option>
                      <option value="REJECT">{t('applications.reject')}</option>
                      <option value="CONDITIONAL">{t('applications.conditional')}</option>
                      <option value="ABSTAIN">{t('applications.abstain')}</option>
                    </select>
                  </div>
                  <div>
                    <label className="block text-xs text-slate-500 mb-1">{t('applications.justification')}</label>
                    <textarea {...submitReviewForm.register('justification')} className="w-full p-2 border rounded text-sm" rows={3} />
                  </div>
                  <div>
                    <label className="block text-xs text-slate-500 mb-1">{t('applications.commentOptional')}</label>
                    <textarea {...submitReviewForm.register('comment_text')} className="w-full p-2 border rounded text-sm" rows={2} />
                  </div>

                  {formQuestions && formQuestions.length > 0 && (
                    <div className="border-t pt-3 space-y-3">
                      <p className="text-xs font-medium text-slate-500">{t('applications.reviewForm', { name: reviewForm?.form_name })}</p>
                      {formQuestions.map((q: any) => (
                        <div key={q.id}>
                          <label className="block text-xs text-slate-500 mb-1">{q.question_text}{q.is_required && <span className="text-red-500">*</span>}</label>
                          {q.question_type === 'BOOLEAN' ? (
                            <select value={formAnswers[q.id]?.text || ''} onChange={e => setFormAnswers({ ...formAnswers, [q.id]: { ...formAnswers[q.id], text: e.target.value } })}
                              className="w-full p-2 border rounded text-sm">
                              <option value="">{t('projects.select')}</option><option value="YES">{t('common.yes')}</option><option value="NO">{t('common.no')}</option>
                            </select>
                          ) : q.question_type === 'SCALE' ? (
                            <div className="flex items-center gap-2">
                              <input type="range" min="1" max="10" value={formAnswers[q.id]?.score || 5} onChange={e => setFormAnswers({ ...formAnswers, [q.id]: { ...formAnswers[q.id], score: parseInt(e.target.value) } })}
                                className="flex-1" />
                              <span className="text-sm font-bold w-6 text-center">{formAnswers[q.id]?.score || 5}</span>
                            </div>
                          ) : (
                            <textarea value={formAnswers[q.id]?.text || ''} onChange={e => setFormAnswers({ ...formAnswers, [q.id]: { ...formAnswers[q.id], text: e.target.value } })}
                              className="w-full p-2 border rounded text-sm" rows={2} />
                          )}
                        </div>
                      ))}
                    </div>
                  )}

                  <Button type="submit" size="sm" className="w-full" disabled={submitting}>
                    {submitting ? t('applications.submitting') : t('applications.submitReview')}
                  </Button>
                </form>
              </CardContent>
            </Card>
          )}

          {(recommendations && recommendations.length > 0) && (
            <Card>
              <CardHeader><CardTitle className="text-sm">{t('applications.recommendations')}</CardTitle></CardHeader>
              <CardContent className="space-y-2">
                {recommendations.map((r: any) => (
                  <div key={r.id} className="text-sm border-b pb-2 last:border-0">
                    <div className="flex items-center gap-2">
                      <span className="font-medium">{r.reviewer_name}</span>
                      <StatusBadge status={r.recommendation_type} />
                    </div>
                    {r.justification && <p className="text-xs text-slate-500 mt-1">{r.justification}</p>}
                    <p className="text-xs text-slate-400">{new Date(r.created_at).toLocaleString()}</p>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}

          {(comments && comments.length > 0) && (
            <Card>
              <CardHeader><CardTitle className="text-sm">{t('applications.reviewComments')}</CardTitle></CardHeader>
              <CardContent className="space-y-2">
                {comments.map((c: any) => (
                  <div key={c.id} className="text-sm border-b pb-2 last:border-0">
                    <p className="font-medium">{c.reviewer_name}</p>
                    <p className="text-xs text-slate-600">{c.comment_text}</p>
                    <p className="text-xs text-slate-400">{new Date(c.created_at).toLocaleString()}</p>
                  </div>
                ))}
              </CardContent>
            </Card>
          )}
        </div>
      </div>
    </div>
  )
}
