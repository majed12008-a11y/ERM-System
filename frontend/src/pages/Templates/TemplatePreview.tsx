/*
 * صفحة معاينة وتوليد القالب: عرض الكود وإدخال المتغيرات ومعاينة الناتج.
 * تخطيط جانبي: كود القالب يسار، المعاينة يمين.
 * إضافة: وضع مباشر مع تحديث تلقائي.
 */
import { useState, useMemo } from 'react'
import { useQuery, useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useParams } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, FileOutput, Code2, Eye, Globe, Zap, AlertCircle, CheckCircle } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Input } from '../../components/ui/input'
import { templates } from '../../sdk/domains/templates.sdk'
import TemplateVariableInspector, { extractVariablesFromContent } from '../../components/TemplateVariableInspector'
import { useAuth } from '../../context/AuthContext'
import { useTemplateLivePreview } from '../../hooks/useTemplateLivePreview'
import type { TemplateVersion } from '../../sdk/domains/templates.sdk'

export default function TemplatePreview() {
  const { t } = useTranslation()
  const { templateCode } = useParams<{ templateCode: string }>()
  const { user } = useAuth()

  const [locale, setLocale] = useState('ar')
  const [liveMode, setLiveMode] = useState<'static' | 'live'>('static')
  const [staticVariables, setStaticVariables] = useState<Record<string, string>>({})
  const [previewHtml, setPreviewHtml] = useState<string>('')
  const [renderResult, setRenderResult] = useState<any>(null)

  const isAdmin = user?.roles?.some(r => ['SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'].includes(r))

  const { data: versionsRes, isLoading: versionsLoading } = useQuery({
    queryKey: ['template-versions-for-preview', templateCode],
    queryFn: () => templates.listVersions({ code: templateCode, page: 1, limit: 100 }).then(r => r.data),
    enabled: !!templateCode,
  })

  const versions = useMemo(() => (versionsRes?.data || []) as TemplateVersion[], [versionsRes])
  const approvedVersion = useMemo(() => versions.find(v => v.status === 'APPROVED') || versions[0], [versions])
  const [selectedVersion, setSelectedVersion] = useState<string>('')

  const activeVersion = useMemo(() => {
    if (selectedVersion) return versions.find(v => v.version === selectedVersion)
    return approvedVersion
  }, [selectedVersion, approvedVersion, versions])

  const variableDefs = useMemo(() => {
    return (activeVersion?.variable_definitions || []) as any[]
  }, [activeVersion])

  const templateContent = useMemo(() => {
    if (!activeVersion?.content) return ''
    return activeVersion.content[locale]?.body || activeVersion.content['ar']?.body || activeVersion.content['en']?.body || ''
  }, [activeVersion, locale])

  const mergedVariableDefs = useMemo(() => {
    const contentVars = extractVariablesFromContent(templateContent)
    const map = new Map<string, any>()
    for (const def of variableDefs) {
      map.set(def.code, {
        name: def.code,
        source_type: def.source_type || def.type || 'entity',
        resolver_key: def.resolver_key,
        default_value: def.default_value,
        required: def.required,
        validation: def.validation,
      })
    }
    for (const v of contentVars) {
      if (!map.has(v)) {
        map.set(v, { name: v, source_type: 'entity' })
      }
    }
    return Array.from(map.values()).sort((a, b) => a.name.localeCompare(b.name))
  }, [variableDefs, templateContent])

  const live = useTemplateLivePreview(
    templateCode || '',
    activeVersion?.version || '',
    locale,
  )

  const previewMutation = useMutation({
    mutationFn: () => templates.preview({
      templateCode: templateCode || '',
      version: activeVersion?.version || '',
      variables: staticVariables,
      locale,
    }),
    onSuccess: (res) => {
      setPreviewHtml(res.data.data.html)
      setRenderResult(res.data.data.renderResult)
    },
    onError: () => {
      toast.error(t('templates.preview.previewFailed'))
    },
  })

  const renderMutation = useMutation({
    mutationFn: () => templates.render({
      templateCode: templateCode || '',
      version: activeVersion?.version || '',
      variables: staticVariables,
      locale,
    }),
    onSuccess: (res) => {
      setPreviewHtml(res.data.data.html)
      setRenderResult(res.data.data.renderResult)
      toast.success(t('templates.preview.renderSuccess'))
    },
    onError: () => {
      toast.error(t('templates.preview.renderFailed'))
    },
  })

  function handleStaticVariableChange(code: string, value: string) {
    setStaticVariables(prev => ({ ...prev, [code]: value }))
  }

  const displayHtml = liveMode === 'live' ? live.renderedHtml : previewHtml
  const displayResult = liveMode === 'live' ? null : renderResult

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => window.history.back()} className="p-1 text-slate-400 hover:text-slate-600">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-2xl font-bold">{t('templates.preview.title')}</h1>
      </div>

      <div className="flex items-center gap-3 mb-4 flex-wrap">
        <div>
          <label className="block text-xs text-slate-500 mb-1">{t('templates.preview.version')}</label>
          <select
            value={selectedVersion || approvedVersion?.version || ''}
            onChange={(e) => setSelectedVersion(e.target.value)}
            className="p-2 border rounded text-sm"
          >
            {versions.map(v => (
              <option key={v.id} value={v.version}>
                v{v.version} ({t(`status.${v.status}`)})
              </option>
            ))}
          </select>
        </div>
        <div>
          <label className="block text-xs text-slate-500 mb-1">{t('templates.preview.locale')}</label>
          <div className="flex items-center gap-1">
            <Globe className="w-4 h-4 text-slate-400" />
            <select
              value={locale}
              onChange={(e) => setLocale(e.target.value)}
              className="p-2 border rounded text-sm"
            >
              <option value="ar">{t('templates.preview.arabic')}</option>
              <option value="en">{t('templates.preview.english')}</option>
            </select>
          </div>
        </div>
        <div>
          <label className="block text-xs text-slate-500 mb-1">&nbsp;</label>
          <div className="flex items-center border rounded overflow-hidden">
            <button
              onClick={() => setLiveMode('static')}
              className={`px-3 py-1.5 text-sm font-medium transition-colors ${liveMode === 'static' ? 'bg-slate-800 text-white' : 'bg-white text-slate-600 hover:bg-slate-50'}`}
            >
              <Code2 className="w-3 h-3 inline mr-1" /> {t('templates.preview.static')}
            </button>
            <button
              onClick={() => setLiveMode('live')}
              className={`px-3 py-1.5 text-sm font-medium transition-colors ${liveMode === 'live' ? 'bg-blue-600 text-white' : 'bg-white text-slate-600 hover:bg-slate-50'}`}
            >
              <Zap className="w-3 h-3 inline mr-1" /> {t('templates.preview.live')}
            </button>
          </div>
        </div>
      </div>

      {liveMode === 'live' && (
        <div className="mb-4 flex items-center gap-2 text-sm">
          {live.validationStatus === 'valid' && (
            <span className="flex items-center gap-1 text-green-600">
              <CheckCircle className="w-4 h-4" /> {t('templates.preview.validTemplate')}
            </span>
          )}
          {live.validationStatus === 'invalid' && (
            <span className="flex items-center gap-1 text-red-600">
              <AlertCircle className="w-4 h-4" /> {t('templates.preview.hasErrors')}
            </span>
          )}
          {live.validationStatus === 'idle' && live.content && (
            <span className="text-slate-400">{t('templates.preview.autoValidating')}</span>
          )}
        </div>
      )}

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-sm flex items-center gap-2">
                <Code2 className="w-4 h-4" /> {t('templates.preview.templateCode')}
              </CardTitle>
            </CardHeader>
            <CardContent>
              {versionsLoading ? (
                <div className="h-48 bg-slate-100 rounded animate-pulse" />
              ) : liveMode === 'live' ? (
                <textarea
                  value={live.content}
                  onChange={(e) => live.setContent(e.target.value)}
                  className="w-full bg-slate-900 text-green-400 rounded p-4 text-sm font-mono whitespace-pre-wrap overflow-x-auto h-80 resize-y border-0 focus:ring-0 focus:outline-none"
                  dir="rtl"
                  placeholder={t('templates.versionCreate.contentPlaceholder')}
                />
              ) : templateContent ? (
                <pre className="bg-slate-900 text-green-400 rounded p-4 text-sm font-mono whitespace-pre-wrap overflow-x-auto max-h-80 overflow-y-auto">
                  {templateContent}
                </pre>
              ) : (
                <p className="text-slate-400 text-sm">{t('templates.preview.noContent')}</p>
              )}
            </CardContent>
          </Card>

          {liveMode === 'live' ? (
            live.detectedVariables.length > 0 && (
              <Card>
                <CardHeader>
                  <CardTitle className="text-sm">{t('templates.preview.variables')}</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    {live.detectedVariables.map((varName) => (
                      <div key={varName}>
                        <label className="block text-xs text-slate-600 mb-1">
                          {'{{' + varName + '}}'}
                        </label>
                        <Input
                          value={live.variables[varName] || ''}
                          onChange={(e) => live.setVariable(varName, e.target.value)}
                          placeholder={varName}
                          className="text-sm"
                        />
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            )
          ) : (
            variableDefs.length > 0 && (
              <Card>
                <CardHeader>
                  <CardTitle className="text-sm">{t('templates.preview.variables')}</CardTitle>
                </CardHeader>
                <CardContent>
                  <div className="space-y-3">
                    {variableDefs.map((v: any) => (
                      <div key={v.code}>
                        <label className="block text-xs text-slate-600 mb-1">
                          {v.code}
                          {v.required && <span className="text-red-500 ml-1">*</span>}
                          {v.type && <span className="text-slate-400 ml-1">({v.type})</span>}
                        </label>
                        <Input
                          value={staticVariables[v.code] || v.default_value || ''}
                          onChange={(e) => handleStaticVariableChange(v.code, e.target.value)}
                          placeholder={v.default_value || v.code}
                          className="text-sm"
                        />
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            )
          )}
        </div>

        <div className="space-y-4">
          {liveMode === 'static' && (
            <div className="flex items-center gap-2">
              <Button
                size="sm"
                onClick={() => previewMutation.mutate()}
                disabled={!activeVersion || previewMutation.isPending}
              >
                <Eye className="w-3 h-3 mr-1" /> {t('templates.preview.previewBtn')}
              </Button>
              <Button
                size="sm"
                variant="outline"
                onClick={() => renderMutation.mutate()}
                disabled={!activeVersion || renderMutation.isPending}
              >
                <FileOutput className="w-3 h-3 mr-1" /> {t('templates.preview.renderBtn')}
              </Button>
            </div>
          )}

          <Card>
            <CardHeader>
              <CardTitle className="text-sm flex items-center gap-2">
                <Eye className="w-4 h-4" /> {t('templates.preview.result')}
                {liveMode === 'live' && (
                  <span className="ml-auto text-xs font-normal text-slate-400">
                    {live.isValidating && t('templates.preview.rendering')}
                  </span>
                )}
              </CardTitle>
            </CardHeader>
            <CardContent>
              {(liveMode === 'static' && (previewMutation.isPending || renderMutation.isPending)) && (
                <div className="h-48 bg-slate-100 rounded animate-pulse flex items-center justify-center">
                  <span className="text-sm text-slate-400">{t('common.loading')}</span>
                </div>
              )}
              {liveMode === 'live' && live.validationStatus === 'idle' && (
                <div className="h-48 bg-slate-50 rounded border-2 border-dashed flex items-center justify-center">
                  <p className="text-sm text-slate-400">{t('templates.preview.placeholder')}</p>
                </div>
              )}
              {liveMode === 'live' && live.errors.length > 0 && (
                <div className="h-48 bg-red-50 rounded border border-red-200 flex items-center justify-center p-4">
                  <div className="text-center">
                    <AlertCircle className="w-6 h-6 text-red-400 mx-auto mb-2" />
                    {live.errors.map((err, i) => (
                      <p key={i} className="text-xs text-red-600">{err}</p>
                    ))}
                  </div>
                </div>
              )}
              {displayHtml && (
                <div>
                  <div
                    className="border rounded p-4 bg-white min-h-[200px] prose prose-sm max-w-none"
                    dir={locale === 'ar' ? 'rtl' : 'ltr'}
                    dangerouslySetInnerHTML={{ __html: displayHtml }}
                  />
                  {displayResult && (
                    <div className="mt-3 text-xs text-slate-500 border-t pt-2 space-y-1">
                      <p>{t('templates.preview.resolutionTime')}: {displayResult.resolutionTimeMs}ms</p>
                      <p>{t('templates.preview.cacheHit')}: {displayResult.cacheHit ? t('common.yes') : t('common.no')}</p>
                      <p>{t('templates.preview.variableCount')}: {displayResult.variableCount}</p>
                    </div>
                  )}
                </div>
              )}
              {liveMode === 'static' && !previewMutation.isPending && !renderMutation.isPending && !previewHtml && (
                <div className="h-48 bg-slate-50 rounded border-2 border-dashed flex items-center justify-center">
                  <p className="text-sm text-slate-400">{t('templates.preview.placeholder')}</p>
                </div>
              )}
            </CardContent>
          </Card>
        </div>
      </div>

      {isAdmin && templateContent && mergedVariableDefs.length > 0 && (
        <div className="mt-6">
          <Card>
            <CardContent className="pt-4">
              <TemplateVariableInspector
                content={templateContent}
                variableDefinitions={mergedVariableDefs}
                resolvedValues={staticVariables}
                isAdmin={isAdmin}
              />
            </CardContent>
          </Card>
        </div>
      )}
    </div>
  )
}
