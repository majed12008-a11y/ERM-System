import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { successResponse, errorResponse } from '../../shared/utils';
import { SnapshotService } from '../../services/template-snapshot.service';

const verifySchema = z.object({ hash: z.string().min(1) });

export default function templateSnapshotRoutes(snapshotService: SnapshotService) {
  const router = Router();

  router.get('/template-snapshots', authenticate, async (req: Request, res: Response) => {
    try {
      const templateVersionId = parseInt(req.query.templateVersionId as string);
      if (!templateVersionId) {
        return res.status(400).json(errorResponse('templateVersionId query parameter is required'));
      }
      const snapshots = await snapshotService.getHistory(templateVersionId);
      res.json(successResponse(snapshots));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.get('/template-snapshots/:hash', authenticate, async (req: Request, res: Response) => {
    try {
      const snapshot = await snapshotService.getSnapshotByHash(req.params.hash as string);
      if (!snapshot) return res.status(404).json(errorResponse('Snapshot not found'));
      res.json(successResponse(snapshot));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/template-snapshots/verify', authenticate, validate(verifySchema), async (req: Request, res: Response) => {
    try {
      const result = await snapshotService.verifySnapshot(req.body.hash);
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
