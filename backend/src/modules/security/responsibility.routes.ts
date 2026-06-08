import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { UsersService } from '../../services/users.service';

const router = Router();
const service = new UsersService();

router.get('/responsibility-types', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getResponsibilityTypes()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/user-responsibilities', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getUserResponsibilities((req as any).user)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/user-responsibilities', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createResponsibility(req.body, (req as any).user), 'Responsibility assigned'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/user-responsibilities/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    await service.deleteResponsibility(parseInt(String(req.params.id)));
    res.json(successResponse(null, 'Responsibility removed'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

export default router;
