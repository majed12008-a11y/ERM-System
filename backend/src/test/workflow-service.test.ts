import { describe, it, expect, vi, beforeEach } from 'vitest';

const mockRepo = vi.hoisted(() => ({
  findInstance: vi.fn(),
  findTransition: vi.fn(),
  createAction: vi.fn().mockResolvedValue(undefined),
  createHistory: vi.fn().mockResolvedValue(undefined),
  updateInstanceState: vi.fn().mockResolvedValue(undefined),
  completeInstance: vi.fn().mockResolvedValue(undefined),
  getEntityOwnerId: vi.fn(),
}));

vi.mock('../repositories/workflow.repository', () => ({
  WorkflowRepository: function() { return mockRepo; },
}));

import { WorkflowService } from '../services/workflow.service';

describe('WorkflowService.executeTransition', () => {
  let service: WorkflowService;
  const mockClient = {} as any;

  beforeEach(() => {
    service = new WorkflowService();
    vi.clearAllMocks();
    mockRepo.findInstance.mockResolvedValue({
      instance_id: 10,
      current_state_id: 5,
      current_state_code: 'CLOSED',
    });
    mockRepo.findTransition.mockResolvedValue({
      id: 20,
      transition_code: 'ARCHIVE',
      to_state_id: 8,
      to_state_code: 'ARCHIVED',
      to_state_is_terminal: true,
      requires_comment: false,
      allowed_roles: null,
    });
  });

  describe('terminal state transitions', () => {
    it('calls completeInstance when transition leads to ARCHIVED', async () => {
      const user = { id: 1, roles: ['SUPER_ADMIN'] } as any;
      await service.executeTransition('Application', 1, 'ARCHIVE', user, undefined, mockClient);
      expect(mockRepo.completeInstance).toHaveBeenCalledWith(10, mockClient);
    });

    it('does NOT call completeInstance when transition leads to APPROVED (non-terminal)', async () => {
      mockRepo.findInstance.mockResolvedValue({
        instance_id: 11,
        current_state_id: 6,
        current_state_code: 'COMMITTEE_REVIEW',
      });
      mockRepo.findTransition.mockResolvedValue({
        id: 30,
        transition_code: 'COMMITTEE_APPROVE',
        to_state_id: 9,
        to_state_code: 'APPROVED',
        to_state_is_terminal: false,
        requires_comment: false,
        allowed_roles: null,
      });
      const user = { id: 1, roles: ['COMMITTEE_CHAIR'] } as any;
      await service.executeTransition('Application', 1, 'COMMITTEE_APPROVE', user, undefined, mockClient);
      expect(mockRepo.completeInstance).not.toHaveBeenCalled();
    });

    it('calls completeInstance when transition leads to REJECTED', async () => {
      mockRepo.findTransition.mockResolvedValue({
        id: 31,
        transition_code: 'COMMITTEE_REJECT',
        to_state_id: 10,
        to_state_code: 'REJECTED',
        to_state_is_terminal: true,
        requires_comment: false,
        allowed_roles: null,
      });
      const user = { id: 1, roles: ['COMMITTEE_CHAIR'] } as any;
      await service.executeTransition('Application', 1, 'COMMITTEE_REJECT', user, undefined, mockClient);
      expect(mockRepo.completeInstance).toHaveBeenCalledWith(10, mockClient);
    });

    it('does NOT call completeInstance when transition leads to a non-terminal state', async () => {
      mockRepo.findInstance.mockResolvedValue({
        instance_id: 12,
        current_state_id: 1,
        current_state_code: 'DRAFT',
      });
      mockRepo.findTransition.mockResolvedValue({
        id: 40,
        transition_code: 'SUBMIT',
        to_state_id: 2,
        to_state_code: 'SUBMITTED',
        to_state_is_terminal: false,
        requires_comment: false,
        allowed_roles: null,
      });
      const user = { id: 2, roles: ['RESEARCHER'] } as any;
      await service.executeTransition('Application', 1, 'SUBMIT', user, undefined, mockClient);
      expect(mockRepo.completeInstance).not.toHaveBeenCalled();
    });

    it('calls completeInstance for WITHDRAWN', async () => {
      mockRepo.findTransition.mockResolvedValue({
        id: 50,
        transition_code: 'WITHDRAW',
        to_state_id: 11,
        to_state_code: 'WITHDRAWN',
        to_state_is_terminal: true,
        requires_comment: false,
        allowed_roles: null,
      });
      const user = { id: 2, roles: ['RESEARCHER'] } as any;
      await service.executeTransition('Application', 1, 'WITHDRAW', user, undefined, mockClient);
      expect(mockRepo.completeInstance).toHaveBeenCalledWith(10, mockClient);
    });
  });

  describe('authorization guards', () => {
    it('throws 400 when no active workflow instance', async () => {
      mockRepo.findInstance.mockResolvedValue(null);
      const user = { id: 1, roles: ['SUPER_ADMIN'] } as any;
      await expect(
        service.executeTransition('Application', 999, 'ANY', user, undefined, mockClient)
      ).rejects.toThrow('No active workflow instance');
    });

    it('throws 400 when transition is invalid for current state', async () => {
      mockRepo.findTransition.mockResolvedValue(null);
      const user = { id: 1, roles: ['SUPER_ADMIN'] } as any;
      await expect(
        service.executeTransition('Application', 1, 'INVALID', user, undefined, mockClient)
      ).rejects.toThrow('Invalid transition for current state');
    });

    it('throws 403 when role not allowed', async () => {
      mockRepo.findTransition.mockResolvedValue({
        id: 20,
        transition_code: 'ARCHIVE',
        to_state_id: 8,
        to_state_code: 'ARCHIVED',
        requires_comment: false,
        allowed_roles: 'SUPER_ADMIN',
      });
      const user = { id: 3, roles: ['RESEARCHER'] } as any;
      await expect(
        service.executeTransition('Application', 1, 'ARCHIVE', user, undefined, mockClient)
      ).rejects.toThrow('Not authorized for this transition');
    });

    it('allows an admin to execute a transition even without the exact role', async () => {
      mockRepo.findTransition.mockResolvedValue({
        id: 20,
        transition_code: 'SUBMIT',
        to_state_id: 2,
        to_state_code: 'SUBMITTED',
        requires_comment: false,
        allowed_roles: 'RESEARCHER',
      });
      const user = { id: 1, roles: ['SUPER_ADMIN'] } as any;
      await expect(
        service.executeTransition('Application', 1, 'SUBMIT', user, undefined, mockClient)
      ).resolves.toMatchObject({ transition_code: 'SUBMIT' });
      expect(mockRepo.getEntityOwnerId).not.toHaveBeenCalled();
    });

    it('allows the entity owner to execute an owner-scoped transition without the exact role', async () => {
      mockRepo.findTransition.mockResolvedValue({
        id: 20,
        transition_code: 'SUBMIT',
        to_state_id: 2,
        to_state_code: 'SUBMITTED',
        requires_comment: false,
        allowed_roles: 'RESEARCHER',
      });
      mockRepo.getEntityOwnerId.mockResolvedValue(3);
      const user = { id: 3, roles: ['INST_COORDINATOR'] } as any;
      await expect(
        service.executeTransition('Application', 1, 'SUBMIT', user, undefined, mockClient)
      ).resolves.toMatchObject({ transition_code: 'SUBMIT' });
    });

    it('rejects an owner who lacks the role for a non-owner-scoped transition', async () => {
      mockRepo.findTransition.mockResolvedValue({
        id: 20,
        transition_code: 'ACCEPT_INITIAL',
        to_state_id: 2,
        to_state_code: 'INITIAL_REVIEW',
        requires_comment: false,
        allowed_roles: 'ETHICS_ADMIN,COMMITTEE_CHAIR,SUPER_ADMIN',
      });
      mockRepo.getEntityOwnerId.mockResolvedValue(3);
      const user = { id: 3, roles: ['RESEARCHER'] } as any;
      await expect(
        service.executeTransition('Application', 1, 'ACCEPT_INITIAL', user, undefined, mockClient)
      ).rejects.toThrow('Not authorized for this transition');
    });

    it('rejects a non-owner who lacks the role on an owner-scoped transition', async () => {
      mockRepo.findTransition.mockResolvedValue({
        id: 20,
        transition_code: 'SUBMIT',
        to_state_id: 2,
        to_state_code: 'SUBMITTED',
        requires_comment: false,
        allowed_roles: 'RESEARCHER',
      });
      mockRepo.getEntityOwnerId.mockResolvedValue(99);
      const user = { id: 3, roles: ['INST_COORDINATOR'] } as any;
      await expect(
        service.executeTransition('Application', 1, 'SUBMIT', user, undefined, mockClient)
      ).rejects.toThrow('Not authorized for this transition');
    });
  });
});
