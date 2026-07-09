import promClient from 'prom-client';

const register = new promClient.Registry();

promClient.collectDefaultMetrics({ register });

export const httpRequestsTotal = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total number of HTTP requests',
  labelNames: ['method', 'route', 'status'] as const,
  registers: [register],
});

export const httpRequestDurationSeconds = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'HTTP request duration in seconds',
  labelNames: ['method', 'route', 'status'] as const,
  buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
  registers: [register],
});

export const httpRequestsInFlight = new promClient.Gauge({
  name: 'http_requests_in_flight',
  help: 'Number of HTTP requests currently in flight',
  labelNames: ['method'] as const,
  registers: [register],
});

export const workflowTransitionsTotal = new promClient.Counter({
  name: 'workflow_transitions_total',
  help: 'Total number of workflow transitions',
  labelNames: ['workflow', 'transition', 'result'] as const,
  registers: [register],
});

export const workflowTransitionDurationSeconds = new promClient.Histogram({
  name: 'workflow_transition_duration_seconds',
  help: 'Workflow transition duration in seconds',
  labelNames: ['workflow', 'transition'] as const,
  buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
  registers: [register],
});

export const workflowTransitionFailuresTotal = new promClient.Counter({
  name: 'workflow_transition_failures_total',
  help: 'Total number of failed workflow transitions',
  labelNames: ['workflow', 'transition', 'reason'] as const,
  registers: [register],
});

export const notificationsSentTotal = new promClient.Counter({
  name: 'notifications_sent_total',
  help: 'Total number of notification delivery attempts',
  labelNames: ['type', 'channel', 'status'] as const,
  registers: [register],
});

export const notificationDeliveryDurationSeconds = new promClient.Histogram({
  name: 'notification_delivery_duration_seconds',
  help: 'Notification delivery duration in seconds',
  labelNames: ['channel'] as const,
  buckets: [0.01, 0.05, 0.1, 0.25, 0.5, 1, 2.5, 5, 10],
  registers: [register],
});

export const notificationSSEConnections = new promClient.Gauge({
  name: 'notification_sse_connections',
  help: 'Current number of active SSE connections',
  registers: [register],
});

export const notificationPendingRetries = new promClient.Gauge({
  name: 'notification_pending_retries',
  help: 'Current number of notifications pending retry',
  registers: [register],
});

export const certificateOperationsTotal = new promClient.Counter({
  name: 'certificate_operations_total',
  help: 'Total number of certificate lifecycle operations',
  labelNames: ['operation', 'result'] as const,
  registers: [register],
});

export const certificateGenerationDurationSeconds = new promClient.Histogram({
  name: 'certificate_generation_duration_seconds',
  help: 'Certificate generation duration in seconds (PDF render + save)',
  labelNames: ['operation'] as const,
  buckets: [0.1, 0.5, 1, 2.5, 5, 10, 30, 60],
  registers: [register],
});

export const certificateVerificationsTotal = new promClient.Counter({
  name: 'certificate_verifications_total',
  help: 'Total number of certificate verification attempts',
  labelNames: ['result'] as const,
  registers: [register],
});

export const certificateGeneratingStuck = new promClient.Gauge({
  name: 'certificate_generating_stuck',
  help: 'Number of certificates stuck in GENERATING status for >5 minutes',
  registers: [register],
});

export const dbPoolTotalConnections = new promClient.Gauge({
  name: 'db_pool_total_connections',
  help: 'Total number of database connections in the pool',
  registers: [register],
});

export const dbPoolIdleConnections = new promClient.Gauge({
  name: 'db_pool_idle_connections',
  help: 'Number of idle database connections in the pool',
  registers: [register],
});

export const dbPoolWaitingRequests = new promClient.Gauge({
  name: 'db_pool_waiting_requests',
  help: 'Number of queued requests waiting for a database connection',
  registers: [register],
});

export { register };
