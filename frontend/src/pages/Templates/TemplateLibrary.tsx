/*
 * صفحة مكتبة القوالب: عرض جميع القوالب مع البحث والتصفية حسب الفئة وال_status.
 * بطاقات تعرض معلومات القالب والعدد الإصدارات والاستخدام.
 */
import { useState, useMemo } from 'react'
import { useQuery } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useNavigate } from 'react-router-dom'
import { Search, Plus, LayoutGrid, AlertCircle, RefreshCw, FileText, Hash, Tag, Layers } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { usePermission } from '../../hooks/usePermission'
import { templates } from '../../sdk/domains/templates.sdk'
import { cn } from '../../lib/utils'
import type { Template, TemplateCategory } from '../../sdk/domains/templates.sdk'

const STATUS_STYLES: Record<string, string> = {
  DRAFT: 'bg-slate-100 text-slate-600',
  REVIEW: 'bg-amber-100 text-amber-700',
  APPROVED: 'bg-green-100 text-green-700',
  DEPRECATED: 'bg-orange-100 text-orange-700',
  ARCHIVED: 'bg-red-100 text-red-600',
}

export default function TemplateLibrary() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const canCreate = usePermission('template.create')

  const [search, setSearch] = useState('')
  const [categoryFilter, setCategoryFilter] = useState<number | ''>('')
  const [statusFilter, setStatusFilter] = useState<string>('')

  const { data, isLoading, isError, refetch } = useQuery({
    queryKey: ['templates', search, categoryFilter],
    queryFn: () =>
      templates.list({
        page: 1,
        limit: 100,
        q: search || undefined,
        category_id: categoryFilter !== '' ? Number(categoryFilter) : undefined,
      }).then(r => r.data),
  })

  const { data: categories } = useQuery({
    queryKey: ['template-categories'],
    queryFn: () => templates.listCategories().then(r => r.data.data),
  })

  const { data: versionsData } = useQuery({
    queryKey: ['template-versions-status'],
    queryFn: () =>
      templates.listVersions({ page: 1, limit: 1000 }).then(r => r.data),
  })

  const templatesList = useMemo(() => (data?.data || []) as Template[], [data])

  const categoryMap = useMemo(() => {
    const map: Record<number, TemplateCategory> = {}
    ;(categories || []).forEach((c: TemplateCategory) => { map[c.id] = c })
    return map
  }, [categories])

  const latestVersionMap = useMemo(() => {
    const map: Record<number, string> = {}
    const versions = (versionsData?.data || []) as any[]
    versions.forEach((v: any) => {
      if (!map[v.template_id]) map[v.template_id] = v.status
    })
    return map
  }, [versionsData])

  const filtered = useMemo(() => {
    if (!statusFilter) return templatesList
    return templatesList.filter(t => {
      const latestStatus = latestVersionMap[t.id]
      if (statusFilter === 'ACTIVE') return t.is_active
      if (statusFilter === 'INACTIVE') return !t.is_active
      return latestStatus === statusFilter
    })
  }, [templatesList, statusFilter, latestVersionMap])

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <div className="flex items-center gap-3">
          <LayoutGrid className="w-6 h-6 text-blue-600" />
          <h1 className="text-2xl font-bold">{t('templates.library.title')}</h1>
        </div>
        {canCreate && (
          <Button onClick={() => navigate('/templates/create')}>
            <Plus className="w-4 h-4 mr-1" /> {t('templates.library.create')}
          </Button>
        )}
      </div>

      <div className="flex items-center gap-3 mb-6 flex-wrap">
        <div className="relative flex-1 min-w-[200px] max-w-md">
          <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-4 h-4 text-slate-400" />
          <Input
            placeholder={t('templates.library.search')}
            value={search}
            onChange={(e) => setSearch(e.target.value)}
            className="pl-9"
          />
        </div>
        <select
          value={categoryFilter}
          onChange={(e) => setCategoryFilter(e.target.value ? Number(e.target.value) : '')}
          className="p-2 border rounded text-sm"
        >
          <option value="">{t('templates.library.allCategories')}</option>
          {(categories || []).map((cat: TemplateCategory) => (
            <option key={cat.id} value={cat.id}>{cat.name_ar}</option>
          ))}
        </select>
        <select
          value={statusFilter}
          onChange={(e) => setStatusFilter(e.target.value)}
          className="p-2 border rounded text-sm"
        >
          <option value="">{t('templates.library.allStatuses')}</option>
          <option value="ACTIVE">{t('common.active')}</option>
          <option value="INACTIVE">{t('common.inactive')}</option>
          <option value="DRAFT">{t('status.DRAFT')}</option>
          <option value="REVIEW">{t('status.REVIEW')}</option>
          <option value="APPROVED">{t('status.APPROVED')}</option>
          <option value="DEPRECATED">{t('status.DEPRECATED')}</option>
          <option value="ARCHIVED">{t('status.ARCHIVED')}</option>
        </select>
      </div>

      {isError && (
        <div className="flex flex-col items-center justify-center p-12 text-center">
          <AlertCircle className="w-10 h-10 text-red-400 mb-3" />
          <p className="text-sm text-slate-600 mb-3">{t('common.error')}</p>
          <Button variant="outline" size="sm" onClick={() => refetch()}>
            <RefreshCw className="w-3 h-3 mr-1" /> {t('common.retry')}
          </Button>
        </div>
      )}

      {isLoading && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {Array.from({ length: 6 }).map((_, i) => (
            <div key={i} className="bg-white rounded-lg shadow p-5 animate-pulse">
              <div className="h-5 bg-slate-200 rounded w-2/3 mb-3" />
              <div className="h-4 bg-slate-100 rounded w-1/2 mb-2" />
              <div className="h-4 bg-slate-100 rounded w-3/4 mb-4" />
              <div className="flex gap-2">
                <div className="h-6 bg-slate-100 rounded w-16" />
                <div className="h-6 bg-slate-100 rounded w-20" />
              </div>
            </div>
          ))}
        </div>
      )}

      {!isLoading && !isError && filtered.length === 0 && (
        <div className="flex flex-col items-center justify-center p-16 text-center">
          <FileText className="w-12 h-12 text-slate-300 mb-4" />
          <p className="text-slate-500 mb-2">{t('templates.library.empty')}</p>
          <p className="text-sm text-slate-400">{t('templates.library.emptyHint')}</p>
        </div>
      )}

      {!isLoading && !isError && filtered.length > 0 && (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          {filtered.map((tpl) => {
            const latestStatus = latestVersionMap[tpl.id]
            const cat = categoryMap[tpl.category_id]
            return (
              <div
                key={tpl.id}
                onClick={() => navigate(`/templates/${tpl.id}`)}
                className="bg-white rounded-lg shadow p-5 cursor-pointer hover:shadow-md transition-shadow border border-transparent hover:border-blue-200"
              >
                <div className="flex items-start justify-between mb-3">
                  <h3 className="font-semibold text-slate-800 text-sm leading-tight">
                    {tpl.name_ar}
                  </h3>
                  {tpl.is_active ? (
                    <span className="text-xs bg-green-100 text-green-700 px-2 py-0.5 rounded flex-shrink-0 ml-2">
                      {t('common.active')}
                    </span>
                  ) : (
                    <span className="text-xs bg-slate-100 text-slate-500 px-2 py-0.5 rounded flex-shrink-0 ml-2">
                      {t('common.inactive')}
                    </span>
                  )}
                </div>

                <p className="text-xs text-slate-500 mb-2 truncate">{tpl.name_en}</p>

                <div className="flex items-center gap-3 text-xs text-slate-500 mb-3">
                  <span className="flex items-center gap-1">
                    <Hash className="w-3 h-3" /> {tpl.code}
                  </span>
                  {cat && (
                    <span className="flex items-center gap-1">
                      <Layers className="w-3 h-3" /> {cat.name_ar}
                    </span>
                  )}
                </div>

                <div className="flex items-center gap-2 flex-wrap">
                  <span className="text-xs text-slate-500 flex items-center gap-1">
                    <FileText className="w-3 h-3" />
                    {t('templates.library.usage', { count: tpl.usage_count })}
                  </span>
                  {latestStatus && (
                    <span className={cn('text-xs px-2 py-0.5 rounded', STATUS_STYLES[latestStatus] || 'bg-slate-100 text-slate-600')}>
                      {t(`status.${latestStatus}`)}
                    </span>
                  )}
                </div>

                {tpl.tags && tpl.tags.length > 0 && (
                  <div className="flex items-center gap-1 mt-3 flex-wrap">
                    <Tag className="w-3 h-3 text-slate-400" />
                    {tpl.tags.slice(0, 3).map((tag, i) => (
                      <span key={i} className="text-xs bg-slate-50 text-slate-500 px-1.5 py-0.5 rounded">
                        {tag}
                      </span>
                    ))}
                    {tpl.tags.length > 3 && (
                      <span className="text-xs text-slate-400">+{tpl.tags.length - 3}</span>
                    )}
                  </div>
                )}
              </div>
            )
          })}
        </div>
      )}
    </div>
  )
}
