/*
 * التحقق من صحة متغيرات البيئة المطلوبة (PORT, DB_HOST, DB_PORT,
 * DB_NAME, DB_USER, DB_PASSWORD, JWT_SECRET) باستخدام Zod.
 * يتحقق من وجود جميع المتغيرات قبل بدء تشغيل الخادم.
 */
import { z } from 'zod';
import crypto from 'crypto';

const envSchema = z.object({
  PORT: z.coerce.number().default(3000),
  DB_HOST: z.string().default('localhost'),
  DB_PORT: z.coerce.number().default(5432),
  DB_NAME: z.string().default('ethics_db'),
  DB_USER: z.string().default('ethics_app'),
  DB_PASSWORD: z.string(),
  JWT_SECRET: z.string().min(32, 'JWT_SECRET must be at least 32 characters'),
  LOG_LEVEL: z.enum(['fatal', 'error', 'warn', 'info', 'debug', 'trace']).default('info'),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),
  CORS_ORIGIN: z.string().default('http://localhost:5173'),
  FRONTEND_URL: z.string().url().default('http://localhost:5173'),
  BACKUP_DIR: z.string().default('backups'),
  PG_BIN_PATH: z.string().default(''),
  DATABASE_URL: z.string().default(''),
  DB_SSL: z.coerce.boolean().default(false),
  DB_SSL_REJECT_UNAUTHORIZED: z.coerce.boolean().default(true),
  DB_STATEMENT_TIMEOUT: z.coerce.number().default(30000),
  DB_IDLE_TX_TIMEOUT: z.coerce.number().default(60000),
  DB_RETRY_MAX_ATTEMPTS: z.coerce.number().default(15),
  DB_RETRY_DELAY_MS: z.coerce.number().default(5000),
  DB_ENCRYPTION_KEY: process.env.NODE_ENV === 'production'
    ? z.string().min(32, 'DB_ENCRYPTION_KEY is required in production and must be at least 32 characters')
    : z.string().optional(),
  TRUST_PROXY: z.coerce.number().default(1),
  RATE_LIMIT_GLOBAL_MAX: z.coerce.number().default(60),
  RATE_LIMIT_AUTH_WINDOW_MS: z.coerce.number().default(60000),
  RATE_LIMIT_LOGIN_MAX: z.coerce.number().default(10),
  RATE_LIMIT_REGISTER_MAX: z.coerce.number().default(5),
  RATE_LIMIT_FORGOT_MAX: z.coerce.number().default(3),
  RATE_LIMIT_REFRESH_MAX: z.coerce.number().default(10),
  RATE_LIMIT_RESET_PASSWORD_MAX: z.coerce.number().default(5),
  RATE_LIMIT_RESEND_VERIFICATION_MAX: z.coerce.number().default(5),
  RATE_LIMIT_VERIFY_MAX: z.coerce.number().default(10),
  SMTP_HOST: z.string().default('localhost'),
  SMTP_PORT: z.coerce.number().default(587),
  SMTP_SECURE: z.coerce.boolean().default(false),
  SMTP_USER: z.string().default(''),
  SMTP_PASS: z.string().default(''),
  SMTP_FROM: z.string().default('noreply@ethics.erc.gov.sa'),
  METRICS_ENABLED: z.coerce.boolean().default(true),
  BACKUP_RETENTION_DAILY: z.coerce.number().default(7),
  BACKUP_RETENTION_WEEKLY: z.coerce.number().default(4),
  BACKUP_RETENTION_MONTHLY: z.coerce.number().default(3),
  BACKUP_SCHEDULE_CRON: z.string().default('0 2 * * *'),
  BACKUP_SCHEDULE_ENABLED: z.coerce.boolean().default(false),
  BACKUP_DESTINATION_TYPE: z.enum(['local', 's3']).default('local'),
  BACKUP_S3_ENDPOINT: z.string().default(''),
  BACKUP_S3_BUCKET: z.string().default(''),
  BACKUP_S3_REGION: z.string().default(''),
  BACKUP_S3_ACCESS_KEY: z.string().default(''),
  BACKUP_S3_SECRET_KEY: z.string().default(''),
});

let env: z.infer<typeof envSchema>;

export function validateEnv() {
  const parsed = envSchema.safeParse(process.env);
  if (!parsed.success) {
    console.error('Invalid environment variables:', parsed.error.flatten());
    if (process.env.NODE_ENV === 'production') process.exit(1);
    env = envSchema.parse({ JWT_SECRET: crypto.randomBytes(32).toString('hex'), DB_PASSWORD: 'APP_PASSWORD' });
    return;
  }
  env = parsed.data;
}

validateEnv();

export { env };
