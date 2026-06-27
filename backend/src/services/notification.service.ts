/*
 * نظام الإشعارات: إرسال إشعارات عبر Server-Sent Events (SSE)،
 * إنشاء إشعارات في قاعدة البيانات، وإذاعة الأحداث
 * للوحة التحكم للمستخدمين المتصلين.
 */
import { Response } from 'express';
import { PoolClient } from 'pg';
import { query } from '../config/database';

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

  res.on('close', () => {
    const userClients = clients.get(userId);
    if (userClients) {
      const idx = userClients.findIndex(c => c.res === res);
      if (idx !== -1) userClients.splice(idx, 1);
      if (userClients.length === 0) clients.delete(userId);
    }
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
