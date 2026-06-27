// ─── Base Response Contract ───
// تعريفات الأنواع الأساسية لاستجابات API.
export interface SuccessResponse<T = unknown> {
  success: true
  data: T
  message?: string | null
}

export interface ErrorResponse {
  success: false
  error: string
}

export type ApiResponse<T = unknown> = SuccessResponse<T> | ErrorResponse

// ─── Pagination ───
export interface Pagination {
  page: number
  limit: number
  total: number
  totalPages: number
}

export interface PaginatedResponse<T> {
  success: true
  data: T[]
  pagination: Pagination
}

export interface PaginationParams {
  page?: number
  limit?: number
  pageSize?: number
}

// ─── Auth ───
export interface LoginRequest {
  username: string
  password: string
}

export interface LoginResponse {
  accessToken: string
  userId: number
}

export interface RegisterRequest {
  username: string
  email: string
  password: string
  first_name_ar?: string
  last_name_ar?: string
}

export interface AuthUser {
  id: number
  uuid: string
  username: string
  email: string
  status: string
  roles: string[]
}

export interface ChangePasswordRequest {
  currentPassword: string
  newPassword: string
}

// ─── Roles ───
export type RoleCode =
  | 'SUPER_ADMIN'
  | 'SYS_ADMIN'
  | 'ADMIN'
  | 'ETHICS_ADMIN'
  | 'COMMITTEE_CHAIR'
  | 'REVIEWER'
  | 'INST_COORDINATOR'
  | 'RESEARCHER'

export interface Role {
  id: number
  code: RoleCode
  name_ar: string
  name_en?: string
}

// ─── Users ───
export interface User {
  id: number
  uuid: string
  username: string
  email: string
  first_name_ar?: string
  last_name_ar?: string
  status: string
  roles: string[]
  institution_name?: string
}

export interface UserProfile {
  id: number
  user_id: number
  national_id?: string
  passport_number?: string
  gender?: string
  date_of_birth?: string
  nationality_code?: string
  academic_title?: string
  specialization?: string
  biography?: string
}

export interface CreateUserRequest {
  username: string
  email: string
  password: string
  first_name_ar?: string
  last_name_ar?: string
  role_codes?: RoleCode[]
}

// ─── Projects ───
export interface Project {
  id: number
  project_code: string
  title_ar: string
  title_en?: string
  principal_investigator_id: number
  research_category?: string
  risk_level?: string
  current_status: string
}

export interface CreateProjectRequest {
  title_ar: string
  title_en?: string
  abstract_ar?: string
  objectives: string
  research_category?: string
  risk_level?: string
}

// ─── Applications ───
export interface Application {
  id: number
  application_number: string
  project_id: number
  submitted_by: number
  status: string
  target_committee_id: number
  current_status: string
  application_type: string
  priority_level?: string
  remarks?: string
  project_title?: string
  project_code?: string
  submitted_by_username?: string
  committee_name?: string
  status_name_ar?: string
  created_at: string
  updated_at?: string
}

export interface CreateApplicationRequest {
  project_id: number
  target_committee_id: number
  application_type?: string
  save_as_draft?: boolean
  [key: string]: any
}

export interface CommitteeDecisionRequest {
  decision: 'APPROVED' | 'REJECTED' | 'REVISIONS_REQUIRED'
  notes?: string
}

// ─── Committees ───
export interface Committee {
  id: number
  committee_code: string
  committee_name_ar: string
  committee_name_en?: string
  committee_type_id: number
  committee_type_name?: string
  institution_name?: string
  is_active: boolean
  created_at?: string
}

export interface Meeting {
  id: number
  committee_id: number
  meeting_date: string
  title: string
  status: string
}

export interface CommitteeMember {
  id: number
  user_id: number
  committee_id: number
  role: string
}

// ─── Reviews ───
export interface ReviewForm {
  id: number
  form_code: string
  title: string
  is_active: boolean
}

export interface ReviewQuestion {
  id: number
  form_id: number
  question_code: string
  question_text: string
  question_type: string
  sort_order: number
}

// ─── Documents ───
export interface Document {
  id: number
  document_title: string
  file_name: string
  mime_type: string
  entity_type?: string
  entity_id?: number
  uploaded_by: number
  uploaded_at: string
}

export interface DocumentSignature {
  id: number
  document_id: number
  signer_id: number
  signature_type: string
  signature_hash: string
  signed_at: string
}

// ─── Communication ───
export interface Notification {
  id: number
  user_id: number
  title: string
  body: string
  is_read: boolean
  created_at: string
}

export interface Message {
  id: number
  subject: string
  body: string
  sender_id: number
  created_at: string
}

export interface SendMessageRequest {
  subject: string
  body: string
  recipient_ids: number[] | string
  parent_id?: number
}

// ─── Safety ───
export interface RiskRegister {
  id: number
  risk_title: string
  risk_level: string
  status: string
  created_by: number
}

