/*
 * وحدة التقارير: إحصائيات لوحة التحكم، تقارير الطلبات
 * والمشاريع واللجان، ولوحة بيانات فاعلة (Dashboard SSE).
 */
import { Router, Request, Response } from 'express';
import { authenticate } from '../../middleware/auth';
import { successResponse, errorResponse, paginatedResponse } from '../../shared/utils';
import { parsePagination } from '../../shared/pagination';
import { addDashboardClient } from '../communication/notification-service';
import { ReportingService } from '../../services/reporting.service';
import { env } from '../../config/env';

const router = Router();
const service = new ReportingService();

router.get('/dashboard/stats', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getDashboardStats((req as any).user.id)));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/dashboard/stream', async (req: Request, res: Response) => {
  const token = req.query.token as string;
  if (!token) { res.status(401).json(errorResponse('Token required')); return; }
  try {
    const secret = new TextEncoder().encode(env.JWT_SECRET);
    const { jwtVerify } = await import('jose');
    await jwtVerify(token, secret);
  } catch {
    res.status(401).json(errorResponse('Invalid token')); return;
  }

  res.writeHead(200, {
    'Content-Type': 'text/event-stream',
    'Cache-Control': 'no-cache',
    Connection: 'keep-alive',
  });
  res.write('event: connected\ndata: {}\n\n');
  addDashboardClient(res);

  const interval = setInterval(() => {
    res.write('event: ping\ndata: {}\n\n');
  }, 30000);
  req.on('close', () => clearInterval(interval));
});

router.get('/applications', authenticate, async (req: Request, res: Response) => {
  try {
    const { page, limit } = parsePagination(req.query);
    const { status, from, to, search } = req.query;
    const { rows, total } = await service.getApplications({
      status: status as string, from: from as string, to: to as string, search: search as string,
      page, limit,
    });
    res.json(paginatedResponse(rows, total, page, limit));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/committees', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getCommittees()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/status-summary', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getStatusSummary()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/applications-trend', authenticate, async (req: Request, res: Response) => {
  try {
    res.json(successResponse(await service.getApplicationsTrend()));
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

router.get('/export/applications', authenticate, async (req: Request, res: Response) => {
  try {
    const rows = await service.getExportData();
    const header = 'Application#,Status,Type,Created,Project Title,Committee,Submitted By\n';
    const csv = header + rows.map(r =>
      `"${r.application_number}","${r.current_status}","${r.application_type}","${r.created_at}","${r.project_title || ''}","${r.committee_name || ''}","${r.submitted_by || ''}"`
    ).join('\n');
    res.setHeader('Content-Type', 'text/csv');
    res.setHeader('Content-Disposition', 'attachment; filename=applications.csv');
    res.send(csv);
  } catch (err: any) { res.status(500).json(errorResponse(err.message)); }
});

export default router;
