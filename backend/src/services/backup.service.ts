import { execFile } from 'child_process';
import { promisify } from 'util';
import path from 'path';
import fs from 'fs';
import { env } from '../config/env';
import { logger } from '../config/logger';
import { BackupFile, BackupDestination, createBackupDestination } from './backup-destination';

const execFileAsync = promisify(execFile);

export type { BackupFile };

export class BackupError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly stdout?: string,
    public readonly stderr?: string,
  ) {
    super(message);
    this.name = this.constructor.name;
  }
}

export class ValidationError extends BackupError {
  constructor(message: string) {
    super(message, 'VALIDATION_ERROR');
  }
}

export class ExecutionError extends BackupError {
  constructor(message: string, stdout?: string, stderr?: string) {
    super(message, 'EXECUTION_ERROR', stdout, stderr);
  }
}

export class TimeoutError extends BackupError {
  constructor(message: string, stdout?: string, stderr?: string) {
    super(message, 'TIMEOUT_ERROR', stdout, stderr);
  }
}

export class FileNotFoundError extends BackupError {
  constructor(message: string) {
    super(message, 'FILE_NOT_FOUND');
  }
}

export class BackupIntegrityError extends BackupError {
  constructor(message: string) {
    super(message, 'BACKUP_INTEGRITY_ERROR');
  }
}

export class PermissionError extends BackupError {
  constructor(message: string) {
    super(message, 'PERMISSION_ERROR');
  }
}

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

interface RunOptions {
  tolerateWarnings?: boolean;
  timeout?: number;
}

