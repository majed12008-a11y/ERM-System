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
  institution_id: z.string().optional(),
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

export const committeeDecisionSchema = z.object({
  decision: z.enum(['APPROVED', 'REJECTED', 'CONDITIONAL']),
  notes: z.string().max(2000).optional(),
});

export const forgotPasswordSchema = z.object({
  email: z.string().email('Valid email is required').max(255),
});

export const resetPasswordSchema = z.object({
  token: z.string().min(1, 'Reset token is required'),
  password: z.string().min(8, 'Password must be at least 8 characters').max(100),
});
