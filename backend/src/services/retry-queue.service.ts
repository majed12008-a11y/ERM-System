import { logger } from '../config/logger';
import { RETRY_POLICY } from './channel-constants';
import { notificationPendingRetries } from './metrics.service';

export type RetryFn = (notificationId: number, channel: string, attempt: number) => Promise<void>;

export class RetryQueueService {
  private timers = new Map<string, NodeJS.Timeout>();

  enqueue(notificationId: number, channel: string, attempt: number, retryFn: RetryFn): void {
    if (attempt >= RETRY_POLICY.MAX_ATTEMPTS) {
      logger.warn({ notificationId, channel, attempt }, 'Max retry attempts reached');
      return;
    }

    const delayMinutes = RETRY_POLICY.BACKOFF_MINUTES[attempt];
    const delayMs = delayMinutes * 60 * 1000;

    const key = `${notificationId}-${channel}`;

    if (this.timers.has(key)) {
      clearTimeout(this.timers.get(key)!);
    } else {
      notificationPendingRetries.inc();
    }

    this.timers.set(
      key,
      setTimeout(async () => {
        this.timers.delete(key);
        notificationPendingRetries.dec();
        try {
          await retryFn(notificationId, channel, attempt);
        } catch (err) {
          logger.error({ err, notificationId, channel }, 'Retry execution failed');
        }
      }, delayMs),
    );

    logger.info({ notificationId, channel, attempt, delayMinutes }, 'Retry scheduled');
  }

  cancel(notificationId: number, channel: string): void {
    const key = `${notificationId}-${channel}`;
    if (this.timers.has(key)) {
      clearTimeout(this.timers.get(key)!);
      this.timers.delete(key);
      notificationPendingRetries.dec();
    }
  }

  cancelAll(): void {
    const count = this.timers.size;
    for (const [key, timer] of this.timers) {
      clearTimeout(timer);
    }
    this.timers.clear();
    if (count > 0) {
      notificationPendingRetries.dec(count);
    }
  }
}
