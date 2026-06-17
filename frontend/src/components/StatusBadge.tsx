import { useTranslation } from 'react-i18next'
import { Badge } from './ui/badge'

const statusVariants: Record<string, 'default' | 'secondary' | 'destructive' | 'success' | 'warning' | 'outline'> = {
  DRAFT: 'secondary',
  SUBMITTED: 'warning',
  UNDER_REVIEW: 'warning',
  APPROVED: 'success',
  REJECTED: 'destructive',
  CONDITIONAL: 'default',
  WITHDRAWN: 'outline',
  CLOSED: 'secondary',
}

export function StatusBadge({ status }: { status: string }) {
  const { t } = useTranslation()

  return (
    <Badge variant={statusVariants[status] || 'outline'}>
      {status ? t(`status.${status}`, { defaultValue: status.replace(/_/g, ' ') }) : t('common.noData')}
    </Badge>
  )
}