export interface AdverseEvent {
  id: number
  event_type: string
  severity: string
  description: string
  reported_at: string
}

// ─── Workflow ───
export interface WorkflowDefinition {
  id: number
  code: string
  name: string
  entity_type: string
}

export interface WorkflowInstance {
  id: number
  workflow_definition_id: number
  entity_type: string
  entity_id: number
  current_state: string
}

// ─── Admin ───
export interface AdminStats {
  users: { total: number; active: number }
  applications: { total: number }
  projects: { total: number }
  committees: { total: number }
  reviews: { total: number }
  meetings: { total: number }
}

export interface AuditLogEntry {
  id: number
  user_id: number
  action_type: string
  entity_type: string
  entity_id?: number
  created_at: string
  username?: string
}

// ─── Monitoring ───
export interface HealthStatus {
  status: string
  timestamp: string
}

// ─── Permissions ───
export interface Permission {
  id: number
  permission_code: string
  name: string
  description?: string
}

// ─── Responsibility ───
export interface ResponsibilityType {
  id: number
  code: string
  name_ar: string
  name_en?: string
}

export interface UserResponsibility {
  id: number
  user_id: number
  responsibility_type_id: number
  entity_type: string
  entity_id: number
}

// ─── Document metadata ───
export interface DocumentType {
  id: number
  code: string
  name_ar: string
}

export interface DocumentClassification {
  id: number
  code: string
  name_ar: string
}

// ─── Safety sub-entities ───
export interface RiskMitigation {
  id: number
  risk_id: number
  mitigation_plan: string
  status: string
}

export interface RiskIncident {
  id: number
  risk_id: number
  incident_code: string
  incident_date: string
  description: string
  severity: string
  status: string
}

export interface CorrectiveAction {
  id: number
  incident_id: number
  action_plan: string
  status: string
  assigned_to: number
}

// ─── Voting ───
export interface VotingSession {
  id: number
  meeting_id: number
  voting_type: string
  status: string
}

export interface Vote {
  id: number
  session_id: number
  voter_id: number
  vote_value: string
}

// ─── Review extensions ───
export interface ReviewAssignment {
  id: number
  application_id: number
  reviewer_id: number
  form_id?: number
  status: string
}

export interface ReviewRecommendation {
  id: number
  application_id: number
  recommendation: string
}

export interface ReviewComment {
  id: number
  application_id: number
  comment_text: string
  created_by: number
}

export interface ReviewAnswer {
  id: number
  assignment_id: number
  question_id: number
  answer_value: string
}

export interface ReviewScore {
  id: number
  assignment_id: number
  total_score: number
}

// ─── Meeting sub-entities ───
export interface AgendaItem {
  id: number
  agenda_id: number
  title: string
  sort_order: number
}

export interface Attendance {
  id: number
  meeting_id: number
  user_id: number
  status: string
}

export interface Minutes {
  id: number
  meeting_id: number
  content: string
  is_approved: boolean
}

export interface MemberTerm {
  id: number
  member_id: number
  start_date: string
  end_date?: string
}

export interface MemberQualification {
  id: number
  member_id: number
  qualification: string
}

export interface MemberConflict {
  id: number
  member_id: number
  application_id: number
  conflict_type: string
}

// ─── Reporting ───
export interface DashboardStats {
  users: { total: number; active: number }
  applications: { total: number; pending: number }
  projects: { total: number }
  committees: { total: number }
  reviews: { total: number; pending: number }
  meetings: { total: number }
}

export interface StatusSummary {
  status: string
  count: number
}

export interface ApplicationTrend {
  date: string
  count: number
}

// ─── System ───
export interface SavedSearch {
  id: number
  name: string
  search_type: string
  criteria: any
  is_shared: boolean
}

export interface SystemConfig {
  key: string
  value: string
}

// ─── Workflow ───
export interface WorkflowTransition {
  transition: string
  from_state: string
  to_state: string
}

// ─── Reference ───
export interface Institution {
  id: number
  name_ar: string
  name_en?: string
}

export interface Profession {
  id: number
  name_ar: string
  name_en?: string
}

export interface License {
  id: number
  license_number: string
  license_type: string
}

export interface ResearchCategory {
  id: number
  code: string
  name_ar: string
}

export interface RiskClassification {
  id: number
  level: string
  name_ar: string
}

export interface VulnerablePopulation {
  id: number
  code: string
  name_ar: string
}

// ─── Integration ───
export interface IntegrationEvent {
  id: number
  event_type: string
  status: string
}

export interface IntegrationLog {
  id: number
  event_id: number
  message: string
  log_level: string
}

// ─── Monitoring ───
export interface MonitoringAudit {
  id: number
  action: string
  user_id: number
  created_at: string
}

// ─── Recent activity (admin) ───
export interface RecentActivity {
  id: number
  action: string
  entity_type: string
  username: string
  created_at: string
}
