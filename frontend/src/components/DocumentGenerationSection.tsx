import { useState } from 'react'
import { useTranslation } from 'react-i18next'
import { toast } from 'sonner'
import { templates } from '../sdk/domains/templates.sdk'
import { FileDown, Eye, FileText, Loader2 } from 'lucide-react'

export interface DocumentAction {
  key: string
  labelKey: string
  templateCode: string
  getVariables: () => Record<string, unknown>
}

interface DocumentGenerationSectionProps {
  actions: DocumentAction[]
}

export default function DocumentGenerationSection({ actions }: DocumentGenerationSectionProps) {
  const { t } = useTranslation()
  const [previewHtml, setPreviewHtml] = useState<string | null>(null)
  const [previewTitle, setPreviewTitle] = useState('')
  const [loadingKey, setLoadingKey] = useState<string | null>(null)

  async function handlePreview(action: DocumentAction) {
    setLoadingKey(`preview-${action.key}`)
    try {
      const res = await templates.preview({
        templateCode: action.templateCode,
        version: '1.0.0',
        variables: action.getVariables(),
      })
      setPreviewHtml(res.data.data.html)
      setPreviewTitle(t(action.labelKey))
    } catch {
      toast.error(t('common.generationFailed'))
    } finally {
      setLoadingKey(null)
    }
  }

  async function handleGenerate(action: DocumentAction) {
    setLoadingKey(`generate-${action.key}`)
    try {
      const res = await templates.render({
        templateCode: action.templateCode,
        version: '1.0.0',
        variables: action.getVariables(),
      })
      toast.success(t('common.documentGenerated') + (res.data.data.snapshotHash ? ` (${res.data.data.snapshotHash.slice(0, 8)})` : ''))
    } catch {
      toast.error(t('common.generationFailed'))
    } finally {
      setLoadingKey(null)
    }
  }

  return (
    <>
      <div className="border rounded-lg p-4 mt-4">
        <h3 className="font-semibold mb-3 flex items-center gap-2 text-sm">
          <FileText className="w-4 h-4" /> {t('common.generateDocument')}
        </h3>
        <div className="flex flex-wrap gap-2">
          {actions.map(action => (
            <div key={action.key} className="flex gap-1">
              <button
                onClick={() => handlePreview(action)}
                disabled={loadingKey !== null}
                className="inline-flex items-center gap-1 px-3 py-1.5 text-sm border rounded hover:bg-muted disabled:opacity-50"
              >
                {loadingKey === `preview-${action.key}` ? (
                  <Loader2 className="w-3 h-3 animate-spin" />
                ) : (
                  <Eye className="w-3 h-3" />
                )}
                {t('common.preview')}
              </button>
              <button
                onClick={() => handleGenerate(action)}
                disabled={loadingKey !== null}
                className="inline-flex items-center gap-1 px-3 py-1.5 text-sm bg-primary text-primary-foreground rounded hover:bg-primary/90 disabled:opacity-50"
              >
                {loadingKey === `generate-${action.key}` ? (
                  <Loader2 className="w-3 h-3 animate-spin" />
                ) : (
                  <FileDown className="w-3 h-3" />
                )}
                {t('common.generate')}
              </button>
            </div>
          ))}
        </div>
      </div>

      {previewHtml && (
        <div className="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4">
          <div className="bg-white rounded-lg max-w-4xl max-h-[90vh] overflow-auto w-full">
            <div className="flex justify-between items-center p-4 border-b">
              <h3 className="font-semibold">{previewTitle}</h3>
              <button onClick={() => setPreviewHtml(null)} className="text-xl leading-none hover:text-slate-600">&times;</button>
            </div>
            <div className="p-4" dangerouslySetInnerHTML={{ __html: previewHtml }} />
          </div>
        </div>
      )}
    </>
  )
}
