/*
 * إدارة الاتصال بقاعدة بيانات PostgreSQL.
 * تستخدم Pool لإدارة الاتصالات. توفر دالة query() للاستعلامات العادية
 * و withTransaction() للمعاملات. تضبط متغيرات RLS (app.user_id)
 * لكل استعلام لتقييد الوصول حسب صلاحيات المستخدم الحالي.
 */
import { Pool, PoolClient, QueryResult } from 'pg';
import { env } from './env';
import { logger } from './logger';
import { getUserId, getRequestId, getSourceIp } from '../middleware/context';
import { createHash } from 'crypto';

function sqlHash(text: string): string {
  return createHash('md5').update(text).digest('hex').substring(0, 8);
}

const sslConfig = env.DB_SSL ? { rejectUnauthorized: env.DB_SSL_REJECT_UNAUTHORIZED } : false;

const pool = new Pool({
  host: env.DB_HOST,
  port: env.DB_PORT,
  database: env.DB_NAME,
  user: env.DB_USER,
  password: env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
  ssl: sslConfig,
  keepAlive: true,
});

pool.on('connect', () => {
  logger.info({ total: pool.totalCount, idle: pool.idleCount }, 'Database client connected');
});

pool.on('acquire', () => {
  logger.debug({ total: pool.totalCount, idle: pool.idleCount, waiting: pool.waitingCount }, 'Database client acquired');
});

pool.on('remove', () => {
  logger.info({ total: pool.totalCount, idle: pool.idleCount }, 'Database client removed from pool');
});

pool.on('error', (err, client) => {
  logger.error({ err, total: pool.totalCount, idle: pool.idleCount }, 'Unexpected pool error');
});

pool.on('connect', (client) => {
  client.query("SET SESSION app.user_id = '0'").catch((err) => {
    logger.error(err, 'Failed to set initial app.user_id');
  });
  client.query(`SET SESSION statement_timeout = '${env.DB_STATEMENT_TIMEOUT}'`).catch((err) => {
    logger.error(err, 'Failed to set statement_timeout');
  });
  client.query(`SET SESSION idle_in_transaction_session_timeout = '${env.DB_IDLE_TX_TIMEOUT}'`).catch((err) => {
    logger.error(err, 'Failed to set idle_in_transaction_session_timeout');
  });
});

function formatDuration(ms: number): string {
  return ms > 1000 ? `${(ms / 1000).toFixed(2)}s` : `${ms.toFixed(0)}ms`;
}

/**
 * READ/WRITE PATH — lightweight, no BEGIN/COMMIT overhead.
 * Sets RLS user context per call via session-level set_config.
 *
 * Before: 4 round trips (BEGIN + set_config + query + COMMIT)
 * After:  2 round trips (set_config + query)
 * Reset not needed — the next call always re-sets config for its own user.
 */
export async function query(text: string, params?: any[]): Promise<QueryResult> {
  const start = Date.now();
  const userId = getUserId();
  const sourceIp = getSourceIp();
  const requestId = getRequestId();
  const client = await pool.connect();
  try {
    const safeUserId = (typeof userId === 'number' && Number.isFinite(userId)) ? userId : 0;
    await client.query(`SELECT set_config('app.user_id', $1, false)`, [String(safeUserId)]);
    await client.query(`SELECT set_config('app.source_ip', $1, false)`, [sourceIp]);
    const result = await client.query(text, params);
    return result;
  } catch (err: any) {
    logger.error({ err, text, params, sqlHash: sqlHash(text), requestId }, 'Database query error');
    throw err;
  } finally {
    const duration = Date.now() - start;
    if (duration > 1000) {
      logger.warn({ requestId, sqlHash: sqlHash(text), duration }, `Slow query (${formatDuration(duration)})`);
    } else if (duration > 100) {
      logger.info({ requestId, sqlHash: sqlHash(text), duration }, `Query (${formatDuration(duration)})`);
    }
    client.release();
  }
}

/**
 * WRITE PATH — full transaction isolation for consistency-critical writes.
 * Uses is_local=true so app.user_id auto-reverts on COMMIT/ROLLBACK.
 */
export async function withTransaction<T>(
  fn: (client: PoolClient) => Promise<T>
): Promise<T> {
  const start = Date.now();
  const client = await pool.connect();
  const userId = getUserId();
  const sourceIp = getSourceIp();
  const requestId = getRequestId();
  try {
    await client.query('BEGIN');
    const safeUserId = (typeof userId === 'number' && Number.isFinite(userId)) ? userId : 0;
    await client.query(`SELECT set_config('app.user_id', $1, true)`, [String(safeUserId)]);
    await client.query(`SELECT set_config('app.source_ip', $1, true)`, [sourceIp]);
    const result = await fn(client);
    await client.query('COMMIT');
    const duration = Date.now() - start;
    if (duration > 1000) {
      logger.warn({ requestId, sqlHash: 'transaction', duration }, `Slow transaction (${formatDuration(duration)})`);
    } else if (duration > 100) {
      logger.info({ requestId, sqlHash: 'transaction', duration }, `Transaction (${formatDuration(duration)})`);
    }
    return result;
  } catch (err) {
    await client.query('ROLLBACK').catch(() => {});
    const duration = Date.now() - start;
    logger.error({ err, requestId, sqlHash: 'transaction', duration }, `Transaction failed (${formatDuration(duration)})`);
    throw err;
  } finally {
    client.release();
  }
}

export async function getClient(): Promise<PoolClient> {
  return pool.connect();
}

export function getPoolStats() {
  return {
    totalCount: pool.totalCount,
    idleCount: pool.idleCount,
    waitingCount: pool.waitingCount,
  };
}

export async function waitForDatabase(): Promise<void> {
  const maxAttempts = env.DB_RETRY_MAX_ATTEMPTS;
  const delayMs = env.DB_RETRY_DELAY_MS;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      const client = await pool.connect();
      await client.query('SELECT 1');
      client.release();
      logger.info({ attempt }, 'Database connection established');
      return;
    } catch (err: any) {
      if (attempt === maxAttempts) {
        logger.fatal({ err, attempt, maxAttempts }, 'Database unreachable — exhausted retries');
        process.exit(1);
      }
      logger.warn({ err, attempt, maxAttempts, delayMs }, 'Database not ready — retrying');
      await new Promise(resolve => setTimeout(resolve, delayMs));
    }
  }
}

export default pool;
