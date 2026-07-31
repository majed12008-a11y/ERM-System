/*
 * Variable Inspector: Admin-only panel for inspecting template variables.
 * Shows source type, resolver, default, resolved value, and status.
 * Admin mode includes "Test Resolve" and "Validate All" features.
 */
import { useState, useMemo } from 'react'
import { useTranslation } from 'react-i18next'
import { Search, CheckCircle, AlertTriangle, XCircle, FileText, Play, ShieldCheck, ChevronDown, ChevronUp } from 'lucide-react'
import { Input } from './ui/input'
import { Button } from './ui/button'
import { cn } from '../lib/utils'

export interface VariableDefinition {
  name: string
  source_type: string
  resolver_key?: string
  default_value?: string
  required?: boolean
  validation?: any
}

interface VariableInspectorProps {
  content: string
  variableDefinitions: VariableDefinition[]
  resolvedValues?: Record<string, any>
  className?: string
  isAdmin?: boolean
}

export function extractVariablesFromContent(content: string): string[] {
  const regex = /\{\{(\w+)\}\}/g
  const matches = new Set<string>()
  let match
  while ((match = regex.exec(content)) !== null) {
    matches.add(match[1])
  }
  return Array.from(matches)
}

type VariableStatus = 'resolved' | 'using_default' | 'missing' | 'static'

function getStatus(
  varName: string,
  def: VariableDefinition | undefined,
  resolvedValues: Record<string, any>,
): VariableStatus {
  if (def?.source_type === 'static') return 'static'
  if (resolvedValues[varName] !== undefined && resolvedValues[varName] !== '') return 'resolved'
  if (def?.default_value) return 'using_default'
  return 'missing'
}

function StatusBadge({ status, t }: { status: VariableStatus; t: any }) {
  const config: Record<VariableStatus, { icon: any; label: string; className: string }> = {
    resolved: {
      icon: CheckCircle,
      label: t('templates.inspector.resolved'),
      className: 'bg-green-100 text-green-700',
    },
    using_default: {
      icon: AlertTriangle,
      label: t('templates.inspector.usingDefault'),
      className: 'bg-amber-100 text-amber-700',
    },
    missing: {
      icon: XCircle,
      label: t('templates.inspector.missing'),
      className: 'bg-red-100 text-red-600',
    },
    static: {
      icon: FileText,
      label: t('templates.inspector.static'),
      className: 'bg-slate-100 text-slate-500',
    },
  }
  const c = config[status]
  const Icon = c.icon
  return (
    <span className={cn('inline-flex items-center gap-1 text-xs px-2 py-0.5 rounded font-medium', c.className)}>
      <Icon className="w-3 h-3" />
      {c.label}
    </span>
  )
}

