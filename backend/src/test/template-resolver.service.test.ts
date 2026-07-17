import { describe, it, expect, vi, beforeEach } from 'vitest';
import { ResolverRegistry } from '../services/template-resolver-registry';
import { TemplateResolverService } from '../services/template-resolver.service';
import { ApplicationResolver } from '../services/resolvers/application.resolver';
import { ConditionResolver } from '../services/resolvers/condition.resolver';
import { UserResolver } from '../services/resolvers/user.resolver';
import { CommitteeResolver } from '../services/resolvers/committee.resolver';
import { MeetingResolver } from '../services/resolvers/meeting.resolver';
import { DocumentResolver } from '../services/resolvers/document.resolver';
import { InstitutionResolver } from '../services/resolvers/institution.resolver';
import { NotificationResolver } from '../services/resolvers/notification.resolver';
import { ReviewResolver } from '../services/resolvers/review.resolver';
import { ReportResolver } from '../services/resolvers/report.resolver';
import { CommunicationResolver } from '../services/resolvers/communication.resolver';
import { SafetyReportResolver } from '../services/resolvers/safety-report.resolver';
import { EntityDataRepository } from '../services/resolvers/entity-data.repository';
import { IResolver, ResolverCache } from '../shared/template-resolver.types';
import { BaseResolver } from '../services/resolvers/base.resolver';

// ─── Mock Data ─────────────────────────────────────────────────────

const mockApplication = {
  id: 1, application_number: 'APP-2025-001', project_id: 10,
  project_title: 'Clinical Trial X', project_code: 'CTX-001',
  application_type: 'INITIAL', submitted_by: 100,
  submitted_by_username: 'researcher1', target_committee_id: 5,
  committee_name_ar: 'لجنة الأخلاقيات', committee_name_en: 'Ethics Committee',
  current_status: 'SUBMITTED', status_name_ar: 'مقدم',
  created_at: new Date('2025-01-15'), created_by: 100,
};

const mockCondition = {
  id: 1, application_id: 1, condition_text: 'Submit updated consent form',
  severity: 'HIGH', category: 'CONSENT', status: 'OPEN',
  due_date: new Date('2025-06-01'), resolved_by: null, resolved_at: null,
};

const mockUser = {
  id: 100, uuid: 'usr-001', username: 'researcher1', email: 'r1@test.com',
  first_name_ar: 'باحث', last_name_ar: 'واحد', first_name_en: 'Researcher',
  last_name_en: 'One', institution_id: 1, institution_name_ar: 'جامعة الاختبار',
  status: 'ACTIVE', roles: ['RESEARCHER'],
};

const mockCommittee = {
  id: 5, committee_code: 'IRB-01', committee_name_ar: 'لجنة الأخلاقيات',
  committee_name_en: 'Ethics Committee', committee_type: 'IRB',
  institution_id: 1, is_active: true,
};

const mockDocument = {
  id: 1, file_name: 'consent.pdf', file_type: 'application/pdf',
  file_size_bytes: 102400, entity_type: 'Application', entity_id: 1,
  uploaded_by: 100, uploaded_by_username: 'researcher1',
  created_at: new Date('2025-01-20'),
};

const mockInstitution = { id: 1, name_ar: 'جامعة الاختبار', name_en: 'Test University', code: 'TU-001', city: 'Riyadh', country: 'SA', is_active: true };

const mockNotification = { id: 1, user_id: 100, notification_type: 'STATUS_CHANGE', subject: 'Test Notification', message_body: 'Your application has been updated.', priority_level: 'NORMAL', created_at: new Date() };

const mockReview = { id: 1, application_id: 1, reviewer_id: 200, reviewer_name: 'Dr. Reviewer', decision: 'APPROVED', comments: 'Looks good', submitted_at: new Date() };

const mockReport = { id: 1, report_type: 'ANNUAL', entity_type: 'Application', entity_id: 1, generated_by: 100, generated_at: new Date(), status: 'COMPLETED' };

