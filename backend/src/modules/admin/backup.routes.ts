import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { successResponse, errorResponse } from '../../shared/utils';
import { BackupService, ValidationError, FileNotFoundError, PermissionError, ExecutionError, TimeoutError, BackupIntegrityError } from '../../services/backup.service';

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

const BACKUP_NAME_REGEX = /^[a-zA-Z0-9_.-]+$/;

export const backupNameSchema = z.string()
  .min(1, 'Backup name is required')
  .max(128, 'Backup name must be at most 128 characters')
  .regex(BACKUP_NAME_REGEX, 'Backup name contains invalid characters. Allowed: A-Z, a-z, 0-9, _, -, .');

function paramName(req: Request): string {
  const n = req.params.name;
  return Array.isArray(n) ? n[0] : n;
}

function validatedName(req: Request): string {
  const raw = paramName(req);
  return backupNameSchema.parse(raw);
}

function handleError(res: Response, err: any): void {
  if (err instanceof ValidationError) {
    res.status(400).json(errorResponse(err.message));
  } else if (err instanceof PermissionError) {
    res.status(403).json(errorResponse(err.message));
  } else if (err instanceof FileNotFoundError) {
    res.status(404).json(errorResponse(err.message));
  } else if (err instanceof TimeoutError) {
    res.status(504).json(errorResponse(err.message));
  } else if (err instanceof ExecutionError || err instanceof BackupIntegrityError) {
    res.status(500).json(errorResponse(err.message));
  } else if (err instanceof z.ZodError) {
    const messages = err.issues.map((e: any) => `${e.path.join('.')}: ${e.message}`).join('; ');
    res.status(400).json(errorResponse(messages));
  } else {
    res.status(500).json(errorResponse(err.message || 'Internal server error'));
  }
}

router.get('/', async (_req: Request, res: Response) => {
  try {
    const backups = await service.list();
    res.json(successResponse(backups));
  } catch (err: any) { handleError(res, err); }
});

router.post('/', validate(createSchema), async (req: Request, res: Response) => {
  try {
    const backup = await service.create(req.body.label);
    res.status(201).json(successResponse(backup, `Backup created: ${backup.name}`));
  } catch (err: any) { handleError(res, err); }
});

router.post('/:name/verify', async (req: Request, res: Response) => {
  try {
    const name = validatedName(req);
    const result = await service.verify(name);
    res.json(successResponse(result, `Backup verified: ${result.backup}`));
  } catch (err: any) { handleError(res, err); }
});

router.post('/:name/restore', async (req: Request, res: Response) => {
  try {
    const name = validatedName(req);
    const result = await service.restore(name);
    res.json(successResponse(result, `Restore completed. Pre-restore backup: ${result.pre_backup}`));
  } catch (err: any) { handleError(res, err); }
});

router.get('/:name/download', async (req: Request, res: Response) => {
  try {
    const name = validatedName(req);
    const stream = service.getStream(name);
    res.setHeader('Content-Type', 'application/octet-stream');
    res.setHeader('Content-Disposition', `attachment; filename="${name}"`);
    stream.pipe(res);
  } catch (err: any) {
    if (err instanceof FileNotFoundError || err instanceof ValidationError) {
      res.status(404).json(errorResponse(err.message));
    } else {
      handleError(res, err);
    }
  }
});

router.delete('/:name', async (req: Request, res: Response) => {
  try {
    const name = validatedName(req);
    await service.delete(name);
    res.json(successResponse(null, `Backup deleted: ${name}`));
  } catch (err: any) { handleError(res, err); }
});

router.post('/rotate', validate(rotateSchema), async (req: Request, res: Response) => {
  try {
    const result = await service.rotate({
      daily: req.body.daily,
      weekly: req.body.weekly,
      monthly: req.body.monthly,
    });
    res.json(successResponse(result, `Rotation complete: ${result.deleted.length} deleted, ${result.kept.length} kept`));
  } catch (err: any) { handleError(res, err); }
});

export default router;
