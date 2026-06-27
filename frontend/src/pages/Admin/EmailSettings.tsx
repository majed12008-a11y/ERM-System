/*
 * صفحة إعدادات البريد الإلكتروني: تكوين SMTP،
 * اختبار الاتصال، وإدارة قوالب البريد.
 */
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'
import { useEffect } from 'react'
import { toast } from 'sonner'
import { useTranslation } from 'react-i18next'
import api from '../../api/client'
import { Card, CardContent, CardHeader, CardTitle, CardDescription } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import { Switch } from '../../components/ui/switch'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import { Plus, Trash2 } from 'lucide-react'

const emailConfigSchema = z.object({
  config_name: z.string().min(1),
  smtp_host: z.string().min(1),
  smtp_port: z.coerce.number().int().min(1).max(65535),
  smtp_username: z.string().optional().default(''),
  smtp_password: z.string().optional().default(''),
  use_tls: z.boolean().default(true),
  from_address: z.string().email(),
  from_name: z.string().optional().default(''),
  is_active: z.boolean().default(true),
})

type FormData = z.input<typeof emailConfigSchema>

function ConfigForm({ config, onDone }: { config?: any; onDone: () => void }) {
  const { t } = useTranslation()
  const queryClient = useQueryClient()

  const { register, handleSubmit, reset, watch, setValue, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(emailConfigSchema),
    defaultValues: { config_name: '', smtp_host: '', smtp_port: 587, smtp_username: '', smtp_password: '', use_tls: true, from_address: '', from_name: '', is_active: true },
  })

  const watchUseTls = watch('use_tls')
  const watchIsActive = watch('is_active')

  useEffect(() => {
    if (config) {
      reset({
        config_name: config.config_name || '',
        smtp_host: config.smtp_host || '',
        smtp_port: config.smtp_port || 587,
        smtp_username: config.smtp_username || '',
        smtp_password: '',
        use_tls: config.use_tls !== false,
        from_address: config.from_address || '',
        from_name: config.from_name || '',
        is_active: config.is_active !== false,
      })
    }
  }, [config, reset])

  const createMutation = useMutation({
    mutationFn: (body: FormData) => api.post('/admin/email-config', body),
    onSuccess: () => { toast.success(t('emailSettings.saved')); queryClient.invalidateQueries({ queryKey: ['email-configs'] }); onDone() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('emailSettings.saveFailed')),
  })

  const updateMutation = useMutation({
    mutationFn: (body: FormData) => api.put(`/admin/email-config/${config.id}`, body),
    onSuccess: () => { toast.success(t('emailSettings.saved')); queryClient.invalidateQueries({ queryKey: ['email-configs'] }); onDone() },
    onError: (err: any) => toast.error(err.response?.data?.error || t('emailSettings.saveFailed')),
  })

  const onSubmit = (data: FormData) => {
    if (config) updateMutation.mutate(data)
    else createMutation.mutate(data)
  }

  const isPending = createMutation.isPending || updateMutation.isPending

  return (
    <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
      <div className="grid grid-cols-2 gap-4">
        <div>
          <Label>{t('emailSettings.configName')}</Label>
          <Input {...register('config_name')} />
          {errors.config_name && <p className="text-red-500 text-xs mt-1">{t('emailSettings.required')}</p>}
        </div>
        <div>
          <Label>{t('emailSettings.smtpHost')}</Label>
          <Input {...register('smtp_host')} />
          {errors.smtp_host && <p className="text-red-500 text-xs mt-1">{t('emailSettings.required')}</p>}
        </div>
        <div>
          <Label>{t('emailSettings.smtpPort')}</Label>
          <Input type="number" {...register('smtp_port')} />
          {errors.smtp_port && <p className="text-red-500 text-xs mt-1">{t('emailSettings.invalidPort')}</p>}
        </div>
        <div>
          <Label>{t('emailSettings.fromAddress')}</Label>
          <Input {...register('from_address')} />
          {errors.from_address && <p className="text-red-500 text-xs mt-1">{t('emailSettings.invalidEmail')}</p>}
        </div>
        <div>
          <Label>{t('emailSettings.fromName')}</Label>
          <Input {...register('from_name')} />
        </div>
        <div>
          <Label>{t('emailSettings.smtpUsername')}</Label>
          <Input {...register('smtp_username')} />
        </div>
        <div>
          <Label>{t('emailSettings.smtpPassword')}</Label>
          <Input type="password" {...register('smtp_password')} placeholder={config ? '••••••••' : ''} />
        </div>
        <div className="flex items-end gap-4 pb-2">
          <div className="flex items-center gap-2">
            <Switch id="email-use-tls" checked={watchUseTls} onCheckedChange={(v) => setValue('use_tls', v)} />
            <Label htmlFor="email-use-tls">{t('emailSettings.useTLS')}</Label>
          </div>
          <div className="flex items-center gap-2">
            <Switch id="email-active" checked={watchIsActive} onCheckedChange={(v) => setValue('is_active', v)} />
            <Label htmlFor="email-active">{t('emailSettings.isActive')}</Label>
          </div>
        </div>
      </div>
      <Button type="submit" disabled={isPending}>{isPending ? t('common.saving') : t('common.save')}</Button>
    </form>
  )
}

