import { createContext, useContext, useState, useEffect, type ReactNode } from 'react'
import api, { setAccessToken, getAccessToken } from '../api/client'

interface User {
  id: number
  uuid: string
  username: string
  email: string
  institution_id: number
  roles: string[]
  permissions: string[]
}

interface AuthContextType {
  user: User | null
  login: (username: string, password: string) => Promise<void>
  logout: () => Promise<void>
  isAuthenticated: boolean
}

const AuthContext = createContext<AuthContextType | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(() => {
    const stored = sessionStorage.getItem('user')
    return stored ? JSON.parse(stored) : null
  })

  useEffect(() => {
    if (window.location.pathname.includes('/login') || window.location.pathname.includes('/register')) return
    const token = getAccessToken()
    if (!token) {
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
      })
    }
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
  }

  return (
    <AuthContext.Provider value={{ user, login, logout, isAuthenticated: !!getAccessToken() }}>
      {children}
    </AuthContext.Provider>
  )
}

export function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
