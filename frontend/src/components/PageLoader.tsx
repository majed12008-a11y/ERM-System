import { Loader2 } from 'lucide-react'
import { useTranslation } from 'react-i18next'

export default function PageLoader() {
  const { t } = useTranslation()

  return (
    <div className="flex items-center justify-center min-h-[400px]">
      <div className="flex flex-col items-center gap-3 text-slate-400">
        <Loader2 className="w-8 h-8 animate-spin" />
        <p className="text-sm">{t('common.loading')}</p>
      </div>
    </div>
  )
}
