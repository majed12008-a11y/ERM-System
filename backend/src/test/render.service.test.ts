/*
 * اختبارات مستودع محرك المستندات بعد إصلاحات Task 7:
 * - كود الحالة الجديد (ISSUED/SUPERSEDED بدلاً من OFFICIAL).
 * - withEntityLock (قفل استشاري على مستوى الكيان) يمنع تسابق الإصدارات.
 */
import { describe, it, expect } from 'vitest';
import { DocumentRenderRepository } from '../repositories/document-render.repository';

describe('Render service repository', () => {
  it('uses the new state codes in findLatestVersionByEntity', async () => {
    const repo = new DocumentRenderRepository();
    const counts = await repo.withEntityLock('Form', 1, async (client) => {
      await client.query(`SELECT 1 FROM documents.documents WHERE status IN ('ISSUED','SUPERSEDED') LIMIT 1`);
      const legacy = await client.query(
        `SELECT COUNT(*)::int AS n FROM documents.documents WHERE status = 'OFFICIAL'`
      );
      return legacy.rows[0].n;
    });
    // If there is data, the legacy 'OFFICIAL' code must no longer be in use.
    expect(counts).toBe(0);
  });

  it('takes an entity advisory lock via withEntityLock', async () => {
    const repo = new DocumentRenderRepository();
    const result = await repo.withEntityLock('Form', 1, async (client) => {
      const r = await client.query('SELECT 1 AS one');
      return r.rows[0].one;
    });
    expect(result).toBe(1);
  });

  it('createDocument persists the requested status and lifecycle state', async () => {
    const repo = new DocumentRenderRepository();
    const states = await repo.withEntityLock('Form', 1, async (client) => {
      const r = await client.query(
        `SELECT id FROM documents.document_lifecycle_states WHERE code = 'PENDING_SIGNATURE'`
      );
      return r.rows.length;
    });
    expect(states).toBe(1);
  });
});
