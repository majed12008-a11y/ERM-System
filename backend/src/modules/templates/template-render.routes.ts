import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { successResponse, errorResponse } from '../../shared/utils';
import { TemplateIntegrationService } from '../../services/template-integration.service';
import type { AuthUser } from '../../shared/types';

const renderSchema = z.object({
  templateCode: z.string().min(1),
  version: z.string().min(1),
  variables: z.record(z.string(), z.unknown()),
  locale: z.string().optional(),
  entityType: z.string().optional(),
  entityId: z.number().int().positive().optional(),
});

export default function templateRenderRoutes(integrationService: TemplateIntegrationService) {
  const router = Router();

  router.post('/template-render', authenticate, validate(renderSchema), async (req: Request, res: Response) => {
    try {
      const user = (req as any).user as AuthUser;
      const { templateCode, version, variables, locale, entityType, entityId } = req.body;
      const result = await integrationService.renderDocument({
        templateCode,
        version,
        variables,
        renderedBy: user.id,
        locale,
        entityType,
        entityId,
        userContext: { userId: user.id, userRoles: user.roles, locale },
      });
      res.json(successResponse({
        html: result.html,
        renderResult: result.renderResult,
        snapshot: result.snapshot,
        snapshotHash: result.snapshotHash,
      }));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
