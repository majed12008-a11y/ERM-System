/*
 * سياق المصادقة: إدارة حالة تسجيل الدخول على مستوى التطبيق.
 * يوفر بيانات المستخدم الحالي، دوال تسجيل الدخول/الخروج،
 * والتحقق من صلاحية التوكن.
 */
import { createContext, useContext, useState, useEffect, type ReactNode } from 'react'
import api, { setAccessToken, getAccessToken } from '../api/client'

interface User {
  id: number
  uuid: string
  username: string
  email: string
  institution_id: number
  is_email_verified: boolean
  roles: string[]
  permissions: string[]
}

interface AuthContextType {
  user: User | null
  login: (username: string, password: string) => Promise<void>
  logout: () => Promise<void>
  isAuthenticated: boolean
  isInitializing: boolean
}

const AuthContext = createContext<AuthContextType | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const token = getAccessToken()
  const [user, setUser] = useState<User | null>(() => {
    const stored = sessionStorage.getItem('user')
    return stored && token ? JSON.parse(stored) : null
  })
  const [isInitializing, setIsInitializing] = useState(true)

  useEffect(() => {
    if (getAccessToken()) {
      setIsInitializing(false)
      return
    }
    api.post('/security/auth/refresh').then((res) => {
      const newToken = res.data.data?.accessToken
      if (newToken) {
        setAccessToken(newToken)
        return api.get('/security/auth/me')
      }
      throw new Error('No token')
    }).then((res) => {
      setUser(res.data.data)
      sessionStorage.setItem('user', JSON.stringify(res.data.data))
    }).catch(() => {
      setUser(null)
      sessionStorage.removeItem('user')
      sessionStorage.removeItem('accessToken')
    }).finally(() => {
      setIsInitializing(false)
    })
  }, [])

  async function login(username: string, password: string) {
    const res = await api.post('/security/auth/login', { username, password })
    const { accessToken: newToken } = res.data.data
    setAccessToken(newToken)
    const meRes = await api.get('/security/auth/me')
    setUser(meRes.data.data)
    sessionStorage.setItem('user', JSON.stringify(meRes.data.data))
  }

  async function logout() {
    try {
      await api.post('/security/auth/logout')
    } catch { /* ignore */ }
    setAccessToken(null)
    setUser(null)
    sessionStorage.removeItem('user')
    sessionStorage.removeItem('accessToken')
  }

  return (
    <AuthContext.Provider value={{ user, login, logout, isAuthenticated: !!getAccessToken(), isInitializing }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
