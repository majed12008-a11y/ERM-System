import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { AuthorizationService } from '../../services/authorization.service';

const router = Router();
const service = new AuthorizationService();

router.get('/', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getPermissions()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', authenticate, authorize('SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createPermission(req.body), 'Permission created'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/:id', authenticate, authorize('SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await service.deletePermission(parseInt(String(req.params.id)));
    res.json(successResponse(null, 'Permission deleted'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/role/:roleId', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getRolePermissions(parseInt(String(req.params.roleId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/role/:roleId', authenticate, authorize('SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    const { permission_ids } = req.body;
    await service.setRolePermissions(parseInt(String(req.params.roleId)), permission_ids);
    res.json(successResponse(null, 'Role permissions updated'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
