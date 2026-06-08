import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { CommitteeService } from '../../services/committee.service';

const router = Router();
const service = new CommitteeService();

router.get('/meeting/:meetingId', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getVotingSessions(parseInt(String(req.params.meetingId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/sessions', authenticate, authorize('COMMITTEE_CHAIR', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createVotingSession(req.body), 'Voting session created'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/sessions/:id', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getVotingSession(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/sessions/:id/vote', authenticate, async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.castVote(parseInt(String(req.params.id)), (req as any).user, req.body.vote_value, req.body.comments), 'Vote recorded'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.patch('/sessions/:id/close', authenticate, authorize('COMMITTEE_CHAIR', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.closeVotingSession(parseInt(String(req.params.id))), 'Voting session closed'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

export default router;
