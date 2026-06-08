import { useEffect, useRef } from 'react'
import { useQueryClient } from '@tanstack/react-query'
import { getAccessToken } from '../api/client'

export function useNotificationStream() {
  const queryClient = useQueryClient()
  const esRef = useRef<EventSource | null>(null)

  useEffect(() => {
    const token = getAccessToken()
    if (!token) return

    const url = `${window.location.origin}/api/v1/communication/notifications/stream?token=${encodeURIComponent(token)}`
    const es = new EventSource(url)
    esRef.current = es

    es.addEventListener('connected', () => {
      console.debug('[SSE] connected')
    })

    es.addEventListener('notification', () => {
      queryClient.invalidateQueries({ queryKey: ['notifications'] })
      queryClient.invalidateQueries({ queryKey: ['notifications-count'] })
    })

    es.addEventListener('ping', () => { /* keep-alive */ })

    es.onerror = () => {
      es.close()
      esRef.current = null
    }

    return () => {
      es.close()
      esRef.current = null
    }
  }, [queryClient])
}
