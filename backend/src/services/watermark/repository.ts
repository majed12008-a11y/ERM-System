/*
 * مستودع إعدادات العلامة المائية: يقرأ الإعدادات النشطة من
 * documents.document_watermark_config ويعيدها بصيغة معيارية (أرقام، شروط JSON).
 * القراءة تستخدم SELECT * لتكون متوافقة مع الأعمدة الجديدة (type, condition)
 * حتى لو لم يُطبق الترحيل الإضافي بعد.
 */
import { AuditableRepository } from '../../repositories/auditable.repository';
import type {
  WatermarkConfigRow,
  WatermarkCondition,
  WatermarkPosition,
} from './types';

const POSITION_VALUES: WatermarkPosition[] = [
  'CENTER', 'TOP_LEFT', 'TOP_RIGHT', 'BOTTOM_LEFT', 'BOTTOM_RIGHT',
];

export class WatermarkRepository extends AuditableRepository {
  async listActive(): Promise<WatermarkConfigRow[]> {
    const result = await this.query(
      `SELECT * FROM documents.document_watermark_config WHERE is_active = TRUE ORDER BY id`
    );
    return result.rows.map((row) => this.mapRow(row));
  }

  async findByCode(code: string): Promise<WatermarkConfigRow | null> {
    const result = await this.query(
      `SELECT * FROM documents.document_watermark_config WHERE code = $1 AND is_active = TRUE LIMIT 1`,
      [code]
    );
    return result.rows.length ? this.mapRow(result.rows[0]) : null;
  }

  private mapRow(row: any): WatermarkConfigRow {
    return {
      id: Number(row.id),
      code: String(row.code),
      text_ar: String(row.text_ar),
      text_en: row.text_en ? String(row.text_en) : '',
      font_family: row.font_family ? String(row.font_family) : 'Tahoma',
      font_size_pt: Number(row.font_size_pt),
      color: row.color ? String(row.color) : '#000000',
      opacity: Number(row.opacity),
      rotation_deg: Number(row.rotation_deg),
      position: this.parsePosition(row.position),
      is_active: Boolean(row.is_active),
      type: row.type ? String(row.type) : 'TEXT',
      condition: this.parseCondition(row.condition),
    };
  }

  private parsePosition(value: any): WatermarkPosition {
    const v = String(value).toUpperCase();
    return POSITION_VALUES.includes(v as WatermarkPosition) ? (v as WatermarkPosition) : 'CENTER';
  }

  private parseCondition(value: any): WatermarkCondition | null {
    if (!value) return null;
    let parsed = value;
    if (typeof parsed === 'string') {
      try {
        parsed = JSON.parse(parsed);
      } catch {
        return null;
      }
    }
    if (Array.isArray(parsed?.all)) {
      return { all: parsed.all };
    }
    return null;
  }
}
