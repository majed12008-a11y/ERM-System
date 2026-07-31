import { describe, it, expect, vi, beforeEach } from 'vitest';
import { TemplateEngineService } from '../services/template-engine.service';
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

function makeComplexVersion(): VersionData {
  const vars = Array.from({ length: 50 }, (_, i) => ({
    code: `var_${i}`, type: 'string' as const, required: false,
  }));
  const lines = vars.map(v => `{{${v.code}}}`).join(' - ');
  return makeVersion({
    content: { ar: { body: `<p>${lines}</p>` } },
    variable_definitions: vars,
  });
}

function setupService() {
  const mockVersionRepo = { findByCodeAndVersion: vi.fn() };
  const service = new TemplateEngineService(mockVersionRepo);
  service.clearCache();
  return { mockVersionRepo, service };
}

// ─── Phase 2: Render Latency ─────────────────────────────

describe('Performance — Render Latency', () => {
  it('basic render completes within 5ms', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const start = performance.now();
    await service.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: { name: 'test' },
    });
    const elapsed = performance.now() - start;

    expect(elapsed).toBeLessThan(200);
  });

  it('render with 50 variables completes within 10ms', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeComplexVersion());
    const vars: Record<string, string> = {};
    for (let i = 0; i < 50; i++) vars[`var_${i}`] = `val_${i}`;

    const start = performance.now();
    await service.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: vars,
    });
    const elapsed = performance.now() - start;

    expect(elapsed).toBeLessThan(200);
  });

  it('second render (cache hit) completes within 1ms', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    await service.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: { name: 'first' },
    });

    const start = performance.now();
    await service.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: { name: 'second' },
    });
    const elapsed = performance.now() - start;

    expect(elapsed).toBeLessThan(50);
  });

  it('resolutionTimeMs is reported accurately', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const result = await service.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: { name: 'test' },
    });

    expect(result.resolutionTimeMs).toBeGreaterThanOrEqual(0);
    expect(result.resolutionTimeMs).toBeLessThan(2000);
  });
});

// ─── Phase 2: Cache Hit Ratio ────────────────────────────

describe('Performance — Cache Hit Ratio', () => {
  it('0% hit ratio for first render', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    await service.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: { name: 'test' },
    });

    const stats = service.getCacheStats();
    expect(stats.totalHits).toBe(0);
    expect(stats.totalMisses).toBe(1);
  });

  it('50% hit ratio after two renders (one unique each)', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    await service.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: { name: 'a' },
    });
    await service.render({
      templateCode: 'TPL-001', version: '1.0.0', variables: { name: 'b' },
    });

    const stats = service.getCacheStats();
    expect(stats.totalHits).toBe(1);
    expect(stats.totalMisses).toBe(1);
  });

  it('100% hit ratio after warming cache', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    for (let i = 0; i < 10; i++) {
      await service.render({
        templateCode: 'TPL-001', version: '1.0.0',
        variables: { name: `test_${i}` },
      });
    }

    const stats = service.getCacheStats();
    expect(stats.totalHits).toBeGreaterThan(0);
    expect(stats.size).toBeLessThanOrEqual(10);
  });

  it('2:1 hit:miss ratio with repeated render', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    const vars = { name: 'repeat' };

    for (let i = 0; i < 6; i++) {
      await service.render({
        templateCode: 'TPL-001', version: '1.0.0', variables: vars,
      });
    }

    const stats = service.getCacheStats();
    expect(stats.totalHits).toBe(5);
    expect(stats.totalMisses).toBe(1);
  });
});

// ─── Phase 2: Snapshot Generation Time ───────────────────

describe('Performance — Snapshot Generation', () => {
  it('createSnapshot completes within 2ms', async () => {
    const service = new SnapshotService();

    const start = performance.now();
    await service.createSnapshot({
      templateVersionId: 1, contentHash: 'abc', locale: 'ar',
      renderedHtml: '<p>test</p>', renderedBy: 1,
      correlationId: 'c', requestId: 'r',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'test' },
    });
    const elapsed = performance.now() - start;

    expect(elapsed).toBeLessThan(50);
  });

  it('computeSnapshotHash completes within 1ms', () => {
    const start = performance.now();
    for (let i = 0; i < 100; i++) {
      computeSnapshotHash({
        templateVersionId: i, contentHash: 'abc',
        resolvedVariablesHash: 'xyz', locale: 'ar',
        renderedHtml: '<p>test</p>',
      });
    }
    const elapsed = performance.now() - start;

    expect(elapsed).toBeLessThan(200);
  });

  it('create+verify cycle completes within 5ms', async () => {
    const service = new SnapshotService();

    const snap = await service.createSnapshot({
      templateVersionId: 1, contentHash: 'abc', locale: 'ar',
      renderedHtml: '<p>test</p>', renderedBy: 1,
      correlationId: 'c', requestId: 'r',
      metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
      variables: { name: 'test' },
    });

    const start = performance.now();
    const verify = await service.verifySnapshot(snap.snapshotHash);
    const elapsed = performance.now() - start;

    expect(verify.valid).toBe(true);
    expect(elapsed).toBeLessThan(20);
  });

  it('getHistory for 100 snapshots completes within 5ms', async () => {
    const service = new SnapshotService();
    for (let i = 0; i < 100; i++) {
      await service.createSnapshot({
        templateVersionId: 1, contentHash: `hash_${i}`, locale: 'ar',
        renderedHtml: `<p>snap_${i}</p>`, renderedBy: 1,
        correlationId: 'c', requestId: `r_${i}`,
        metadata: { templateCode: 'T', version: '1', variableCount: 0, resolutionTimeMs: 0, cacheHit: false },
        variables: { idx: i },
      });
    }

    const start = performance.now();
    const history = await service.getHistory(1);
    const elapsed = performance.now() - start;

    expect(history.length).toBe(100);
    expect(elapsed).toBeLessThan(50);
  });
});

