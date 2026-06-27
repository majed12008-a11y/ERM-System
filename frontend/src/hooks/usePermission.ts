/*
 * Hook للتحقق من صلاحية المستخدم.
 * تعيد true إذا كان المستخدم يملك الصلاحية المحددة.
 */
import { useAuth } from '../context/AuthContext'

export function usePermission(permissionCode: string): boolean {
  const { user } = useAuth()
  return user?.permissions?.includes(permissionCode) ?? false
}

export function useRole(...roles: string[]): boolean {
  const { user } = useAuth()
  if (!user?.roles) return false
  return roles.some(r => user.roles.includes(r))
}
