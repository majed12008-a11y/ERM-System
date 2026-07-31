// ─── Resolver Interfaces ────────────────────────────────────────────

export interface IResolver<TDto extends Record<string, any>> {
  readonly entityType: string;
  resolve(entityId: number, variableCode: string, context?: ResolveContext): Promise<unknown>;
  resolveBatch(entityIds: number[], requestedVariables: string[], context?: ResolveContext): Promise<Map<number, Partial<TDto>>>;
}

export interface ResolveContext {
  userId?: number;
  userRoles?: string[];
  locale?: string;
}

// ─── Resolve Request / Result Types ────────────────────────────────

export interface ResolveRequest {
  entityType: string;
  entityId: number;
  variableCode: string;
  args?: Record<string, unknown>;
}

export interface ResolveResult {
  entityType: string;
  entityId: number;
  variableCode: string;
  value: unknown;
  resolved: boolean;
  error?: string;
}

export interface BatchResolveInput {
  requests: ResolveRequest[];
  context?: ResolveContext;
}

export interface BatchResolveOutput {
  results: ResolveResult[];
  cachedCount: number;
  resolvedCount: number;
  failedCount: number;
  durationMs: number;
}

// ─── Cache Types ───────────────────────────────────────────────────

export interface CacheEntry {
  value: unknown;
  resolvedAt: Date;
}

export interface ResolverCache {
  get(entityType: string, entityId: number, variableCode: string): CacheEntry | undefined;
  set(entityType: string, entityId: number, variableCode: string, value: unknown): void;
  clear(): void;
}

// ─── DTOs ──────────────────────────────────────────────────────────

export interface ApplicationResolveDTO {
  id: number;
  application_number: string;
  project_id: number;
  project_title?: string;
  project_code?: string;
  application_type: string;
  submitted_by: number;
  submitted_by_username?: string;
  target_committee_id: number;
  current_status: string;
  status_name_ar?: string;
  created_at: Date;
  created_by: number;
}

export interface ConditionResolveDTO {
  id: number;
  application_id: number;
  condition_text: string;
  severity: string;
  category: string;
  status: string;
  due_date: Date | null;
  resolved_by: number | null;
  resolved_at: Date | null;
}

export interface UserResolveDTO {
  id: number;
  uuid: string;
  username: string;
  email: string;
  first_name_ar?: string;
  last_name_ar?: string;
  first_name_en?: string;
  last_name_en?: string;
  institution_id: number;
  institution_name_ar?: string;
  status: string;
  roles: string[];
}

export interface CommitteeResolveDTO {
  id: number;
  committee_code: string;
  committee_name_ar: string;
  committee_name_en: string | null;
  committee_type: string;
  institution_id: number;
  is_active: boolean;
}

export interface DocumentResolveDTO {
  id: number;
  file_name: string;
  file_type: string;
  file_size_bytes: number;
  entity_type: string;
  entity_id: number;
  uploaded_by: number;
  uploaded_by_username?: string;
  created_at: Date;
}

export interface InstitutionResolveDTO {
  id: number;
  name_ar: string;
  name_en: string | null;
  code: string;
  city: string | null;
  country: string | null;
  is_active: boolean;
}

export interface NotificationResolveDTO {
  id: number;
  user_id: number;
  notification_type: string;
  subject: string;
  message_body: string;
  priority_level: string;
  created_at: Date;
}

export interface MeetingResolveDTO {
  id: number;
  committee_id: number;
  meeting_date: Date;
  meeting_type: string;
  status: string;
  location: string | null;
}

export interface ReviewResolveDTO {
  id: number;
  application_id: number;
  reviewer_id: number;
  reviewer_name?: string;
  decision: string | null;
  comments: string | null;
  submitted_at: Date | null;
}

export interface ReportResolveDTO {
  id: number;
  report_type: string;
  entity_type: string;
  entity_id: number;
  generated_by: number;
  generated_at: Date;
  status: string;
}

export interface CommunicationResolveDTO {
  id: number;
  communication_type: string;
  subject: string;
  body: string;
  sender_id: number;
  recipient_id: number;
  sent_at: Date;
}

export interface SafetyReportResolveDTO {
  id: number;
  application_id: number;
  report_type: string;
  severity: string;
  description: string;
  reported_by: number;
  reported_at: Date;
  status: string;
}

// ─── Entity Root Constants ─────────────────────────────────────────

export const ENTITY_ROOTS = [
  'Application',
  'Condition',
  'User',
  'Committee',
  'Institution',
  'Notification',
  'Document',
  'Meeting',
  'Review',
  'Report',
  'Communication',
  'SafetyReport',
] as const;

export type EntityRoot = (typeof ENTITY_ROOTS)[number];

// ─── Variable Code Mapping ─────────────────────────────────────────

export interface VariableMapping {
  variableCode: string;
  fieldPath: string;
  description: string;
}

export interface ResolverMetadata {
  entityType: string;
  supportedVariables: VariableMapping[];
  repositoryDependencies: string[];
}