const BACKUP_NAME_REGEX = /^[a-zA-Z0-9_.-]+$/;

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
  private maskPattern: RegExp;

  constructor() {
    this.destination = createBackupDestination();
    this.pgBin = env.PG_BIN_PATH || '';
    const parsed = env.DATABASE_URL ? parseDatabaseUrl(env.DATABASE_URL) : parseDatabaseUrl('');
    this.superUser = parsed.user;
    this.superPassword = parsed.password;
    this.maskPattern = new RegExp(this.escapeRegex(this.superPassword), 'g');
  }

  private escapeRegex(s: string): string {
    return s.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  }

  private maskCredentials(text: string): string {
    if (!text) return text;
    return text.replace(this.maskPattern, '***');
  }

  private connArgs(dbName?: string): string[] {
    return ['-h', env.DB_HOST, '-p', String(env.DB_PORT), '-U', this.superUser, '-d', dbName || env.DB_NAME];
  }

  private sanitizeFilename(name: string): string {
    return this.destination.getPath(name);
  }

  private filePath(name: string): string {
    return this.destination.getPath(name);
  }

  private async run(executable: string, args: string[], options?: RunOptions): Promise<{ stdout: string; stderr: string }> {
    const execPath = this.pgBin ? path.join(this.pgBin, executable) : executable;
    const timeout = options?.timeout ?? 600000;
    const tolerateWarnings = options?.tolerateWarnings ?? false;

    logger.info({ cmd: `${execPath} ${executable}`, argCount: args.length }, 'Running backup command');

    try {
      const result = await execFileAsync(execPath, args, {
        timeout,
        killSignal: 'SIGTERM',
        env: { ...process.env, PGPASSWORD: this.superPassword },
        maxBuffer: 1024 * 1024,
      });
      return result;
    } catch (err: any) {
      const stderr = this.maskCredentials(err.stderr || '');
      const stdout = this.maskCredentials(err.stdout || '');

      if (tolerateWarnings && err.code === 1) {
        logger.warn({ cmd: executable, exitCode: err.code }, 'Command completed with warnings');
        return { stdout: stdout || '', stderr: stderr || '' };
      }

      if (err.killed || err.signal) {
        logger.error({ cmd: executable, signal: err.signal, timeout }, 'Command timed out');
        throw new TimeoutError(`Command timed out after ${timeout}ms`, stdout, stderr);
      }

      if (err.code === 'ENOENT') {
        logger.error({ cmd: executable, execPath }, 'Command not found');
        throw new FileNotFoundError(`Executable not found: ${executable}`);
      }

      if (err.code === 'EACCES') {
        logger.error({ cmd: executable, execPath }, 'Permission denied');
        throw new PermissionError(`Permission denied: ${executable}`);
      }

      logger.error({ cmd: executable, exitCode: err.code }, 'Command failed');
      throw new ExecutionError(stderr || err.message, stdout, stderr);
    }
  }

  private validateName(name: string): string {
    if (!name || typeof name !== 'string') {
      throw new ValidationError('Backup name is required');
    }
    if (name.length > 128) {
      throw new ValidationError('Backup name must be at most 128 characters');
    }
    if (!BACKUP_NAME_REGEX.test(name)) {
      throw new ValidationError('Backup name contains invalid characters. Allowed: A-Z, a-z, 0-9, _, -, .');
    }
    if (!name.endsWith('.dump')) {
      throw new ValidationError('Backup name must end with .dump');
    }
    return name;
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
      await this.run('pg_dump', [...this.connArgs(), '-Fc', '-f', tmpPath]);
      await this.destination.store(tmpPath, name);
      const storedPath = this.destination.getPath(name);
      const stat = fs.statSync(storedPath);
      return { name, size: stat.size, created_at: stat.mtime.toISOString() };
    } finally {
      this.cleanupTempFile(tmpPath);
    }
  }

  async delete(name: string): Promise<void> {
    this.validateName(name);
    await this.destination.delete(name);
  }

  async verify(name: string): Promise<VerifyResult> {
    this.validateName(name);
    const fp = this.destination.getPath(name);
    if (!fs.existsSync(fp)) throw new FileNotFoundError('Backup file not found');

    const verifyDb = `verify_restore_${Date.now()}`;
    const safeDb = this.sanitizeDbName(verifyDb);

    try {
      await this.run('psql', [...this.connArgs('postgres'), '-c', `CREATE DATABASE ${safeDb} OWNER ethics_app;`]);
      const start = Date.now();
      await this.run('pg_restore', [...this.connArgs(verifyDb), '-Fc', fp], { tolerateWarnings: true });
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
        const { stdout } = await this.run('psql', [...this.connArgs(verifyDb), '-At', '-c', q.sql]);
        entities.push({ entity: q.entity, row_count: parseInt(stdout.trim()) || 0 });
      }

      await this.dropDatabase(safeDb);
      return { backup: name, duration_seconds: Math.round(duration * 10) / 10, entities };
    } catch (err) {
      await this.dropDatabase(safeDb);
      if (err instanceof BackupError) throw err;
      throw new BackupIntegrityError(`Backup verification failed: ${err instanceof Error ? err.message : 'unknown error'}`);
    }
  }

  async restore(name: string): Promise<{ pre_backup: string }> {
    this.validateName(name);
    const fp = this.destination.getPath(name);
    if (!fs.existsSync(fp)) throw new FileNotFoundError('Backup file not found');

    const dbName = env.DB_NAME;
    const preName = `pre_restore_${new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19)}.dump`;
    const prePath = path.join(env.BACKUP_DIR, preName);

    await this.run('pg_dump', [...this.connArgs(), '-Fc', '-f', prePath]);

    const oldName = `${dbName}_old_${Date.now()}`;
    const safeOldName = this.sanitizeDbName(oldName);
    await this.terminateConnections(dbName);
    await this.run('psql', [...this.connArgs('postgres'), '-c', `ALTER DATABASE "${dbName}" RENAME TO "${safeOldName}";`]);
    await this.run('psql', [...this.connArgs('postgres'), '-c', `CREATE DATABASE "${dbName}" OWNER ethics_app;`]);

    try {
      await this.run('pg_restore', [...this.connArgs(dbName), '-Fc', fp], { tolerateWarnings: true });
    } catch (err) {
      logger.error({ oldName: safeOldName }, 'Restore failed — reverting to original database');
      await this.dropDatabase(dbName);
      await this.terminateConnections(safeOldName);
      try {
        await this.run('psql', [...this.connArgs('postgres'), '-c', `ALTER DATABASE "${safeOldName}" RENAME TO "${dbName}";`]);
      } catch (renameErr: any) {
        logger.error({ err: renameErr, oldName: safeOldName }, 'Rollback rename failed — manual intervention required');
        throw new BackupIntegrityError(
          `Restore failed and rollback rename also failed. Pre-restore backup: ${preName}. Old database: ${safeOldName}. Manual intervention required.`,
        );
      }
      if (err instanceof BackupError) throw err;
      throw new ExecutionError(`Restore failed: ${err instanceof Error ? err.message : 'unknown error'}`);
    }

    await this.dropDatabase(safeOldName);
    return { pre_backup: preName };
  }

  getStream(name: string): fs.ReadStream {
    this.validateName(name);
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
    for (const fName of deleted) {
      try {
        await this.destination.delete(fName);
        logger.info({ name: fName, retention: 'rotate' }, 'Backup file removed by retention policy');
      } catch (err: any) {
        logger.error({ err, name: fName }, 'Failed to remove backup during rotation');
      }
    }

    return { deleted, kept };
  }

  private async terminateConnections(dbName: string): Promise<void> {
    const safe = this.sanitizeDbName(dbName);
    try {
      await this.run('psql', [...this.connArgs('postgres'), '-At', '-c',
        `SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '${safe}' AND pid <> pg_backend_pid();`,
      ]);
      await new Promise(resolve => setTimeout(resolve, 500));
      logger.info({ database: safe }, 'Active connections terminated');
    } catch (err: any) {
      logger.warn({ err: err.message, database: safe }, 'Could not terminate some connections — DDL may fail');
    }
  }

  private async dropDatabase(name: string): Promise<void> {
    await this.terminateConnections(name);
    const safe = this.sanitizeDbName(name);
    try {
      await this.run('psql', [...this.connArgs('postgres'), '-c', `DROP DATABASE IF EXISTS "${safe}";`]);
      logger.info({ database: safe }, 'Temporary database dropped');
    } catch (err: any) {
      logger.error({ err: err.message, database: safe }, 'Failed to drop temporary database — may require manual cleanup');
    }
  }

  private sanitizeDbName(name: string): string {
    return name.replace(/[^a-zA-Z0-9_]/g, '_');
  }

  private cleanupTempFile(filePath: string): void {
    try {
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    } catch {
      /* ignore cleanup error */
    }
  }
}
