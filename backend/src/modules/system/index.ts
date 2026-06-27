/*
 * وحدة النظام: عمليات البحث المحفوظة،
 * إعدادات المستخدم، وخدمات النظام العامة.
 */
import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { SystemService } from '../../services/system.service';

const router = Router();
const service = new SystemService();

router.get('/saved-searches', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getSavedSearches((req as any).user.id)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/saved-searches', authenticate, async (req: Request, res: Response) => {
  try {
    const { name, search_type, criteria, is_shared } = req.body;
    const result = await service.createSavedSearch((req as any).user.id, { name, search_type, criteria, is_shared });
    res.status(201).json(successResponse(result));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/saved-searches/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const { name, criteria, is_shared } = req.body;
    const result = await service.updateSavedSearch(Number(req.params.id), (req as any).user.id, { name, criteria, is_shared });
    if (!result) return res.status(404).json(errorResponse('Saved search not found'));
    res.json(successResponse(result));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/saved-searches/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const deleted = await service.deleteSavedSearch(Number(req.params.id), (req as any).user.id);
    if (!deleted) return res.status(404).json(errorResponse('Saved search not found'));
    res.json(successResponse(null, 'Saved search deleted'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/config', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getConfig()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
