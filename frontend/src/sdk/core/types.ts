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
  target_committee_id: number
  current_status: string
  application_type: string
  priority_level?: string
  remarks?: string
  project_title?: string
  project_title_en?: string
  project_code?: string
  research_category?: string
  project_risk_level?: string
  project_objectives?: string
  submitted_by_username?: string
  submitted_by_email?: string
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
}

// ─── Committees ───
export interface Committee {
  id: number
  committee_code: string
  committee_name_ar: string
  committee_name_en?: string
  committee_type_id: number
  committee_type_name?: string
  institution_id?: number
  institution_name?: string
  is_active: boolean
  created_at?: string
  updated_at?: string
}

export interface CommitteeType {
  id: number
  name_ar: string
  name_en?: string
}

export interface CommitteeRole {
  id: number
  name_ar: string
  name_en?: string
}

export interface Meeting {
  id: number
  committee_id: number
  meeting_number: string
  meeting_date: string
  meeting_type: string
  title?: string
  location?: string
  meeting_status: string
  committee_name?: string
  created_at?: string
}

export interface CommitteeMember {
  id: number
  user_id: number
  committee_id: number
  role_id?: number
  role: string
  role_name?: string
  display_name?: string
  username?: string
  email?: string
  is_active?: boolean
  assigned_at?: string
}

// ─── Reviews ───
export interface ReviewForm {
  id: number
  form_code: string
  form_name: string
  title?: string
  review_type: string
  description?: string
  is_active: boolean
  question_count?: number
  version_no?: number
}

export interface ReviewQuestion {
  id: number
  form_id: number
  question_code: string
  question_text: string
  question_type: string
  is_required?: boolean
  sort_order?: number
  display_order?: number
  scale_min?: number | null
  scale_max?: number | null
  question_options?: string | null
}

// ─── Documents ───
export interface Document {
  id: number
  document_title: string
  file_name: string
  mime_type: string
  entity_type?: string
  entity_id?: number
  document_type_id?: number
  type_name_ar?: string
  uploaded_by: number
  uploaded_at: string
  created_at: string
  file_size_bytes?: number
  uploaded_by_username?: string
  storage_path?: string
  deleted_at?: string
}

export interface DocumentSignature {
  id: number
  document_id: number
  signer_id: number
  signer_name?: string
  display_name?: string
  signature_type: string
  signature_hash: string
  signed_at: string
}

// ─── Communication ───
export interface Notification {
  id: number
  user_id: number
  subject: string
  message_body: string
  notification_type?: string
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
  service: string
  version: string
  status: string
  requestId: string
  uptime: number
  timestamp: string
  checks: {
    database: string
    smtp: string
  }
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
  application_id?: number
  voting_type: string
  title?: string
  description?: string
  status: string
  status_code?: string
  project_title?: string
  application_number?: string
  voting_start?: string | null
  voting_end?: string | null
  votes?: Vote[]
  created_at?: string
}

export interface Vote {
  id: number
  session_id?: number
  voting_session_id?: number
  voter_id: number
  voter_name?: string
  vote_value: string
  comments?: string | null
  voted_at?: string
  vote_time?: string
}

// ─── Review extensions ───
export interface ReviewAssignment {
  id: number
  application_id: number
  reviewer_id: number
  reviewer_name?: string
  form_id?: number
  status: string
  status_code?: string
  review_type?: string
  assigned_at?: string
  assigned_by?: number
  due_date?: string
  application_number?: string
  project_title?: string
  current_status?: string
  created_at?: string
}

export interface ReviewRecommendation {
  id: number
  application_id: number
  reviewer_id?: number
  reviewer_name?: string
  recommendation: string
  recommendation_type?: string
  justification?: string
  created_at?: string
}

export interface ReviewComment {
  id: number
  application_id: number
  reviewer_id?: number
  reviewer_name?: string
  comment_text: string
  is_internal?: boolean
  created_by?: number
  created_at?: string
}

export interface ReviewAnswer {
  id: number
  assignment_id?: number
  review_id?: number
  question_id: number
  question_text?: string
  answer_value: string
  answer_text?: string
  answer_score?: number | null
}

