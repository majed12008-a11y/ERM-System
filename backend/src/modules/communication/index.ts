/*
 * وحدة المراسلات: إدارة الرسائل الداخلية بين المستخدمين
 * ونظام الإشعارات الفورية (SSE) للوحة التحكم.
 */
import { Router, Request, Response } from 'express';
import { authenticate } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { addClient } from '../../services/notification.service';
import { CommunicationService } from '../../services/communication.service';
import messagesRoutes from './messages.routes';

const router = Router();
const service = new CommunicationService();

router.use(messagesRoutes);

// Notifications
router.get('/notifications', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getNotifications((req as any).user.id)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.patch('/notifications/:id/read', authenticate, async (req: Request, res: Response) => {
  try {
    await service.markNotificationRead(Number(req.params.id), (req as any).user.id);
    res.json(successResponse(null, 'Marked as read'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.patch('/notifications/read-all', authenticate, async (req: Request, res: Response) => {
  try {
    await service.markAllNotificationsRead((req as any).user.id);
    res.json(successResponse(null, 'All marked as read'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/notifications/:id', authenticate, async (req: Request, res: Response) => {
  try {
    await service.deleteNotification(Number(req.params.id), (req as any).user.id);
    res.json(successResponse(null, 'Notification deleted'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

// SSE stream
router.get('/notifications/stream', async (req: Request, res: Response) => {
  try {
    const token = req.query.token as string;
    if (!token) { res.status(401).json(errorResponse('Token required')); return; }

    const { jwtVerify } = await import('jose');
    const { env } = await import('../../config/env');
    const secret = new TextEncoder().encode(env.JWT_SECRET);
    let payload: { userId: number };
    try {
      const result = await jwtVerify(token, secret);
      payload = result.payload as unknown as { userId: number };
    } catch {
      res.status(401).json(errorResponse('Invalid token')); return;
    }

    res.writeHead(200, {
      'Content-Type': 'text/event-stream',
      'Cache-Control': 'no-cache',
      'Connection': 'keep-alive',
      'X-Accel-Buffering': 'no',
    });

    res.write(`event: connected\ndata: {"userId": ${payload.userId}}\n\n`);
    addClient(payload.userId, res);

    const heartbeat = setInterval(() => {
      try { res.write(`event: ping\ndata: {}\n\n`); } catch { clearInterval(heartbeat); }
    }, 30000);

    req.on('close', () => clearInterval(heartbeat));
  } catch (err: any) {
    if (!res.headersSent) res.status(500).json(errorResponse(err.message));
  }
});

export default router;
