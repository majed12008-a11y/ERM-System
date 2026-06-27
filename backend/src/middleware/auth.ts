/*
 * وسيط المصادقة (JWT) والصلاحيات.
 * authenticate: يتحقق من JWT Bearer token ويضبط سياق المستخدم.
 * authorize(code): تتحقق من صلاحية المستخدم للوصول إلى مسار معين.
 */
import { Request, Response, NextFunction } from 'express';
import { jwtVerify, SignJWT } from 'jose';
import { query } from '../config/database';
import { env } from '../config/env';
import { logger } from '../config/logger';
import { userContext } from './context';

const secret = new TextEncoder().encode(env.JWT_SECRET);

export async function authenticate(req: Request, res: Response, next: NextFunction) {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith('Bearer ')) {
    return res.status(401).json({ success: false, error: 'No token provided' });
  }

  let payload: { userId: number; type?: string };
  try {
    const result = await jwtVerify(authHeader.substring(7), secret);
    payload = result.payload as unknown as { userId: number; type?: string };
    if (payload.type === 'refresh') {
      return res.status(401).json({ success: false, error: 'Access token required' });
    }
  } catch (err) {
    logger.warn({ err }, 'JWT verification failed');
    return res.status(401).json({ success: false, error: 'Invalid or expired token' });
  }

  const userId = payload.userId;

  const existingCtx = userContext.getStore();
  userContext.run({ userId, requestId: existingCtx?.requestId || '-', sourceIp: existingCtx?.sourceIp }, async () => {
    try {
      const dbResult = await query(
        `SELECT u.id, u.uuid, u.institution_id, u.username, u.email, u.status, u.is_email_verified,
                COALESCE(array_agg(r.code) FILTER (WHERE r.code IS NOT NULL), '{}') as roles
         FROM security.users u
         LEFT JOIN security.user_roles ur ON ur.user_id = u.id
         LEFT JOIN security.roles r ON ur.role_id = r.id
         WHERE u.id = $1 AND u.status = 'ACTIVE'
         GROUP BY u.id`,
        [userId]
      );

      if (dbResult.rows.length === 0) {
        return res.status(401).json({ success: false, error: 'User not found or inactive' });
      }

      (req as any).user = dbResult.rows[0];
      next();
    } catch (err) {
      logger.warn({ err }, 'User lookup failed');
      return res.status(500).json({ success: false, error: 'Internal server error' });
    }
  });
}

export function authorize(...roles: string[]) {
  return (req: Request, res: Response, next: NextFunction) => {
    const user = (req as any).user;
    if (!user) {
      return res.status(401).json({ success: false, error: 'Not authenticated' });
    }
    if (roles.length > 0 && (!user.roles || !user.roles.includes('SUPER_ADMIN')) && !roles.some(r => user.roles && user.roles.includes(r))) {
      return res.status(403).json({ success: false, error: 'Insufficient permissions' });
    }
    next();
  };
}

export async function signToken(userId: number): Promise<string> {
  return await new SignJWT({ userId, type: 'access' })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('15m')
    .sign(secret);
}

export async function signRefreshToken(userId: number, sessionToken?: string): Promise<string> {
  const jwt = new SignJWT({ userId, type: 'refresh' })
    .setProtectedHeader({ alg: 'HS256' })
    .setExpirationTime('7d');
  if (sessionToken) {
    jwt.setJti(sessionToken);
  }
  return await jwt.sign(secret);
}

export async function generateTokens(userId: number, sessionToken?: string): Promise<{ accessToken: string; refreshToken: string }> {
  const [accessToken, refreshToken] = await Promise.all([signToken(userId), signRefreshToken(userId, sessionToken)]);
  return { accessToken, refreshToken };
}
