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

export const logger = pino({
  level: env.LOG_LEVEL,
  transport: env.NODE_ENV === 'development' ? { target: 'pino-pretty' } : undefined,
  redact: ['req.headers.authorization', 'req.body.password', 'req.body.oldPassword', 'req.body.newPassword'],
  serializers: {
    err: serializeError,
    error: serializeError,
  },
});

export const httpLogger = pinoHttp({
  logger,
  autoLogging: {
    ignore: (req) => req.url === '/api/v1/health',
  },
  customReceivedMessage: (req) => `← ${req.method} ${req.url}`,
  customSuccessMessage: (req, res) => `→ ${req.method} ${req.url} ${res.statusCode}`,
  customErrorMessage: (req, res, err) => `✗ ${req.method} ${req.url} ${res.statusCode}`,
});
