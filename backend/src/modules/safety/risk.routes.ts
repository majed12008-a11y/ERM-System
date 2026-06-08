import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { SafetyService } from '../../services/safety.service';

const router = Router();
const service = new SafetyService();

router.get('/risk-register', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getRiskRegister((req as any).user))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/risk-register', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try { res.status(201).json(successResponse(await service.createRisk(req.body, (req as any).user))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/risk-register/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.updateRisk(parseInt(String(req.params.id)), req.body))); }
  catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.delete('/risk-register/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    await service.softDeleteRisk(parseInt(String(req.params.id)));
    res.json(successResponse(null, 'Risk deleted'));
  }
  catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/risk-register/:id/mitigations', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getMitigations(parseInt(String(req.params.id))))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/risk-register/:id/mitigations', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try { res.status(201).json(successResponse(await service.createMitigation(parseInt(String(req.params.id)), req.body))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/risk-incidents', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getIncidents())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/risk-incidents', authenticate, async (req: Request, res: Response) => {
  try { res.status(201).json(successResponse(await service.createIncident(req.body, (req as any).user))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/corrective-actions', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getCorrectiveActions())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/corrective-actions', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try { res.status(201).json(successResponse(await service.createCorrectiveAction(req.body))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
