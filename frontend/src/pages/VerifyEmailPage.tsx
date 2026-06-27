/*
 * صفحة التحقق من البريد الإلكتروني: تأكيد رمز التحقق
 * المرسل عبر البريد لتفعيل الحساب الجديد.
 */
import { useEffect, useState } from 'react'
import { useSearchParams, Link } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import api from '../api/client'
import { Button } from '../components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '../components/ui/card'

export default function VerifyEmailPage() {
  const { t } = useTranslation()
  const [searchParams] = useSearchParams()
  const token = searchParams.get('token')
  const [status, setStatus] = useState<'loading' | 'success' | 'error'>('loading')
  const [message, setMessage] = useState('')

  useEffect(() => {
    if (!token) {
      setStatus('error')
      setMessage(t('verifyEmail.noToken'))
      return
    }
    api.post('/security/auth/verify-email', { token })
      .then(() => {
        setStatus('success')
        setMessage(t('verifyEmail.success'))
      })
      .catch((err) => {
        setStatus('error')
        setMessage(err.response?.data?.error || t('verifyEmail.failed'))
      })
  }, [token, t])

  return (
    <div className="min-h-screen flex items-center justify-center bg-muted px-4">
      <Card className="w-full max-w-sm">
        <CardHeader className="text-center">
          <CardTitle className="text-blue-700 text-xl sm:text-2xl">{t('app.title')}</CardTitle>
        </CardHeader>
        <CardContent className="text-center space-y-4">
          {status === 'loading' && <p className="text-slate-500">{t('verifyEmail.verifying')}</p>}
          {status === 'success' && (
            <>
              <div className="text-green-600 text-4xl">✓</div>
              <p className="text-green-700">{message}</p>
              <Link to="/login"><Button>{t('verifyEmail.goToLogin')}</Button></Link>
            </>
          )}
          {status === 'error' && (
            <>
              <div className="text-red-600 text-4xl">✗</div>
              <p className="text-red-700">{message}</p>
              <Link to="/login"><Button variant="outline">{t('verifyEmail.goToLogin')}</Button></Link>
            </>
          )}
        </CardContent>
      </Card>
    </div>
  )
}
