import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { AuthorizationService } from '../../services/authorization.service';

const router = Router();
const service = new AuthorizationService();

router.get('/', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getRoles()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getRole(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/', authenticate, authorize('SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createRole(req.body)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/:id', authenticate, authorize('SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.updateRole(parseInt(String(req.params.id)), req.body), 'Role updated'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

export default router;
