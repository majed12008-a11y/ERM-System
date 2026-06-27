/*
 * مستودع المشاريع البحثية: إدارة المشاريع المرتبطة
 * بطلبات البحث المعتمدة. يشمل CRUD مع ربط
 * بالفريق البحثي والموارد.
 */
import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';
import { IReadRepository, IWriteRepository, IPaginatedReadRepository } from './contracts';

export interface ProjectRow {
  id: number;
  institution_id: number;
  project_code: string;
  title_ar: string;
  title_en: string | null;
  abstract_ar: string | null;
  abstract_en: string | null;
  objectives: string | null;
  principal_investigator_id: number;
  research_category: string | null;
  risk_level: string | null;
  start_date: string | null;
  expected_end_date: string | null;
  current_status: string;
  created_at: Date;
}

export interface CreateProjectDTO {
  institution_id: number;
  project_code: string;
  title_ar: string;
  title_en?: string;
  abstract_ar?: string;
  abstract_en?: string;
  objectives?: string;
  principal_investigator_id: number;
  research_category?: string;
  risk_level?: string;
  start_date?: string;
  expected_end_date?: string;
}

export class ProjectRepository extends AuditableRepository
  implements IReadRepository<ProjectRow>, IPaginatedReadRepository<ProjectRow>, IWriteRepository<ProjectRow, CreateProjectDTO> {
  async findAll(
    params: PaginationParams,
    userId: number | null,
    userRoles: string[]
  ): Promise<{ rows: any[]; total: number }> {
    const adminRoles = ['SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'];
    const isAdmin = userRoles.some(r => adminRoles.includes(r));

    let whereClause = '';
    let countWhere = '';
    const queryParams: any[] = [params.limit, (params.page - 1) * params.limit];
    const countParams: any[] = [];
    let paramIdx = 3;

    if (!isAdmin && userId !== null) {
      whereClause = `WHERE p.principal_investigator_id = $${paramIdx}`;
      countWhere = 'WHERE p.principal_investigator_id = $1';
      queryParams.push(userId);
      countParams.push(userId);
    }

    const countResult = await this.query(
      `SELECT COUNT(*) FROM core.projects p ${countWhere}`, countParams
    );
    const total = parseInt(countResult.rows[0].count);

    const result = await this.query(
      `SELECT p.*, i.name_ar as institution_name, u.username as pi_username
       FROM core.projects p
       LEFT JOIN security.institutions i ON p.institution_id = i.id
       LEFT JOIN security.users u ON p.principal_investigator_id = u.id
       ${whereClause}
       ORDER BY p.created_at DESC
       LIMIT $1 OFFSET $2`,
      queryParams
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT p.*, i.name_ar as institution_name, u.username as pi_username
       FROM core.projects p
       LEFT JOIN security.institutions i ON p.institution_id = i.id
       LEFT JOIN security.users u ON p.principal_investigator_id = u.id
       WHERE p.id = $1`,
      [id]
    );
    return result.rows[0] || null;
  }

  async generateProjectCode(client: PoolClient): Promise<string> {
    const result = await this.query('SELECT system.fn_generate_project_code()', undefined, client);
    return result.rows[0].fn_generate_project_code;
  }

  async create(data: CreateProjectDTO, client: PoolClient): Promise<ProjectRow> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO core.projects
        (institution_id, project_code, title_ar, title_en, abstract_ar, abstract_en,
         objectives, principal_investigator_id, research_category, risk_level,
         start_date, expected_end_date, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14)
       RETURNING *`,
      [
        data.institution_id, data.project_code, data.title_ar, data.title_en || null,
        data.abstract_ar || null, data.abstract_en || null, data.objectives || null,
        data.principal_investigator_id, data.research_category || null,
        data.risk_level || null, data.start_date || null, data.expected_end_date || null,
        meta.created_by, meta.created_at,
      ],
      client
    );
    return result.rows[0];
  }

  async getApplications(projectId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT a.*, s.status_name_ar, cm.committee_name_ar as committee_name
       FROM core.applications a
       LEFT JOIN reference.application_statuses s ON a.current_status = s.status_code
       LEFT JOIN committee.committees cm ON a.target_committee_id = cm.id
       WHERE a.project_id = $1
       ORDER BY a.created_at DESC`,
      [projectId]
    );
    return result.rows;
  }

  async getStats(projectId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT current_status, COUNT(*)::int as count
       FROM core.applications WHERE project_id = $1
       GROUP BY current_status`,
      [projectId]
    );
    return result.rows;
  }
}
