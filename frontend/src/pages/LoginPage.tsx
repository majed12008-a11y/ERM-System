/*
 * صفحة تسجيل الدخول: نموذج إدخال اسم المستخدم وكلمة المرور،
 * مع رابط لاستعادة كلمة المرور والتسجيل.
 */
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useNavigate, Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { useAuth } from '../context/AuthContext'
import { Button } from '../components/ui/button'
import { Input } from '../components/ui/input'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'
import { loginSchema } from '../lib/schemas'

type LoginFormData = { username: string; password: string }

export default function LoginPage() {
  const { t } = useTranslation()
  const { login } = useAuth()
  const navigate = useNavigate()
  const { register, handleSubmit, formState: { errors, isSubmitting } } = useForm<LoginFormData>({
    resolver: zodResolver(loginSchema),
  })

  async function onSubmit(data: LoginFormData) {
    try {
      await login(data.username, data.password)
      navigate('/')
    } catch (err: any) {
      toast.error(err.response?.data?.error || t('login.failed'))
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-muted px-4">
      <Card className="w-full max-w-sm">
        <CardHeader className="text-center">
          <CardTitle className="text-blue-700 text-xl sm:text-2xl">{t('app.title')}</CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={handleSubmit(onSubmit)} className="space-y-4">
            <Input type="text" placeholder={t('login.username')} {...register('username')} />
            {errors.username && <p className="text-red-500 text-xs">{errors.username.message}</p>}
            <Input type="password" placeholder={t('login.password')} {...register('password')} />
            {errors.password && <p className="text-red-500 text-xs">{errors.password.message}</p>}
            <Button type="submit" className="w-full" disabled={isSubmitting}>{t('login.signIn')}</Button>
            <div className="text-center text-sm text-slate-500 space-y-1">
              <p>
                {t('login.noAccount')}{' '}
                <Link to="/register" className="text-blue-600 hover:underline">{t('login.createOne')}</Link>
              </p>
              <Link to="/forgot-password" className="text-blue-600 hover:underline text-xs">{t('login.forgotPassword')}</Link>
            </div>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
