import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TemplateIntegrationService } from '../services/template-integration.service';
import { TemplateEngineService } from '../services/template-engine.service';
import { SnapshotService } from '../services/template-snapshot.service';
import type { VersionData } from '../services/template-version-lifecycle.service';

function makeVersion(overrides: Partial<VersionData> = {}): VersionData {
  return {
    id: 1,
    template_id: 100,
    version: '1.0.0',
    status: 'APPROVED',
    content: { ar: { body: '<p>مرحبا {{name}}</p>' } },
    content_hash: 'abc123',
    variable_definitions: [{ code: 'name', type: 'string', required: true }],
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

// ─── TemplateIntegrationService — Core Rendering ────────

describe('TemplateIntegrationService — Core Rendering', () => {
  let service: TemplateIntegrationService;
  let engine: TemplateEngineService;
  let snapshotService: SnapshotService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    snapshotService = new SnapshotService();
    engine = new TemplateEngineService(mockVersionRepo);
    service = new TemplateIntegrationService(engine, snapshotService, mockVersionRepo);
  });

  it('renders a document and creates snapshot', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
      renderedBy: 10,
      locale: 'ar',
    });

    expect(result.html).toContain('مرحبا عالم');
    expect(result.snapshot).toBeDefined();
    expect(result.snapshotHash).toBe(result.snapshot.snapshotHash);
    expect(result.correlationId).toBeTruthy();
    expect(result.renderResult.templateCode).toBe('TPL-001');
    expect(result.renderResult.cacheHit).toBe(false);
  });

  it('second render returns cache hit', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
      renderedBy: 10,
    });

    const result = await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
      renderedBy: 10,
    });

    expect(result.renderResult.cacheHit).toBe(true);
  });

  it('includes content hash from engine result', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
      renderedBy: 10,
    });

    expect(result.renderResult.contentHash).toBe('abc123');
    expect(result.snapshot.contentHash).toBe('abc123');
  });

  it('returned snapshot is immutable', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'عالم' },
      renderedBy: 10,
    });

    const verifyResult = await snapshotService.verifySnapshot(result.snapshotHash);
    expect(verifyResult.valid).toBe(true);
  });
});

// ─── TemplateIntegrationService — Module Documents ──────

describe('TemplateIntegrationService — Module Documents', () => {
  let service: TemplateIntegrationService;
  let engine: TemplateEngineService;
  let snapshotService: SnapshotService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    snapshotService = new SnapshotService();
    engine = new TemplateEngineService(mockVersionRepo);
    service = new TemplateIntegrationService(engine, snapshotService, mockVersionRepo);
  });

  it('renders application approval document', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      id: 1,
      version: '1.0.0',
      content: { ar: { body: '{{applicationReferenceNumber}} - {{piFullName}}' } },
      content_hash: 'cert-hash',
      variable_definitions: [
        { code: 'applicationReferenceNumber', type: 'string', required: true },
        { code: 'piFullName', type: 'string', required: true },
      ],
    }));

    const result = await service.renderApplicationDocument(
      'approval',
      { applicationReferenceNumber: 'APP-001', piFullName: 'د. أحمد' },
      42,
      10,
    );

    expect(result.html).toBe('APP-001 - د. أحمد');
  });

  it('renders application rejection document', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      id: 2,
      content: { ar: { body: 'المشروع: {{projectTitleAr}} - القرار: {{decisionResult}}' } },
      variable_definitions: [
        { code: 'projectTitleAr', type: 'string', required: true },
        { code: 'decisionResult', type: 'string', required: true },
      ],
    }));

    const result = await service.renderApplicationDocument(
      'rejection',
      { projectTitleAr: 'دراسة السرطان', decisionResult: 'مرفوض' },
      42,
      10,
    );

    expect(result.html).toBe('المشروع: دراسة السرطان - القرار: مرفوض');
  });

  it('renders module document by key', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({
      id: 3,
      content: { ar: { body: 'تقرير: {{executiveSummary}}' } },
      content_hash: 'rep-hash',
      variable_definitions: [
        { code: 'executiveSummary', type: 'string', required: true },
      ],
    }));

    const result = await service.renderModuleDocument(
      'report.annual',
      { executiveSummary: 'ملخص سنوي' },
      10,
      { entityId: 1 },
    );

    expect(result.html).toBe('تقرير: ملخص سنوي');
  });

  it('throws for unknown module document key', async () => {
    await expect(
      service.renderModuleDocument('nonexistent.key', {}, 10),
    ).rejects.toThrow('Unknown module document key');
  });

  it('throws for unknown application document type', async () => {
    await expect(
      service.renderApplicationDocument('unknown', {}, 1, 10),
    ).rejects.toThrow('Unknown application document type');
  });
});

