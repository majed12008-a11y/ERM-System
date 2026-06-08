import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { useTranslation } from 'react-i18next'
import api from '../../api/client'
import { useAuth } from '../../context/AuthContext'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { Input } from '../../components/ui/input'
import { StatusBadge } from '../../components/StatusBadge'
import { meetingAgendaSchema, agendaItemSchema, attendanceSchema, minutesSchema, votingSessionSchema } from '../../lib/schemas'
import { z } from 'zod'
import { ArrowLeft, CalendarDays, FileText, UserCheck, MessageSquare, Vote } from 'lucide-react'
import { PageSkeleton } from '../../components/LoadingSkeleton'

export default function MeetingDetail() {
  const { t } = useTranslation()
  const { id } = useParams()
  const navigate = useNavigate()
  const { user } = useAuth()
  const queryClient = useQueryClient()
  const canEdit = user?.roles?.some(r => ['ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'].includes(r))

  const { data: meeting, isLoading } = useQuery({
    queryKey: ['meeting', id],
    queryFn: () => api.get(`/committee/meetings/${id}`).then(r => r.data.data),
    enabled: !!id,
  })

  const { data: agenda } = useQuery({
    queryKey: ['meeting-agenda', id],
    queryFn: () => api.get(`/committee/meetings/${id}/agenda`).then(r => r.data.data),
    enabled: !!id,
  })

  const { data: attendance } = useQuery({
    queryKey: ['meeting-attendance', id],
    queryFn: () => api.get(`/committee/meetings/${id}/attendance`).then(r => r.data.data),
    enabled: !!id,
  })

  const { data: minutes } = useQuery({
    queryKey: ['meeting-minutes', id],
    queryFn: () => api.get(`/committee/meetings/${id}/minutes`).then(r => r.data.data),
    enabled: !!id,
  })

  const { data: members } = useQuery({
    queryKey: ['meeting-members', id],
    queryFn: () => api.get(`/committee/meetings/${id}/committee-members`).then(r => r.data.data),
    enabled: !!id,
  })

  const updateMeeting = useMutation({
    mutationFn: (data: any) => api.patch(`/committee/meetings/${id}`, data),
    onSuccess: () => { queryClient.invalidateQueries({ queryKey: ['meeting', id] }) },
  })

  const [statusFilter, setStatusFilter] = useState('')
  const [activeAgendaId, setActiveAgendaId] = useState<number | null>(null)

  const agendaForm = useForm<{ title: string; description?: string }>({
    resolver: zodResolver(meetingAgendaSchema),
    defaultValues: { title: '', description: '' },
  })
  const itemForm = useForm<{ title: string; application_id?: string }>({
    resolver: zodResolver(agendaItemSchema),
    defaultValues: { title: '', application_id: '' },
  })
  const attendForm = useForm<z.input<typeof attendanceSchema>>({
    resolver: zodResolver(attendanceSchema),
    defaultValues: { user_id: '', attendance_status: 'PRESENT', remarks: '' },
  })
  const minutesForm = useForm<{ minutes_text: string }>({
    resolver: zodResolver(minutesSchema),
    defaultValues: { minutes_text: '' },
  })
  const voteForm = useForm<{ application_id: string }>({
    resolver: zodResolver(votingSessionSchema),
    defaultValues: { application_id: '' },
  })

  const { data: votingSessions } = useQuery({
    queryKey: ['voting-sessions', id],
    queryFn: () => api.get(`/committee/voting/meeting/${id}`).then(r => r.data.data),
    enabled: !!id,
  })

  const [voteErrors, setVoteErrors] = useState<Record<string, string>>({})

  async function onAgenda(data: { title: string; description?: string }) {
    await api.post(`/committee/meetings/${id}/agenda`, data)
    agendaForm.reset()
    queryClient.invalidateQueries({ queryKey: ['meeting-agenda'] })
  }

  async function onItem(data: { title: string; application_id?: string }, agendaId: number) {
    await api.post(`/committee/meetings/${id}/agenda/${agendaId}/items`, { title: data.title, application_id: data.application_id || null })
    itemForm.reset()
    setActiveAgendaId(null)
    queryClient.invalidateQueries({ queryKey: ['meeting-agenda'] })
  }

  async function onAttendance(data: z.input<typeof attendanceSchema>) {
    await api.post(`/committee/meetings/${id}/attendance`, { user_id: parseInt(data.user_id), attendance_status: data.attendance_status, remarks: data.remarks })
    attendForm.reset()
    queryClient.invalidateQueries({ queryKey: ['meeting-attendance'] })
  }

  async function onMinutes(data: { minutes_text: string }) {
    await api.post(`/committee/meetings/${id}/minutes`, data)
    minutesForm.reset()
    queryClient.invalidateQueries({ queryKey: ['meeting-minutes'] })
  }

  async function approveMinutes(minutesId: number) {
    await api.patch(`/committee/meetings/${id}/minutes/${minutesId}/approve`)
    queryClient.invalidateQueries({ queryKey: ['meeting-minutes'] })
  }

  async function onNewVote(data: { application_id: string }) {
    await api.post('/committee/voting/sessions', { application_id: parseInt(data.application_id), meeting_id: parseInt(id!), voting_type: 'MAJORITY' })
    voteForm.reset()
    queryClient.invalidateQueries({ queryKey: ['voting-sessions'] })
  }

  async function castVote(sessionId: number, voteValue: string) {
    try {
      await api.post(`/committee/voting/sessions/${sessionId}/vote`, { vote_value: voteValue })
      setVoteErrors({ ...voteErrors, [sessionId]: '' })
      queryClient.invalidateQueries({ queryKey: ['voting-sessions'] })
    } catch (err: any) {
      setVoteErrors({ ...voteErrors, [sessionId]: err.response?.data?.error || t('meetings.voteFailed') })
    }
  }

  async function closeSession(sessionId: number) {
    await api.patch(`/committee/voting/sessions/${sessionId}/close`)
    queryClient.invalidateQueries({ queryKey: ['voting-sessions'] })
  }

  if (isLoading) return <PageSkeleton />
  if (!meeting) return <p className="text-red-500">{t('meetings.notFound')}</p>

  return (
    <div>
      <button onClick={() => navigate('/committee/meetings')} className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4">
        <ArrowLeft className="w-4 h-4" /> {t('meetings.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold">{meeting.meeting_number}</h1>
        <div className="flex items-center gap-2">
          <StatusBadge status={meeting.meeting_status} />
          {canEdit && (
            <select value={statusFilter || meeting.meeting_status} onChange={e => { setStatusFilter(e.target.value); updateMeeting.mutate({ meeting_status: e.target.value }) }}
              className="text-sm border rounded p-1">
              <option value="SCHEDULED">{t('meetings.scheduledLabel')}</option>
              <option value="IN_PROGRESS">{t('meetings.inProgressLabel')}</option>
              <option value="COMPLETED">{t('meetings.completedLabel')}</option>
              <option value="CANCELLED">{t('meetings.cancelledLabel')}</option>
            </select>
          )}
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-6">
        <div className="bg-white rounded-lg shadow p-4 flex items-center gap-3">
          <div className="bg-slate-100 p-2 rounded"><CalendarDays className="w-5 h-5 text-slate-600" /></div>
          <div><p className="text-xs text-slate-500">{t('meetings.date')}</p><p className="text-sm font-medium">{new Date(meeting.meeting_date).toLocaleString()}</p></div>
        </div>
        <div className="bg-white rounded-lg shadow p-4 flex items-center gap-3">
          <div className="bg-slate-100 p-2 rounded"><FileText className="w-5 h-5 text-slate-600" /></div>
          <div><p className="text-xs text-slate-500">{t('meetings.committee')}</p><p className="text-sm font-medium">{meeting.committee_name || '\u2014'}</p></div>
        </div>
        <div className="bg-white rounded-lg shadow p-4 flex items-center gap-3">
          <div className="bg-slate-100 p-2 rounded"><UserCheck className="w-5 h-5 text-slate-600" /></div>
          <div><p className="text-xs text-slate-500">{t('meetings.location')}</p><p className="text-sm font-medium">{meeting.location || '\u2014'}</p></div>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div className="lg:col-span-2 space-y-6">
          <Card>
            <CardHeader><CardTitle className="text-sm flex items-center gap-2"><FileText className="w-4 h-4" /> {t('meetings.agenda')}</CardTitle></CardHeader>
            <CardContent>
              {agenda && agenda.length > 0 ? agenda.map((a: any) => (
                <div key={a.id} className="mb-4 pb-3 border-b last:border-0">
                  <p className="font-medium text-sm">{a.title}</p>
                  {a.description && <p className="text-xs text-slate-500">{a.description}</p>}
                  {a.items && a.items.length > 0 && (
                    <div className="ms-4 mt-2 space-y-1">
                      {a.items.map((item: any) => (
                        <div key={item.id} className="flex items-center gap-2 text-xs">
                          <span className="text-slate-400">#{item.item_order}</span>
                          <span className="font-medium">{item.title}</span>
                          {item.app_number && <span className="text-blue-600">({item.app_number})</span>}
                        </div>
                      ))}
                    </div>
                  )}
                  {canEdit && (
                    <div className="mt-2">
                      {activeAgendaId === a.id ? (
                        <form onSubmit={itemForm.handleSubmit((data) => onItem(data, a.id))} className="flex gap-2 items-center">
                          <Input size={20} placeholder={t('meetings.itemTitle')} {...itemForm.register('title')} className="text-xs" />
                          <Input size={10} placeholder={t('meetings.appId')} {...itemForm.register('application_id')} className="text-xs w-20" />
                          <Button type="submit" size="sm">{t('common.add')}</Button>
                          <button type="button" className="text-xs text-slate-400" onClick={() => { setActiveAgendaId(null); itemForm.reset() }}>{t('common.cancel')}</button>
                        </form>
                      ) : (
                        <Button size="sm" variant="outline" className="text-xs" onClick={() => setActiveAgendaId(a.id)}>{t('meetings.addItem')}</Button>
                      )}
                    </div>
                  )}
                </div>
              )) : <p className="text-sm text-slate-400">{t('meetings.noAgendaItems')}</p>}
              {canEdit && (
                <form onSubmit={agendaForm.handleSubmit(onAgenda)} className="mt-3 pt-3 border-t space-y-2">
                  <p className="text-xs font-medium text-slate-500">{t('meetings.addAgenda')}</p>
                  <Input placeholder={t('meetings.titlePlaceholder')} {...agendaForm.register('title')} className="text-sm" />
                  {agendaForm.formState.errors.title && <p className="text-red-500 text-xs">{agendaForm.formState.errors.title.message}</p>}
                  <Input placeholder={t('meetings.descriptionOptional')} {...agendaForm.register('description')} className="text-sm" />
                  <Button type="submit" size="sm">{t('meetings.addAgenda')}</Button>
                </form>
              )}
            </CardContent>
          </Card>
        </div>

        <div className="space-y-6">
          <Card>
            <CardHeader><CardTitle className="text-sm flex items-center gap-2"><UserCheck className="w-4 h-4" /> {t('meetings.attendance')}</CardTitle></CardHeader>
            <CardContent>
              {attendance && attendance.length > 0 ? (
                <div className="space-y-2">
                  {attendance.map((a: any) => (
                    <div key={a.id} className="flex items-center justify-between text-sm border-b pb-1 last:border-0">
                      <span className="font-medium">{a.display_name || a.username}</span>
                      <StatusBadge status={a.attendance_status} />
                    </div>
                  ))}
                </div>
              ) : <p className="text-sm text-slate-400">{t('meetings.noAttendance')}</p>}
              {canEdit && members && (
                <form onSubmit={attendForm.handleSubmit(onAttendance)} className="mt-3 pt-3 border-t space-y-2">
                  <p className="text-xs font-medium text-slate-500">{t('meetings.markAttendance')}</p>
                  <select {...attendForm.register('user_id')} className="w-full p-2 border rounded text-sm">
                    <option value="">{t('meetings.selectMember')}</option>
                    {members.map((m: any) => <option key={m.id} value={m.user_id}>{m.display_name || m.username}</option>)}
                  </select>
                  {attendForm.formState.errors.user_id && <p className="text-red-500 text-xs">{attendForm.formState.errors.user_id.message}</p>}
                  <select {...attendForm.register('attendance_status')} className="w-full p-2 border rounded text-sm">
                    <option value="PRESENT">{t('meetings.present')}</option>
                    <option value="ABSENT">{t('meetings.absent')}</option>
                    <option value="EXCUSED">{t('meetings.excused')}</option>
                    <option value="LATE">{t('meetings.late')}</option>
                  </select>
                  <Input placeholder={t('meetings.remarks')} {...attendForm.register('remarks')} className="text-sm" />
                  <Button type="submit" size="sm" className="w-full">{t('meetings.record')}</Button>
                </form>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader><CardTitle className="text-sm flex items-center gap-2"><MessageSquare className="w-4 h-4" /> {t('meetings.minutes')}</CardTitle></CardHeader>
            <CardContent>
              {minutes && minutes.length > 0 ? minutes.map((m: any) => (
                <div key={m.id} className="text-sm border-b pb-2 mb-2 last:border-0">
                  <p className="text-xs text-slate-600 whitespace-pre-wrap">{m.minutes_text}</p>
                  {m.created_by_username && <p className="text-xs text-slate-400 mt-1">{t('meetings.by', { name: m.created_by_username })}</p>}
                  <div className="flex items-center gap-2 mt-1">
                    <StatusBadge status={m.approved_by ? 'APPROVED' : 'DRAFT'} />
                    {m.approved_by_username && <span className="text-xs text-slate-400">{t('meetings.approvedBy', { name: m.approved_by_username })}</span>}
                    {m.signatures && m.signatures.length > 0 && (
                      <span className="text-xs text-green-600 font-medium">{t('meetings.signatures', { count: m.signatures.length })}</span>
                    )}
                  </div>
                  {m.signatures && m.signatures.length > 0 && (
                    <div className="mt-1 flex flex-wrap gap-2">
                      {m.signatures.map((s: any) => (
                        <span key={s.id} className="text-xs bg-green-50 text-green-700 px-1.5 py-0.5 rounded flex items-center gap-1">
                          {'\u270D'} {s.signer_name}
                        </span>
                      ))}
                    </div>
                  )}
                  <div className="flex gap-2 mt-1">
                    {canEdit && !m.approved_by && (
                      <button className="text-xs text-blue-600 hover:underline" onClick={() => approveMinutes(m.id)}>{t('meetings.voteApprove')}</button>
                    )}
                    {canEdit && m.signatures && !m.signatures.find((s: any) => s.signer_id === user?.id) && (
                      <button className="text-xs text-green-600 hover:underline" onClick={() => approveMinutes(m.id)}>{t('signatures.sign')}</button>
                    )}
                  </div>
                </div>
              )) : <p className="text-sm text-slate-400">{t('meetings.noMinutes')}</p>}
              {canEdit && (
                <form onSubmit={minutesForm.handleSubmit(onMinutes)} className="mt-3 pt-3 border-t space-y-2">
                  <p className="text-xs font-medium text-slate-500">{t('meetings.addMinutes')}</p>
                  <textarea {...minutesForm.register('minutes_text')} className="w-full p-2 border rounded text-sm" rows={4} />
                  {minutesForm.formState.errors.minutes_text && <p className="text-red-500 text-xs">{minutesForm.formState.errors.minutes_text.message}</p>}
                  <Button type="submit" size="sm" className="w-full">{t('meetings.addMinutes')}</Button>
                </form>
              )}
            </CardContent>
          </Card>

          <Card>
            <CardHeader><CardTitle className="text-sm flex items-center gap-2"><Vote className="w-4 h-4" /> {t('meetings.voting')}</CardTitle></CardHeader>
            <CardContent>
              {votingSessions && votingSessions.length > 0 ? votingSessions.map((s: any) => (
                <div key={s.id} className="text-sm border-b pb-3 mb-3 last:border-0">
                  <div className="flex items-center justify-between">
                    <div>
                      <p className="font-medium">{s.project_title || s.application_number}</p>
                      <StatusBadge status={s.status_code} />
                    </div>
                    {canEdit && s.status_code === 'OPEN' && (
                      <Button size="sm" variant="outline" className="text-xs" onClick={() => closeSession(s.id)}>{t('meetings.closeVoting')}</Button>
                    )}
                  </div>
                  {s.votes && s.votes.length > 0 && (
                    <div className="mt-2 space-y-1">
                      {s.votes.map((v: any) => (
                        <div key={v.id} className="flex items-center justify-between text-xs">
                          <span>{v.voter_name}</span>
                          <StatusBadge status={v.vote_value} />
                        </div>
                      ))}
                    </div>
                  )}
                  {s.status_code === 'OPEN' && !s.votes?.find((v: any) => v.voter_id === user?.id) && (
                    <div className="mt-2 flex gap-1">
                      <Button size="sm" variant="outline" className="text-xs text-green-600" onClick={() => castVote(s.id, 'APPROVE')}>{t('meetings.voteApprove')}</Button>
                      <Button size="sm" variant="outline" className="text-xs text-red-600" onClick={() => castVote(s.id, 'REJECT')}>{t('meetings.voteReject')}</Button>
                      <Button size="sm" variant="outline" className="text-xs text-slate-500" onClick={() => castVote(s.id, 'ABSTAIN')}>{t('meetings.voteAbstain')}</Button>
                    </div>
                  )}
                  {voteErrors[s.id] && <p className="text-red-500 text-xs mt-1">{voteErrors[s.id]}</p>}
                </div>
              )) : <p className="text-sm text-slate-400">{t('meetings.noVotingSessions')}</p>}
              {canEdit && (
                <form onSubmit={voteForm.handleSubmit(onNewVote)} className="mt-3 pt-3 border-t space-y-2">
                  <p className="text-xs font-medium text-slate-500">{t('meetings.newVotingSession')}</p>
                  <Input placeholder={t('meetings.applicationId')} {...voteForm.register('application_id')} className="text-sm" />
                  {voteForm.formState.errors.application_id && <p className="text-red-500 text-xs">{voteForm.formState.errors.application_id.message}</p>}
                  <Button type="submit" size="sm" className="w-full">{t('meetings.startVote')}</Button>
                </form>
              )}
            </CardContent>
          </Card>
        </div>
      </div>
    </div>
  )
}
