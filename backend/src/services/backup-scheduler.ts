import { CronJob } from 'cron';
import { env } from '../config/env';
import { logger } from '../config/logger';
import { BackupService } from './backup.service';

export class BackupScheduler {
  private job: CronJob | null = null;
  private service: BackupService;

  constructor(service?: BackupService) {
    this.service = service || new BackupService();
  }

  start(): void {
    if (!env.BACKUP_SCHEDULE_ENABLED) {
      logger.info('Backup scheduler is disabled (BACKUP_SCHEDULE_ENABLED=false)');
      return;
    }

    const cronExpr = env.BACKUP_SCHEDULE_CRON;
    logger.info({ cronExpr }, 'Starting backup scheduler');

    this.job = new CronJob(
      cronExpr,
      () => this.execute(),
      null,
      true,
      'UTC',
    );
  }

  stop(): void {
    if (this.job) {
      this.job.stop();
      this.job = null;
      logger.info('Backup scheduler stopped');
    }
  }

  private async execute(): Promise<void> {
    const start = Date.now();
    logger.info('Scheduled backup started');

    try {
      const backup = await this.service.create('scheduled');
      logger.info({ name: backup.name, size: backup.size, durationMs: Date.now() - start }, 'Scheduled backup created');

      const rotateResult = await this.service.rotate();
      if (rotateResult.deleted.length > 0) {
        logger.info({ deleted: rotateResult.deleted.length, kept: rotateResult.kept.length }, 'Retention rotation completed');
      }
    } catch (err: any) {
      logger.error({ err, durationMs: Date.now() - start }, 'Scheduled backup failed');
    }
  }
}
