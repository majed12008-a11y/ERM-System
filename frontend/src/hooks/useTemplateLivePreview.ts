/*
 * Hook for real-time template preview: debounced content, auto-validate, auto-render.
 * Uses preview endpoint which validates and renders in one call.
 */
import { useState, useEffect, useCallback, useRef } from 'react'
import { templates } from '../sdk/domains/templates.sdk'

interface ErrorWithResponse {
  response?: { data?: { error?: string } }
  message?: string
}

export function useTemplateLivePreview(
  templateCode: string,
  version: string,
  locale: string = 'ar',
) {
  const [content, setContent] = useState('')
  const [variables, setVariables] = useState<Record<string, string>>({})
  const [renderedHtml, setRenderedHtml] = useState('')
  const [errors, setErrors] = useState<string[]>([])
  const [validationStatus, setValidationStatus] = useState<'idle' | 'valid' | 'invalid'>('idle')
  const debounceTimer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined)
  const abortRef = useRef(0)
  const contentRef = useRef(content)
  const variablesRef = useRef(variables)

  useEffect(() => {
    contentRef.current = content
  }, [content])

  useEffect(() => {
    variablesRef.current = variables
  }, [variables])

  const detectVariables = useCallback((text: string): string[] => {
    const matches = text.match(/\{\{(\w+)\}\}/g) || []
    return [...new Set(matches.map(m => m.replace(/\{\{|\}\}/g, '')))]
  }, [])

  const detectedVariables = detectVariables(content)

  const runPreview = useCallback((vars: Record<string, string>) => {
    const currentContent = contentRef.current
    if (!currentContent || !templateCode || !version) {
      setValidationStatus('idle')
      setRenderedHtml('')
      setErrors([])
      return
    }
    const requestId = ++abortRef.current
    setValidationStatus('idle')
    setErrors([])
    templates.preview({
      templateCode,
      version,
      variables: vars,
      locale,
    }).then((res) => {
      if (requestId === abortRef.current) {
        setRenderedHtml(res.data.data.html)
        setErrors([])
        setValidationStatus('valid')
      }
    }).catch((err: ErrorWithResponse) => {
      if (requestId === abortRef.current) {
        const msg = err?.response?.data?.error || err?.message || 'Preview failed'
        setErrors([msg])
        setRenderedHtml('')
        setValidationStatus('invalid')
      }
    })
  }, [templateCode, version, locale])

  // Debounce content changes
  useEffect(() => {
    if (debounceTimer.current) clearTimeout(debounceTimer.current)
    debounceTimer.current = setTimeout(() => {
      runPreview(variablesRef.current)
    }, 500)
    return () => {
      if (debounceTimer.current) clearTimeout(debounceTimer.current)
    }
  }, [content, runPreview])

  // Preview on variable changes (immediate, no debounce)
  useEffect(() => {
    if (contentRef.current && templateCode && version) {
      runPreview(variables)
    }
  }, [variables, runPreview, templateCode, version])

  const setVariable = useCallback((key: string, value: string) => {
    setVariables(prev => ({ ...prev, [key]: value }))
  }, [])

  const resetPreview = useCallback(() => {
    setContent('')
    setRenderedHtml('')
    setErrors([])
    setValidationStatus('idle')
    setVariables({})
  }, [])

  return {
    content,
    setContent,
    variables,
    setVariables,
    setVariable,
    detectedVariables,
    renderedHtml,
    isValidating: false,
    errors,
    validationStatus,
    resetPreview,
  }
}
