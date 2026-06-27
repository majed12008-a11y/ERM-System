import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createMeetingSchema, createAgendaSchema, addAttendanceSchema, createMinutesSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { CommitteeService } from '../../services/committee.service';

const router = Router();
const service = new CommitteeService();

router.get('/committee/:committeeId', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getMeetings(parseInt(String(req.params.committeeId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', authenticate, authorize('COMMITTEE_CHAIR', 'ETHICS_ADMIN'), validate(createMeetingSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createMeeting(req.body)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:id/quorum', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getQuorum(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getMeeting(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/:id/agenda', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getAgenda(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:id/agenda', authenticate, authorize('COMMITTEE_CHAIR', 'ETHICS_ADMIN'), validate(createAgendaSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createAgenda(parseInt(String(req.params.id)), req.body)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:id/agenda/:agendaId/items', authenticate, authorize('COMMITTEE_CHAIR', 'ETHICS_ADMIN'), validate(createAgendaSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.addAgendaItem(parseInt(String(req.params.agendaId)), req.body)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:id/attendance', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getAttendance(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:id/attendance', authenticate, validate(addAttendanceSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.addAttendance(parseInt(String(req.params.id)), req.body)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:id/minutes', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getMinutes(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/:id/minutes', authenticate, authorize('COMMITTEE_CHAIR', 'ETHICS_ADMIN'), validate(createMinutesSchema), async (req: Request, res: Response) => {
  try {
    res.status(201).json(successResponse(await service.createMinutes(parseInt(String(req.params.id)), req.body.minutes_text, (req as any).user)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.patch('/:id/minutes/:minutesId/approve', authenticate, authorize('COMMITTEE_CHAIR', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.approveMinutes(parseInt(String(req.params.id)), parseInt(String(req.params.minutesId)), (req as any).user)));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/:id', authenticate, authorize('COMMITTEE_CHAIR', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.updateMeeting(parseInt(String(req.params.id)), req.body)));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/:id/committee-members', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getCommitteeMembers(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

export default router;
