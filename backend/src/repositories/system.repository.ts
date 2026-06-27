/*
 * مستودع خدمات النظام: عمليات البحث المحفوظة،
 * إعدادات المستخدمين، والخدمات العامة للنظام.
 */
import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';

export class SystemRepository extends AuditableRepository {
  async getSavedSearches(userId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM system.saved_searches
       WHERE user_id = $1 OR is_shared = true
       ORDER BY created_at DESC`,
      [userId]
    );
    return result.rows;
  }

  async createSavedSearch(data: {
    user_id: number; name: string; search_type: string;
    criteria: any; is_shared?: boolean;
  }, client?: PoolClient): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO system.saved_searches (user_id, search_name, entity_type, search_criteria, is_shared, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [data.user_id, data.name, data.search_type, JSON.stringify(data.criteria),
       data.is_shared ?? false, meta.created_by, meta.created_at],
      client
    );
    return result.rows[0];
  }

  async updateSavedSearch(
    id: number, userId: number,
    data: { name?: string; criteria?: any; is_shared?: boolean },
  ): Promise<any | null> {
    const sets: string[] = [];
    const values: any[] = [];
    let idx = 1;

    if (data.name !== undefined) { sets.push(`search_name = $${idx++}`); values.push(data.name); }
    if (data.criteria !== undefined) { sets.push(`search_criteria = $${idx++}`); values.push(JSON.stringify(data.criteria)); }
    if (data.is_shared !== undefined) { sets.push(`is_shared = $${idx++}`); values.push(data.is_shared); }
    if (sets.length === 0) return null;

    sets.push('updated_at = NOW()');
    values.push(id, userId);

    const result = await this.query(
      `UPDATE system.saved_searches SET ${sets.join(', ')} WHERE id = $${idx} AND user_id = $${idx + 1} RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async softDeleteSavedSearch(id: number, userId: number): Promise<boolean> {
    const result = await this.query(
      'UPDATE system.saved_searches SET is_shared = false WHERE id = $1 AND user_id = $2 RETURNING id',
      [id, userId]
    );
    return result.rows.length > 0;
  }

  async getConfig(): Promise<any[]> {
    const result = await this.query('SELECT * FROM system.system_config ORDER BY config_key');
    return result.rows;
  }
}
