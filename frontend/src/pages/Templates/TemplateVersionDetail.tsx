/*
 * صفحة تفاصيل الإصدار: محتوى القالب، المتغيرات، سجل التدقيق، وأزرار سرعة الحالة.
 * إضافات المرحلة الثالثة: مقارنة الإصدارات، تكرار الإصدار، اللقطات، سجل الاعتماد.
 * إضافات المرحلة الرابعة: لوحة معاينة مباشرة.
 */
import { useState, useEffect } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useNavigate, useParams } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, Clock, Send, CheckCircle, XCircle, Trash2, Archive, Eye, Code2, ListChecks, History, AlertCircle, RefreshCw, Copy, GitCompare, Camera, ShieldCheck, PanelRightOpen, PanelRightClose, Zap, Search } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Input } from '../../components/ui/input'
import ConfirmDialog from '../../components/ConfirmDialog'
import { useAuth } from '../../context/AuthContext'
import { templates } from '../../sdk/domains/templates.sdk'
import TemplateVariableInspector from '../../components/TemplateVariableInspector'
import { useTemplateLivePreview } from '../../hooks/useTemplateLivePreview'
import { cn } from '../../lib/utils'
import type { AuditEntry, TemplateVersion, TemplateSnapshot } from '../../sdk/domains/templates.sdk'

const STATUS_STYLES: Record<string, string> = {
  DRAFT: 'bg-slate-100 text-slate-600',
  REVIEW: 'bg-amber-100 text-amber-700',
  APPROVED: 'bg-green-100 text-green-700',
  DEPRECATED: 'bg-orange-100 text-orange-700',
  ARCHIVED: 'bg-red-100 text-red-600',
}

