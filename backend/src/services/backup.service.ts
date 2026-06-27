/*
 * النسخ الاحتياطي لقاعدة البيانات: إنشاء نسخ احتياطية
 * باستخدام pg_dump، جدولة النسخ التلقائي،
 * وإدارة دورة حياة النسخ الاحتياطية.
 */
import { exec } from 'child_process';
import { promisify } from 'util';
import path from 'path';
import fs from 'fs';
import { env } from '../config/env';
import { logger } from '../config/logger';

const execAsync = promisify(exec);

export interface BackupFile {
  name: string;
  size: number;
  created_at: string;
}

export interface VerifyResult {
  backup: string;
  duration_seconds: number;
  entities: { entity: string; row_count: number }[];
}

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
  private backupDir: string;
  private pgBin: string;
  private superUser: string;
  private superPassword: string;

  constructor() {
    this.backupDir = path.resolve(env.BACKUP_DIR);
    this.pgBin = env.PG_BIN_PATH ? env.PG_BIN_PATH + path.sep : '';
    if (!fs.existsSync(this.backupDir)) {
      fs.mkdirSync(this.backupDir, { recursive: true });
    }
    const parsed = env.DATABASE_URL ? parseDatabaseUrl(env.DATABASE_URL) : parseDatabaseUrl('');
    this.superUser = parsed.user;
    this.superPassword = parsed.password;
  }

  private superConnString(dbName?: string): string {
    return `postgres://${this.superUser}:${this.superPassword}@${env.DB_HOST}:${env.DB_PORT}/${dbName || env.DB_NAME}`;
  }

  private sanitizeFilename(name: string): string {
    const base = path.basename(name);
    if (!base.endsWith('.dump')) throw new Error('Invalid backup file (must be .dump)');
    const resolved = path.resolve(this.backupDir, base);
    if (!resolved.startsWith(this.backupDir)) throw new Error('Invalid backup file path');
    return base;
  }

  private filePath(name: string): string {
    return path.join(this.backupDir, this.sanitizeFilename(name));
  }

  // pg_dump exits 0 on success, 1 on warnings, >=2 on error.
  // pg_restore exits 0 on success, 1 on non-fatal warnings (ignored), >=2 on fatal error.
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
    const files = fs.readdirSync(this.backupDir)
      .filter(f => f.endsWith('.dump'))
      .map(f => {
        const stat = fs.statSync(path.join(this.backupDir, f));
        return { name: f, size: stat.size, created_at: stat.mtime.toISOString() };
      })
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
    return files;
  }

  private sanitizeDbName(name: string): string {
    return name.replace(/[^a-zA-Z0-9_]/g, '_');
  }

  async create(label?: string): Promise<BackupFile> {
    const ts = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
    const safeLabel = label ? `_${label.replace(/[^a-zA-Z0-9_-]/g, '')}` : '';
    const name = `ethics_db${safeLabel}_${ts}.dump`;
    const filePath = path.join(this.backupDir, name);
    const conn = this.superConnString();
    await this.run(`pg_dump -d "${conn}" -Fc -f "${filePath}"`);
    const stat = fs.statSync(filePath);
    return { name, size: stat.size, created_at: stat.mtime.toISOString() };
  }

  async delete(name: string): Promise<void> {
    const fp = this.filePath(name);
    if (!fs.existsSync(fp)) throw new Error('Backup file not found');
    fs.unlinkSync(fp);
  }

  async verify(name: string): Promise<VerifyResult> {
    const fp = this.filePath(name);
    if (!fs.existsSync(fp)) throw new Error('Backup file not found');

    const verifyDb = `verify_restore_${Date.now()}`;
    const adminConn = this.superConnString('postgres');
    const verifyConn = this.superConnString(verifyDb);

    try {
      await this.run(`psql -d "${adminConn}" -c "CREATE DATABASE ${this.sanitizeDbName(verifyDb)} OWNER ethics_app;"`);
      const start = Date.now();
      await this.run(`pg_restore -d "${verifyConn}" -Fc "${fp}"`, true);
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
        const { stdout } = await this.run(`psql -d "${verifyConn}" -At -c "${q.sql}"`);
        entities.push({ entity: q.entity, row_count: parseInt(stdout.trim()) || 0 });
      }

      return { backup: name, duration_seconds: Math.round(duration * 10) / 10, entities };
    } finally {
      await this.run(`psql -d "${adminConn}" -c "DROP DATABASE IF EXISTS ${this.sanitizeDbName(verifyDb)};"`).catch(() => {});
    }
  }

  async restore(name: string): Promise<{ pre_backup: string }> {
    const fp = this.filePath(name);
    if (!fs.existsSync(fp)) throw new Error('Backup file not found');

    const adminConn = this.superConnString('postgres');
    const targetConn = this.superConnString();
    const dbName = env.DB_NAME;

    const preName = `pre_restore_${new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19)}.dump`;
    const prePath = path.join(this.backupDir, preName);
    await this.run(`pg_dump -d "${targetConn}" -Fc -f "${prePath}"`);

    const oldName = `${dbName}_old_${Date.now()}`;
    const safeOldName = this.sanitizeDbName(oldName);
    await this.run(`psql -d "${adminConn}" -c "ALTER DATABASE ${dbName} RENAME TO ${safeOldName};"`);
    await this.run(`psql -d "${adminConn}" -c "CREATE DATABASE ${dbName} OWNER ethics_app;"`);

    try {
      await this.run(`pg_restore -d "${targetConn}" -Fc "${fp}"`, true);
    } catch (err) {
      await this.run(`psql -d "${adminConn}" -c "DROP DATABASE IF EXISTS ${dbName};"`).catch(() => {});
      await this.run(`psql -d "${adminConn}" -c "ALTER DATABASE ${safeOldName} RENAME TO ${dbName};"`).catch(() => {});
      throw err;
    }

    await this.run(`psql -d "${adminConn}" -c "DROP DATABASE IF EXISTS ${safeOldName};"`).catch(() => {});

    return { pre_backup: preName };
  }

  getStream(name: string): fs.ReadStream {
    const fp = this.filePath(name);
    if (!fs.existsSync(fp)) throw new Error('Backup file not found');
    return fs.createReadStream(fp);
  }
}
