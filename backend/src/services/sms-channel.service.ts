import { logger } from '../config/logger';

export interface SmsResult {
  success: boolean;
  reference?: string;
  error?: string;
}

export interface SmsProvider {
  send(to: string, message: string): Promise<SmsResult>;
}

export class MockSmsProvider implements SmsProvider {
  async send(to: string, message: string): Promise<SmsResult> {
    logger.info({ to, messageLength: message.length }, '[Mock SMS] Would send SMS');
    return { success: true, reference: `mock-${Date.now()}` };
  }
}

export class SmsChannelService {
  private provider: SmsProvider;

  constructor(provider?: SmsProvider) {
    this.provider = provider ?? new MockSmsProvider();
  }

  async send(to: string, message: string): Promise<SmsResult> {
    return this.provider.send(to, message);
  }
}
