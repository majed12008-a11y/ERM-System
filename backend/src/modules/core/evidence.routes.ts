import { Router, Request, Response } from 'express';
import multer from 'multer';
import path from 'path';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { uploadEvidenceSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { EvidenceService } from '../../services/evidence.service';
import { DocumentRepository } from '../../repositories/document.repository';
import { ConditionRepository } from '../../repositories/condition.repository';

const router = Router({ mergeParams: true });
const service = new EvidenceService(new DocumentRepository(), new ConditionRepository());

const ALLOWED_MIME_TYPES = ['application/pdf', 'image/jpeg', 'image/png', 'image/tiff'];

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
      cb(new Error('Only PDF, JPEG, PNG, and TIFF files are allowed'));
    }
  },
});

router.post('/', authenticate, upload.single('file'), validate(uploadEvidenceSchema), async (req: Request, res: Response) => {
  try {
    if (!req.file) {
      res.status(400).json(errorResponse('File is required'));
      return;
    }
    const doc = await service.uploadEvidence(
      parseInt(String(req.params.applicationId)),
      parseInt(String(req.params.conditionId)),
      req.file,
      req.body,
      (req as any).user,
    );
    res.status(201).json(successResponse(doc, 'Evidence uploaded'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const docs = await service.getEvidence(
      parseInt(String(req.params.applicationId)),
      parseInt(String(req.params.conditionId)),
    );
    res.json(successResponse(docs));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.delete('/:evidenceId', authenticate, async (req: Request, res: Response) => {
  try {
    await service.deleteEvidence(
      parseInt(String(req.params.applicationId)),
      parseInt(String(req.params.conditionId)),
      parseInt(String(req.params.evidenceId)),
      (req as any).user,
    );
    res.json(successResponse(null, 'Evidence deleted'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
