/*
 * مخططات Zod للتحقق من صحة البيانات المدخلة في جميع نقاط النهاية
 * مثل تسجيل الدخول والتسجيل وتغيير كلمة المرور وتحديث الملف الشخصي.
 */
import { z } from 'zod';

export const loginSchema = z.object({
  username: z.string().min(1, 'Username is required').max(100),
  password: z.string().min(1, 'Password is required').max(200),
});

export const createUserSchema = z.object({
  username: z.string().min(3, 'Username must be at least 3 characters').max(50),
  email: z.string().email('Invalid email format').max(255),
  password: z.string().min(8, 'Password must be at least 8 characters').max(100),
  first_name_ar: z.string().max(100).optional().default(''),
  last_name_ar: z.string().max(100).optional().default(''),
  first_name_en: z.string().max(100).optional().default(''),
  last_name_en: z.string().max(100).optional().default(''),
  mobile: z.string().max(20).optional().default(''),
  institution_id: z.string().min(1, 'Institution is required'),
  department_id: z.string().optional(),
  role_codes: z.array(z.string()).optional().default([]),
});

export const createApplicationSchema = z.object({
  project_id: z.coerce.number().positive('Project ID is required'),
  application_type: z.enum(['INITIAL', 'AMENDMENT', 'RENEWAL', 'EXPEDITED']).default('INITIAL'),
  target_committee_id: z.coerce.number().positive('Committee ID is required'),
});

export const createProjectSchema = z.object({
  title_ar: z.string().min(1, 'Arabic title is required').max(500),
  title_en: z.string().max(500).optional().default(''),
  abstract_ar: z.string().max(2000).optional().default(''),
  abstract_en: z.string().max(2000).optional().default(''),
  objectives: z.string().min(1, 'Objectives are required').max(2000),
  start_date: z.string().optional(),
  expected_end_date: z.string().optional(),
  research_category: z.string().optional().default(''),
  risk_level: z.string().optional().default(''),
});

export const assignReviewSchema = z.object({
  application_id: z.coerce.number().positive(),
  reviewer_id: z.coerce.number().positive(),
  review_type: z.string().min(1, 'Review type is required'),
  due_date: z.string().optional(),
});

export const createMessageSchema = z.object({
  recipient_ids: z.string().transform((v) => {
    try { return JSON.parse(v); } catch { return v.split(',').map(Number); }
  }).pipe(z.array(z.number().positive()).min(1, 'At least one recipient required')),
  subject: z.string().min(1, 'Subject is required').max(500),
  message_body: z.string().optional().default(''),
  related_entity_type: z.string().max(100).optional(),
  related_entity_id: z.string().max(100).optional(),
});

export const createReviewFormSchema = z.object({
  form_code: z.string().min(1, 'Form code is required').max(50),
  form_name: z.string().min(1, 'Form name is required').max(255),
  review_type: z.string().min(1, 'Review type is required'),
  description: z.string().max(1000).optional(),
  is_active: z.boolean().optional().default(true),
});

export const addQuestionSchema = z.object({
  question_code: z.string().min(1, 'Question code is required').max(50),
  question_text: z.string().min(1, 'Question text is required').max(1000),
  question_type: z.enum(['TEXT', 'SCALE', 'BOOLEAN', 'CHOICE']),
  is_required: z.boolean().optional().default(false),
  display_order: z.coerce.number().int().positive().optional(),
  scale_min: z.coerce.number().int().optional(),
  scale_max: z.coerce.number().int().optional(),
  question_options: z.string().optional(),
});

export const createCommitteeSchema = z.object({
  committee_code: z.string().min(1, 'Committee code is required').max(50),
  committee_name_ar: z.string().min(1, 'Arabic name is required').max(500),
  committee_name_en: z.string().max(500).optional().default(''),
  institution_id: z.string().min(1, 'Institution is required'),
  committee_type_id: z.string().min(1, 'Committee type is required'),
  is_active: z.boolean().optional().default(true),
});

export const updateCommitteeSchema = z.object({
  committee_name_ar: z.string().max(500).optional(),
  committee_name_en: z.string().max(500).optional(),
  institution_id: z.string().optional(),
  committee_type_id: z.string().optional(),
  is_active: z.boolean().optional(),
});

export const updateUserSchema = z.object({
  email: z.string().email('Invalid email format').max(255).optional(),
  first_name_ar: z.string().max(100).optional(),
  last_name_ar: z.string().max(100).optional(),
  first_name_en: z.string().max(100).optional(),
  last_name_en: z.string().max(100).optional(),
  mobile: z.string().max(20).optional(),
  institution_id: z.string().optional(),
  department_id: z.string().optional(),
  status: z.enum(['ACTIVE', 'INACTIVE', 'SUSPENDED']).optional(),
  role_codes: z.array(z.string()).optional(),
});

