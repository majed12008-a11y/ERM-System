import { Router, Request, Response } from 'express';
import rateLimit from 'express-rate-limit';
import { successResponse, errorResponse } from '../../shared/utils';
import { env } from '../../config/env';
import { CertificateService } from '../../services/certificate.service';
import { CertificateRepository } from '../../repositories/certificate.repository';
import { DocumentRepository } from '../../repositories/document.repository';

const router = Router();

const certificateService = new CertificateService(
  new CertificateRepository(),
  new DocumentRepository(),
);

const verifyLimiter = rateLimit({
  windowMs: env.RATE_LIMIT_AUTH_WINDOW_MS,
  max: env.RATE_LIMIT_VERIFY_MAX,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: 'Too many verification requests. Try again later.' },
});

router.get('/verify/:serialNumber', verifyLimiter, async (req: Request, res: Response) => {
  try {
    const serialNumber = String(req.params.serialNumber);
    const ip = req.ip || req.socket.remoteAddress || undefined;
    const data = await certificateService.verify(serialNumber, ip);
    res.json(successResponse(data));
  } catch (err: any) {
    if (err.status === 404) {
      return res.status(404).json(errorResponse('Certificate not found'));
    }
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
