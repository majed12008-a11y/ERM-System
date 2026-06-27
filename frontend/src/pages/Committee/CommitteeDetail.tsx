/*
 * صفحة تفاصيل اللجنة: معلومات اللجنة، الأعضاء، الصلاحيات،
 * والطلبات المرتبطة بها.
 */
import { useParams, useNavigate } from 'react-router-dom'
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { committees, members } from '../../sdk/domains/committee.sdk'
import { Card, CardContent, CardHeader, CardTitle } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { PageSkeleton } from '../../components/LoadingSkeleton'
import {
  ArrowLeft, Users, Building2, Tag, CalendarDays, UserPlus, Trash2,
  Eye, CalendarPlus, Award, AlertTriangle, FileText,
  Plus
} from 'lucide-react'
import {
  Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger,
} from '../../components/ui/dialog'
import api from '../../api/client'

type Tab = 'members' | 'details' | 'meetings'

export default function CommitteeDetail() {
  const { t } = useTranslation()
  const { id } = useParams()
  const navigate = useNavigate()
  const queryClient = useQueryClient()
  const [activeTab, setActiveTab] = useState<Tab>('members')
  const [addDialogOpen, setAddDialogOpen] = useState(false)
  const [selectedUserId, setSelectedUserId] = useState('')
  const [selectedRoleId, setSelectedRoleId] = useState('')
  const [memberDetailOpen, setMemberDetailOpen] = useState(false)
  const [selectedMember, setSelectedMember] = useState<any>(null)
  const [memberDetailTab, setMemberDetailTab] = useState<'terms' | 'qualifications' | 'conflicts'>('terms')
  const [meetingDialogOpen, setMeetingDialogOpen] = useState(false)
  const [meetingDate, setMeetingDate] = useState('')
  const [meetingLocation, setMeetingLocation] = useState('')

  const committeeId = Number(id)

  const { data: committee, isLoading } = useQuery({
    queryKey: ['committee', committeeId],
    queryFn: () => committees.getById(committeeId).then(r => r.data.data),
    enabled: !!committeeId,
  })

  const { data: memberList, isLoading: membersLoading } = useQuery({
    queryKey: ['committee-members', committeeId],
    queryFn: () => members.listByCommittee(committeeId).then(r => r.data.data),
    enabled: !!committeeId,
  })

  const { data: meetingsList } = useQuery({
    queryKey: ['committee-meetings', committeeId],
    queryFn: () => api.get(`/committee/meetings/committee/${committeeId}`).then(r => r.data.data),
    enabled: !!committeeId,
  })

  const { data: committeeRoles } = useQuery({
    queryKey: ['committee-roles'],
    queryFn: () => committees.listRoles().then(r => r.data.data),
  })

  const { data: users } = useQuery({
    queryKey: ['users'],
    queryFn: () => api.get('/security/users').then(r => r.data.data),
  })

  const { data: memberTerms } = useQuery({
    queryKey: ['member-terms', selectedMember?.id],
    queryFn: () => members.getTerms(selectedMember.id).then(r => r.data.data),
    enabled: !!selectedMember && memberDetailOpen,
  })

  const { data: memberQualifications } = useQuery({
    queryKey: ['member-qualifications', selectedMember?.id],
    queryFn: () => members.getQualifications(selectedMember.id).then(r => r.data.data),
    enabled: !!selectedMember && memberDetailOpen,
  })

  const { data: memberConflicts } = useQuery({
    queryKey: ['member-conflicts', selectedMember?.id],
    queryFn: () => members.getConflicts(selectedMember.id).then(r => r.data.data),
    enabled: !!selectedMember && memberDetailOpen,
  })

  const addMember = useMutation({
    mutationFn: () => {
      const payload: { user_id: number; role_id?: number } = { user_id: Number(selectedUserId) }
      const roleId = Number(selectedRoleId)
      if (roleId > 0) payload.role_id = roleId
      return members.add(committeeId, payload)
    },
    onSuccess: () => {
      toast.success(t('committeeDetail.memberAdded'))
      queryClient.invalidateQueries({ queryKey: ['committee-members'] })
      setAddDialogOpen(false)
      setSelectedUserId('')
      setSelectedRoleId('')
    },
    onError: (err: any) => {
      toast.error(err?.response?.data?.error || err.message)
    },
  })

  const removeMember = useMutation({
    mutationFn: (memberId: number) => members.remove(committeeId, memberId),
    onSuccess: () => {
      toast.success(t('committeeDetail.memberRemoved'))
      queryClient.invalidateQueries({ queryKey: ['committee-members'] })
    },
    onError: (err: any) => {
      toast.error(err?.response?.data?.error || err.message)
    },
  })

  const updateRole = useMutation({
    mutationFn: ({ memberId, role_id }: { memberId: number; role_id: number }) =>
      members.updateRole(committeeId, memberId, { role_id }),
    onSuccess: () => {
      toast.success(t('committeeDetail.roleUpdated'))
      queryClient.invalidateQueries({ queryKey: ['committee-members'] })
    },
    onError: (err: any) => {
      toast.error(err?.response?.data?.error || err.message)
    },
  })

  const createMeeting = useMutation({
    mutationFn: () =>
      api.post('/committee/meetings', {
        committee_id: committeeId,
        meeting_date: meetingDate,
        location: meetingLocation || undefined,
      }),
    onSuccess: () => {
      toast.success(t('meetings.created'))
      queryClient.invalidateQueries({ queryKey: ['committee-meetings'] })
      setMeetingDialogOpen(false)
      setMeetingDate('')
      setMeetingLocation('')
    },
    onError: (err: any) => {
      toast.error(err?.response?.data?.error || err.message)
    },
  })

  const addTerm = useMutation({
    mutationFn: (data: any) => members.addTerm(selectedMember!.id, data),
    onSuccess: () => {
      toast.success('Term added')
      queryClient.invalidateQueries({ queryKey: ['member-terms'] })
    },
    onError: (err: any) => toast.error(err?.response?.data?.error || err.message),
  })

  const addQualification = useMutation({
    mutationFn: (data: any) => members.addQualification(selectedMember!.id, data),
    onSuccess: () => {
      toast.success('Qualification added')
      queryClient.invalidateQueries({ queryKey: ['member-qualifications'] })
    },
    onError: (err: any) => toast.error(err?.response?.data?.error || err.message),
  })

  const declareConflict = useMutation({
    mutationFn: (data: any) => members.declareConflict(selectedMember!.id, data),
    onSuccess: () => {
      toast.success('Conflict declared')
      queryClient.invalidateQueries({ queryKey: ['member-conflicts'] })
    },
    onError: (err: any) => toast.error(err?.response?.data?.error || err.message),
  })

  if (isLoading) return <PageSkeleton />
  if (!committee) return <p className="text-red-500">{t('committeeDetail.notFound')}</p>

  const tabs: { key: Tab; label: string; icon: React.ComponentType<{ className?: string }> }[] = [
    { key: 'members', label: t('committees.members'), icon: Users },
    { key: 'details', label: t('committeeDetail.details'), icon: Building2 },
    { key: 'meetings', label: t('meetings.title'), icon: CalendarDays },
  ]

  const handleRoleChange = (memberId: number, role_id: string) => {
    if (role_id) updateRole.mutate({ memberId, role_id: Number(role_id) })
  }

  const memberColumns = [
    { key: 'display_name', label: t('committeeDetail.memberName'), sortable: true },
    { key: 'username', label: t('committeeDetail.memberUsername') },
    {
      key: 'role_name', label: t('committeeDetail.role'), render: (m: any) => (
        <select
          value={m.role_id ?? ''}
          onChange={e => handleRoleChange(m.id, e.target.value)}
          className="text-xs p-1 border rounded bg-white"
        >
          <option value="">{t('committeeDetail.noRole')}</option>
          {(committeeRoles || []).map((r: any) => (
            <option key={r.id} value={String(r.id)}>{r.role_name}</option>
          ))}
        </select>
      ),
    },
    {
      key: 'is_active', label: t('common.status'), render: (m: any) => (
        <StatusBadge status={m.is_active ? 'ACTIVE' : 'INACTIVE'} />
      ),
    },
    {
      key: 'actions', label: '', render: (m: any) => (
        <div className="flex items-center gap-1">
          <Button variant="ghost" size="sm" onClick={() => { setSelectedMember(m); setMemberDetailOpen(true) }} className="text-slate-400 hover:text-blue-600">
            <Eye className="w-4 h-4" />
          </Button>
          <Button variant="ghost" size="sm" onClick={(e) => { e.stopPropagation(); removeMember.mutate(m.id) }} className="text-red-500 hover:text-red-700">
            <Trash2 className="w-4 h-4" />
          </Button>
        </div>
      ),
    },
  ]

  return (
    <div>
      <button onClick={() => navigate('/committee/committees')} className="flex items-center gap-1 text-sm text-slate-500 hover:text-slate-700 mb-4">
        <ArrowLeft className="w-4 h-4" /> {t('committeeDetail.back')}
      </button>

      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="text-2xl font-bold">{committee.committee_name_ar}</h1>
          <p className="text-sm text-slate-500">{committee.committee_code}</p>
        </div>
        <StatusBadge status={committee.is_active ? 'ACTIVE' : 'INACTIVE'} />
      </div>

      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <Card>
          <CardContent className="flex items-center gap-3 p-4">
            <div className="bg-slate-100 p-2 rounded"><Building2 className="w-5 h-5 text-slate-600" /></div>
            <div>
              <p className="text-xs text-slate-500">{t('committees.institution')}</p>
              <p className="text-sm font-medium">{committee.institution_name || '\u2014'}</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="flex items-center gap-3 p-4">
            <div className="bg-slate-100 p-2 rounded"><Tag className="w-5 h-5 text-slate-600" /></div>
            <div>
              <p className="text-xs text-slate-500">{t('committees.type')}</p>
              <p className="text-sm font-medium">{committee.committee_type_name || '\u2014'}</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="flex items-center gap-3 p-4">
            <div className="bg-slate-100 p-2 rounded"><Users className="w-5 h-5 text-slate-600" /></div>
            <div>
              <p className="text-xs text-slate-500">{t('committees.members')}</p>
              <p className="text-sm font-medium">{memberList?.length || 0}</p>
            </div>
          </CardContent>
        </Card>
        <Card>
          <CardContent className="flex items-center gap-3 p-4">
            <div className="bg-slate-100 p-2 rounded"><CalendarDays className="w-5 h-5 text-slate-600" /></div>
            <div>
              <p className="text-xs text-slate-500">{t('committeeDetail.established')}</p>
              <p className="text-sm font-medium">{committee.created_at ? new Date(committee.created_at).toLocaleDateString() : '\u2014'}</p>
            </div>
          </CardContent>
        </Card>
      </div>

      <div className="flex gap-1 border-b mb-6">
        {tabs.map(tab => (
          <button
            key={tab.key}
            onClick={() => setActiveTab(tab.key)}
            className={`flex items-center gap-2 px-4 py-2 text-sm font-medium border-b-2 transition-colors ${
              activeTab === tab.key
                ? 'border-blue-600 text-blue-600'
                : 'border-transparent text-slate-500 hover:text-slate-700'
            }`}
          >
            <tab.icon className="w-4 h-4" />
            {tab.label}
          </button>
        ))}
      </div>

      {activeTab === 'members' && (
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-sm">{t('committeeDetail.membersList')}</CardTitle>
            <Dialog open={addDialogOpen} onOpenChange={setAddDialogOpen}>
              <DialogTrigger asChild>
                <Button size="sm"><UserPlus className="w-4 h-4" /> {t('committeeDetail.addMember')}</Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>{t('committeeDetail.addMember')}</DialogTitle>
                </DialogHeader>
                <div className="space-y-4">
                  <div>
                    <label className="text-sm font-medium block mb-1">{t('committeeDetail.memberName')}</label>
                    <select
                      value={selectedUserId}
                      onChange={e => setSelectedUserId(e.target.value)}
                      className="w-full p-2 border rounded text-sm"
                    >
                      <option value="">{t('committeeDetail.selectUser')}</option>
                      {(users || []).map((u: any) => (
                        <option key={u.id} value={String(u.id)}>{u.display_name || u.username}</option>
                      ))}
                    </select>
                  </div>
                  <div>
                    <label className="text-sm font-medium block mb-1">{t('committeeDetail.role')}</label>
                    <select
                      value={selectedRoleId}
                      onChange={e => setSelectedRoleId(e.target.value)}
                      className="w-full p-2 border rounded text-sm"
                    >
                      <option value="">{t('committeeDetail.noRole')}</option>
                      {(committeeRoles || []).map((r: any) => (
                        <option key={r.id} value={String(r.id)}>{r.role_name}</option>
                      ))}
                    </select>
                  </div>
                  <Button
                    onClick={() => addMember.mutate()}
                    disabled={!selectedUserId || addMember.isPending}
                    className="w-full"
                  >
                    {addMember.isPending ? t('common.saving') : t('common.add')}
                  </Button>
                </div>
              </DialogContent>
            </Dialog>
          </CardHeader>
          <CardContent>
            <DataTable
              columns={memberColumns}
              data={memberList || []}
              loading={membersLoading}
              emptyMessage={t('committeeDetail.noMembers')}
            />
          </CardContent>
        </Card>
      )}

      {activeTab === 'details' && (
        <Card>
          <CardHeader><CardTitle className="text-sm">{t('committeeDetail.details')}</CardTitle></CardHeader>
          <CardContent>
            <dl className="grid grid-cols-1 md:grid-cols-2 gap-4">
              <div>
                <dt className="text-xs text-slate-500">{t('committees.code')}</dt>
                <dd className="text-sm font-medium">{committee.committee_code}</dd>
              </div>
              <div>
                <dt className="text-xs text-slate-500">{t('committees.nameAr')}</dt>
                <dd className="text-sm font-medium">{committee.committee_name_ar}</dd>
              </div>
              <div>
                <dt className="text-xs text-slate-500">{t('committees.nameEn')}</dt>
                <dd className="text-sm font-medium">{committee.committee_name_en || '\u2014'}</dd>
              </div>
              <div>
                <dt className="text-xs text-slate-500">{t('committees.type')}</dt>
                <dd className="text-sm font-medium">{committee.committee_type_name}</dd>
              </div>
              <div>
                <dt className="text-xs text-slate-500">{t('committees.institution')}</dt>
                <dd className="text-sm font-medium">{committee.institution_name}</dd>
              </div>
              <div>
                <dt className="text-xs text-slate-500">{t('committeeDetail.established')}</dt>
                <dd className="text-sm font-medium">{committee.created_at ? new Date(committee.created_at).toLocaleDateString() : '\u2014'}</dd>
              </div>
            </dl>
          </CardContent>
        </Card>
      )}

      {activeTab === 'meetings' && (
        <Card>
          <CardHeader className="flex flex-row items-center justify-between">
            <CardTitle className="text-sm">{t('meetings.title')}</CardTitle>
            <Dialog open={meetingDialogOpen} onOpenChange={setMeetingDialogOpen}>
              <DialogTrigger asChild>
                <Button size="sm"><CalendarPlus className="w-4 h-4" /> {t('meetings.schedule')}</Button>
              </DialogTrigger>
              <DialogContent>
                <DialogHeader>
                  <DialogTitle>{t('meetings.scheduleNew')}</DialogTitle>
                </DialogHeader>
                <div className="space-y-4">
                  <div>
                    <label className="text-sm font-medium block mb-1">{t('meetings.date')}</label>
                    <input
                      type="datetime-local"
                      value={meetingDate}
                      onChange={e => setMeetingDate(e.target.value)}
                      className="w-full p-2 border rounded text-sm"
                    />
                  </div>
                  <div>
                    <label className="text-sm font-medium block mb-1">{t('meetings.location')}</label>
                    <input
                      value={meetingLocation}
                      onChange={e => setMeetingLocation(e.target.value)}
                      placeholder={t('meetings.locationPlaceholder')}
                      className="w-full p-2 border rounded text-sm"
                    />
                  </div>
                  <Button
                    onClick={() => createMeeting.mutate()}
                    disabled={!meetingDate || createMeeting.isPending}
                    className="w-full"
                  >
                    {createMeeting.isPending ? t('common.saving') : t('meetings.create')}
                  </Button>
                </div>
              </DialogContent>
            </Dialog>
          </CardHeader>
          <CardContent>
            {meetingsList && meetingsList.length > 0 ? (
              <div className="space-y-2">
                {meetingsList.map((m: any) => (
                  <div
                    key={m.id}
                    className="flex items-center justify-between p-3 border rounded hover:bg-slate-50 cursor-pointer"
                    onClick={() => navigate(`/committee/meetings/${m.id}`)}
                  >
                    <div>
                      <p className="text-sm font-medium">{m.meeting_number}</p>
                      <p className="text-xs text-slate-500">{new Date(m.meeting_date).toLocaleString()}</p>
                    </div>
                    <StatusBadge status={m.meeting_status} />
                  </div>
                ))}
              </div>
            ) : (
              <p className="text-sm text-slate-400">{t('committeeDetail.noMeetings')}</p>
            )}
          </CardContent>
        </Card>
      )}

      {/* Member Detail Dialog */}
      <Dialog open={memberDetailOpen} onOpenChange={setMemberDetailOpen}>
        <DialogContent className="max-w-2xl">
          <DialogHeader>
            <DialogTitle>{selectedMember?.display_name || selectedMember?.username}</DialogTitle>
          </DialogHeader>
          {selectedMember && (
            <div>
              <div className="flex gap-1 border-b mb-4">
                {([
                  { key: 'terms', label: t('committeeDetail.terms'), icon: FileText },
                  { key: 'qualifications', label: t('committeeDetail.qualifications'), icon: Award },
                  { key: 'conflicts', label: t('committeeDetail.conflicts'), icon: AlertTriangle },
                ] as const).map(tab => (
                  <button
                    key={tab.key}
                    onClick={() => setMemberDetailTab(tab.key)}
                    className={`flex items-center gap-2 px-3 py-2 text-xs font-medium border-b-2 transition-colors ${
                      memberDetailTab === tab.key
                        ? 'border-blue-600 text-blue-600'
                        : 'border-transparent text-slate-500 hover:text-slate-700'
                    }`}
                  >
                    <tab.icon className="w-3.5 h-3.5" />
                    {tab.label}
                  </button>
                ))}
              </div>

              {memberDetailTab === 'terms' && (
                <MemberTermsSection
                  terms={memberTerms || []}
                  onAdd={(data) => addTerm.mutate(data)}
                  isPending={addTerm.isPending}
                />
              )}
              {memberDetailTab === 'qualifications' && (
                <MemberQualificationsSection
                  qualifications={memberQualifications || []}
                  onAdd={(data) => addQualification.mutate(data)}
                  isPending={addQualification.isPending}
                />
              )}
              {memberDetailTab === 'conflicts' && (
                <MemberConflictsSection
                  conflicts={memberConflicts || []}
                  onAdd={(data) => declareConflict.mutate(data)}
                  isPending={declareConflict.isPending}
                />
              )}
            </div>
          )}
        </DialogContent>
      </Dialog>
    </div>
  )
}

