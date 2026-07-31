import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TemplateEngineService } from '../services/template-engine.service';
import { TemplateResolverService } from '../services/template-resolver.service';
import { SnapshotService, computeSnapshotHash } from '../services/template-snapshot.service';
import type { VersionData } from '../services/template-version-lifecycle.service';

function makeVersion(overrides: Partial<VersionData> = {}): VersionData {
  return {
    id: 1, template_id: 100, version: '1.0.0', status: 'APPROVED',
    content: { ar: { body: '{{name}}' }, en: { body: 'Hello {{name}}' } },
    content_hash: 'abc123',
    variable_definitions: [{ code: 'name', type: 'string', required: true }],
    change_summary: null, effective_from: null, effective_until: null,
    retired_at: null, approved_by: 10, approved_at: new Date(),
    created_by: 5, created_at: new Date(), ...overrides,
  };
}

// ─── Phase 3: Template Injection ─────────────────────────

describe('Security — Template Injection', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('Handlebars expressions in variables are NOT executed', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: '{{helper injection}}' },
    });

    expect(result.html).toBe('{{helper injection}}');
  });

  it('partial syntax in variables is NOT invoked', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: '{{> footer_standard}}' },
    });

    expect(result.html).toBe('{{&gt; footer_standard}}');
  });

  it('block helper syntax in variables is NOT evaluated', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: '{{#each items}}{{this}}{{/each}}' },
    });

    expect(result.html).toBe('{{#each items}}{{this}}{{/each}}');
  });
});

// ─── Phase 3: HTML Escaping & XSS ────────────────────────

describe('Security — HTML Escaping & XSS', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('angle brackets in variables are entity-escaped', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: '<b>bold</b>' },
    });

    expect(result.html).toBe('&lt;b&gt;bold&lt;/b&gt;');
  });

  it('quotes in variables are entity-escaped (XSS prevention)', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: '" onclick="alert(1)' },
    });

    expect(result.html).toContain('&quot;');
    expect(result.html).toContain('&#x3D;');
  });

  it('ampersands in variables are entity-escaped', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'a&b&c' },
    });

    expect(result.html).toBe('a&amp;b&amp;c');
  });

  it('template body HTML is preserved (not double-escaped)', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '<h1>{{title}}</h1>' } },
      variable_definitions: [
        { code: 'title', type: 'string', required: true },
      ],
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { title: 'Hello' },
    });

    expect(result.html).toBe('<h1>Hello</h1>');
  });

  it('handles Unicode and RTL content safely', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [{ code: 'name', type: 'string', required: true }],
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'مرحبا بالعالم \u202E\u202D' },
    });

    expect(result.html).toContain('مرحبا');
  });
});

// ─── Phase 3: Resolver Isolation ─────────────────────────

describe('Security — Resolver Isolation', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;
  let mockResolverService: any;

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    mockResolverService = {
      resolveFromVariableDefinitions: vi.fn(),
    };
    service = new TemplateEngineService(mockVersionRepo, mockResolverService as unknown as TemplateResolverService);
  });

  it('resolver only resolves variables in definition list', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'allowed', type: 'string', source_type: 'entity' },
      ],
      content: { ar: { body: '{{allowed}}' } },
    }));

    mockResolverService.resolveFromVariableDefinitions.mockResolvedValue(
      new Map([['allowed', 'value']]),
    );

    await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: {}, entityType: 'application', entityId: 42,
    });

    const calledWith = mockResolverService.resolveFromVariableDefinitions.mock.calls[0];
    const passedDefs = calledWith[2] as any[];
    const passedCodes = passedDefs.map((d: any) => d.code);
    expect(passedCodes).toEqual(['allowed']);
    expect(passedCodes).not.toContain('unauthorized');
  });

  it('resolver cannot inject unauthorized variables', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'name', type: 'string', required: true },
      ],
      content: { ar: { body: '{{name}}' } },
    }));

    mockResolverService.resolveFromVariableDefinitions.mockResolvedValue(
      new Map<string, string>([['name', 'legit'], ['unauthorized', 'data']]),
    );

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'user_value' },
      entityType: 'application', entityId: 42,
    });

    expect(result.html).toBe('user_value');
  });

  it('resolver receives only filtered variable definitions', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'name', type: 'string', required: true },
        { code: 'title', type: 'string', source_type: 'entity' },
        { code: 'role', type: 'string', source_type: 'entity' },
      ],
      content: { ar: { body: '{{name}} {{title}} {{role}}' } },
    }));

    mockResolverService.resolveFromVariableDefinitions.mockResolvedValue(
      new Map([['title', 'دكتور'], ['role', 'admin']]),
    );

    await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'أحمد' },
      entityType: 'application', entityId: 42,
    });

    const calledWith = mockResolverService.resolveFromVariableDefinitions.mock.calls[0];
    const passedDefs = calledWith[2] as any[];
    const sourceTypes = passedDefs.map((d: any) => d.source_type);
    expect(sourceTypes).toEqual(['entity', 'entity']);
    expect(passedDefs.length).toBe(2);
  });
});

