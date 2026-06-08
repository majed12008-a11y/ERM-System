import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';
import { PaginationParams } from '../shared/pagination';

export class UsersRepository extends AuditableRepository {
  async findAll(params: PaginationParams): Promise<{ rows: any[]; total: number }> {
    const countResult = await this.query('SELECT COUNT(*) FROM security.users');
    const total = parseInt(countResult.rows[0].count);

    const result = await this.query(
      `SELECT u.id, u.uuid, u.username, u.email, u.first_name_ar, u.last_name_ar,
              u.status, u.is_locked, u.is_email_verified, u.last_login_at, u.created_at,
              i.name_ar as institution_name,
              array_agg(r.code) as roles
       FROM security.users u
       LEFT JOIN security.institutions i ON u.institution_id = i.id
       LEFT JOIN security.user_roles ur ON ur.user_id = u.id
       LEFT JOIN security.roles r ON ur.role_id = r.id
       GROUP BY u.id, i.name_ar
       ORDER BY u.created_at DESC
       LIMIT $1 OFFSET $2`,
      [params.limit, (params.page - 1) * params.limit]
    );
    return { rows: result.rows, total };
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT u.id, u.uuid, u.username, u.email, u.first_name_ar, u.last_name_ar,
              u.first_name_en, u.last_name_en, u.mobile, u.status, u.is_locked,
              u.is_email_verified, u.last_login_at, u.created_at,
              i.name_ar as institution_name, d.name_ar as department_name
       FROM security.users u
       LEFT JOIN security.institutions i ON u.institution_id = i.id
       LEFT JOIN security.departments d ON u.department_id = d.id
       WHERE u.id = $1`,
      [id]
    );
    if (!result.rows[0]) return null;

    const rolesResult = await this.query(
      `SELECT r.id, r.code, r.name_ar
       FROM security.user_roles ur
       JOIN security.roles r ON ur.role_id = r.id
       WHERE ur.user_id = $1`,
      [id]
    );
    return { ...result.rows[0], roles: rolesResult.rows };
  }

  async checkExisting(username: string, email: string): Promise<boolean> {
    const result = await this.query(
      'SELECT id FROM security.users WHERE username = $1 OR email = $2',
      [username, email]
    );
    return result.rows.length > 0;
  }

  async create(data: {
    institution_id: number; department_id?: number;
    username: string; email: string; password_hash: string;
    first_name_ar?: string; last_name_ar?: string;
    first_name_en?: string; last_name_en?: string; mobile?: string;
  }, client?: PoolClient): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO security.users
        (institution_id, department_id, username, email, password_hash,
         first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
       RETURNING id, uuid, username, email`,
      [data.institution_id, data.department_id || null, data.username, data.email,
       data.password_hash, data.first_name_ar || '', data.last_name_ar || '',
       data.first_name_en || '', data.last_name_en || '', data.mobile || '',
       meta.created_by, meta.created_at],
      client
    );
    return result.rows[0];
  }

  async update(id: number, data: any): Promise<any | null> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE security.users SET
        email = COALESCE($1, email), first_name_ar = COALESCE($2, first_name_ar),
        last_name_ar = COALESCE($3, last_name_ar), first_name_en = COALESCE($4, first_name_en),
        last_name_en = COALESCE($5, last_name_en), mobile = COALESCE($6, mobile),
        institution_id = COALESCE($7::int, institution_id),
        department_id = COALESCE($8::int, department_id),
        status = COALESCE($9, status),
        updated_at = $10, updated_by = $11
       WHERE id = $12
       RETURNING id, uuid, username, email, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, status`,
      [data.email, data.first_name_ar, data.last_name_ar, data.first_name_en, data.last_name_en,
       data.mobile, data.institution_id, data.department_id, data.status,
       meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async setRoles(userId: number, roleCodes: string[], assignedBy: number) {
    await this.query('DELETE FROM security.user_roles WHERE user_id = $1', [userId]);
    if (roleCodes.length > 0) {
      const roles = await this.query('SELECT id, code FROM security.roles WHERE code = ANY($1)', [roleCodes]);
      for (const role of roles.rows) {
        await this.query(
          'INSERT INTO security.user_roles (user_id, role_id, assigned_by) VALUES ($1, $2, $3)',
          [userId, role.id, assignedBy]
        );
      }
    }
  }

  async assignRole(userId: number, roleId: number, assignedBy: number, client?: PoolClient) {
    await this.query(
      'INSERT INTO security.user_roles (user_id, role_id, assigned_by) VALUES ($1, $2, $3)',
      [userId, roleId, assignedBy],
      client
    );
  }

  // Profiles
  async getProfile(userId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT up.id, up.user_id, up.national_id, up.passport_number,
              up.gender, up.date_of_birth, up.nationality_code,
              up.academic_title, up.specialization, up.biography,
              up.created_at, up.updated_at
       FROM security.user_profiles up WHERE up.user_id = $1`,
      [userId]
    );
    return result.rows[0] || null;
  }

  async upsertProfile(userId: number, data: any): Promise<any> {
    const result = await this.query(
      `INSERT INTO security.user_profiles
        (user_id, national_id, passport_number, gender, date_of_birth, nationality_code, academic_title, specialization, biography)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       ON CONFLICT (user_id) DO UPDATE SET
         national_id = COALESCE($2, security.user_profiles.national_id),
         passport_number = COALESCE($3, security.user_profiles.passport_number),
         gender = COALESCE($4, security.user_profiles.gender),
         date_of_birth = COALESCE($5, security.user_profiles.date_of_birth),
         nationality_code = COALESCE($6, security.user_profiles.nationality_code),
         academic_title = COALESCE($7, security.user_profiles.academic_title),
         specialization = COALESCE($8, security.user_profiles.specialization),
         biography = COALESCE($9, security.user_profiles.biography),
         updated_at = now()
       RETURNING id, user_id`,
      [userId, data.national_id, data.passport_number, data.gender, data.date_of_birth,
       data.nationality_code, data.academic_title, data.specialization, data.biography]
    );
    return result.rows[0];
  }

  // Responsibilities
  async getResponsibilityTypes(): Promise<any[]> {
    const result = await this.query(
      'SELECT id, code, name_ar, name_en FROM security.responsibility_types WHERE is_active = true ORDER BY id'
    );
    return result.rows;
  }

  async getUserResponsibilities(userId: number | null, userRoles: string[]): Promise<any[]> {
    const isAdmin = userRoles.some((r: string) => ['SUPER_ADMIN','SYS_ADMIN','ADMIN','ETHICS_ADMIN'].includes(r));
    let where = '';
    const params: any[] = [];
    if (!isAdmin && userId) {
      where = 'WHERE ur.user_id = $1';
      params.push(userId);
    }
    const result = await this.query(
      `SELECT ur.*, rt.name_ar as responsibility_name, rt.code as responsibility_code
       FROM security.user_responsibilities ur
       JOIN security.responsibility_types rt ON ur.responsibility_type_id = rt.id
       ${where} ORDER BY ur.created_at DESC`,
      params
    );
    return result.rows;
  }

  async createResponsibility(data: any, assignedBy: number): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO security.user_responsibilities
        (user_id, responsibility_type_id, entity_type, entity_id, assigned_by, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [data.user_id, data.responsibility_type_id, data.entity_type, data.entity_id, assignedBy, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async deleteResponsibility(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE security.user_responsibilities SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }
}
