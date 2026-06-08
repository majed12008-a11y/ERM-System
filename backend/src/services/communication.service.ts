import { withTransaction } from '../config/database';
import { CommunicationRepository } from '../repositories/communication.repository';

export class CommunicationService {
  private repo = new CommunicationRepository();

  async getMessages(userId: number, box: string) {
    return box === 'sent'
      ? this.repo.getSentMessages(userId)
      : this.repo.getInbox(userId);
  }

  async getUnreadCount(userId: number) {
    return this.repo.getUnreadCount(userId);
  }

  async getMessageById(id: number, userId: number) {
    const msg = await this.repo.findMessageById(id);
    if (!msg) return null;

    const isRecipient = msg.sender_id !== userId
      ? await this.repo.findRecipient(id, userId)
      : null;

    if (msg.sender_id !== userId && !isRecipient) return null;

    if (isRecipient) {
      await this.repo.markAsRead(isRecipient.id);
    }

    const [recipients, attachments] = await Promise.all([
      this.repo.getRecipients(id),
      this.repo.getAttachments(id),
    ]);

    return { ...msg, recipients, attachments };
  }

  async createMessage(
    userId: number,
    data: {
      recipient_ids: number[]; subject: string; message_body?: string;
      related_entity_type?: string; related_entity_id?: string;
    },
    files?: Express.Multer.File[],
  ) {
    return withTransaction(async (client) => {
      const msg = await this.repo.createMessage({
        sender_id: userId, subject: data.subject,
        message_body: data.message_body,
        related_entity_type: data.related_entity_type,
        related_entity_id: data.related_entity_id,
      }, client);

      await this.repo.addRecipientsBatch(msg.id, data.recipient_ids, client);

      if (files) {
        await this.repo.addAttachmentsBatch(
          msg.id,
          files.map(f => ({
            file_name: f.originalname,
            file_path: f.path,
            file_size: f.size,
            mime_type: f.mimetype,
          })),
          client,
        );
      }

      return msg;
    });
  }

  async deleteMessage(id: number, userId: number) {
    const msg = await this.repo.findMessageById(id);
    if (!msg) return false;

    if (msg.sender_id === userId) {
      await this.repo.softDeleteMessage(id);
    } else {
      await this.repo.softDeleteRecipient(id, userId);
    }
    return true;
  }

  async getAttachment(attachmentId: number, messageId: number) {
    return this.repo.findAttachment(attachmentId, messageId);
  }

  async searchUsers(q: string) {
    return this.repo.searchUsers(q);
  }

  // Notifications
  async getNotifications(userId: number) {
    return this.repo.getNotifications(userId);
  }

  async markNotificationRead(id: number, userId: number) {
    await this.repo.markNotificationRead(id, userId);
  }

  async markAllNotificationsRead(userId: number) {
    await this.repo.markAllNotificationsRead(userId);
  }

  async deleteNotification(id: number, userId: number) {
    await this.repo.softDeleteNotification(id, userId);
  }
}
