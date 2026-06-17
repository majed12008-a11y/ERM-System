import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';

export class AuthRepository extends AuditableRepository {
  async authenticate(username: string, client?: PoolClient): Promise<any | null> {
    const result = await this.query(
      'SELECT v_id as id, v_password_hash as password_hash, v_status as status, v_is_locked as is_locked FROM security.fn_authenticate($1)',
      [username],
      client
    );
    return result.rows[0] || null;
  }

  async logLoginAttempt(username: string, userId: number | null, success: boolean, ip: string, reason?: string) {
    await this.query(
      `INSERT INTO security.login_audit (user_id, username_attempt, success, failure_reason, ip_address)
       VALUES ($1, $2, $3, $4, $5::inet)`,
      [userId, username, success, reason || null, ip]
    );
  }

  async getRecentFailedAttempts(userId: number, minutes: number): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(*)::int as attempts FROM security.login_audit
       WHERE user_id = $1 AND success = false AND login_time > now() - make_interval(mins => $2)`,
      [userId, minutes]
    );
    return result.rows[0].attempts;
  }

  async lockAccount(userId: number, ip: string, maxAttempts: number) {
    await this.query('UPDATE security.users SET is_locked = true WHERE id = $1', [userId]);
    await this.query(
      `INSERT INTO security.security_events (event_type, severity, user_id, source_ip, details)
       VALUES ($1, $2, $3, $4::inet, $5::jsonb)`,
      ['ACCOUNT_LOCKED', 'HIGH', userId, ip, JSON.stringify({ reason: `Exceeded ${maxAttempts} failed attempts` })]
    );
  }

  async unlockIfResolved(userId: number) {
    await this.query('UPDATE security.users SET is_locked = false WHERE id = $1', [userId]);
  }

  async updateLoginSuccess(userId: number) {
    await this.query('UPDATE security.users SET last_login_at = now(), is_locked = false WHERE id = $1', [userId]);
  }

  async createSession(userId: number, ip: string, userAgent: string): Promise<string> {
    const result = await this.query(
      `INSERT INTO security.sessions (user_id, login_at, expires_at, ip_address, user_agent)
       VALUES ($1, now(), now() + interval '7 days', $2::inet, $3)
       RETURNING session_token`,
      [userId, ip, userAgent]
    );
    return result.rows[0]?.session_token;
  }

  async revokeAllSessions(userId: number) {
    await this.query(
      `UPDATE security.sessions SET revoked_at = now() WHERE user_id = $1 AND revoked_at IS NULL`,
      [userId]
    );
  }

  async findValidSession(userId: number, sessionToken?: string): Promise<any | null> {
    const result = await this.query(
      `SELECT id, session_token FROM security.sessions
       WHERE user_id = $1 AND revoked_at IS NULL AND expires_at > now()
       ${sessionToken ? 'AND session_token = $2::uuid' : ''}
       ORDER BY login_at DESC LIMIT 1`,
      sessionToken ? [userId, sessionToken] : [userId]
    );
    return result.rows[0] || null;
  }

  async checkUserActive(userId: number): Promise<boolean> {
    const result = await this.query(
      'SELECT id FROM security.users WHERE id = $1 AND status = \'ACTIVE\'',
      [userId]
    );
    return result.rows.length > 0;
  }

  async checkExistingUser(username: string, email: string, client?: PoolClient): Promise<boolean> {
    const result = await this.query(
      'SELECT id FROM security.users WHERE username = $1 OR email = $2',
      [username, email],
      client
    );
    return result.rows.length > 0;
  }

  async getPasswordHash(userId: number): Promise<string | null> {
    const result = await this.query('SELECT password_hash FROM security.users WHERE id = $1', [userId]);
    return result.rows[0]?.password_hash || null;
  }

  async getRecentPasswordHashes(userId: number, limit: number): Promise<string[]> {
    const result = await this.query(
      `SELECT password_hash FROM security.password_history WHERE user_id = $1 ORDER BY changed_at DESC LIMIT $2`,
      [userId, limit]
    );
    return result.rows.map((r: any) => r.password_hash);
  }

  async updatePassword(userId: number, hash: string) {
    await this.query('UPDATE security.users SET password_hash = $1 WHERE id = $2', [hash, userId]);
    await this.query('INSERT INTO security.password_history (user_id, password_hash) VALUES ($1, $2)', [userId, hash]);
  }

  async getPermissions(userId: number): Promise<string[]> {
    const result = await this.query(
      `SELECT DISTINCT p.permission_code
       FROM security.role_permissions rp
       JOIN security.user_roles ur ON ur.role_id = rp.role_id
       JOIN security.permissions p ON rp.permission_id = p.id
       WHERE ur.user_id = $1`,
      [userId]
    );
    return result.rows.map((r: any) => r.permission_code);
  }

  async getRoleByCode(code: string, client?: PoolClient): Promise<any | null> {
    const result = await this.query('SELECT id FROM security.roles WHERE code = $1', [code], client);
    return result.rows[0] || null;
  }

  async findUserByEmail(email: string): Promise<{ id: number; username: string; email: string } | null> {
    const result = await this.query(
      'SELECT id, username, email FROM security.users WHERE email = $1 AND status = \'ACTIVE\'',
      [email]
    );
    return result.rows[0] || null;
  }

  async saveResetToken(userId: number, tokenHash: string, expiresAt: Date): Promise<void> {
    await this.query(
      `INSERT INTO security.password_reset_tokens (user_id, token_hash, expires_at)
       VALUES ($1, $2, $3)`,
      [userId, tokenHash, expiresAt.toISOString()]
    );
  }

  async findValidResetToken(tokenHash: string): Promise<{ id: number; user_id: number; expires_at: Date } | null> {
    const result = await this.query(
      `SELECT id, user_id, expires_at FROM security.password_reset_tokens
       WHERE token_hash = $1 AND used_at IS NULL AND expires_at > now()`,
      [tokenHash]
    );
    return result.rows[0] || null;
  }

  async resetPasswordWithToken(tokenHash: string, passwordHash: string): Promise<boolean> {
    const result = await this.query(
      'SELECT security.fn_reset_password($1, $2)',
      [tokenHash, passwordHash]
    );
    return result.rows[0]?.fn_reset_password === true;
  }
}
