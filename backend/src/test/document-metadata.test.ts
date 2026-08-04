/*
 * اختبارات Task 8: بيانات المستند الوصفية — التصنيف، السرية،
 * سياسات الاحتفاظ، العلامات، والبيانات الوصفية الحرة، بالإضافة
 * إلى فحص انتهاء الصلاحية الكسول (lazy expiry).
 */
import { describe, it, expect } from 'vitest';
import { DocumentRepository } from '../repositories/document.repository';
import { DocumentLifecycleService } from '../services/document-lifecycle.service';

describe('Document metadata', () => {
  it('lists retention rules', async () => {
    const repo = new DocumentRepository();
    const rules = await repo.listRetentionRules();
    expect(Array.isArray(rules)).toBe(true);
  });

  it('updates metadata on a document', async () => {
    const repo = new DocumentRepository();
    const { rows } = await repo.findAll({ page: 1, limit: 1 });
    if (rows.length === 0) return;
    const id = Number(rows[0].id);
    const updated = await repo.updateMetadata(id, {
      tags: ['urgent'],
      metadata: { source: 'test' },
      confidentiality_level: 'CONFIDENTIAL',
    }, 1);
    expect(updated.tags).toContain('urgent');
    expect(updated.confidentiality_level).toBe('CONFIDENTIAL');
  });

  it('lazy expiry returns not-expired for an unknown document', async () => {
    const service = new DocumentLifecycleService();
    const user = { id: 1, uuid: '', institution_id: 1, username: 'tester', email: '', status: 'ACTIVE', is_email_verified: true, roles: ['ADMIN'] };
    const result = await service.checkExpiry(999999999, user);
    expect(result).toEqual({ expired: false });
  });
});