export default function EmailSettings() {
  const { t } = useTranslation()
  const queryClient = useQueryClient()

  const { data: configs, isLoading } = useQuery({
    queryKey: ['email-configs'],
    queryFn: () => api.get('/admin/email-config').then(r => r.data.data),
  })

  const deleteMutation = useMutation({
    mutationFn: (id: number) => api.delete(`/admin/email-config/${id}`),
    onSuccess: () => { toast.success(t('emailSettings.configDeleted')); queryClient.invalidateQueries({ queryKey: ['email-configs'] }) },
    onError: (err: any) => toast.error(err.response?.data?.error || t('emailSettings.saveFailed')),
  })

  const testMutation = useMutation({
    mutationFn: () => api.post('/admin/email-config/test', {}),
    onSuccess: () => toast.success(t('emailSettings.testSent')),
    onError: (err: any) => toast.error(err.response?.data?.error || t('emailSettings.testFailed')),
  })

  if (isLoading) return <PageSkeleton />

  return (
    <div className="max-w-4xl">
      <h1 className="text-2xl font-bold mb-2">{t('emailSettings.title')}</h1>
      <p className="text-muted-foreground mb-6">{t('emailSettings.description')}</p>

      {(!configs || configs.length === 0) ? (
        <Card>
          <CardContent className="py-8 text-center">
            <p className="text-muted-foreground mb-4">{t('emailSettings.noConfig')}</p>
            <Button onClick={() => queryClient.invalidateQueries({ queryKey: ['email-configs'] })}>
              <Plus className="ml-2 h-4 w-4" />
              {t('emailSettings.addConfig')}
            </Button>
          </CardContent>
        </Card>
      ) : (
        <div className="space-y-4">
          {configs.map((config: any) => (
            <Card key={config.id}>
              <CardHeader className="flex flex-row items-center justify-between">
                <div>
                  <CardTitle>{config.config_name}</CardTitle>
                  <CardDescription>{config.smtp_host}:{config.smtp_port}</CardDescription>
                </div>
                <div className="flex items-center gap-2">
                  <span className={`px-2 py-1 text-xs rounded-full ${config.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-600'}`}>
                    {config.is_active ? t('emailSettings.active') : t('emailSettings.inactive')}
                  </span>
                </div>
              </CardHeader>
              <CardContent>
                <ConfigForm config={config} onDone={() => queryClient.invalidateQueries({ queryKey: ['email-configs'] })} />
                <div className="flex gap-2 mt-4 pt-4 border-t">
                  <Button variant="outline" size="sm" onClick={() => testMutation.mutate()} disabled={testMutation.isPending}>
                    {t('emailSettings.test')}
                  </Button>
                  <Button variant="destructive" size="sm" onClick={() => { if (confirm(t('common.confirmDelete'))) deleteMutation.mutate(config.id) }} disabled={deleteMutation.isPending}>
                    <Trash2 className="ml-1 h-4 w-4" />
                    {t('emailSettings.deleteConfig')}
                  </Button>
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  )
}
