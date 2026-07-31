/*
 * مستودع المراجعات: إدارة تكليفات المراجعات والبيانات ذات الصلة.
 */
import { AuditableRepository } from './auditable.repository';

export class ReviewRepository extends AuditableRepository {
  async getMyReviews(userId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ra.*, a.application_number, a.current_status, p.title_ar as project_title
       FROM committee.review_assignments ra
       JOIN core.applications a ON ra.application_id = a.id
       LEFT JOIN core.projects p ON a.project_id = p.id
       WHERE ra.reviewer_id = $1
       ORDER BY ra.assigned_at DESC`,
      [userId]
    );
    return result.rows;
  }

  async findAssignmentById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM committee.review_assignments WHERE id = $1`, [id]
    );
    return result.rows[0] || null;
  }

  async getApplicationReviews(applicationId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ra.*, u.username as reviewer_name
       FROM committee.review_assignments ra
       LEFT JOIN security.users u ON ra.reviewer_id = u.id
       WHERE ra.application_id = $1
       ORDER BY ra.assigned_at DESC`,
      [applicationId]
    );
    return result.rows;
  }

  async createAssignment(data: {
    application_id: number; reviewer_id: number; review_type: string;
    assigned_by: number; due_date?: string;
  }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.review_assignments
        (application_id, reviewer_id, review_type, assigned_by, due_date, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [data.application_id, data.reviewer_id, data.review_type, data.assigned_by, data.due_date || null, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async getForms(): Promise<any[]> {
    const result = await this.query(
      `SELECT rf.*, (SELECT COUNT(*) FROM committee.review_questions rq WHERE rq.form_id = rf.id) as question_count
       FROM committee.review_forms rf ORDER BY rf.form_name`
    );
    return result.rows;
  }

  async createForm(data: { form_code: string; form_name: string; review_type: string }): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.review_forms (form_code, form_name, review_type, version_no, is_active, created_by, created_at)
       VALUES ($1, $2, $3, 1, TRUE, $4, $5) RETURNING *`,
      [data.form_code, data.form_name, data.review_type, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async getQuestions(formId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM committee.review_questions WHERE form_id = $1 ORDER BY display_order`,
      [formId]
    );
    return result.rows;
  }

  async addQuestion(formId: number, data: any): Promise<any> {
    const orderResult = await this.query(
      `SELECT COALESCE(MAX(display_order),0)+1 as nxt FROM committee.review_questions WHERE form_id=$1`,
      [formId]
    );
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO committee.review_questions
        (form_id, question_code, question_text, question_type, display_order, is_required, question_options, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING *`,
      [formId, data.question_code, data.question_text, data.question_type, orderResult.rows[0].nxt, data.is_required !== false, data.question_options || null, meta.created_by, meta.created_at]
    );
    return result.rows[0];
  }

  async deleteQuestion(questionId: number, formId: number): Promise<boolean> {
    const meta = this.deleteMeta();
    const result = await this.query(
      `UPDATE committee.review_questions SET deleted_at = $1, deleted_by = $2 WHERE id = $3 AND form_id = $4 AND deleted_at IS NULL`,
      [meta.deleted_at, meta.deleted_by, questionId, formId]
    );
    return (result.rowCount ?? 0) > 0;
  }

  async getRecommendations(applicationId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT rr.*, u.username as reviewer_name
       FROM committee.review_recommendations rr
       LEFT JOIN security.users u ON rr.reviewer_id = u.id
       WHERE rr.application_id = $1
       ORDER BY rr.created_at DESC`,
      [applicationId]
    );
    return result.rows;
  }

  async getComments(applicationId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT rc.*, u.username as reviewer_name
       FROM committee.review_comments rc
       LEFT JOIN security.users u ON rc.reviewer_id = u.id
       WHERE rc.application_id = $1
       ORDER BY rc.created_at DESC`,
      [applicationId]
    );
    return result.rows;
  }

  async getAnswers(assignmentId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT ra.*, rq.question_text, rq.question_type
       FROM committee.review_answers ra
       JOIN committee.review_questions rq ON ra.question_id = rq.id
       WHERE ra.review_id = $1
       ORDER BY rq.display_order`,
      [assignmentId]
    );
    return result.rows;
  }

  async getScore(assignmentId: number): Promise<any | null> {
    const assignment = await this.findAssignmentById(assignmentId);
    if (!assignment) return null;
    const result = await this.query(
      `SELECT * FROM committee.review_scores WHERE application_id = $1 AND reviewer_id = $2`,
      [assignment.application_id, assignment.reviewer_id]
    );
    return result.rows[0] || null;
  }

  async submitReview(assignmentId: number, userId: number, data: any): Promise<void> {
    const assignment = await this.findAssignmentById(assignmentId);
    if (!assignment) throw Object.assign(new Error('Assignment not found'), { status: 404 });

    await this.withTransaction(async (client) => {
      await client.query(
        `INSERT INTO committee.review_recommendations (application_id, reviewer_id, recommendation_type, justification)
         VALUES ($1, $2, $3, $4)`,
        [assignment.application_id, userId, data.recommendation_type, data.justification || null]
      );

      if (data.comment_text) {
        await client.query(
          `INSERT INTO committee.review_comments (application_id, reviewer_id, comment_text, is_internal)
           VALUES ($1, $2, $3, $4)`,
          [assignment.application_id, userId, data.comment_text, data.is_internal || false]
        );
      }

      if (data.answers && Array.isArray(data.answers)) {
        for (const a of data.answers) {
          await client.query(
            `INSERT INTO committee.review_answers (review_id, review_type, question_id, answer_text, answer_score)
             VALUES ($1, $2, $3, $4, $5)`,
            [assignmentId, assignment.review_type, a.question_id, a.answer_text || null, a.answer_score || null]
          );
        }
        const scoreResult = await client.query(
          `SELECT COALESCE(AVG(answer_score), 0) as avg_score FROM committee.review_answers WHERE review_id = $1 AND answer_score IS NOT NULL`,
          [assignmentId]
        );
        await client.query(
          `INSERT INTO committee.review_scores (application_id, reviewer_id, review_type, score)
           VALUES ($1, $2, $3, $4)`,
          [assignment.application_id, userId, assignment.review_type, scoreResult.rows[0].avg_score]
        );
      }

      await client.query(
        `UPDATE committee.review_assignments SET status_code = 'COMPLETED', updated_at = now() WHERE id = $1`,
        [assignmentId]
      );
    });
  }
}
