import { Router, Request, Response } from 'express';
import { authenticate } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { TemplateCategoryRepository } from '../../repositories/template-category.repository';

export default function templateCategoriesRoutes(categoryRepo: TemplateCategoryRepository) {
  const router = Router();

  router.get('/', authenticate, async (req: Request, res: Response) => {
    try {
      const categories = await categoryRepo.findAll();
      res.json(successResponse(categories));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  router.get('/:id', authenticate, async (req: Request, res: Response) => {
    try {
      const id = parseInt(req.params.id as string);
      const category = await categoryRepo.findById(id);
      if (!category) return res.status(404).json(errorResponse('Category not found'));
      res.json(successResponse(category));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  });

  return router;
}
