/*
 * إدارة اللجان: إنشاء، تعديل، إدارة الأعضاء،
 * جدولة الاجتماعات، مراجعة الطلبات. تدير دورة حياة اللجنة
 * بالكامل مع صلاحيات مبنية على RLS.
 */
import path from 'path';
import fs from 'fs';
import crypto from 'crypto';
import {
  CommitteeRepository,
  MemberRepository,
  MeetingRepository,
} from '../repositories/committee.repository';
import { ApplicationRepository } from '../repositories/application.repository';
import { DocumentRepository } from '../repositories/document.repository';
import { AuthUser } from '../shared/types';
import { createAndNotifyBatch, broadcastDashboardEvent } from './notification.service';

const MINUTES_DIR = path.resolve('uploads/meeting-minutes');
if (!fs.existsSync(MINUTES_DIR)) {
  fs.mkdirSync(MINUTES_DIR, { recursive: true });
}

export class CommitteeService {
  private committees = new CommitteeRepository();
  private members = new MemberRepository();
  private meetings = new MeetingRepository();
  private applications = new ApplicationRepository();
  private documents = new DocumentRepository();

  async getTypes() { return this.committees.getTypes(); }
  async getRoles() { return this.committees.getRoles(); }
  async getAll() { return this.committees.findAll(); }
  async getById(id: number) {
    const c = await this.committees.findById(id);
    if (!c) throw Object.assign(new Error('Committee not found'), { status: 404 });
    return c;
  }

  async create(data: any, user: AuthUser) {
    return this.committees.create({ ...data, institution_id: parseInt(data.institution_id), committee_type_id: parseInt(data.committee_type_id) });
  }

  async update(id: number, data: any) {
    const result = await this.committees.update(id, data);
    if (!result) throw Object.assign(new Error('No valid fields to update or committee not found'), { status: 400 });
    return result;
  }

  async deactivate(id: number) {
    const ok = await this.committees.deactivate(id);
    if (!ok) throw Object.assign(new Error('Committee not found or already inactive'), { status: 404 });
    return { message: 'Committee deactivated' };
  }

  // Members
  async getMembers(committeeId: number) { return this.members.findByCommittee(committeeId); }
  async addMember(committeeId: number, data: { user_id: number; role_id?: number }) {
    const existing = await this.members.findByCommittee(committeeId);
    if (existing.some((m: any) => m.user_id === data.user_id && m.is_active)) {
      throw Object.assign(new Error('User is already a member of this committee'), { status: 400 });
    }
    return this.members.add(committeeId, data);
  }
  async updateMemberRole(memberId: number, role_id: number) {
    const result = await this.members.updateRole(memberId, role_id);
    if (!result) throw Object.assign(new Error('Member not found'), { status: 404 });
    return result;
  }
  async removeMember(memberId: number) {
    const ok = await this.members.remove(memberId);
    if (!ok) throw Object.assign(new Error('Member not found or already inactive'), { status: 404 });
    return { message: 'Member removed' };
  }
  async getTerms(memberId: number) { return this.members.getTerms(memberId); }
  async createTerm(memberId: number, data: any) { return this.members.createTerm(memberId, data); }
  async getQualifications(memberId: number) { return this.members.getQualifications(memberId); }
  async createQualification(memberId: number, data: any, user: AuthUser) {
    return this.members.createQualification(memberId, data, data.is_verified ? user.id : null);
  }
  async getConflicts(memberId: number) { return this.members.getConflicts(memberId); }
  async createConflict(memberId: number, data: any, user: AuthUser) {
    return this.members.createConflict(memberId, data, user.id);
  }

