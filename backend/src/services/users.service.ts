import * as argon2 from 'argon2';
import { UsersRepository } from '../repositories/users.repository';
import { AuthUser } from '../shared/types';
import { PaginationParams } from '../shared/pagination';
import { encrypt, decrypt } from '../shared/crypto';

export class UsersService {
  private repo = new UsersRepository();

  async getAll(params: PaginationParams) {
    const { rows, total } = await this.repo.findAll(params);
    return {
      data: rows,
      pagination: { page: params.page, limit: params.limit, total, totalPages: Math.ceil(total / params.limit) },
    };
  }

  async getById(id: number) {
    const user = await this.repo.findById(id);
    if (!user) throw Object.assign(new Error('User not found'), { status: 404 });
    return user;
  }

  async create(data: any, currentUser: AuthUser) {
    if (!data.password || data.password.length < 8 || !/[A-Z]/.test(data.password) || !/[a-z]/.test(data.password) || !/[0-9]/.test(data.password)) {
      throw Object.assign(new Error('Password must be at least 8 characters with uppercase, lowercase, and number'), { status: 400 });
    }

    const exists = await this.repo.checkExisting(data.username, data.email);
    if (exists) throw Object.assign(new Error('Username or email already exists'), { status: 409 });

    const password_hash = await argon2.hash(data.password);
    const user = await this.repo.create({ ...data, password_hash });

    if (data.role_codes && data.role_codes.length > 0) {
      await this.repo.setRoles(user.id, data.role_codes, currentUser.id);
    }

    return user;
  }

  async update(id: number, data: any, currentUser: AuthUser) {
    const user = await this.repo.update(id, data);
    if (!user) throw Object.assign(new Error('User not found'), { status: 404 });

    if (data.role_codes && data.role_codes.length > 0) {
      await this.repo.setRoles(id, data.role_codes, currentUser.id);
    }

    return user;
  }

  async getProfile(userId: number, isAdmin: boolean) {
    const profile = await this.repo.getProfile(userId);
    if (!profile) return null;
    if (profile.national_id) profile.national_id = decrypt(profile.national_id);
    if (profile.passport_number) profile.passport_number = decrypt(profile.passport_number);
    return profile;
  }

  async upsertProfile(userId: number, data: any) {
    const encrypted: any = { ...data };
    if (data.national_id) encrypted.national_id = encrypt(data.national_id);
    if (data.passport_number) encrypted.passport_number = encrypt(data.passport_number);
    return this.repo.upsertProfile(userId, encrypted);
  }

  async getResponsibilityTypes() { return this.repo.getResponsibilityTypes(); }

  async getUserResponsibilities(user: AuthUser) {
    return this.repo.getUserResponsibilities(user.id, user.roles);
  }

  async createResponsibility(data: any, user: AuthUser) {
    return this.repo.createResponsibility(data, user.id);
  }

  async deleteResponsibility(id: number) {
    const ok = await this.repo.deleteResponsibility(id);
    if (!ok) throw Object.assign(new Error('Responsibility not found'), { status: 404 });
  }
}
