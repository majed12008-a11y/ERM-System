/*
 * خدمة المراجعات: إدارة تكليفات المراجعات والنماذج والتقديمات.
 */
import { ReviewRepository } from '../repositories/review.repository';
import { createAndNotify, broadcastDashboardEvent } from './notification.service';
import { AuthUser } from '../shared/types';

export class ReviewService {
  private reviews = new ReviewRepository();

  async getMyReviews(user: AuthUser) { return this.reviews.getMyReviews(user.id); }
  async getApplicationReviews(applicationId: number) { return this.reviews.getApplicationReviews(applicationId); }

  async assignReview(data: any, user: AuthUser) {
    const assignment = await this.reviews.createAssignment({ ...data, assigned_by: user.id });
    await createAndNotify(data.reviewer_id, 'REVIEW_REQUEST',
      'New Review Assignment', `You have been assigned as a ${data.review_type} reviewer for application #${data.application_id}.`);
    broadcastDashboardEvent('dashboard-stats', {});
    return assignment;
  }

  async getRecommendations(applicationId: number) { return this.reviews.getRecommendations(applicationId); }
  async getComments(applicationId: number) { return this.reviews.getComments(applicationId); }
  async getAnswers(assignmentId: number) { return this.reviews.getAnswers(assignmentId); }
  async getScore(assignmentId: number) { return this.reviews.getScore(assignmentId); }

  async submitReview(assignmentId: number, user: AuthUser, data: any) {
    const assignment = await this.reviews.findAssignmentById(assignmentId);
    if (!assignment) throw Object.assign(new Error('Assignment not found'), { status: 404 });
    if (assignment.reviewer_id !== user.id) throw Object.assign(new Error('Not assigned to you'), { status: 403 });

    const validTypes = ['APPROVE', 'REJECT', 'CONDITIONAL', 'ABSTAIN'];
    if (!validTypes.includes(data.recommendation_type)) {
      throw Object.assign(new Error('Invalid recommendation type'), { status: 400 });
    }

    await this.reviews.submitReview(assignmentId, user.id, data);
    return { message: 'Review submitted' };
  }

  async getForms() { return this.reviews.getForms(); }
  async createForm(data: any) { return this.reviews.createForm(data); }
  async getQuestions(formId: number) { return this.reviews.getQuestions(formId); }
  async addQuestion(formId: number, data: any) { return this.reviews.addQuestion(formId, data); }

  async deleteQuestion(formId: number, questionId: number) {
    const ok = await this.reviews.deleteQuestion(questionId, formId);
    if (!ok) throw Object.assign(new Error('Question not found'), { status: 404 });
  }
}
