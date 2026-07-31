/*
 * مسارات إدارة قوالب الشهادات/المستندات:
 * عرض وإنشاء وتعديل وإيقاف قوالب المستندات.
 */
import { Router, Request, Response } from 'express';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { createDocumentTemplateSchema, updateDocumentTemplateSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { DocumentTemplateRepository } from '../../repositories/document-template.repository';

const router = Router();
const repo = new DocumentTemplateRepository();

const ADMIN_ROLES = ['SUPER_ADMIN', 'ETHICS_ADMIN', 'SYS_ADMIN', 'ADMIN'];

router.get('/', authenticate, async (_req: Request, res: Response) => {
  try {
    res.json(successResponse(await repo.findAll()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const tpl = await repo.findById(parseInt(String(req.params.id)));
    if (!tpl) return res.status(404).json(errorResponse('Template not found'));
    res.json(successResponse(tpl));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', authenticate, authorize(...ADMIN_ROLES), validate(createDocumentTemplateSchema), async (req: Request, res: Response) => {
  try {
    const tpl = await repo.create(req.body);
    res.status(201).json(successResponse(tpl, 'Template created'));
  } catch (err: any) {
    if (err.code === '23505') {
      return res.status(409).json(errorResponse('Template code and version already exists'));
    }
    res.status(500).json(errorResponse(err.message));
  }
});

router.put('/:id', authenticate, authorize(...ADMIN_ROLES), validate(updateDocumentTemplateSchema), async (req: Request, res: Response) => {
  try {
    const tpl = await repo.update(parseInt(String(req.params.id)), req.body);
    if (!tpl) return res.status(404).json(errorResponse('Template not found'));
    res.json(successResponse(tpl, 'Template updated'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/:id', authenticate, authorize(...ADMIN_ROLES), async (req: Request, res: Response) => {
  try {
    await repo.retire(parseInt(String(req.params.id)));
    res.json(successResponse(null, 'Template retired'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
