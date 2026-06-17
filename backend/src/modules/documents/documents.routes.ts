import { Router, Request, Response } from 'express';
import multer from 'multer';
import path from 'path';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { signDocumentSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { DocumentService } from '../../services/document.service';

const router = Router();
const service = new DocumentService();

const ALLOWED_MIME_TYPES = ['application/pdf', 'image/jpeg', 'image/png', 'image/tiff', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'text/plain'];

function sanitizeFilename(original: string): string {
  const ext = path.extname(original).replace(/[^a-zA-Z0-9.]/g, '');
  const base = path.basename(original, ext).replace(/[^a-zA-Z0-9 _-]/g, '');
  return `${Date.now()}-${base}${ext}`;
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => cb(null, path.resolve('uploads')),
  filename: (_req, file, cb) => cb(null, sanitizeFilename(file.originalname)),
});
const upload = multer({
  storage,
  limits: { fileSize: 10 * 1024 * 1024 },
  fileFilter: (_req, file, cb) => {
    if (ALLOWED_MIME_TYPES.includes(file.mimetype)) {
      cb(null, true);
    } else {
      cb(new Error(`File type ${file.mimetype} is not allowed`));
    }
  },
});

router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const result = await service.getAll(parsePagination(req.query as any));
    res.json({ success: true, ...result });
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/types', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getTypes()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.post('/', authenticate, upload.single('file'), async (req: Request, res: Response) => {
  try {
    const doc = await service.upload(req.file, req.body, (req as any).user);
    res.status(201).json(successResponse(doc, 'Document uploaded'));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/classifications', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getClassifications()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/entity/:entityType/:entityId', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getByEntity(String(req.params.entityType), parseInt(String(req.params.entityId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.delete('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    await service.softDelete(parseInt(String(req.params.id)));
    res.json(successResponse(null, 'Document deleted'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/:id/sign', authenticate, validate(signDocumentSchema), async (req: Request, res: Response) => {
  try {
    const signature = await service.sign(parseInt(String(req.params.id)), (req as any).user);
    res.status(201).json(successResponse(signature, 'Document signed'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/:id/signatures', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getSignatures(parseInt(String(req.params.id)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/pending-signatures', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getPendingSignatures((req as any).user)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