export const executeTransitionSchema = z.object({
  entity_type: z.string().min(1),
  entity_id: z.coerce.number().positive(),
  transition_code: z.string().min(1),
  comment: z.string().optional(),
});

export const registerSchema = z.object({
  username: z.string().min(3, 'Username must be at least 3 characters').max(50),
  email: z.string().email('Invalid email format').max(255),
  password: z.string().min(8, 'Password must be at least 8 characters').max(100),
  first_name_ar: z.string().max(100).optional().default(''),
  last_name_ar: z.string().max(100).optional().default(''),
  first_name_en: z.string().max(100).optional().default(''),
  last_name_en: z.string().max(100).optional().default(''),
  mobile: z.string().max(20).optional().default(''),
  institution_id: z.string().min(1, 'Institution is required'),
});

export const signDocumentSchema = z.object({
  signature_type: z.enum(['ELECTRONIC', 'DIGITAL', 'WET']).default('ELECTRONIC'),
});

export const forgotPasswordSchema = z.object({
  email: z.string().email('Valid email is required').max(255),
});

export const resetPasswordSchema = z.object({
  token: z.string().min(1, 'Reset token is required'),
  password: z.string().min(8, 'Password must be at least 8 characters').max(100),
});

export const verifyEmailSchema = z.object({
  token: z.string().min(1, 'Verification token is required'),
});

export const changePasswordSchema = z.object({
  oldPassword: z.string().min(1, 'Current password is required').max(200),
  newPassword: z.string().min(8, 'New password must be at least 8 characters').max(100),
});

export const createMeetingSchema = z.object({
  committee_id: z.coerce.number().positive(),
  meeting_number: z.string().min(1).max(100),
  meeting_date: z.string().min(1),
  location: z.string().max(500).optional(),
  meeting_status: z.string().optional(),
});

export const createAgendaSchema = z.object({
  title: z.string().min(1).max(500),
  description: z.string().optional(),
});

export const addAttendanceSchema = z.object({
  user_id: z.coerce.number().positive(),
  attendance_status: z.string().min(1).max(50),
  remarks: z.string().optional(),
});

export const createMinutesSchema = z.object({
  minutes_text: z.string().min(1),
});

export const createVotingSessionSchema = z.object({
  meeting_id: z.coerce.number().positive(),
  application_id: z.coerce.number().positive(),
  voting_type: z.string().min(1).max(50).default('STANDARD'),
  title: z.string().min(1).max(500),
  description: z.string().optional(),
});

export const castVoteSchema = z.object({
  vote_value: z.string().min(1).max(50),
  comments: z.string().optional(),
});

export const createTermSchema = z.object({
  start_date: z.string().min(1),
  end_date: z.string().optional(),
  appointment_decision_no: z.string().optional(),
  termination_decision_no: z.string().optional(),
});

export const createQualificationSchema = z.object({
  specialization: z.string().min(1).max(100),
  academic_degree: z.string().min(1).max(100),
  institution_name: z.string().optional(),
  experience_years: z.coerce.number().positive().optional(),
});

export const createConflictSchema = z.object({
  entity_type: z.string().min(1).max(50),
  entity_id: z.coerce.number().positive(),
  conflict_type: z.string().min(1).max(100),
  description: z.string().optional(),
});

export const createAdverseEventSchema = z.object({
  application_id: z.coerce.number().positive(),
  event_number: z.string().min(1).max(100),
  event_type: z.string().min(1).max(100),
  severity: z.string().min(1).max(50),
  description: z.string().min(1),
  participant_reference: z.string().optional(),
  event_date: z.string().min(1),
  expectedness: z.string().optional(),
  relatedness: z.string().optional(),
  outcome_status: z.string().optional(),
});

export const createRiskIncidentSchema = z.object({
  risk_id: z.coerce.number().positive().optional(),
  title: z.string().min(1).max(300),
  description: z.string().min(1),
  severity: z.string().max(50).optional(),
});

export const createCorrectiveActionSchema = z.object({
  description: z.string().min(1),
  assigned_to: z.coerce.number().positive(),
  due_date: z.string().min(1),
  priority: z.string().optional(),
});

export const createRoleSchema = z.object({
  code: z.string().min(1).max(100),
  name_ar: z.string().min(1).max(200),
  name_en: z.string().max(200).optional(),
  description: z.string().optional(),
});

