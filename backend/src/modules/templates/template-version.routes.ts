import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { successResponse, errorResponse, paginatedResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { TemplateRepository } from '../../repositories/template.repository';
import { TemplateVersionRepository } from '../../repositories/template-version.repository';
import { VersionLifecycleService } from '../../services/template-version-lifecycle.service';
import type { AuthUser } from '../../shared/types';

const createVersionSchema = z.object({
  template_id: z.number().int().positive(),
  version: z.string().min(1),
  content: z.record(z.string(), z.record(z.string(), z.string())),
  content_hash: z.string().optional(),
  variable_definitions: z.array(z.any()).optional(),
  change_summary: z.string().optional(),
});

const updateVersionSchema = z.object({
  content: z.record(z.string(), z.record(z.string(), z.string())).optional(),
  content_hash: z.string().optional(),
  variable_definitions: z.array(z.any()).optional(),
  change_summary: z.string().optional(),
});

const submitSchema = z.object({ comment: z.string().optional() });
const approveSchema = z.object({ comment: z.string().optional() });
const rejectSchema = z.object({ reason: z.string().min(1) });
const deprecateSchema = z.object({ reason: z.string().optional() });
const archiveSchema = z.object({ reason: z.string().optional() });

const ADMIN_ROLES = ['SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'] as const;
const REVIEW_ROLES = ['ETHICS_ADMIN', 'ETHICS_CHAIR', 'ETHICS_REVIEWER'] as const;

async function resolveTemplateCode(templateRepo: TemplateRepository, version: { template_id: number }): Promise<string> {
  const template = await templateRepo.findById(version.template_id);
  if (!template) throw Object.assign(new Error('Template not found'), { status: 404 });
  return template.code;
}

export default function templateVersionRoutes(
  templateRepo: TemplateRepository,
  versionRepo: TemplateVersionRepository,
  lifecycleService: VersionLifecycleService,
) {
  const router = Router();

  router.get('/versions', authenticate, async (req: Request, res: Response) => {
    try {
      const { page, limit } = parsePagination(req.query);
      const templateId = req.query.template_id ? parseInt(req.query.template_id as string) : undefined;
      const status = req.query.status as string | undefined;
      const code = req.query.code as string | undefined;

      let versions = code ? await versionRepo.findByTemplateCode(code) : [];

      if (templateId && !code) {
        versions = await versionRepo.findByTemplateId(templateId);
      }

      if (status) {
        versions = versions.filter(v => v.status === status);
      }

      const total = versions.length;
      const start = (page - 1) * limit;
      const paged = versions.slice(start, start + limit);

      res.json(paginatedResponse(paged, total, page, limit));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.get('/versions/:id', authenticate, async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      const version = await versionRepo.findById(id);
      if (!version) return res.status(404).json(errorResponse('Version not found'));
      res.json(successResponse(version));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/versions', authenticate, authorize(...ADMIN_ROLES), validate(createVersionSchema), async (req: Request, res: Response) => {
    try {
      const user = (req as any).user as AuthUser;
      const version = await versionRepo.create({ ...req.body, created_by: user.id });
      res.status(201).json(successResponse(version));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.put('/versions/:id', authenticate, authorize(...ADMIN_ROLES), validate(updateVersionSchema), async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      const existing = await versionRepo.findById(id);
      if (!existing) return res.status(404).json(errorResponse('Version not found'));
      if (existing.status !== 'DRAFT') {
        return res.status(400).json(errorResponse('Only DRAFT versions can be updated'));
      }
      res.json(successResponse(existing));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/versions/:id/submit', authenticate, authorize(...ADMIN_ROLES), validate(submitSchema), async (req: Request, res: Response) => {
    try {
      const user = (req as any).user as AuthUser;
      const version = await versionRepo.findById(parseInt(req.params.id as string));
      if (!version) return res.status(404).json(errorResponse('Version not found'));
      const code = await resolveTemplateCode(templateRepo, version);
      const result = await lifecycleService.submit(code, version.version, user, req.body.comment);
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/versions/:id/approve', authenticate, authorize(...REVIEW_ROLES), validate(approveSchema), async (req: Request, res: Response) => {
    try {
      const user = (req as any).user as AuthUser;
      const version = await versionRepo.findById(parseInt(req.params.id as string));
      if (!version) return res.status(404).json(errorResponse('Version not found'));
      const code = await resolveTemplateCode(templateRepo, version);
      const result = await lifecycleService.approve(code, version.version, user, req.body.comment);
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/versions/:id/reject', authenticate, authorize(...REVIEW_ROLES), validate(rejectSchema), async (req: Request, res: Response) => {
    try {
      const user = (req as any).user as AuthUser;
      const version = await versionRepo.findById(parseInt(req.params.id as string));
      if (!version) return res.status(404).json(errorResponse('Version not found'));
      const code = await resolveTemplateCode(templateRepo, version);
      const result = await lifecycleService.reject(code, version.version, user, req.body.reason);
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/versions/:id/deprecate', authenticate, authorize(...ADMIN_ROLES), validate(deprecateSchema), async (req: Request, res: Response) => {
    try {
      const user = (req as any).user as AuthUser;
      const version = await versionRepo.findById(parseInt(req.params.id as string));
      if (!version) return res.status(404).json(errorResponse('Version not found'));
      const code = await resolveTemplateCode(templateRepo, version);
      const result = await lifecycleService.deprecate(code, version.version, user, req.body.reason);
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/versions/:id/archive', authenticate, authorize(...ADMIN_ROLES), validate(archiveSchema), async (req: Request, res: Response) => {
    try {
      const user = (req as any).user as AuthUser;
      const version = await versionRepo.findById(parseInt(req.params.id as string));
      if (!version) return res.status(404).json(errorResponse('Version not found'));
      const code = await resolveTemplateCode(templateRepo, version);
      const result = await lifecycleService.archive(code, version.version, user, req.body.reason);
      res.json(successResponse(result));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
