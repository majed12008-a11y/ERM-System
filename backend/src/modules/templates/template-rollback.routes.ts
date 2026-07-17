import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { successResponse, errorResponse } from '../../shared/utils';
import { RollbackService } from '../../services/template-rollback.service';
import type { AuthUser } from '../../shared/types';

const rollbackSchema = z.object({
  templateCode: z.string().min(1),
  version: z.string().min(1),
  reason: z.string().optional(),
});

const ADMIN_ROLES = ['SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'] as const;

export default function templateRollbackRoutes(rollbackService: RollbackService) {
  const router = Router();

  router.post('/template-rollback', authenticate, authorize(...ADMIN_ROLES), validate(rollbackSchema), async (req: Request, res: Response) => {
    try {
      const user = (req as any).user as AuthUser;
      const { templateCode, version, reason } = req.body;
      const result = await rollbackService.executeRollback(templateCode, version, user, reason);
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
