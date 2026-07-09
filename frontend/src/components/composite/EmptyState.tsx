import type { LucideIcon } from 'lucide-react'
import { Inbox, AlertTriangle, SearchX } from 'lucide-react'
import { Button } from '../ui/button'

interface EmptyStateProps {
  icon?: LucideIcon
  title: string
  description?: string
  action?: {
    label: string
    onClick: () => void
  }
  variant?: 'empty' | 'error' | 'search'
}

const variantIcons: Record<string, LucideIcon> = {
  empty: Inbox,
  error: AlertTriangle,
  search: SearchX,
}

export function EmptyState({ icon, title, description, action, variant = 'empty' }: EmptyStateProps) {
  const Icon = icon ?? variantIcons[variant]

  return (
    <div className="flex flex-col items-center justify-center py-12 text-center px-4">
      <Icon className="w-12 h-12 text-muted-foreground/30 mb-4" />
      <h3 className="text-base font-semibold text-foreground mb-1">{title}</h3>
      {description && (
        <p className="text-sm text-muted-foreground max-w-xs">{description}</p>
      )}
      {action && (
        <Button variant="default" size="sm" className="mt-4" onClick={action.onClick}>
          {action.label}
        </Button>
      )}
    </div>
  )
}
