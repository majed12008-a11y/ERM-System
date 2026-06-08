interface Props {
  count?: number
  height?: string
  className?: string
}

export function LoadingSkeleton({ count = 3, height = 'h-4', className = '' }: Props) {
  return (
    <div className={`space-y-3 ${className}`}>
      {Array.from({ length: count }).map((_, i) => (
        <div key={i} className={`${height} bg-slate-200 rounded animate-pulse w-full`} />
      ))}
    </div>
  )
}

export function CardSkeleton() {
  return (
    <div className="bg-white rounded-lg shadow p-6 space-y-4">
      <div className="h-5 bg-slate-200 rounded animate-pulse w-1/3" />
      <div className="space-y-3">
        <LoadingSkeleton count={4} height="h-3" />
      </div>
    </div>
  )
}

export function PageSkeleton() {
  return (
    <div className="space-y-6">
      <div className="h-8 bg-slate-200 rounded animate-pulse w-1/4" />
      <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
        {Array.from({ length: 3 }).map((_, i) => <CardSkeleton key={i} />)}
      </div>
    </div>
  )
}
