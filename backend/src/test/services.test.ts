import { describe, it, expect, vi, beforeEach } from 'vitest';

vi.mock('../config/database', () => ({
  withTransaction: vi.fn((fn: any) => {
    const mockClient = { query: vi.fn().mockResolvedValue({ rows: [] }) };
    return fn(mockClient);
  }),
}));

vi.mock('../services/notification.service', () => ({
  createAndNotify: vi.fn(),
  createAndNotifyBatch: vi.fn(),
  broadcastDashboardEvent: vi.fn(),
}));

import { ApplicationService } from '../services/application.service';
import { withTransaction } from '../config/database';
import { broadcastDashboardEvent, createAndNotify } from '../services/notification.service';

describe('ApplicationService', () => {
  let service: ApplicationService;
  let mockRepo: any;
  let mockWorkflow: any;

  beforeEach(() => {
    mockRepo = {
      findAll: vi.fn(),
      findById: vi.fn(),
      create: vi.fn(),
      generateApplicationNumber: vi.fn(),
      updateStatus: vi.fn(),
      softDelete: vi.fn(),
      countPendingReviews: vi.fn(),
    };
    mockWorkflow = {
      initWorkflow: vi.fn(),
      executeTransition: vi.fn().mockResolvedValue({ to_state: 'APPROVED' }),
      autoTransition: vi.fn(),
    };
    service = new ApplicationService(mockRepo, mockWorkflow);
    vi.clearAllMocks();
  });

  describe('1. Authorization: updateStatus blocks non-privileged roles', () => {
    it('allows ETHICS_ADMIN to update status', async () => {
      mockRepo.updateStatus.mockResolvedValue({ id: 1, current_status: 'UNDER_REVIEW' });
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'] };

      const result = await service.updateStatus(1, { status: 'UNDER_REVIEW' }, user);

      expect(result.current_status).toBe('UNDER_REVIEW');
      expect(mockRepo.updateStatus).toHaveBeenCalledWith(1, 'UNDER_REVIEW', expect.any(Object));
    });

    it('blocks RESEARCHER with 403', async () => {
      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'] };
      const err = await service.updateStatus(1, { status: 'UNDER_REVIEW' }, user)
        .catch(e => e);
      expect(err.status).toBe(403);
      expect(err.message).toMatch(/not authorized/i);
    });

    it('blocks REVIEWER with 403', async () => {
      const user = { id: 24, uuid: '', institution_id: 1, username: 'reviewer', email: 'rev@test.com', status: 'ACTIVE', roles: ['REVIEWER'] };
      const err = await service.updateStatus(1, { status: 'UNDER_REVIEW' }, user)
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

    it('updateStatus throws 404 when application not found', async () => {
      mockRepo.updateStatus.mockResolvedValue(null);
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'] };
      const err = await service.updateStatus(999, { status: 'APPROVED' }, user)
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
    it('creates application + workflow init in single transaction', async () => {
      const mockClient = {};
      vi.mocked(withTransaction).mockImplementationOnce((fn: any) => fn(mockClient));
      mockRepo.generateApplicationNumber.mockResolvedValue('APP-2025-001');
      mockRepo.create.mockResolvedValue({ id: 100, application_number: 'APP-2025-001' });

      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'] };
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
      expect(mockWorkflow.initWorkflow).toHaveBeenCalledWith(
        'APP_REVIEW', 'Application', 100, mockClient
      );
      expect(broadcastDashboardEvent).toHaveBeenCalledWith('dashboard-stats', {});
      expect(result.id).toBe(100);
    });

    it('propagates error when workflow init fails (no orphan app)', async () => {
      const mockClient = {};
      vi.mocked(withTransaction).mockImplementationOnce((fn: any) => fn(mockClient));
      mockRepo.generateApplicationNumber.mockResolvedValue('APP-2025-002');
      mockRepo.create.mockResolvedValue({ id: 101 });
      mockWorkflow.initWorkflow.mockRejectedValue(new Error('Workflow engine error'));

      const user = { id: 27, uuid: '', institution_id: 1, username: 'researcher', email: 'r@test.com', status: 'ACTIVE', roles: ['RESEARCHER'] };
      const data = { project_id: 35, application_type: 'INITIAL', target_committee_id: 3 };

      await expect(service.create(data, user)).rejects.toThrow('Workflow engine error');
      expect(mockRepo.create).toHaveBeenCalled();
      expect(broadcastDashboardEvent).not.toHaveBeenCalled();
    });
  });

  describe('4. Input Validation: committeeDecision rejects invalid states', () => {
    it('throws 400 for invalid decision value', async () => {
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'] };
      const err = await service.committeeDecision(1, 'INVALID', undefined, user)
        .catch(e => e);
      expect(err.status).toBe(400);
      expect(err.message).toMatch(/invalid decision/i);
    });

    it('throws 400 when reviews still pending', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1 });
      mockRepo.countPendingReviews.mockResolvedValue(2);
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'] };

      const err = await service.committeeDecision(1, 'APPROVED', undefined, user)
        .catch(e => e);
      expect(err.status).toBe(400);
      expect(err.message).toMatch(/2 review/i);
    });

    it('creates notification on approved decision', async () => {
      mockRepo.findById.mockResolvedValue({ id: 1, submitted_by: 27, application_number: 'APP-2024-001' });
      mockRepo.countPendingReviews.mockResolvedValue(0);
      mockRepo.updateStatus.mockResolvedValue({ id: 1, current_status: 'APPROVED' });
      const user = { id: 22, uuid: '', institution_id: 1, username: 'admin', email: 'admin@test.com', status: 'ACTIVE', roles: ['ETHICS_ADMIN'] };

      await service.committeeDecision(1, 'APPROVED', 'Looks good', user);

      expect(createAndNotify).toHaveBeenCalledWith(
        27, 'APPLICATION_UPDATE',
        expect.stringContaining('APPROVED'),
        expect.stringContaining('Looks good'),
        'HIGH',
        expect.any(Object)
      );
    });
  });
});
