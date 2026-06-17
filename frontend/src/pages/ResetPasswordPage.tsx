import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate, useSearchParams, Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../api/client'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { resetPasswordSchema } from '../lib/schemas'
import { z } from 'zod'

type ResetFormData = z.input<typeof resetPasswordSchema>

export default function ResetPasswordPage() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const token = searchParams.get('token') || ''

  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<ResetFormData>({
    resolver: zodResolver(resetPasswordSchema),
    defaultValues: { token, password: '', confirmPassword: '' },
  })

  async function onSubmit(data: ResetFormData) {
    try {
      await api.post('/security/auth/reset-password', {
        token: data.token,
        password: data.password,
      })
      toast.success(t('resetPassword.success'))
      navigate('/login')
    } catch (err: any) {
      toast.error(err.response?.data?.error || t('resetPassword.failed'))
    }
  }

  if (!token) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-muted px-4">
        <Card className="w-full max-w-sm">
          <CardContent className="text-center py-8">
            <p className="text-red-500 text-sm">{t('resetPassword.invalidToken')}</p>
            <Link to="/forgot-password" className="text-blue-600 hover:underline text-sm">{t('resetPassword.requestNew')}</Link>
          </CardContent>
        </Card>
      </div>
    )
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-muted px-4">
      <Card className="w-full max-w-sm">
        <CardHeader className="text-center">
          <CardTitle className="text-blue-700 text-xl">{t('resetPassword.title')}</CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <Input type="hidden" {...register('token')} />
            <Input type="password" placeholder={t('resetPassword.newPassword')} {...register('password')} />
            {errors.password && <p className="text-red-500 text-xs">{errors.password.message}</p>}
            <Input type="password" placeholder={t('resetPassword.confirmPassword')} {...register('confirmPassword')} />
            {errors.confirmPassword && <p className="text-red-500 text-xs">{errors.confirmPassword.message}</p>}
            <Button type="submit" className="w-full" disabled={isSubmitting}>
              {isSubmitting ? t('common.saving') : t('resetPassword.submit')}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}