  // Meetings
  async getMeetings(committeeId: number) { return this.meetings.findByCommittee(committeeId); }
  async getAllMeetings() { return this.meetings.findAll(); }
  async getMeeting(id: number) {
    const m = await this.meetings.findById(id);
    if (!m) throw Object.assign(new Error('Meeting not found'), { status: 404 });
    return m;
  }
  async createMeeting(data: any) {
    const meeting = await this.meetings.create(data);
    const members = await this.meetings.getCommitteeMembers(data.committee_id);
    await createAndNotifyBatch(members.map(m => ({
      userId: m.user_id,
      notificationType: 'MEETING_SCHEDULED',
      subject: 'New Meeting Scheduled',
      messageBody: `A new meeting has been scheduled for ${new Date(data.meeting_date).toLocaleDateString()} at ${data.location ?? 'TBD'}.`,
    })));
    broadcastDashboardEvent('dashboard-stats', {});
    return meeting;
  }
  async updateMeeting(id: number, data: any) {
    const meeting = await this.meetings.update(id, data);
    if (!meeting) throw Object.assign(new Error('Meeting not found or no valid fields'), { status: 404 });
    const members = await this.meetings.getCommitteeMembers(meeting.committee_id);
    await createAndNotifyBatch(members.map(m => ({
      userId: m.user_id,
      notificationType: 'MEETING_UPDATED',
      subject: 'Meeting Updated',
      messageBody: `Meeting on ${new Date(meeting.meeting_date).toLocaleDateString()} has been updated.`,
    })));
    return meeting;
  }
  async getQuorum(meetingId: number) {
    return this.meetings.calculateQuorum(meetingId);
  }
  async getAgenda(meetingId: number) { return this.meetings.getAgenda(meetingId); }
  async createAgenda(meetingId: number, data: any) { return this.meetings.createAgenda(meetingId, data); }
  async addAgendaItem(agendaId: number, data: any) { return this.meetings.addAgendaItem(agendaId, data); }
  async getAttendance(meetingId: number) { return this.meetings.getAttendance(meetingId); }
  async addAttendance(meetingId: number, data: any) { return this.meetings.addAttendance(meetingId, data); }
  async getMinutes(meetingId: number) { return this.meetings.getMinutes(meetingId); }

  async createMinutes(meetingId: number, minutesText: string, user: AuthUser) {
    const minutes = await this.meetings.createMinutes(meetingId, minutesText, user.id);

    const txtPath = path.join(MINUTES_DIR, `minutes-${minutes.id}.txt`);
    await fs.promises.writeFile(txtPath, minutesText || '');

    const doc = await this.documents.create({
      document_type_id: 11,
      entity_type: 'MeetingMinutes',
      entity_id: minutes.id,
      document_title: `Meeting Minutes #${minutes.id}`,
      file_name: `minutes-${minutes.id}.txt`,
      mime_type: 'text/plain',
      file_size_bytes: Buffer.byteLength(minutesText || '', 'utf-8'),
      storage_path: txtPath,
      uploaded_by: user.id,
    });

    const raw = `${doc.id}-${user.id}-${Date.now()}`;
    const signatureHash = crypto.createHash('sha256').update(raw).digest('hex');
    await this.documents.addSignature(doc.id, user.id, signatureHash);

    return { ...minutes, document_id: doc.id };
  }

  async approveMinutes(meetingId: number, minutesId: number, user: AuthUser) {
    const docs = await this.documents.findByEntity('MeetingMinutes', minutesId);
    if (docs.length > 0) {
      const existing = await this.documents.findSignature(docs[0].id, user.id);
      if (!existing) {
        const raw = `${docs[0].id}-${user.id}-${Date.now()}`;
        const signatureHash = crypto.createHash('sha256').update(raw).digest('hex');
        await this.documents.addSignature(docs[0].id, user.id, signatureHash);
      }
    }
    const result = await this.meetings.approveMinutes(minutesId, meetingId, user.id);
    if (!result) throw Object.assign(new Error('Minutes not found'), { status: 404 });
    return result;
  }

  async getCommitteeMembers(meetingId: number) {
    const meeting = await this.meetings.findById(meetingId);
    if (!meeting) throw Object.assign(new Error('Meeting not found'), { status: 404 });
    return this.meetings.getCommitteeMembers(meeting.committee_id);
  }
}