export default function TemplateVariableInspector({
  content,
  variableDefinitions,
  resolvedValues = {},
  className,
  isAdmin = false,
}: VariableInspectorProps) {
  const { t } = useTranslation()
  const [testValues, setTestValues] = useState<Record<string, string>>({})
  const [validationResults, setValidationResults] = useState<Record<string, { valid: boolean; message?: string }>>({})
  const [showTestPanel, setShowTestPanel] = useState(false)
  const [expandedRow, setExpandedRow] = useState<string | null>(null)

  const contentVars = useMemo(() => extractVariablesFromContent(content), [content])

  const mergedVariables = useMemo(() => {
    const map = new Map<string, VariableDefinition>()

    for (const def of variableDefinitions) {
      map.set(def.name, def)
    }

    for (const v of contentVars) {
      if (!map.has(v)) {
        map.set(v, {
          name: v,
          source_type: 'entity',
        })
      }
    }

    return Array.from(map.values()).sort((a, b) => a.name.localeCompare(b.name))
  }, [variableDefinitions, contentVars])

  function handleTestValueChange(varName: string, value: string) {
    setTestValues(prev => ({ ...prev, [varName]: value }))
  }

  function handleValidateAll() {
    const results: Record<string, { valid: boolean; message?: string }> = {}
    for (const def of mergedVariables) {
      const value = testValues[def.name] || resolvedValues[def.name] || def.default_value
      if (def.required && (!value || value === '')) {
        results[def.name] = { valid: false, message: 'Required field is empty' }
      } else if (def.validation) {
        try {
          const v = def.validation
          if (v.minLength && value && value.length < v.minLength) {
            results[def.name] = { valid: false, message: `Min length: ${v.minLength}` }
          } else if (v.maxLength && value && value.length > v.maxLength) {
            results[def.name] = { valid: false, message: `Max length: ${v.maxLength}` }
          } else if (v.pattern && value && !new RegExp(v.pattern).test(value)) {
            results[def.name] = { valid: false, message: 'Pattern mismatch' }
          } else {
            results[def.name] = { valid: true }
          }
        } catch {
          results[def.name] = { valid: true }
        }
      } else {
        results[def.name] = { valid: true }
      }
    }
    setValidationResults(results)
  }

  const testOutput = useMemo(() => {
    if (!isAdmin || !showTestPanel) return null
    let output = content
    for (const def of mergedVariables) {
      const value = testValues[def.name] || resolvedValues[def.name] || def.default_value || `[${def.name}]`
      output = output.replace(new RegExp(`\\{\\{${def.name}\\}\\}`, 'g'), String(value))
    }
    return output
  }, [isAdmin, showTestPanel, content, mergedVariables, testValues, resolvedValues])

  const resolvedCount = mergedVariables.filter(v => getStatus(v.name, v, resolvedValues) === 'resolved').length
  const missingCount = mergedVariables.filter(v => getStatus(v.name, v, resolvedValues) === 'missing').length

  return (
    <div className={cn('space-y-4', className)}>
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <Search className="w-4 h-4 text-slate-500" />
          <h3 className="text-sm font-semibold">{t('templates.inspector.title')}</h3>
          <span className="text-xs text-slate-400">
            ({resolvedCount}/{mergedVariables.length} {t('templates.inspector.resolved').toLowerCase()})
          </span>
          {missingCount > 0 && (
            <span className="text-xs text-red-500 font-medium">
              {missingCount} {t('templates.inspector.missing').toLowerCase()}
            </span>
          )}
        </div>
        {isAdmin && (
          <div className="flex items-center gap-2">
            <Button
              size="sm"
              variant={showTestPanel ? 'default' : 'outline'}
              onClick={() => setShowTestPanel(!showTestPanel)}
            >
              <Play className="w-3 h-3 mr-1" />
              {t('templates.inspector.testResolve')}
            </Button>
            <Button size="sm" variant="outline" onClick={handleValidateAll}>
              <ShieldCheck className="w-3 h-3 mr-1" />
              {t('templates.inspector.validateAll')}
            </Button>
          </div>
        )}
      </div>

      {mergedVariables.length === 0 ? (
        <div className="text-center py-8 text-slate-400 text-sm">
          {t('templates.inspector.noDefinitions')}
        </div>
      ) : (
        <div className="border rounded-lg overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="bg-slate-50 border-b text-left">
                <th className="py-2 px-3 font-medium text-slate-600">{t('templates.inspector.variable')}</th>
                <th className="py-2 px-3 font-medium text-slate-600">{t('templates.inspector.sourceType')}</th>
                <th className="py-2 px-3 font-medium text-slate-600 hidden md:table-cell">{t('templates.inspector.resolver')}</th>
                <th className="py-2 px-3 font-medium text-slate-600 hidden md:table-cell">{t('templates.inspector.defaultValue')}</th>
                <th className="py-2 px-3 font-medium text-slate-600">{t('templates.inspector.resolvedValue')}</th>
                <th className="py-2 px-3 font-medium text-slate-600">{t('templates.inspector.status')}</th>
                {isAdmin && showTestPanel && (
                  <th className="py-2 px-3 font-medium text-slate-600">Test Input</th>
                )}
              </tr>
            </thead>
            <tbody>
              {mergedVariables.map((def) => {
                const status = getStatus(def.name, def, resolvedValues)
                const resolvedVal = resolvedValues[def.name]
                const vr = validationResults[def.name]
                const isExpanded = expandedRow === def.name

                return (
                  <tr key={def.name} className="border-b last:border-0 hover:bg-slate-50/50">
                    <td className="py-2 px-3">
                      <div className="flex items-center gap-1">
                        <button
                          onClick={() => setExpandedRow(isExpanded ? null : def.name)}
                          className="text-slate-400 hover:text-slate-600 md:hidden"
                        >
                          {isExpanded ? <ChevronUp className="w-3 h-3" /> : <ChevronDown className="w-3 h-3" />}
                        </button>
                        <span className="font-mono text-xs font-medium text-slate-800">
                          {'{{' + def.name + '}}'}
                        </span>
                        {def.required && <span className="text-red-500 text-xs">*</span>}
                      </div>
                    </td>
                    <td className="py-2 px-3">
                      <span className="text-xs text-slate-500">{def.source_type}</span>
                    </td>
                    <td className="py-2 px-3 hidden md:table-cell">
                      <span className="text-xs text-slate-500 font-mono">
                        {def.resolver_key || '—'}
                      </span>
                    </td>
                    <td className="py-2 px-3 hidden md:table-cell">
                      <span className="text-xs text-slate-500 truncate max-w-[120px] inline-block">
                        {def.default_value || '—'}
                      </span>
                    </td>
                    <td className="py-2 px-3">
                      <span className="text-xs text-slate-700 truncate max-w-[120px] inline-block font-mono">
                        {resolvedVal !== undefined ? String(resolvedVal) : '—'}
                      </span>
                    </td>
                    <td className="py-2 px-3">
                      <StatusBadge status={status} t={t} />
                      {vr && (
                        <span className={cn('ml-2 text-xs', vr.valid ? 'text-green-600' : 'text-red-600')}>
                          {vr.valid ? '✓' : `✗ ${vr.message}`}
                        </span>
                      )}
                    </td>
                    {isAdmin && showTestPanel && (
                      <td className="py-2 px-3">
                        <Input
                          value={testValues[def.name] || ''}
                          onChange={(e) => handleTestValueChange(def.name, e.target.value)}
                          placeholder={def.default_value || def.name}
                          className="text-xs h-7 w-32"
                        />
                      </td>
                    )}
                  </tr>
                )
              })}
            </tbody>
          </table>
        </div>
      )}

      {isAdmin && showTestPanel && testOutput && (
        <div className="border rounded-lg overflow-hidden">
          <div className="bg-slate-900 text-green-400 p-4 text-sm font-mono whitespace-pre-wrap max-h-64 overflow-y-auto">
            {testOutput}
          </div>
        </div>
      )}
    </div>
  )
}
