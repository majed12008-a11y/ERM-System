/*
 * نقطة الدخول الرئيسية للخادم (Express).
 * يهيئ Middleware النظام (CORS، Helmet، التحكم بالمعدل، المصادقة)
 * ويسجل جميع المسارات للوحدات المختلفة، ثم يبدأ الخادم على المنفذ المحدد.
 */
import 'dotenv/config';
import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import rateLimit from 'express-rate-limit';
import swaggerUi from 'swagger-ui-express';
import { v7 as uuidv7 } from 'uuid';
import { httpLogger, logger } from './config/logger';
import { swaggerSpec } from './config/swagger';
import { errorHandler, notFoundHandler } from './middleware/errorHandler';
import { userContext } from './middleware/context';
import { metricsMiddleware } from './middleware/metrics';
import { env, validateEnv } from './config/env';
import pool, { waitForDatabase } from './config/database';
import { BackupScheduler } from './services/backup-scheduler';

const loginLimiter = rateLimit({ windowMs: env.RATE_LIMIT_AUTH_WINDOW_MS, max: env.RATE_LIMIT_LOGIN_MAX, standardHeaders: true, legacyHeaders: false, message: { success: false, error: 'Too many login attempts. Try again later.' } });

import securityRoutes from './modules/security';
import coreRoutes from './modules/core';
import committeeRoutes from './modules/committee';
import workflowRoutes from './modules/workflow';
import documentRoutes from './modules/documents';
import communicationRoutes from './modules/communication';
import monitoringRoutes from './modules/monitoring';
import safetyRoutes from './modules/safety';
import reportingRoutes from './modules/reporting';
import adminRoutes from './modules/admin';
import integrationRoutes from './modules/integration';
import systemRoutes from './modules/system';
import referenceRoutes from './modules/reference';
import publicRoutes from './modules/public';
import templateRoutes from './modules/templates';

import path from 'path';
process.on('uncaughtException', (err) => {
  logger.fatal({ err, stack: err.stack }, 'Uncaught exception — exiting');
  process.exit(1);
});
process.on('unhandledRejection', (reason: any, promise: Promise<any>) => {
  const detail = reason instanceof Error ? { err: reason, stack: reason.stack } : { reason: String(reason) };
  logger.error(detail, 'Unhandled promise rejection');
});

const app = express();
validateEnv();
const isProd = env.NODE_ENV === 'production';
app.set('trust proxy', env.TRUST_PROXY);

if (isProd) {
  app.use(express.static(path.join(__dirname, '../public')));
}

app.use((req, res, next) => {
  const header = req.headers['x-request-id'];
  const requestId = typeof header === 'string' && header.length <= 100 ? header : uuidv7();
  (req as any).requestId = requestId;
  req.id = requestId;
  res.setHeader('X-Request-Id', requestId);
  const sourceIp = req.ip || req.socket.remoteAddress || '0.0.0.0';
  userContext.run({ userId: 0, requestId, sourceIp }, () => next());
});
app.use(metricsMiddleware);
app.use(httpLogger);
app.use(helmet({
  contentSecurityPolicy: isProd ? {
    directives: {
      defaultSrc: ["'self'", "blob:"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:"],
      connectSrc: ["'self'"],
      fontSrc: ["'self'"],
      frameAncestors: ["'none'"],
      formAction: ["'self'"],
      baseUri: ["'self'"],
      objectSrc: ["'none'"],
    },
  } : false,
  crossOriginResourcePolicy: { policy: isProd ? 'same-origin' : 'cross-origin' },
}));
app.use(cors({
  origin: isProd ? env.CORS_ORIGIN?.split(',') || 'http://localhost:5173' : 'http://localhost:5173',
  credentials: true,
}));
app.use(express.json({ limit: '1mb' }));

// Health probes — before global rate limiter (orchestrator needs unrestricted access)
app.use('/api/v1/monitoring', monitoringRoutes);

// Global rate limiter — applied to all API routes below
app.use(rateLimit({ windowMs: 60 * 1000, max: env.RATE_LIMIT_GLOBAL_MAX, standardHeaders: true, legacyHeaders: false }));

// Auth-specific rate limiter on login (most common abuse target) — also applied inline per-route in auth.routes.ts
app.use('/api/v1/security/auth/login', loginLimiter);
app.use('/api/v1/security', securityRoutes);
app.use('/api/v1/core', coreRoutes);
app.use('/api/v1/committee', committeeRoutes);
app.use('/api/v1/workflow', workflowRoutes);
app.use('/api/v1/documents', documentRoutes);
app.use('/api/v1/communication', communicationRoutes);
app.use('/api/v1/safety', safetyRoutes);
app.use('/api/v1/reporting', reportingRoutes);
app.use('/api/v1/admin', adminRoutes);
app.use('/api/v1/integration', integrationRoutes);
app.use('/api/v1/system', systemRoutes);
app.use('/api/v1/reference', referenceRoutes);
app.use('/api/v1/public', publicRoutes);
app.use('/api/v1/templates', templateRoutes);

app.use('/api/v1/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, { customCss: '.swagger-ui .topbar { display: none }' }));
app.get('/api/v1/docs.json', (req, res) => res.json(swaggerSpec));

app.use(notFoundHandler);
app.use(errorHandler);

async function start() {
  await waitForDatabase();
  const server = app.listen(env.PORT, () => {
    logger.info({ port: env.PORT, NODE_ENV: env.NODE_ENV }, 'Ethics ERM API started');
  });

  const backupScheduler = new BackupScheduler();
  backupScheduler.start();

  async function shutdown(signal: string) {
    logger.info({ signal }, 'Shutting down gracefully...');
    backupScheduler.stop();
    server.close(async () => {
      logger.info('Server closed');
      try {
        await pool.end();
        logger.info('Database pool drained');
      } catch { /* pool already closed */ }
      process.exit(0);
    });
    setTimeout(() => { logger.error('Forced shutdown'); process.exit(1); }, 10000).unref();
  }

  process.on('SIGTERM', () => shutdown('SIGTERM'));
  process.on('SIGINT', () => shutdown('SIGINT'));
}

start();

export default app;