const mockCommunication = { id: 1, communication_type: 'EMAIL', subject: 'Meeting Reminder', body: 'Reminder text', sender_id: 100, recipient_id: 200, sent_at: new Date() };

const mockSafetyReport = { id: 1, application_id: 1, report_type: 'ADVERSE_EVENT', severity: 'MODERATE', description: 'Patient reported headache', reported_by: 100, reported_at: new Date(), status: 'UNDER_REVIEW' };

const mockMeeting = { id: 1, committee_id: 5, meeting_date: new Date('2025-03-01'), meeting_type: 'REGULAR', status: 'SCHEDULED', location: 'Room A', committee_name_ar: 'لجنة الأخلاقيات' };

// ─── Mock EntityDataRepository Factory ──────────────────────────────

function createMockEntityDataRepo(overrides: Partial<Record<string, any>> = {}): EntityDataRepository {
  const defaults: Record<string, any> = {
    findApplicationBatch: new Map([[1, mockApplication]]),
    findConditionBatch: new Map([[1, mockCondition]]),
    findUserBatch: new Map([[100, mockUser]]),
    findCommitteeBatch: new Map([[5, mockCommittee]]),
    findInstitutionBatch: new Map([[1, mockInstitution]]),
    findNotificationBatch: new Map([[1, mockNotification]]),
    findMeetingBatch: new Map([[1, mockMeeting]]),
    findReviewBatch: new Map([[1, mockReview]]),
    findDocumentBatch: new Map([[1, mockDocument]]),
    findReportBatch: new Map([[1, mockReport]]),
    findCommunicationBatch: new Map([[1, mockCommunication]]),
    findSafetyReportBatch: new Map([[1, mockSafetyReport]]),
  };

  const data = { ...defaults, ...overrides };
  const repo = {} as EntityDataRepository;

  for (const [method, batchResult] of Object.entries(data)) {
    (repo as any)[method] = vi.fn().mockResolvedValue(batchResult);
  }

  return repo;
}

// ─── Tests ─────────────────────────────────────────────────────────

describe('ResolverRegistry', () => {
  let registry: ResolverRegistry;

  beforeEach(() => {
    registry = new ResolverRegistry();
  });

  it('registers and retrieves a resolver', () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    registry.register(resolver);
    expect(registry.has('Application')).toBe(true);
    expect(registry.get('Application')).toBe(resolver);
  });

  it('returns undefined for unregistered entity type', () => {
    expect(registry.get('Unknown')).toBeUndefined();
  });

  it('getOrThrow throws for unregistered entity type', () => {
    expect(() => registry.getOrThrow('Unknown')).toThrow('No resolver registered');
  });

  it('getOrThrow returns resolver for registered type', () => {
    const resolver = new UserResolver(createMockEntityDataRepo());
    registry.register(resolver);
    expect(registry.getOrThrow('User')).toBe(resolver);
  });

  it('rejects registration of non-whitelisted entity type', () => {
    const fakeResolver = { entityType: 'FakeEntity', resolve: vi.fn(), resolveBatch: vi.fn() } as any as IResolver<any>;
    expect(() => registry.register(fakeResolver)).toThrow('not in the entity whitelist');
  });

  it('rejects duplicate registration', () => {
    const r1 = new ApplicationResolver(createMockEntityDataRepo());
    const r2 = new ApplicationResolver(createMockEntityDataRepo());
    registry.register(r1);
    expect(() => registry.register(r2)).toThrow('already registered');
  });

  it('lists registered types', () => {
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    registry.register(new UserResolver(createMockEntityDataRepo()));
    const types = registry.getRegisteredTypes();
    expect(types).toContain('Application');
    expect(types).toContain('User');
  });

  it('unregisters a resolver', () => {
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    expect(registry.unregister('Application')).toBe(true);
    expect(registry.has('Application')).toBe(false);
  });

  it('reports correct size', () => {
    expect(registry.size).toBe(0);
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    expect(registry.size).toBe(1);
    registry.register(new UserResolver(createMockEntityDataRepo()));
    expect(registry.size).toBe(2);
  });

  it('whitelist check works', () => {
    expect(registry.isWhitelisted('Application')).toBe(true);
    expect(registry.isWhitelisted('Unknown')).toBe(false);
  });

  it('clears all resolvers', () => {
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    registry.clear();
    expect(registry.size).toBe(0);
  });
});