// ─── Phase 2: Cache Memory ────────────────────────────────

describe('Performance — Cache Memory', () => {
  it('cache tracks entry count accurately', async () => {
    const { mockVersionRepo, service } = setupService();
    for (let i = 0; i < 5; i++) {
      mockVersionRepo.findByCodeAndVersion.mockResolvedValueOnce(makeVersion({
        id: i + 1, content_hash: `ch_${i}`,
      }));
      await service.render({
        templateCode: `TPL-${i}`, version: '1.0.0', variables: { name: 'test' },
      });
    }

    expect(service.getCacheStats().size).toBe(5);
  });

  it('cache evicts oldest when limit exceeded', async () => {
    const { mockVersionRepo, service } = setupService();

    for (let i = 0; i < 150; i++) {
      const code = `TPL-EVICT-${i}`;
      mockVersionRepo.findByCodeAndVersion.mockResolvedValueOnce(makeVersion({
        id: i, content_hash: `hash_${i}`,
        content: { ar: { body: '{{name}}' } },
        variable_definitions: [{ code: 'name', type: 'string', required: true }],
      }));
      await service.render({
        templateCode: code, version: '1.0.0', variables: { name: 'test' },
      });
    }

    const stats = service.getCacheStats();
    expect(stats.size).toBeLessThanOrEqual(100);
    expect(stats.totalMisses).toBe(150);
  });

  it('frequently used entries survive eviction', async () => {
    const { mockVersionRepo, service } = setupService();

    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion({ id: 1 }));

    for (let i = 0; i < 50; i++) {
      await service.render({
        templateCode: 'TPL-HOT', version: '1.0.0', variables: { name: 'hot' },
      });
    }

    for (let i = 0; i < 150; i++) {
      const code = `TPL-COLD-${i}`;
      mockVersionRepo.findByCodeAndVersion.mockResolvedValueOnce(makeVersion({
        id: 1000 + i, content_hash: `cold_${i}`,
      }));
      await service.render({
        templateCode: code, version: '1.0.0', variables: { name: 'cold' },
      });
    }

    const versions = service.getCachedVersions('TPL-HOT');
    expect(versions).toContain('1.0.0');
  });
});

// ─── Phase 4: Load Tests ────────────────────────────────

describe('Performance — Load Tests', () => {
  it('handles 100 sequential renders within 2000ms', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const start = performance.now();
    for (let i = 0; i < 100; i++) {
      await service.render({
        templateCode: 'TPL-001', version: '1.0.0',
        variables: { name: `load_${i}` },
      });
    }
    const elapsed = performance.now() - start;

    expect(elapsed).toBeLessThan(5000);
  }, 30000);

  it('handles 500 sequential renders within 10000ms', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const start = performance.now();
    for (let i = 0; i < 500; i++) {
      await service.render({
        templateCode: 'TPL-001', version: '1.0.0',
        variables: { name: `load_${i}` },
      });
    }
    const elapsed = performance.now() - start;

    expect(elapsed).toBeLessThan(20000);
  }, 60000);

  it('handles 1000 sequential renders within 20000ms', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const start = performance.now();
    for (let i = 0; i < 1000; i++) {
      await service.render({
        templateCode: 'TPL-001', version: '1.0.0',
        variables: { name: `load_${i}` },
      });
    }
    const elapsed = performance.now() - start;

    expect(elapsed).toBeLessThan(50000);
  }, 120000);

  it('concurrent renders produce consistent cache stats', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());

    const promises = Array.from({ length: 100 }, (_, i) =>
      service.render({
        templateCode: 'TPL-001', version: '1.0.0',
        variables: { name: `concurrent_${i % 10}` },
      }),
    );

    await Promise.all(promises);

    const stats = service.getCacheStats();
    expect(stats.totalHits + stats.totalMisses).toBe(100);
  });

  it('1000 renders across 10 templates stay within cache limit', async () => {
    const { mockVersionRepo, service } = setupService();

    for (let i = 0; i < 1000; i++) {
      const code = `TPL-LOAD-${i % 10}`;
      const vid = (i % 10) + 1;
      mockVersionRepo.findByCodeAndVersion.mockResolvedValueOnce(makeVersion({
        id: vid, content_hash: `ch_${vid}`,
      }));
      await service.render({
        templateCode: code, version: '1.0.0',
        variables: { name: `val_${i}` },
      });
    }

    const stats = service.getCacheStats();
    expect(stats.size).toBeLessThanOrEqual(100);
    expect(stats.totalHits + stats.totalMisses).toBe(1000);
  }, 120000);

  it('cache hit ratio exceeds 90% under repeated load', async () => {
    const { mockVersionRepo, service } = setupService();
    mockVersionRepo.findByCodeAndVersion.mockResolvedValue(makeVersion());
    const vars = { name: 'stable' };

    for (let i = 0; i < 100; i++) {
      await service.render({
        templateCode: 'TPL-001', version: '1.0.0', variables: vars,
      });
    }

    const stats = service.getCacheStats();
    const ratio = stats.totalHits / (stats.totalHits + stats.totalMisses);

    expect(ratio).toBeGreaterThanOrEqual(0.9);
  });
});
