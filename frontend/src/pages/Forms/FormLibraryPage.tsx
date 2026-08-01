/*
 * صفحة مكتبة النماذج: عرض تعريفات النماذج مصنفة حسب الفئة،
 * وبدء تعبئة نموذج على كيان (طلب بحث).
 */
import { useMemo, useState } from 'react'
import { useQuery, useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import { FileText, Plus, ClipboardList } from 'lucide-react'
import api from '../../api/client'
import { createFormInstance, listFormDefinitions } from '../../api/forms'
import type { FormDefinition } from '../../components/forms/types'
import { Card, CardContent } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Badge } from '../../components/ui/badge'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter,
} from '../../components/ui/dialog'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import { AxiosError } from 'axios'

const CATEGORY_ORDER = ['SCREENING', 'REVIEW', 'SAFETY', 'MONITORING', 'CLOSURE', 'POST_APPROVAL', 'MEETING']

export default function FormLibraryPage() {
  const { t } = useTranslation()
  const navigate = useNavigate()

  const { data: definitions, isLoading } = useQuery({
    queryKey: ['form-definitions'],
    queryFn: listFormDefinitions,
  })

  const [fillTarget, setFillTarget] = useState<FormDefinition | null>(null)
  const [entityId, setEntityId] = useState<string>('')

  const { data: applications } = useQuery({
    queryKey: ['applications-for-forms'],
    queryFn: () => api.get('/core/applications').then((r) => r.data.data || []),
    enabled: !!fillTarget,
  })

  const createInstance = useMutation({
    mutationFn: ({ code, id }: { code: string; id: number }) =>
      createFormInstance({ form_code: code, entity_type: 'Application', entity_id: id }),
    onSuccess: (instance) => {
      toast.success(t('formLibrary.instanceCreated'))
      setFillTarget(null)
      navigate(`/forms/fill/${instance.id}`)
    },
    onError: (err: AxiosError<{ error?: string }>) =>
      toast.error(err.response?.data?.error || t('formLibrary.instanceFailed')),
  })

  const grouped = useMemo(() => {
    const map = new Map<string, FormDefinition[]>()
    for (const def of definitions || []) {
      const list = map.get(def.category) || []
      list.push(def)
      map.set(def.category, list)
    }
    return map
  }, [definitions])

  if (isLoading) return <PageSkeleton />

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <ClipboardList className="w-6 h-6 text-blue-600" />
        <h1 className="text-2xl font-bold">{t('formLibrary.title')}</h1>
      </div>

      {definitions && definitions.length > 0 ? (
        <div className="space-y-8">
          {CATEGORY_ORDER.filter((c) => grouped.has(c)).map((category) => (
            <section key={category}>
              <h2 className="text-lg font-semibold text-slate-700 mb-3 flex items-center gap-2">
                <FileText className="w-4 h-4 text-slate-400" />
                {t(`formLibrary.categories.${category}`)}
              </h2>
              <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
                {(grouped.get(category) || []).map((def) => (
                  <Card key={def.id} className="hover:shadow-md transition-shadow">
                    <CardContent className="p-4 flex flex-col gap-2 h-full">
                      <div className="flex items-start justify-between gap-2">
                        <div>
                          <p className="font-medium text-sm">{def.form_name_ar}</p>
                          {def.form_name_en && (
                            <p className="text-xs text-slate-400">{def.form_name_en}</p>
                          )}
                        </div>
                        <Badge variant="outline" className="shrink-0">{def.form_code}</Badge>
                      </div>
                      <div className="flex items-center gap-2 text-xs text-slate-500 mt-1">
                        <span>{t('formLibrary.version')} v{def.version_no}</span>
                        {def.workflow_stage && <span>• {def.workflow_stage}</span>}
                      </div>
                      <div className="mt-auto pt-2">
                        <Button
                          size="sm"
                          className="w-full"
                          onClick={() => { setFillTarget(def); setEntityId('') }}
                        >
                          <Plus className="w-3 h-3 ms-1" /> {t('formLibrary.fill')}
                        </Button>
                      </div>
                    </CardContent>
                  </Card>
                ))}
              </div>
            </section>
          ))}
        </div>
      ) : (
        <p className="text-slate-400">{t('formLibrary.empty')}</p>
      )}

      <Dialog open={!!fillTarget} onOpenChange={(o) => { if (!o) setFillTarget(null) }}>
        <DialogContent>
          <DialogHeader>
            <DialogTitle className="text-base">{t('formLibrary.createInstanceTitle')}</DialogTitle>
          </DialogHeader>
          {fillTarget && (
            <div className="space-y-4">
              <div className="rounded-md bg-slate-50 p-3 text-sm">
                <p className="font-medium">{fillTarget.form_name_ar}</p>
                <p className="text-xs text-slate-500">{fillTarget.form_code} • v{fillTarget.version_no}</p>
              </div>
              <div className="space-y-1.5">
                <Label className="text-sm">{t('formLibrary.entityType')}</Label>
                <Input value={t('formLibrary.entityApplication')} disabled className="text-sm" />
              </div>
              <div className="space-y-1.5">
                <Label className="text-sm">{t('formLibrary.entityId')}</Label>
                <select
                  value={entityId}
                  onChange={(e) => setEntityId(e.target.value)}
                  className="flex h-9 w-full items-center rounded-md border border-input bg-white px-3 py-2 text-sm shadow-sm focus:outline-none focus:ring-1 focus:ring-ring"
                >
                  <option value="">{t('formLibrary.selectApplication')}</option>
                  {(applications || []).map((app: { id: number; application_number?: string; project_title?: string; title?: string }) => (
                    <option key={app.id} value={String(app.id)}>
                      {app.application_number || `#${app.id}`} — {app.project_title || app.title || ''}
                    </option>
                  ))}
                </select>
              </div>
            </div>
          )}
          <DialogFooter>
            <Button
              size="sm"
              disabled={!entityId || createInstance.isPending}
              onClick={() => fillTarget && createInstance.mutate({ code: fillTarget.form_code, id: Number(entityId) })}
            >
              {t('formLibrary.start')}
            </Button>
            <Button size="sm" variant="outline" onClick={() => setFillTarget(null)}>
              {t('common.cancel')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  )
}
