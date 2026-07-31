/*
 * صفحة تفاصيل القالب: معلومات القالب وقائمة الإصدارات وسرعة الحالة.
 * أزرار الإجراءات حسب حالة الإصدار الحالي.
 */
import { useState, useRef } from 'react'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useNavigate, useParams } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, Plus, FileText, Hash, Tag, Layers, Clock, Eye, Send, CheckCircle, XCircle, Trash2, Archive, AlertCircle, RefreshCw, Copy, Download, Upload, BarChart3, History, RotateCcw, Search } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogFooter } from '../../components/ui/dialog'
import { Input } from '../../components/ui/input'
import ConfirmDialog from '../../components/ConfirmDialog'
import { useAuth } from '../../context/AuthContext'
import { templates } from '../../sdk/domains/templates.sdk'
import TemplateVariableInspector from '../../components/TemplateVariableInspector'
import { cn } from '../../lib/utils'
import type { TemplateVersion, TemplateSnapshot } from '../../sdk/domains/templates.sdk'

const STATUS_STYLES: Record<string, string> = {
  DRAFT: 'bg-slate-100 text-slate-600',
  REVIEW: 'bg-amber-100 text-amber-700',
  APPROVED: 'bg-green-100 text-green-700',
  DEPRECATED: 'bg-orange-100 text-orange-700',
  ARCHIVED: 'bg-red-100 text-red-600',
}

