import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { assignReviewSchema, createReviewFormSchema, addQuestionSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { CommitteeService } from '../../services/committee.service';

const router = Router();
const service = new CommitteeService();

router.get('/my', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getMyReviews((req as any).user)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/assign', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(assignReviewSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.assignReview(req.body, (req as any).user)));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/application/:applicationId', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getApplicationReviews(parseInt(String(req.params.applicationId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/application/:applicationId/recommendations', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getRecommendations(parseInt(String(req.params.applicationId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/application/:applicationId/comments', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getComments(parseInt(String(req.params.applicationId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:assignmentId/submit', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.submitReview(parseInt(String(req.params.assignmentId)), (req as any).user, req.body)));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/forms', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getForms()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/forms', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(createReviewFormSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createForm(req.body)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/forms/:formId/questions', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getQuestions(parseInt(String(req.params.formId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/forms/:formId/questions', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), validate(addQuestionSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.addQuestion(parseInt(String(req.params.formId)), req.body)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/forms/:formId/questions/:questionId', authenticate, authorize('ETHICS_ADMIN', 'COMMITTEE_CHAIR', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await service.deleteQuestion(parseInt(String(req.params.formId)), parseInt(String(req.params.questionId)));
    res.json(successResponse(null, 'Question deleted'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/assignment/:assignmentId/answers', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getAnswers(parseInt(String(req.params.assignmentId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/assignment/:assignmentId/score', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getScore(parseInt(String(req.params.assignmentId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
