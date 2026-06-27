import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import {
  createConsentTemplateSchema, updateConsentTemplateSchema,
  createConsentVersionSchema, updateConsentVersionSchema,
  assignConsentSchema, replaceConsentVersionSchema,
  createConsentReviewSchema, updateConsentReviewSchema
} from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { ConsentTemplateRepository } from '../../repositories/consent-template.repository';
import { ConsentVersionRepository } from '../../repositories/consent-version.repository';
import { ApplicationConsentRepository } from '../../repositories/application-consent.repository';
import { ConsentReviewRepository } from '../../repositories/consent-review.repository';

const router = Router();
const templateRepo = new ConsentTemplateRepository();
const versionRepo = new ConsentVersionRepository();
const appConsentRepo = new ApplicationConsentRepository();
const reviewRepo = new ConsentReviewRepository();

// ========================
// CONSENT TEMPLATES
// ========================

router.get('/templates', authenticate, async (_req: Request, res: Response) => {
  try { res.json(successResponse(await templateRepo.findAll())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/templates/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const template = await templateRepo.findById(parseInt(String(req.params.id)));
    if (!template) return res.status(404).json(errorResponse('Template not found'));
    res.json(successResponse(template));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/templates', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(createConsentTemplateSchema), async (req: Request, res: Response) => {
  try {
    const template = await templateRepo.create(req.body);
    res.status(201).json(successResponse(template));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/templates/:id', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(updateConsentTemplateSchema), async (req: Request, res: Response) => {
  try {
    const template = await templateRepo.update(parseInt(String(req.params.id)), req.body);
    if (!template) return res.status(404).json(errorResponse('Template not found'));
    res.json(successResponse(template));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/templates/:id', authenticate, authorize('ETHICS_ADMIN', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await templateRepo.retire(parseInt(String(req.params.id)));
    res.json(successResponse({ message: 'Template retired' }));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

// ========================
// CONSENT VERSIONS
// ========================

router.get('/templates/:templateId/versions', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await versionRepo.findByTemplate(parseInt(String(req.params.templateId))))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/versions/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const version = await versionRepo.findById(parseInt(String(req.params.id)));
    if (!version) return res.status(404).json(errorResponse('Version not found'));
    res.json(successResponse(version));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/templates/:templateId/versions', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(createConsentVersionSchema), async (req: Request, res: Response) => {
  try {
    const version = await versionRepo.create(parseInt(String(req.params.templateId)), req.body);
    res.status(201).json(successResponse(version));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/versions/:id', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(updateConsentVersionSchema), async (req: Request, res: Response) => {
  try {
    const version = await versionRepo.update(parseInt(String(req.params.id)), req.body);
    if (!version) return res.status(404).json(errorResponse('Version not found'));
    res.json(successResponse(version));
  } catch (err: any) { res.status(err.statusCode || 400).json(errorResponse(err.message)); }
});

router.post('/versions/:id/approve', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    const version = await versionRepo.approve(parseInt(String(req.params.id)));
    if (!version) return res.status(404).json(errorResponse('Version not found'));
    res.json(successResponse(version));
  } catch (err: any) { res.status(err.statusCode || 400).json(errorResponse(err.message)); }
});

router.post('/versions/:id/retire', authenticate, authorize('ETHICS_ADMIN', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await versionRepo.retire(parseInt(String(req.params.id)));
    res.json(successResponse({ message: 'Version retired' }));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/versions/:id', authenticate, authorize('ETHICS_ADMIN', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await versionRepo.softDelete(parseInt(String(req.params.id)));
    res.json(successResponse({ message: 'Version deleted' }));
  } catch (err: any) { res.status(err.statusCode || 400).json(errorResponse(err.message)); }
});

// ========================
// APPLICATION CONSENTS
// ========================

router.get('/application-consents/:applicationId', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await appConsentRepo.findByApplication(parseInt(String(req.params.applicationId))))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/application-consents', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(assignConsentSchema), async (req: Request, res: Response) => {
  try {
    const { application_id, consent_version_id, is_required } = req.body;
    const ac = await appConsentRepo.assign(application_id, consent_version_id, is_required);
    res.status(201).json(successResponse(ac));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/application-consents/:id/replace-version', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(replaceConsentVersionSchema), async (req: Request, res: Response) => {
  try {
    const ac = await appConsentRepo.replaceConsentVersion(parseInt(String(req.params.id)), req.body.consent_version_id);
    if (!ac) return res.status(404).json(errorResponse('Application consent not found'));
    res.json(successResponse(ac));
  } catch (err: any) { res.status(400).json(errorResponse(err.message)); }
});

router.put('/application-consents/:id/required', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    const ac = await appConsentRepo.markRequired(parseInt(String(req.params.id)), req.body.is_required);
    if (!ac) return res.status(404).json(errorResponse('Application consent not found'));
    res.json(successResponse(ac));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

// ========================
// CONSENT REVIEW COMMENTS
// ========================

router.get('/reviews/:applicationConsentId', authenticate, async (req: Request, res: Response) => {
  try { res.json(successResponse(await reviewRepo.findByApplicationConsent(parseInt(String(req.params.applicationConsentId))))); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/reviews', authenticate, authorize('REVIEWER', 'COMMITTEE_CHAIR', 'ETHICS_ADMIN', 'SUPER_ADMIN'), validate(createConsentReviewSchema), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const comment = await reviewRepo.createReviewComment(req.body, user.id);
    res.status(201).json(successResponse(comment));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.put('/reviews/:id', authenticate, authorize('REVIEWER', 'COMMITTEE_CHAIR', 'ETHICS_ADMIN', 'SUPER_ADMIN'), validate(updateConsentReviewSchema), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const comment = await reviewRepo.updateReviewComment(parseInt(String(req.params.id)), req.body, user.id);
    if (!comment) return res.status(404).json(errorResponse('Review comment not found'));
    res.json(successResponse(comment));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.delete('/reviews/:id', authenticate, authorize('ETHICS_ADMIN', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await reviewRepo.softDelete(parseInt(String(req.params.id)));
    res.json(successResponse({ message: 'Review comment deleted' }));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
