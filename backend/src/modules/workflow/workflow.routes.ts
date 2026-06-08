import { Router, Request, Response } from 'express';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { executeTransitionSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { WorkflowService } from '../../services/workflow.service';

const router = Router();
const service = new WorkflowService();

router.get('/definitions', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getDefinitions()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/instances/:entityType/:entityId', authenticate, async (req: Request, res: Response) => {
  try {
    const instance = await service.getInstance(String(req.params.entityType), parseInt(String(req.params.entityId)));
    res.json(successResponse(instance));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/available-transitions/:entityType/:entityId', authenticate, async (req: Request, res: Response) => {
  try {
    const result = await service.getAvailableTransitions(String(req.params.entityType), parseInt(String(req.params.entityId)), (req as any).user);
    res.json(successResponse(result));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/execute-transition', authenticate, validate(executeTransitionSchema), async (req: Request, res: Response) => {
  try {
    if (!req.body.entity_type || !req.body.entity_id || !req.body.transition_code) {
      return res.status(400).json(errorResponse('entity_type, entity_id, and transition_code required'));
    }
    const result = await service.executeTransition(
      req.body.entity_type,
      req.body.entity_id,
      req.body.transition_code,
      (req as any).user,
      req.body.comment
    );
    res.json(successResponse(result, 'Transition executed'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