export const createPermissionSchema = z.object({
  permission_code: z.string().min(1).max(100),
  module_name: z.string().min(1).max(100),
  action_name: z.string().min(1).max(100),
  description: z.string().optional(),
});

export const setRolePermissionsSchema = z.object({
  permission_ids: z.array(z.coerce.number().positive()).min(1),
});

export const upsertProfileSchema = z.object({
  national_id: z.string().max(50).optional(),
  passport_number: z.string().max(50).optional(),
  gender: z.enum(['MALE', 'FEMALE']).optional(),
  date_of_birth: z.string().optional(),
  nationality_code: z.string().max(10).optional(),
  academic_title: z.string().max(200).optional(),
  specialization: z.string().max(500).optional(),
  biography: z.string().max(2000).optional(),
});

export const riskItemInputSchema = z.object({
  risk_category_id: z.coerce.number().positive(),
  risk_description: z.string().min(1, 'Risk description is required').max(2000),
  probability: z.coerce.number().int().min(1).max(5),
  severity: z.coerce.number().int().min(1).max(5),
  mitigation_plan: z.string().max(2000).optional(),
  residual_probability: z.coerce.number().int().min(1).max(5).optional().nullable(),
  residual_severity: z.coerce.number().int().min(1).max(5).optional().nullable(),
  is_acceptable: z.boolean().optional().default(false),
});

export const createEthicsRiskAssessmentSchema = z.object({
  application_id: z.coerce.number().positive(),
  ethics_review_id: z.coerce.number().positive().optional().nullable(),
  scientific_review_id: z.coerce.number().positive().optional().nullable(),
  overall_risk_level: z.enum(['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']),
  recommendation: z.string().max(100).optional(),
  summary: z.string().max(2000).optional(),
  items: z.array(riskItemInputSchema).optional().default([]),
});

export const addRiskItemSchema = riskItemInputSchema;

export const updateRiskItemSchema = riskItemInputSchema.partial();

export const createConsentTemplateSchema = z.object({
  code: z.string().min(1).max(50),
  name_ar: z.string().min(1).max(500),
  name_en: z.string().min(1).max(500),
  description: z.string().max(2000).optional(),
  consent_type: z.enum(['WRITTEN', 'ELECTRONIC', 'VERBAL', 'GUARDIAN', 'ASSENT', 'WAIVER', 'DEFERRED']),
});

export const updateConsentTemplateSchema = createConsentTemplateSchema.partial();

export const createConsentVersionSchema = z.object({
  version_no: z.coerce.number().int().positive(),
  language: z.enum(['ar', 'en']),
  title: z.string().min(1).max(500),
  content: z.string().optional(),
  document_id: z.coerce.number().positive().optional().nullable(),
  effective_from: z.string().optional().nullable(),
  change_summary: z.string().max(2000).optional(),
});

export const updateConsentVersionSchema = createConsentVersionSchema.partial();

export const assignConsentSchema = z.object({
  application_id: z.coerce.number().positive(),
  consent_version_id: z.coerce.number().positive(),
  is_required: z.boolean().optional().default(true),
});

export const replaceConsentVersionSchema = z.object({
  consent_version_id: z.coerce.number().positive(),
});

export const createConsentReviewSchema = z.object({
  application_consent_id: z.coerce.number().positive(),
  decision: z.enum(['APPROVED', 'MINOR_REVISION', 'MAJOR_REVISION', 'REJECTED']),
  comment: z.string().min(1).max(2000),
});

export const updateConsentReviewSchema = z.object({
  decision: z.enum(['APPROVED', 'MINOR_REVISION', 'MAJOR_REVISION', 'REJECTED']).optional(),
  comment: z.string().min(1).max(2000).optional(),
});

export const updateApplicationStatusSchema = z.object({
  transition_code: z.string().min(1, 'transition_code is required'),
  comment: z.string().max(2000).optional(),
  remarks: z.string().max(2000).optional(),
});

export const createConditionSchema = z.object({
  condition_text: z.string().min(1, 'Condition text is required').max(2000),
  severity: z.enum(['CRITICAL', 'MAJOR', 'MINOR']).optional().default('MAJOR'),
  category: z.string().max(100).optional(),
  due_date: z.string().optional(),
});

export const updateConditionSchema = createConditionSchema.partial();

export const resolveConditionSchema = z.object({
  status: z.enum(['MET', 'NOT_MET', 'WAIVED']),
});

