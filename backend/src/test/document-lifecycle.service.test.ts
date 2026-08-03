import { describe, it, expect, vi, beforeEach } from 'vitest';
import { DocumentLifecycleService } from '../services/document-lifecycle.service';

const user = {
  id: 1,
  uuid: '',
  institution_id: 1,
  username: 'admin',
  email: 'admin@test.com',
  status: 'ACTIVE',
  roles: ['SUPER_ADMIN'],
  is_email_verified: true,
};

const okResult = {
  ok: true,
  message: 'Transition applied',
  new_status: 'ISSUED',
  document_number: 'DOC-001',
  action_code: 'ISSUE',
  from_code: 'APPROVED',
  to_code: 'ISSUED',
  is_terminal: false,
  document: {
    id: 10,
    document_number: 'DOC-001',
    document_uuid: 'uuid-1',
    document_title: 'Test doc',
    status: 'ISSUED',
    lifecycle_state_id: 5,
  },
  timestamp: '2026-08-03T10:00:00.000Z',
};

describe('DocumentLifecycleService', () => {
  let service: DocumentLifecycleService;
  let mockRepo: any;

  beforeEach(() => {
    mockRepo = {
      listStates: vi.fn(),
      listTransitions: vi.fn(),
      applyTransition: vi.fn(),
    };
    service = new DocumentLifecycleService(mockRepo);
    vi.clearAllMocks();
  });

  it('lists active states ordered by sort_order', async () => {
    mockRepo.listStates.mockResolvedValue([{ code: 'DRAFT', sort_order: 10 }]);
    const states = await service.listStates();
    expect(states).toHaveLength(1);
    expect(states[0].code).toBe('DRAFT');
    expect(mockRepo.listStates).toHaveBeenCalledOnce();
  });

  it('lists configured transitions', async () => {
    mockRepo.listTransitions.mockResolvedValue([{ action_code: 'ISSUE', from_code: 'APPROVED' }]);
    const transitions = await service.listTransitions();
    expect(transitions[0].action_code).toBe('ISSUE');
    expect(mockRepo.listTransitions).toHaveBeenCalledOnce();
  });

  it('applies a transition and returns the enriched result', async () => {
    mockRepo.applyTransition.mockResolvedValue(okResult);
    const result = await service.transition(10, 'ISSUE', 'approved by chair', user);
    expect(result.ok).toBe(true);
    expect(result.to_code).toBe('ISSUED');
    expect(mockRepo.applyTransition).toHaveBeenCalledWith(10, 'ISSUE', user.id, 'approved by chair', undefined);
  });

  it('rejects an undefined/not-allowed transition with 400', async () => {
    mockRepo.applyTransition.mockResolvedValue({
      ...okResult,
      ok: false,
      message: 'Action ARCHIVE is not allowed from state ISSUED',
      new_status: null,
      to_code: null,
      is_terminal: false,
    });
    const err = await service.transition(10, 'ARCHIVE', 'x', user).catch((e: any) => e);
    expect(err.status).toBe(400);
    expect(err.message).toMatch(/not allowed/);
  });

  it('dispatches action-specific and wildcard handlers after a successful transition', async () => {
    mockRepo.applyTransition.mockResolvedValue(okResult);
    const issuedHandler = vi.fn();
    const anyHandler = vi.fn();
    service.onAction('ISSUE', issuedHandler);
    service.onAny(anyHandler);

    await service.transition(10, 'ISSUE', 'go', user);

    expect(issuedHandler).toHaveBeenCalledTimes(1);
    expect(anyHandler).toHaveBeenCalledTimes(1);
    const ctx = issuedHandler.mock.calls[0][0];
    expect(ctx.documentId).toBe(10);
    expect(ctx.actionCode).toBe('ISSUE');
    expect(ctx.fromCode).toBe('APPROVED');
    expect(ctx.toCode).toBe('ISSUED');
    expect(ctx.isTerminal).toBe(false);
    expect(ctx.actor.id).toBe(user.id);
    expect(ctx.actor.username).toBe('admin');
    expect(ctx.reason).toBe('go');
    expect(ctx.documentNumber).toBeUndefined();
    expect(ctx.document.document_number).toBe('DOC-001');
  });

  it('hands handlers a complete serializable transition context', async () => {
    mockRepo.applyTransition.mockResolvedValue(okResult);
    const h = vi.fn();
    service.onAny(h);

    await service.transition(
      10, 'ISSUE', 'go', user, { channel: 'notify' },
      { correlationId: 'corr-123', requestId: 'req-456' }
    );

    const ctx = h.mock.calls[0][0];
    expect(ctx.document).toEqual(okResult.document);
    expect(ctx.timestamp).toBe('2026-08-03T10:00:00.000Z');
    expect(ctx.details).toEqual({ channel: 'notify' });
    expect(ctx.actor).toEqual({ id: user.id, username: user.username });
    expect(ctx.correlationId).toBe('corr-123');
    expect(ctx.requestId).toBe('req-456');
  });

  it('defaults correlationId to requestId when not supplied', async () => {
    mockRepo.applyTransition.mockResolvedValue(okResult);
    const h = vi.fn();
    service.onAny(h);

    await service.transition(10, 'ISSUE', 'go', user, undefined, { requestId: 'req-abc' });

    const ctx = h.mock.calls[0][0];
    expect(ctx.requestId).toBe('req-abc');
    expect(ctx.correlationId).toBe('req-abc');
  });

  it('does not dispatch handlers when the transition is rejected', async () => {
    mockRepo.applyTransition.mockResolvedValue({
      ...okResult,
      ok: false,
      message: 'Action ARCHIVE is not allowed from state ISSUED',
    });
    const h = vi.fn();
    service.onAny(h);
    await service.transition(10, 'ARCHIVE', 'x', user).catch(() => {});
    expect(h).not.toHaveBeenCalled();
  });

  it('logs a failing handler without failing the already-committed transition', async () => {
    mockRepo.applyTransition.mockResolvedValue(okResult);
    const bad = vi.fn(async () => {
      throw new Error('notify boom');
    });
    service.onAction('ISSUE', bad);

    const result = await service.transition(10, 'ISSUE', 'go', user);
    expect(result.ok).toBe(true);
    expect(bad).toHaveBeenCalledTimes(1);
  });

  it('passes through optional details to the repository', async () => {
    mockRepo.applyTransition.mockResolvedValue(okResult);
    await service.transition(10, 'ISSUE', undefined, user, { channel: 'notify' });
    expect(mockRepo.applyTransition).toHaveBeenCalledWith(10, 'ISSUE', user.id, undefined, { channel: 'notify' });
  });
});
