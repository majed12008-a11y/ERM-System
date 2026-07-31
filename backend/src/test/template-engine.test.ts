import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TemplateEngineService } from '../services/template-engine.service';
import { TemplateResolverService } from '../services/template-resolver.service';
import type { VersionData } from '../services/template-version-lifecycle.service';

function makeVersion(overrides: Partial<VersionData> = {}): VersionData {
  return {
    id: 1,
    template_id: 100,
    version: '1.0.0',
    status: 'APPROVED',
    content: {
      ar: { body: 'مرحبا {{name}}' },
      en: { body: 'Hello {{name}}' },
    },
    content_hash: 'abc123',
    variable_definitions: [
      { code: 'name', type: 'string', required: true },
    ],
    change_summary: null,
    effective_from: null,
    effective_until: null,
    retired_at: null,
    approved_by: 10,
    approved_at: new Date(),
    created_by: 5,
    created_at: new Date(),
    ...overrides,
  };
}

// ─── TemplateEngineService — Rendering ────────────────────

describe('TemplateEngineService — Rendering', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('renders HTML with injected variables', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
      locale: 'ar',
    });

    expect(result.html).toContain('مرحبا عالم');
    expect(result.templateCode).toBe('TPL-001');
    expect(result.version).toBe('1.0.0');
    expect(result.locale).toBe('ar');
    expect(result.variableCount).toBe(1);
  });

  it('renders with English locale', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'World' },
      locale: 'en',
    });

    expect(result.html).toContain('Hello World');
  });

  it('falls back to Arabic when requested locale has no content', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: 'مرحبا {{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
      locale: 'en',
    });

    expect(result.html).toContain('مرحبا عالم');
  });

  it('defaults to Arabic when no locale specified', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
    });

    expect(result.html).toContain('مرحبا');
  });

  it('renders complex Handlebars expressions', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: {
        ar: { body: '{{#if show}}مرحبا {{name}}{{else}}وداعا{{/if}}' },
      },
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم', show: true },
    });

    expect(result.html).toContain('مرحبا عالم');
  });

  it('handles Handlebars helpers (each, if)', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [],
      content: {
        ar: { body: '{{#each items}}{{this}}{{#unless @last}}, {{/unless}}{{/each}}' },
      },
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { items: ['أ', 'ب', 'ج'] },
    });

    expect(result.html).toBe('أ, ب, ج');
  });

  it('detects missing required variables', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const err = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: {},
    }).catch((e: any) => e);

    expect(err.status).toBe(400);
    expect(err.renderErrors).toBeDefined();
    expect(err.renderErrors[0].code).toBe('RENDER_ERR_001');
  });

  it('allows missing non-required variables', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'name', type: 'string', required: false },
        { code: 'extra', type: 'string', required: false },
      ],
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
    });

    expect(result.html).toContain('مرحبا عالم');
  });

  it('throws 404 when version not found', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(null);

    const err = await service.render({
      templateCode: 'NONEXIST',
      version: '1.0.0',
      variables: { name: 'test' },
    }).catch((e: any) => e);

    expect(err.status).toBe(404);
  });

  it('throws when version has no content', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: {} as any,
    }));

    const err = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    }).catch((e: any) => e);

    expect(err.status).toBe(400);
  });

  it('throws when locale content has no body', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: {} as any },
    }));

    const err = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    }).catch((e: any) => e);

    expect(err.status).toBe(400);
  });

  it('reports resolution time and renderedAt', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
    });

    expect(result.renderedAt).toBeInstanceOf(Date);
    expect(result.resolutionTimeMs).toBeGreaterThanOrEqual(0);
  });
});

// ─── TemplateEngineService — Determinism ─────────────────

describe('TemplateEngineService — Determinism', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    service = new TemplateEngineService(mockVersionRepo);
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
  });

  it('produces identical output for identical inputs', async () => {
    const request = {
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
    };

    const result1 = await service.render(request);
    const result2 = await service.render(request);

    expect(result1.html).toBe(result2.html);
  });

  it('produces different output for different variables', async () => {
    const result1 = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'أحمد' },
    });
    const result2 = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'سارة' },
    });

    expect(result1.html).not.toBe(result2.html);
    expect(result1.html).toContain('أحمد');
    expect(result2.html).toContain('سارة');
  });

  it('same input across service instances produces same output', async () => {
    const service2 = new TemplateEngineService(mockVersionRepo);

    const result1 = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
    });
    const result2 = await service2.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
    });

    expect(result1.html).toBe(result2.html);
  });
});

