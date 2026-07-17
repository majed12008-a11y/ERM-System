/*
 * خدمة التصويت: إدارة جلسات التصويت والقرارات.
 */
import { VotingRepository } from '../repositories/voting.repository';
import { ApplicationRepository } from '../repositories/application.repository';
import { createAndNotifyBatch, broadcastDashboardEvent } from './notification.service';
import { AuthUser } from '../shared/types';

export class VotingService {
  private voting = new VotingRepository();
  private applications = new ApplicationRepository();

  async getVotingSessions(meetingId: number) { return this.voting.findByMeeting(meetingId); }

  async getVotingSession(id: number) {
    const session = await this.voting.findSessionById(id);
    if (!session) throw Object.assign(new Error('Session not found'), { status: 404 });
    const votes = await this.voting.getVotes(id);
    return { ...session, votes };
  }

  async createVotingSession(data: any) { return this.voting.createSession(data); }

  async castVote(sessionId: number, user: AuthUser, voteValue: string, comments?: string) {
    if (!['APPROVE', 'REJECT', 'ABSTAIN'].includes(voteValue)) {
      throw Object.assign(new Error('Invalid vote value'), { status: 400 });
    }
    const session = await this.voting.findSessionById(sessionId);
    if (!session || session.status_code !== 'OPEN') {
      throw Object.assign(new Error('Voting session is not open'), { status: 400 });
    }
    const existingVotes = await this.voting.getVotes(sessionId);
    if (existingVotes.some((v: any) => v.voter_id === user.id)) {
      throw Object.assign(new Error('Already voted'), { status: 400 });
    }
    return this.voting.castVote(sessionId, user.id, voteValue, comments);
  }

  async closeVotingSession(sessionId: number) {
    const session = await this.voting.closeSession(sessionId);
    if (!session) throw Object.assign(new Error('Session not found'), { status: 404 });

    const voters = await this.voting.getVotes(sessionId);
    await createAndNotifyBatch(voters.map(v => ({
      userId: v.voter_id,
      notificationType: 'VOTE_CLOSED',
      subject: 'Voting Session Closed',
      messageBody: `Voting session for application #${session.application_id ?? 'N/A'} has been closed.`,
    })));

    try {
      if (session.application_id) {
        const app = await this.applications.findById(session.application_id);
        if (app) {
          await createAndNotifyBatch([{
            userId: app.submitted_by,
            notificationType: 'VOTE_DECISION',
            subject: 'Committee Decision',
            messageBody: `A decision has been made on your application #${session.application_id}. Check the committee voting results.`,
          }]);
        }
      }
    } catch { /* non-critical */ }

    broadcastDashboardEvent('dashboard-stats', {});
    return session;
  }
}
