import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createProjectSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { ProjectService } from '../../services/project.service';

const router = Router();
const service = new ProjectService();

router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const pagination = parsePagination(req.query as any);
    const result = await service.getAll(pagination, (req as any).user);
    res.json({ success: true, ...result });
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const project = await service.getById(parseInt(String(req.params.id)));
    res.json(successResponse(project));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/', authenticate, authorize('RESEARCHER', 'INST_COORDINATOR', 'ETHICS_ADMIN', 'ADMIN', 'SUPER_ADMIN'), validate(createProjectSchema), async (req: Request, res: Response) => {
  try {
    const project = await service.create(req.body, (req as any).user);
    res.status(201).json(successResponse(project, 'Project created'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/:id/applications', authenticate, async (req: Request, res: Response) => {
  try {
    const apps = await service.getApplications(parseInt(String(req.params.id)));
    res.json(successResponse(apps));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/:id/stats', authenticate, async (req: Request, res: Response) => {
  try {
    const stats = await service.getStats(parseInt(String(req.params.id)));
    res.json(successResponse(stats));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
