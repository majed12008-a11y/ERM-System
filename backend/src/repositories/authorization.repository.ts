/*
 * مستودع الصلاحيات: إدارة الأدوار والأذونات.
 * يوفر دوال للتحقق من صلاحيات المستخدمين
 * وإدارة تعيين الأدوار.
 */
import { AuditableRepository } from './auditable.repository';

export class AuthorizationRepository extends AuditableRepository {
  async getRoles(): Promise<any[]> {
    const result = await this.query(
      `SELECT r.id, r.code, r.name_ar, r.name_en, r.description, r.is_system_role, r.is_active,
              COALESCE(json_agg(json_build_object('id', p.id, 'permission_code', p.permission_code))
                FILTER (WHERE p.id IS NOT NULL), '[]') as permissions
       FROM security.roles r
       LEFT JOIN security.role_permissions rp ON rp.role_id = r.id
       LEFT JOIN security.permissions p ON rp.permission_id = p.id
       GROUP BY r.id ORDER BY r.id`
    );
    return result.rows;
  }

  async getRole(id: number): Promise<any | null> {
    const roleResult = await this.query(
      'SELECT id, code, name_ar, name_en, description, is_system_role, is_active FROM security.roles WHERE id = $1',
      [id]
    );
    if (!roleResult.rows[0]) return null;

    const permResult = await this.query(
      `SELECT p.id, p.permission_code, p.module_name, p.action_name
       FROM security.role_permissions rp
       JOIN security.permissions p ON rp.permission_id = p.id
       WHERE rp.role_id = $1`,
      [id]
    );
    return { ...roleResult.rows[0], permissions: permResult.rows };
  }

  async createRole(data: { code: string; name_ar: string; name_en?: string; description?: string }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO security.roles (code, name_ar, name_en, description, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING id, code, name_ar`,
      [data.code, data.name_ar, data.name_en || null, data.description || null, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async updateRole(id: number, data: any): Promise<any | null> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE security.roles SET
        name_ar = COALESCE($1, name_ar), name_en = COALESCE($2, name_en),
        description = COALESCE($3, description), is_active = COALESCE($4, is_active),
        updated_at = $5, updated_by = $6
       WHERE id = $7 RETURNING id, code, name_ar, is_active`,
      [data.name_ar, data.name_en, data.description, data.is_active, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async getPermissions(): Promise<any[]> {
    const result = await this.query(
      'SELECT id, permission_code, module_name, action_name, description FROM security.permissions ORDER BY module_name, permission_code'
    );
    return result.rows;
  }

  async createPermission(data: { permission_code: string; module_name: string; action_name: string; description?: string }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO security.permissions (permission_code, module_name, action_name, description, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING id, permission_code`,
      [data.permission_code, data.module_name, data.action_name, data.description || null, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async deletePermission(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE security.permissions SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async getRolePermissions(roleId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT p.id, p.permission_code, p.module_name, p.action_name,
              CASE WHEN rp.role_id IS NOT NULL THEN true ELSE false END as granted
       FROM security.permissions p
       LEFT JOIN security.role_permissions rp ON rp.permission_id = p.id AND rp.role_id = $1
       ORDER BY p.module_name, p.permission_code`,
      [roleId]
    );
    return result.rows;
  }

  async setRolePermissions(roleId: number, permissionIds: number[]) {
    const meta = this.updateMeta();
    await this.query('DELETE FROM security.role_permissions WHERE role_id = $1', [roleId]);
    if (permissionIds.length > 0) {
      const values = permissionIds.map((_: any, i: number) => `($1, $${i + 2})`).join(', ');
      await this.query(
        `INSERT INTO security.role_permissions (role_id, permission_id) VALUES ${values}`,
        [roleId, ...permissionIds]
      );
    }
  }
}
