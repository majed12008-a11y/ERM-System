/*
 * التحقق من الصلاحيات والأذونات للمستخدمين.
 * يتحقق من صلاحية المستخدم للوصول إلى موارد محددة
 * بناءً على الأدوار والأذونات الممنوحة.
 */
import { AuthorizationRepository } from '../repositories/authorization.repository';

export class AuthorizationService {
  private repo = new AuthorizationRepository();

  async getRoles() { return this.repo.getRoles(); }
  async getRole(id: number) {
    const role = await this.repo.getRole(id);
    if (!role) throw Object.assign(new Error('Role not found'), { status: 404 });
    return role;
  }
  async createRole(data: any) { return this.repo.createRole(data); }
  async updateRole(id: number, data: any) {
    const result = await this.repo.updateRole(id, data);
    if (!result) throw Object.assign(new Error('Role not found'), { status: 404 });
    return result;
  }
  async getPermissions() { return this.repo.getPermissions(); }
  async createPermission(data: any) { return this.repo.createPermission(data); }
  async deletePermission(id: number) {
    const ok = await this.repo.deletePermission(id);
    if (!ok) throw Object.assign(new Error('Permission not found'), { status: 404 });
  }
  async getRolePermissions(roleId: number) { return this.repo.getRolePermissions(roleId); }
  async setRolePermissions(roleId: number, permissionIds: number[]) {
    await this.repo.setRolePermissions(roleId, permissionIds);
  }
}
