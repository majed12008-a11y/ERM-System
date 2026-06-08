import { Router, Request, Response } from 'express';
import { query } from '../../config/database';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { MonitoringService } from '../../services/monitoring.service';

const router = Router();
const service = new MonitoringService();

router.get('/health', async (req: Request, res: Response) => {
  try {
    await query('SELECT 1');
    res.json(successResponse({ status: 'healthy', timestamp: new Date().toISOString() }));
  } catch (err: any) {
    res.status(503).json(errorResponse('Database unhealthy'));
  }
});

router.get('/audit', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN'), async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getAuditLogs())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/config', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN'), async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getSystemConfig())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
