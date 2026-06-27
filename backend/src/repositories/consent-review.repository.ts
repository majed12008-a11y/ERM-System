/*
 * مستودع مراجعة الموافقة: إدارة مراجعات
 * نماذج الموافقة المستنيرة المرتبطة بالطلبات.
 */
import { AuditableRepository } from './auditable.repository';
import { ApplicationConsentRepository } from './application-consent.repository';

export class ConsentReviewRepository extends AuditableRepository {
  private appConsentRepo = new ApplicationConsentRepository();

  async findByApplicationConsent(applicationConsentId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT crc.*, CONCAT(u.first_name_ar, ' ', u.last_name_ar) as reviewer_name
       FROM committee.consent_review_comments crc
       LEFT JOIN security.users u ON crc.reviewer_id = u.id
       WHERE crc.application_consent_id = $1 AND crc.deleted_at IS NULL
       ORDER BY crc.created_at DESC`,
      [applicationConsentId]
    );
    return result.rows;
  }

  async createReviewComment(data: any, userId: number): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.consent_review_comments
        (application_consent_id, reviewer_id, decision, comment, created_at)
       VALUES ($1, $2, $3, $4, $5) RETURNING *`,
      [data.application_consent_id, userId, data.decision, data.comment, meta.created_at]
    );

    await this.appConsentRepo.recalculateStatus(data.application_consent_id);

    return result.rows[0];
  }

  async updateReviewComment(id: number, data: any, userId: number): Promise<any | null> {
    const current = await this.query(
      `SELECT * FROM committee.consent_review_comments WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
    if (!current.rows[0]) return null;
    if (current.rows[0].reviewer_id !== userId) {
      const isAdmin = await this.query(
        `SELECT system.fn_is_admin($1) as is_admin`,
        [userId]
      );
      if (!isAdmin.rows[0]?.is_admin) {
        throw new Error('Only the original reviewer or an admin can update this comment.');
      }
    }

    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE committee.consent_review_comments SET
        decision = COALESCE($1, decision),
        comment = COALESCE($2, comment),
        updated_at = $3, updated_by = $4
       WHERE id = $5 AND deleted_at IS NULL RETURNING *`,
      [data.decision, data.comment, meta.updated_at, meta.updated_by, id]
    );

    if (result.rows[0]) {
      await this.appConsentRepo.recalculateStatus(result.rows[0].application_consent_id);
    }

    return result.rows[0] || null;
  }

  async softDelete(id: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE committee.consent_review_comments SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, id]
    );
    if ((result.rowCount ?? 0) > 0) {
      const comment = await this.query(
        `SELECT application_consent_id FROM committee.consent_review_comments WHERE id = $1`,
        [id]
      );
      if (comment.rows[0]) {
        await this.appConsentRepo.recalculateStatus(comment.rows[0].application_consent_id);
      }
    }
    return (result.rowCount ?? 0) > 0;
  }
}
