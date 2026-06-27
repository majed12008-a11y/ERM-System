/*
 * وحدة الإدارة: لوحة التحكم، إحصائيات النظام،
 * إعدادات البريد/الرسائل/الإشعارات، النسخ الاحتياطي،
 * إدارة البيانات المرجعية.
 */
import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse, paginatedResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { AdminService } from '../../services/admin.service';
import emailConfigRoutes from './email-config.routes';
import smsConfigRoutes from './sms-config.routes';
import pushConfigRoutes from './push-config.routes';
import systemConfigRoutes from './system-config.routes';
import backupRoutes from './backup.routes';
import referenceDataRoutes from './reference-data.routes';

const router = Router();
const service = new AdminService();

router.use('/email-config', emailConfigRoutes);
router.use('/sms-config', smsConfigRoutes);
router.use('/push-config', pushConfigRoutes);
router.use('/system-config', systemConfigRoutes);
router.use('/backup', backupRoutes);
router.use('/reference-data', referenceDataRoutes);

router.get('/stats', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getStats()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/audit-log', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    const { page, limit } = parsePagination(req.query);
    const { rows, total } = await service.getAuditLog({
      page, limit,
      action: req.query.action as string,
      userId: req.query.user_id ? parseInt(req.query.user_id as string) : undefined,
    });
    res.json(paginatedResponse(rows, total, page, limit));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/audit-log/actions', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getDistinctActions()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/online-users', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getOnlineUsers()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/recent-activity', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getRecentActivity()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