// ─── Phase 3: Snapshot Integrity ─────────────────────────

describe('Security — Snapshot Integrity', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('tampered HTML invalidates hash', async () => {
    const snap = await service.createSnapshot({
      templateVersionId: 1, contentHash: 'abc', locale: 'ar',
      renderedHtml: '<p>original</p>', renderedBy: 1,
      correlationId: 'c', requestId: 'r',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'original' },
    });

    const tamperedHash = computeSnapshotHash({
      templateVersionId: snap.templateVersionId,
      contentHash: snap.contentHash,
      resolvedVariablesHash: snap.resolvedVariablesHash,
      locale: snap.locale,
      renderedHtml: '<p>tampered</p>',
    });

    expect(tamperedHash).not.toBe(snap.snapshotHash);
    const verify = await service.verifySnapshot(snap.snapshotHash);
    expect(verify.valid).toBe(true);
  });

  it('tampered contentHash invalidates hash', async () => {
    const snap = await service.createSnapshot({
      templateVersionId: 1, contentHash: 'original_hash', locale: 'ar',
      renderedHtml: '<p>test</p>', renderedBy: 1,
      correlationId: 'c', requestId: 'r',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'test' },
    });

    const tamperedHash = computeSnapshotHash({
      templateVersionId: snap.templateVersionId,
      contentHash: 'tampered_hash',
      resolvedVariablesHash: snap.resolvedVariablesHash,
      locale: snap.locale,
      renderedHtml: snap.renderedHtml,
    });

    expect(tamperedHash).not.toBe(snap.snapshotHash);
  });

  it('tampered locale invalidates hash', async () => {
    const snap = await service.createSnapshot({
      templateVersionId: 1, contentHash: 'abc', locale: 'ar',
      renderedHtml: '<p>test</p>', renderedBy: 1,
      correlationId: 'c', requestId: 'r',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'test' },
    });

    const tamperedHash = computeSnapshotHash({
      templateVersionId: snap.templateVersionId,
      contentHash: snap.contentHash,
      resolvedVariablesHash: snap.resolvedVariablesHash,
      locale: 'en',
      renderedHtml: snap.renderedHtml,
    });

    expect(tamperedHash).not.toBe(snap.snapshotHash);
  });

  it('duplicate detection prevents hash collision', async () => {
    const snap1 = await service.createSnapshot({
      templateVersionId: 1, contentHash: 'abc', locale: 'ar',
      renderedHtml: '<p>unique</p>', renderedBy: 1,
      correlationId: 'c1', requestId: 'r1',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'unique' },
    });

    const snap2 = await service.createSnapshot({
      templateVersionId: 1, contentHash: 'abc', locale: 'ar',
      renderedHtml: '<p>unique</p>', renderedBy: 1,
      correlationId: 'c2', requestId: 'r2',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'unique' },
    });

    expect(snap1.id).toBe(snap2.id);
    expect(snap1.snapshotHash).toBe(snap2.snapshotHash);
    expect(await service.snapshotCount()).toBe(1);
  });

  it('hash includes all five components', async () => {
    const inputs = Array.from({ length: 5 }, (_, i) => ({
      templateVersionId: i, contentHash: `ch_${i}`,
      resolvedVariablesHash: `rvh_${i}`,
      locale: i % 2 === 0 ? 'ar' : 'en',
      renderedHtml: `<p>test_${i}</p>`,
    }));

    const hashes = inputs.map(i => computeSnapshotHash(i));
    const unique = new Set(hashes);

    expect(unique.size).toBe(5);
  });
});

