import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { IntegrationService } from '../../services/integration.service';

const router = Router();
const service = new IntegrationService();

router.get('/events', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getEvents()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/logs', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getLogs()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
