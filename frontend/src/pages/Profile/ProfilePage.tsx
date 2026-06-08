import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useEffect } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { toast } from 'sonner'
import api from '../../api/client'
import { useAuth } from '../../context/AuthContext'
import { Card, CardContent } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { Label } from '../../components/ui/label'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import { profileSchema, changePasswordSchema } from '../../lib/schemas'
import { useTranslation } from 'react-i18next'

type ProfileFormData = {
  national_id?: string; passport_number?: string; gender?: string; date_of_birth?: string
  nationality_code?: string; academic_title?: string; specialization?: string; biography?: string
}
type PasswordFormData = { oldPassword: string; newPassword: string; confirmPassword: string }

const GENDERS = ['', 'MALE', 'FEMALE'] as const
const ACADEMIC_TITLES = ['', 'PROFESSOR', 'ASSOCIATE_PROFESSOR', 'ASSISTANT_PROFESSOR', 'LECTURER', 'RESEARCHER', 'SPECIALIST'] as const
const ACADEMIC_TITLE_KEYS: Record<string, string> = {
  PROFESSOR: 'profile.professor',
  ASSOCIATE_PROFESSOR: 'profile.associateProfessor',
  ASSISTANT_PROFESSOR: 'profile.assistantProfessor',
  LECTURER: 'profile.lecturer',
  RESEARCHER: 'profile.researcher',
  SPECIALIST: 'profile.specialist',
}

