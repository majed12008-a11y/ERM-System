import { Request, Response, NextFunction } from 'express';
import { logger } from '../config/logger';

export class AppError extends Error {
  constructor(public statusCode: number, message: string) {
    super(message);
    this.name = 'AppError';
  }
}

export function errorHandler(err: Error | AppError, req: Request, res: Response, _next: NextFunction) {
  const requestId = (req as any).requestId || '-';
  const statusCode = err instanceof AppError ? err.statusCode : 500;

  logger.error({ err, requestId, statusCode }, 'Request error');

  res.status(statusCode).json({
    success: false,
    error: process.env.NODE_ENV === 'production' && statusCode === 500 ? 'Internal server error' : err.message,
    requestId,
  });
}

export function notFoundHandler(req: Request, res: Response) {
  res.status(404).json({
    success: false,
    error: `Route ${req.method} ${req.path} not found`,
    requestId: (req as any).requestId || '-',
  });
}
