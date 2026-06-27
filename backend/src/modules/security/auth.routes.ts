import { Router, Request, Response } from 'express';
import rateLimit from 'express-rate-limit';
import { authenticate } from '../../middleware/auth';
import { validate } from '../../middleware/validate';
import { loginSchema, registerSchema, forgotPasswordSchema, resetPasswordSchema, verifyEmailSchema, changePasswordSchema } from '../../middleware/schemas';
import { successResponse, errorResponse } from '../../shared/utils';
import { env } from '../../config/env';
import { AuthService } from '../../services/auth.service';

const router = Router();
const service = new AuthService();

const registerLimiter = rateLimit({ windowMs: 60 * 1000, max: 5, standardHeaders: true, legacyHeaders: false, message: { success: false, error: 'Too many registration attempts. Try again later.' } });
const forgotLimiter = rateLimit({ windowMs: 60 * 1000, max: 3, standardHeaders: true, legacyHeaders: false, message: { success: false, error: 'Too many password reset requests. Try again later.' } });

function parseCookies(header: string | undefined): Record<string, string> {
  if (!header) return {};
  return Object.fromEntries(header.split(';').map(c => {
    const [k, ...v] = c.trim().split('=');
    return [k, v.join('=')];
  }));
}

router.post('/login', validate(loginSchema), async (req: Request, res: Response) => {
  try {
    const { username, password } = req.body;
    const result = await service.login(username, password, req.ip || '0.0.0.0', req.headers['user-agent'] || '');

    res.cookie('refreshToken', result.refreshToken, {
      httpOnly: true,
      secure: env.NODE_ENV === 'production',
      sameSite: 'strict',
      maxAge: 7 * 24 * 60 * 60 * 1000,
      path: '/api/v1/security/auth',
    });

    res.json(successResponse({ accessToken: result.accessToken, userId: result.userId }));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/register', registerLimiter, validate(registerSchema), async (req: Request, res: Response) => {
  try {
    const { username, email, password, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile, institution_id } = req.body;
    const result = await service.register({
      username, email, password, first_name_ar, last_name_ar, first_name_en, last_name_en, mobile,
      institution_id: parseInt(institution_id, 10),
    });
    res.status(201).json(successResponse(result, 'Registration successful'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/forgot-password', forgotLimiter, validate(forgotPasswordSchema), async (req: Request, res: Response) => {
  try {
    const result = await service.forgotPassword(req.body.email);
    res.json(successResponse(result, result.message));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/reset-password', validate(resetPasswordSchema), async (req: Request, res: Response) => {
  try {
    await service.resetPassword(req.body.token, req.body.password);
    res.json(successResponse(null, 'Password has been reset successfully'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/refresh', async (req: Request, res: Response) => {
  try {
    const cookies = parseCookies(req.headers.cookie);
    const refreshToken = cookies.refreshToken;
    const result = await service.refresh(refreshToken);
    res.json(successResponse(result));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/logout', authenticate, async (req: Request, res: Response) => {
  try {
    await service.logout((req as any).user.id);
    res.clearCookie('refreshToken', {
      path: '/api/v1/security/auth',
      httpOnly: true,
      secure: env.NODE_ENV === 'production',
      sameSite: 'strict',
    });
    res.json(successResponse(null, 'Logged out'));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.get('/me', authenticate, async (req: Request, res: Response) => {
  try {
    const result = await service.getMe((req as any).user);
    res.json(successResponse(result));
  } catch (err: any) {
    res.status(500).json(errorResponse(err.message));
  }
});

router.post('/verify-email', validate(verifyEmailSchema), async (req: Request, res: Response) => {
  try {
    await service.verifyEmail(req.body.token);
    res.json(successResponse(null, 'Email verified successfully'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/resend-verification', authenticate, async (req: Request, res: Response) => {
  try {
    const result = await service.resendVerificationEmail((req as any).user.id);
    res.json(successResponse(result, 'Verification email resent'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

router.post('/change-password', authenticate, validate(changePasswordSchema), async (req: Request, res: Response) => {
  try {
    const user = (req as any).user;
    const { oldPassword, newPassword } = req.body;
    await service.changePassword(user.id, oldPassword, newPassword);
    res.clearCookie('refreshToken', {
      path: '/api/v1/security/auth',
      httpOnly: true,
      secure: env.NODE_ENV === 'production',
      sameSite: 'strict',
    });
    res.json(successResponse(null, 'Password changed. Please login again.'));
  } catch (err: any) {
    res.status(err.status || 500).json(errorResponse(err.message));
  }
});

export default router;
