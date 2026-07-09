import { Response } from 'express';
import { PoolClient } from 'pg';
import { query } from '../config/database';
import { logger } from '../config/logger';
import {
  NotificationRepository,
  CreatePendingInput,
  PendingBatchItem,
} from '../repositories/notification.repository';
import { DEDUP_EVENTS, DEDUP_CONFIG } from './notification-types';
import { ChannelRouterService } from './channel-router.service';
import { TemplateRendererService } from './template-renderer.service';
import { EmailChannelService } from './email-channel.service';
import { SmsChannelService } from './sms-channel.service';
import { RetryQueueService, RetryFn } from './retry-queue.service';
import { RETRY_POLICY } from './channel-constants';
import {
  notificationsSentTotal,
  notificationDeliveryDurationSeconds,
  notificationSSEConnections,
} from './metrics.service';

// ============================================================
// SSE infrastructure
// ============================================================

interface SSEClient {
  userId: number;
  res: Response;
}

const clients = new Map<number, SSEClient[]>();

export function addClient(userId: number, res: Response): void {
  if (!clients.has(userId)) {
    clients.set(userId, []);
  }
  clients.get(userId)!.push({ userId, res });
  notificationSSEConnections.inc();

  res.on('close', () => {
    const userClients = clients.get(userId);
    if (userClients) {
      const idx = userClients.findIndex(c => c.res === res);
      if (idx !== -1) userClients.splice(idx, 1);
      if (userClients.length === 0) clients.delete(userId);
    }
    notificationSSEConnections.dec();
  });
}

