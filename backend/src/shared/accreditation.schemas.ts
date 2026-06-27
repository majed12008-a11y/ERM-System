import { z } from 'zod';

export const cycleStatusEnum = z.enum(['PENDING','UNDER_REVIEW','ACCREDITED','CONDITIONAL','SUSPENDED','EXPIRED','REVOKED']);
export const decisionTypeEnum = z.enum(['APPLY','SUBMIT','APPROVE','CONDITIONAL','SUSPEND','REVOKE','EXPIRE','RESUME']);
export const assessmentDecisionEnum = z.enum(['RECOMMEND_APPROVE','RECOMMEND_CONDITIONAL','RECOMMEND_REJECT','DEFER']);
export const evidenceStatusEnum = z.enum(['PENDING','SUBMITTED','ACCEPTED','REJECTED','EXPIRED']);
export const conditionStatusEnum = z.enum(['OPEN','MET','OVERDUE','WAIVED']);
export const conditionSeverityEnum = z.enum(['MINOR','MAJOR','CRITICAL']);

export const createCycleSchema = z.object({
  committee_id: z.coerce.number().positive(),
  standard_version_id: z.coerce.number().positive(),
  cycle_number: z.coerce.number().int().positive().optional(),
  status: cycleStatusEnum.default('PENDING'),
});

export const updateCycleStatusSchema = z.object({
  to_status: cycleStatusEnum,
  decision: decisionTypeEnum,
  decided_by: z.coerce.number().positive(),
  decision_reason: z.string().optional(),
  notes: z.string().optional(),
});

export const createEvidenceSchema = z.object({
  cycle_id: z.coerce.number().positive(),
  standard_version_id: z.coerce.number().positive().optional(),
  document_id: z.coerce.number().positive().optional(),
  notes: z.string().optional(),
});

export const updateEvidenceStatusSchema = z.object({
  status: evidenceStatusEnum,
  reviewed_by: z.coerce.number().positive().optional(),
  review_notes: z.string().optional(),
});

export const createAssessmentSchema = z.object({
  cycle_id: z.coerce.number().positive(),
  overall_decision: assessmentDecisionEnum,
  overall_justification: z.string().optional(),
  items: z.array(z.object({
    standard_version_id: z.coerce.number().positive(),
    is_met: z.boolean().default(false),
    findings: z.string().optional(),
    score: z.coerce.number().int().min(1).max(5).optional(),
  })).optional().default([]),
});

export const updateAssessmentItemsSchema = z.object({
  items: z.array(z.object({
    standard_version_id: z.coerce.number().positive(),
    is_met: z.boolean(),
    findings: z.string().optional(),
    score: z.coerce.number().int().min(1).max(5).optional(),
  })),
});

export const createConditionSchema = z.object({
  cycle_id: z.coerce.number().positive(),
  condition_text: z.string().min(1, 'Condition text is required'),
  due_date: z.string().datetime({ message: 'Invalid due date format' }),
  severity: conditionSeverityEnum.optional().default('MAJOR'),
  assessment_id: z.coerce.number().positive().optional(),
  assessment_item_id: z.coerce.number().positive().optional(),
  standard_version_id: z.coerce.number().positive().optional(),
});

export const resolveConditionSchema = z.object({
  status: conditionStatusEnum,
  resolved_by: z.coerce.number().positive().optional(),
});

export const createDecisionSchema = z.object({
  cycle_id: z.coerce.number().positive(),
  from_status: cycleStatusEnum.optional(),
  to_status: cycleStatusEnum,
  decision: decisionTypeEnum,
  decided_by: z.coerce.number().positive(),
  decision_reason: z.string().optional(),
  notes: z.string().optional(),
});