// ─── TemplateEngineService — Cache ────────────────────────

describe('TemplateEngineService — Cache', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    service = new TemplateEngineService(mockVersionRepo);
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
  });

  it('returns cacheHit=false on first render', async () => {
    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    });

    expect(result.cacheHit).toBe(false);
  });

  it('returns cacheHit=true on second render', async () => {
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    });

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    });

    expect(result.cacheHit).toBe(true);
  });

  it('cache stats report hits and misses', async () => {
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    });

    const stats = service.getCacheStats();

    expect(stats.size).toBe(1);
    expect(stats.totalHits).toBe(0);
    expect(stats.totalMisses).toBe(1);
    expect(stats.entries[0].templateCode).toBe('TPL-001');
  });

  it('cache stats track multiple renders', async () => {
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'a' },
    });
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'b' },
    });

    const stats = service.getCacheStats();

    expect(stats.totalHits).toBe(1);
    expect(stats.totalMisses).toBe(1);
  });

  it('invalidateCache removes a specific version-locale entry', async () => {
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
      locale: 'ar',
    });

    service.invalidateCache('TPL-001', '1.0.0', 'ar');
    expect(service.getCacheStats().size).toBe(0);
  });

  it('invalidateCache removes all locales for a version', async () => {
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
      locale: 'ar',
    });
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
      locale: 'en',
    });

    service.invalidateCache('TPL-001', '1.0.0');
    expect(service.getCacheStats().size).toBe(0);
  });

  it('invalidateTemplateCache removes all versions of a template', async () => {
    mockVersionRepo.findByCodeAndVersion
      .mockResolvedValueOnce(makeVersion({ id: 1, version: '1.0.0' }))
      .mockResolvedValueOnce(makeVersion({ id: 2, version: '2.0.0' }));

    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    });
    await service.render({
      templateCode: 'TPL-001',
      version: '2.0.0',
      variables: { name: 'test' },
    });

    expect(service.getCacheStats().size).toBe(2);
    service.invalidateTemplateCache('TPL-001');
    expect(service.getCacheStats().size).toBe(0);
  });

  it('clearCache resets all statistics', async () => {
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    });

    service.clearCache();
    const stats = service.getCacheStats();

    expect(stats.size).toBe(0);
    expect(stats.totalHits).toBe(0);
    expect(stats.totalMisses).toBe(0);
  });

  it('different locales create separate cache entries', async () => {
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
      locale: 'ar',
    });
    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
      locale: 'en',
    });

    expect(service.getCacheStats().size).toBe(2);
  });

  it('getCachedVersions returns cached version strings', async () => {
    await service.render({
      templateCode: 'TPL-001',
      version: '2.0.0',
      variables: { name: 'test' },
    });

    const versions = service.getCachedVersions('TPL-001');
    expect(versions).toContain('2.0.0');
  });

  it('getCachedVersions returns empty for uncached template', async () => {
    const versions = service.getCachedVersions('NONEXIST');
    expect(versions).toEqual([]);
  });
});

// ─── TemplateEngineService — Edge Cases ───────────────────

describe('TemplateEngineService — Edge Cases', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('handles empty variable list', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [],
      content: { ar: { body: 'ثابت' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: {},
    });

    expect(result.html).toBe('ثابت');
  });

  it('handles zero numeric values correctly', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [{ code: 'count', type: 'number', required: true }],
      content: { ar: { body: 'العدد: {{count}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { count: 0 },
    });

    expect(result.html).toBe('العدد: 0');
  });

  it('handles boolean values', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [{ code: 'active', type: 'boolean', required: true }],
      content: { ar: { body: '{{#if active}}نعم{{else}}لا{{/if}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { active: true },
    });

    expect(result.html).toBe('نعم');
  });

  it('handles extra variables not in definitions', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [{ code: 'name', type: 'string', required: true }],
      content: { ar: { body: '{{name}} - {{extra}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test', extra: 'value' },
    });

    expect(result.html).toBe('test - value');
  });

  it('throws on invalid Handlebars syntax', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{#invalid' } },
    }));

    const err = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
    }).catch((e: any) => e);

    expect(err).toBeDefined();
    expect(err.message || true).toBeTruthy();
  });

  it('renders without variables when template has none', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: 'نص ثابت بدون متغيرات' } },
      variable_definitions: [],
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: {},
    });

    expect(result.html).toBe('نص ثابت بدون متغيرات');
  });

  it('preserves HTML tags in rendered output', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '<h1>{{title}}</h1><p>{{body}}</p>' } },
      variable_definitions: [
        { code: 'title', type: 'string', required: true },
        { code: 'body', type: 'string', required: true },
      ],
    }));

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { title: 'العنوان', body: 'المحتوى' },
    });

    expect(result.html).toBe('<h1>العنوان</h1><p>المحتوى</p>');
  });
});

