import { Router, Request, Response } from 'express';
import path from 'path';
import fs from 'fs/promises';
import { authenticate, authorize } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { revokeCertificateSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { CertificateService } from '../../services/certificate.service';
import { CertificateRepository } from '../../repositories/certificate.repository';
import { DocumentRepository } from '../../repositories/document.repository';

const router = Router({ mergeParams: true });
const certificateService = new CertificateService(
  new CertificateRepository(),
  new DocumentRepository(),
);

router.get('/', authenticate, async (req: Request, res: Response) => {
  try {
    const applicationId = parseInt(String(req.params.applicationId));
    const certs = await certificateService.listByApplication(applicationId);
    res.json(successResponse(certs));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/:id', authenticate, async (req: Request, res: Response) => {
  try {
    const repo = new CertificateRepository();
    const cert = await repo.findById(parseInt(String(req.params.id)));
    if (!cert) {
      return res.status(404).json(errorResponse('Certificate not found'));
    }
    res.json(successResponse(cert));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/:id/reissue', authenticate, authorize('ETHICS_ADMIN', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await certificateService.reissue(parseInt(String(req.params.id)), (req as any).user);
    res.json(successResponse(null, 'Certificate re-issued successfully'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/:id/retry', authenticate, authorize('ETHICS_ADMIN', 'SUPER_ADMIN'), async (req: Request, res: Response) => {
  try {
    await certificateService.retry(parseInt(String(req.params.id)), (req as any).user);
    res.json(successResponse(null, 'Certificate generation retried successfully'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/:id/revoke', authenticate, authorize('ETHICS_ADMIN', 'SUPER_ADMIN'), validate(revokeCertificateSchema), async (req: Request, res: Response) => {
  try {
    await certificateService.revoke(parseInt(String(req.params.id)), req.body.reason, (req as any).user);
    res.json(successResponse(null, 'Certificate revoked'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.get('/:id/download', authenticate, async (req: Request, res: Response) => {
  try {
    const certId = parseInt(String(req.params.id));
    const info = await certificateService.getDownloadInfo(certId);
    if (!info) {
      return res.status(404).json(errorResponse('Certificate PDF not found'));
    }

    const fullPath = path.resolve(info.storagePath);
    await fs.access(fullPath);

    res.download(fullPath, info.fileName);
  } catch (err: any) {
    if (err.code === 'ENOENT') {
      return res.status(404).json(errorResponse('Certificate PDF file not found on disk'));
    }
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
