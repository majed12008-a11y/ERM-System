import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createCommitteeSchema, updateCommitteeSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { CommitteeService } from '../../services/committee.service';

const router = Router();
const service = new CommitteeService();

router.get('/committee-types', authenticate, async (req: Request, res: Response) => {
  try {
    const types = await service.getTypes();
    res.json(successResponse(types));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const committees = await service.getAll();
    res.json(successResponse(committees));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.post('/', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), validate(createCommitteeSchema), async (req: Request, res: Response) => {
  try {
    const committee = await service.create(req.body, (req as any).user);
    res.status(201).json(successResponse(committee, 'Committee created'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), validate(updateCommitteeSchema), async (req: Request, res: Response) => {
  try {
    const committee = await service.update(parseInt(String(req.params.id)), req.body);
    res.json(successResponse(committee, 'Committee updated'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    const result = await service.deactivate(parseInt(String(req.params.id)));
    res.json(successResponse(null, 'Committee deactivated'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const committee = await service.getById(parseInt(String(req.params.id)));
    res.json(successResponse(committee));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
