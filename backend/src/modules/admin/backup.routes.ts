import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { successResponse, errorResponse } from '../../shared/utils';
import { BackupService } from '../../services/backup.service';

const router = Router();
const service = new BackupService();

router.use(authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'));

const createSchema = z.object({
  label: z.string().max(100).optional(),
});

const rotateSchema = z.object({
  daily: z.number().int().min(1).max(365).optional(),
  weekly: z.number().int().min(0).max(52).optional(),
  monthly: z.number().int().min(0).max(12).optional(),
});

function paramName(req: Request): string {
  const n = req.params.name;
  return Array.isArray(n) ? n[0] : n;
}

router.get('/', async (_req: Request, res: Response) => {
  try {
    const backups = await service.list();
    res.json(successResponse(backups));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', validate(createSchema), async (req: Request, res: Response) => {
  try {
    const backup = await service.create(req.body.label);
    res.status(201).json(successResponse(backup, `Backup created: ${backup.name}`));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:name/verify', async (req: Request, res: Response) => {
  try {
    const result = await service.verify(paramName(req));
    res.json(successResponse(result, `Backup verified: ${result.backup}`));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:name/restore', async (req: Request, res: Response) => {
  try {
    const result = await service.restore(paramName(req));
    res.json(successResponse(result, `Restore completed. Pre-restore backup: ${result.pre_backup}`));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:name/download', async (req: Request, res: Response) => {
  try {
    const stream = service.getStream(paramName(req));
    res.setHeader('Content-Type', 'application/octet-stream');
    res.setHeader('Content-Disposition', `attachment; filename="${paramName(req)}"`);
    stream.pipe(res);
  } catch (err: any) { res.status(404).json(errorResponse(err.message)); }
});

router.delete('/:name', async (req: Request, res: Response) => {
  try {
    await service.delete(paramName(req));
    res.json(successResponse(null, `Backup deleted: ${paramName(req)}`));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/rotate', validate(rotateSchema), async (req: Request, res: Response) => {
  try {
    const result = await service.rotate({
      daily: req.body.daily,
      weekly: req.body.weekly,
      monthly: req.body.monthly,
    });
    res.json(successResponse(result, `Rotation complete: ${result.deleted.length} deleted, ${result.kept.length} kept`));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