describe('ApplicationResolver', () => {
  it('resolves a single variable', async () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(1, 'application_number');
    expect(value).toBe('APP-2025-001');
  });

  it('resolves alias variable applicant_name', async () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(1, 'applicant_name');
    expect(value).toBe('researcher1');
  });

  it('resolves alias variable protocol_number', async () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(1, 'protocol_number');
    expect(value).toBe('APP-2025-001');
  });

  it('throws for unknown variable code', async () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    await expect(resolver.resolve(1, 'unknown_var')).rejects.toThrow('Unknown variable code');
  });

  it('throws for non-existent entity', async () => {
    const repo = createMockEntityDataRepo({ findApplicationBatch: new Map() });
    const resolver = new ApplicationResolver(repo);
    await expect(resolver.resolve(999, 'application_number')).rejects.toThrow('not found');
  });

  it('resolves batch of variables', async () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    const results = await resolver.resolveBatch([1], ['application_number', 'current_status', 'project_title']);
    expect(results.size).toBe(1);
    const data = results.get(1)!;
    expect(data.application_number).toBe('APP-2025-001');
    expect(data.current_status).toBe('SUBMITTED');
    expect(data.project_title).toBe('Clinical Trial X');
  });

  it('batch skips non-existent entities', async () => {
    const repo = createMockEntityDataRepo({ findApplicationBatch: new Map() });
    const resolver = new ApplicationResolver(repo);
    const results = await resolver.resolveBatch([999], ['application_number']);
    expect(results.size).toBe(0);
  });

  it('deduplicates entity IDs in batch', async () => {
    const repo = createMockEntityDataRepo();
    const resolver = new ApplicationResolver(repo);
    await resolver.resolveBatch([1, 1, 1], ['application_number']);
    expect(repo.findApplicationBatch).toHaveBeenCalledTimes(1);
  });

  it('resolves committee_name via locale', async () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    const arVal = await resolver.resolve(1, 'committee_name_ar');
    expect(arVal).toBe('لجنة الأخلاقيات');
    const enVal = await resolver.resolve(1, 'committee_name_en');
    expect(enVal).toBe('Ethics Committee');
  });
});

describe('ConditionResolver', () => {
  it('resolves a condition variable', async () => {
    const resolver = new ConditionResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(1, 'condition_text');
    expect(value).toBe('Submit updated consent form');
  });

  it('resolves condition status', async () => {
    const resolver = new ConditionResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(1, 'status');
    expect(value).toBe('OPEN');
  });

  it('throws for unknown variable', async () => {
    const resolver = new ConditionResolver(createMockEntityDataRepo());
    await expect(resolver.resolve(1, 'bad_var')).rejects.toThrow('Unknown variable code');
  });

  it('throws when condition not found', async () => {
    const repo = createMockEntityDataRepo({ findConditionBatch: new Map() });
    const resolver = new ConditionResolver(repo);
    await expect(resolver.resolve(999, 'status')).rejects.toThrow('not found');
  });
});

describe('UserResolver', () => {
  it('resolves user display name', async () => {
    const resolver = new UserResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(100, 'display_name');
    expect(value).toBe('باحث');
  });

  it('resolves user email', async () => {
    const resolver = new UserResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(100, 'email');
    expect(value).toBe('r1@test.com');
  });

  it('resolves user roles', async () => {
    const resolver = new UserResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(100, 'roles');
    expect(value).toEqual(['RESEARCHER']);
  });
});

