import { z } from 'zod'

export const loginSchema = z.object({
  username: z.string({ message: 'Username is required' }).min(1),
  password: z.string({ message: 'Password is required' }).min(1),
})

export const projectCreateSchema = z.object({
  title_ar: z.string({ message: 'Arabic title is required' }).min(1),
  title_en: z.string().optional().default(''),
  abstract_ar: z.string().optional().default(''),
  abstract_en: z.string().optional().default(''),
  objectives: z.string({ message: 'Objectives are required' }).min(1),
  start_date: z.string().optional().default(''),
  expected_end_date: z.string().optional().default(''),
  research_category: z.string().optional().default(''),
  risk_level: z.string().optional().default(''),
})

export const applicationCreateSchema = z.object({
  project_id: z.string({ message: 'Project is required' }).min(1),
  application_type: z.string().default('INITIAL'),
  target_committee_id: z.string({ message: 'Committee is required' }).min(1),
})

export const profileSchema = z.object({
  national_id: z.string().optional().default(''),
  passport_number: z.string().optional().default(''),
  gender: z.string().optional().default(''),
  date_of_birth: z.string().optional().default(''),
  nationality_code: z.string().optional().default(''),
  academic_title: z.string().optional().default(''),
  specialization: z.string().optional().default(''),
  biography: z.string().optional().default(''),
})

export const changePasswordSchema = z.object({
  oldPassword: z.string({ message: 'Current password is required' }).min(1),
  newPassword: z.string({ message: 'New password must be at least 8 characters' }).min(8),
  confirmPassword: z.string({ message: 'Please confirm your password' }).min(1),
}).refine((data: { newPassword: string; confirmPassword: string }) => data.newPassword === data.confirmPassword, {
  message: 'Passwords do not match',
  path: ['confirmPassword'],
})

export const registerSchema = z.object({
  username: z.string({ message: 'Username is required' }).min(3, 'At least 3 characters'),
  email: z.string({ message: 'Email is required' }).email('Invalid email'),
  password: z.string({ message: 'Password must be at least 8 characters' }).min(8),
  confirmPassword: z.string({ message: 'Please confirm password' }).min(1),
  first_name_ar: z.string().optional().default(''),
  last_name_ar: z.string().optional().default(''),
  first_name_en: z.string().optional().default(''),
  last_name_en: z.string().optional().default(''),
  mobile: z.string().optional().default(''),
  institution_id: z.string({ message: 'Please select an institution' }).min(1, 'Institution is required'),
}).refine((data: any) => data.password === data.confirmPassword, {
  message: 'Passwords do not match',
  path: ['confirmPassword'],
})

export const createUserSchema = z.object({
  username: z.string({ message: 'Username is required' }).min(1),
  email: z.string({ message: 'Valid email is required' }).min(1).email('Invalid email'),
  password: z.string({ message: 'Password must be at least 8 characters' }).min(8),
  first_name_ar: z.string().optional().default(''),
  last_name_ar: z.string().optional().default(''),
  first_name_en: z.string().optional().default(''),
  last_name_en: z.string().optional().default(''),
  mobile: z.string().optional().default(''),
  institution_id: z.string().optional().default(''),
  department_id: z.string().optional().default(''),
  role_codes: z.array(z.string()).optional().default([]),
})

export const documentUploadSchema = z.object({
  document_type_id: z.string().optional().default(''),
  entity_type: z.string().optional().default(''),
  entity_id: z.string().optional().default(''),
  document_title: z.string().optional().default(''),
})

export const reviewFormSchema = z.object({
  form_code: z.string({ message: 'Form code is required' }).min(1),
  form_name: z.string({ message: 'Form name is required' }).min(1),
  review_type: z.string().default('ETHICS'),
})

export const addQuestionSchema = z.object({
  question_code: z.string({ message: 'Question code is required' }).min(1),
  question_text: z.string({ message: 'Question text is required' }).min(1),
  question_type: z.enum(['TEXT', 'SCALE', 'BOOLEAN', 'CHOICE']).default('TEXT'),
  is_required: z.boolean().default(true),
  question_options: z.string().optional().default(''),
})

export const savedSearchSchema = z.object({
  name: z.string({ message: 'Name is required' }).min(1),
  search_type: z.string({ message: 'Entity type is required' }).min(1),
  criteria: z.string().optional().default(''),
  is_shared: z.boolean().optional().default(false),
})

export const riskRegisterSchema = z.object({
  risk_code: z.string({ message: 'Risk code is required' }).min(1),
  risk_title: z.string({ message: 'Title is required' }).min(1),
  risk_description: z.string().optional().default(''),
  likelihood: z.coerce.number().min(1).max(5).optional(),
  impact: z.coerce.number().min(1).max(5).optional(),
  risk_level: z.string().optional().default(''),
  owner_id: z.coerce.number().optional(),
  status: z.string().optional().default('IDENTIFIED'),
})

export const messageSchema = z.object({
  subject: z.string({ message: 'Subject is required' }).min(1),
  message_body: z.string().optional().default(''),
})

export const workflowTransitionSchema = z.object({
  transition_code: z.string({ message: 'Select a transition' }).min(1),
  comment: z.string().optional().default(''),
})

export const reviewSubmissionSchema = z.object({
  recommendation_type: z.string().default('APPROVE'),
  justification: z.string().optional().default(''),
  comment_text: z.string().optional().default(''),
})

export const committeeDecisionSchema = z.object({
  decision: z.string().default('APPROVED'),
  notes: z.string().optional().default(''),
})

export const meetingAgendaSchema = z.object({
  title: z.string({ message: 'Title is required' }).min(1),
  description: z.string().optional().default(''),
})

export const agendaItemSchema = z.object({
  title: z.string({ message: 'Item title is required' }).min(1),
  application_id: z.string().optional().default(''),
})

export const attendanceSchema = z.object({
  user_id: z.string({ message: 'Select a member' }).min(1),
  attendance_status: z.string().default('PRESENT'),
  remarks: z.string().optional().default(''),
})

export const minutesSchema = z.object({
  minutes_text: z.string({ message: 'Minutes text is required' }).min(1),
})

export const votingSessionSchema = z.object({
  application_id: z.string({ message: 'Application ID is required' }).min(1),
})
