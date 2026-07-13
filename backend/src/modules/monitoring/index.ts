import { Router, Request, Response } from 'express';
import { query, getPoolStats } from '../../config/database';
import { authenticate, authorize } from '../../middleware/auth';
import { successResponse, errorResponse } from '../../shared/utils';
import { MonitoringService } from '../../services/monitoring.service';
import { register, certificateGeneratingStuck, dbPoolTotalConnections, dbPoolIdleConnections, dbPoolWaitingRequests } from '../../services/metrics.service';
import { env } from '../../config/env';

const router = Router();
const service = new MonitoringService();

router.get('/live', (_req: Request, res: Response) => {
  res.json({ status: 'alive', service: 'ethics-erm-api' });
});

router.get('/ready', async (_req: Request, res: Response) => {
  const checks: Record<string, string> = {};
  let dbHealthy = false;

  try {
    await query('SELECT 1');
    checks.database = 'healthy';
    dbHealthy = true;
  } catch {
    checks.database = 'unhealthy';
  }

  checks.smtp = env.SMTP_HOST ? 'configured' : 'not_configured';

  res.status(dbHealthy ? 200 : 503).json({ status: dbHealthy ? 'healthy' : 'degraded', service: 'ethics-erm-api', checks });
});

router.get('/health', async (req: Request, res: Response) => {
  const checks: Record<string, string> = {};
  let dbHealthy = false;

  try {
    await query('SELECT 1');
    checks.database = 'healthy';
    dbHealthy = true;
  } catch {
    checks.database = 'unhealthy';
  }

  checks.smtp = env.SMTP_HOST ? 'configured' : 'not_configured';

  res.json({
    service: 'ethics-erm-api',
    version: '1.0.0',
    status: dbHealthy ? 'healthy' : 'degraded',
    requestId: (req as any).requestId,
    uptime: process.uptime(),
    timestamp: new Date().toISOString(),
    checks,
  });
});

router.get('/metrics', async (_req: Request, res: Response) => {
  if (!env.METRICS_ENABLED) {
    return res.status(404).json(errorResponse('Metrics not enabled'));
  }

  try {
    const stuck = await query(
      `SELECT COUNT(*)::int AS stuck_count
       FROM documents.approval_certificates
       WHERE status = 'GENERATING'
         AND updated_at < NOW() - INTERVAL '5 minutes'`
    );
    certificateGeneratingStuck.set(stuck.rows[0].stuck_count);
  } catch {
    certificateGeneratingStuck.set(0);
  }

  const poolStats = getPoolStats();
  dbPoolTotalConnections.set(poolStats.totalCount);
  dbPoolIdleConnections.set(poolStats.idleCount);
  dbPoolWaitingRequests.set(poolStats.waitingCount);

  res.set('Content-Type', register.contentType);
  res.send(await register.metrics());
});

router.get('/audit', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN'), async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getAuditLogs())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/config', authenticate, authorize('SUPER_ADMIN', 'SYS_ADMIN'), async (req: Request, res: Response) => {
  try { res.json(successResponse(await service.getSystemConfig())); }
  catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
