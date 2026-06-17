import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createCommitteeSchema, updateCommitteeSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { CommitteeService } from '../../services/committee.service';

const router = Router();
const service = new CommitteeService();

router.get('/committee-types', authenticate, async (req: Request, res: Response) => {
  try {
    const types = await service.getTypes();
    res.json(successResponse(types));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/committee-roles', authenticate, async (req: Request, res: Response) => {
  try {
    const roles = await service.getRoles();
    res.json(successResponse(roles));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const committees = await service.getAll();
    res.json(successResponse(committees));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.post('/', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), validate(createCommitteeSchema), async (req: Request, res: Response) => {
  try {
    const committee = await service.create(req.body, (req as any).user);
    res.status(201).json(successResponse(committee, 'Committee created'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.put('/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), validate(updateCommitteeSchema), async (req: Request, res: Response) => {
  try {
    const committee = await service.update(parseInt(String(req.params.id)), req.body);
    res.json(successResponse(committee, 'Committee updated'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.delete('/:id', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    const result = await service.deactivate(parseInt(String(req.params.id)));
    res.json(successResponse(null, 'Committee deactivated'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const committee = await service.getById(parseInt(String(req.params.id)));
    res.json(successResponse(committee));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

// Committee member sub-resources
router.get('/:id/members', authenticate, async (req: Request, res: Response) => {
  try {
    const members = await service.getMembers(parseInt(String(req.params.id)));
    res.json(successResponse(members));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.post('/:id/members', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    const { user_id, role_id } = req.body;
    if (!user_id) return res.status(400).json(errorResponse('user_id is required'));
    const parsedUserId = parseInt(String(user_id), 10);
    if (isNaN(parsedUserId)) return res.status(400).json(errorResponse('Invalid user_id'));
    let parsedRoleId: number | undefined;
    if (role_id != null) {
      parsedRoleId = parseInt(String(role_id), 10);
      if (isNaN(parsedRoleId)) parsedRoleId = undefined;
    }
    const member = await service.addMember(parseInt(String(req.params.id), 10), {
      user_id: parsedUserId,
      role_id: parsedRoleId,
    });
    res.status(201).json(successResponse(member, 'Member added'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.put('/:id/members/:memberId', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    const role_id = parseInt(String(req.body.role_id), 10);
    if (isNaN(role_id)) return res.status(400).json(errorResponse('Invalid role_id'));
    const result = await service.updateMemberRole(parseInt(String(req.params.memberId), 10), role_id);
    res.json(successResponse(result, 'Role updated'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.delete('/:id/members/:memberId', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN', 'ETHICS_ADMIN'), async (req: Request, res: Response) => {
  try {
    const memberId = parseInt(String(req.params.memberId), 10);
    if (isNaN(memberId)) return res.status(400).json(errorResponse('Invalid memberId'));
    const result = await service.removeMember(memberId);
    res.json(successResponse(null, 'Member removed'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
