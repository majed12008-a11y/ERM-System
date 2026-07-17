import { Router, Request, Response } from 'express';
import { z } from 'zod';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { successResponse, errorResponse, paginatedResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { TemplateRepository } from '../../repositories/template.repository';

const createTemplateSchema = z.object({
  category_id: z.number().int().positive(),
  code: z.string().min(1).max(100),
  name_ar: z.string().min(1),
  name_en: z.string().min(1),
  description: z.string().optional(),
  engine: z.string().optional(),
  default_locale: z.string().optional(),
  tags: z.array(z.string()).optional(),
  variable_sources: z.any().optional(),
});

const updateTemplateSchema = z.object({
  name_ar: z.string().min(1).optional(),
  name_en: z.string().min(1).optional(),
  description: z.string().optional(),
  tags: z.array(z.string()).optional(),
  variable_sources: z.any().optional(),
  is_active: z.boolean().optional(),
});

const ADMIN_ROLES = ['SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'] as const;

export default function templateRoutes(
  templateRepo: TemplateRepository,
) {
  const router = Router();

  router.get('/', authenticate, async (req: Request, res: Response) => {
    try {
      const { page, limit } = parsePagination(req.query);
      const q = req.query.q as string | undefined;
      const categoryId = req.query.category_id ? parseInt(req.query.category_id as string) : undefined;
      const { rows, total } = await templateRepo.findAll({ page, limit }, q);
      const filtered = categoryId ? rows.filter((r: any) => r.category_id === categoryId) : rows;
      res.json(paginatedResponse(filtered, categoryId ? filtered.length : total, page, limit));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.get('/:id', authenticate, async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      const template = await templateRepo.findById(id);
      if (!template) return res.status(404).json(errorResponse('Template not found'));
      res.json(successResponse(template));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.post('/', authenticate, authorize(...ADMIN_ROLES), validate(createTemplateSchema), async (req: Request, res: Response) => {
    try {
      const template = await templateRepo.create(req.body);
      res.status(201).json(successResponse(template));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.put('/:id', authenticate, authorize(...ADMIN_ROLES), validate(updateTemplateSchema), async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      const template = await templateRepo.update(id, req.body);
      if (!template) return res.status(404).json(errorResponse('Template not found'));
      res.json(successResponse(template));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.delete('/:id', authenticate, authorize(...ADMIN_ROLES), async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      const deleted = await templateRepo.softDelete(id);
      if (!deleted) return res.status(404).json(errorResponse('Template not found'));
      res.json(successResponse({ deleted: true }));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