describe('CommitteeResolver', () => {
  it('resolves committee name', async () => {
    const resolver = new CommitteeResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(5, 'committee_name_ar');
    expect(value).toBe('لجنة الأخلاقيات');
  });

  it('resolves committee code', async () => {
    const resolver = new CommitteeResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(5, 'committee_code');
    expect(value).toBe('IRB-01');
  });
});

describe('MeetingResolver', () => {
  it('resolves meeting fields', async () => {
    const resolver = new MeetingResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(1, 'meeting_type');
    expect(value).toBe('REGULAR');
  });
});

describe('DocumentResolver', () => {
  it('resolves document fields', async () => {
    const resolver = new DocumentResolver(createMockEntityDataRepo());
    const value = await resolver.resolve(1, 'file_name');
    expect(value).toBe('consent.pdf');
  });
});

describe('Individual Reference Resolvers', () => {
  it('InstitutionResolver resolves name', async () => {
    const r = new InstitutionResolver(createMockEntityDataRepo());
    expect(await r.resolve(1, 'name_ar')).toBe('جامعة الاختبار');
    expect(await r.resolve(1, 'code')).toBe('TU-001');
  });

  it('NotificationResolver resolves fields', async () => {
    const r = new NotificationResolver(createMockEntityDataRepo());
    expect(await r.resolve(1, 'subject')).toBe('Test Notification');
  });

  it('ReviewResolver resolves fields', async () => {
    const r = new ReviewResolver(createMockEntityDataRepo());
    expect(await r.resolve(1, 'decision')).toBe('APPROVED');
  });

  it('ReportResolver resolves fields', async () => {
    const r = new ReportResolver(createMockEntityDataRepo());
    expect(await r.resolve(1, 'report_type')).toBe('ANNUAL');
  });

  it('CommunicationResolver resolves fields', async () => {
    const r = new CommunicationResolver(createMockEntityDataRepo());
    expect(await r.resolve(1, 'communication_type')).toBe('EMAIL');
  });

  it('SafetyReportResolver resolves fields', async () => {
    const r = new SafetyReportResolver(createMockEntityDataRepo());
    expect(await r.resolve(1, 'severity')).toBe('MODERATE');
  });

  it('all resolvers throw for unknown vars', async () => {
    const resolvers = [
      { resolver: new InstitutionResolver(createMockEntityDataRepo()), varCode: 'nonexistent' },
      { resolver: new NotificationResolver(createMockEntityDataRepo()), varCode: 'nonexistent' },
      { resolver: new ReviewResolver(createMockEntityDataRepo()), varCode: 'nonexistent' },
      { resolver: new ReportResolver(createMockEntityDataRepo()), varCode: 'nonexistent' },
      { resolver: new CommunicationResolver(createMockEntityDataRepo()), varCode: 'nonexistent' },
      { resolver: new SafetyReportResolver(createMockEntityDataRepo()), varCode: 'nonexistent' },
    ];
    for (const { resolver, varCode } of resolvers) {
      await expect(resolver.resolve(1, varCode)).rejects.toThrow('reject: Unknown');
    }
  });

  it('all resolvers throw for missing entities', async () => {
    const emptyRepos = {
      findInstitutionBatch: new Map(),
      findNotificationBatch: new Map(),
      findReviewBatch: new Map(),
      findReportBatch: new Map(),
      findCommunicationBatch: new Map(),
      findSafetyReportBatch: new Map(),
    };
    const resolvers = [
      { resolver: new InstitutionResolver(createMockEntityDataRepo(emptyRepos)), varCode: 'name_ar' },
      { resolver: new NotificationResolver(createMockEntityDataRepo(emptyRepos)), varCode: 'subject' },
      { resolver: new ReviewResolver(createMockEntityDataRepo(emptyRepos)), varCode: 'decision' },
      { resolver: new ReportResolver(createMockEntityDataRepo(emptyRepos)), varCode: 'report_type' },
      { resolver: new CommunicationResolver(createMockEntityDataRepo(emptyRepos)), varCode: 'subject' },
      { resolver: new SafetyReportResolver(createMockEntityDataRepo(emptyRepos)), varCode: 'severity' },
    ];
    for (const { resolver, varCode } of resolvers) {
      await expect(resolver.resolve(999, varCode)).rejects.toThrow('reject:');
    }
  });
});

