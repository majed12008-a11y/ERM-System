/*
 * نظام تسجيل الأحداث (Logging) باستخدام Pino.
 * يدعم مستويات متعددة (info، warn، error، fatal)
 * وتنسيق JSON للإنتاج و pino-pretty للتطوير.
 */
import pino from 'pino';
import pinoHttp from 'pino-http';
import { env } from './env';

function serializeError(err: any): Record<string, any> {
  if (!err) return {};
  return {
    type: err.name || 'Error',
    message: err.message,
    stack: env.NODE_ENV === 'development' ? err.stack : undefined,
    ...(err.statusCode ? { statusCode: err.statusCode } : {}),
  };
}

const pinoTransport = env.NODE_ENV === 'development'
  ? (process.env.PINOLOG_FILE
      ? { target: 'pino-pretty', options: { destination: process.env.PINOLOG_FILE } }
      : { target: 'pino-pretty' })
  : undefined;

export const logger = pino({
  level: env.LOG_LEVEL,
  transport: pinoTransport,
  redact: ['req.headers.authorization', 'req.body.password', 'req.body.oldPassword', 'req.body.newPassword'],
  serializers: {
    err: serializeError,
    error: serializeError,
  },
});

export const httpLogger = pinoHttp({
  logger,
  autoLogging: {
    ignore: (req) => ['/api/v1/health', '/api/v1/monitoring/live', '/api/v1/monitoring/ready', '/api/v1/monitoring/health'].includes(req.url ?? ''),
  },
  customReceivedMessage: (req) => `← ${req.method} ${req.url}`,
  customSuccessMessage: (req, res) => `→ ${req.method} ${req.url} ${res.statusCode}`,
  customErrorMessage: (req, res, err) => `✗ ${req.method} ${req.url} ${res.statusCode}`,
});
