import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createConditionSchema, updateConditionSchema, resolveConditionSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { ConditionService } from '../../services/condition.service';
import { ConditionRepository } from '../../repositories/condition.repository';

const router = Router({ mergeParams: true });
const service = new ConditionService(new ConditionRepository());

router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const conditions = await service.getConditions(parseInt(String(req.params.applicationId)));
    res.json(successResponse(conditions));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post(
  '/',
  authenticate,
  authorize('ETHICS_ADMIN', 'SUPER_ADMIN'),
  validate(createConditionSchema),
  async (req: Request, res: Response) => {
    try {
      const condition = await service.createCondition(
        parseInt(String(req.params.applicationId)),
        req.body,
        (req as any).user
      );
      res.status(201).json(successResponse(condition, 'Condition created'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

router.put(
  '/:id',
  authenticate,
  authorize('ETHICS_ADMIN', 'SUPER_ADMIN'),
  validate(updateConditionSchema),
  async (req: Request, res: Response) => {
    try {
      const condition = await service.updateCondition(
        parseInt(String(req.params.id)),
        req.body,
        (req as any).user
      );
      res.json(successResponse(condition, 'Condition updated'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

router.patch(
  '/:id/resolve',
  authenticate,
  authorize('ETHICS_ADMIN', 'SUPER_ADMIN'),
  validate(resolveConditionSchema),
  async (req: Request, res: Response) => {
    try {
      const condition = await service.resolveCondition(
        parseInt(String(req.params.id)),
        req.body.status,
        (req as any).user
      );
      res.json(successResponse(condition, 'Condition resolved'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

router.delete(
  '/:id',
  authenticate,
  authorize('ETHICS_ADMIN', 'SUPER_ADMIN'),
  async (req: Request, res: Response) => {
    try {
      await service.deleteCondition(parseInt(String(req.params.id)), (req as any).user);
      res.json(successResponse(null, 'Condition deleted'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

import evidenceRoutes from './evidence.routes';

router.use('/:conditionId/evidence', evidenceRoutes);

router.get('/summary', authenticate, async (req: Request, res: Response) => {
  try {
    const evaluation = await service.evaluate(parseInt(String(req.params.applicationId)));
    res.json(successResponse(evaluation));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
