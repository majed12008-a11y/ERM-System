import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { successResponse, errorResponse } from '../../shared/utils';
import { TemplateEngineService } from '../../services/template-engine.service';

const previewSchema = z.object({
  templateCode: z.string().min(1),
  version: z.string().min(1),
  variables: z.record(z.string(), z.unknown()),
  locale: z.string().optional(),
});

export default function templatePreviewRoutes(engineService: TemplateEngineService) {
  const router = Router();

  router.post('/template-preview', authenticate, validate(previewSchema), async (req: Request, res: Response) => {
    try {
      const { templateCode, version, variables, locale } = req.body;
      const renderResult = await engineService.render({
        templateCode,
        version,
        variables,
        locale,
      });
      res.json(successResponse({ html: renderResult.html, renderResult }));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
