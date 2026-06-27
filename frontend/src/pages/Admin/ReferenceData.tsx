/*
 * صفحة إدارة البيانات المرجعية: إضافة وتعديل وحذف
 * التصنيفات والأنواع والبيانات الأساسية.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { Plus, Pencil, Trash2 } from 'lucide-react'
import { usePermission } from '../../hooks/usePermission'

interface EntityConfig {
  key: string
  labelKey: string
  apiPath: string
  columns: { key: string; labelKey: string; render?: (item: any) => React.ReactNode }[]
  formFields: { key: string; labelKey: string; type: 'text' | 'select' | 'textarea' | 'number'; required?: boolean; options?: { label: string; value: string }[] }[]
}

export default function ReferenceData() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()
  const canEdit = usePermission('user.update')

  const entities: EntityConfig[] = [
    {
      key: 'academic-titles',
      labelKey: 'referenceData.academicTitles',
      apiPath: '/admin/reference-data/academic-titles',
      columns: [
        { key: 'code', labelKey: 'referenceData.code' },
        { key: 'name_ar', labelKey: 'referenceData.nameAr' },
        { key: 'name_en', labelKey: 'referenceData.nameEn' },
        { key: 'display_order', labelKey: 'referenceData.displayOrder' },
        { key: 'is_active', labelKey: 'referenceData.isActive', render: (i) => i.is_active ? '✓' : '✗' },
      ],
      formFields: [
        { key: 'code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'name_ar', labelKey: 'referenceData.nameAr', type: 'text', required: true },
        { key: 'name_en', labelKey: 'referenceData.nameEn', type: 'text' },
        { key: 'display_order', labelKey: 'referenceData.displayOrder', type: 'number' },
      ],
    },
    {
      key: 'institution-types',
      labelKey: 'referenceData.institutionTypes',
      apiPath: '/admin/reference-data/institution-types',
      columns: [
        { key: 'code', labelKey: 'referenceData.code' },
        { key: 'name_ar', labelKey: 'referenceData.nameAr' },
        { key: 'name_en', labelKey: 'referenceData.nameEn' },
      ],
      formFields: [
        { key: 'code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'name_ar', labelKey: 'referenceData.nameAr', type: 'text', required: true },
        { key: 'name_en', labelKey: 'referenceData.nameEn', type: 'text' },
      ],
    },
    {
      key: 'institutions',
      labelKey: 'referenceData.institutions',
      apiPath: '/admin/reference-data/institutions',
      columns: [
        { key: 'code', labelKey: 'referenceData.code' },
        { key: 'name_ar', labelKey: 'referenceData.nameAr' },
        { key: 'name_en', labelKey: 'referenceData.nameEn' },
        { key: 'address', labelKey: 'referenceData.address' },
      ],
      formFields: [
        { key: 'code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'name_ar', labelKey: 'referenceData.nameAr', type: 'text', required: true },
        { key: 'name_en', labelKey: 'referenceData.nameEn', type: 'text' },
        { key: 'institution_type_id', labelKey: 'referenceData.type', type: 'select', required: true, options: [] },
        { key: 'address', labelKey: 'referenceData.address', type: 'text' },
        { key: 'email', labelKey: 'referenceData.email', type: 'text' },
        { key: 'phone', labelKey: 'referenceData.phone', type: 'text' },
        { key: 'is_active', labelKey: 'referenceData.isActive', type: 'select', options: [{ label: 'Active', value: 'true' }, { label: 'Inactive', value: 'false' }] },
      ],
    },
    {
      key: 'research-categories',
      labelKey: 'referenceData.researchCategories',
      apiPath: '/admin/reference-data/research-categories',
      columns: [
        { key: 'code', labelKey: 'referenceData.code' },
        { key: 'name_ar', labelKey: 'referenceData.nameAr' },
        { key: 'name_en', labelKey: 'referenceData.nameEn' },
      ],
      formFields: [
        { key: 'code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'name_ar', labelKey: 'referenceData.nameAr', type: 'text', required: true },
        { key: 'name_en', labelKey: 'referenceData.nameEn', type: 'text' },
        { key: 'description', labelKey: 'referenceData.description', type: 'textarea' },
      ],
    },
    {
      key: 'risk-classifications',
      labelKey: 'referenceData.riskClassifications',
      apiPath: '/admin/reference-data/risk-classifications',
      columns: [
        { key: 'code', labelKey: 'referenceData.code' },
        { key: 'name_ar', labelKey: 'referenceData.nameAr' },
        { key: 'name_en', labelKey: 'referenceData.nameEn' },
        { key: 'severity_level', labelKey: 'referenceData.severity' },
      ],
      formFields: [
        { key: 'code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'name_ar', labelKey: 'referenceData.nameAr', type: 'text', required: true },
        { key: 'name_en', labelKey: 'referenceData.nameEn', type: 'text' },
        { key: 'severity_level', labelKey: 'referenceData.severity', type: 'number' },
        { key: 'description', labelKey: 'referenceData.description', type: 'textarea' },
      ],
    },
    {
      key: 'vulnerable-populations',
      labelKey: 'referenceData.vulnerablePopulations',
      apiPath: '/admin/reference-data/vulnerable-populations',
      columns: [
        { key: 'code', labelKey: 'referenceData.code' },
        { key: 'name_ar', labelKey: 'referenceData.nameAr' },
        { key: 'name_en', labelKey: 'referenceData.nameEn' },
        { key: 'safeguards_required', labelKey: 'referenceData.safeguards' },
      ],
      formFields: [
        { key: 'code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'name_ar', labelKey: 'referenceData.nameAr', type: 'text', required: true },
        { key: 'name_en', labelKey: 'referenceData.nameEn', type: 'text' },
        { key: 'safeguards_required', labelKey: 'referenceData.safeguards', type: 'textarea' },
      ],
    },
    {
      key: 'document-types',
      labelKey: 'referenceData.documentTypes',
      apiPath: '/admin/reference-data/document-types',
      columns: [
        { key: 'type_code', labelKey: 'referenceData.code' },
        { key: 'type_name_ar', labelKey: 'referenceData.nameAr' },
        { key: 'type_name_en', labelKey: 'referenceData.nameEn' },
      ],
      formFields: [
        { key: 'type_code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'type_name_ar', labelKey: 'referenceData.nameAr', type: 'text', required: true },
        { key: 'type_name_en', labelKey: 'referenceData.nameEn', type: 'text' },
      ],
    },
    {
      key: 'committee-types',
      labelKey: 'referenceData.committeeTypes',
      apiPath: '/admin/reference-data/committee-types',
      columns: [
        { key: 'type_code', labelKey: 'referenceData.code' },
        { key: 'type_name', labelKey: 'referenceData.name' },
      ],
      formFields: [
        { key: 'type_code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'type_name', labelKey: 'referenceData.name', type: 'text', required: true },
        { key: 'description', labelKey: 'referenceData.description', type: 'textarea' },
      ],
    },
    {
      key: 'committee-roles',
      labelKey: 'referenceData.committeeRoles',
      apiPath: '/admin/reference-data/committee-roles',
      columns: [
        { key: 'role_code', labelKey: 'referenceData.code' },
        { key: 'role_name', labelKey: 'referenceData.name' },
      ],
      formFields: [
        { key: 'role_code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'role_name', labelKey: 'referenceData.name', type: 'text', required: true },
        { key: 'description', labelKey: 'referenceData.description', type: 'textarea' },
      ],
    },
    {
      key: 'notification-channels',
      labelKey: 'referenceData.notificationChannels',
      apiPath: '/admin/reference-data/notification-channels',
      columns: [
        { key: 'channel_code', labelKey: 'referenceData.code' },
        { key: 'channel_name', labelKey: 'referenceData.name' },
        { key: 'is_active', labelKey: 'referenceData.isActive', render: (i) => i.is_active ? '✓' : '✗' },
      ],
      formFields: [
        { key: 'channel_code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'channel_name', labelKey: 'referenceData.name', type: 'text', required: true },
      ],
    },
    {
      key: 'professions',
      labelKey: 'referenceData.professions',
      apiPath: '/admin/reference-data/professions',
      columns: [
        { key: 'code', labelKey: 'referenceData.code' },
        { key: 'name_ar', labelKey: 'referenceData.nameAr' },
        { key: 'name_en', labelKey: 'referenceData.nameEn' },
        { key: 'category', labelKey: 'referenceData.category' },
      ],
      formFields: [
        { key: 'code', labelKey: 'referenceData.code', type: 'text', required: true },
        { key: 'name_ar', labelKey: 'referenceData.nameAr', type: 'text', required: true },
        { key: 'name_en', labelKey: 'referenceData.nameEn', type: 'text' },
        { key: 'category', labelKey: 'referenceData.category', type: 'text' },
      ],
    },
  ]

  const [activeTab, setActiveTab] = useState(entities[0].key)
  const [showCreate, setShowCreate] = useState(false)
  const [editItem, setEditItem] = useState<any | null>(null)
  const [formData, setFormData] = useState<Record<string, any>>({})

  const activeEntity = entities.find(e => e.key === activeTab)!

  const { data: items, isLoading } = useQuery({
    queryKey: ['reference-data', activeTab],
    queryFn: () => api.get(activeEntity.apiPath).then(r => r.data.data || []),
  })

  const { data: institutionTypes } = useQuery({
    queryKey: ['reference-data', 'institution-types'],
    queryFn: () => api.get('/admin/reference-data/institution-types').then(r => r.data.data || []),
    enabled: activeTab === 'institutions',
  })

  const createMutation = useMutation({
    mutationFn: (body: any) => api.post(activeEntity.apiPath, body),
    onSuccess: () => { toast.success(t('common.created')); queryClient.invalidateQueries({ queryKey: ['reference-data', activeTab] }); setShowCreate(false); setFormData({}) },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const updateMutation = useMutation({
    mutationFn: ({ id, data }: { id: number; data: any }) => api.put(`${activeEntity.apiPath}/${id}`, data),
    onSuccess: () => { toast.success(t('common.updated')); queryClient.invalidateQueries({ queryKey: ['reference-data', activeTab] }); setEditItem(null); setFormData({}) },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`${activeEntity.apiPath}/${id}`),
    onSuccess: () => { toast.success(t('common.deleted')); queryClient.invalidateQueries({ queryKey: ['reference-data', activeTab] }) },
    onError: (err: any) => toast.error(err.response?.data?.error || t('common.error')),
  })

  function openCreate() {
    const defaults: Record<string, any> = {}
    activeEntity.formFields.forEach(f => { defaults[f.key] = f.type === 'number' ? 0 : '' })
    setFormData(defaults)
    setShowCreate(true)
    setEditItem(null)
  }

  function openEdit(item: any) {
    const vals: Record<string, any> = {}
    activeEntity.formFields.forEach(f => { vals[f.key] = item[f.key] ?? '' })
    setFormData(vals)
    setEditItem(item)
    setShowCreate(false)
  }

  function handleSave(e: React.FormEvent) {
    e.preventDefault()
    const payload = { ...formData }
    if (editItem) {
      updateMutation.mutate({ id: editItem.id, data: payload })
    } else {
      createMutation.mutate(payload)
    }
  }

  function handleDelete(item: any) {
    if (window.confirm(t('common.confirmDelete'))) {
      deleteMutation.mutate(item.id)
    }
  }

  function updateField(key: string, value: any) {
    setFormData(prev => ({ ...prev, [key]: value }))
  }

  const entityColumns = [
    ...activeEntity.columns.map(col => ({
      ...col,
      label: t(col.labelKey),
      render: col.render || ((i: any) => String(i[col.key] ?? '')),
    })),
    ...(canEdit ? [{
      key: 'actions' as string,
      label: '',
      render: (i: any) => (
        <div className="flex gap-1">
          <button onClick={() => openEdit(i)} className="text-slate-400 hover:text-blue-600 p-1"><Pencil className="w-3.5 h-3.5" /></button>
          <button onClick={() => handleDelete(i)} className="text-slate-400 hover:text-red-600 p-1"><Trash2 className="w-3.5 h-3.5" /></button>
        </div>
      ),
    }] : []),
  ]

  const inputClass = "w-full p-2 border rounded text-sm"
  const labelClass = "block text-sm font-medium mb-1"

  const activeFormFields = activeEntity.formFields.map(f => {
    if (f.key === 'institution_type_id' && activeTab === 'institutions') {
      return { ...f, options: (institutionTypes || []).map((t: any) => ({ label: t.name_ar || t.name_en, value: String(t.id) })) }
    }
    return f
  })

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">{t('referenceData.title')}</h1>

      <div className="flex flex-wrap gap-1 mb-4 border-b pb-2">
        {entities.map(e => (
          <button
            key={e.key}
            onClick={() => { setActiveTab(e.key); setShowCreate(false); setEditItem(null) }}
            className={`px-3 py-1.5 text-sm rounded-t transition-colors ${activeTab === e.key ? 'bg-blue-600 text-white' : 'text-slate-600 hover:bg-slate-100'}`}
          >
            {t(e.labelKey)}
          </button>
        ))}
      </div>

      <div className="mb-4">
        <button onClick={openCreate} className="flex items-center gap-1.5 bg-blue-600 text-white px-3 py-1.5 rounded text-sm hover:bg-blue-700">
          <Plus className="w-3.5 h-3.5" /> {t('referenceData.addNew')}
        </button>
      </div>

      {(showCreate || editItem) && (
        <div className="bg-white p-4 rounded-lg border mb-4 max-w-lg">
          <h2 className="font-semibold mb-3 text-sm">{editItem ? t('referenceData.edit') : t('referenceData.addNew')}</h2>
          <form onSubmit={handleSave} className="space-y-3">
            {activeFormFields.map(f => (
              <div key={f.key}>
                <label className={labelClass}>{t(f.labelKey)}{f.required ? ' *' : ''}</label>
                {f.type === 'select' ? (
                  <select value={String(formData[f.key] ?? '')} onChange={e => updateField(f.key, e.target.value)} className={inputClass} required={f.required}>
                    <option value="">--</option>
                    {(f.options || []).map(o => <option key={o.value} value={o.value}>{o.label}</option>)}
                  </select>
                ) : f.type === 'textarea' ? (
                  <textarea value={formData[f.key] ?? ''} onChange={e => updateField(f.key, e.target.value)} className={inputClass} rows={3} />
                ) : f.type === 'number' ? (
                  <input type="number" value={formData[f.key] ?? 0} onChange={e => updateField(f.key, f.type === 'number' ? parseInt(e.target.value) : e.target.value)} className={inputClass} required={f.required} />
                ) : (
                  <input value={formData[f.key] ?? ''} onChange={e => updateField(f.key, e.target.value)} className={inputClass} required={f.required} />
                )}
              </div>
            ))}
            <div className="flex gap-2 pt-1">
              <button type="submit" disabled={createMutation.isPending || updateMutation.isPending}
                className="bg-blue-600 text-white px-4 py-1.5 rounded text-sm disabled:opacity-50">
                {(createMutation.isPending || updateMutation.isPending) ? t('common.saving') : t('common.save')}
              </button>
              <button type="button" onClick={() => { setShowCreate(false); setEditItem(null); setFormData({}) }}
                className="bg-slate-200 text-slate-700 px-4 py-1.5 rounded text-sm">{t('common.cancel')}</button>
            </div>
          </form>
        </div>
      )}

      <DataTable
        searchable
        loading={isLoading}
        columns={entityColumns}
        data={items || []}
        emptyMessage={t('referenceData.empty')}
      />
    </div>
  )
}
