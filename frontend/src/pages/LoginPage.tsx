import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate, Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { useAuth } from '../context/AuthContext'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Card, CardContent } from '../components/ui/card'
import { loginSchema } from '../lib/schemas'
import { AxiosError } from 'axios'
import { Mail, Lock, Loader2 } from 'lucide-react'

type LoginFormData = { username: string; password: string }

export default function LoginPage() {
  const { t } = useTranslation()
  const { login } = useAuth()
  const navigate = useNavigate()
  const [loginError, setLoginError] = useState<string | null>(null)
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
  })

  async function onSubmit(data: LoginFormData) {
    setLoginError(null)
    try {
      await login(data.username, data.password)
      navigate('/')
    } catch (err: unknown) {
      const axiosErr = err instanceof AxiosError ? err : undefined
      const message = axiosErr?.response?.data?.error || t('login.failed')
      setLoginError(message)
      toast.error(message)
    }
  }

  return (
    <div className="min-h-screen flex">
      {/* Hero section — hidden on mobile */}
      <div className="hidden md:flex w-1/2 bg-gradient-to-br from-[#0a2540] to-[#0f3b6a] items-center justify-center relative overflow-hidden">
        <img
          src="/branding/logo-icon.svg"
          alt=""
          className="absolute -bottom-20 -end-20 w-96 h-96 opacity-5 pointer-events-none"
        />
        <div className="text-center space-y-6 max-w-md px-8">
          <img src="/branding/logo-icon.svg" alt="NERMS" className="w-20 h-20 mx-auto" />
          <h1 className="text-3xl font-bold text-white leading-snug">
            النظام الوطني لإدارة<br />
            الموافقات الأخلاقية
          </h1>
          <p className="text-white/70 text-sm">
            National Ethics Research Management System
          </p>
          <p className="text-white/50 text-xs">
            Ministry of Health — Republic of Yemen
          </p>
        </div>
      </div>

      {/* Login card */}
      <div className="flex-1 flex items-center justify-center bg-muted p-4">
        <Card className="w-full max-w-md shadow-lg">
          <CardContent className="pt-8 pb-6 px-8">
            <div className="text-center mb-6 space-y-3">
              <img src="/branding/logo-icon.svg" alt="NERMS" className="w-12 h-12 mx-auto" />
              <h2 className="text-xl font-semibold text-foreground">{t('login.signIn')}</h2>
              <p className="text-sm text-muted-foreground">{t('app.title')}</p>
            </div>

            {loginError && (
              <div role="alert" className="bg-danger-light text-danger rounded-lg px-4 py-3 text-sm mb-4">
                {loginError}
              </div>
            )}

            <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
              <div>
                <label htmlFor="username" className="text-sm font-medium text-foreground block mb-1">
                  {t('login.username')}
                </label>
                <div className="relative">
                  <Mail className="absolute start-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <Input
                    id="username"
                    type="text"
                    autoComplete="username"
                    aria-invalid={!!errors.username}
                    aria-describedby={errors.username ? 'username-error' : undefined}
                    className="ps-9"
                    placeholder={t('login.username')}
                    {...register('username')}
                  />
                </div>
                {errors.username && (
                  <p id="username-error" className="text-sm text-destructive mt-1" role="alert">
                    {errors.username.message}
                  </p>
                )}
              </div>

              <div>
                <label htmlFor="password" className="text-sm font-medium text-foreground block mb-1">
                  {t('login.password')}
                </label>
                <div className="relative">
                  <Lock className="absolute start-3 top-1/2 -translate-y-1/2 w-4 h-4 text-muted-foreground" />
                  <Input
                    id="password"
                    type="password"
                    autoComplete="current-password"
                    aria-invalid={!!errors.password}
                    aria-describedby={errors.password ? 'password-error' : undefined}
                    className="ps-9"
                    placeholder={t('login.password')}
                    {...register('password')}
                  />
                </div>
                {errors.password && (
                  <p id="password-error" className="text-sm text-destructive mt-1" role="alert">
                    {errors.password.message}
                  </p>
                )}
              </div>

              <Button type="submit" className="w-full" disabled={isSubmitting}>
                {isSubmitting && <Loader2 className="w-4 h-4 me-2 animate-spin" />}
                {isSubmitting ? t('login.signingIn') : t('login.signIn')}
              </Button>

              <div className="text-center text-sm text-muted-foreground space-y-2 pt-2">
                <p>
                  {t('login.noAccount')}{' '}
                  <Link to="/register" className="text-primary hover:underline font-medium">
                    {t('login.createOne')}
                  </Link>
                </p>
                <Link to="/forgot-password" className="text-primary hover:underline text-xs">
                  {t('login.forgotPassword')}
                </Link>
              </div>
            </form>
          </CardContent>
        </Card>
      </div>
    </div>
  )
}
