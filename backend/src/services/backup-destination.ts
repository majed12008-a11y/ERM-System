import fs from 'fs';
import path from 'path';
import { env } from '../config/env';
import { logger } from '../config/logger';

export interface BackupFile {
  name: string;
  size: number;
  created_at: string;
}

export interface BackupDestination {
  list(): Promise<BackupFile[]>;
  store(sourcePath: string, name: string): Promise<string>;
  retrieve(name: string, destPath: string): Promise<string>;
  delete(name: string): Promise<void>;
  getStream(name: string): fs.ReadStream;
  getPath(name: string): string;
}

export class LocalBackupDestination implements BackupDestination {
  private dir: string;

  constructor(dir: string) {
    this.dir = path.resolve(dir);
    if (!fs.existsSync(this.dir)) {
      fs.mkdirSync(this.dir, { recursive: true });
    }
  }

  async list(): Promise<BackupFile[]> {
    const files = fs.readdirSync(this.dir)
      .filter(f => f.endsWith('.dump'))
      .map(f => {
        const stat = fs.statSync(path.join(this.dir, f));
        return { name: f, size: stat.size, created_at: stat.mtime.toISOString() };
      })
      .sort((a, b) => new Date(b.created_at).getTime() - new Date(a.created_at).getTime());
    return files;
  }

  async store(sourcePath: string, name: string): Promise<string> {
    const dest = this.getPath(name);
    fs.copyFileSync(sourcePath, dest);
    logger.info({ name, sourcePath, dest }, 'Backup file stored locally');
    return dest;
  }

  async retrieve(name: string, destPath: string): Promise<string> {
    const src = this.getPath(name);
    fs.copyFileSync(src, destPath);
    return destPath;
  }

  async delete(name: string): Promise<void> {
    const fp = this.getPath(name);
    if (!fs.existsSync(fp)) throw new Error('Backup file not found');
    fs.unlinkSync(fp);
    logger.info({ name }, 'Backup file deleted from local storage');
  }

  getStream(name: string): fs.ReadStream {
    const fp = this.getPath(name);
    if (!fs.existsSync(fp)) throw new Error('Backup file not found');
    return fs.createReadStream(fp);
  }

  getPath(name: string): string {
    const base = path.basename(name);
    if (!base.endsWith('.dump')) throw new Error('Invalid backup file (must be .dump)');
    const resolved = path.resolve(this.dir, base);
    if (!resolved.startsWith(path.resolve(this.dir))) throw new Error('Invalid backup file path');
    try {
      const canonical = fs.realpathSync(resolved);
      if (!canonical.startsWith(path.resolve(this.dir))) throw new Error('Invalid backup file path (canonical mismatch)');
    } catch (err: any) {
      if (err.code !== 'ENOENT') throw err;
    }
    return resolved;
  }
}

export class S3BackupDestination implements BackupDestination {
  constructor() {
    if (!env.BACKUP_S3_BUCKET) {
      throw new Error('BACKUP_S3_BUCKET is required when BACKUP_DESTINATION_TYPE=s3');
    }
    if (!env.BACKUP_S3_REGION) {
      throw new Error('BACKUP_S3_REGION is required when BACKUP_DESTINATION_TYPE=s3');
    }
    logger.info({ bucket: env.BACKUP_S3_BUCKET, region: env.BACKUP_S3_REGION }, 'S3 backup destination configured');
  }

  async list(): Promise<BackupFile[]> {
    throw new Error('S3 backup destination: list() not yet implemented');
  }

  async store(_sourcePath: string, name: string): Promise<string> {
    throw new Error(`S3 backup destination: store() not yet implemented — would upload ${name}`);
  }

  async retrieve(_name: string, _destPath: string): Promise<string> {
    throw new Error('S3 backup destination: retrieve() not yet implemented');
  }

  async delete(_name: string): Promise<void> {
    throw new Error('S3 backup destination: delete() not yet implemented');
  }

  getStream(_name: string): fs.ReadStream {
    throw new Error('S3 backup destination: getStream() not yet implemented');
  }

  getPath(name: string): string {
    return name;
  }
}

export function createBackupDestination(): BackupDestination {
  const type = env.BACKUP_DESTINATION_TYPE || 'local';
  switch (type) {
    case 's3':
      return new S3BackupDestination();
    case 'local':
    default:
      return new LocalBackupDestination(env.BACKUP_DIR);
  }
}
