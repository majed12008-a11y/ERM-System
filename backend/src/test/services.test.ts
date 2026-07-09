import { describe, it, expect, vi, beforeEach } from 'vitest';

vi.mock('../config/database', () => ({
  withTransaction: vi.fn((fn: any) => {
    const mockClient = { query: vi.fn().mockResolvedValue({ rows: [] }) };
    return fn(mockClient);
  }),
}));

vi.mock('../services/notification.service', () => {
  class MockNotificationService {
    async send() { return undefined; }
  }
  return {
    createAndNotifyBatch: vi.fn(),
    broadcastDashboardEvent: vi.fn(),
    NotificationService: MockNotificationService,
  };
});

import { ApplicationService } from '../services/application.service';
import { withTransaction } from '../config/database';
import { broadcastDashboardEvent } from '../services/notification.service';

describe('ApplicationService', () => {
  let service: ApplicationService;
  let mockRepo: any;
  let mockWorkflow: any;
  let mockConditions: any;

  beforeEach(() => {
    mockRepo = {
      findAll: vi.fn(),
      findById: vi.fn(),
      create: vi.fn(),
      generateApplicationNumber: vi.fn(),
      update: vi.fn(),
      updateStatus: vi.fn(),
      softDelete: vi.fn(),
    };
    mockWorkflow = {
      initWorkflow: vi.fn(),
      executeTransition: vi.fn().mockResolvedValue({ to_state: 'APPROVED' }),
    };
    mockConditions = {
      validateTransition: vi.fn().mockResolvedValue(undefined),
    };
    service = new ApplicationService(mockRepo, mockWorkflow, mockConditions);
    vi.clearAllMocks();
  });

  describe('1. updateStatus requires transition_code', () => {
    it('executes transition and returns updated application', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1, current_status: 'SUBMITTED' });
      mockWorkflow.executeTransition.mockResolvedValue({ to_state: 'INITIAL_REVIEW' });
      mockRepo.updateStatus.mockResolvedValue({ id: 1, current_status: 'INITIAL_REVIEW' });
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'], is_email_verified: true };

      const result = await service.updateStatus(1, { transition_code: 'ACCEPT_INITIAL' }, user);

      expect(result.current_status).toBe('INITIAL_REVIEW');
      expect(mockWorkflow.executeTransition).toHaveBeenCalledWith('Application', 1, 'ACCEPT_INITIAL', user, undefined, expect.any(Object));
      expect(mockRepo.updateStatus).toHaveBeenCalledWith(1, 'INITIAL_REVIEW', expect.any(Object));
    });

    it('propagates 403 from executeTransition when role not allowed', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1, current_status: 'SUBMITTED' });
      mockWorkflow.executeTransition.mockRejectedValue(
        Object.assign(new Error('Not authorized for this transition'), { status: 403 })
      );
      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'], is_email_verified: true };
      const err = await service.updateStatus(1, { transition_code: 'ACCEPT_INITIAL' }, user)
        .catch(e => e);
      expect(err.status).toBe(403);
      expect(err.message).toMatch(/not authorized/i);
    });
  });

  describe('2. Error Handling: missing resources return 404', () => {
    it('getById throws 404 when application not found', async () => {
      mockRepo.findById.mockResolvedValue(null);
      const err = await service.getById(999).catch(e => e);
      expect(err.status).toBe(404);
      expect(err.message).toBe('Application not found');
    });

    it('updateStatus throws 404 when application not found after transition', async () => {
      mockWorkflow.executeTransition.mockResolvedValue({ to_state: 'APPROVED' });
      mockRepo.updateStatus.mockResolvedValue(null);
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'], is_email_verified: true };
      const err = await service.updateStatus(999, { transition_code: 'COMMITTEE_APPROVE' }, user)
        .catch(e => e);
      expect(err.status).toBe(404);
    });

    it('softDelete throws 404 when already deleted', async () => {
      mockRepo.softDelete.mockResolvedValue(null);
      const err = await service.softDelete(999).catch(e => e);
      expect(err.status).toBe(404);
      expect(err.message).toMatch(/not found or already deleted/i);
    });
  });

  describe('3. Transaction: create uses withTransaction and broadcasts', () => {
    it('creates application in single transaction', async () => {
      const mockClient = {};
      vi.mocked(withTransaction).mockImplementationOnce((fn: any) => fn(mockClient));
      mockRepo.generateApplicationNumber.mockResolvedValue('APP-2025-001');
      mockRepo.create.mockResolvedValue({ id: 100, application_number: 'APP-2025-001' });

      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'], is_email_verified: true };
      const data = { project_id: 35, application_type: 'INITIAL', target_committee_id: 3 };
      const result = await service.create(data, user);

      expect(mockRepo.generateApplicationNumber).toHaveBeenCalledWith(mockClient);
      expect(mockRepo.create).toHaveBeenCalledWith({
        application_number: 'APP-2025-001',
        project_id: 35,
        application_type: 'INITIAL',
        submitted_by: 27,
        target_committee_id: 3,
      }, mockClient);
      expect(mockWorkflow.initWorkflow).not.toHaveBeenCalled();
      expect(broadcastDashboardEvent).toHaveBeenCalledWith('dashboard-stats', {});
      expect(result.id).toBe(100);
    });

    it('propagates error when generateApplicationNumber fails', async () => {
      const mockClient = {};
      vi.mocked(withTransaction).mockImplementationOnce((fn: any) => fn(mockClient));
      mockRepo.generateApplicationNumber.mockRejectedValue(new Error('Generation error'));
      mockRepo.create.mockResolvedValue({ id: 101 });

      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'], is_email_verified: true };
      const data = { project_id: 35, application_type: 'INITIAL', target_committee_id: 3 };

      await expect(service.create(data, user)).rejects.toThrow('Generation error');
      expect(mockRepo.create).not.toHaveBeenCalled();
      expect(broadcastDashboardEvent).not.toHaveBeenCalled();
    });
  });

  describe('4. updateDraft status guard', () => {
    it('accepts DRAFT applications', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1, submitted_by: 27, current_status: 'DRAFT' });
      mockRepo.update.mockResolvedValue({ id: 1, current_status: 'DRAFT' });
      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'], is_email_verified: true };

      const result = await service.updateDraft(1, { remarks: 'updated' }, user);

      expect(result.current_status).toBe('DRAFT');
      expect(mockRepo.update).toHaveBeenCalledWith(1, { remarks: 'updated' });
    });

    it('accepts RETURNED applications', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1, submitted_by: 27, current_status: 'RETURNED' });
      mockRepo.update.mockResolvedValue({ id: 1, current_status: 'RETURNED' });
      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'], is_email_verified: true };

      const result = await service.updateDraft(1, { remarks: 'updated' }, user);

      expect(result.current_status).toBe('RETURNED');
    });

    it('rejects SUBMITTED applications', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1, submitted_by: 27, current_status: 'SUBMITTED' });
      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'], is_email_verified: true };

      const err = await service.updateDraft(1, { remarks: 'updated' }, user).catch(e => e);

      expect(err.status).toBe(400);
      expect(err.message).toMatch(/draft or returned/i);
    });

    it('rejects APPROVED applications', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1, submitted_by: 27, current_status: 'APPROVED' });
      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'], is_email_verified: true };

      const err = await service.updateDraft(1, { remarks: 'updated' }, user).catch(e => e);

      expect(err.status).toBe(400);
      expect(err.message).toMatch(/draft or returned/i);
    });

    it('does not call executeTransition or initWorkflow', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1, submitted_by: 27, current_status: 'DRAFT' });
      mockRepo.update.mockResolvedValue({ id: 1, current_status: 'DRAFT' });
      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'], is_email_verified: true };

      await service.updateDraft(1, { remarks: 'updated' }, user);

      expect(mockWorkflow.executeTransition).not.toHaveBeenCalled();
      expect(mockWorkflow.initWorkflow).not.toHaveBeenCalled();
    });
  });

  describe('5. updateStatus supports committee transitions', () => {
    beforeEach(() => {
      mockRepo.findById.mockResolvedValue({ id: 1, current_status: 'SUBMITTED' });
    });

    it('executes COMMITTEE_APPROVE transition via generic endpoint', async () => {
      mockWorkflow.executeTransition.mockResolvedValue({ to_state: 'APPROVED' });
      mockRepo.updateStatus.mockResolvedValue({ id: 1, current_status: 'APPROVED' });
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'], is_email_verified: true };

      const result = await service.updateStatus(1, { transition_code: 'COMMITTEE_APPROVE', comment: 'Looks good' }, user);

      expect(result.current_status).toBe('APPROVED');
      expect(mockWorkflow.executeTransition).toHaveBeenCalledWith('Application', 1, 'COMMITTEE_APPROVE', user, 'Looks good', expect.any(Object));
    });

    it('executes COMMITTEE_REJECT transition', async () => {
      mockWorkflow.executeTransition.mockResolvedValue({ to_state: 'REJECTED' });
      mockRepo.updateStatus.mockResolvedValue({ id: 1, current_status: 'REJECTED' });
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'], is_email_verified: true };

      const result = await service.updateStatus(1, { transition_code: 'COMMITTEE_REJECT', comment: 'Insufficient' }, user);

      expect(result.current_status).toBe('REJECTED');
      expect(mockWorkflow.executeTransition).toHaveBeenCalledWith('Application', 1, 'COMMITTEE_REJECT', user, 'Insufficient', expect.any(Object));
    });

    it('executes COMMITTEE_CONDITIONAL transition', async () => {
      mockWorkflow.executeTransition.mockResolvedValue({ to_state: 'CONDITIONAL' });
      mockRepo.updateStatus.mockResolvedValue({ id: 1, current_status: 'CONDITIONAL' });
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'], is_email_verified: true };

      const result = await service.updateStatus(1, { transition_code: 'COMMITTEE_CONDITIONAL', comment: 'Minor revisions' }, user);

      expect(result.current_status).toBe('CONDITIONAL');
      expect(mockWorkflow.executeTransition).toHaveBeenCalledWith('Application', 1, 'COMMITTEE_CONDITIONAL', user, 'Minor revisions', expect.any(Object));
    });
  });
});
