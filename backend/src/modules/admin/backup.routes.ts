import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { BackupService } from '../../services/backup.service';

const router = Router();
const service = new BackupService();

router.use(authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN'));

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

router.post('/', async (req: Request, res: Response) => {
  try {
    const label = req.body.label as string | undefined;
    const backup = await service.create(label);
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

export default router;
