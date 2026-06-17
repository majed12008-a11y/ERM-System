import { Pool, PoolClient, QueryResult } from 'pg';
import { env } from './env';
import { logger } from './logger';
import { getUserId, getRequestId } from '../middleware/context';
import { createHash } from 'crypto';

function sqlHash(text: string): string {
  return createHash('md5').update(text).digest('hex').substring(0, 8);
}

const pool = new Pool({
  host: env.DB_HOST,
  port: env.DB_PORT,
  database: env.DB_NAME,
  user: env.DB_USER,
  password: env.DB_PASSWORD,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

pool.on('error', (err) => {
  logger.error(err, 'Unexpected pool error');
});

pool.on('connect', (client) => {
  client.query("SET SESSION app.user_id = '0'").catch((err) => {
    logger.error(err, 'Failed to set initial app.user_id');
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
  const requestId = getRequestId();
  const client = await pool.connect();
  try {
    await client.query(`SELECT set_config('app.user_id', $1, false)`, [String(userId)]);
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
  const requestId = getRequestId();
  try {
    await client.query('BEGIN');
    await client.query(`SELECT set_config('app.user_id', $1, true)`, [String(userId)]);
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

export default pool;
