import { Router, Request, Response } from 'express';
import rateLimit from 'express-rate-limit';
import { successResponse, errorResponse } from '../../shared/utils';
import { env } from '../../config/env';
import { DocumentRenderRepository } from '../../repositories/document-render.repository';

const router = Router();

const verifyLimiter = rateLimit({
  windowMs: env.RATE_LIMIT_AUTH_WINDOW_MS,
  max: env.RATE_LIMIT_VERIFY_MAX,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: 'Too many verification requests. Try again later.' },
});

router.get('/verify/:reference', verifyLimiter, async (req: Request, res: Response) => {
  try {
    const reference = String(req.params.reference);
    const ip = req.ip || req.socket.remoteAddress || null;

    const repo = new DocumentRenderRepository();
    const data = await repo.getVerificationData(reference);
    if (!data) {
      await repo.logVerification(reference, ip, 'NOT_FOUND');
      return res.status(404).json(errorResponse('Document not found'));
    }

    const result = data.status === 'OFFICIAL' ? 'VALID' : (data.status || 'ERROR');
    await repo.logVerification(reference, ip, result, data);
    res.json(successResponse(data));
  } catch (err: any) {
    if (err.status === 404) {
      return res.status(404).json(errorResponse('Document not found'));
    }
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
