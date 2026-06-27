/*
 * SDK الأمان: دوال المصادقة وإدارة المستخدمين والأدوار.
 * التعامل مع تسجيل الدخول، التسجيل، إدارة الملف الشخصي، الصلاحيات.
 */
import api from '../../api/client'
import type {
  LoginRequest,
  LoginResponse,
  RegisterRequest,
  AuthUser,
  ChangePasswordRequest,
  SuccessResponse,
  User,
  UserProfile,
  Role,
  Permission,
  ResponsibilityType,
  UserResponsibility,
  Pagination,
} from '../core/types'

export const auth = {
  login(data: LoginRequest) {
    return api.post<SuccessResponse<LoginResponse>>('/security/auth/login', data)
  },

  register(data: RegisterRequest) {
    return api.post<SuccessResponse<unknown>>('/security/auth/register', data)
  },

  refresh() {
    return api.post<SuccessResponse<{ accessToken: string }>>('/security/auth/refresh')
  },

  logout() {
    return api.post<SuccessResponse<null>>('/security/auth/logout')
  },

  me() {
    return api.get<SuccessResponse<AuthUser>>('/security/auth/me')
  },

  changePassword(data: ChangePasswordRequest) {
    return api.post<SuccessResponse<null>>('/security/auth/change-password', data)
  },
}

export const users = {
  list(params?: { page?: number; limit?: number }) {
    return api.get<SuccessResponse<User[]> & { pagination?: Pagination }>('/security/users', { params })
  },

  getById(id: number) {
    return api.get<SuccessResponse<User>>(`/security/users/${id}`)
  },

  create(data: { username: string; email: string; password: string; role_codes?: string[] }) {
    return api.post<SuccessResponse<User>>('/security/users', data)
  },

  update(id: number, data: Partial<User>) {
    return api.put<SuccessResponse<User>>(`/security/users/${id}`, data)
  },

  getProfile() {
    return api.get<SuccessResponse<UserProfile>>('/security/profile')
  },

  updateProfile(data: Partial<UserProfile>) {
    return api.put<SuccessResponse<UserProfile>>('/security/profile', data)
  },

  getProfileById(userId: number) {
    return api.get<SuccessResponse<UserProfile>>(`/security/profile/${userId}`)
  },
}

export const roles = {
  list() {
    return api.get<SuccessResponse<Role[]>>('/security/roles')
  },

  getById(id: number) {
    return api.get<SuccessResponse<Role>>(`/security/roles/${id}`)
  },

  create(data: { code: string; name_ar: string }) {
    return api.post<SuccessResponse<Role>>('/security/roles', data)
  },

  update(id: number, data: Partial<Role>) {
    return api.put<SuccessResponse<Role>>(`/security/roles/${id}`, data)
  },
}

export const permissions = {
  list() {
    return api.get<SuccessResponse<Permission[]>>('/security/permissions')
  },

  create(data: { permission_code: string; name: string }) {
    return api.post<SuccessResponse<Permission>>('/security/permissions', data)
  },

  delete(id: number) {
    return api.delete<SuccessResponse<null>>(`/security/permissions/${id}`)
  },

  getByRole(roleId: number) {
    return api.get<SuccessResponse<Permission[]>>(`/security/permissions/role/${roleId}`)
  },

  updateRole(roleId: number, data: { permission_ids: number[] }) {
    return api.put<SuccessResponse<null>>(`/security/permissions/role/${roleId}`, data)
  },
}

export const responsibilities = {
  listTypes() {
    return api.get<SuccessResponse<ResponsibilityType[]>>('/security/responsibility-types')
  },

  list() {
    return api.get<SuccessResponse<UserResponsibility[]>>('/security/user-responsibilities')
  },

  assign(data: { user_id: number; responsibility_type_id: number; entity_type: string; entity_id: number }) {
    return api.post<SuccessResponse<UserResponsibility>>('/security/user-responsibilities', data)
  },

  remove(id: number) {
    return api.delete<SuccessResponse<null>>(`/security/user-responsibilities/${id}`)
  },
}
