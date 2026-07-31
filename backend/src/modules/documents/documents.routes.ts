import { Router, Request, Response } from 'express';
import multer from 'multer';
import path from 'path';
import fs from 'fs';
import mime from 'mime-types';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { signDocumentSchema, uploadDocumentSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { DocumentService } from '../../services/document.service';

const router = Router();
const service = new DocumentService();

const ALLOWED_MIME_TYPES = ['application/pdf', 'image/jpeg', 'image/png', 'image/tiff', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document', 'application/vnd.ms-excel', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', 'text/plain'];
const PREVIEWABLE_TYPES = ['application/pdf', 'image/jpeg', 'image/png', 'image/tiff'];

function sanitizeFilename(original: string): string {
  const ext = path.extname(original).replace(/[^a-zA-Z0-9.]/g, '');
  const base = path.basename(original, ext).replace(/[^a-zA-Z0-9 _-]/g, '');
  return `${Date.now()}-${base}${ext}`;
}

const storage = multer.diskStorage({
  destination: (_req, _file, cb) => {
    const dir = path.resolve('uploads');
    if (!fs.existsSync(dir)) fs.mkdirSync(dir, { recursive: true });
    cb(null, dir);
  },
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

router.get('/classifications', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getClassifications()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/pending-signatures', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getPendingSignatures((req as any).user)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/entity/:entityType/:entityId', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getByEntity(String(req.params.entityType), parseInt(String(req.params.entityId)))));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const doc = await service.getById(parseInt(String(req.params.id)));
    res.json(successResponse(doc));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/:id/download', authenticate, async (req: Request, res: Response) => {
  try {
    const doc = await service.getById(parseInt(String(req.params.id)));
    const filePath = service.getStoragePath(doc);

    if (!fs.existsSync(filePath)) {
      return res.status(404).json(errorResponse('File not found on disk'));
    }

    const mimeType = service.getMimeType(doc);
    const fileName = service.getFileName(doc);
    const stat = fs.statSync(filePath);

    res.setHeader('Content-Type', mimeType);
    res.setHeader('Content-Length', stat.size);
    res.setHeader('Content-Disposition', `attachment; filename="${encodeURIComponent(fileName)}"`);
    res.setHeader('X-Content-Type-Options', 'nosniff');

    fs.createReadStream(filePath).pipe(res);
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.get('/:id/preview', authenticate, async (req: Request, res: Response) => {
  try {
    const doc = await service.getById(parseInt(String(req.params.id)));
    const filePath = service.getStoragePath(doc);
    const mimeType = service.getMimeType(doc);

    if (!PREVIEWABLE_TYPES.includes(mimeType)) {
      return res.status(415).json(errorResponse('File type not supported for preview'));
    }

    if (!fs.existsSync(filePath)) {
      return res.status(404).json(errorResponse('File not found on disk'));
    }

    const stat = fs.statSync(filePath);
    const fileName = service.getFileName(doc);

    res.setHeader('Content-Type', mimeType);
    res.setHeader('Content-Length', stat.size);
    res.setHeader('Content-Disposition', `inline; filename="${encodeURIComponent(fileName)}"`);
    res.setHeader('X-Content-Type-Options', 'nosniff');
    res.setHeader('Cache-Control', 'private, max-age=3600');

    fs.createReadStream(filePath).pipe(res);
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.post('/', authenticate, upload.single('file'), validate(uploadDocumentSchema), async (req: Request, res: Response) => {
  try {
    const doc = await service.upload(req.file, req.body, (req as any).user);
    res.status(201).json(successResponse(doc, 'Document uploaded'));
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

router.post('/:id/restore', authenticate, async (req: Request, res: Response) => {
  try {
    const result = await service.restore(parseInt(String(req.params.id)));
    res.json(successResponse(result, 'Document restored'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

router.delete('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const result = await service.softDelete(parseInt(String(req.params.id)));
    res.json(successResponse(result, 'Document deleted'));
  } catch (err: any) { res.status(err.status || 500).json(errorResponse(err.message)); }
});

export default router;
