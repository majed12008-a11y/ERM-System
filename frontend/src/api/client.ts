import axios from 'axios'
import { toast } from 'sonner'

const api = axios.create({
  baseURL: '/api/v1',
  headers: { 'Content-Type': 'application/json' },
  withCredentials: true,
})

let accessToken: string | null = sessionStorage.getItem('accessToken')
let refreshPromise: Promise<string | null> | null = null

export function setAccessToken(token: string | null) {
  accessToken = token
  if (token) {
    sessionStorage.setItem('accessToken', token)
  } else {
    sessionStorage.removeItem('accessToken')
  }
}

export function getAccessToken() {
  return accessToken
}

async function doRefresh(): Promise<string | null> {
  try {
    const res = await axios.post('/api/v1/security/auth/refresh', {}, { withCredentials: true })
    const newToken: string = res.data.data?.accessToken
    if (newToken) {
      accessToken = newToken
      return newToken
    }
  } catch {
    accessToken = null
  }
  return null
}

api.interceptors.request.use((config) => {
  if (accessToken) {
    config.headers.Authorization = `Bearer ${accessToken}`
  }
  return config
})

api.interceptors.response.use(
  (res) => res,
  async (err) => {
    const original = err.config
    if (original?.url?.includes('/auth/refresh')) {
      return Promise.reject(err)
    }
    if (err.response?.status === 401 && !original._retry) {
      original._retry = true
      if (!refreshPromise) {
        refreshPromise = doRefresh()
      }
      const newToken = await refreshPromise
      refreshPromise = null
      if (newToken) {
        original.headers.Authorization = `Bearer ${newToken}`
        return api(original)
      }
      accessToken = null
      if (!window.location.pathname.includes('/login') && !window.location.pathname.includes('/register')) {
        window.location.href = '/login'
      }
    }
    if (err.response?.status === 403) {
      toast.error('You do not have permission to perform this action')
    }
    return Promise.reject(err)
  }
)

export default api