export default function TemplateDetail() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const { id } = useParams<{ id: string }>()
  const { user } = useAuth()
  const queryClient = useQueryClient()

  const [confirmAction, setConfirmAction] = useState<{ type: string; version: TemplateVersion } | null>(null)
  const [rejectReason, setRejectReason] = useState('')
  const [cloneDialogOpen, setCloneDialogOpen] = useState(false)
  const [cloneCode, setCloneCode] = useState('')
  const [cloneNameAr, setCloneNameAr] = useState('')
  const [cloneNameEn, setCloneNameEn] = useState('')
  const [detailTab, setDetailTab] = useState<'info' | 'renderHistory' | 'rollback'>('info')
  const [inspectorOpen, setInspectorOpen] = useState(false)
  const importFileRef = useRef<HTMLInputElement>(null)

  const templateId = Number(id)

  const { data: templateRes, isLoading: tplLoading, isError: tplError, refetch: tplRefetch } = useQuery({
    queryKey: ['template', templateId],
    queryFn: () => templates.get(templateId).then(r => r.data.data),
    enabled: !!templateId,
  })

  const { data: versionsRes, isLoading: verLoading, isError: verError, refetch: verRefetch } = useQuery({
    queryKey: ['template-versions', templateId],
    queryFn: () => templates.listVersions({ template_id: templateId, page: 1, limit: 100 }).then(r => r.data),
    enabled: !!templateId,
  })

  const { data: category } = useQuery({
    queryKey: ['template-category', templateRes?.category_id],
    queryFn: () => templates.getCategory(templateRes!.category_id).then(r => r.data.data),
    enabled: !!templateRes?.category_id,
  })

  const { data: snapshotsData } = useQuery({
    queryKey: ['template-snapshots', versionsRes],
    queryFn: async () => {
      const selected = selectedVersion
      if (!selected) return []
      return templates.getSnapshots({ templateVersionId: selected.id }).then(r => r.data.data)
    },
    enabled: detailTab === 'renderHistory' && !!versionsRes?.data?.length,
  })

  const versions = (versionsRes?.data || []) as TemplateVersion[]
  const tpl = templateRes
  const selectedVersion = versions[0]
  const snapshots = (snapshotsData || []) as TemplateSnapshot[]

  const isAdmin = user?.roles?.some(r => ['SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'].includes(r))

  const submitMutation = useMutation({
    mutationFn: (versionId: number) => templates.submitVersion(versionId),
    onSuccess: () => {
      toast.success(t('templates.detail.submitted'))
      queryClient.invalidateQueries({ queryKey: ['template-versions', templateId] })
      setConfirmAction(null)
    },
  })

  const approveMutation = useMutation({
    mutationFn: (versionId: number) => templates.approveVersion(versionId),
    onSuccess: () => {
      toast.success(t('templates.detail.approved'))
      queryClient.invalidateQueries({ queryKey: ['template-versions', templateId] })
      setConfirmAction(null)
    },
  })

  const rejectMutation = useMutation({
    mutationFn: ({ versionId, reason }: { versionId: number; reason: string }) =>
      templates.rejectVersion(versionId, reason),
    onSuccess: () => {
      toast.success(t('templates.detail.rejected'))
      queryClient.invalidateQueries({ queryKey: ['template-versions', templateId] })
      setConfirmAction(null)
      setRejectReason('')
    },
  })

  const deprecateMutation = useMutation({
    mutationFn: (versionId: number) => templates.deprecateVersion(versionId),
    onSuccess: () => {
      toast.success(t('templates.detail.deprecated'))
      queryClient.invalidateQueries({ queryKey: ['template-versions', templateId] })
      setConfirmAction(null)
    },
  })

  const archiveMutation = useMutation({
    mutationFn: (versionId: number) => templates.archiveVersion(versionId),
    onSuccess: () => {
      toast.success(t('templates.detail.archived'))
      queryClient.invalidateQueries({ queryKey: ['template-versions', templateId] })
      setConfirmAction(null)
    },
  })

  const toggleActiveMutation = useMutation({
    mutationFn: (active: boolean) => templates.update(templateId, { is_active: active }),
    onSuccess: () => {
      toast.success(t('templates.detail.updated'))
      queryClient.invalidateQueries({ queryKey: ['template', templateId] })
    },
  })

  const cloneMutation = useMutation({
    mutationFn: () => templates.create({
      category_id: tpl!.category_id,
      code: cloneCode,
      name_ar: cloneNameAr,
      name_en: cloneNameEn,
      description: tpl?.description || undefined,
      engine: tpl?.engine,
      default_locale: tpl?.default_locale,
      tags: tpl?.tags,
    }),
    onSuccess: (res) => {
      toast.success(t('templates.detail.cloned'))
      setCloneDialogOpen(false)
      setCloneCode('')
      setCloneNameAr('')
      setCloneNameEn('')
      navigate(`/templates/${res.data.data.id}`)
    },
  })

  function handleExport() {
    if (!versions.length) {
      toast.error(t('templates.detail.noVersions'))
      return
    }
    const v = versions[0]
    const data = JSON.stringify({
      version: v.version,
      content: v.content,
      variable_definitions: v.variable_definitions,
      change_summary: v.change_summary,
    }, null, 2)
    const blob = new Blob([data], { type: 'application/json' })
    const url = URL.createObjectURL(blob)
    const a = document.createElement('a')
    a.href = url
    a.download = `${tpl?.code || 'template'}-v${v.version}.json`
    a.click()
    URL.revokeObjectURL(url)
  }

  function handleImport(file: File | undefined) {
    if (!file) return
    const reader = new FileReader()
    reader.onload = (e) => {
      try {
        const data = JSON.parse(e.target?.result as string)
        if (!data.content || !data.version) {
          toast.error(t('templates.detail.importInvalid'))
          return
        }
        importMutation.mutate(data)
      } catch {
        toast.error(t('templates.detail.importInvalid'))
      }
    }
    reader.readAsText(file)
  }

  const importMutation = useMutation({
    mutationFn: (data: { version: string; content: Record<string, { body: string }>; variable_definitions?: { code: string; type?: string; required?: boolean }[]; change_summary?: string }) =>
      templates.createVersion({
        template_id: templateId,
        version: data.version,
        content: data.content,
        variable_definitions: data.variable_definitions,
        change_summary: data.change_summary || undefined,
      }),
    onSuccess: () => {
      toast.success(t('templates.detail.importSuccess'))
      queryClient.invalidateQueries({ queryKey: ['template-versions', templateId] })
      if (importFileRef.current) importFileRef.current.value = ''
    },
  })

  function renderActionButtons(version: TemplateVersion) {
    const buttons: React.ReactNode[] = []

    if (version.status === 'DRAFT') {
      buttons.push(
        <Button key="submit" size="sm" variant="outline" onClick={() => setConfirmAction({ type: 'submit', version })}>
          <Send className="w-3 h-3 mr-1" /> {t('templates.detail.submitForReview')}
        </Button>,
        <Button key="edit" size="sm" variant="outline" onClick={() => navigate(`/templates/versions/${version.id}`)}>
          <Eye className="w-3 h-3 mr-1" /> {t('templates.detail.viewContent')}
        </Button>
      )
    }
    if (version.status === 'REVIEW' && isAdmin) {
      buttons.push(
        <Button key="approve" size="sm" className="bg-green-600 hover:bg-green-700 text-white" onClick={() => setConfirmAction({ type: 'approve', version })}>
          <CheckCircle className="w-3 h-3 mr-1" /> {t('templates.detail.approve')}
        </Button>,
        <Button key="reject" size="sm" variant="destructive" onClick={() => setConfirmAction({ type: 'reject', version })}>
          <XCircle className="w-3 h-3 mr-1" /> {t('templates.detail.reject')}
        </Button>
      )
    }
    if (version.status === 'APPROVED' && isAdmin) {
      buttons.push(
        <Button key="deprecate" size="sm" variant="outline" className="text-orange-600 border-orange-300 hover:bg-orange-50" onClick={() => setConfirmAction({ type: 'deprecate', version })}>
          <Trash2 className="w-3 h-3 mr-1" /> {t('templates.detail.deprecate')}
        </Button>
      )
    }
    if (version.status === 'DEPRECATED' && isAdmin) {
      buttons.push(
        <Button key="archive" size="sm" variant="outline" className="text-red-600 border-red-300 hover:bg-red-50" onClick={() => setConfirmAction({ type: 'archive', version })}>
          <Archive className="w-3 h-3 mr-1" /> {t('templates.detail.archive')}
        </Button>
      )
    }

    return buttons.length > 0 ? <div className="flex items-center gap-2 flex-wrap">{buttons}</div> : null
  }

  if (tplLoading) {
    return (
      <div className="space-y-4">
        <div className="h-8 bg-slate-100 rounded w-48 animate-pulse" />
        <div className="h-40 bg-slate-100 rounded animate-pulse" />
        <div className="h-60 bg-slate-100 rounded animate-pulse" />
      </div>
    )
  }

  if (tplError || !tpl) {
    return (
      <div className="flex flex-col items-center justify-center p-12 text-center">
        <AlertCircle className="w-10 h-10 text-red-400 mb-3" />
        <p className="text-sm text-slate-600 mb-3">{t('common.error')}</p>
        <Button variant="outline" size="sm" onClick={() => tplRefetch()}>
          <RefreshCw className="w-3 h-3 mr-1" /> {t('common.retry')}
        </Button>
      </div>
    )
  }

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate('/templates')} className="p-1 text-slate-400 hover:text-slate-600">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-2xl font-bold">{t('templates.detail.title')}</h1>
      </div>

      <Card className="mb-6">
        <CardHeader>
          <div className="flex items-center justify-between">
            <CardTitle className="text-lg">{tpl.name_ar}</CardTitle>
            <div className="flex items-center gap-2">
              {tpl.is_active ? (
                <span className="text-xs bg-green-100 text-green-700 px-2 py-1 rounded">{t('common.active')}</span>
              ) : (
                <span className="text-xs bg-slate-100 text-slate-500 px-2 py-1 rounded">{t('common.inactive')}</span>
              )}
              {isAdmin && (
                <Button
                  size="sm"
                  variant="outline"
                  onClick={() => toggleActiveMutation.mutate(!tpl.is_active)}
                  disabled={toggleActiveMutation.isPending}
                >
                  {tpl.is_active ? t('templates.detail.deactivate') : t('templates.detail.activate')}
                </Button>
              )}
            </div>
          </div>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 text-sm">
            <div className="space-y-2">
              <p className="flex items-center gap-2 text-slate-600">
                <Hash className="w-4 h-4" /> {t('common.code')}: <span className="font-medium text-slate-800">{tpl.code}</span>
              </p>
              <p className="text-slate-600">
                {t('templates.detail.nameEn')}: <span className="text-slate-800">{tpl.name_en || '—'}</span>
              </p>
              <p className="flex items-center gap-2 text-slate-600">
                <Layers className="w-4 h-4" /> {t('templates.detail.category')}: <span className="text-slate-800">{category?.name_ar || '—'}</span>
              </p>
            </div>
            <div className="space-y-2">
              <p className="text-slate-600">
                {t('templates.detail.engine')}: <span className="font-medium text-slate-800">{tpl.engine}</span>
              </p>
              <p className="text-slate-600">
                {t('templates.detail.locale')}: <span className="text-slate-800">{tpl.default_locale}</span>
              </p>
              <p className="text-slate-600">
                {t('templates.detail.usage')}: <span className="font-medium text-slate-800">{tpl.usage_count}</span>
              </p>
            </div>
          </div>
          {tpl.description && (
            <p className="mt-3 text-sm text-slate-600 border-t pt-3">{tpl.description}</p>
          )}
          {tpl.tags && tpl.tags.length > 0 && (
            <div className="flex items-center gap-2 mt-3 flex-wrap">
              <Tag className="w-4 h-4 text-slate-400" />
              {tpl.tags.map((tag, i) => (
                <span key={i} className="text-xs bg-slate-100 text-slate-600 px-2 py-0.5 rounded">{tag}</span>
              ))}
            </div>
          )}
        </CardContent>
      </Card>

      {/* Action buttons: Clone, Export, Import */}
      <div className="flex items-center gap-2 mb-4 flex-wrap">
        <Button size="sm" variant="outline" onClick={() => {
          setCloneCode(tpl.code + '_clone')
          setCloneNameAr(tpl.name_ar + ' (منسوخ)')
          setCloneNameEn(tpl.name_en ? tpl.name_en + ' (cloned)' : '')
          setCloneDialogOpen(true)
        }}>
          <Copy className="w-3 h-3 mr-1" /> {t('templates.detail.clone')}
        </Button>
        <Button size="sm" variant="outline" onClick={handleExport}>
          <Download className="w-3 h-3 mr-1" /> {t('templates.detail.export')}
        </Button>
        <Button size="sm" variant="outline" onClick={() => importFileRef.current?.click()}>
          <Upload className="w-3 h-3 mr-1" /> {t('templates.detail.import')}
        </Button>
        <input
          ref={importFileRef}
          type="file"
          accept=".json"
          className="hidden"
          onChange={(e) => handleImport(e.target.files?.[0])}
        />
        {isAdmin && selectedVersion?.variable_definitions && selectedVersion.variable_definitions.length > 0 && (
          <Button size="sm" variant="outline" onClick={() => setInspectorOpen(true)}>
            <Search className="w-3 h-3 mr-1" /> {t('templates.inspector.title')}
          </Button>
        )}
      </div>

      {/* Detail tabs: Info / Render History / Rollback */}
      <div className="flex items-center gap-1 mb-4 border-b">
        <button
          onClick={() => setDetailTab('info')}
          className={cn('px-4 py-2 text-sm font-medium border-b-2 transition-colors', detailTab === 'info' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700')}
        >
          <FileText className="w-4 h-4 inline mr-1" /> {t('templates.detail.versions')}
        </button>
        <button
          onClick={() => setDetailTab('renderHistory')}
          className={cn('px-4 py-2 text-sm font-medium border-b-2 transition-colors', detailTab === 'renderHistory' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700')}
        >
          <History className="w-4 h-4 inline mr-1" /> {t('templates.detail.renderHistory')}
        </button>
        <button
          onClick={() => setDetailTab('rollback')}
          className={cn('px-4 py-2 text-sm font-medium border-b-2 transition-colors', detailTab === 'rollback' ? 'border-blue-600 text-blue-600' : 'border-transparent text-slate-500 hover:text-slate-700')}
        >
          <RotateCcw className="w-4 h-4 inline mr-1" /> {t('templates.detail.rollbackHistory')}
        </button>
      </div>

      {/* Usage Statistics card */}
      <Card className="mb-6">
        <CardHeader>
          <CardTitle className="text-sm flex items-center gap-2">
            <BarChart3 className="w-4 h-4" /> {t('templates.detail.usageStats')}
          </CardTitle>
        </CardHeader>
        <CardContent>
          <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 text-sm">
            <div className="bg-slate-50 rounded p-3">
              <p className="text-slate-500">{t('templates.detail.totalRenders')}</p>
              <p className="text-2xl font-bold text-slate-800">{tpl.usage_count}</p>
            </div>
            <div className="bg-slate-50 rounded p-3">
              <p className="text-slate-500">{t('templates.detail.usage')}</p>
              <p className="text-2xl font-bold text-slate-800">{versions.length}</p>
            </div>
            <div className="bg-slate-50 rounded p-3">
              <p className="text-slate-500">{t('templates.detail.lastRendered')}</p>
              <p className="text-sm font-medium text-slate-800">
                {snapshots.length > 0 ? new Date(snapshots[0].renderedAt).toLocaleDateString() : '—'}
              </p>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Tab: Versions list */}
      {detailTab === 'info' && (
        <>
          <div className="flex items-center justify-between mb-4">
            <h2 className="text-lg font-semibold">{t('templates.detail.versions')}</h2>
            <Button size="sm" onClick={() => navigate(`/templates/${templateId}/versions/create`)}>
              <Plus className="w-3 h-3 mr-1" /> {t('templates.detail.newVersion')}
            </Button>
          </div>

          {verLoading && (
            <div className="space-y-3">
              {Array.from({ length: 3 }).map((_, i) => (
                <div key={i} className="h-20 bg-slate-100 rounded animate-pulse" />
              ))}
            </div>
          )}

          {verError && (
            <div className="flex items-center gap-2 text-red-600 text-sm p-4">
              <AlertCircle className="w-4 h-4" />
              <span>{t('common.error')}</span>
              <Button variant="outline" size="sm" onClick={() => verRefetch()}>
                <RefreshCw className="w-3 h-3 mr-1" /> {t('common.retry')}
              </Button>
            </div>
          )}

          {!verLoading && !verError && versions.length === 0 && (
            <div className="text-center p-12 text-slate-400">
              <FileText className="w-10 h-10 mx-auto mb-3" />
              <p>{t('templates.detail.noVersions')}</p>
            </div>
          )}

          {!verLoading && !verError && versions.length > 0 && (
            <div className="space-y-3">
              {versions.map((ver) => (
                <div
                  key={ver.id}
                  className="bg-white rounded-lg shadow border p-4 hover:border-blue-200 transition-colors cursor-pointer"
                  onClick={() => navigate(`/templates/versions/${ver.id}`)}
                >
                  <div className="flex items-center justify-between mb-2">
                    <div className="flex items-center gap-3">
                      <span className="font-mono text-sm font-semibold text-slate-800">v{ver.version}</span>
                      <span className={cn('text-xs px-2 py-0.5 rounded', STATUS_STYLES[ver.status] || 'bg-slate-100 text-slate-600')}>
                        {t(`status.${ver.status}`)}
                      </span>
                    </div>
                    <span className="text-xs text-slate-400 flex items-center gap-1">
                      <Clock className="w-3 h-3" />
                      {new Date(ver.created_at).toLocaleDateString()}
                    </span>
                  </div>
                  {ver.change_summary && (
                    <p className="text-sm text-slate-600 mb-2">{ver.change_summary}</p>
                  )}
                  <div className="flex items-center gap-4 text-xs text-slate-500">
                    {ver.effective_from && (
                      <span>{t('templates.detail.effectiveFrom')}: {new Date(ver.effective_from).toLocaleDateString()}</span>
                    )}
                    {ver.variable_definitions && ver.variable_definitions.length > 0 && (
                      <span>{t('templates.detail.variables')}: {ver.variable_definitions.length}</span>
                    )}
                  </div>
                  <div className="mt-3" onClick={(e) => e.stopPropagation()}>
                    {renderActionButtons(ver)}
                  </div>
                </div>
              ))}
            </div>
          )}
        </>
      )}

      {/* Tab: Render History */}
      {detailTab === 'renderHistory' && (
        <Card>
          <CardHeader>
            <CardTitle className="text-sm">{t('templates.detail.renderHistory')}</CardTitle>
          </CardHeader>
          <CardContent>
            {snapshots.length === 0 ? (
              <p className="text-sm text-slate-400">{t('templates.detail.noRenderHistory')}</p>
            ) : (
              <div className="overflow-x-auto">
                <table className="w-full text-sm">
                  <thead>
                    <tr className="border-b text-left text-slate-500">
                      <th className="py-2 pr-4">{t('templates.detail.renderedAt')}</th>
                      <th className="py-2 pr-4">{t('templates.detail.renderedBy')}</th>
                      <th className="py-2 pr-4">{t('templates.detail.locale')}</th>
                      <th className="py-2 pr-4">{t('templates.detail.correlationId')}</th>
                      <th className="py-2 pr-4">{t('templates.detail.hash')}</th>
                    </tr>
                  </thead>
                  <tbody>
                    {snapshots.map((s) => (
                      <tr key={s.id} className="border-b last:border-0">
                        <td className="py-2 pr-4">{new Date(s.renderedAt).toLocaleString()}</td>
                        <td className="py-2 pr-4">#{s.renderedBy}</td>
                        <td className="py-2 pr-4">{s.locale}</td>
                        <td className="py-2 pr-4 font-mono text-xs">{s.correlationId?.substring(0, 12) || '—'}</td>
                        <td className="py-2 pr-4 font-mono text-xs">{s.snapshotHash?.substring(0, 12) || '—'}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </CardContent>
        </Card>
      )}

      {/* Tab: Rollback History */}
      {detailTab === 'rollback' && (
        <Card>
          <CardHeader>
            <CardTitle className="text-sm">{t('templates.detail.rollbackHistory')}</CardTitle>
          </CardHeader>
          <CardContent>
            <p className="text-sm text-slate-400">{t('templates.detail.noRollbackHistory')}</p>
          </CardContent>
        </Card>
      )}

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
        description={
          confirmAction?.type === 'reject'
            ? undefined
            : t('templates.detail.actionWarning')
        }
        onConfirm={() => {
          if (!confirmAction) return
          const verId = confirmAction.version.id
          switch (confirmAction.type) {
            case 'submit': submitMutation.mutate(verId); break
            case 'approve': approveMutation.mutate(verId); break
            case 'reject': rejectMutation.mutate({ versionId: verId, reason: rejectReason }); break
            case 'deprecate': deprecateMutation.mutate(verId); break
            case 'archive': archiveMutation.mutate(verId); break
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

      {/* Clone Dialog */}
      <Dialog open={cloneDialogOpen} onOpenChange={setCloneDialogOpen}>
        <DialogContent className="sm:max-w-md">
          <DialogHeader>
            <DialogTitle>{t('templates.detail.cloneDialogTitle')}</DialogTitle>
          </DialogHeader>
          <div className="space-y-3">
            <div>
              <label className="block text-sm text-slate-600 mb-1">{t('templates.detail.cloneCode')}</label>
              <Input value={cloneCode} onChange={(e) => setCloneCode(e.target.value)} />
            </div>
            <div>
              <label className="block text-sm text-slate-600 mb-1">{t('templates.detail.cloneNameAr')}</label>
              <Input value={cloneNameAr} onChange={(e) => setCloneNameAr(e.target.value)} />
            </div>
            <div>
              <label className="block text-sm text-slate-600 mb-1">{t('templates.detail.cloneNameEn')}</label>
              <Input value={cloneNameEn} onChange={(e) => setCloneNameEn(e.target.value)} />
            </div>
          </div>
          <DialogFooter className="gap-2">
            <Button variant="outline" onClick={() => setCloneDialogOpen(false)}>{t('common.cancel')}</Button>
            <Button onClick={() => cloneMutation.mutate()} disabled={!cloneCode || !cloneNameAr || cloneMutation.isPending}>
              {cloneMutation.isPending ? t('templates.detail.cloning') : t('templates.detail.clone')}
            </Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>

      {/* Variable Inspector Dialog */}
      {isAdmin && (
        <Dialog open={inspectorOpen} onOpenChange={setInspectorOpen}>
          <DialogContent className="sm:max-w-4xl max-h-[80vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle>{t('templates.inspector.title')}</DialogTitle>
            </DialogHeader>
            {selectedVersion && (
              <TemplateVariableInspector
                content={selectedVersion.content?.['ar']?.body || selectedVersion.content?.['en']?.body || ''}
                variableDefinitions={(selectedVersion.variable_definitions || []).map((v: any) => ({
                  name: v.code,
                  source_type: v.source_type || v.type || 'entity',
                  resolver_key: v.resolver_key,
                  default_value: v.default_value,
                  required: v.required,
                  validation: v.validation,
                }))}
                isAdmin={isAdmin}
              />
            )}
          </DialogContent>
        </Dialog>
      )}
    </div>
  )
}
