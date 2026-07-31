import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createApplicationSchema, updateApplicationStatusSchema, updateApplicationSchema, withdrawApplicationSchema, appealApplicationSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { ApplicationService } from '../../services/application.service';
import { WorkflowService } from '../../services/workflow.service';

const router = Router();
const applicationService = new ApplicationService();
const workflowService = new WorkflowService();

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

// ── سحب الطلب (RESEARCHER فقط، عبر workflow transition) ──────────────────
router.post(
  '/:id/withdraw',
  authenticate,
  authorize('RESEARCHER'),
  validate(withdrawApplicationSchema),
  async (req: Request, res: Response) => {
    try {
      const app = await applicationService.withdrawApplication(
        parseInt(String(req.params.id)),
        req.body?.comment,
        (req as any).user
      );
      res.json(successResponse(app, 'Application withdrawn'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

// ── تقديم استئناف (RESEARCHER فقط، للطلبات المرفوضة) ───────────────────────
router.post(
  '/:id/appeal',
  authenticate,
  authorize('RESEARCHER'),
  validate(appealApplicationSchema),
  async (req: Request, res: Response) => {
    try {
      const app = await applicationService.appealDecision(
        parseInt(String(req.params.id)),
        req.body.comment,
        (req as any).user
      );
      res.json(successResponse(app, 'Appeal submitted successfully'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

// ── بدء التجديد السنوي (ETHICS_ADMIN / SUPER_ADMIN — ICH-GCP §3.3) ─────────
router.post(
  '/:id/renewal',
  authenticate,
  authorize('ETHICS_ADMIN', 'SUPER_ADMIN'),
  async (req: Request, res: Response) => {
    try {
      const app = await applicationService.initiateRenewal(
        parseInt(String(req.params.id)),
        (req as any).user
      );
      res.json(successResponse(app, 'Annual renewal initiated'));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

// ── حالة SLA للطلب الحالي (lazy-check) ─────────────────────────────────────
router.get(
  '/:id/sla',
  authenticate,
  async (req: Request, res: Response) => {
    try {
      const sla = await workflowService.getSLAStatus('Application', parseInt(String(req.params.id)));
      if (!sla) {
        return res.json(successResponse(null, 'No SLA defined for current state'));
      }
      res.json(successResponse(sla));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

// ── تاريخ Workflow الكامل للطلب ──────────────────────────────────────────────
router.get(
  '/:id/history',
  authenticate,
  async (req: Request, res: Response) => {
    try {
      const history = await workflowService.getHistory('Application', parseInt(String(req.params.id)));
      res.json(successResponse(history));
    } catch (err: any) {
      res.status(err.status || 500).json(errorResponse(err.message));
    }
  }
);

export default router;