describe('TemplateResolverService — Single Resolve', () => {
  let registry: ResolverRegistry;
  let service: TemplateResolverService;

  beforeEach(() => {
    registry = new ResolverRegistry();
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    registry.register(new UserResolver(createMockEntityDataRepo()));
    registry.register(new ConditionResolver(createMockEntityDataRepo()));
    service = new TemplateResolverService(registry);
    service.clearCache();
  });

  it('resolves a single variable successfully', async () => {
    const result = await service.resolveSingle({
      entityType: 'Application', entityId: 1, variableCode: 'application_number',
    });
    expect(result.resolved).toBe(true);
    expect(result.value).toBe('APP-2025-001');
  });

  it('returns error for unregistered entity type', async () => {
    const result = await service.resolveSingle({
      entityType: 'Unknown', entityId: 1, variableCode: 'x',
    });
    expect(result.resolved).toBe(false);
    expect(result.error).toContain('not whitelisted');
  });

  it('returns error when entity not found', async () => {
    const reg = new ResolverRegistry();
    reg.register(new ApplicationResolver(createMockEntityDataRepo({ findApplicationBatch: new Map() })));
    const svc = new TemplateResolverService(reg);
    const result = await svc.resolveSingle({
      entityType: 'Application', entityId: 999, variableCode: 'application_number',
    });
    expect(result.resolved).toBe(false);
    expect(result.error).toContain('not found');
  });

  it('uses cache on repeated resolution', async () => {
    const repo = createMockEntityDataRepo();
    const reg = new ResolverRegistry();
    reg.register(new ApplicationResolver(repo));
    const svc = new TemplateResolverService(reg);
    svc.clearCache();

    const r1 = await svc.resolveSingle({ entityType: 'Application', entityId: 1, variableCode: 'application_number' });
    expect(r1.resolved).toBe(true);
    expect(repo.findApplicationBatch).toHaveBeenCalledTimes(1);

    const r2 = await svc.resolveSingle({ entityType: 'Application', entityId: 1, variableCode: 'application_number' });
    expect(r2.resolved).toBe(true);
    expect(repo.findApplicationBatch).toHaveBeenCalledTimes(1);
  });
});

