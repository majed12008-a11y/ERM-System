import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';

export class CommunicationRepository extends AuditableRepository {
  // Messages
  async getInbox(userId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT m.*, u.username as sender_name, mr.is_read, mr.read_at
       FROM communication.message_recipients mr
       JOIN communication.messages m ON mr.message_id = m.id
       JOIN security.users u ON m.sender_id = u.id
       WHERE mr.recipient_id = $1 AND mr.is_deleted = FALSE AND m.is_deleted = FALSE
       ORDER BY mr.created_at DESC`,
      [userId]
    );
    return result.rows;
  }

  async getSentMessages(userId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT m.*, u.username as sender_name,
              (SELECT COUNT(*) FROM communication.message_recipients mr WHERE mr.message_id = m.id) as recipient_count,
              (SELECT COUNT(*) FROM communication.message_recipients mr WHERE mr.message_id = m.id AND mr.is_read = TRUE) as read_count
       FROM communication.messages m
       JOIN security.users u ON m.sender_id = u.id
       WHERE m.sender_id = $1 AND m.is_deleted = FALSE
       ORDER BY m.created_at DESC`,
      [userId]
    );
    return result.rows;
  }

  async getUnreadCount(userId: number): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(*)::int as count FROM communication.message_recipients
       WHERE recipient_id = $1 AND is_read = FALSE AND is_deleted = FALSE`,
      [userId]
    );
    return result.rows[0].count;
  }

  async findMessageById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT m.*, u.username as sender_name
       FROM communication.messages m
       JOIN security.users u ON m.sender_id = u.id
       WHERE m.id = $1 AND m.is_deleted = FALSE`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findRecipient(messageId: number, userId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT id FROM communication.message_recipients WHERE message_id = $1 AND recipient_id = $2 AND is_deleted = FALSE`,
      [messageId, userId]
    );
    return result.rows[0] || null;
  }

  async markAsRead(recipientId: number) {
    await this.query(
      `UPDATE communication.message_recipients SET is_read = TRUE, read_at = now() WHERE id = $1 AND is_read = FALSE`,
      [recipientId]
    );
  }

  async getRecipients(messageId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT mr.*, u.username as recipient_name
       FROM communication.message_recipients mr
       JOIN security.users u ON mr.recipient_id = u.id
       WHERE mr.message_id = $1 AND mr.is_deleted = FALSE`,
      [messageId]
    );
    return result.rows;
  }

  async getAttachments(messageId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM communication.message_attachments WHERE message_id = $1`,
      [messageId]
    );
    return result.rows;
  }

  async createMessage(data: {
    sender_id: number; subject: string; message_body?: string;
    related_entity_type?: string; related_entity_id?: string;
  }, client?: PoolClient): Promise<any> {
    const meta = this.createMeta();
    const result = await this.query(
      `INSERT INTO communication.messages (sender_id, subject, message_body, related_entity_type, related_entity_id, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
      [data.sender_id, data.subject, data.message_body || null,
       data.related_entity_type || null, data.related_entity_id || null,
       meta.created_by, meta.created_at],
      client
    );
    return result.rows[0];
  }

  async addRecipient(messageId: number, recipientId: number, client?: PoolClient) {
    await this.query(
      `INSERT INTO communication.message_recipients (message_id, recipient_id) VALUES ($1, $2)`,
      [messageId, recipientId],
      client
    );
  }

  async addRecipientsBatch(messageId: number, recipientIds: number[], client?: PoolClient) {
    if (recipientIds.length === 0) return;
    await this.query(
      `INSERT INTO communication.message_recipients (message_id, recipient_id)
       SELECT $1, unnest($2::int[])`,
      [messageId, recipientIds],
      client
    );
  }

  async addAttachment(data: {
    message_id: number; file_name: string; file_path: string;
    file_size: number; mime_type: string;
  }, client?: PoolClient) {
    const meta = this.createMeta();
    await this.query(
      `INSERT INTO communication.message_attachments (message_id, file_name, file_path, file_size, mime_type, created_by, created_at)
       VALUES ($1, $2, $3, $4, $5, $6, $7)`,
      [data.message_id, data.file_name, data.file_path, data.file_size, data.mime_type,
       meta.created_by, meta.created_at],
      client
    );
  }

  async addAttachmentsBatch(messageId: number, attachments: Array<{
    file_name: string; file_path: string; file_size: number; mime_type: string;
  }>, client?: PoolClient) {
    if (attachments.length === 0) return;
    const meta = this.createMeta();
    await this.query(
      `INSERT INTO communication.message_attachments (message_id, file_name, file_path, file_size, mime_type, created_by, created_at)
       SELECT $1, unnest($2::text[]), unnest($3::text[]), unnest($4::int[]), unnest($5::text[]), $6, $7`,
      [
        messageId,
        attachments.map(a => a.file_name),
        attachments.map(a => a.file_path),
        attachments.map(a => a.file_size),
        attachments.map(a => a.mime_type),
        meta.created_by,
        meta.created_at,
      ],
      client
    );
  }

  async softDeleteMessage(id: number) {
    await this.query('UPDATE communication.messages SET is_deleted = TRUE WHERE id = $1', [id]);
  }

  async softDeleteRecipient(messageId: number, userId: number) {
    await this.query(
      'UPDATE communication.message_recipients SET is_deleted = TRUE WHERE message_id = $1 AND recipient_id = $2',
      [messageId, userId]
    );
  }

  async findAttachment(attachmentId: number, messageId: number): Promise<any | null> {
    const result = await this.query(
      `SELECT * FROM communication.message_attachments WHERE id = $1 AND message_id = $2`,
      [attachmentId, messageId]
    );
    return result.rows[0] || null;
  }

  async searchUsers(queryStr: string): Promise<any[]> {
    const result = await this.query(
      `SELECT u.id, u.username, u.email
       FROM security.users u
       WHERE u.status = 'ACTIVE' AND u.username ILIKE $1
       ORDER BY u.username LIMIT 20`,
      [`%${queryStr}%`]
    );
    return result.rows;
  }

  // Notifications
  async getNotifications(userId: number): Promise<any[]> {
    const result = await this.query(
      `SELECT * FROM communication.notifications
       WHERE user_id = $1 AND deleted_at IS NULL
       ORDER BY created_at DESC LIMIT 50`,
      [userId]
    );
    return result.rows;
  }

  async markNotificationRead(id: number, userId: number) {
    await this.query(
      'UPDATE communication.notifications SET is_read = TRUE WHERE id = $1 AND user_id = $2',
      [id, userId]
    );
  }

  async markAllNotificationsRead(userId: number) {
    await this.query(
      'UPDATE communication.notifications SET is_read = TRUE WHERE user_id = $1 AND is_read = FALSE',
      [userId]
    );
  }

  async softDeleteNotification(id: number, userId: number) {
    await this.query(
      'UPDATE communication.notifications SET deleted_at = now(), deleted_by = $1 WHERE id = $2 AND user_id = $3 AND deleted_at IS NULL',
      [userId, id, userId]
    );
  }
}
