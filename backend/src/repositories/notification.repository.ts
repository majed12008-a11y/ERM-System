/*
 * مستودع الإشعارات: إدارة الإشعارات وسجلات التوصيل
 * وتفضيلات المستخدم. عمليات CRUD بحتة — لا منطق أعمال.
 */
import { PoolClient } from 'pg';
import { AuditableRepository } from './auditable.repository';

export interface CreatePendingInput {
  userId: number;
  notificationType: string;
  subject: string;
  messageBody: string;
  priorityLevel?: string;
  sourceEntityType?: string | null;
  sourceEntityId?: number | null;
}

export interface PendingBatchItem {
  userId: number;
  notificationType: string;
  subject: string;
  messageBody: string;
  priorityLevel?: string;
  sourceEntityType?: string | null;
  sourceEntityId?: number | null;
}

export class NotificationRepository extends AuditableRepository {

  // ============================================================
  // Transaction-aware: accept optional client
  // ============================================================

  async createPending(data: CreatePendingInput, client?: PoolClient): Promise<number> {
    const result = await this.query(
      `INSERT INTO communication.notifications
       (user_id, notification_type, subject, message_body, priority_level, source_entity_type, source_entity_id)
       VALUES ($1, $2, $3, $4, $5, $6, $7)
       RETURNING id`,
      [
        data.userId, data.notificationType, data.subject, data.messageBody,
        data.priorityLevel ?? 'NORMAL', data.sourceEntityType ?? null, data.sourceEntityId ?? null,
      ],
      client
    );
    return result.rows[0].id;
  }

  async createPendingBatch(items: PendingBatchItem[], client?: PoolClient): Promise<number[]> {
    if (items.length === 0) return [];

    const n = items.length;
    const userIds = new Array<number>(n);
    const types = new Array<string>(n);
    const subjects = new Array<string>(n);
    const bodies = new Array<string>(n);
    const priorities = new Array<string>(n);
    const sourceTypes = new Array<string | null>(n);
    const sourceIds = new Array<number | null>(n);

    for (let i = 0; i < n; i++) {
      const item = items[i];
      userIds[i] = item.userId;
      types[i] = item.notificationType;
      subjects[i] = item.subject;
      bodies[i] = item.messageBody;
      priorities[i] = item.priorityLevel ?? 'NORMAL';
      sourceTypes[i] = item.sourceEntityType ?? null;
      sourceIds[i] = item.sourceEntityId ?? null;
    }

    const result = await this.query(
      `INSERT INTO communication.notifications
       (user_id, notification_type, subject, message_body, priority_level, source_entity_type, source_entity_id)
       SELECT unnest($1::int[]), unnest($2::text[]), unnest($3::text[]),
              unnest($4::text[]), unnest($5::text[]), unnest($6::text[]), unnest($7::bigint[])
       RETURNING id`,
      [userIds, types, subjects, bodies, priorities, sourceTypes, sourceIds],
      client
    );
    return result.rows.map(r => r.id);
  }

  // ============================================================
  // Read path
  // ============================================================

  async getByUser(userId: number, limit: number = 50): Promise<any[]> {
    const result = await this.query(
      `SELECT id, user_id, notification_type, subject, message_body,
              priority_level, is_read, sent_at, created_at
       FROM communication.notifications
       WHERE user_id = $1 AND deleted_at IS NULL
       ORDER BY created_at DESC
       LIMIT $2`,
      [userId, limit]
    );
    return result.rows;
  }

  async getUnreadCount(userId: number): Promise<number> {
    const result = await this.query(
      `SELECT COUNT(*)::int AS count
       FROM communication.notifications
       WHERE user_id = $1 AND is_read = FALSE AND deleted_at IS NULL`,
      [userId]
    );
    return result.rows[0].count;
  }

  async findById(id: number): Promise<any | null> {
    const result = await this.query(
      `SELECT id, user_id, notification_type, subject, message_body,
              priority_level, is_read, sent_at, created_at,
              source_entity_type, source_entity_id
       FROM communication.notifications
       WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
    return result.rows[0] || null;
  }

  async findExisting(
    notificationType: string,
    userId: number,
    sourceEntityType: string,
    sourceEntityId: number,
    windowHours: number = 168
  ): Promise<boolean> {
    const result = await this.query(
      `SELECT 1 FROM communication.notifications
       WHERE notification_type = $1
         AND user_id = $2
         AND source_entity_type = $3
         AND source_entity_id = $4
         AND created_at > NOW() - make_interval(hours => $5)
       LIMIT 1`,
      [notificationType, userId, sourceEntityType, sourceEntityId, windowHours]
    );
    return result.rows.length > 0;
  }

  // ============================================================
  // Mutations
  // ============================================================

  async markRead(id: number, userId: number): Promise<void> {
    await this.query(
      `UPDATE communication.notifications SET is_read = TRUE
       WHERE id = $1 AND user_id = $2 AND deleted_at IS NULL`,
      [id, userId]
    );
  }

  async markAllRead(userId: number): Promise<void> {
    await this.query(
      `UPDATE communication.notifications SET is_read = TRUE
       WHERE user_id = $1 AND is_read = FALSE AND deleted_at IS NULL`,
      [userId]
    );
  }

  async softDelete(id: number, userId: number): Promise<void> {
    const meta = this.deleteMeta();
    await this.query(
      `UPDATE communication.notifications
       SET deleted_at = $3, deleted_by = $4
       WHERE id = $1 AND user_id = $2 AND deleted_at IS NULL`,
      [id, userId, meta.deleted_at, meta.deleted_by]
    );
  }

  async markDelivered(id: number): Promise<void> {
    await this.query(
      `UPDATE communication.notifications SET sent_at = NOW()
       WHERE id = $1 AND deleted_at IS NULL`,
      [id]
    );
  }

  // ============================================================
  // Delivery logging
  // ============================================================

  async insertLog(
    notificationId: number,
    deliveryStatus: string,
    providerReference?: string,
    errorMessage?: string
  ): Promise<number> {
    const result = await this.query(
      `INSERT INTO communication.notification_logs
       (notification_id, delivery_status, provider_reference, error_message)
       VALUES ($1, $2, $3, $4)
       RETURNING id`,
      [notificationId, deliveryStatus, providerReference ?? null, errorMessage ?? null]
    );
    return result.rows[0].id;
  }

  async getUserContactInfo(userId: number): Promise<{ email: string; mobile: string | null } | null> {
    const result = await this.query(
      `SELECT email, mobile FROM security.users WHERE id = $1`,
      [userId]
    );
    return result.rows[0] || null;
  }

  async updateDeliveryStatus(
    logId: number,
    deliveryStatus: string,
    errorMessage?: string
  ): Promise<void> {
    await this.query(
      `UPDATE communication.notification_logs
       SET delivery_status = $2, error_message = COALESCE($3, error_message)
       WHERE id = $1`,
      [logId, deliveryStatus, errorMessage ?? null]
    );
  }
}
