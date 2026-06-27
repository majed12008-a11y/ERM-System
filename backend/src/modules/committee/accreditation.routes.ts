import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import {
  createCycleSchema, updateCycleStatusSchema, createAssessmentSchema,
  updateAssessmentItemsSchema, createEvidenceSchema, updateEvidenceStatusSchema,
  createDecisionSchema, createConditionSchema, resolveConditionSchema
} from '../../shared/accreditation.schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { AccreditationService } from '../../services/accreditation.service';

const router = Router();
const service = new AccreditationService();

// --- Cycles ---
router.get('/cycles', authenticate, async (_req: Request, res: Response) => {
  try {
    const cycles = await service.getCycles();
    res.json(successResponse(cycles));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/cycles/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const cycle = await service.getCycle(Number(req.params.id));
    res.json(successResponse(cycle));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/cycles', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), validate(createCycleSchema), async (req: Request, res: Response) => {
  try {
    const cycle = await service.createCycle(req.body);
    res.status(201).json(successResponse(cycle));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.patch('/cycles/:id/status', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), validate(updateCycleStatusSchema), async (req: Request, res: Response) => {
  try {
    const result = await service.updateCycleStatus(Number(req.params.id), req.body);
    res.json(successResponse(result));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.delete('/cycles/:id', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    await service.deleteCycle(Number(req.params.id));
    res.json(successResponse(null));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

// --- Standards ---
router.get('/standards', authenticate, async (req: Request, res: Response) => {
  try {
    const activeOnly = req.query.active_only === 'true';
    const standards = await service.getStandards(activeOnly);
    res.json(successResponse(standards));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

// --- Assessments ---
router.get('/cycles/:cycleId/assessments', authenticate, async (req: Request, res: Response) => {
  try {
    const assessments = await service.getAssessments(Number(req.params.cycleId));
    res.json(successResponse(assessments));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/assessments/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const assessment = await service.getAssessment(Number(req.params.id));
    res.json(successResponse(assessment));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/cycles/:cycleId/assessments', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), validate(createAssessmentSchema), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const assessment = await service.createAssessment({ ...req.body, cycle_id: Number(req.params.cycleId), assessed_by: user.id });
    res.status(201).json(successResponse(assessment));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.put('/assessments/:id/items', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), validate(updateAssessmentItemsSchema), async (req: Request, res: Response) => {
  try {
    const assessment = await service.updateAssessmentItems(Number(req.params.id), req.body.items);
    res.json(successResponse(assessment));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.delete('/assessments/:id', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    await service.deleteAssessment(Number(req.params.id));
    res.json(successResponse(null));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

// --- Evidence ---
router.get('/cycles/:cycleId/evidence', authenticate, async (req: Request, res: Response) => {
  try {
    const evidence = await service.getEvidence(Number(req.params.cycleId));
    res.json(successResponse(evidence));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/evidence/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const evidence = await service.getEvidenceItem(Number(req.params.id));
    res.json(successResponse(evidence));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/cycles/:cycleId/evidence', authenticate, validate(createEvidenceSchema), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const evidence = await service.createEvidence({ ...req.body, cycle_id: Number(req.params.cycleId), uploaded_by: user.id });
    res.status(201).json(successResponse(evidence));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.patch('/evidence/:id/status', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), validate(updateEvidenceStatusSchema), async (req: Request, res: Response) => {
  try {
    const evidence = await service.updateEvidenceStatus(Number(req.params.id), req.body.status, req.body.reviewed_by, req.body.review_notes);
    res.json(successResponse(evidence));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.delete('/evidence/:id', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    await service.deleteEvidence(Number(req.params.id));
    res.json(successResponse(null));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

// --- Conditions ---
router.get('/cycles/:cycleId/conditions', authenticate, async (req: Request, res: Response) => {
  try {
    const conditions = await service.getConditions(Number(req.params.cycleId));
    res.json(successResponse(conditions));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/conditions/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const condition = await service.getCondition(Number(req.params.id));
    res.json(successResponse(condition));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/cycles/:cycleId/conditions', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), validate(createConditionSchema), async (req: Request, res: Response) => {
  try {
    const condition = await service.createCondition({ ...req.body, cycle_id: Number(req.params.cycleId) });
    res.status(201).json(successResponse(condition));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.patch('/conditions/:id/status', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), validate(resolveConditionSchema), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const condition = await service.resolveCondition(Number(req.params.id), req.body.status, req.body.resolved_by || user.id);
    res.json(successResponse(condition));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

// --- Decisions ---
router.get('/cycles/:cycleId/decisions', authenticate, async (req: Request, res: Response) => {
  try {
    const decisions = await service.getDecisions(Number(req.params.cycleId));
    res.json(successResponse(decisions));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/decisions/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const decision = await service.getDecision(Number(req.params.id));
    res.json(successResponse(decision));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/cycles/:cycleId/decisions', authenticate, authorize('SUPER_ADMIN', 'ETHICS_ADMIN'), validate(createDecisionSchema), async (req: Request, res: Response) => {
  try {
    const decision = await service.createDecision({ ...req.body, cycle_id: Number(req.params.cycleId) });
    res.status(201).json(successResponse(decision));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

export default router;