// ─── Phase 3: Variable Pollution ────────────────────────

describe('Security — Variable Pollution', () => {
  let service: TemplateEngineService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = { findByCodeAndVersion: vi.fn() };
    service = new TemplateEngineService(mockVersionRepo);
  });

  it('user variables cannot override Handlebars built-in', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      content: { ar: { body: '{{name}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'test', constructor: 'pollution' },
    });

    expect(result.html).toBe('test');
  });

  it('extra variables not in definitions are rendered', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [{ code: 'name', type: 'string', required: true }],
      content: { ar: { body: '{{name}}-{{extra}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'test', extra: 'data' },
    });

    expect(result.html).toBe('test-data');
  });

  it('undefined variables render as empty string', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [{ code: 'name', type: 'string', required: true }],
      content: { ar: { body: '{{name}} {{undefined}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'test' },
    });

    expect(result.html).toBe('test ');
  });

  it('null variable values render as empty', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      variable_definitions: [
        { code: 'name', type: 'string', required: true },
        { code: 'optional', type: 'string', required: false },
      ],
      content: { ar: { body: '{{name}}-{{optional}}' } },
    }));

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'test', optional: null },
    });

    expect(result.html).toBe('test-');
  });
});

// ─── Phase 3: Audit Chain Integrity ──────────────────────

describe('Security — Audit Chain Integrity', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('verifySnapshot recomputes hash correctly', async () => {
    const snap = await service.createSnapshot({
      templateVersionId: 1, contentHash: 'abc', locale: 'ar',
      renderedHtml: '<p>audit</p>', renderedBy: 1,
      correlationId: 'c', requestId: 'r',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'audit' },
    });

    const recomputed = computeSnapshotHash({
      templateVersionId: snap.templateVersionId,
      contentHash: snap.contentHash,
      resolvedVariablesHash: snap.resolvedVariablesHash,
      locale: snap.locale,
      renderedHtml: snap.renderedHtml,
    });

    expect(recomputed).toBe(snap.snapshotHash);
    const verify = await service.verifySnapshot(snap.snapshotHash);
    expect(verify.valid).toBe(true);
    expect(verify.match).toBe(true);
  });

  it('reference chain is immutable after creation', async () => {
    const snap = await service.createSnapshot({
      templateVersionId: 1, contentHash: 'abc', locale: 'ar',
      renderedHtml: '<p>ref-chain</p>', renderedBy: 1,
      correlationId: 'c', requestId: 'r',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'ref' },
    });

    await service.addReference(snap.id, 'lifecycle_event', 42);

    const verify = await service.verifySnapshot(snap.snapshotHash);
    expect(verify.valid).toBe(true);
  });

  it('findByReference returns correct snapshot across many entities', async () => {
    for (let i = 1; i <= 5; i++) {
      const snap = await service.createSnapshot({
        templateVersionId: i, contentHash: `ch_${i}`, locale: 'ar',
        renderedHtml: `<p>entity_${i}</p>`, renderedBy: 1,
        correlationId: `c_${i}`, requestId: `r_${i}`,
        metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
        variables: { idx: i },
      });
      await service.addReference(snap.id, 'lifecycle_event', i * 10);
    }

    const found = await service.findByReference('lifecycle_event', 30);
    expect(found).not.toBeNull();
    expect(found!.templateVersionId).toBe(3);
  });
});
