import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createApplicationSchema, committeeDecisionSchema, updateApplicationStatusSchema, updateApplicationSchema, submitApplicationSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { ApplicationService } from '../../services/application.service';

const router = Router();
const applicationService = new ApplicationService();

router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const pagination = parsePagination(req.query as any);
    const status = String(req.query.status ?? '') || undefined;
    const result = await applicationService.getAll(pagination, (req as any).user, status);
    res.json({ success: true, ...result });
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const app = await applicationService.getById(parseInt(String(req.params.id)));
    res.json(successResponse(app));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post(
  '/',
  authenticate,
  authorize('RESEARCHER', 'INST_COORDINATOR'),
  validate(createApplicationSchema),
  async (req: Request, res: Response) => {
    try {
      const saveAsDraft = req.query.save_as_draft === 'true';
      const app = await applicationService.create({ ...req.body, save_as_draft: saveAsDraft }, (req as any).user);
      const msg = saveAsDraft ? 'Draft saved' : 'Application submitted';
      res.status(201).json(successResponse(app, msg));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

router.put(
  '/:id',
  authenticate,
  validate(updateApplicationSchema),
  async (req: Request, res: Response) => {
    try {
      const app = await applicationService.updateDraft(parseInt(String(req.params.id)), req.body, (req as any).user);
      res.json(successResponse(app, 'Draft updated'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

router.post(
  '/:id/submit',
  authenticate,
  validate(submitApplicationSchema),
  async (req: Request, res: Response) => {
    try {
      const app = await applicationService.submitDraft(parseInt(String(req.params.id)), req.body, (req as any).user);
      res.json(successResponse(app, 'Application submitted'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

router.patch('/:id/status', authenticate, validate(updateApplicationStatusSchema), async (req: Request, res: Response) => {
  try {
    const app = await applicationService.updateStatus(
      parseInt(String(req.params.id)),
      req.body,
      (req as any).user
    );
    res.json(successResponse(app, 'Status updated'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post(
  '/:id/committee-decision',
  authenticate,
  authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR'),
  validate(committeeDecisionSchema),
  async (req: Request, res: Response) => {
    try {
      const app = await applicationService.committeeDecision(
        parseInt(String(req.params.id)),
        req.body.decision,
        req.body.notes,
        (req as any).user
      );
      res.json(successResponse(app, `Application ${req.body.decision}`));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

export default router;
