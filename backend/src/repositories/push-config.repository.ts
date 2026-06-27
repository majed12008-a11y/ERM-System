/*
 * مستودع إعدادات الإشعارات الفورية: إدارة تكوينات
 * الإشعارات الفورية (Push Notifications).
 */
import { AuditableRepository } from './auditable.repository';

export interface PushConfig {
  id?: number;
  config_name: string;
  provider: string;
  server_key?: string;
  app_id?: string;
  is_active: boolean;
}

export class PushConfigRepository extends AuditableRepository {
  async findAll(): Promise<PushConfig[]> {
    const result = await this.query(
      'SELECT * FROM system.push_config ORDER BY is_active DESC, id ASC'
    );
    return result.rows;
  }

  async findActive(): Promise<PushConfig | null> {
    const result = await this.query(
      "SELECT * FROM system.push_config WHERE is_active = true LIMIT 1"
    );
    return result.rows[0] || null;
  }

  async findById(id: number): Promise<PushConfig | null> {
    const result = await this.query(
      'SELECT * FROM system.push_config WHERE id = $1', [id]
    );
    return result.rows[0] || null;
  }

  async create(data: Omit<PushConfig, 'id'>): Promise<PushConfig> {
    const result = await this.query(
      `INSERT INTO system.push_config (config_name, provider, server_key, app_id, is_active)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [data.config_name, data.provider, data.server_key || '', data.app_id || '', data.is_active]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<PushConfig>): Promise<PushConfig | null> {
    const fields: string[] = [];
    const values: any[] = [];
    let idx = 1;
    for (const [key, value] of Object.entries(data)) {
      if (key === 'id') continue;
      fields.push(`${key} = $${idx++}`);
      values.push(value);
    }
    if (fields.length === 0) return this.findById(id);
    values.push(id);
    const result = await this.query(
      `UPDATE system.push_config SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async delete(id: number): Promise<boolean> {
    const result = await this.query(
      'DELETE FROM system.push_config WHERE id = $1', [id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async deactivateAll(): Promise<void> {
    await this.query(
      'UPDATE system.push_config SET is_active = false WHERE is_active = true'
    );
  }
}
