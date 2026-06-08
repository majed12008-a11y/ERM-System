import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';
import { ApplicationRow } from '../shared/db-types';
import { PaginationParams } from '../shared/pagination';
import { IReadRepository, IWriteRepository, IPaginatedReadRepository, ISoftDeleteRepository } from './contracts';

export interface CreateApplicationDTO {
  application_number: string;
  project_id: number;
  application_type: string;
  submitted_by: number;
  target_committee_id: number;
}

export class ApplicationRepository extends AuditableRepository
  implements IReadRepository<ApplicationRow>, IPaginatedReadRepository<ApplicationRow>, IWriteRepository<ApplicationRow, CreateApplicationDTO>, ISoftDeleteRepository {
  async findAll(
    params: PaginationParams,
    userId: number | null,
    userRoles: string[],
    status?: string
  ): Promise<{ rows: ApplicationRow[]; total: number }> {
    const adminRoles = ['SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'];
    const isAdmin = userRoles.some(r => adminRoles.includes(r));

    let whereClause = '';
    let countWhere = '';
    const queryParams: any[] = [params.limit, (params.page - 1) * params.limit];
    const countParams: any[] = [];
    let paramIdx = 3;

    if (!isAdmin && userId !== null) {
      whereClause = `WHERE a.submitted_by = $${paramIdx}`;
      countWhere = 'WHERE a.submitted_by = $1';
      queryParams.push(userId);
      countParams.push(userId);
      paramIdx++;
    }

    if (status) {
      const clause = ` a.current_status = $${paramIdx}`;
      whereClause += whereClause ? ' AND' : 'WHERE';
      whereClause += clause;
      const countClause = ` a.current_status = $${countParams.length + 1}`;
      countWhere += countWhere ? ' AND' : 'WHERE';
      countWhere += countClause;
      queryParams.push(status);
      countParams.push(status);
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM core.applications a ${countWhere}`,
      countParams
    );
    const total = parseInt(countResult.rows[0].count);

    const result = await this.query(
      `SELECT a.*, p.title_ar as project_title, p.project_code,
              u.username as submitted_by_username, s.status_name_ar
       FROM core.applications a
       LEFT JOIN core.projects p ON a.project_id = p.id
       LEFT JOIN security.users u ON a.submitted_by = u.id
       LEFT JOIN reference.application_statuses s ON a.current_status = s.status_code
       ${whereClause}
       ORDER BY a.created_at DESC
       LIMIT $1 OFFSET $2`,
      queryParams
    );

    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<ApplicationRow | null> {
    const result = await this.query(
      `SELECT a.*,
              p.title_ar as project_title, p.title_en as project_title_en,
              p.project_code, p.research_category, p.risk_level as project_risk_level,
              p.objectives as project_objectives,
              u.username as submitted_by_username, u.email as submitted_by_email,
              s.status_name_ar,
              cm.committee_name_ar as committee_name
       FROM core.applications a
       LEFT JOIN core.projects p ON a.project_id = p.id
       LEFT JOIN security.users u ON a.submitted_by = u.id
       LEFT JOIN reference.application_statuses s ON a.current_status = s.status_code
       LEFT JOIN committee.committees cm ON a.target_committee_id = cm.id
       WHERE a.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async create(data: CreateApplicationDTO, client: PoolClient): Promise<ApplicationRow> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO core.applications
        (application_number, project_id, application_type, submitted_by, target_committee_id, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING *`,
      [
        data.application_number,
        data.project_id,
        data.application_type,
        data.submitted_by,
        data.target_committee_id,
        meta.created_by,
        meta.created_at,
      ],
      client
    );
    return result.rows[0];
  }

  async generateApplicationNumber(client: PoolClient): Promise<string> {
    const result = await this.query('SELECT system.fn_generate_application_number()', undefined, client);
    return result.rows[0].fn_generate_application_number;
  }

  async countPendingReviews(applicationId: number): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(*)::int as cnt FROM committee.review_assignments
       WHERE application_id = $1 AND (status_code IS NULL OR status_code != 'COMPLETED')`,
      [applicationId]
    );
    return result.rows[0].cnt;
  }

  async setApplicationUnderReview(id: number): Promise<void> {
    await this.query(
      `UPDATE core.applications SET current_status = 'UNDER_REVIEW' WHERE id = $1 AND current_status = 'SUBMITTED'`,
      [id]
    );
  }

  async updateStatus(id: number, status: string, client?: PoolClient): Promise<ApplicationRow | null> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE core.applications SET current_status = $1, updated_at = $2, updated_by = $3 WHERE id = $4 RETURNING *`,
      [status, meta.updated_at, meta.updated_by, id],
      client
    );
    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE core.applications SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }
}
