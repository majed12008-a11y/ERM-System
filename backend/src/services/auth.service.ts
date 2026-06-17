import * as argon2 from 'argon2';
import { jwtVerify } from 'jose';
import { AuthRepository } from '../repositories/auth.repository';
import { UsersRepository } from '../repositories/users.repository';
import { AuthUser } from '../shared/types';
import { generateTokens, signToken } from '../middleware/auth';
import { env } from '../config/env';
import { withTransaction } from '../config/database';

const MAX_FAILED_ATTEMPTS = 5;
const LOCK_DURATION_MINUTES = 15;
const PASSWORD_HISTORY_CHECK = 5;
const PASSWORD_MIN_LENGTH = 8;

export class AuthService {
  private repo = new AuthRepository();

  private validatePasswordStrength(password: string): string | null {
    if (password.length < PASSWORD_MIN_LENGTH) return `Password must be at least ${PASSWORD_MIN_LENGTH} characters`;
    if (!/[A-Z]/.test(password)) return 'Password must contain an uppercase letter';
    if (!/[a-z]/.test(password)) return 'Password must contain a lowercase letter';
    if (!/[0-9]/.test(password)) return 'Password must contain a number';
    if (!/[!@#$%^&*()_+\-=[\]{};':"\\|,.<>/?]/.test(password)) return 'Password must contain a special character';
    return null;
  }

  async login(username: string, password: string, ip: string, userAgent: string = '') {
    const user = await this.repo.authenticate(username);
    if (!user) {
      await this.repo.logLoginAttempt(username, null, false, ip, 'User not found');
      throw Object.assign(new Error('Invalid credentials'), { status: 401 });
    }

    if (user.is_locked) {
      const attempts = await this.repo.getRecentFailedAttempts(user.id, LOCK_DURATION_MINUTES);
      if (attempts >= MAX_FAILED_ATTEMPTS) {
        throw Object.assign(new Error('Account locked due to repeated failures. Try again later.'), { status: 423 });
      }
      await this.repo.unlockIfResolved(user.id);
    }

    if (user.status !== 'ACTIVE') {
      throw Object.assign(new Error('Account is not active'), { status: 403 });
    }

    const valid = await argon2.verify(user.password_hash, password);
    if (!valid) {
      await this.repo.logLoginAttempt(username, user.id, false, ip, 'Invalid password');
      const failCount = await this.repo.getRecentFailedAttempts(user.id, LOCK_DURATION_MINUTES);
      if (failCount >= MAX_FAILED_ATTEMPTS) {
        await this.repo.lockAccount(user.id, ip, MAX_FAILED_ATTEMPTS);
        throw Object.assign(new Error(`Account locked due to ${MAX_FAILED_ATTEMPTS} failed attempts. Try again later.`), { status: 423 });
      }
      throw Object.assign(new Error(`Invalid credentials (${failCount}/${MAX_FAILED_ATTEMPTS})`), { status: 401 });
    }

    await this.repo.logLoginAttempt(username, user.id, true, ip);
    await this.repo.updateLoginSuccess(user.id);

    const sessionToken = await this.repo.createSession(user.id, ip, userAgent);
    const { accessToken, refreshToken } = await generateTokens(user.id, sessionToken);

    return { accessToken, refreshToken, userId: user.id };
  }

  async logout(userId: number) {
    await this.repo.revokeAllSessions(userId);
  }

  async refresh(refreshToken: string) {
    const secret = new TextEncoder().encode(env.JWT_SECRET);

    let payload: { userId: number; type?: string; jti?: string };
    try {
      const result = await jwtVerify(refreshToken, secret);
      payload = result.payload as unknown as { userId: number; type?: string; jti?: string };
      if (payload.type !== 'refresh') throw new Error('Invalid token type');
    } catch {
      throw Object.assign(new Error('Invalid or expired refresh token'), { status: 401 });
    }

    const session = await this.repo.findValidSession(payload.userId, payload.jti);
    if (!session) throw Object.assign(new Error('Session expired or revoked'), { status: 401 });

    const active = await this.repo.checkUserActive(payload.userId);
    if (!active) throw Object.assign(new Error('User not found or inactive'), { status: 401 });

    const accessToken = await signToken(payload.userId);
    return { accessToken };
  }

  async getMe(user: AuthUser) {
    const permissions = await this.repo.getPermissions(user.id);
    return {
      id: user.id, uuid: user.uuid, username: user.username, email: user.email,
      institution_id: user.institution_id, roles: user.roles, permissions,
    };
  }

  async changePassword(userId: number, oldPassword: string, newPassword: string) {
    if (!oldPassword || !newPassword) {
      throw Object.assign(new Error('Old and new password required'), { status: 400 });
    }

    const strengthError = this.validatePasswordStrength(newPassword);
    if (strengthError) throw Object.assign(new Error(strengthError), { status: 400 });

    const hash = await this.repo.getPasswordHash(userId);
    const valid = await argon2.verify(hash!, oldPassword);
    if (!valid) throw Object.assign(new Error('Current password is incorrect'), { status: 400 });

    const recentHashes = await this.repo.getRecentPasswordHashes(userId, PASSWORD_HISTORY_CHECK);
    for (const h of recentHashes) {
      if (await argon2.verify(h, newPassword)) {
        throw Object.assign(new Error('Password has been used recently. Choose a different one.'), { status: 400 });
      }
    }

    const newHash = await argon2.hash(newPassword);
    await this.repo.updatePassword(userId, newHash);
    await this.repo.revokeAllSessions(userId);
  }

  async register(data: {
    username: string; email: string; password: string;
    first_name_ar?: string; last_name_ar?: string;
    first_name_en?: string; last_name_en?: string; mobile?: string;
    institution_id: number;
  }) {
    if (!/[A-Z]/.test(data.password) || !/[a-z]/.test(data.password) || !/[0-9]/.test(data.password)) {
      throw Object.assign(new Error('Password must contain uppercase, lowercase, and number'), { status: 400 });
    }

    const exists = await this.repo.checkExistingUser(data.username, data.email);
    if (exists) throw Object.assign(new Error('Username or email already exists'), { status: 409 });

    const password_hash = await argon2.hash(data.password);
    const userRepo = new UsersRepository();

    const user = await withTransaction(async (client) => {
      const newUser = await userRepo.create({
        institution_id: data.institution_id,
        username: data.username,
        email: data.email,
        password_hash,
        first_name_ar: data.first_name_ar,
        last_name_ar: data.last_name_ar,
        first_name_en: data.first_name_en,
        last_name_en: data.last_name_en,
        mobile: data.mobile,
      }, client);

      const role = await this.repo.getRoleByCode('RESEARCHER', client);
      if (role) {
        await userRepo.assignRole(newUser.id, role.id, newUser.id, client);
      }

      return newUser;
    });

    return { userId: user.id, username: user.username, email: user.email };
  }
}