export default function ProfilePage() {
  const { t } = useTranslation()
  const { user } = useAuth()
  const queryClient = useQueryClient()

  const profileForm = useForm<ProfileFormData>({ resolver: zodResolver(profileSchema) })
  const pwForm = useForm<PasswordFormData>({ resolver: zodResolver(changePasswordSchema) })

  const { data: profile, isLoading } = useQuery({
    queryKey: ['my-profile'],
    queryFn: () => api.get('/security/profile').then((r) => r.data.data),
  })

  useEffect(() => {
    if (profile) {
      profileForm.reset({
        national_id: profile.national_id || '',
        passport_number: profile.passport_number || '',
        gender: profile.gender || '',
        date_of_birth: profile.date_of_birth ? profile.date_of_birth.split('T')[0] : '',
        nationality_code: profile.nationality_code || '',
        academic_title: profile.academic_title || '',
        specialization: profile.specialization || '',
        biography: profile.biography || '',
      })
    }
  }, [profile])

  const mutation = useMutation({
    mutationFn: (body: any) => api.put('/security/profile', body),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['my-profile'] })
      toast.success(t('profile.updated'))
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('profile.updateFailed')),
  })

  function onSubmitProfile(data: ProfileFormData) {
    mutation.mutate(data)
  }

  const pwMutation = useMutation({
    mutationFn: (data: { oldPassword: string; newPassword: string }) => api.post('/security/auth/change-password', data),
    onSuccess: () => {
      toast.success(t('profile.passwordChanged'))
      pwForm.reset()
    },
    onError: (err: any) => toast.error(err.response?.data?.error || t('profile.passwordChangeFailed')),
  })

  function onSubmitPassword(data: PasswordFormData) {
    pwMutation.mutate({ oldPassword: data.oldPassword, newPassword: data.newPassword })
  }

  if (isLoading) return <PageSkeleton />

  return (
    <div className="max-w-2xl">
      <h1 className="text-2xl font-bold mb-6">{t('profile.title')}</h1>
      <p className="text-sm text-slate-500 mb-4">{user?.username} — {user?.email} ({user?.roles?.join(', ')})</p>

      <form onSubmit={profileForm.handleSubmit(onSubmitProfile)} className="space-y-6">
        <Card>
          <CardContent className="p-6 space-y-4">
            <h2 className="font-semibold text-sm text-slate-700 border-b pb-2">{t('profile.identificationDocs')}</h2>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">{t('profile.nationalId')}</label>
                <input {...profileForm.register('national_id')} className="w-full p-2 border rounded text-sm" placeholder={t('profile.encrypted')} />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('profile.passport')}</label>
                <input {...profileForm.register('passport_number')} className="w-full p-2 border rounded text-sm" placeholder={t('profile.encrypted')} />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6 space-y-4">
            <h2 className="font-semibold text-sm text-slate-700 border-b pb-2">{t('profile.personalDetails')}</h2>
            <div className="grid grid-cols-2 gap-4">
              <div>
                <label className="block text-sm font-medium mb-1">{t('profile.gender')}</label>
                <select {...profileForm.register('gender')} className="w-full p-2 border rounded text-sm">
                  {GENDERS.map((g) => (
                    <option key={g} value={g}>{g === 'MALE' ? t('profile.male') : g === 'FEMALE' ? t('profile.female') : ''}</option>
                  ))}
                </select>
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('profile.dateOfBirth')}</label>
                <input type="date" {...profileForm.register('date_of_birth')} className="w-full p-2 border rounded text-sm" />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('profile.nationality')}</label>
                <input {...profileForm.register('nationality_code')} className="w-full p-2 border rounded text-sm" placeholder={t('profile.nationalityHint')} />
              </div>
              <div>
                <label className="block text-sm font-medium mb-1">{t('profile.academicTitle')}</label>
                <select {...profileForm.register('academic_title')} className="w-full p-2 border rounded text-sm">
                  {ACADEMIC_TITLES.map((at) => (
                    <option key={at} value={at}>{at ? t(ACADEMIC_TITLE_KEYS[at]) : ''}</option>
                  ))}
                </select>
              </div>
              <div className="col-span-2">
                <label className="block text-sm font-medium mb-1">{t('profile.specialization')}</label>
                <input {...profileForm.register('specialization')} className="w-full p-2 border rounded text-sm" />
              </div>
            </div>
          </CardContent>
        </Card>

        <Card>
          <CardContent className="p-6 space-y-4">
            <h2 className="font-semibold text-sm text-slate-700 border-b pb-2">{t('profile.biography')}</h2>
            <textarea {...profileForm.register('biography')} className="w-full p-2 border rounded text-sm" rows={4} />
          </CardContent>
        </Card>

        <div className="flex gap-3">
          <Button type="submit" disabled={mutation.isPending}>
            {mutation.isPending ? t('common.saving') : t('profile.saveProfile')}
          </Button>
        </div>
      </form>

      <Card className="mt-8">
        <CardContent className="p-6 space-y-4">
          <h2 className="font-semibold text-sm text-slate-700 border-b pb-2">{t('profile.changePassword')}</h2>
          <form onSubmit={pwForm.handleSubmit(onSubmitPassword)} className="space-y-3 max-w-sm">
            <div>
              <Label>{t('profile.currentPassword')}</Label>
              <Input type="password" {...pwForm.register('oldPassword')} />
              {pwForm.formState.errors.oldPassword && <p className="text-red-500 text-xs">{pwForm.formState.errors.oldPassword.message}</p>}
            </div>
            <div>
              <Label>{t('profile.newPassword')}</Label>
              <Input type="password" {...pwForm.register('newPassword')} />
              {pwForm.formState.errors.newPassword && <p className="text-red-500 text-xs">{pwForm.formState.errors.newPassword.message}</p>}
            </div>
            <div>
              <Label>{t('profile.confirmNewPassword')}</Label>
              <Input type="password" {...pwForm.register('confirmPassword')} />
              {pwForm.formState.errors.confirmPassword && <p className="text-red-500 text-xs">{pwForm.formState.errors.confirmPassword.message}</p>}
            </div>
            <Button type="submit" variant="outline" disabled={pwMutation.isPending}>
              {pwMutation.isPending ? t('profile.changing') : t('profile.changePassword')}
            </Button>
          </form>
        </CardContent>
      </Card>
    </div>
  )
}
