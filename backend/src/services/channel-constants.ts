export const CHANNEL_TYPES = {
  IN_APP: 'IN_APP',
  EMAIL: 'EMAIL',
  SMS: 'SMS',
  PUSH: 'PUSH',
} as const;

export type ChannelType = (typeof CHANNEL_TYPES)[keyof typeof CHANNEL_TYPES];

export const DELIVERY_STATUS = {
  PENDING: 'PENDING',
  SENT: 'SENT',
  DELIVERED: 'DELIVERED',
  RETRYING: 'RETRYING',
  FAILED: 'FAILED',
} as const;

export type DeliveryStatus = (typeof DELIVERY_STATUS)[keyof typeof DELIVERY_STATUS];

export const RETRY_POLICY = {
  MAX_ATTEMPTS: 3,
  BACKOFF_MINUTES: [0, 1, 5],
} as const;
