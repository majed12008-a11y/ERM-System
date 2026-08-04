/*
 * وحدة مكتبة النماذج — المسارات:
 * تعريفات النماذج، مثيلات النماذج (حفظ/إرسال/اعتماد/إرجاع)،
 * وتوليد المستندات الرسمية من استجابات النماذج.
 */
import { Router, Request, Response } from 'express';
import path from 'path';
import fs from 'fs/promises';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import {
  createFormInstanceSchema,
  saveFormInstanceSchema,
  generateFormDocumentSchema,
} from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { FormService } from '../../services/form.service';
import { DocumentLifecycleService } from '../../services/document-lifecycle.service';

const router = Router();
const service = new FormService();
const lifecycleService = new DocumentLifecycleService();

// ── Definitions ──────────────────────────────────────────────
router.get('/', authenticate, async (_req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.listDefinitions()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/categories', authenticate, async (_req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.listCategories()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/definitions/:code', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getDefinition(String(req.params.code))));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

// ── Instances ────────────────────────────────────────────────
router.get('/instances', authenticate, async (req: Request, res: Response) => {
  try {
    const { page, limit } = parsePagination(req.query as any);
    res.json(successResponse(await service.listInstances(page, limit)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/instances/entity/:entityType/:entityId', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.listByEntity(String(req.params.entityType), parseInt(String(req.params.entityId)))));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/instances/:id', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getInstance(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/instances', authenticate, validate(createFormInstanceSchema), async (req: Request, res: Response) => {
  try {
    const instance = await service.createInstance(req.body, (req as any).user);
    res.status(201).json(successResponse(instance, 'Form instance created'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.put('/instances/:id', authenticate, validate(saveFormInstanceSchema), async (req: Request, res: Response) => {
  try {
    const updated = await service.saveInstance(parseInt(String(req.params.id)), req.body.responses, (req as any).user);
    res.json(successResponse(updated, 'Form saved as draft'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/instances/:id/submit', authenticate, validate(saveFormInstanceSchema), async (req: Request, res: Response) => {
  try {
    const submitted = await service.submitInstance(parseInt(String(req.params.id)), req.body.responses, (req as any).user);
    res.json(successResponse(submitted, 'Form submitted'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/instances/:id/approve', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.approveInstance(parseInt(String(req.params.id)), (req as any).user), 'Form approved'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/instances/:id/return', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.returnInstance(parseInt(String(req.params.id)), (req as any).user), 'Form returned'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/instances/:id/void', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.voidInstance(parseInt(String(req.params.id)), (req as any).user), 'Form voided'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/instances/:id/generate', authenticate, validate(generateFormDocumentSchema), async (req: Request, res: Response) => {
  try {
    const result = await service.generateDocument(parseInt(String(req.params.id)), req.body, (req as any).user);
    res.status(201).json(successResponse(result, 'Official document generated'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/documents/:id/download', authenticate, async (req: Request, res: Response) => {
  try {
    const info = await service.getDocumentDownload(parseInt(String(req.params.id)));
    if (!info) {
      return res.status(404).json(errorResponse('Document not found'));
    }
    const fullPath = path.resolve(info.storagePath);
    await fs.access(fullPath);
    res.download(fullPath, info.fileName);
  } catch (err: any) {
    if (err.code === 'ENOENT') {
      return res.status(404).json(errorResponse('PDF file not found on disk'));
    }
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/instances/:id/documents', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.listDocuments(parseInt(String(req.params.id)), (req as any).user)));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/documents/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const docId = parseInt(String(req.params.id));
    await lifecycleService.checkExpiry(docId, (req as any).user);
    res.json(successResponse(await service.getDocumentDetail(docId, (req as any).user)));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

export default router;
