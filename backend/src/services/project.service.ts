/*
 * إدارة المشاريع البحثية المرتبطة بطلبات البحث.
 * توفر دوال CRUD مع التحقق من الصلاحيات عبر RLS
 * ومعالجة حالة المشروع وسير العمل.
 */
import { ProjectRepository } from '../repositories/project.repository';
import { AuthUser } from '../shared/types';
import { PaginationParams, paginatedResult, PaginatedResult } from '../shared/pagination';
import { withTransaction } from '../config/database';

export class ProjectService {
  private repo = new ProjectRepository();

  async getAll(params: PaginationParams, user: AuthUser): Promise<PaginatedResult<any>> {
    const { rows, total } = await this.repo.findAll(params, user.id, user.roles);
    return paginatedResult(rows, total, params);
  }

  async getById(id: number): Promise<any> {
    const project = await this.repo.findById(id);
    if (!project) throw Object.assign(new Error('Project not found'), { status: 404 });
    return project;
  }

  async create(data: {
    title_ar: string; title_en?: string; abstract_ar?: string; abstract_en?: string;
    objectives?: string; research_category?: string; risk_level?: string;
    principal_investigator_id?: number; start_date?: string; expected_end_date?: string;
  }, user: AuthUser): Promise<any> {
    return withTransaction(async (client) => {
      const project_code = await this.repo.generateProjectCode(client);
      return this.repo.create({
        institution_id: user.institution_id,
        project_code,
        title_ar: data.title_ar,
        title_en: data.title_en,
        abstract_ar: data.abstract_ar,
        abstract_en: data.abstract_en,
        objectives: data.objectives,
        principal_investigator_id: data.principal_investigator_id || user.id,
        research_category: data.research_category,
        risk_level: data.risk_level,
        start_date: data.start_date,
        expected_end_date: data.expected_end_date,
      }, client);
    });
  }

  async getApplications(projectId: number): Promise<any[]> {
    return this.repo.getApplications(projectId);
  }

  async getStats(projectId: number): Promise<any[]> {
    return this.repo.getStats(projectId);
  }
}
