/*
 * صفحة مراجعاتي: عرض الطلبات الموكلة للمستخدم
 * لمراجعتها ضمن مهام اللجنة.
 */
import { useQuery } from '@tanstack/react-query'
import { useNavigate } from 'react-router-dom'
import { useTranslation } from 'react-i18next'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { StatusBadge } from '../../components/StatusBadge'
import { ClipboardCheck } from 'lucide-react'

export default function MyReviews() {
  const { t } = useTranslation()
  const navigate = useNavigate()
  const { data, isLoading } = useQuery({
    queryKey: ['my-reviews'],
    queryFn: () => api.get('/committee/reviews/my').then((r) => r.data.data),
  })

  return (
    <div>
      <div className="flex items-center gap-3 mb-6">
        <ClipboardCheck className="w-6 h-6 text-blue-600" />
        <h1 className="text-2xl font-bold">{t('reviews.title')}</h1>
      </div>

        <DataTable
          loading={isLoading}
          onRowClick={(r) => navigate(`/applications/${r.application_id}`)}
          columns={[
            { key: 'application_number', label: t('reviews.application'), sortable: true },
            { key: 'project_title', label: t('reviews.project'), sortable: true },
            { key: 'review_type', label: t('reviews.reviewType'), sortable: true },
            { key: 'status_code', label: t('reviews.status'), sortable: true, render: (i) => <StatusBadge status={i.status_code} /> },
            { key: 'assigned_at', label: t('reviews.assigned'), sortable: true, render: (i) => new Date(i.assigned_at).toLocaleDateString() },
            { key: 'due_date', label: t('reviews.dueDate'), sortable: true, render: (i) => i.due_date ? new Date(i.due_date).toLocaleDateString() : '\u2014' },
          ]}
          data={data || []}
          emptyMessage={t('reviews.empty')}
        />
    </div>
  )
}