function MemberTermsSection({ terms, onAdd, isPending }: { terms: any[]; onAdd: (data: any) => void; isPending: boolean }) {
  const { t } = useTranslation()
  const [showForm, setShowForm] = useState(false)
  const [startDate, setStartDate] = useState('')
  const [endDate, setEndDate] = useState('')
  const [decisionNo, setDecisionNo] = useState('')

  function handleSubmit() {
    if (!startDate) return
    onAdd({ start_date: startDate, end_date: endDate || null, appointment_decision_no: decisionNo || null })
    setStartDate('')
    setEndDate('')
    setDecisionNo('')
    setShowForm(false)
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-3">
        <p className="text-sm font-medium">{t('committeeDetail.termsList')}</p>
        <Button size="sm" variant="outline" onClick={() => setShowForm(!showForm)}>
          <Plus className="w-3.5 h-3.5" /> {t('common.add')}
        </Button>
      </div>
      {showForm && (
        <div className="bg-slate-50 p-3 rounded mb-3 space-y-2">
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.startDate')}</label>
              <input type="date" value={startDate} onChange={e => setStartDate(e.target.value)} className="w-full p-1.5 border rounded text-sm" />
            </div>
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.endDate')}</label>
              <input type="date" value={endDate} onChange={e => setEndDate(e.target.value)} className="w-full p-1.5 border rounded text-sm" />
            </div>
          </div>
          <div>
            <label className="text-xs text-slate-500">{t('committeeDetail.decisionNo')}</label>
            <input value={decisionNo} onChange={e => setDecisionNo(e.target.value)} className="w-full p-1.5 border rounded text-sm" />
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={handleSubmit} disabled={!startDate || isPending}>
              {isPending ? t('common.saving') : t('common.save')}
            </Button>
            <Button size="sm" variant="outline" onClick={() => setShowForm(false)}>{t('common.cancel')}</Button>
          </div>
        </div>
      )}
      {terms.length === 0 ? (
        <p className="text-sm text-slate-400">{t('committeeDetail.noTerms')}</p>
      ) : (
        <div className="space-y-2">
          {terms.map((term: any) => (
            <div key={term.id} className="text-sm border-b pb-2">
              <div className="flex items-center justify-between">
                <span className="font-medium">{new Date(term.start_date).toLocaleDateString()} - {term.end_date ? new Date(term.end_date).toLocaleDateString() : '\u2014'}</span>
                <StatusBadge status={term.is_active ? 'ACTIVE' : 'INACTIVE'} />
              </div>
              {term.appointment_decision_no && <p className="text-xs text-slate-500">{t('committeeDetail.decisionNo')}: {term.appointment_decision_no}</p>}
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

function MemberQualificationsSection({ qualifications, onAdd, isPending }: { qualifications: any[]; onAdd: (data: any) => void; isPending: boolean }) {
  const { t } = useTranslation()
  const [showForm, setShowForm] = useState(false)
  const [specialization, setSpecialization] = useState('')
  const [degree, setDegree] = useState('')
  const [institutionName, setInstitutionName] = useState('')
  const [experienceYears, setExperienceYears] = useState('')

  function handleSubmit() {
    if (!specialization || !degree) return
    onAdd({ specialization, academic_degree: degree, institution_name: institutionName || null, experience_years: experienceYears ? parseInt(experienceYears) : null })
    setSpecialization('')
    setDegree('')
    setInstitutionName('')
    setExperienceYears('')
    setShowForm(false)
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-3">
        <p className="text-sm font-medium">{t('committeeDetail.qualificationsList')}</p>
        <Button size="sm" variant="outline" onClick={() => setShowForm(!showForm)}>
          <Plus className="w-3.5 h-3.5" /> {t('common.add')}
        </Button>
      </div>
      {showForm && (
        <div className="bg-slate-50 p-3 rounded mb-3 space-y-2">
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.specialization')}</label>
              <input value={specialization} onChange={e => setSpecialization(e.target.value)} className="w-full p-1.5 border rounded text-sm" />
            </div>
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.degree')}</label>
              <input value={degree} onChange={e => setDegree(e.target.value)} className="w-full p-1.5 border rounded text-sm" />
            </div>
          </div>
          <div className="grid grid-cols-2 gap-2">
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.institution')}</label>
              <input value={institutionName} onChange={e => setInstitutionName(e.target.value)} className="w-full p-1.5 border rounded text-sm" />
            </div>
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.experienceYears')}</label>
              <input type="number" value={experienceYears} onChange={e => setExperienceYears(e.target.value)} className="w-full p-1.5 border rounded text-sm" />
            </div>
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={handleSubmit} disabled={!specialization || !degree || isPending}>
              {isPending ? t('common.saving') : t('common.save')}
            </Button>
            <Button size="sm" variant="outline" onClick={() => setShowForm(false)}>{t('common.cancel')}</Button>
          </div>
        </div>
      )}
      {qualifications.length === 0 ? (
        <p className="text-sm text-slate-400">{t('committeeDetail.noQualifications')}</p>
      ) : (
        <div className="space-y-2">
          {qualifications.map((q: any) => (
            <div key={q.id} className="text-sm border-b pb-2">
              <div className="flex items-center justify-between">
                <span className="font-medium">{q.specialization}</span>
                <StatusBadge status={q.is_verified ? 'VERIFIED' : 'PENDING'} />
              </div>
              <p className="text-xs text-slate-500">{q.academic_degree}{q.institution_name ? ` - ${q.institution_name}` : ''}{q.experience_years ? ` (${q.experience_years} ${t('committeeDetail.years')})` : ''}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}

function MemberConflictsSection({ conflicts, onAdd, isPending }: { conflicts: any[]; onAdd: (data: any) => void; isPending: boolean }) {
  const { t } = useTranslation()
  const [showForm, setShowForm] = useState(false)
  const [entityType, setEntityType] = useState('')
  const [entityId, setEntityId] = useState('')
  const [conflictType, setConflictType] = useState('')
  const [description, setDescription] = useState('')

  function handleSubmit() {
    if (!entityType || !entityId || !conflictType) return
    onAdd({ entity_type: entityType, entity_id: parseInt(entityId), conflict_type: conflictType, description: description || null })
    setEntityType('')
    setEntityId('')
    setConflictType('')
    setDescription('')
    setShowForm(false)
  }

  return (
    <div>
      <div className="flex items-center justify-between mb-3">
        <p className="text-sm font-medium">{t('committeeDetail.conflictsList')}</p>
        <Button size="sm" variant="outline" onClick={() => setShowForm(!showForm)}>
          <Plus className="w-3.5 h-3.5" /> {t('common.declare')}
        </Button>
      </div>
      {showForm && (
        <div className="bg-slate-50 p-3 rounded mb-3 space-y-2">
          <div className="grid grid-cols-3 gap-2">
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.entityType')}</label>
              <select value={entityType} onChange={e => setEntityType(e.target.value)} className="w-full p-1.5 border rounded text-sm">
                <option value="">{t('common.select')}</option>
                <option value="APPLICATION">{t('committeeDetail.application')}</option>
                <option value="PROJECT">{t('committeeDetail.project')}</option>
              </select>
            </div>
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.entityId')}</label>
              <input type="number" value={entityId} onChange={e => setEntityId(e.target.value)} className="w-full p-1.5 border rounded text-sm" />
            </div>
            <div>
              <label className="text-xs text-slate-500">{t('committeeDetail.conflictType')}</label>
              <select value={conflictType} onChange={e => setConflictType(e.target.value)} className="w-full p-1.5 border rounded text-sm">
                <option value="">{t('common.select')}</option>
                <option value="FINANCIAL">{t('committeeDetail.financial')}</option>
                <option value="PERSONAL">{t('committeeDetail.personal')}</option>
                <option value="ACADEMIC">{t('committeeDetail.academic')}</option>
                <option value="OTHER">{t('committeeDetail.other')}</option>
              </select>
            </div>
          </div>
          <div>
            <label className="text-xs text-slate-500">{t('committeeDetail.description')}</label>
            <textarea value={description} onChange={e => setDescription(e.target.value)} className="w-full p-1.5 border rounded text-sm" rows={2} />
          </div>
          <div className="flex gap-2">
            <Button size="sm" onClick={handleSubmit} disabled={!entityType || !entityId || !conflictType || isPending}>
              {isPending ? t('common.saving') : t('common.save')}
            </Button>
            <Button size="sm" variant="outline" onClick={() => setShowForm(false)}>{t('common.cancel')}</Button>
          </div>
        </div>
      )}
      {conflicts.length === 0 ? (
        <p className="text-sm text-slate-400">{t('committeeDetail.noConflicts')}</p>
      ) : (
        <div className="space-y-2">
          {conflicts.map((c: any) => (
            <div key={c.id} className="text-sm border-b pb-2">
              <div className="flex items-center justify-between">
                <span className="font-medium">{c.conflict_type} - {c.entity_type}#{c.entity_id}</span>
                <StatusBadge status={c.resolved_at ? 'RESOLVED' : 'DECLARED'} />
              </div>
              {c.description && <p className="text-xs text-slate-500">{c.description}</p>}
              <p className="text-xs text-slate-400">{new Date(c.declared_at).toLocaleString()}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
