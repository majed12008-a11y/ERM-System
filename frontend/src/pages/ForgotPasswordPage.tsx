/*
 * صفحة استعادة كلمة المرور: إدخال البريد الإلكتروني
 * لإرسال رابط إعادة تعيين كلمة المرور.
 */
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import api from '../api/client'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { forgotPasswordSchema } from '../lib/schemas'
import { z } from 'zod'

type ForgotFormData = z.input<typeof forgotPasswordSchema>

export default function ForgotPasswordPage() {
  const { t } = useTranslation()
  const [sent, setSent] = useState(false)
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<ForgotFormData>({
    resolver: zodResolver(forgotPasswordSchema),
  })

  async function onSubmit(data: ForgotFormData) {
    try {
      await api.post('/security/auth/forgot-password', data)
      setSent(true)
      toast.success(t('forgotPassword.sent'))
    } catch {
      toast.error(t('forgotPassword.failed'))
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-muted px-4">
      <Card className="w-full max-w-sm">
        <CardHeader className="text-center">
          <CardTitle className="text-blue-700 text-xl">{t('forgotPassword.title')}</CardTitle>
        </CardHeader>
        <CardContent>
          {sent ? (
            <p className="text-center text-green-600 text-sm">{t('forgotPassword.checkEmail')}</p>
          ) : (
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
              <Input type="email" placeholder={t('forgotPassword.email')} {...register('email')} />
              {errors.email && <p className="text-red-500 text-xs">{errors.email.message}</p>}
              <Button type="submit" className="w-full" disabled={isSubmitting}>
                {isSubmitting ? t('common.sending') : t('forgotPassword.send')}
              </Button>
              <p className="text-center text-sm text-slate-500">
                <Link to="/login" className="text-blue-600 hover:underline">{t('forgotPassword.backToLogin')}</Link>
              </p>
            </form>
          )}
        </CardContent>
      </Card>
    </div>
  )
}