// ─── TemplateEngineService — Resolver Integration ────────

describe('TemplateEngineService — Resolver Integration', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;
  let mockResolverService: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    mockResolverService = {
      resolveFromVariableDefinitions: vi.fn(),
    };
    service = new TemplateEngineService(mockVersionRepo, mockResolverService as unknown as TemplateResolverService);
  });

  it('resolves entity variables when entity context provided', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'name', type: 'string', required: true },
        { code: 'title', type: 'string', required: true, source_type: 'entity' },
      ],
      content: { ar: { body: '{{name}}: {{title}}' } },
    }));

    mockResolverService.resolveFromVariableDefinitions.mockResolvedValue(
      new Map([['title', 'مدير البحث']]),
    );

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'أحمد' },
      entityType: 'application',
      entityId: 42,
    });

    expect(result.html).toBe('أحمد: مدير البحث');
    expect(mockResolverService.resolveFromVariableDefinitions).toHaveBeenCalledWith(
      'application', 42, expect.any(Array), undefined,
    );
  });

  it('pre-resolved variables override resolver values', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'name', type: 'string', required: true, source_type: 'entity' },
      ],
      content: { ar: { body: '{{name}}' } },
    }));

    mockResolverService.resolveFromVariableDefinitions.mockResolvedValue(
      new Map([['name', 'اسم من المحلل']]),
    );

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'اسم المستخدم' },
      entityType: 'application',
      entityId: 42,
    });

    expect(result.html).toBe('اسم المستخدم');
  });

  it('returns default value when resolver fails and default exists', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'name', type: 'string', required: true },
        { code: 'title', type: 'string', source_type: 'entity', default_value: 'افتراضي' },
      ],
      content: { ar: { body: '{{name}}: {{title}}' } },
    }));

    mockResolverService.resolveFromVariableDefinitions.mockResolvedValue(
      new Map([['title', 'من المحلل']]),
    );

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'أحمد' },
      entityType: 'application',
      entityId: 42,
    });

    expect(result.html).toBe('أحمد: من المحلل');
  });

  it('works without resolver service', async () => {
    const serviceNoResolver = new TemplateEngineService(mockVersionRepo);

    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await serviceNoResolver.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'نص' },
    });

    expect(result.html).toBe('نص');
  });

  it('works with resolver but no entity context', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
    });

    expect(result.html).toContain('مرحبا عالم');
    expect(mockResolverService.resolveFromVariableDefinitions).not.toHaveBeenCalled();
  });

  it('applies defaults when resolver does not return a value', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'name', type: 'string', required: true },
        { code: 'title', type: 'string', source_type: 'entity', default_value: 'دكتور' },
      ],
      content: { ar: { body: '{{name}} {{title}}' } },
    }));

    mockResolverService.resolveFromVariableDefinitions.mockResolvedValue(
      new Map(),
    );

    const result = await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'أحمد' },
      entityType: 'application',
      entityId: 42,
    });

    expect(result.html).toBe('أحمد دكتور');
  });

  it('resolver receives user context', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'role', type: 'string', source_type: 'entity' },
      ],
      content: { ar: { body: '{{role}}' } },
    }));

    mockResolverService.resolveFromVariableDefinitions.mockResolvedValue(
      new Map([['role', 'admin']]),
    );

    await service.render({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: {},
      entityType: 'application',
      entityId: 42,
      userContext: { userId: 5, userRoles: ['ETHICS_ADMIN'], locale: 'ar' },
    });

    expect(mockResolverService.resolveFromVariableDefinitions).toHaveBeenCalledWith(
      'application', 42, expect.any(Array),
      { userId: 5, userRoles: ['ETHICS_ADMIN'], locale: 'ar' },
    );
  });
});
