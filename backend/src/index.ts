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
import { validateEnv } from './config/env';

const loginLimiter = rateLimit({ windowMs: 60 * 1000, max: 10, standardHeaders: true, legacyHeaders: false, message: { success: false, error: 'Too many login attempts. Try again later.' } });

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

const app = express();
const PORT = parseInt(process.env.PORT || '3000');
const isProd = process.env.NODE_ENV === 'production';

validateEnv();

app.use((req, res, next) => {
  const header = req.headers['x-request-id'];
  const requestId = typeof header === 'string' && header.length <= 100 ? header : uuidv7();
  (req as any).requestId = requestId;
  req.id = requestId;
  res.setHeader('X-Request-Id', requestId);
  userContext.run({ userId: 0, requestId }, () => next());
});
app.use(httpLogger);
app.use(helmet({
  contentSecurityPolicy: isProd ? undefined : false,
  crossOriginResourcePolicy: { policy: isProd ? 'same-origin' : 'cross-origin' },
}));
app.use(cors({
  origin: isProd ? process.env.CORS_ORIGIN?.split(',') || 'http://localhost:5173' : '*',
  credentials: true,
}));
app.use(express.json({ limit: '10mb' }));
app.use(rateLimit({ windowMs: 60 * 1000, max: isProd ? 60 : 100, standardHeaders: true, legacyHeaders: false }));

app.use('/api/v1/security/auth/login', loginLimiter);
app.use('/api/v1/security', securityRoutes);
app.use('/api/v1/core', coreRoutes);
app.use('/api/v1/committee', committeeRoutes);
app.use('/api/v1/workflow', workflowRoutes);
app.use('/api/v1/documents', documentRoutes);
app.use('/api/v1/communication', communicationRoutes);
app.use('/api/v1/monitoring', monitoringRoutes);
app.use('/api/v1/safety', safetyRoutes);
app.use('/api/v1/reporting', reportingRoutes);
app.use('/api/v1/admin', adminRoutes);
app.use('/api/v1/integration', integrationRoutes);
app.use('/api/v1/system', systemRoutes);
app.use('/api/v1/reference', referenceRoutes);

app.use('/api/v1/docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, { customCss: '.swagger-ui .topbar { display: none }' }));
app.get('/api/v1/docs.json', (req, res) => res.json(swaggerSpec));

app.get('/api/v1/health', async (req, res) => {
  try {
    const { query } = await import('./config/database');
    await query('SELECT 1');
    res.json({ success: true, data: { service: 'ethics-erm-api', version: '1.0.0', status: 'healthy', requestId: (req as any).requestId } });
  } catch {
    res.status(503).json({ success: false, error: 'Database unavailable' });
  }
});

app.use(notFoundHandler);
app.use(errorHandler);

const server = app.listen(PORT, () => {
  logger.info({ port: PORT, NODE_ENV: process.env.NODE_ENV || 'development' }, 'Ethics ERM API started');
});

function shutdown(signal: string) {
  logger.info({ signal }, 'Shutting down gracefully...');
  server.close(() => {
    logger.info('Server closed');
    process.exit(0);
  });
  setTimeout(() => { logger.error('Forced shutdown'); process.exit(1); }, 10000).unref();
}

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

export default app;