describe('TemplateResolverService — Batch Resolve', () => {
  let registry: ResolverRegistry;
  let service: TemplateResolverService;

  beforeEach(() => {
    registry = new ResolverRegistry();
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    registry.register(new UserResolver(createMockEntityDataRepo()));
    registry.register(new ConditionResolver(createMockEntityDataRepo()));
    registry.register(new DocumentResolver(createMockEntityDataRepo()));
    service = new TemplateResolverService(registry);
    service.clearCache();
  });

  it('resolves multiple variables across entity types', async () => {
    const result = await service.resolveBatch({
      requests: [
        { entityType: 'Application', entityId: 1, variableCode: 'application_number' },
        { entityType: 'Application', entityId: 1, variableCode: 'current_status' },
        { entityType: 'User', entityId: 100, variableCode: 'username' },
      ],
    });
    expect(result.resolvedCount).toBe(3);
    expect(result.failedCount).toBe(0);
    expect(result.results[0].value).toBe('APP-2025-001');
    expect(result.results[1].value).toBe('SUBMITTED');
    expect(result.results[2].value).toBe('researcher1');
  });

  it('groups requests by entity type', async () => {
    const repo = createMockEntityDataRepo();
    const reg = new ResolverRegistry();
    reg.register(new ApplicationResolver(repo));
    const svc = new TemplateResolverService(reg);
    svc.clearCache();

    await svc.resolveBatch({
      requests: [
        { entityType: 'Application', entityId: 1, variableCode: 'application_number' },
        { entityType: 'Application', entityId: 1, variableCode: 'current_status' },
        { entityType: 'Application', entityId: 2, variableCode: 'project_title' },
      ],
    });
    expect(repo.findApplicationBatch).toHaveBeenCalledTimes(1);
  });

  it('deduplicates identical requests', async () => {
    const repo = createMockEntityDataRepo();
    const reg = new ResolverRegistry();
    reg.register(new ApplicationResolver(repo));
    const svc = new TemplateResolverService(reg);
    svc.clearCache();

    await svc.resolveBatch({
      requests: [
        { entityType: 'Application', entityId: 1, variableCode: 'application_number' },
        { entityType: 'Application', entityId: 1, variableCode: 'application_number' },
        { entityType: 'Application', entityId: 1, variableCode: 'application_number' },
      ],
    });
    expect(repo.findApplicationBatch).toHaveBeenCalledTimes(1);
  });

  it('handles unregistered entity type in batch', async () => {
    const result = await service.resolveBatch({
      requests: [
        { entityType: 'Unknown', entityId: 1, variableCode: 'x' },
        { entityType: 'Application', entityId: 1, variableCode: 'application_number' },
      ],
    });
    expect(result.failedCount).toBe(1);
    expect(result.resolvedCount).toBe(1);
    expect(result.results[0].error).toContain('not whitelisted');
  });

  it('returns cached results without re-resolving', async () => {
    const repo = createMockEntityDataRepo();
    const reg = new ResolverRegistry();
    reg.register(new ApplicationResolver(repo));
    const svc = new TemplateResolverService(reg);
    svc.clearCache();

    await svc.resolveBatch({
      requests: [{ entityType: 'Application', entityId: 1, variableCode: 'application_number' }],
    });
    expect(repo.findApplicationBatch).toHaveBeenCalledTimes(1);

    const result = await svc.resolveBatch({
      requests: [{ entityType: 'Application', entityId: 1, variableCode: 'application_number' }],
    });
    expect(repo.findApplicationBatch).toHaveBeenCalledTimes(1);
    expect(result.cachedCount).toBe(1);
    expect(result.results[0].value).toBe('APP-2025-001');
  });

  it('reports duration', async () => {
    const result = await service.resolveBatch({
      requests: [{ entityType: 'Application', entityId: 1, variableCode: 'application_number' }],
    });
    expect(result.durationMs).toBeGreaterThanOrEqual(0);
  });
});

describe('TemplateResolverService — resolveFromVariableDefinitions', () => {
  let registry: ResolverRegistry;
  let service: TemplateResolverService;

  beforeEach(() => {
    registry = new ResolverRegistry();
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    service = new TemplateResolverService(registry);
    service.clearCache();
  });

  it('resolves entity variables and includes manual defaults', async () => {
    const definitions = [
      { code: 'applicant_name', resolver_path: 'Application.repository.getApplicantName', source_type: 'entity' },
      { code: 'manual_field', source_type: 'manual', default_value: 'default value' },
    ];

    const results = await service.resolveFromVariableDefinitions('Application', 1, definitions);
    expect(results.get('applicant_name')).toBe('researcher1');
    expect(results.get('manual_field')).toBe('default value');
  });

  it('falls back to default when entity resolve fails', async () => {
    const definitions = [
      { code: 'missing_field', resolver_path: 'Application.repository.getMissing', source_type: 'entity', default_value: 'fallback' },
    ];

    const results = await service.resolveFromVariableDefinitions('Application', 1, definitions);
    expect(results.get('missing_field')).toBe('fallback');
  });
});

