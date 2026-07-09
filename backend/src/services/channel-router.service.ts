import { query } from '../config/database';
import { DEFAULT_CHANNELS } from './notification-types';

export class ChannelRouterService {
  async resolveChannels(notificationType: string, userId: number): Promise<string[]> {
    const defaults = DEFAULT_CHANNELS[notificationType] ?? ['IN_APP'];

    const prefs = await this.loadUserPreferences(userId);
    const matchingPrefs = prefs.filter(
      p => p.notification_type === notificationType || p.notification_type === '*'
    );

    if (matchingPrefs.length === 0) {
      return defaults;
    }

    const disabledChannels = new Set<string>(
      matchingPrefs.filter(p => !p.is_enabled).map(p => p.channel)
    );

    return defaults.filter(ch => !disabledChannels.has(ch));
  }

  private async loadUserPreferences(userId: number): Promise<{ notification_type: string; channel: string; is_enabled: boolean }[]> {
    const result = await query(
      `SELECT notification_type, channel, is_enabled
       FROM communication.user_notification_preferences
       WHERE user_id = $1`,
      [userId]
    );
    return result.rows;
  }
}
