import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { SafetyService } from '../../services/safety.service';
import riskRoutes from './risk.routes';

const router = Router();
const service = new SafetyService();

router.get('/adverse-events', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getAdverseEvents((req as any).user))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/serious-adverse-events', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getSeriousAdverseEvents())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/safety-reports', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getSafetyReports())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.use('/', riskRoutes);

export default router;
