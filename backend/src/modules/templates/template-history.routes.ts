import { Router, Request, Response } from 'express';
import { authenticate } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { VersionLifecycleService } from '../../services/template-version-lifecycle.service';

export default function templateHistoryRoutes(lifecycleService: VersionLifecycleService) {
  const router = Router();

  router.get('/template-history', authenticate, async (req: Request, res: Response) => {
    try {
      const templateCode = req.query.templateCode as string;
      const version = req.query.version as string;

      if (!templateCode || !version) {
        return res.status(400).json(errorResponse('templateCode and version query parameters are required'));
      }

      const history = await lifecycleService.getTransitionHistory(templateCode, version);
      res.json(successResponse(history));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