export interface ReviewScore {
  id: number
  assignment_id?: number
  application_id?: number
  reviewer_id?: number
  review_type?: string
  total_score?: number
  score?: number
}

// ─── Meeting sub-entities ───
export interface AgendaItem {
  id: number
  agenda_id: number
  title: string
  description?: string
  sort_order: number
  item_order?: number
  application_id?: number
  app_number?: string
}

export interface Attendance {
  id: number
  meeting_id: number
  user_id: number
  attendance_status: string
  status?: string
  display_name?: string
  username?: string
  remarks?: string
  recorded_at?: string
}

export interface Minutes {
  id: number
  meeting_id: number
  content?: string
  minutes_text: string
  is_approved: boolean
  created_by?: number
  created_by_username?: string
  approved_by?: number
  approved_by_username?: string
  approved_at?: string
  signatures?: { id: number; signer_id: number; signer_name: string; signed_at: string; signature_type?: string }[]
}

export interface AgendaSection {
  id: number
  meeting_id: number
  title: string
  description?: string
  items: AgendaItem[]
}

export interface MemberTerm {
  id: number
  member_id: number
  start_date: string
  end_date?: string
  is_active?: boolean
  appointment_decision_no?: string
  termination_decision_no?: string
}

export interface MemberQualification {
  id: number
  member_id: number
  qualification?: string
  specialization: string
  academic_degree: string
  institution_name?: string
  experience_years?: number
  is_verified?: boolean
}

export interface MemberConflict {
  id: number
  member_id: number
  application_id?: number
  entity_type?: string
  entity_id?: number
  conflict_type: string
  description?: string
  declared_at?: string
  resolved_at?: string
}

// ─── Reporting ───
export interface DashboardStats {
  applications: {
    total: number
    submitted: number
    under_review: number
    approved: number
    rejected: number
  }
  projects: { total: number }
  upcomingMeetings: { total: number }
  pendingReviews: { pending: number }
}

export interface StatusSummary {
  current_status: string
  count: number
}

export interface ApplicationTrend {
  month: string
  count: number
}

export interface ReportApplication {
  id: number
  application_number: string
  current_status: string
  application_type: string
  created_at: string
  updated_at?: string
  project_title?: string
  project_title_en?: string
  committee_name?: string
}

export interface ReportCommittee {
  id: number
  committee_name_ar: string
  committee_type?: string
  total_reviews: number
  total_meetings: number
}

export interface ReportApplicationsParams {
  status?: string
  from?: string
  to?: string
  search?: string
  page?: number
  limit?: number
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
  id: number
  transition_code: string
  transition_name?: string
  requires_comment: boolean
  allowed_roles?: string | null
  to_state_code: string
  to_state_name?: string
}

export interface AvailableTransitionsResponse {
  current_state: string | null
  transitions: WorkflowTransition[]
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

// ─── Conditions ───
export type ConditionSeverity = 'CRITICAL' | 'MAJOR' | 'MINOR'
export type ConditionStatus = 'OPEN' | 'MET' | 'NOT_MET' | 'WAIVED'

export interface ApplicationCondition {
  id: number
  application_id: number
  condition_text: string
  severity: ConditionSeverity
  category: string
  due_date: string | null
  status: ConditionStatus
  resolved_by: number | null
  resolved_by_name?: string | null
  resolved_at: string | null
  created_at: string
  created_by: number
  updated_at: string | null
  updated_by: number | null
}

export interface CreateConditionRequest {
  condition_text: string
  severity?: ConditionSeverity
  category?: string
  due_date?: string
}

export interface UpdateConditionRequest {
  condition_text?: string
  severity?: ConditionSeverity
  category?: string
  due_date?: string | null
}

export interface ResolveConditionRequest {
  status: 'MET' | 'NOT_MET' | 'WAIVED'
}

export interface ConditionEvaluation {
  total: number
  open: number
  met: number
  notMet: number
  waived: number
  allSatisfied: boolean
  canApprove: boolean
  canReject: boolean
  canSubmitEvidence: boolean
  unmetConditionIds: number[]
  missingEvidenceIds: number[]
}

// ─── Recent activity (admin) ───
export interface RecentActivity {
  id: number
  action: string
  entity_type: string
  username: string
  created_at: string
}
