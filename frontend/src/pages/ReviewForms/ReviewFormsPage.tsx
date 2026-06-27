/*
 * صفحة نماذج المراجعة: إدارة نماذج مراجعة الطلبات،
 * الأسئلة، والتقييمات.
 */
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { toast } from 'sonner'
import api from '../../api/client'
import ConfirmDialog from '../../components/ConfirmDialog'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { Textarea } from '../../components/ui/textarea'
import { reviewFormSchema, addQuestionSchema } from '../../lib/schemas'
import { z } from 'zod'
import { ClipboardList, Plus, Trash2, ChevronDown, ChevronRight } from 'lucide-react'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import { useTranslation } from 'react-i18next'

type FormFormData = z.input<typeof reviewFormSchema>
type QuestionFormData = z.input<typeof addQuestionSchema>

export default function ReviewFormsPage() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const [expandedForm, setExpandedForm] = useState<number | null>(null)
  const [showCreateForm, setShowCreateForm] = useState(false)
  const [addingQuestion, setAddingQuestion] = useState<number | null>(null)

  const formForm = useForm<FormFormData>({
    resolver: zodResolver(reviewFormSchema),
    defaultValues: { form_code: '', form_name: '', review_type: 'ETHICS' },
  })
  const questionForm = useForm<QuestionFormData>({
    resolver: zodResolver(addQuestionSchema),
    defaultValues: { question_code: '', question_text: '', question_type: 'TEXT', is_required: true, question_options: '' },
  })

  const { data: forms, isLoading } = useQuery({
    queryKey: ['review-forms'],
    queryFn: () => api.get('/committee/reviews/forms').then(r => r.data.data),
  })

  const { data: questions } = useQuery({
    queryKey: ['form-questions', expandedForm],
    queryFn: () => api.get(`/committee/reviews/forms/${expandedForm}/questions`).then(r => r.data.data),
    enabled: !!expandedForm,
  })

  const createFormMut = useMutation({
    mutationFn: (data: any) => api.post('/committee/reviews/forms', data),
    onSuccess: () => { toast.success(t('reviewForms.created')); queryClient.invalidateQueries({ queryKey: ['review-forms'] }); setShowCreateForm(false); formForm.reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('reviewForms.createFailed')),
  })

  const addQuestionMut = useMutation({
    mutationFn: (data: any) => api.post(`/committee/reviews/forms/${expandedForm}/questions`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['form-questions'] }); setAddingQuestion(null); questionForm.reset() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('reviewForms.addQuestionFailed')),
  })

  const [deleteTarget, setDeleteTarget] = useState<number | null>(null)
  const deleteQuestionMut = useMutation({
    mutationFn: (id: number) => api.delete(`/committee/reviews/forms/${expandedForm}/questions/${id}`),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['form-questions'] }); setDeleteTarget(null) },
  })

  function onCreateForm(data: FormFormData) {
    createFormMut.mutate(data)
  }

  function onAddQuestion(data: QuestionFormData) {
    addQuestionMut.mutate(data)
  }

  if (isLoading) return <PageSkeleton />

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <ClipboardList className="w-6 h-6 text-blue-600" />
          <h1 className="text-2xl font-bold">{t('reviewForms.title')}</h1>
        </div>
        <Button size="sm" onClick={() => setShowCreateForm(true)}><Plus className="w-3 h-3 mr-1" /> {t('reviewForms.new')}</Button>
      </div>

      {showCreateForm && (
        <Card className="mb-6">
          <CardHeader><CardTitle className="text-sm">{t('reviewForms.create')}</CardTitle></CardHeader>
          <CardContent>
            <form onSubmit={formForm.handleSubmit(onCreateForm)} className="space-y-3">
              <div className="grid grid-cols-3 gap-3">
                <div><Input placeholder={t('reviewForms.codePlaceholder')} {...formForm.register('form_code')} className="text-sm" />{formForm.formState.errors.form_code && <p className="text-red-500 text-xs">{formForm.formState.errors.form_code.message}</p>}</div>
                <div><Input placeholder={t('reviewForms.namePlaceholder')} {...formForm.register('form_name')} className="text-sm" />{formForm.formState.errors.form_name && <p className="text-red-500 text-xs">{formForm.formState.errors.form_name.message}</p>}</div>
                <select {...formForm.register('review_type')} className="p-2 border rounded text-sm">
                  <option value="ETHICS">{t('reviewForms.ethicsReview')}</option>
                  <option value="SCIENTIFIC">{t('reviewForms.scientificReview')}</option>
                </select>
              </div>
              <div className="flex gap-2">
                <Button size="sm" type="submit" disabled={createFormMut.isPending}>{t('common.create')}</Button>
                <Button size="sm" variant="outline" type="button" onClick={() => setShowCreateForm(false)}>{t('common.cancel')}</Button>
              </div>
            </form>
          </CardContent>
        </Card>
      )}

      <div className="space-y-3">
        {forms && forms.length > 0 ? forms.map((f: any) => (
          <Card key={f.id}>
            <CardContent className="p-4">
              <div className="flex items-center justify-between cursor-pointer" onClick={() => setExpandedForm(expandedForm === f.id ? null : f.id)}>
                <div className="flex items-center gap-3">
                  {expandedForm === f.id ? <ChevronDown className="w-4 h-4 text-slate-400" /> : <ChevronRight className="w-4 h-4 text-slate-400" />}
                  <div>
                    <p className="font-medium text-sm">{f.form_name}</p>
                    <p className="text-xs text-slate-400">{f.form_code} • v{f.version_no} • {f.review_type} • {t('reviewForms.questions', { count: f.question_count })}</p>
                  </div>
                </div>
                <span className={`text-xs px-2 py-0.5 rounded ${f.is_active ? 'bg-green-100 text-green-700' : 'bg-slate-100 text-slate-500'}`}>
                  {f.is_active ? t('reviewForms.active') : t('reviewForms.inactive')}
                </span>
              </div>

              {expandedForm === f.id && (
                <div className="mt-4 pt-3 border-t">
                  {questions && questions.length > 0 ? (
                    <div className="space-y-2 mb-3">
                      {questions.map((q: any) => (
                        <div key={q.id} className="flex items-center justify-between text-sm border-b pb-1 last:border-0">
                          <div className="flex items-center gap-2">
                            <span className="text-xs text-slate-400 w-6">#{q.display_order}</span>
                            <span className="font-medium">{q.question_text}</span>
                            <span className="text-xs text-slate-400 bg-slate-100 px-1.5 py-0.5 rounded">{q.question_type}</span>
                            {q.is_required && <span className="text-xs text-red-500">*</span>}
                          </div>
                          <button onClick={() => setDeleteTarget(q.id)} className="text-slate-300 hover:text-red-500">
                            <Trash2 className="w-3.5 h-3.5" />
                          </button>
                        </div>
                      ))}
                    </div>
                  ) : <p className="text-sm text-slate-400 mb-3">{t('reviewForms.noQuestions')}</p>}

                  {addingQuestion === f.id ? (
                    <form onSubmit={questionForm.handleSubmit(onAddQuestion)} className="border-t pt-2 space-y-2">
                      <div className="flex gap-2 items-center">
                        <Input size={12} placeholder={t('reviewForms.questionCode')} {...questionForm.register('question_code')} className="text-xs w-24" />
                        <Input size={30} placeholder={t('reviewForms.questionText')} {...questionForm.register('question_text')} className="text-xs flex-1" />
                        <select {...questionForm.register('question_type')} className="p-1.5 border rounded text-xs">
                          <option value="TEXT">{t('reviewForms.text')}</option>
                          <option value="SCALE">{t('reviewForms.scale')}</option>
                          <option value="BOOLEAN">{t('reviewForms.yesNo')}</option>
                          <option value="CHOICE">{t('reviewForms.choice')}</option>
                        </select>
                        <label className="flex items-center gap-1 text-xs whitespace-nowrap"><input type="checkbox" {...questionForm.register('is_required')} /> {t('reviewForms.required')}</label>
                        <Button size="sm" type="submit" disabled={addQuestionMut.isPending}>{t('common.add')}</Button>
                        <button type="button" className="text-xs text-slate-400" onClick={() => setAddingQuestion(null)}>{t('common.cancel')}</button>
                      </div>
                      {questionForm.watch('question_type') === 'CHOICE' && (
                        <Textarea
                          placeholder={t('reviewForms.optionsPlaceholder')}
                          {...questionForm.register('question_options')}
                          className="text-xs"
                          rows={3}
                        />
                      )}
                    </form>
                  ) : (
                    <button className="text-xs text-blue-600 hover:underline mt-2 inline-block" onClick={() => { setAddingQuestion(f.id); questionForm.reset() }}>
                      {t('reviewForms.addQuestion')}
                    </button>
                  )}
                </div>
              )}
            </CardContent>
          </Card>
        )) : <p className="text-slate-400">{t('reviewForms.empty')}</p>}
      </div>

      <ConfirmDialog
        open={deleteTarget !== null}
        onOpenChange={(o) => { if (!o) setDeleteTarget(null) }}
        title={t('reviewForms.deleteQuestionTitle')}
        description={t('reviewForms.deleteQuestionConfirm')}
        onConfirm={() => deleteTarget && deleteQuestionMut.mutate(deleteTarget)}
        loading={deleteQuestionMut.isPending}
      />
    </div>
  )
}