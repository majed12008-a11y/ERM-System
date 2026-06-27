/*
 * مستودع ربط الموافقة بالطلبات: إدارة نماذج الموافقة
 * المرتبطة بكل طلب بحث.
 */
import { AuditableRepository } from './auditable.repository';

export class ApplicationConsentRepository extends AuditableRepository {
  async findByApplication(applicationId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ac.*,
        ctv.version_no, ctv.language, ctv.title, ctv.status as version_status,
        ct.id as template_id, ct.code as template_code, ct.name_ar as template_name_ar,
        ct.name_en as template_name_en, ct.consent_type,
        CONCAT(u.first_name_ar, ' ', u.last_name_ar) as reviewer_name,
        COALESCE(
          (SELECT jsonb_agg(jsonb_build_object(
            'id', crc2.id,
            'decision', crc2.decision,
            'comment', crc2.comment,
            'reviewer_name', CONCAT(ru2.first_name_ar, ' ', ru2.last_name_ar),
            'created_at', crc2.created_at
          ) ORDER BY crc2.created_at DESC)
           FROM committee.consent_review_comments crc2
           LEFT JOIN security.users ru2 ON crc2.reviewer_id = ru2.id
           WHERE crc2.application_consent_id = ac.id AND crc2.deleted_at IS NULL),
          '[]'::jsonb
        ) as review_comments
       FROM core.application_consents ac
       JOIN committee.consent_template_versions ctv ON ac.consent_version_id = ctv.id
       JOIN committee.consent_templates ct ON ctv.template_id = ct.id
       LEFT JOIN security.users u ON ac.reviewed_by = u.id
       WHERE ac.application_id = $1 AND ac.deleted_at IS NULL
       GROUP BY ac.id, ctv.version_no, ctv.language, ctv.title, ctv.status,
         ct.id, ct.code, ct.name_ar, ct.name_en, ct.consent_type, u.first_name_ar, u.last_name_ar
       ORDER BY ct.name_ar, ctv.version_no`,
      [applicationId]
    );
    return result.rows;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT ac.*,
        ctv.version_no, ctv.language, ctv.title, ctv.status as version_status,
        ct.code as template_code, ct.name_ar as template_name_ar, ct.name_en as template_name_en
       FROM core.application_consents ac
       JOIN committee.consent_template_versions ctv ON ac.consent_version_id = ctv.id
       JOIN committee.consent_templates ct ON ctv.template_id = ct.id
       WHERE ac.id = $1 AND ac.deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async assign(applicationId: number, consentVersionId: number, isRequired: boolean): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO core.application_consents (application_id, consent_version_id, is_required, status, created_by, created_at)
       VALUES ($1, $2, $3, 'PENDING', $4, $5)
       ON CONFLICT (application_id, consent_version_id) DO UPDATE SET
         is_required = COALESCE($3, application_consents.is_required),
         deleted_at = NULL, deleted_by = NULL,
         updated_at = $5, updated_by = $4
       RETURNING *`,
      [applicationId, consentVersionId, isRequired, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async replaceConsentVersion(id: number, newConsentVersionId: number): Promise<any | null> {
    const current = await this.findById(id);
    if (!current) return null;

    const reviewInProgress = await this.query(
      `SELECT 1 FROM committee.review_assignments ra
       JOIN core.application_consents ac ON ac.application_id = ra.application_id
       WHERE ac.id = $1 AND ra.review_type = 'CONSENT'
         AND ra.status_code IN ('ASSIGNED', 'IN_REVIEW')
         AND ra.deleted_at IS NULL
       LIMIT 1`,
      [id]
    );
    if (reviewInProgress.rows.length > 0) {
      throw new Error('Cannot replace consent version while a review is in progress.');
    }

    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE core.application_consents SET
        consent_version_id = $1, status = 'PENDING', reviewed_by = NULL, reviewed_at = NULL, reviewer_notes = NULL,
        updated_at = $2, updated_by = $3
       WHERE id = $4 AND deleted_at IS NULL RETURNING *`,
      [newConsentVersionId, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async markRequired(id: number, isRequired: boolean): Promise<any | null> {
    const meta = this.updateMeta();
    const result = await this.query(
      `UPDATE core.application_consents SET is_required = $1, updated_at = $2, updated_by = $3
       WHERE id = $4 AND deleted_at IS NULL RETURNING *`,
      [isRequired, meta.updated_at, meta.updated_by, id]
    );
    return result.rows[0] || null;
  }

  async recalculateStatus(id: number): Promise<string> {
    const comments = await this.query(
      `SELECT decision FROM committee.consent_review_comments
       WHERE application_consent_id = $1 AND deleted_at IS NULL
       ORDER BY created_at DESC`,
      [id]
    );

    let autoStatus: string;
    const decisions = comments.rows.map(r => r.decision);

    if (decisions.length === 0) {
      autoStatus = 'PENDING';
    } else if (decisions.includes('REJECTED')) {
      autoStatus = 'REJECTED';
    } else if (decisions.includes('MAJOR_REVISION')) {
      autoStatus = 'MAJOR_REVISION';
    } else if (decisions.includes('MINOR_REVISION')) {
      autoStatus = 'MINOR_REVISION';
    } else if (decisions.every(d => d === 'APPROVED')) {
      autoStatus = 'APPROVED';
    } else {
      autoStatus = 'PENDING';
    }

    await this.query(
      `UPDATE core.application_consents SET status = $1, updated_at = $2
       WHERE id = $3 AND deleted_at IS NULL`,
      [autoStatus, new Date(), id]
    );
    return autoStatus;
  }
}
