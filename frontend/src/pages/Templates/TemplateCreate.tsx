/*
 * صفحة إنشاء قالب جديد: نموذج بيانات القالب مع التحقق.
 */
import { useState } from 'react'
import { useQuery, useMutation } from '@tanstack/react-query'
import { useTranslation } from 'react-i18next'
import { useNavigate } from 'react-router-dom'
import { toast } from 'sonner'
import { ArrowLeft, Save } from 'lucide-react'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { templates } from '../../sdk/domains/templates.sdk'
import type { TemplateCategory } from '../../sdk/domains/templates.sdk'

interface FormData {
  code: string
  name_ar: string
  name_en: string
  description: string
  category_id: string
  engine: string
  default_locale: string
  tags: string
}

const INITIAL: FormData = {
  code: '',
  name_ar: '',
  name_en: '',
  description: '',
  category_id: '',
  engine: 'handlebars',
  default_locale: 'ar',
  tags: '',
}

export default function TemplateCreate() {
  const { t } = useTranslation()
  const navigate = useNavigate()

  const [form, setForm] = useState<FormData>(INITIAL)
  const [errors, setErrors] = useState<Partial<Record<keyof FormData, string>>>({})

  const { data: categories } = useQuery({
    queryKey: ['template-categories'],
    queryFn: () => templates.listCategories().then(r => r.data.data),
  })

  const createMutation = useMutation({
    mutationFn: () => templates.create({
      code: form.code,
      name_ar: form.name_ar,
      name_en: form.name_en,
      description: form.description || undefined,
      category_id: Number(form.category_id),
      engine: form.engine,
      default_locale: form.default_locale,
      tags: form.tags ? form.tags.split(',').map(t => t.trim()).filter(Boolean) : [],
    }),
    onSuccess: (res) => {
      toast.success(t('templates.create.success'))
      navigate(`/templates/${res.data.data.id}`)
    },
    onError: (err: any) => {
      const msg = err?.response?.data?.error || t('templates.create.failed')
      toast.error(msg)
    },
  })

  function validate(): boolean {
    const e: Partial<Record<keyof FormData, string>> = {}
    if (!form.code.trim()) e.code = t('templates.create.codeRequired')
    if (!form.name_ar.trim()) e.name_ar = t('templates.create.nameArRequired')
    if (!form.category_id) e.category_id = t('templates.create.categoryRequired')
    setErrors(e)
    return Object.keys(e).length === 0
  }

  function handleSubmit(ev: React.FormEvent) {
    ev.preventDefault()
    if (!validate()) return
    createMutation.mutate()
  }

  function updateField(key: keyof FormData, value: string) {
    setForm(prev => ({ ...prev, [key]: value }))
    if (errors[key]) setErrors(prev => ({ ...prev, [key]: undefined }))
  }

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <button onClick={() => navigate('/templates')} className="p-1 text-slate-400 hover:text-slate-600">
          <ArrowLeft className="w-5 h-5" />
        </button>
        <h1 className="text-2xl font-bold">{t('templates.create.title')}</h1>
      </div>

      <Card className="max-w-2xl">
        <CardHeader>
          <CardTitle className="text-sm">{t('templates.create.formTitle')}</CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit} className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">
                {t('templates.create.code')} <span className="text-red-500">*</span>
              </label>
              <Input
                value={form.code}
                onChange={(e) => updateField('code', e.target.value)}
                placeholder={t('templates.create.codePlaceholder')}
                className={errors.code ? 'border-red-500' : ''}
              />
              {errors.code && <p className="text-xs text-red-500 mt-1">{errors.code}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">
                {t('templates.create.nameAr')} <span className="text-red-500">*</span>
              </label>
              <Input
                value={form.name_ar}
                onChange={(e) => updateField('name_ar', e.target.value)}
                placeholder={t('templates.create.nameArPlaceholder')}
                dir="rtl"
                className={errors.name_ar ? 'border-red-500' : ''}
              />
              {errors.name_ar && <p className="text-xs text-red-500 mt-1">{errors.name_ar}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">
                {t('templates.create.nameEn')}
              </label>
              <Input
                value={form.name_en}
                onChange={(e) => updateField('name_en', e.target.value)}
                placeholder={t('templates.create.nameEnPlaceholder')}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">
                {t('templates.create.description')}
              </label>
              <textarea
                value={form.description}
                onChange={(e) => updateField('description', e.target.value)}
                className="w-full border rounded p-2 text-sm"
                rows={3}
                placeholder={t('templates.create.descriptionPlaceholder')}
              />
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">
                {t('templates.create.category')} <span className="text-red-500">*</span>
              </label>
              <select
                value={form.category_id}
                onChange={(e) => updateField('category_id', e.target.value)}
                className={`w-full p-2 border rounded text-sm ${errors.category_id ? 'border-red-500' : ''}`}
              >
                <option value="">{t('templates.create.selectCategory')}</option>
                {(categories || []).map((cat: TemplateCategory) => (
                  <option key={cat.id} value={cat.id}>{cat.name_ar}</option>
                ))}
              </select>
              {errors.category_id && <p className="text-xs text-red-500 mt-1">{errors.category_id}</p>}
            </div>

            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  {t('templates.create.engine')}
                </label>
                <select
                  value={form.engine}
                  onChange={(e) => updateField('engine', e.target.value)}
                  className="w-full p-2 border rounded text-sm"
                >
                  <option value="handlebars">Handlebars</option>
                  <option value="mustache">Mustache</option>
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium text-slate-700 mb-1">
                  {t('templates.create.defaultLocale')}
                </label>
                <select
                  value={form.default_locale}
                  onChange={(e) => updateField('default_locale', e.target.value)}
                  className="w-full p-2 border rounded text-sm"
                >
                  <option value="ar">{t('templates.preview.arabic')}</option>
                  <option value="en">{t('templates.preview.english')}</option>
                </select>
              </div>
            </div>

            <div>
              <label className="block text-sm font-medium text-slate-700 mb-1">
                {t('templates.create.tags')}
              </label>
              <Input
                value={form.tags}
                onChange={(e) => updateField('tags', e.target.value)}
                placeholder={t('templates.create.tagsPlaceholder')}
              />
              <p className="text-xs text-slate-400 mt-1">{t('templates.create.tagsHint')}</p>
            </div>

            <div className="flex items-center gap-3 pt-4 border-t">
              <Button type="submit" disabled={createMutation.isPending}>
                <Save className="w-4 h-4 mr-1" />
                {createMutation.isPending ? t('common.loading') : t('common.create')}
              </Button>
              <Button type="button" variant="outline" onClick={() => navigate('/templates')}>
                {t('common.cancel')}
              </Button>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
