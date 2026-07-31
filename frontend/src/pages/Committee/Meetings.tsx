/*
 * صفحة الاجتماعات: عرض وجدولة وإدارة اجتماعات اللجان.
 */
import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import { meetings } from '../../sdk/domains/committee.sdk'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { CalendarDays } from 'lucide-react'

export default function CommitteeMeetings() {
  const { t } = useTranslation()
  const navigate = useNavigate()

  const { data, isLoading } = useQuery({
    queryKey: ['committee-meetings-all'],
    queryFn: () => meetings.listAll().then((r) => r.data.data),
  })

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <CalendarDays className="w-6 h-6 text-blue-600" />
        <h1 className="text-2xl font-bold">{t('meetings.title')}</h1>
      </div>

      <DataTable
        loading={isLoading}
        columns={[
          { key: 'meeting_number', label: t('meetings.number'), sortable: true, render: (r) => <a href="#" onClick={(e) => { e.preventDefault(); navigate(`/committee/meetings/${r.id}`) }} className="text-blue-600 hover:underline">{r.meeting_number}</a> },
          { key: 'committee_name', label: t('committees.nameAr'), sortable: true },
          { key: 'meeting_date', label: t('meetings.date'), sortable: true, render: (i) => new Date(i.meeting_date).toLocaleDateString() },
          { key: 'location', label: t('meetings.location'), sortable: true },
          { key: 'meeting_status', label: t('meetings.status'), sortable: true, render: (i) => <StatusBadge status={i.meeting_status} /> },
        ]}
        data={data || []}
        emptyMessage={t('meetings.noMeetings')}
      />
    </div>
  )
}
