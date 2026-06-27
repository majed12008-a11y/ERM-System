import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createEthicsRiskAssessmentSchema, addRiskItemSchema, updateRiskItemSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { EthicsRiskRepository } from '../../repositories/ethics-risk.repository';

const router = Router();
const repo = new EthicsRiskRepository();

router.get('/categories', authenticate, async (_req: Request, res: Response) => {
  try {
    res.json(successResponse(await repo.getRiskCategories()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/application/:applicationId', authenticate, async (req: Request, res: Response) => {
  try {
    const assessment = await repo.getAssessment(parseInt(String(req.params.applicationId)));
    if (!assessment) return res.status(404).json(errorResponse('No risk assessment found'));
    res.json(successResponse(assessment));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/my', authenticate, async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    res.json(successResponse(await repo.getAssessmentsByReviewer(user.id)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'REVIEWER', 'SUPER_ADMIN'), validate(createEthicsRiskAssessmentSchema), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const assessment = await repo.createAssessment(req.body, user.id);
    res.status(201).json(successResponse(assessment));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.put('/:id', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    const assessment = await repo.updateAssessment(parseInt(String(req.params.id)), req.body);
    if (!assessment) return res.status(404).json(errorResponse('Assessment not found'));
    res.json(successResponse(assessment));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/:id', authenticate, authorize('ETHICS_ADMIN', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await repo.softDelete(parseInt(String(req.params.id)));
    res.json(successResponse(null, 'Assessment deleted'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:assessmentId/items', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'REVIEWER', 'SUPER_ADMIN'), validate(addRiskItemSchema), async (req: Request, res: Response) => {
  try {
    const item = await repo.addRiskItem(parseInt(String(req.params.assessmentId)), req.body);
    res.status(201).json(successResponse(item));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.put('/items/:itemId', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'REVIEWER', 'SUPER_ADMIN'), validate(updateRiskItemSchema), async (req: Request, res: Response) => {
  try {
    const item = await repo.updateRiskItem(parseInt(String(req.params.itemId)), req.body);
    if (!item) return res.status(404).json(errorResponse('Item not found'));
    res.json(successResponse(item));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/items/:itemId', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await repo.deleteRiskItem(parseInt(String(req.params.itemId)));
    res.json(successResponse(null, 'Item deleted'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
