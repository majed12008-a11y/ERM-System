import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { upsertProfileSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { UsersService } from '../../services/users.service';

const router = Router();
const service = new UsersService();

router.get('/profile', authenticate, async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const profile = await service.getProfile(user.id, false);
    res.json(successResponse(profile));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.put('/profile', authenticate, validate(upsertProfileSchema), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const result = await service.upsertProfile(user.id, req.body);
    res.json(successResponse(result, 'Profile updated'));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/profile/:userId', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    const profile = await service.getProfile(parseInt(String(req.params.userId)), true);
    if (!profile) return res.status(404).json(errorResponse('Profile not found'));
    res.json(successResponse(profile));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

export default router;
