import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createPushConfigSchema, updatePushConfigSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { PushConfigRepository } from '../../repositories/push-config.repository';

const router = Router();
const repo = new PushConfigRepository();

router.use(authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'));

router.get('/', async (_req: Request, res: Response) => {
  try {
    const configs = await repo.findAll();
    res.json(successResponse(configs));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/active', async (_req: Request, res: Response) => {
  try {
    const config = await repo.findActive();
    res.json(successResponse(config));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:id', async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id as string);
    if (isNaN(id)) return res.status(400).json(errorResponse('Invalid id'));
    const config = await repo.findById(id);
    if (!config) return res.status(404).json(errorResponse('Push config not found'));
    res.json(successResponse(config));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', validate(createPushConfigSchema), async (req: Request, res: Response) => {
  try {
    if (req.body.is_active) await repo.deactivateAll();
    const config = await repo.create(req.body);
    res.status(201).json(successResponse(config, 'Push config created'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/:id', validate(updatePushConfigSchema), async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id as string);
    if (isNaN(id)) return res.status(400).json(errorResponse('Invalid id'));
    const existing = await repo.findById(id);
    if (!existing) return res.status(404).json(errorResponse('Push config not found'));
    if (req.body.is_active === true) await repo.deactivateAll();
    const config = await repo.update(id, req.body);
    res.json(successResponse(config, 'Push config updated'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/:id', async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id as string);
    if (isNaN(id)) return res.status(400).json(errorResponse('Invalid id'));
    const deleted = await repo.delete(id);
    if (!deleted) return res.status(404).json(errorResponse('Push config not found'));
    res.json(successResponse(null, 'Push config deleted'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