export const updateApplicationSchema = z.object({
  application_type: z.enum(['INITIAL', 'AMENDMENT', 'RENEWAL', 'EXPEDITED']).optional(),
  target_committee_id: z.coerce.number().positive().optional(),
  priority_level: z.string().max(50).optional(),
  remarks: z.string().max(2000).optional(),
});

// ── PB-001 new schemas ──────────────────────────────────────────────────────

export const updateRoleSchema = createRoleSchema.partial();

export const createResponsibilitySchema = z.object({
  user_id: z.coerce.number().positive(),
  responsibility_type_id: z.coerce.number().positive(),
  entity_type: z.string().max(100).optional(),
  entity_id: z.string().max(100).optional(),
});

export const withdrawApplicationSchema = z.object({
  comment: z.string().max(2000).optional(),
});

export const appealApplicationSchema = z.object({
  comment: z.string().min(1, 'Appeal justification is required').max(2000),
});

export const uploadEvidenceSchema = z.object({
  document_title: z.string().max(500).optional(),
});

export const revokeCertificateSchema = z.object({
  reason: z.string().min(1, 'Revocation reason is required').max(2000),
});

export const updateMeetingSchema = z.object({
  meeting_date: z.string().optional(),
  location: z.string().max(500).optional(),
  meeting_status: z.string().max(50).optional(),
  chairperson_id: z.coerce.number().positive().optional(),
});

export const submitReviewSchema = z.object({
  recommendation_type: z.enum(['APPROVE', 'REJECT', 'CONDITIONAL', 'ABSTAIN']),
  justification: z.string().max(2000).optional(),
  comment_text: z.string().max(2000).optional(),
  is_internal: z.boolean().optional(),
  answers: z.array(z.object({
    question_id: z.coerce.number().positive(),
    answer_text: z.string().optional(),
    answer_score: z.coerce.number().min(0).max(100).optional(),
  })).optional(),
});

export const addCommitteeMemberSchema = z.object({
  user_id: z.coerce.number().positive('user_id is required'),
  role_id: z.coerce.number().positive().optional(),
});

export const updateCommitteeMemberSchema = z.object({
  role_id: z.coerce.number().positive('role_id is required'),
});

export const updateConsentRequiredSchema = z.object({
  is_required: z.boolean(),
});

export const updateEthicsRiskAssessmentSchema = z.object({
  overall_risk_level: z.enum(['LOW', 'MEDIUM', 'HIGH', 'CRITICAL']).optional(),
  recommendation: z.string().max(100).optional(),
  summary: z.string().max(2000).optional(),
});

export const uploadDocumentSchema = z.object({
  document_type_id: z.coerce.number().positive().optional(),
  entity_type: z.string().max(100).optional(),
  entity_id: z.coerce.number().positive().optional(),
  document_title: z.string().max(500).optional(),
  file_name: z.string().max(500).optional(),
  mime_type: z.string().max(100).optional(),
});

export const updateRiskRegisterSchema = z.object({
  risk_title: z.string().min(1).max(300).optional(),
  risk_description: z.string().min(1).optional(),
  likelihood: z.coerce.number().int().min(1).max(5).optional(),
  impact: z.coerce.number().int().min(1).max(5).optional(),
  risk_level: z.string().max(50).optional(),
  owner_id: z.coerce.number().positive().optional(),
  status: z.string().max(50).optional(),
});

export const createMitigationSchema = z.object({
  mitigation_plan: z.string().min(1, 'Mitigation plan is required').max(2000),
  responsible_party: z.string().max(255).optional(),
  target_date: z.string().min(1, 'Target date is required'),
  status: z.string().max(50).optional(),
});

export const createEmailConfigSchema = z.object({
  config_name: z.string().min(1, 'Config name is required').max(100),
  smtp_host: z.string().min(1, 'SMTP host is required').max(255),
  smtp_port: z.coerce.number().int().positive('SMTP port is required'),
  smtp_username: z.string().max(255).optional().default(''),
  smtp_password: z.string().max(255).optional().default(''),
  use_tls: z.boolean().optional().default(true),
  from_address: z.string().min(1, 'From address is required').max(255),
  from_name: z.string().max(255).optional().default(''),
  is_active: z.boolean().optional().default(true),
});

export const updateEmailConfigSchema = createEmailConfigSchema.partial();

export const createPushConfigSchema = z.object({
  config_name: z.string().min(1, 'Config name is required').max(100),
  provider: z.string().min(1, 'Provider is required').max(100),
  server_key: z.string().max(500).optional().default(''),
  app_id: z.string().max(255).optional().default(''),
  is_active: z.boolean().optional().default(true),
});

