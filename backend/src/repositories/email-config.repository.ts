/*
 * مستودع إعدادات البريد الإلكتروني: إدارة تكوينات
 * SMTP لإرسال رسائل البريد الإلكتروني.
 */
import { AuditableRepository } from './auditable.repository';

export interface EmailConfig {
  id?: number;
  config_name: string;
  smtp_host: string;
  smtp_port: number;
  smtp_username: string;
  smtp_password: string;
  use_tls: boolean;
  from_address: string;
  from_name: string;
  is_active: boolean;
}

export class EmailConfigRepository extends AuditableRepository {
  async findAll(): Promise<EmailConfig[]> {
    const result = await this.query(
      'SELECT * FROM system.email_config ORDER BY is_active DESC, id ASC'
    );
    return result.rows;
  }

  async findActive(): Promise<EmailConfig | null> {
    const result = await this.query(
      "SELECT * FROM system.email_config WHERE is_active = true LIMIT 1"
    );
    return result.rows[0] || null;
  }

  async findById(id: number): Promise<EmailConfig | null> {
    const result = await this.query(
      'SELECT * FROM system.email_config WHERE id = $1', [id]
    );
    return result.rows[0] || null;
  }

  async create(data: Omit<EmailConfig, 'id'>): Promise<EmailConfig> {
    const result = await this.query(
      `INSERT INTO system.email_config (config_name, smtp_host, smtp_port, smtp_username, smtp_password, use_tls, from_address, from_name, is_active)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING *`,
      [data.config_name, data.smtp_host, data.smtp_port, data.smtp_username, data.smtp_password, data.use_tls, data.from_address, data.from_name, data.is_active]
    );
    return result.rows[0];
  }

  async update(id: number, data: Partial<EmailConfig>): Promise<EmailConfig | null> {
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
      `UPDATE system.email_config SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );
    return result.rows[0] || null;
  }

  async delete(id: number): Promise<boolean> {
    const result = await this.query(
      'DELETE FROM system.email_config WHERE id = $1', [id]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async deactivateAll(): Promise<void> {
    await this.query(
      'UPDATE system.email_config SET is_active = false WHERE is_active = true'
    );
  }
}