function sendToClient(client: SSEClient, event: string, data: any): void {
  try {
    client.res.write(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`);
  } catch {
    const userClients = clients.get(client.userId);
    if (userClients) {
      const idx = userClients.findIndex(c => c.res === client.res);
      if (idx !== -1) userClients.splice(idx, 1);
      if (userClients.length === 0) clients.delete(client.userId);
    }
  }
}

export function broadcastToUser(userId: number, event: string, data: any): void {
  const userClients = clients.get(userId);
  if (userClients) {
    userClients.forEach(client => sendToClient(client, event, data));
  }
}

export function broadcastToAll(event: string, data: any): void {
  clients.forEach(userClients => {
    userClients.forEach(client => sendToClient(client, event, data));
  });
}

export function getConnectedUserIds(): number[] {
  return Array.from(clients.keys());
}

const dashboardClients: Response[] = [];

export function addDashboardClient(res: Response): void {
  dashboardClients.push(res);
  res.on('close', () => {
    const idx = dashboardClients.indexOf(res);
    if (idx !== -1) dashboardClients.splice(idx, 1);
  });
}

export function broadcastDashboardEvent(event: string, data: any): void {
  dashboardClients.forEach((client) => {
    try {
      client.write(`event: ${event}\ndata: ${JSON.stringify(data)}\n\n`);
    } catch {
      const idx = dashboardClients.indexOf(client);
      if (idx !== -1) dashboardClients.splice(idx, 1);
    }
  });
}

// ============================================================
// NotificationService class (Phase 4)
// ============================================================

export class NotificationService {
  private repo = new NotificationRepository();
  private channelRouter = new ChannelRouterService();
  private templateRenderer = new TemplateRendererService();
  private emailChannel = new EmailChannelService();
  private smsChannel = new SmsChannelService();
  private retryQueue = new RetryQueueService();

  // ============================================================
  // Inside-transaction: DB persistence only
  // ============================================================

  async createPending(data: CreatePendingInput, client?: PoolClient): Promise<number | null> {
    if (DEDUP_EVENTS.has(data.notificationType) && data.sourceEntityType && data.sourceEntityId) {
      const windowHours = DEDUP_CONFIG[data.notificationType]?.windowHours ?? 168;
      const exists = await this.repo.findExisting(
        data.notificationType,
        data.userId,
        data.sourceEntityType,
        data.sourceEntityId,
        windowHours
      );
      if (exists) {
        logger.debug({ data }, 'Duplicate notification suppressed');
        return null;
      }
    }
    return this.repo.createPending(data, client);
  }

  async createPendingBatch(items: PendingBatchItem[], client?: PoolClient): Promise<number[]> {
    return this.repo.createPendingBatch(items, client);
  }

  // ============================================================
  // After-commit: multi-channel dispatch + logging
  // ============================================================

  async deliver(notificationId: number): Promise<void> {
    try {
      const notification = await this.repo.findById(notificationId);
      if (!notification) {
        logger.warn({ notificationId }, 'deliver: notification not found');
        return;
      }

      const notifType = notification.notification_type;

      // 1. IN_APP — always broadcast via SSE
      broadcastToUser(notification.user_id, 'notification', notification);
      await this.repo.insertLog(notificationId, 'DELIVERED', 'IN_APP');
      notificationsSentTotal.inc({ type: notifType, channel: 'IN_APP', status: 'DELIVERED' });

      // 2. Resolve non-IN_APP channels
      const channels = await this.channelRouter.resolveChannels(notifType, notification.user_id);

      // 3. Dispatch per channel
      const contact = await this.repo.getUserContactInfo(notification.user_id);

      for (const channel of channels) {
        if (channel === 'IN_APP') continue;

        if (!contact) {
          await this.repo.insertLog(notificationId, 'FAILED', channel, 'No contact info for user');
          notificationsSentTotal.inc({ type: notifType, channel, status: 'FAILED' });
          logger.warn({ notificationId, channel, userId: notification.user_id }, 'Notification delivery failed: no contact info');
          continue;
        }

        const rendered = await this.templateRenderer.render(
          notifType, channel, notification.subject, notification.message_body
        );

        let result: { success: boolean; reference?: string; error?: string };
        if (channel === 'EMAIL') {
          if (!contact.email) {
            await this.repo.insertLog(notificationId, 'FAILED', 'EMAIL', 'No email address');
            notificationsSentTotal.inc({ type: notifType, channel: 'EMAIL', status: 'FAILED' });
            logger.warn({ notificationId, userId: notification.user_id }, 'Notification delivery failed: no email address');
            continue;
          }
          const sendStart = process.hrtime.bigint();
          result = await this.emailChannel.send(contact.email, rendered.subject, rendered.body);
          notificationDeliveryDurationSeconds.observe({ channel: 'EMAIL' }, Number(process.hrtime.bigint() - sendStart) / 1e9);
        } else if (channel === 'SMS') {
          if (!contact.mobile) {
            await this.repo.insertLog(notificationId, 'FAILED', 'SMS', 'No mobile number');
            notificationsSentTotal.inc({ type: notifType, channel: 'SMS', status: 'FAILED' });
            logger.warn({ notificationId, userId: notification.user_id }, 'Notification delivery failed: no mobile number');
            continue;
          }
          const sendStart = process.hrtime.bigint();
          result = await this.smsChannel.send(contact.mobile, rendered.body);
          notificationDeliveryDurationSeconds.observe({ channel: 'SMS' }, Number(process.hrtime.bigint() - sendStart) / 1e9);
        } else {
          await this.repo.insertLog(notificationId, 'FAILED', channel, 'Unknown channel');
          notificationsSentTotal.inc({ type: notifType, channel, status: 'FAILED' });
          logger.warn({ notificationId, channel, userId: notification.user_id }, 'Notification delivery failed: unknown channel');
          continue;
        }

        if (result.success) {
          await this.repo.insertLog(notificationId, 'SENT', `${channel}:${result.reference}`);
          notificationsSentTotal.inc({ type: notifType, channel, status: 'SENT' });
        } else {
          await this.repo.insertLog(notificationId, 'RETRYING', channel, result.error);
          notificationsSentTotal.inc({ type: notifType, channel, status: 'RETRYING' });
          logger.warn({ notificationId, channel, error: result.error, attempt: 1 }, 'Notification delivery queued for retry');
          this.retryQueue.enqueue(notificationId, channel, 1, this.retryBound);
        }
      }

      await this.repo.markDelivered(notificationId);
    } catch (err) {
      logger.error({ err, notificationId }, 'deliver failed');
    }
  }

  // ============================================================
  // Retry mechanism
  // ============================================================

  private retryBound: RetryFn = (id, ch, attempt) => this.retryChannel(id, ch, attempt);

  private async retryChannel(notificationId: number, channel: string, attempt: number): Promise<void> {
    try {
      const notification = await this.repo.findById(notificationId);
      if (!notification) return;

      const notifType = notification.notification_type;

      const rendered = await this.templateRenderer.render(
        notifType, channel, notification.subject, notification.message_body
      );

      const contact = await this.repo.getUserContactInfo(notification.user_id);
      if (!contact) {
        await this.repo.insertLog(notificationId, 'FAILED', channel, 'No contact info');
        notificationsSentTotal.inc({ type: notifType, channel, status: 'FAILED' });
        logger.warn({ notificationId, channel, attempt }, 'Retry failed: no contact info');
        return;
      }

      let result: { success: boolean; reference?: string; error?: string };
      if (channel === 'EMAIL') {
        if (!contact.email) {
          await this.repo.insertLog(notificationId, 'FAILED', 'EMAIL', 'No email address');
          notificationsSentTotal.inc({ type: notifType, channel: 'EMAIL', status: 'FAILED' });
          logger.warn({ notificationId, attempt }, 'Retry failed: no email address');
          return;
        }
        result = await this.emailChannel.send(contact.email, rendered.subject, rendered.body);
      } else if (channel === 'SMS') {
        if (!contact.mobile) {
          await this.repo.insertLog(notificationId, 'FAILED', 'SMS', 'No mobile number');
          notificationsSentTotal.inc({ type: notifType, channel: 'SMS', status: 'FAILED' });
          logger.warn({ notificationId, attempt }, 'Retry failed: no mobile number');
          return;
        }
        result = await this.smsChannel.send(contact.mobile, rendered.body);
      } else {
        await this.repo.insertLog(notificationId, 'FAILED', channel, 'Unknown channel');
        notificationsSentTotal.inc({ type: notifType, channel, status: 'FAILED' });
        logger.warn({ notificationId, channel, attempt }, 'Retry failed: unknown channel');
        return;
      }

      if (result.success) {
        await this.repo.insertLog(notificationId, 'SENT', `${channel}:${result.reference}`);
        notificationsSentTotal.inc({ type: notifType, channel, status: 'SENT' });
        logger.info({ notificationId, channel, attempt }, 'Retry succeeded');
        this.retryQueue.cancel(notificationId, channel);
      } else if (attempt < RETRY_POLICY.MAX_ATTEMPTS - 1) {
        await this.repo.insertLog(notificationId, 'RETRYING', channel, result.error);
        notificationsSentTotal.inc({ type: notifType, channel, status: 'RETRYING' });
        logger.warn({ notificationId, channel, error: result.error, attempt: attempt + 1 }, 'Notification delivery requeued for retry');
        this.retryQueue.enqueue(notificationId, channel, attempt + 1, this.retryBound);
      } else {
        await this.repo.insertLog(notificationId, 'FAILED', channel, result.error);
        notificationsSentTotal.inc({ type: notifType, channel, status: 'FAILED' });
        logger.error({ notificationId, channel, error: result.error, attempt }, 'Retry exhausted — notification delivery permanently failed');
      }
    } catch (err) {
      logger.error({ err, notificationId, channel, attempt }, 'retryChannel failed');
    }
  }

  // ============================================================
  // Non-txn convenience: create + deliver
  // ============================================================

  async send(data: CreatePendingInput): Promise<void> {
    try {
      const id = await this.createPending(data);
      if (id !== null) {
        await this.deliver(id);
      }
    } catch (err) {
      logger.error({ err, notificationType: data.notificationType }, 'send failed');
    }
  }
}

// ============================================================
// Backward-compatible legacy wrappers (unchanged)
// ============================================================

export async function createAndNotify(
  userId: number,
  notificationType: string,
  subject: string,
  messageBody: string,
  priorityLevel: string = 'NORMAL',
  client?: PoolClient,
): Promise<void> {
  const result = client
    ? await client.query(
        `INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, priority_level)
         VALUES ($1, $2, $3, $4, $5) RETURNING *`,
        [userId, notificationType, subject, messageBody, priorityLevel]
      )
    : await query(
        `INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, priority_level)
         VALUES ($1, $2, $3, $4, $5) RETURNING *`,
        [userId, notificationType, subject, messageBody, priorityLevel]
      );

  broadcastToUser(userId, 'notification', result.rows[0]);
}

export async function createAndNotifyBatch(
  items: Array<{
    userId: number; notificationType: string; subject: string; messageBody: string; priorityLevel?: string;
  }>,
  client?: PoolClient,
): Promise<void> {
  if (items.length === 0) return;

  const n = items.length;
  const userArr = new Array<number>(n);
  const typeArr = new Array<string>(n);
  const subjArr = new Array<string>(n);
  const bodyArr = new Array<string>(n);
  const prioArr = new Array<string>(n);

  for (let i = 0; i < n; i++) {
    const item = items[i];
    userArr[i] = item.userId;
    typeArr[i] = item.notificationType;
    subjArr[i] = item.subject;
    bodyArr[i] = item.messageBody;
    prioArr[i] = item.priorityLevel ?? 'NORMAL';
  }

  const result = client
    ? await client.query(
        `INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, priority_level)
         SELECT unnest($1::int[]), unnest($2::text[]), unnest($3::text[]), unnest($4::text[]), unnest($5::text[])
         RETURNING *`,
        [userArr, typeArr, subjArr, bodyArr, prioArr]
      )
    : await query(
        `INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, priority_level)
         SELECT unnest($1::int[]), unnest($2::text[]), unnest($3::text[]), unnest($4::text[]), unnest($5::text[])
         RETURNING *`,
        [userArr, typeArr, subjArr, bodyArr, prioArr]
      );

  for (const row of result.rows) {
    broadcastToUser(row.user_id, 'notification', row);
  }
}
