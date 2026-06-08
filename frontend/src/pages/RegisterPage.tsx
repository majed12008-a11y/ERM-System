import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate, Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { useQuery } from '@tanstack/react-query'
import { toast } from 'sonner'
import api from '../api/client'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { registerSchema } from '../lib/schemas'
import { z } from 'zod'

type RegisterFormData = z.input<typeof registerSchema>

export default function RegisterPage() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const [submitting, setSubmitting] = useState(false)

  const { register, handleSubmit, formState: { errors } } = useForm<RegisterFormData>({
    resolver: zodResolver(registerSchema),
    defaultValues: {
      username: '', email: '', password: '', confirmPassword: '',
      first_name_ar: '', last_name_ar: '', first_name_en: '', last_name_en: '',
      mobile: '', institution_id: '',
    },
  })

  const { data: institutions } = useQuery({
    queryKey: ['institutions-registry'],
    queryFn: () => api.get('/reference/institutions-registry').then(r => r.data.data || []),
    retry: 1,
    staleTime: 5 * 60 * 1000,
  })

  async function onSubmit(data: RegisterFormData) {
    setSubmitting(true)
    try {
      const { confirmPassword, ...body } = data
      await api.post('/security/auth/register', body)
      toast.success(t('register.success'))
      navigate('/login')
    } catch (err: any) {
      toast.error(err.response?.data?.error || t('register.failed'))
    } finally {
      setSubmitting(false)
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-muted px-4 py-8">
      <Card className="w-full max-w-md">
        <CardHeader className="text-center">
          <CardTitle className="text-blue-700 text-xl sm:text-2xl">{t('register.title')}</CardTitle>
          <p className="text-sm text-slate-500 mt-1">{t('register.subtitle')}</p>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <div>
              <Input type="text" placeholder={t('register.username')} {...register('username')} />
              {errors.username && <p className="text-red-500 text-xs mt-1">{errors.username.message}</p>}
            </div>
            <div>
              <Input type="email" placeholder={t('register.email')} {...register('email')} />
              {errors.email && <p className="text-red-500 text-xs mt-1">{errors.email.message}</p>}
            </div>
            <div className="grid grid-cols-2 gap-3">
              <input placeholder={t('register.firstNameAr')} {...register('first_name_ar')} className="p-2 border rounded text-sm" />
              <input placeholder={t('register.lastNameAr')} {...register('last_name_ar')} className="p-2 border rounded text-sm" />
            </div>
            <div className="grid grid-cols-2 gap-3">
              <input placeholder={t('register.firstNameEn')} {...register('first_name_en')} className="p-2 border rounded text-sm" />
              <input placeholder={t('register.lastNameEn')} {...register('last_name_en')} className="p-2 border rounded text-sm" />
            </div>
            <div className="grid grid-cols-2 gap-3">
              <input placeholder={t('register.mobile')} type="tel" {...register('mobile')} className="p-2 border rounded text-sm" />
              <select {...register('institution_id')} className="p-2 border rounded text-sm w-full">
                <option value="">{t('register.institution')}</option>
                {(institutions || []).map((i: any) => (
                  <option key={i.id} value={String(i.id)}>{i.name_ar || i.name_en}</option>
                ))}
              </select>
              {errors.institution_id && <p className="text-red-500 text-xs mt-1">{errors.institution_id.message}</p>}
            </div>
            <div>
              <Input type="password" placeholder={t('register.password')} {...register('password')} />
              {errors.password && <p className="text-red-500 text-xs mt-1">{errors.password.message}</p>}
            </div>
            <div>
              <Input type="password" placeholder={t('register.confirmPassword')} {...register('confirmPassword')} />
              {errors.confirmPassword && <p className="text-red-500 text-xs mt-1">{errors.confirmPassword.message}</p>}
            </div>
            <Button type="submit" className="w-full" disabled={submitting}>
              {submitting ? t('register.creating') : t('register.submit')}
            </Button>
            <p className="text-center text-sm text-slate-500">
              {t('register.hasAccount')}{' '}
              <Link to="/login" className="text-blue-600 hover:underline">{t('register.signIn')}</Link>
            </p>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