export const updatePushConfigSchema = createPushConfigSchema.partial();

// ── SMS Config ───────────────────────────────────────────────────────────────

export const createSmsConfigSchema = z.object({
  config_name: z.string().min(1, 'Config name is required').max(200),
  provider: z.string().min(1, 'Provider is required').max(100),
  api_key: z.string().max(500).optional().default(''),
  api_secret: z.string().max(500).optional().default(''),
  sender_name: z.string().max(100).optional().default(''),
  is_active: z.boolean().optional().default(true),
});

export const updateSmsConfigSchema = createSmsConfigSchema.partial();

// ── System Config ────────────────────────────────────────────────────────────

export const updateSystemConfigSchema = z.object({
  config_value: z.string().min(1, 'config_value is required'),
  description: z.string().max(500).optional().default(''),
}).strict();

// ── Reference Data Per-Entity Schemas ────────────────────────────────────────

export const referenceDataSchemas: Record<string, z.ZodObject<any>> = {
  'academic-titles': z.object({
    code: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(200),
    name_en: z.string().max(200).optional().default(''),
    display_order: z.coerce.number().int().min(0).optional(),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'institutions': z.object({
    institution_type_id: z.coerce.number().positive(),
    code: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(300),
    name_en: z.string().max(300).optional().default(''),
    license_number: z.string().max(100).optional().default(''),
    registration_number: z.string().max(100).optional().default(''),
    email: z.string().email().max(200).optional().or(z.literal('')),
    phone: z.string().max(100).optional().default(''),
    address: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'institution-types': z.object({
    code: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(200),
    name_en: z.string().max(200).optional().default(''),
    description: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'departments': z.object({
    institution_id: z.coerce.number().positive(),
    code: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(200),
    name_en: z.string().max(200).optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'research-categories': z.object({
    code: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(200),
    name_en: z.string().max(200).optional().default(''),
    description: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'risk-classifications': z.object({
    code: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(200),
    name_en: z.string().max(200).optional().default(''),
    severity_level: z.string().max(50).optional().default(''),
    description: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'vulnerable-populations': z.object({
    code: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(200),
    name_en: z.string().max(200).optional().default(''),
    description: z.string().optional().default(''),
    safeguards_required: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'document-types': z.object({
    type_code: z.string().min(1).max(50),
    type_name_ar: z.string().min(1).max(200),
    type_name_en: z.string().max(200).optional().default(''),
    description: z.string().optional().default(''),
    is_required: z.boolean().optional().default(false),
  }).strict(),

  'committee-types': z.object({
    type_code: z.string().min(1).max(50),
    type_name: z.string().min(1).max(200),
    description: z.string().optional().default(''),
  }).strict(),

  'committee-roles': z.object({
    role_code: z.string().min(1).max(50),
    role_name: z.string().min(1).max(200),
    description: z.string().optional().default(''),
  }).strict(),

  'notification-channels': z.object({
    channel_code: z.string().min(1).max(50),
    channel_name: z.string().min(1).max(200),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'lookup-categories': z.object({
    category_code: z.string().min(1).max(50),
    category_name_ar: z.string().min(1).max(200),
    category_name_en: z.string().max(200).optional().default(''),
    description: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'lookup-values': z.object({
    category_id: z.coerce.number().positive(),
    value_code: z.string().min(1).max(50),
    value_name_ar: z.string().min(1).max(200),
    value_name_en: z.string().max(200).optional().default(''),
    display_order: z.coerce.number().int().min(0).optional(),
    is_default: z.boolean().optional().default(false),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'professions': z.object({
    code: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(200),
    name_en: z.string().max(200).optional().default(''),
    category: z.string().max(100).optional().default(''),
    description: z.string().optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),

  'institutions-registry': z.object({
    national_id: z.string().min(1).max(50),
    name_ar: z.string().min(1).max(300),
    name_en: z.string().max(300).optional().default(''),
    type: z.string().max(100).optional().default(''),
    address: z.string().optional().default(''),
    city: z.string().max(100).optional().default(''),
    country: z.string().max(100).optional().default(''),
    phone: z.string().max(50).optional().default(''),
    email: z.string().max(200).optional().default(''),
    website: z.string().max(500).optional().default(''),
    is_accredited: z.boolean().optional().default(false),
    accreditation_body: z.string().max(200).optional().default(''),
    license_number: z.string().max(100).optional().default(''),
    is_active: z.boolean().optional().default(true),
  }).strict(),
};
