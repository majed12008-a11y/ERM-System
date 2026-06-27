/*
 * تعريفات الأنواع المشتركة (TypeScript interfaces)
 * المستخدمة عبر النظام بأكمله (المستخدم، AuthUser، المستندات).
 */
export interface User {
  id: number;
  uuid: string;
  institution_id: number;
  username: string;
  email: string;
  status: string;
}

export interface AuthUser {
  id: number;
  uuid: string;
  institution_id: number;
  username: string;
  email: string;
  status: string;
  is_email_verified: boolean;
  roles: string[];
}

export interface AuthenticatedRequest {
  user: User & { roles: string[] };
}

export interface ApiResponse<T = any> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
  pagination?: {
    page: number;
    limit: number;
    total: number;
  };
}

export interface ApplicationStatus {
  status_code: string;
  status_name_ar: string;
  is_terminal: boolean;
}

export interface WorkflowTransition {
  id: number;
  transition_code: string;
  transition_name: string;
  from_state: string;
  to_state: string;
}