export default function TemplateVersionDetail() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const { versionId } = useParams<{ versionId: string }>()
  const { user } = useAuth()
  const queryClient = useQueryClient()

  const [confirmAction, setConfirmAction] = useState<{ type: string } | null>(null)
  const [rejectReason, setRejectReason] = useState('')
  const [activeTab, setActiveTab] = useState<'info' | 'history' | 'snapshots' | 'compare'>('info')
  const [compareVersionId, setCompareVersionId] = useState<number | ''>('')
  const [previewOpen, setPreviewOpen] = useState(false)
  const [inspectorOpen, setInspectorOpen] = useState(false)

  const verId = Number(versionId)

  const { data: version, isLoading, isError, refetch } = useQuery({
    queryKey: ['template-version', verId],
    queryFn: () => templates.getVersion(verId).then(r => r.data.data),
    enabled: !!verId,
  })

  const { data: templateForHistory } = useQuery({
    queryKey: ['template-for-history', version?.template_id],
    queryFn: () => templates.get(version!.template_id).then(r => r.data.data),
    enabled: !!version?.template_id,
  })

  const { data: history } = useQuery({
    queryKey: ['template-history', version?.version, templateForHistory?.code],
    queryFn: () => templates.getHistory({ templateCode: templateForHistory!.code, version: version!.version }).then(r => r.data.data),
    enabled: !!version && !!templateForHistory,
  })

  const { data: snapshots } = useQuery({
    queryKey: ['template-version-snapshots', verId],
    queryFn: () => templates.getSnapshots({ templateVersionId: verId }).then(r => r.data.data),
    enabled: activeTab === 'snapshots' && !!verId,
  })

  const { data: versions } = useQuery({
    queryKey: ['template-other-versions', version?.template_id],
    queryFn: () => templates.listVersions({ template_id: version!.template_id, page: 1, limit: 100 }).then(r => r.data.data),
    enabled: activeTab === 'compare' && !!version?.template_id,
  })

  const { data: compareVersion } = useQuery({
    queryKey: ['template-compare-version', compareVersionId],
    queryFn: () => templates.getVersion(Number(compareVersionId)).then(r => r.data.data),
    enabled: !!compareVersionId,
  })

  const isAdmin = user?.roles?.some(r => ['SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'].includes(r))

  const livePreview = useTemplateLivePreview(
    version ? String(version.template_id) : '',
    version?.version || '',
    'ar',
  )

  useEffect(() => {
    if (version && !livePreview.content) {
      const body = version.content?.['ar']?.body || version.content?.['en']?.body || ''
      livePreview.setContent(body)
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [version])

  const submitMutation = useMutation({
    mutationFn: () => templates.submitVersion(verId),
    onSuccess: () => {
      toast.success(t('templates.detail.submitted'))
      queryClient.invalidateQueries({ queryKey: ['template-version', verId] })
      setConfirmAction(null)
    },
  })

  const approveMutation = useMutation({
    mutationFn: () => templates.approveVersion(verId),
    onSuccess: () => {
      toast.success(t('templates.detail.approved'))
      queryClient.invalidateQueries({ queryKey: ['template-version', verId] })
      setConfirmAction(null)
    },
  })

  const rejectMutation = useMutation({
    mutationFn: () => templates.rejectVersion(verId, rejectReason),
    onSuccess: () => {
      toast.success(t('templates.detail.rejected'))
      queryClient.invalidateQueries({ queryKey: ['template-version', verId] })
      setConfirmAction(null)
      setRejectReason('')
    },
  })

  const deprecateMutation = useMutation({
    mutationFn: () => templates.deprecateVersion(verId),
    onSuccess: () => {
      toast.success(t('templates.detail.deprecated'))
      queryClient.invalidateQueries({ queryKey: ['template-version', verId] })
      setConfirmAction(null)
    },
  })

  const archiveMutation = useMutation({
    mutationFn: () => templates.archiveVersion(verId),
    onSuccess: () => {
      toast.success(t('templates.detail.archived'))
      queryClient.invalidateQueries({ queryKey: ['template-version', verId] })
      setConfirmAction(null)
    },
  })

  const duplicateMutation = useMutation({
    mutationFn: () => {
      if (!version) throw new Error('No version')
      const nextVer = version.version.split('.').map(Number)
      const newVersion = nextVer.length > 1 ? `${nextVer[0]}.${(nextVer[1] || 0) + 1}` : `${parseInt(version.version) + 1}`
      return templates.createVersion({
        template_id: version.template_id,
        version: newVersion,
        content: version.content,
        variable_definitions: version.variable_definitions?.map(v => ({ ...v })),
        change_summary: `Duplicated from v${version.version}`,
      })
    },
    onSuccess: (res) => {
      toast.success(t('templates.detail.duplicated'))
      navigate(`/templates/versions/${res.data.data.id}`)
    },
  })

  const snapshotsList = (snapshots || []) as TemplateSnapshot[]
  const versionsList = (versions || []) as TemplateVersion[]
  const otherVersions = versionsList.filter(v => v.id !== verId)
  const compareVersionData = compareVersion as TemplateVersion | undefined

  function renderDiffRows() {
    if (!version || !compareVersionData) return null
    const props: { label: string; a: string; b: string }[] = [
      {
        label: t('templates.version.status'),
        a: t(`status.${version.status}`),
        b: t(`status.${compareVersionData.status}`),
      },
      {
        label: t('templates.version.version'),
        a: `v${version.version}`,
        b: `v${compareVersionData.version}`,
      },
      {
        label: t('templates.version.effectiveFrom'),
        a: version.effective_from ? new Date(version.effective_from).toLocaleDateString() : '—',
        b: compareVersionData.effective_from ? new Date(compareVersionData.effective_from).toLocaleDateString() : '—',
      },
      {
        label: t('templates.version.effectiveUntil'),
        a: version.effective_until ? new Date(version.effective_until).toLocaleDateString() : '—',
        b: compareVersionData.effective_until ? new Date(compareVersionData.effective_until).toLocaleDateString() : '—',
      },
      {
        label: t('templates.version.hash'),
        a: version.content_hash?.substring(0, 16) || '—',
        b: compareVersionData.content_hash?.substring(0, 16) || '—',
      },
    ]

    const varsA = version.variable_definitions?.length || 0
    const varsB = compareVersionData.variable_definitions?.length || 0
    props.push({
      label: t('templates.version.variables'),
      a: `${varsA} variable(s): ${(version.variable_definitions || []).map((v: { code: string }) => v.code).join(', ') || '—'}`,
      b: `${varsB} variable(s): ${(compareVersionData.variable_definitions || []).map((v: { code: string }) => v.code).join(', ') || '—'}`,
    })

    const contentA = version.content?.['ar']?.body?.substring(0, 100) || version.content?.['en']?.body?.substring(0, 100) || '—'
    const contentB = compareVersionData.content?.['ar']?.body?.substring(0, 100) || compareVersionData.content?.['en']?.body?.substring(0, 100) || '—'
    props.push({
      label: t('templates.version.content'),
      a: contentA.length > 80 ? contentA.substring(0, 80) + '...' : contentA,
      b: contentB.length > 80 ? contentB.substring(0, 80) + '...' : contentB,
    })

    return props.map((p, i) => (
      <tr key={i} className={cn('border-b text-sm', p.a !== p.b ? 'bg-amber-50' : '')}>
        <td className="py-2 pr-4 font-medium text-slate-600">{p.label}</td>
        <td className="py-2 pr-4 text-slate-800">{p.a}</td>
        <td className="py-2 pr-4 text-slate-800">{p.b}</td>
      </tr>
    ))
  }

  if (isLoading) {
    return (
      <div className="space-y-4">
        <div className="h-8 bg-slate-100 rounded w-48 animate-pulse" />
        <div className="h-40 bg-slate-100 rounded animate-pulse" />
        <div className="h-60 bg-slate-100 rounded animate-pulse" />
      </div>
    )
  }

  if (isError || !version) {
    return (
      <div className="flex flex-col items-center justify-center p-12 text-center">
        <AlertCircle className="w-10 h-10 text-red-400 mb-3" />
        <p className="text-sm text-slate-600 mb-3">{t('common.error')}</p>
        <Button variant="outline" size="sm" onClick={() => refetch()}>
          <RefreshCw className="w-3 h-3 mr-1" /> {t('common.retry')}
        </Button>
      </div>
    )
  }

  const contentBody = version.content?.['ar']?.body || version.content?.['en']?.body || ''

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate(-1)} className="p-1 text-slate-400 hover:text-slate-600">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-2xl font-bold">
          {t('templates.version.title')} — <span className="font-mono">v{version.version}</span>
        </h1>
        <span className={cn('text-xs px-2 py-1 rounded', STATUS_STYLES[version.status])}>
          {t(`status.${version.status}`)}
        </span>
      </div>

      {/* Tabs */}
      <div className="flex items-center gap-1 mb-4 border-b">
        <button
          onClick={() => setActiveTab('info')}
          className={cn('px-4 py-2 text-sm font-medium border-b-2 transition-colors', activeTab === 'info' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700')}
        >
          <Code2 className="w-4 h-4 inline mr-1" /> {t('templates.version.metadata')}
        </button>
        <button
          onClick={() => setActiveTab('history')}
          className={cn('px-4 py-2 text-sm font-medium border-b-2 transition-colors', activeTab === 'history' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700')}
        >
          <History className="w-4 h-4 inline mr-1" /> {t('templates.detail.approvalHistory')}
        </button>
        <button
          onClick={() => setActiveTab('snapshots')}
          className={cn('px-4 py-2 text-sm font-medium border-b-2 transition-colors', activeTab === 'snapshots' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700')}
        >
          <Camera className="w-4 h-4 inline mr-1" /> {t('templates.detail.snapshotHistory')}
        </button>
        <button
          onClick={() => setActiveTab('compare')}
          className={cn('px-4 py-2 text-sm font-medium border-b-2 transition-colors', activeTab === 'compare' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700')}
        >
          <GitCompare className="w-4 h-4 inline mr-1" /> {t('templates.detail.compareVersions')}
        </button>
        <div className="ml-auto">
          <button
            onClick={() => setPreviewOpen(!previewOpen)}
            className={cn('px-4 py-2 text-sm font-medium border-b-2 transition-colors', previewOpen ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700')}
          >
            {previewOpen ? <PanelRightClose className="w-4 h-4 inline mr-1" /> : <PanelRightOpen className="w-4 h-4 inline mr-1" />}
            {previewOpen ? t('templates.preview.closePreview') : t('templates.preview.openPreview')}
          </button>
        </div>
      </div>

      <div className={cn('grid grid-cols-1 gap-6', previewOpen ? 'lg:grid-cols-4' : 'lg:grid-cols-3')}>
        {/* Main content */}
        <div className="lg:col-span-2 space-y-4">
          {activeTab === 'info' && (
            <>
              <Card>
                <CardHeader>
                  <CardTitle className="text-sm flex items-center gap-2">
                    <Clock className="w-4 h-4" /> {t('templates.version.metadata')}
                  </CardTitle>
                </CardHeader>
                <CardContent className="text-sm space-y-2">
                  <div className="grid grid-cols-2 gap-4">
                    <div>
                      <span className="text-slate-500">{t('templates.version.version')}:</span>
                      <span className="ml-2 font-mono font-semibold">{version.version}</span>
                    </div>
                    <div>
                      <span className="text-slate-500">{t('templates.version.status')}:</span>
                      <span className={cn('ml-2 text-xs px-2 py-0.5 rounded', STATUS_STYLES[version.status])}>
                        {t(`status.${version.status}`)}
                      </span>
                    </div>
                    <div>
                      <span className="text-slate-500">{t('templates.version.created')}:</span>
                      <span className="ml-2">{new Date(version.created_at).toLocaleString()}</span>
                    </div>
                    <div>
                      <span className="text-slate-500">{t('templates.version.hash')}:</span>
                      <span className="ml-2 font-mono text-xs">{version.content_hash?.substring(0, 16) || '—'}</span>
                    </div>
                    {version.effective_from && (
                      <div>
                        <span className="text-slate-500">{t('templates.version.effectiveFrom')}:</span>
                        <span className="ml-2">{new Date(version.effective_from).toLocaleDateString()}</span>
                      </div>
                    )}
                    {version.effective_until && (
                      <div>
                        <span className="text-slate-500">{t('templates.version.effectiveUntil')}:</span>
                        <span className="ml-2">{new Date(version.effective_until).toLocaleDateString()}</span>
                      </div>
                    )}
                    {version.approved_by && (
                      <div>
                        <span className="text-slate-500">{t('templates.version.approvedBy')}:</span>
                        <span className="ml-2">#{version.approved_by}</span>
                      </div>
                    )}
                    {version.approved_at && (
                      <div>
                        <span className="text-slate-500">{t('templates.version.approvedAt')}:</span>
                        <span className="ml-2">{new Date(version.approved_at).toLocaleString()}</span>
                      </div>
                    )}
                  </div>
                  {version.change_summary && (
                    <div className="border-t pt-2 mt-2">
                      <span className="text-slate-500">{t('templates.version.changeSummary')}:</span>
                      <p className="mt-1">{version.change_summary}</p>
                    </div>
                  )}
                </CardContent>
              </Card>

              <Card>
                <CardHeader>
                  <CardTitle className="text-sm flex items-center gap-2">
                    <Code2 className="w-4 h-4" /> {t('templates.version.content')}
                  </CardTitle>
                </CardHeader>
                <CardContent>
                  {contentBody ? (
                    <pre className="bg-slate-50 border rounded p-4 text-sm font-mono whitespace-pre-wrap overflow-x-auto max-h-96">
                      {contentBody}
                    </pre>
                  ) : (
                    <p className="text-slate-400 text-sm">{t('templates.version.noContent')}</p>
                  )}
                </CardContent>
              </Card>

              {version.variable_definitions && version.variable_definitions.length > 0 && (
                <Card>
                  <CardHeader>
                    <CardTitle className="text-sm flex items-center gap-2">
                      <ListChecks className="w-4 h-4" /> {t('templates.version.variables')}
                    </CardTitle>
                  </CardHeader>
                  <CardContent>
                    <div className="space-y-2">
                      {version.variable_definitions.map((v: { code: string; type?: string; required?: boolean }, i: number) => (
                        <div key={i} className="flex items-center justify-between text-sm border-b pb-1 last:border-0">
                          <span className="font-mono text-slate-800">{v.code}</span>
                          <div className="flex items-center gap-2">
                            <span className="text-xs text-slate-500">{v.type || 'string'}</span>
                            {v.required && <span className="text-xs text-red-500">*</span>}
                          </div>
                        </div>
                      ))}
                    </div>
                  </CardContent>
                </Card>
              )}
            </>
          )}

          {activeTab === 'history' && (
            <Card>
              <CardHeader>
                <CardTitle className="text-sm flex items-center gap-2">
                  <History className="w-4 h-4" /> {t('templates.detail.approvalHistory')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {!history || history.length === 0 ? (
                  <p className="text-sm text-slate-400">{t('templates.detail.noApprovalHistory')}</p>
                ) : (
                  <div className="space-y-3">
                    {(history as AuditEntry[]).map((entry: AuditEntry) => (
                      <div key={entry.id} className="flex items-start gap-3 text-sm border-b pb-2 last:border-0">
                        <div className="w-2 h-2 rounded-full bg-blue-500 mt-1.5 flex-shrink-0" />
                        <div className="flex-1">
                          <p>
                            <span className="font-medium">{t('templates.detail.action')}:</span>{' '}
                            <span className="text-slate-600">{entry.action}</span>
                          </p>
                          <p className="text-xs text-slate-500">
                            <span className="font-medium">{t('templates.detail.actor')}:</span> #{entry.actor_id}
                          </p>
                          {entry.previous_status && entry.new_status && (
                            <p className="text-xs text-slate-500">
                              {t('templates.detail.fromStatus')}: {t(`status.${entry.previous_status}`)} → {t('templates.detail.toStatus')}: {t(`status.${entry.new_status}`)}
                            </p>
                          )}
                          {entry.comment && <p className="text-xs text-slate-500 italic mt-1">{t('templates.detail.comment')}: {entry.comment}</p>}
                        </div>
                        <span className="text-xs text-slate-400 flex-shrink-0">
                          {new Date(entry.created_at).toLocaleString()}
                        </span>
                      </div>
                    ))}
                  </div>
                )}
              </CardContent>
            </Card>
          )}

          {activeTab === 'snapshots' && (
            <Card>
              <CardHeader>
                <CardTitle className="text-sm flex items-center gap-2">
                  <Camera className="w-4 h-4" /> {t('templates.detail.snapshotHistory')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                {snapshotsList.length === 0 ? (
                  <p className="text-sm text-slate-400">{t('templates.detail.noSnapshots')}</p>
                ) : (
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                      <thead>
                        <tr className="border-b text-left text-slate-500">
                          <th className="py-2 pr-4">{t('templates.detail.renderedAt')}</th>
                          <th className="py-2 pr-4">{t('templates.detail.renderedBy')}</th>
                          <th className="py-2 pr-4">{t('templates.detail.locale')}</th>
                          <th className="py-2 pr-4">{t('templates.detail.hash')}</th>
                          <th className="py-2 pr-4">{t('templates.detail.correlationId')}</th>
                          <th className="py-2 pr-4">{t('common.actions')}</th>
                        </tr>
                      </thead>
                      <tbody>
                        {snapshotsList.map((s) => (
                          <SnapshotRow key={s.id} snapshot={s} />
                        ))}
                      </tbody>
                    </table>
                  </div>
                )}
              </CardContent>
            </Card>
          )}

          {activeTab === 'compare' && (
            <Card>
              <CardHeader>
                <CardTitle className="text-sm flex items-center gap-2">
                  <GitCompare className="w-4 h-4" /> {t('templates.detail.compareVersions')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="mb-4">
                  <label className="block text-sm text-slate-600 mb-1">{t('templates.detail.compareWith')}</label>
                  <select
                    value={compareVersionId}
                    onChange={(e) => setCompareVersionId(e.target.value ? Number(e.target.value) : '')}
                    className="p-2 border rounded text-sm w-full max-w-xs"
                  >
                    <option value="">{t('common.select')}</option>
                    {otherVersions.map((v) => (
                      <option key={v.id} value={v.id}>
                        v{v.version} — {t(`status.${v.status}`)} ({new Date(v.created_at).toLocaleDateString()})
                      </option>
                    ))}
                  </select>
                </div>

                {!compareVersionData && (
                  <p className="text-sm text-slate-400">
                    {otherVersions.length === 0 ? t('templates.detail.noVersionsAvailable') : t('common.select')}
                  </p>
                )}

                {compareVersionData && (
                  <div className="overflow-x-auto">
                    <table className="w-full text-sm">
                      <thead>
                        <tr className="border-b text-left text-slate-500">
                          <th className="py-2 pr-4">{t('templates.detail.property')}</th>
                          <th className="py-2 pr-4">{t('templates.detail.versionA')}</th>
                          <th className="py-2 pr-4">{t('templates.detail.versionB')}</th>
                        </tr>
                      </thead>
                      <tbody>{renderDiffRows()}</tbody>
                    </table>
                  </div>
                )}
              </CardContent>
            </Card>
          )}
        </div>

        {/* Sidebar: Actions */}
        <div className="space-y-4">
          <Card>
            <CardHeader>
              <CardTitle className="text-sm">{t('templates.version.actions')}</CardTitle>
            </CardHeader>
            <CardContent className="space-y-2">
              {version.status === 'DRAFT' && (
                <>
                  <Button size="sm" className="w-full" onClick={() => setConfirmAction({ type: 'submit' })}>
                    <Send className="w-3 h-3 mr-1" /> {t('templates.detail.submitForReview')}
                  </Button>
                  <Button size="sm" variant="outline" className="w-full" onClick={() => navigate(`/templates/preview/${version.template_id}`)}>
                    <Eye className="w-3 h-3 mr-1" /> {t('templates.version.preview')}
                  </Button>
                </>
              )}
              {version.status === 'REVIEW' && isAdmin && (
                <>
                  <Button size="sm" className="w-full bg-green-600 hover:bg-green-700 text-white" onClick={() => setConfirmAction({ type: 'approve' })}>
                    <CheckCircle className="w-3 h-3 mr-1" /> {t('templates.detail.approve')}
                  </Button>
                  <Button size="sm" variant="destructive" className="w-full" onClick={() => setConfirmAction({ type: 'reject' })}>
                    <XCircle className="w-3 h-3 mr-1" /> {t('templates.detail.reject')}
                  </Button>
                </>
              )}
              {version.status === 'APPROVED' && isAdmin && (
                <Button size="sm" variant="outline" className="w-full text-orange-600 border-orange-300 hover:bg-orange-50" onClick={() => setConfirmAction({ type: 'deprecate' })}>
                  <Trash2 className="w-3 h-3 mr-1" /> {t('templates.detail.deprecate')}
                </Button>
              )}
              {version.status === 'DEPRECATED' && isAdmin && (
                <Button size="sm" variant="outline" className="w-full text-red-600 border-red-300 hover:bg-red-50" onClick={() => setConfirmAction({ type: 'archive' })}>
                  <Archive className="w-3 h-3 mr-1" /> {t('templates.detail.archive')}
                </Button>
              )}

              {version.status === 'DRAFT' && (
                <Button size="sm" variant="outline" className="w-full" onClick={() => duplicateMutation.mutate()} disabled={duplicateMutation.isPending}>
                  <Copy className="w-3 h-3 mr-1" /> {duplicateMutation.isPending ? t('templates.detail.duplicating') : t('templates.detail.duplicateVersion')}
                </Button>
              )}

              {isAdmin && version.variable_definitions && version.variable_definitions.length > 0 && (
                <Button size="sm" variant="outline" className="w-full" onClick={() => setInspectorOpen(!inspectorOpen)}>
                  <Search className="w-3 h-3 mr-1" /> {t('templates.inspector.title')}
                </Button>
              )}
            </CardContent>
          </Card>

          {version.variable_definitions && version.variable_definitions.length > 0 && (
            <Card>
              <CardHeader>
                <CardTitle className="text-sm flex items-center gap-2">
                  <ListChecks className="w-4 h-4" /> {t('templates.version.variables')}
                </CardTitle>
              </CardHeader>
              <CardContent>
                <div className="space-y-2">
                  {version.variable_definitions.map((v: { code: string; type?: string; required?: boolean }, i: number) => (
                    <div key={i} className="flex items-center justify-between text-sm border-b pb-1 last:border-0">
                      <span className="font-mono text-slate-800">{v.code}</span>
                      <div className="flex items-center gap-2">
                        <span className="text-xs text-slate-500">{v.type || 'string'}</span>
                        {v.required && <span className="text-xs text-red-500">*</span>}
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          )}

          {inspectorOpen && isAdmin && (
            <Card>
              <CardContent className="pt-4">
                <TemplateVariableInspector
                  content={contentBody}
                  variableDefinitions={(version.variable_definitions || []).map((v: any) => ({
                    name: v.code,
                    source_type: v.source_type || v.type || 'entity',
                    resolver_key: v.resolver_key,
                    default_value: v.default_value,
                    required: v.required,
                    validation: v.validation,
                  }))}
                  isAdmin={isAdmin}
                />
              </CardContent>
            </Card>
          )}
        </div>

        {/* Live Preview Panel */}
        {previewOpen && (
          <div className="space-y-4">
            <Card>
              <CardHeader>
                <CardTitle className="text-sm flex items-center gap-2">
                  <Zap className="w-4 h-4" /> {t('templates.preview.title')}
                </CardTitle>
              </CardHeader>
              <CardContent className="space-y-3">
                <div>
                  <label className="block text-xs text-slate-500 mb-1">{t('templates.preview.enterVariables')}</label>
                  {livePreview.detectedVariables.length > 0 ? (
                    <div className="space-y-2">
                      {livePreview.detectedVariables.map((varName) => (
                        <div key={varName}>
                          <label className="block text-xs text-slate-600 mb-0.5">
                            {'{{' + varName + '}}'}
                          </label>
                          <Input
                            value={livePreview.variables[varName] || ''}
                            onChange={(e) => livePreview.setVariable(varName, e.target.value)}
                            placeholder={varName}
                            className="text-sm"
                          />
                        </div>
                      ))}
                    </div>
                  ) : (
                    <p className="text-xs text-slate-400">{t('templates.preview.noContent')}</p>
                  )}
                </div>

                <div className="border-t pt-3">
                  <div className="flex items-center gap-2 mb-2">
                    {livePreview.validationStatus === 'valid' && (
                      <span className="flex items-center gap-1 text-xs text-green-600">
                        <CheckCircle className="w-3 h-3" /> {t('templates.preview.validTemplate')}
                      </span>
                    )}
                    {livePreview.validationStatus === 'invalid' && (
                      <span className="flex items-center gap-1 text-xs text-red-600">
                        <AlertCircle className="w-3 h-3" /> {t('templates.preview.hasErrors')}
                      </span>
                    )}
                  </div>
                  {livePreview.errors.length > 0 && (
                    <div className="bg-red-50 border border-red-200 rounded p-2 mb-2">
                      {livePreview.errors.map((err, i) => (
                        <p key={i} className="text-xs text-red-600">{err}</p>
                      ))}
                    </div>
                  )}
                  {livePreview.renderedHtml ? (
                    <div
                      className="border rounded p-3 bg-white prose prose-xs max-w-none max-h-64 overflow-y-auto"
                      dir="ar"
                      dangerouslySetInnerHTML={{ __html: livePreview.renderedHtml }}
                    />
                  ) : (
                    <div className="h-32 bg-slate-50 rounded border-2 border-dashed flex items-center justify-center">
                      <p className="text-xs text-slate-400">{t('templates.preview.placeholder')}</p>
                    </div>
                  )}
                </div>

                <Button
                  size="sm"
                  variant="outline"
                  className="w-full"
                  onClick={() => navigate(`/templates/preview/${version.template_id}`)}
                >
                  <Eye className="w-3 h-3 mr-1" /> {t('templates.version.preview')}
                </Button>
              </CardContent>
            </Card>
          </div>
        )}
      </div>

      <ConfirmDialog
        open={confirmAction !== null}
        onOpenChange={(o) => { if (!o) { setConfirmAction(null); setRejectReason('') } }}
        title={
          confirmAction?.type === 'submit' ? t('templates.detail.confirmSubmit') :
          confirmAction?.type === 'approve' ? t('templates.detail.confirmApprove') :
          confirmAction?.type === 'reject' ? t('templates.detail.confirmReject') :
          confirmAction?.type === 'deprecate' ? t('templates.detail.confirmDeprecate') :
          confirmAction?.type === 'archive' ? t('templates.detail.confirmArchive') : ''
        }
        onConfirm={() => {
          if (!confirmAction) return
          switch (confirmAction.type) {
            case 'submit': submitMutation.mutate(); break
            case 'approve': approveMutation.mutate(); break
            case 'reject': rejectMutation.mutate(); break
            case 'deprecate': deprecateMutation.mutate(); break
            case 'archive': archiveMutation.mutate(); break
          }
        }}
        loading={submitMutation.isPending || approveMutation.isPending || rejectMutation.isPending || deprecateMutation.isPending || archiveMutation.isPending}
      >
        {confirmAction?.type === 'reject' && (
          <div className="mt-3">
            <label className="block text-sm text-slate-600 mb-1">{t('templates.detail.rejectReason')}</label>
            <textarea
              value={rejectReason}
              onChange={(e) => setRejectReason(e.target.value)}
              className="w-full border rounded p-2 text-sm"
              rows={3}
              placeholder={t('templates.detail.rejectReasonPlaceholder')}
            />
          </div>
        )}
      </ConfirmDialog>
    </div>
  )
}

function SnapshotRow({ snapshot }: { snapshot: TemplateSnapshot }) {
  const { t } = useTranslation()
  const [verifying, setVerifying] = useState(false)
  const [verifyResult, setVerifyResult] = useState<boolean | null>(null)

  async function handleVerify() {
    setVerifying(true)
    try {
      const res = await templates.verifySnapshot(snapshot.snapshotHash)
      setVerifyResult(res.data.data.valid)
      toast.success(res.data.data.valid ? t('templates.detail.valid') : t('templates.detail.invalid'))
    } catch {
      toast.error(t('common.error'))
    } finally {
      setVerifying(false)
    }
  }

  return (
    <tr className="border-b last:border-0">
      <td className="py-2 pr-4">{new Date(snapshot.renderedAt).toLocaleString()}</td>
      <td className="py-2 pr-4">#{snapshot.renderedBy}</td>
      <td className="py-2 pr-4">{snapshot.locale}</td>
      <td className="py-2 pr-4 font-mono text-xs">{snapshot.snapshotHash?.substring(0, 12) || '—'}</td>
      <td className="py-2 pr-4 font-mono text-xs">{snapshot.correlationId?.substring(0, 12) || '—'}</td>
      <td className="py-2 pr-4">
        <div className="flex items-center gap-2">
          <Button size="sm" variant="outline" onClick={handleVerify} disabled={verifying}>
            <ShieldCheck className="w-3 h-3 mr-1" />
            {verifying ? t('templates.detail.verifying') : t('templates.detail.verify')}
          </Button>
          {verifyResult !== null && (
            <span className={cn('text-xs px-2 py-0.5 rounded', verifyResult ? 'bg-green-100 text-green-700' : 'bg-red-100 text-red-600')}>
              {verifyResult ? t('templates.detail.valid') : t('templates.detail.invalid')}
            </span>
          )}
        </div>
      </td>
    </tr>
  )
}
