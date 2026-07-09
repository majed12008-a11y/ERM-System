import { exec } from 'child_process';
import { promisify } from 'util';
import path from 'path';
import fs from 'fs';
import { env } from '../config/env';
import { logger } from '../config/logger';
import { BackupFile, BackupDestination, createBackupDestination } from './backup-destination';

const execAsync = promisify(exec);

export type { BackupFile };

export interface VerifyResult {
  backup: string;
  duration_seconds: number;
  entities: { entity: string; row_count: number }[];
}

export interface RetentionConfig {
  daily: number;
  weekly: number;
  monthly: number;
}

export interface RotateResult {
  deleted: string[];
  kept: string[];
}

const DEFAULT_RETENTION: RetentionConfig = {
  daily: 7,
  weekly: 4,
  monthly: 3,
};

function parseDatabaseUrl(url: string): { user: string; password: string; host: string; port: number; database: string } {
  try {
    const u = new URL(url);
    return {
      user: decodeURIComponent(u.username),
      password: decodeURIComponent(u.password),
      host: u.hostname,
      port: parseInt(u.port) || 5432,
      database: u.pathname.replace(/^\//, ''),
    };
  } catch {
    return { user: env.DB_USER, password: env.DB_PASSWORD, host: env.DB_HOST, port: env.DB_PORT, database: env.DB_NAME };
  }
}

export class BackupService {
  private destination: BackupDestination;
  private pgBin: string;
  private superUser: string;
  private superPassword: string;

  constructor() {
    this.destination = createBackupDestination();
    this.pgBin = env.PG_BIN_PATH ? env.PG_BIN_PATH + path.sep : '';
    const parsed = env.DATABASE_URL ? parseDatabaseUrl(env.DATABASE_URL) : parseDatabaseUrl('');
    this.superUser = parsed.user;
    this.superPassword = parsed.password;
  }

  private connArgs(dbName?: string): string {
    return `-h ${env.DB_HOST} -p ${env.DB_PORT} -U ${this.superUser} -d ${dbName || env.DB_NAME}`;
  }

  private sanitizeFilename(name: string): string {
    return this.destination.getPath(name);
  }

  private filePath(name: string): string {
    return this.destination.getPath(name);
  }

  private async run(cmd: string, tolerateWarnings = false): Promise<{ stdout: string; stderr: string }> {
    const fullCmd = `${this.pgBin}${cmd}`;
    logger.info({ cmd: fullCmd }, 'Running backup command');
    try {
      const result = await execAsync(fullCmd, {
        timeout: 600000,
        env: { ...process.env, PGPASSWORD: this.superPassword },
      });
      return result;
    } catch (err: any) {
      if (tolerateWarnings && err.code === 1) {
        logger.warn({ cmd: fullCmd, stderr: err.stderr }, 'Backup command completed with warnings');
        return { stdout: err.stdout || '', stderr: err.stderr || '' };
      }
      logger.error({ cmd: fullCmd, stderr: err.stderr, code: err.code }, 'Backup command failed');
      throw new Error(err.stderr || err.message);
    }
  }

  async list(): Promise<BackupFile[]> {
    return this.destination.list();
  }

  async create(label?: string): Promise<BackupFile> {
    const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
    const safeLabel = label ? `_${label.replace(/[^a-zA-Z0-9_-]/g, '')}` : '';
    const name = `ethics_db${safeLabel}_${ts}.dump`;
    const tmpPath = path.join(env.BACKUP_DIR, `.tmp_${name}`);
    try {
      const args = this.connArgs();
      await this.run(`pg_dump ${args} -Fc -f "${tmpPath}"`);
      await this.destination.store(tmpPath, name);
      const storedPath = this.destination.getPath(name);
      const stat = fs.statSync(storedPath);
      return { name, size: stat.size, created_at: stat.mtime.toISOString() };
    } finally {
      try { if (fs.existsSync(tmpPath)) fs.unlinkSync(tmpPath); } catch { /* ignore cleanup error */ }
    }
  }

  async delete(name: string): Promise<void> {
    await this.destination.delete(name);
  }

  async verify(name: string): Promise<VerifyResult> {
    const fp = this.destination.getPath(name);
    if (!fs.existsSync(fp)) throw new Error('Backup file not found');

    const verifyDb = `verify_restore_${Date.now()}`;
    const safeDb = this.sanitizeDbName(verifyDb);

    try {
      await this.run(`psql ${this.connArgs('postgres')} -c "CREATE DATABASE ${safeDb} OWNER ethics_app;"`);
      const start = Date.now();
      await this.run(`pg_restore ${this.connArgs(verifyDb)} -Fc "${fp}"`, true);
      const duration = (Date.now() - start) / 1000;

      const queries: { entity: string; sql: string }[] = [
        { entity: 'Users', sql: 'SELECT COUNT(*) FROM security.users' },
        { entity: 'Projects', sql: 'SELECT COUNT(*) FROM core.projects' },
        { entity: 'Applications', sql: 'SELECT COUNT(*) FROM core.applications' },
        { entity: 'Committees', sql: 'SELECT COUNT(*) FROM committee.committees' },
        { entity: 'Audit Logs', sql: 'SELECT COUNT(*) FROM audit.audit_logs' },
      ];

      const entities: { entity: string; row_count: number }[] = [];
      for (const q of queries) {
        const { stdout } = await this.run(`psql ${this.connArgs(verifyDb)} -At -c "${q.sql}"`);
        entities.push({ entity: q.entity, row_count: parseInt(stdout.trim()) || 0 });
      }

      await this.dropDatabase(safeDb);
      return { backup: name, duration_seconds: Math.round(duration * 10) / 10, entities };
    } catch (err) {
      await this.dropDatabase(safeDb);
      throw err;
    }
  }

  async restore(name: string): Promise<{ pre_backup: string }> {
    const fp = this.destination.getPath(name);
    if (!fs.existsSync(fp)) throw new Error('Backup file not found');

    const dbName = env.DB_NAME;
    const preName = `pre_restore_${new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19)}.dump`;
    const prePath = path.join(env.BACKUP_DIR, preName);

    const args = this.connArgs();
    await this.run(`pg_dump ${args} -Fc -f "${prePath}"`);

    const oldName = `${dbName}_old_${Date.now()}`;
    const safeOldName = this.sanitizeDbName(oldName);
    await this.terminateConnections(dbName);
    await this.run(`psql ${this.connArgs('postgres')} -c "ALTER DATABASE ${dbName} RENAME TO ${safeOldName};"`);
    await this.run(`psql ${this.connArgs('postgres')} -c "CREATE DATABASE ${dbName} OWNER ethics_app;"`);

    try {
      await this.run(`pg_restore ${this.connArgs(dbName)} -Fc "${fp}"`, true);
    } catch (err) {
      logger.error({ err, oldName: safeOldName }, 'Restore failed — reverting to original database');
      await this.dropDatabase(dbName);
      await this.terminateConnections(safeOldName);
      await this.run(`psql ${this.connArgs('postgres')} -c "ALTER DATABASE ${safeOldName} RENAME TO ${dbName};"`);
      throw err;
    }

    await this.dropDatabase(safeOldName);
    return { pre_backup: preName };
  }

  getStream(name: string): fs.ReadStream {
    return this.destination.getStream(name);
  }

  async rotate(config?: Partial<RetentionConfig>): Promise<RotateResult> {
    const ret = { ...DEFAULT_RETENTION, ...config };
    const files = await this.destination.list();
    const now = Date.now();
    const dayMs = 86400000;

    const daily: { file: BackupFile; age: number }[] = [];
    const weekly: { file: BackupFile; age: number }[] = [];
    const monthly: { file: BackupFile; age: number }[] = [];
    const deleted: string[] = [];

    for (const f of files) {
      const age = (now - new Date(f.created_at).getTime()) / dayMs;
      const dt = new Date(f.created_at);
      const isSunday = dt.getDay() === 0;
      const isFirstWeek = dt.getDate() <= 7;

      if (age <= ret.daily) {
        daily.push({ file: f, age });
      } else if (isSunday && age <= 28 && isFirstWeek) {
        monthly.push({ file: f, age });
      } else if (isSunday && age <= 28) {
        weekly.push({ file: f, age });
      } else {
        deleted.push(f.name);
      }
    }

    daily.sort((a, b) => a.age - b.age);
    while (daily.length > ret.daily) {
      const removed = daily.shift();
      if (removed) deleted.push(removed.file.name);
    }

    weekly.sort((a, b) => a.age - b.age);
    while (weekly.length > ret.weekly) {
      const removed = weekly.shift();
      if (removed) deleted.push(removed.file.name);
    }

    monthly.sort((a, b) => a.age - b.age);
    while (monthly.length > ret.monthly) {
      const removed = monthly.shift();
      if (removed) deleted.push(removed.file.name);
    }

    const kept = [...daily, ...weekly, ...monthly].map(x => x.file.name);
    for (const name of deleted) {
      try {
        await this.destination.delete(name);
        logger.info({ name, retention: 'rotate' }, 'Backup file removed by retention policy');
      } catch (err: any) {
        logger.error({ err, name }, 'Failed to remove backup during rotation');
      }
    }

    return { deleted, kept };
  }

  private async terminateConnections(dbName: string): Promise<void> {
    const safe = this.sanitizeDbName(dbName);
    try {
      await this.run(`psql ${this.connArgs('postgres')} -At -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '${safe}' AND pid <> pg_backend_pid();"`);
      await new Promise(resolve => setTimeout(resolve, 500));
      logger.info({ database: safe }, 'Active connections terminated');
    } catch (err: any) {
      logger.warn({ err, database: safe }, 'Could not terminate some connections — DDL may fail');
    }
  }

  private async dropDatabase(name: string): Promise<void> {
    await this.terminateConnections(name);
    const safe = this.sanitizeDbName(name);
    try {
      await this.run(`psql ${this.connArgs('postgres')} -c "DROP DATABASE IF EXISTS ${safe};"`);
      logger.info({ database: safe }, 'Temporary database dropped');
    } catch (err: any) {
      logger.error({ err, database: safe }, 'Failed to drop temporary database — may require manual cleanup');
    }
  }

  private sanitizeDbName(name: string): string {
    return name.replace(/[^a-zA-Z0-9_]/g, '_');
  }
}
