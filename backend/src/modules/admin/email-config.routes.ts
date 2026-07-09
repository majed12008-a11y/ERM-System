import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createEmailConfigSchema, updateEmailConfigSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { EmailConfigRepository } from '../../repositories/email-config.repository';
import { clearTransportCache, sendEmail } from '../../services/email.service';

const router = Router();
const repo = new EmailConfigRepository();

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
    if (!config) return res.status(404).json(errorResponse('Email config not found'));
    res.json(successResponse(config));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', validate(createEmailConfigSchema), async (req: Request, res: Response) => {
  try {
    if (req.body.is_active) await repo.deactivateAll();
    const config = await repo.create(req.body);
    clearTransportCache();
    res.status(201).json(successResponse(config, 'Email config created'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/:id', validate(updateEmailConfigSchema), async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id as string);
    if (isNaN(id)) return res.status(400).json(errorResponse('Invalid id'));
    const existing = await repo.findById(id);
    if (!existing) return res.status(404).json(errorResponse('Email config not found'));
    if (req.body.is_active === true) await repo.deactivateAll();
    const config = await repo.update(id, req.body);
    clearTransportCache();
    res.json(successResponse(config, 'Email config updated'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/:id', async (req: Request, res: Response) => {
  try {
    const id = parseInt(req.params.id as string);
    if (isNaN(id)) return res.status(400).json(errorResponse('Invalid id'));
    const deleted = await repo.delete(id);
    if (!deleted) return res.status(404).json(errorResponse('Email config not found'));
    clearTransportCache();
    res.json(successResponse(null, 'Email config deleted'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/test', async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const sent = await sendEmail({
      to: user.email,
      subject: 'Test email from ERM System',
      text: 'This is a test email to verify your SMTP configuration. If you received this, your SMTP settings are working correctly.',
    });
    if (!sent) return res.status(500).json(errorResponse('Failed to send test email — check SMTP configuration'));
    res.json(successResponse(null, 'Test email sent successfully'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
