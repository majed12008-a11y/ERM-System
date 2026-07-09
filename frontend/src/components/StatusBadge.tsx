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
  PENDING: 'secondary',
  ACCEPTED: 'success',
  RECOMMEND_APPROVE: 'success',
  RECOMMEND_CONDITIONAL: 'default',
  RECOMMEND_REJECT: 'destructive',
  DEFER: 'warning',
  ACCREDITED: 'success',
  SUSPENDED: 'destructive',
  EXPIRED: 'outline',
  REVOKED: 'destructive',
  OPEN: 'secondary',
  MET: 'success',
  NOT_MET: 'destructive',
  OVERDUE: 'destructive',
  WAIVED: 'outline',
}

export function StatusBadge({ status, colorMap }: { status: string, colorMap?: Record<string, string> }) {
  const { t } = useTranslation()
  const customClass = colorMap?.[status]
  const variant = customClass ? 'outline' : (statusVariants[status] || 'outline')

  return (
    <Badge variant={variant} className={customClass}>
      {status ? t(`status.${status}`, { defaultValue: status.replace(/_/g, ' ') }) : t('common.noData')}
    </Badge>
  )
}
