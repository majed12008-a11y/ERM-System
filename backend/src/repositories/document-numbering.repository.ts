/*
 * مستودع ترقيم المستندات الرسمية:
 * تخصيص رقم تسلسلي ذري لكل فئة/سنة باستخدام قفل استشاري
 * (pg_advisory_xact_lock) لضمان عدم تكرار الأرقام عند التوازي.
 * رقم المستند بصيغة: PREFIX-YYYY-NNNN
 */
import { AuditableRepository } from './auditable.repository';

export interface AllocatedNumber {
  category: string;
  year: number;
  prefix: string;
  seq: number;
  number: string;
}

const DEFAULT_PREFIXES: Record<string, string> = {
  OFFICIAL_LETTER: 'DEC',
  REVIEW_FORM: 'RVW',
  MEETING_DOCUMENT: 'COM',
  CONSENT_DOCUMENT: 'ICF',
  SAFETY_REPORT: 'SAF',
  MONITORING_REPORT: 'MON',
  CLOSURE_REPORT: 'FIN',
};

export class DocumentNumberingRepository extends AuditableRepository {
  async allocate(category: string, year?: number): Promise<AllocatedNumber> {
    const targetYear = year || new Date().getFullYear();
    return this.withTransaction(async (client) => {
      await client.query(`SELECT pg_advisory_xact_lock(hashtext($1))`, [`docnum_${category}_${targetYear}`]);

      const existing = await client.query(
        `SELECT prefix, last_seq FROM documents.document_numbering WHERE category = $1 AND year = $2`,
        [category, targetYear]
      );

      let prefix: string;
      let seq: number;

      if (existing.rows.length === 0) {
        prefix = DEFAULT_PREFIXES[category] || 'DOC';
        seq = 1;
        await client.query(
          `INSERT INTO documents.document_numbering (category, year, prefix, last_seq)
           VALUES ($1, $2, $3, $4)`,
          [category, targetYear, prefix, seq]
        );
      } else {
        prefix = existing.rows[0].prefix;
        const updated = await client.query(
          `UPDATE documents.document_numbering
           SET last_seq = last_seq + 1
           WHERE category = $1 AND year = $2
           RETURNING last_seq`,
          [category, targetYear]
        );
        seq = parseInt(updated.rows[0].last_seq, 10);
      }

      return {
        category,
        year: targetYear,
        prefix,
        seq,
        number: `${prefix}-${targetYear}-${String(seq).padStart(4, '0')}`,
      };
    });
  }

  async getCurrent(category: string, year?: number): Promise<AllocatedNumber | null> {
    const targetYear = year || new Date().getFullYear();
    const result = await this.query(
      `SELECT category, year, prefix, last_seq FROM documents.document_numbering WHERE category = $1 AND year = $2`,
      [category, targetYear]
    );
    if (result.rows.length === 0) return null;
    const row = result.rows[0];
    return {
      category: row.category,
      year: row.year,
      prefix: row.prefix,
      seq: parseInt(row.last_seq, 10),
      number: `${row.prefix}-${row.year}-${String(row.last_seq).padStart(4, '0')}`,
    };
  }
}
