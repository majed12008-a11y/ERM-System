import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { z } from 'zod';
import { successResponse, errorResponse } from '../../shared/utils';
import { TemplateDocumentService } from '../../services/template-document.service';

const ADMIN_ROLES = ['SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'] as const;

const previewDocumentSchema = z.object({
  templateCode: z.string().min(1),
  version: z.string().min(1),
  variables: z.record(z.string(), z.unknown()).optional(),
  locale: z.enum(['ar', 'en']).optional(),
});

const renderDocumentSchema = z.object({
  moduleKey: z.string().min(1),
  entityId: z.number().int().positive(),
  variables: z.record(z.string(), z.unknown()).optional(),
  locale: z.enum(['ar', 'en']).optional(),
});

export default function templateDocumentRoutes(documentService: TemplateDocumentService) {
  const router = Router();

  router.post('/preview', authenticate, authorize(...ADMIN_ROLES), validate(previewDocumentSchema), async (req: Request, res: Response) => {
    try {
      const { templateCode, version, variables, locale } = req.body;
      const result = await documentService.previewTemplate(templateCode, version, variables || {}, locale);
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/render', authenticate, authorize(...ADMIN_ROLES), validate(renderDocumentSchema), async (req: Request, res: Response) => {
    try {
      const { moduleKey, entityId, variables, locale } = req.body;
      const user = (req as any).user;
      const result = await documentService.renderByModuleKey(
        moduleKey,
        entityId,
        variables || {},
        user?.id || 0,
        locale,
      );
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.get('/module-keys', authenticate, async (_req: Request, res: Response) => {
    try {
      const keys = documentService.getModuleDocumentKeys();
      res.json(successResponse(keys));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.get('/module-config/:key', authenticate, async (req: Request, res: Response) => {
    try {
      const config = documentService.getModuleDocumentConfig(req.params.key as string);
      if (!config) {
        return res.status(404).json(errorResponse(`Module key "${req.params.key}" not found`));
      }
      res.json(successResponse(config));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
