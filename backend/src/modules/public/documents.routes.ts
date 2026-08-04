import { Router, Request, Response } from 'express';
import rateLimit from 'express-rate-limit';
import { successResponse, errorResponse } from '../../shared/utils';
import { env } from '../../config/env';
import { createVerificationEngine, VerificationNotFoundError } from '../../services/verification';

const router = Router();

const engine = createVerificationEngine();

const verifyLimiter = rateLimit({
  windowMs: env.RATE_LIMIT_AUTH_WINDOW_MS,
  max: env.RATE_LIMIT_VERIFY_MAX,
  standardHeaders: true,
  legacyHeaders: false,
  message: { success: false, error: 'Too many verification requests. Try again later.' },
});

/**
 * Backward-compatible document verification URL. Routes through the shared
 * verification platform with the artifact type pinned to generated documents.
 */
router.get('/verify/:reference', verifyLimiter, async (req: Request, res: Response) => {
  try {
    const reference = String(req.params.reference);
    const ip = req.ip || req.socket.remoteAddress || null;
    const result = await engine.verify(
      { artifactType: 'generated-document', reference, context: { ip } },
      { ip }
    );
    res.json(successResponse(result));
  } catch (err: any) {
    if (err instanceof VerificationNotFoundError) {
      return res.status(404).json(errorResponse('Document not found'));
    }
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
