export const ACCREDITATION_CYCLE_STATUS = {
  PENDING: 'PENDING',
  UNDER_REVIEW: 'UNDER_REVIEW',
  ACCREDITED: 'ACCREDITED',
  CONDITIONAL: 'CONDITIONAL',
  SUSPENDED: 'SUSPENDED',
  EXPIRED: 'EXPIRED',
  REVOKED: 'REVOKED',
} as const;
export type AccreditationCycleStatus = typeof ACCREDITATION_CYCLE_STATUS[keyof typeof ACCREDITATION_CYCLE_STATUS];

export const ACCREDITATION_DECISION_TYPE = {
  APPLY: 'APPLY',
  SUBMIT: 'SUBMIT',
  APPROVE: 'APPROVE',
  CONDITIONAL: 'CONDITIONAL',
  SUSPEND: 'SUSPEND',
  REVOKE: 'REVOKE',
  EXPIRE: 'EXPIRE',
  RESUME: 'RESUME',
} as const;
export type AccreditationDecisionType = typeof ACCREDITATION_DECISION_TYPE[keyof typeof ACCREDITATION_DECISION_TYPE];

export const ASSESSMENT_DECISION = {
  RECOMMEND_APPROVE: 'RECOMMEND_APPROVE',
  RECOMMEND_CONDITIONAL: 'RECOMMEND_CONDITIONAL',
  RECOMMEND_REJECT: 'RECOMMEND_REJECT',
  DEFER: 'DEFER',
} as const;
export type AssessmentDecision = typeof ASSESSMENT_DECISION[keyof typeof ASSESSMENT_DECISION];

export const EVIDENCE_STATUS = {
  PENDING: 'PENDING',
  SUBMITTED: 'SUBMITTED',
  ACCEPTED: 'ACCEPTED',
  REJECTED: 'REJECTED',
  EXPIRED: 'EXPIRED',
} as const;
export type EvidenceStatus = typeof EVIDENCE_STATUS[keyof typeof EVIDENCE_STATUS];

export const CONDITION_STATUS = {
  OPEN: 'OPEN',
  MET: 'MET',
  OVERDUE: 'OVERDUE',
  WAIVED: 'WAIVED',
} as const;
export type ConditionStatus = typeof CONDITION_STATUS[keyof typeof CONDITION_STATUS];

export const CYCLE_STATUS_TRANSITIONS: Record<AccreditationCycleStatus, AccreditationCycleStatus[]> = {
  PENDING: ['UNDER_REVIEW'],
  UNDER_REVIEW: ['ACCREDITED', 'CONDITIONAL', 'SUSPENDED', 'REVOKED'],
  ACCREDITED: ['SUSPENDED', 'EXPIRED', 'REVOKED'],
  CONDITIONAL: ['ACCREDITED', 'SUSPENDED', 'REVOKED'],
  SUSPENDED: ['ACCREDITED', 'CONDITIONAL', 'REVOKED'],
  EXPIRED: ['REVOKED'],
  REVOKED: [],
};

export const DECISION_TYPE_STATUS_MAP: Record<string, AccreditationCycleStatus> = {
  APPLY: 'PENDING',
  SUBMIT: 'UNDER_REVIEW',
  APPROVE: 'ACCREDITED',
  CONDITIONAL: 'CONDITIONAL',
  SUSPEND: 'SUSPENDED',
  REVOKE: 'REVOKED',
  EXPIRE: 'EXPIRED',
  RESUME: 'PENDING',
};

export const ACCREDITATION_ROLES = {
  COMMITTEE_ADMIN: 'COMMITTEE_ADMIN',
  ASSESSOR: 'ASSESSOR',
  ACCREDITATION_ADMIN: 'ACCREDITATION_ADMIN',
} as const;
export type AccreditationRole = typeof ACCREDITATION_ROLES[keyof typeof ACCREDITATION_ROLES];

export function canTransition(from: AccreditationCycleStatus, to: AccreditationCycleStatus): boolean {
  return CYCLE_STATUS_TRANSITIONS[from]?.includes(to) ?? false;
}

export function isValidTransition(from: string, to: string, decision: string): boolean {
  const expectedTo = DECISION_TYPE_STATUS_MAP[decision];
  if (!expectedTo) return false;
  if (expectedTo !== to) return false;
  return canTransition(from as AccreditationCycleStatus, to as AccreditationCycleStatus);
}
