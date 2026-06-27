import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createTermSchema, createQualificationSchema, createConflictSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { CommitteeService } from '../../services/committee.service';

const router = Router();
const service = new CommitteeService();

router.get('/:memberId/terms', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getTerms(parseInt(String(req.params.memberId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:memberId/terms', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), validate(createTermSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createTerm(parseInt(String(req.params.memberId)), req.body)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:memberId/qualifications', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getQualifications(parseInt(String(req.params.memberId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:memberId/qualifications', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN'), validate(createQualificationSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createQualification(parseInt(String(req.params.memberId)), req.body, (req as any).user)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:memberId/conflicts', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getConflicts(parseInt(String(req.params.memberId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:memberId/conflicts', authenticate, validate(createConflictSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createConflict(parseInt(String(req.params.memberId)), req.body, (req as any).user)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
