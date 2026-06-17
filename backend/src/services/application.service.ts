import { ApplicationRepository } from '../repositories/application.repository';
import { ApplicationRow } from '../shared/db-types';
import { AuthUser } from '../shared/types';
import { PaginationParams, paginatedResult, PaginatedResult } from '../shared/pagination';
import { createAndNotify, broadcastDashboardEvent } from './notification.service';
import { WorkflowService } from './workflow.service';
import { withTransaction } from '../config/database';

export class ApplicationService {
  constructor(
    private repo = new ApplicationRepository(),
    private workflow = new WorkflowService()
  ) {}

  async getAll(
    params: PaginationParams,
    user: AuthUser,
    status?: string
  ): Promise<PaginatedResult<ApplicationRow>> {
    const { rows, total } = await this.repo.findAll(
      params,
      user.id,
      user.roles,
      status
    );
    return paginatedResult(rows, total, params);
  }

  async getById(id: number): Promise<ApplicationRow> {
    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }
    return app;
  }

  async create(data: {
    project_id: number;
    application_type: string;
    target_committee_id: number;
  }, user: AuthUser): Promise<ApplicationRow> {
    const app = await withTransaction(async (client) => {
      const applicationNumber = await this.repo.generateApplicationNumber(client);

      const newApp = await this.repo.create({
        application_number: applicationNumber,
        project_id: data.project_id,
        application_type: data.application_type,
        submitted_by: user.id,
        target_committee_id: data.target_committee_id,
      }, client);

      await this.workflow.initWorkflow('APP_REVIEW_V1', 'Application', newApp.id, client);

      return newApp;
    });

    broadcastDashboardEvent('dashboard-stats', {});

    return app;
  }

  async updateStatus(
    id: number,
    body: { status?: string; transition_code?: string; comment?: string },
    user: AuthUser
  ): Promise<ApplicationRow> {
    const userRoles: string[] = user.roles;

    if (body.transition_code) {
      const result = await this.workflow.executeTransition(
        'Application', id, body.transition_code, user, body.comment
      );

      const updated = await this.repo.updateStatus(id, result.to_state);
      if (!updated) {
        const err = new Error('Application not found') as any;
        err.status = 404;
        throw err;
      }
      broadcastDashboardEvent('dashboard-stats', {});
      return updated;
    }

    if (!userRoles.some((r: string) => ['ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'].includes(r))) {
      const err = new Error('Not authorized') as any;
      err.status = 403;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const updated = await this.repo.updateStatus(id, body.status!, client);
      if (!updated) {
        const err = new Error('Application not found') as any;
        err.status = 404;
        throw err;
      }

      await this.workflow.autoTransition('Application', id, user.id, client);
      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});
    return updated;
  }

  async committeeDecision(
    id: number,
    decision: string,
    notes: string | undefined,
    user: AuthUser
  ): Promise<ApplicationRow> {
    const validDecisions = ['APPROVED', 'REJECTED', 'CONDITIONAL'];
    if (!validDecisions.includes(decision)) {
      const err = new Error('Invalid decision. Must be APPROVED, REJECTED, or CONDITIONAL') as any;
      err.status = 400;
      throw err;
    }

    const app = await this.repo.findById(id);
    if (!app) {
      const err = new Error('Application not found') as any;
      err.status = 404;
      throw err;
    }

    const pending = await this.repo.countPendingReviews(id);
    if (pending > 0) {
      const err = new Error(`${pending} review(s) still pending`) as any;
      err.status = 400;
      throw err;
    }

    const updated = await withTransaction(async (client) => {
      const updated = await this.repo.updateStatus(id, decision, client);
      if (!updated) {
        const err = new Error('Application not found') as any;
        err.status = 404;
        throw err;
      }

      await this.workflow.autoTransition('Application', id, user.id, client);

      await createAndNotify(
        app.submitted_by,
        'APPLICATION_UPDATE',
        `Application ${app.application_number}: ${decision}`,
        `Your application ${app.application_number} was ${decision}${notes ? '. Notes: ' + notes : ''}`,
        decision === 'APPROVED' ? 'HIGH' : 'MEDIUM',
        client
      );

      return updated;
    });

    broadcastDashboardEvent('dashboard-stats', {});

    return updated;
  }

  async softDelete(id: number): Promise<void> {
    const deleted = await this.repo.softDelete(id);
    if (!deleted) {
      const err = new Error('Application not found or already deleted') as any;
      err.status = 404;
      throw err;
    }
  }

}