describe('Cache integration', () => {
  it('custom cache implementation works', async () => {
    const customCache: ResolverCache = {
      get: vi.fn().mockReturnValue(undefined),
      set: vi.fn(),
      clear: vi.fn(),
    };

    const registry = new ResolverRegistry();
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    const service = new TemplateResolverService(registry, customCache);
    service.clearCache();

    await service.resolveSingle({ entityType: 'Application', entityId: 1, variableCode: 'application_number' });
    expect(customCache.get).toHaveBeenCalledWith('Application', 1, 'application_number');
    expect(customCache.set).toHaveBeenCalledWith('Application', 1, 'application_number', 'APP-2025-001');
  });

  it('clearCache works', async () => {
    const registry = new ResolverRegistry();
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    const service = new TemplateResolverService(registry);
    service.clearCache();

    await service.resolveSingle({ entityType: 'Application', entityId: 1, variableCode: 'application_number' });
    service.clearCache();

    const repo = createMockEntityDataRepo();
    const reg = new ResolverRegistry();
    reg.register(new ApplicationResolver(repo));
    const svc = new TemplateResolverService(reg);

    await svc.resolveSingle({ entityType: 'Application', entityId: 1, variableCode: 'application_number' });
    expect(repo.findApplicationBatch).toHaveBeenCalledTimes(1);
  });
});

describe('Entity whitelist enforcement', () => {
  it('BaseResolver rejects unwhitelisted entity types', () => {
    expect(() => new (class extends BaseResolver<any> {
      constructor() {
        super('NotWhitelisted');
      }
      resolve = vi.fn();
      resolveBatch = vi.fn();
    })()).toThrow('not in the whitelist');
  });

  it('ResolverRegistry enforces whitelist on register', () => {
    const registry = new ResolverRegistry();
    const fake: IResolver<any> = {
      entityType: 'BadEntity',
      resolve: vi.fn(),
      resolveBatch: vi.fn(),
    };
    expect(() => registry.register(fake)).toThrow('not in the entity whitelist');
  });

  it('TemplateResolverService rejects non-whitelisted types in batch', async () => {
    const registry = new ResolverRegistry();
    const service = new TemplateResolverService(registry);
    const result = await service.resolveBatch({
      requests: [{ entityType: 'HackedEntity', entityId: 1, variableCode: 'x' }],
    });
    expect(result.results[0].resolved).toBe(false);
    expect(result.results[0].error).toContain('not whitelisted');
  });
});

describe('Resolver metadata', () => {
  it('ApplicationResolver exposes supported variables', () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    const vars = resolver.supportedVariables;
    expect(vars.length).toBeGreaterThan(10);
    expect(vars.find(v => v.variableCode === 'application_number')).toBeDefined();
    expect(vars.find(v => v.variableCode === 'current_status')).toBeDefined();
  });

  it('ApplicationResolver exposes repository dependencies', () => {
    const resolver = new ApplicationResolver(createMockEntityDataRepo());
    expect(resolver.repositoryDependencies).toContain('EntityDataRepository');
  });
});

describe('Resolver coverage matrix', () => {
  it('all 12 entity roots have resolvers in the registry', () => {
    const registry = new ResolverRegistry();
    registry.register(new ApplicationResolver(createMockEntityDataRepo()));
    registry.register(new ConditionResolver(createMockEntityDataRepo()));
    registry.register(new UserResolver(createMockEntityDataRepo()));
    registry.register(new CommitteeResolver(createMockEntityDataRepo()));
    registry.register(new MeetingResolver(createMockEntityDataRepo()));
    registry.register(new DocumentResolver(createMockEntityDataRepo()));
    registry.register(new InstitutionResolver(createMockEntityDataRepo()));
    registry.register(new NotificationResolver(createMockEntityDataRepo()));
    registry.register(new ReviewResolver(createMockEntityDataRepo()));
    registry.register(new ReportResolver(createMockEntityDataRepo()));
    registry.register(new CommunicationResolver(createMockEntityDataRepo()));
    registry.register(new SafetyReportResolver(createMockEntityDataRepo()));

    expect(registry.size).toBe(12);
    const expected = ['Application', 'Condition', 'User', 'Committee', 'Meeting',
      'Document', 'Institution', 'Notification', 'Review', 'Report',
      'Communication', 'SafetyReport'];
    for (const et of expected) {
      expect(registry.has(et)).toBe(true);
    }
  });
});
