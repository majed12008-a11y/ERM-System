import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { SmsConfigRepository } from '../../repositories/sms-config.repository';

const router = Router();
const repo = new SmsConfigRepository();

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
    if (!config) return res.status(404).json(errorResponse('SMS config not found'));
    res.json(successResponse(config));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', async (req: Request, res: Response) => {
  try {
    const { config_name, provider, api_key, api_secret, sender_name, is_active } = req.body;
    if (!config_name || !provider) {
      return res.status(400).json(errorResponse('config_name and provider are required'));
    }
    if (is_active) await repo.deactivateAll();
    const config = await repo.create({
      config_name, provider,
      api_key: api_key || '', api_secret: api_secret || '',
      sender_name: sender_name || '',
      is_active: is_active !== false,
    });
    res.status(201).json(successResponse(config, 'SMS config created'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/:id', async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id as string);
    if (isNaN(id)) return res.status(400).json(errorResponse('Invalid id'));
    const existing = await repo.findById(id);
    if (!existing) return res.status(404).json(errorResponse('SMS config not found'));
    const data: any = {};
    for (const key of ['config_name', 'provider', 'api_key', 'api_secret', 'sender_name', 'is_active']) {
      if (req.body[key] !== undefined) data[key] = req.body[key];
    }
    if (data.is_active === true) await repo.deactivateAll();
    const config = await repo.update(id, data);
    res.json(successResponse(config, 'SMS config updated'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/:id', async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id as string);
    if (isNaN(id)) return res.status(400).json(errorResponse('Invalid id'));
    const deleted = await repo.delete(id);
    if (!deleted) return res.status(404).json(errorResponse('SMS config not found'));
    res.json(successResponse(null, 'SMS config deleted'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
