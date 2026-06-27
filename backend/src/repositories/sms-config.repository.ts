/*
 * مستودع إعدادات الرسائل النصية: إدارة تكوينات
 * إرسال الرسائل القصيرة (SMS).
 */
import { AuditableRepository } from './auditable.repository';

export interface SmsConfig {
  id?: number;
  config_name: string;
  provider: string;
  api_key?: string;
  api_secret?: string;
  sender_name?: string;
  is_active: boolean;
}

export class SmsConfigRepository extends AuditableRepository {
  async findAll(): Promise<SmsConfig[]> {
    const result = await this.query(
      'SELECT * FROM system.sms_config ORDER BY is_active DESC, id ASC'
    );
    return result.rows;
  }

  async findActive(): Promise<SmsConfig | null> {
    const result = await this.query(
      "SELECT * FROM system.sms_config WHERE is_active = true LIMIT 1"
    );
    return result.rows[0] || null;
  }

  async findById(id: number): Promise<SmsConfig | null> {
    const result = await this.query(
      'SELECT * FROM system.sms_config WHERE id = $1', [id]
    );
    return result.rows[0] || null;
  }

  async create(data: Omit<SmsConfig, 'id'>): Promise<SmsConfig> {
    const result = await this.query(
      `INSERT INTO system.sms_config (config_name, provider, api_key, api_secret, sender_name, is_active)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING *`,
      [data.config_name, data.provider, data.api_key || '', data.api_secret || '', data.sender_name || '', data.is_active]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<SmsConfig>): Promise<SmsConfig | null> {
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
      `UPDATE system.sms_config SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async delete(id: number): Promise<boolean> {
    const result = await this.query(
      'DELETE FROM system.sms_config WHERE id = $1', [id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async deactivateAll(): Promise<void> {
    await this.query(
      'UPDATE system.sms_config SET is_active = false WHERE is_active = true'
    );
  }
}
