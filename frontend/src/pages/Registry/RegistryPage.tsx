import { useQuery } from '@tanstack/react-query'
import { useState } from 'react'
import api from '../../api/client'
import DataTable from '../../components/DataTable'
import { Card, CardContent } from '../../components/ui/card'
import { Button } from '../../components/ui/button'
import { StatusBadge } from '../../components/StatusBadge'
import { useTranslation } from 'react-i18next'

const tabs = ['institutions', 'professions', 'licenses'] as const

export default function RegistryPage() {
  const { t } = useTranslation()
  const [tab, setTab] = useState<'institutions' | 'professions' | 'licenses'>('institutions')

  const { data: institutions } = useQuery({
    queryKey: ['institutions-registry'],
    queryFn: () => api.get('/reference/institutions-registry').then(r => r.data.data),
    enabled: tab === 'institutions',
  })

  const { data: professions } = useQuery({
    queryKey: ['professions'],
    queryFn: () => api.get('/reference/professions').then(r => r.data.data),
    enabled: tab === 'professions',
  })

  const { data: licenses } = useQuery({
    queryKey: ['licenses'],
    queryFn: () => api.get('/reference/licenses').then(r => r.data.data),
    enabled: tab === 'licenses',
  })

  return (
    <div>
      <h1 className="text-2xl font-bold mb-6">{t('registry.title')}</h1>

      <div className="flex gap-2 mb-4">
        {tabs.map(tabName => (
          <Button key={tabName} variant={tab === tabName ? 'default' : 'outline'} onClick={() => setTab(tabName)}>
            {{ institutions: t('registry.institutions'), professions: t('registry.professions'), licenses: t('registry.licenses') }[tabName]}
          </Button>
        ))}
      </div>

      <Card>
        <CardContent className="p-0">
          {tab === 'institutions' && (
            <DataTable
              columns={[
                { key: 'national_id', label: t('registry.nationalId') },
                { key: 'name_ar', label: t('registry.nameAr') },
                { key: 'name_en', label: t('registry.nameEn') },
                { key: 'type', label: t('registry.type') },
                { key: 'city', label: t('registry.city') },
                { key: 'is_accredited', label: t('registry.accredited'), render: (i: any) => i.is_accredited ? <StatusBadge status="APPROVED" /> : <StatusBadge status="DRAFT" /> },
              ]}
              data={institutions || []}
            />
          )}
          {tab === 'professions' && (
            <DataTable
              columns={[
                { key: 'code', label: t('registry.code') },
                { key: 'name_ar', label: t('registry.nameAr') },
                { key: 'name_en', label: t('registry.nameEn') },
                { key: 'category', label: t('registry.category') },
              ]}
              data={professions || []}
            />
          )}
          {tab === 'licenses' && (
            <DataTable
              columns={[
                { key: 'profession_name', label: t('registry.profession') },
                { key: 'user_name', label: t('registry.user') },
                { key: 'verification_status', label: t('registry.verification'), render: (l: any) => <StatusBadge status={l.verification_status} /> },
              ]}
              data={licenses || []}
            />
          )}
        </CardContent>
      </Card>
    </div>
  )
}
