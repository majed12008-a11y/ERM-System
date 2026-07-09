import { Request, Response, NextFunction } from 'express';
import { httpRequestsTotal, httpRequestDurationSeconds, httpRequestsInFlight } from '../services/metrics.service';

export function metricsMiddleware(req: Request, res: Response, next: NextFunction) {
  const method = req.method;
  httpRequestsInFlight.inc({ method });
  const start = process.hrtime.bigint();

  res.on('finish', () => {
    const durationSeconds = Number(process.hrtime.bigint() - start) / 1e9;

    const route = (req.route as any)?.path
      ? (req.baseUrl || '') + (req.route as any).path
      : req.path.replace(/\/\d+/g, '/:id');

    const status = String(res.statusCode);
    httpRequestsTotal.inc({ method, route, status });
    httpRequestDurationSeconds.observe({ method, route, status }, durationSeconds);
    httpRequestsInFlight.dec({ method });
  });

  next();
}
