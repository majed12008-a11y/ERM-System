/*
 * صفحة إنشاء إصدار جديد للقالب: محرر المحتوى وتعريفات المتغيرات.
 * إضافة: معاينة مباشرة في وضع مقسّم.
 */
import { useState, useMemo } from 'react'
import { useQuery, useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useNavigate, useParams } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, Save, Plus, Trash2, Eye, EyeOff } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { templates } from '../../sdk/domains/templates.sdk'

interface VariableDef {
  code: string
  type: string
  required: boolean
  default_value: string
}

function detectTemplateVariables(content: string): string[] {
  const matches = content.match(/\{\{(\w+)\}\}/g) || []
  return [...new Set(matches.map(m => m.replace(/\{\{|\}\}/g, '')))]
}

export default function TemplateVersionCreate() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const { id } = useParams<{ id: string }>()

  const templateId = Number(id)

  const [version, setVersion] = useState('')
  const [contentAr, setContentAr] = useState('')
  const [contentEn, setContentEn] = useState('')
  const [changeSummary, setChangeSummary] = useState('')
  const [variables, setVariables] = useState<VariableDef[]>([])
  const [errors, setErrors] = useState<Record<string, string>>({})
  const [showPreview, setShowPreview] = useState(false)
  const [previewVariables, setPreviewVariables] = useState<Record<string, string>>({})

  const { data: template, isLoading: tplLoading } = useQuery({
    queryKey: ['template', templateId],
    queryFn: () => templates.get(templateId).then(r => r.data.data),
    enabled: !!templateId,
  })

  const detectedVars = useMemo(() => detectTemplateVariables(contentAr), [contentAr])

  const createMutation = useMutation({
    mutationFn: () => {
      const content: Record<string, { body: string }> = {}
      if (contentAr.trim()) content['ar'] = { body: contentAr }
      if (contentEn.trim()) content['en'] = { body: contentEn }

      return templates.createVersion({
        template_id: templateId,
        version,
        content,
        variable_definitions: variables.filter(v => v.code.trim()),
        change_summary: changeSummary || undefined,
      })
    },
    onSuccess: (res) => {
      toast.success(t('templates.versionCreate.success'))
      navigate(`/templates/versions/${res.data.data.id}`)
    },
    onError: (err: any) => {
      const msg = err?.response?.data?.error || t('templates.versionCreate.failed')
      toast.error(msg)
    },
  })

  function validate(): boolean {
    const e: Record<string, string> = {}
    if (!version.trim()) e.version = t('templates.versionCreate.versionRequired')
    if (!contentAr.trim() && !contentEn.trim()) e.content = t('templates.versionCreate.contentRequired')
    setErrors(e)
    return Object.keys(e).length === 0
  }

  function handleSubmit(ev: React.FormEvent) {
    ev.preventDefault()
    if (!validate()) return
    createMutation.mutate()
  }

  function addVariable() {
    setVariables(prev => [...prev, { code: '', type: 'string', required: false, default_value: '' }])
  }

  function removeVariable(index: number) {
    setVariables(prev => prev.filter((_, i) => i !== index))
  }

  function updateVariable(index: number, field: keyof VariableDef, value: any) {
    setVariables(prev => prev.map((v, i) => i === index ? { ...v, [field]: value } : v))
  }

  if (tplLoading) {
    return (
      <div className="space-y-4">
        <div className="h-8 bg-slate-100 rounded w-48 animate-pulse" />
        <div className="h-60 bg-slate-100 rounded animate-pulse" />
      </div>
    )
  }

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate(-1)} className="p-1 text-slate-400 hover:text-slate-600">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-2xl font-bold">{t('templates.versionCreate.title')}</h1>
        <div className="ml-auto">
          <Button
            size="sm"
            variant={showPreview ? 'default' : 'outline'}
            onClick={() => setShowPreview(!showPreview)}
          >
            {showPreview ? <EyeOff className="w-3 h-3 mr-1" /> : <Eye className="w-3 h-3 mr-1" />}
            {showPreview ? t('templates.preview.closePreview') : t('templates.preview.openPreview')}
          </Button>
        </div>
      </div>

      {template && (
        <div className="bg-blue-50 border border-blue-200 rounded p-3 mb-4 text-sm">
          <span className="text-slate-600">{t('templates.versionCreate.template')}:</span>{' '}
          <span className="font-semibold">{template.name_ar}</span>
          <span className="text-slate-400 ml-2">({template.code})</span>
        </div>
      )}

      <form onSubmit={handleSubmit} className={showPreview ? 'grid grid-cols-1 lg:grid-cols-2 gap-6' : 'space-y-4 max-w-4xl'}>
        <div className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-sm">{t('templates.versionCreate.basicInfo')}</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-700 mb-1">
                    {t('templates.versionCreate.versionNumber')} <span className="text-red-500">*</span>
                  </label>
                  <Input
                    value={version}
                    onChange={(e) => { setVersion(e.target.value); if (errors.version) setErrors(prev => ({ ...prev, version: '' })) }}
                    placeholder={t('templates.versionCreate.versionPlaceholder')}
                    className={errors.version ? 'border-red-500' : ''}
                  />
                  {errors.version && <p className="text-xs text-red-500 mt-1">{errors.version}</p>}
                </div>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  {t('templates.versionCreate.changeSummary')}
                </label>
                <textarea
                  value={changeSummary}
                  onChange={(e) => setChangeSummary(e.target.value)}
                  className="w-full border rounded p-2 text-sm"
                  rows={2}
                  placeholder={t('templates.versionCreate.changeSummaryPlaceholder')}
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <CardTitle className="text-sm">{t('templates.versionCreate.content')}</CardTitle>
            </CardHeader>
            <CardContent className="space-y-4">
              {errors.content && <p className="text-xs text-red-500">{errors.content}</p>}

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  {t('templates.versionCreate.contentAr')} <span className="text-red-500">*</span>
                </label>
                <textarea
                  value={contentAr}
                  onChange={(e) => { setContentAr(e.target.value); if (errors.content) setErrors(prev => ({ ...prev, content: '' })) }}
                  className="w-full border rounded p-3 text-sm font-mono"
                  rows={10}
                  dir="rtl"
                  placeholder={t('templates.versionCreate.contentPlaceholder')}
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  {t('templates.versionCreate.contentEn')}
                </label>
                <textarea
                  value={contentEn}
                  onChange={(e) => setContentEn(e.target.value)}
                  className="w-full border rounded p-3 text-sm font-mono"
                  rows={10}
                  placeholder={t('templates.versionCreate.contentPlaceholder')}
                />
              </div>
            </CardContent>
          </Card>

          <Card>
            <CardHeader>
              <div className="flex items-center justify-between">
                <CardTitle className="text-sm">{t('templates.versionCreate.variables')}</CardTitle>
                <Button type="button" size="sm" variant="outline" onClick={addVariable}>
                  <Plus className="w-3 h-3 mr-1" /> {t('templates.versionCreate.addVariable')}
                </Button>
              </div>
            </CardHeader>
            <CardContent>
              {variables.length === 0 ? (
                <p className="text-sm text-slate-400">{t('templates.versionCreate.noVariables')}</p>
              ) : (
                <div className="space-y-3">
                  {variables.map((v, i) => (
                    <div key={i} className="flex items-center gap-2 border rounded p-2">
                      <Input
                        value={v.code}
                        onChange={(e) => updateVariable(i, 'code', e.target.value)}
                        placeholder={t('templates.versionCreate.varCode')}
                        className="flex-1 text-sm"
                      />
                      <select
                        value={v.type}
                        onChange={(e) => updateVariable(i, 'type', e.target.value)}
                        className="p-2 border rounded text-sm"
                      >
                        <option value="string">String</option>
                        <option value="number">Number</option>
                        <option value="boolean">Boolean</option>
                        <option value="date">Date</option>
                      </select>
                      <label className="flex items-center gap-1 text-sm whitespace-nowrap">
                        <input
                          type="checkbox"
                          checked={v.required}
                          onChange={(e) => updateVariable(i, 'required', e.target.checked)}
                        />
                        {t('templates.versionCreate.required')}
                      </label>
                      <Input
                        value={v.default_value}
                        onChange={(e) => updateVariable(i, 'default_value', e.target.value)}
                        placeholder={t('templates.versionCreate.defaultValue')}
                        className="flex-1 text-sm"
                      />
                      <button type="button" onClick={() => removeVariable(i)} className="p-1 text-slate-400 hover:text-red-500">
                        <Trash2 className="w-4 h-4" />
                      </button>
                    </div>
                  ))}
                </div>
              )}
            </CardContent>
          </Card>

          <div className="flex items-center gap-3 pt-4 border-t">
            <Button type="submit" disabled={createMutation.isPending}>
              <Save className="w-4 h-4 mr-1" />
              {createMutation.isPending ? t('common.loading') : t('common.create')}
            </Button>
            <Button type="button" variant="outline" onClick={() => navigate(-1)}>
              {t('common.cancel')}
            </Button>
          </div>
        </div>

        {showPreview && (
          <div className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle className="text-sm flex items-center gap-2">
                  <Eye className="w-4 h-4" /> {t('templates.preview.title')}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                {detectedVars.length > 0 && (
                  <div>
                    <label className="block text-xs text-slate-500 mb-1">{t('templates.preview.variables')}</label>
                    <div className="space-y-2">
                      {detectedVars.map((varName) => (
                        <div key={varName}>
                          <label className="block text-xs text-slate-600 mb-0.5">
                            {'{{' + varName + '}}'}
                          </label>
                          <Input
                            value={previewVariables[varName] || ''}
                            onChange={(e) => setPreviewVariables(prev => ({ ...prev, [varName]: e.target.value }))}
                            placeholder={varName}
                            className="text-sm"
                          />
                        </div>
                      ))}
                    </div>
                  </div>
                )}

                <div className="border-t pt-3">
                  {contentAr ? (
                    <div
                      className="border rounded p-4 bg-white prose prose-sm max-w-none min-h-[200px]"
                      dir="rtl"
                      dangerouslySetInnerHTML={{
                        __html: contentAr.replace(/\{\{(\w+)\}\}/g, (_, name) =>
                          `<span class="bg-yellow-100 px-1 rounded text-yellow-800 font-mono text-xs">{{${name}}}</span>`
                        )
                      }}
                    />
                  ) : (
                    <div className="h-48 bg-slate-50 rounded border-2 border-dashed flex items-center justify-center">
                      <p className="text-sm text-slate-400">{t('templates.preview.placeholder')}</p>
                    </div>
                  )}
                </div>
              </CardContent>
            </Card>
          </div>
        )}
      </form>
    </div>
  )
}