// ─── TemplateIntegrationService — Snapshot Linking ─────

describe('TemplateIntegrationService — Snapshot Linking', () => {
  let service: TemplateIntegrationService;
  let engine: TemplateEngineService;
  let snapshotService: SnapshotService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    snapshotService = new SnapshotService();
    engine = new TemplateEngineService(mockVersionRepo);
    service = new TemplateIntegrationService(engine, snapshotService, mockVersionRepo);
  });

  it('links snapshot to lifecycle event', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
      renderedBy: 10,
    });

    await service.linkSnapshotToEntity(result.snapshot.id, 'lifecycle_event', 42);

    const refs = await snapshotService.getReferences(result.snapshot.id);
    expect(refs.length).toBe(1);
    expect(refs[0].entityType).toBe('lifecycle_event');
    expect(refs[0].entityId).toBe(42);
  });

  it('links snapshot to approval step', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
      renderedBy: 10,
    });

    await service.linkSnapshotToEntity(result.snapshot.id, 'approval_step', 7);

    const refs = await snapshotService.getReferences(result.snapshot.id);
    expect(refs[0].entityType).toBe('approval_step');
  });

  it('links snapshot to rollback event', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: { name: 'test' },
      renderedBy: 10,
    });

    await service.linkSnapshotToEntity(result.snapshot.id, 'rollback', 15);

    const refs = await snapshotService.getReferences(result.snapshot.id);
    expect(refs[0].entityType).toBe('rollback');
  });
});

// ─── TemplateIntegrationService — Determinism ───────────

describe('TemplateIntegrationService — Determinism', () => {
  let service: TemplateIntegrationService;
  let engine: TemplateEngineService;
  let snapshotService: SnapshotService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    snapshotService = new SnapshotService();
    engine = new TemplateEngineService(mockVersionRepo);
    service = new TemplateIntegrationService(engine, snapshotService, mockVersionRepo);
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
  });

  it('same input produces same HTML', async () => {
    const result1 = await service.renderDocument({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'عالم' }, renderedBy: 10,
    });
    const result2 = await service.renderDocument({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'عالم' }, renderedBy: 10,
    });

    expect(result1.html).toBe(result2.html);
  });

  it('same input produces same snapshot hash (dedup)', async () => {
    const result1 = await service.renderDocument({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'عالم' }, renderedBy: 10,
    });
    const result2 = await service.renderDocument({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'عالم' }, renderedBy: 10,
    });

    expect(result1.snapshotHash).toBe(result2.snapshotHash);
    expect(result1.snapshot.id).toBe(result2.snapshot.id);
  });

  it('different variables produces different hash', async () => {
    const result1 = await service.renderDocument({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'أحمد' }, renderedBy: 10,
    });
    const result2 = await service.renderDocument({
      templateCode: 'TPL-001', version: '1.0.0',
      variables: { name: 'سارة' }, renderedBy: 10,
    });

    expect(result1.snapshotHash).not.toBe(result2.snapshotHash);
  });
});

// ─── TemplateIntegrationService — Error Handling ───────

describe('TemplateIntegrationService — Error Handling', () => {
  let service: TemplateIntegrationService;
  let engine: TemplateEngineService;
  let snapshotService: SnapshotService;
  let mockVersionRepo: any;

  beforeEach(() => {
    mockVersionRepo = {
      findByCodeAndVersion: vi.fn(),
    };
    snapshotService = new SnapshotService();
    engine = new TemplateEngineService(mockVersionRepo);
    service = new TemplateIntegrationService(engine, snapshotService, mockVersionRepo);
  });

  it('throws 404 when version not found', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(null);

    const err = await service.renderDocument({
      templateCode: 'NONEXIST',
      version: '1.0.0',
      variables: { name: 'test' },
      renderedBy: 10,
    }).catch((e: any) => e);

    expect(err.status).toBe(404);
  });

  it('throws 400 when required variable missing', async () => {
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const err = await service.renderDocument({
      templateCode: 'TPL-001',
      version: '1.0.0',
      variables: {},
      renderedBy: 10,
    }).catch((e: any) => e);

    expect(err.status).toBe(400);
  });
});
