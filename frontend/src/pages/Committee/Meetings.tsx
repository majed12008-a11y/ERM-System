/*
 * صفحة الاجتماعات: عرض وجدولة وإدارة اجتماعات اللجان.
 */
import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { CalendarDays } from 'lucide-react'

export default function CommitteeMeetings() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const { data: committees } = useQuery({
    queryKey: ['committees'],
    queryFn: () => api.get('/committee/committees').then((r) => r.data.data),
  })

  const { data: meetings, isLoading } = useQuery({
    queryKey: ['committee-meetings'],
    queryFn: async () => {
      if (!committees || committees.length === 0) return []
      const results = await Promise.all(
        committees.map((c: any) =>
          api.get(`/committee/meetings/committee/${c.id}`).then((r) => r.data.data || [])
        )
      )
      return results.flat()
    },
    enabled: !!committees && committees.length > 0,
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
            { key: 'meeting_date', label: t('meetings.date'), sortable: true, render: (i) => new Date(i.meeting_date).toLocaleDateString() },
            { key: 'location', label: t('meetings.location'), sortable: true },
            { key: 'meeting_status', label: t('meetings.status'), sortable: true },
          ]}
          data={meetings || []}
          emptyMessage={t('meetings.noMeetings')}
        />
    </div>
  )
}
