import { Router, Request, Response, NextFunction } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createUserSchema, updateUserSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { UsersService } from '../../services/users.service';

const router = Router();
const service = new UsersService();

const adminRoles = ['SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'];

router.get('/', authenticate, authorize(...adminRoles), async (req: Request, res: Response) => {
  try {
    const params = parsePagination(req.query);
    const result = await service.getAll(params);
    res.json({ success: true, ...result });
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/:id', authenticate, async (req: Request, res: Response, next: NextFunction) => {
  const targetId = parseInt(String(req.params.id));
  const currentUser = (req as any).user;
  if (targetId !== currentUser.id && !currentUser.roles?.some((r: string) => adminRoles.includes(r))) {
    return res.status(403).json(errorResponse('Access denied'));
  }
  next();
}, async (req: Request, res: Response) => {
  try {
    const user = await service.getById(parseInt(String(req.params.id)));
    res.json(successResponse(user));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), validate(createUserSchema), async (req: Request, res: Response) => {
  try {
    const user = await service.create(req.body, (req as any).user);
    res.status(201).json(successResponse(user, 'User created'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), validate(updateUserSchema), async (req: Request, res: Response) => {
  try {
    const user = await service.update(parseInt(String(req.params.id)), req.body, (req as any).user);
    res.json(successResponse(user, 'User updated'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
