import type { WorkflowTransition } from '../sdk/core/types';

export const EDITABLE_APPLICATION_STATUSES = ['DRAFT', 'RETURNED'];

const SUBMISSION_TRANSITIONS: Record<string, string> = {
  DRAFT: 'SUBMIT',
  RETURNED: 'RESUBMIT',
};

export function getSubmitTransition(currentStatus: string): string {
  const transition = SUBMISSION_TRANSITIONS[currentStatus];
  if (!transition) {
    throw new Error(`No submission transition defined for status: ${currentStatus}`);
  }
  return transition;
}

export function findTransition(
  transitions: WorkflowTransition[],
  transitionCode: string
): WorkflowTransition | undefined {
  return transitions.find(t => t.transition_code === transitionCode);
}
