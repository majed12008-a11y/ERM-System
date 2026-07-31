import { describe, it, expect, beforeEach } from 'vitest';
import { SnapshotService, computeVariablesHash, computeSnapshotHash } from '../services/template-snapshot.service';
import type { CreateSnapshotInput } from '../shared/template-snapshot.types';

function makeInput(overrides: Partial<CreateSnapshotInput> = {}): CreateSnapshotInput {
  return {
    templateVersionId: 1,
    contentHash: 'abc123',
    locale: 'ar',
    renderedHtml: '<p>مرحبا عالم</p>',
    renderedBy: 10,
    correlationId: 'corr-001',
    requestId: 'req-001',
    metadata: {
      templateCode: 'TPL-001',
      version: '1.0.0',
      variableCount: 1,
      resolutionTimeMs: 5,
      cacheHit: false,
    },
    variables: { name: 'عالم' },
    ...overrides,
  };
}

// ─── SnapshotService — Creation ──────────────────────────

describe('SnapshotService — Creation', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('creates a snapshot with all fields', async () => {
    const snap = await service.createSnapshot(makeInput());

    expect(snap.id).toBe(1);
    expect(snap.templateVersionId).toBe(1);
    expect(snap.contentHash).toBe('abc123');
    expect(snap.locale).toBe('ar');
    expect(snap.renderedHtml).toBe('<p>مرحبا عالم</p>');
    expect(snap.renderedBy).toBe(10);
    expect(snap.correlationId).toBe('corr-001');
    expect(snap.requestId).toBe('req-001');
    expect(snap.renderedAt).toBeInstanceOf(Date);
    expect(snap.snapshotHash).toBeTruthy();
    expect(snap.snapshotHash.length).toBe(64);
    expect(snap.metadata.templateCode).toBe('TPL-001');
  });

  it('auto-increments snapshot IDs', async () => {
    const snap1 = await service.createSnapshot(makeInput({ requestId: 'r1' }));
    const snap2 = await service.createSnapshot(makeInput({ requestId: 'r2', renderedHtml: '<p>ثاني</p>', variables: { name: 'ثاني' } }));

    expect(snap1.id).toBe(1);
    expect(snap2.id).toBe(2);
  });

  it('computes resolvedVariablesHash from variables', async () => {
    const snap = await service.createSnapshot(makeInput({
      variables: { name: 'عالم', role: 'admin' },
    }));

    expect(snap.resolvedVariablesHash).toBeTruthy();
    expect(snap.resolvedVariablesHash.length).toBe(64);
  });

  it('handles empty variables', async () => {
    const snap = await service.createSnapshot(makeInput({
      variables: {},
      renderedHtml: '<p>ثابت</p>',
      metadata: {
        templateCode: 'TPL-001',
        version: '1.0.0',
        variableCount: 0,
        resolutionTimeMs: 5,
        cacheHit: false,
      },
    }));

    expect(snap.resolvedVariablesHash).toBeTruthy();
    expect(snap.metadata.variableCount).toBe(0);
  });
});

// ─── SnapshotService — Deterministic Hash ────────────────

describe('SnapshotService — Deterministic Hash', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('same input produces same hash', async () => {
    const snap1 = await service.createSnapshot(makeInput());
    const snap2 = await service.createSnapshot(makeInput());

    expect(snap1.snapshotHash).toBe(snap2.snapshotHash);
  });

  it('different HTML produces different hash', async () => {
    const snap1 = await service.createSnapshot(makeInput({ renderedHtml: '<p>نص أول</p>', variables: { name: 'أول' } }));
    const snap2 = await service.createSnapshot(makeInput({ renderedHtml: '<p>نص ثاني</p>', variables: { name: 'ثاني' } }));

    expect(snap1.snapshotHash).not.toBe(snap2.snapshotHash);
  });

  it('different locale produces different hash', async () => {
    const snap1 = await service.createSnapshot(makeInput({ locale: 'ar', renderedHtml: '<p>عربي</p>', variables: { name: 'عربي' } }));
    const snap2 = await service.createSnapshot(makeInput({ locale: 'en', renderedHtml: '<p>English</p>', variables: { name: 'English' } }));

    expect(snap1.snapshotHash).not.toBe(snap2.snapshotHash);
  });

  it('different variables produce different hash', async () => {
    const snap1 = await service.createSnapshot(makeInput({ variables: { name: 'أحمد' }, renderedHtml: '<p>أحمد</p>' }));
    const snap2 = await service.createSnapshot(makeInput({ variables: { name: 'سارة' }, renderedHtml: '<p>سارة</p>' }));

    expect(snap1.snapshotHash).not.toBe(snap2.snapshotHash);
  });

  it('computeVariablesHash is deterministic', () => {
    const h1 = computeVariablesHash({ a: 1, b: 2 });
    const h2 = computeVariablesHash({ b: 2, a: 1 });

    expect(h1).toBe(h2);
    expect(h1.length).toBe(64);
  });

  it('computeSnapshotHash is deterministic', () => {
    const h1 = computeSnapshotHash({
      templateVersionId: 1, contentHash: 'abc',
      resolvedVariablesHash: 'xyz', locale: 'ar',
      renderedHtml: '<p>test</p>',
    });
    const h2 = computeSnapshotHash({
      templateVersionId: 1, contentHash: 'abc',
      resolvedVariablesHash: 'xyz', locale: 'ar',
      renderedHtml: '<p>test</p>',
    });

    expect(h1).toBe(h2);
  });
});

// ─── SnapshotService — Immutability ─────────────────────

describe('SnapshotService — Immutability', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('no update method exists', () => {
    expect((service as any).updateSnapshot).toBeUndefined();
    expect((service as any).update).toBeUndefined();
    expect((service as any).modify).toBeUndefined();
  });

  it('duplicate create returns existing snapshot', async () => {
    const snap1 = await service.createSnapshot(makeInput());
    const snap2 = await service.createSnapshot(makeInput());

    expect(snap1.id).toBe(snap2.id);
    expect(snap1.snapshotHash).toBe(snap2.snapshotHash);
    expect(await service.snapshotCount()).toBe(1);
  });

  it('cannot modify after creation', async () => {
    const snap = await service.createSnapshot(makeInput());
    const retrieved = await service.getSnapshot(snap.id);

    expect(retrieved).not.toBeNull();
    expect(retrieved!.renderedHtml).toBe('<p>مرحبا عالم</p>');
  });
});

// ─── SnapshotService — Verification ──────────────────────

describe('SnapshotService — Verification', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('verifies a valid snapshot hash', async () => {
    const snap = await service.createSnapshot(makeInput());
    const result = await service.verifySnapshot(snap.snapshotHash);

    expect(result.valid).toBe(true);
    expect(result.match).toBe(true);
    expect(result.snapshotHash).toBe(snap.snapshotHash);
    expect(result.verifiedAt).toBeInstanceOf(Date);
  });

  it('fails verification for unknown hash', async () => {
    const result = await service.verifySnapshot('0000000000000000000000000000000000000000000000000000000000000000');

    expect(result.valid).toBe(false);
    expect(result.match).toBe(false);
  });

  it('fails verification for tampered hash', async () => {
    await service.createSnapshot(makeInput());

    const result = await service.verifySnapshot('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');

    expect(result.valid).toBe(false);
    expect(result.match).toBe(false);
  });

  it('verification recomputes hash correctly', async () => {
    const snap = await service.createSnapshot(makeInput());

    const expectedHash = computeSnapshotHash({
      templateVersionId: snap.templateVersionId,
      contentHash: snap.contentHash,
      resolvedVariablesHash: snap.resolvedVariablesHash,
      locale: snap.locale,
      renderedHtml: snap.renderedHtml,
    });

    expect(snap.snapshotHash).toBe(expectedHash);
  });
});

// ─── SnapshotService — Comparison ────────────────────────

describe('SnapshotService — Comparison', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('identical snapshots show no differences', async () => {
    const snap1 = await service.createSnapshot(makeInput());

    const result = await service.compareSnapshots(snap1.snapshotHash, snap1.snapshotHash);

    expect(result.identical).toBe(true);
    expect(result.differences).toEqual([]);
  });

  it('different snapshots show differences', async () => {
    const snap1 = await service.createSnapshot(makeInput({ renderedHtml: '<p>أول</p>', variables: { name: 'أول' } }));
    const snap2 = await service.createSnapshot(makeInput({ renderedHtml: '<p>ثاني</p>', variables: { name: 'ثاني' } }));

    const result = await service.compareSnapshots(snap1.snapshotHash, snap2.snapshotHash);

    expect(result.identical).toBe(false);
    expect(result.differences).toContain('renderedHtml');
  });

  it('throws for missing snapshot in comparison', async () => {
    await expect(
      service.compareSnapshots(
        'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa',
        'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb',
      ),
    ).rejects.toThrow('Snapshot not found');
  });
});

// ─── SnapshotService — Audit Correlation ─────────────────

describe('SnapshotService — Audit Correlation', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('adds reference to lifecycle event', async () => {
    const snap = await service.createSnapshot(makeInput());

    const ref = await service.addReference(snap.id, 'lifecycle_event', 42);

    expect(ref.snapshotId).toBe(snap.id);
    expect(ref.entityType).toBe('lifecycle_event');
    expect(ref.entityId).toBe(42);
    expect(ref.id).toBe(1);
  });

  it('adds reference to approval step', async () => {
    const snap = await service.createSnapshot(makeInput());

    const ref = await service.addReference(snap.id, 'approval_step', 7);

    expect(ref.entityType).toBe('approval_step');
    expect(ref.entityId).toBe(7);
  });

  it('adds reference to rollback', async () => {
    const snap = await service.createSnapshot(makeInput());

    const ref = await service.addReference(snap.id, 'rollback', 15);

    expect(ref.entityType).toBe('rollback');
    expect(ref.entityId).toBe(15);
  });

  it('adds reference to future PDF generation', async () => {
    const snap = await service.createSnapshot(makeInput());

    const ref = await service.addReference(snap.id, 'pdf_generation', 100);

    expect(ref.entityType).toBe('pdf_generation');
    expect(ref.entityId).toBe(100);
  });

  it('getReferences returns all references for a snapshot', async () => {
    const snap = await service.createSnapshot(makeInput());

    await service.addReference(snap.id, 'lifecycle_event', 1);
    await service.addReference(snap.id, 'approval_step', 2);

    const refs = await service.getReferences(snap.id);

    expect(refs.length).toBe(2);
  });

  it('findByReference returns snapshot linked to entity', async () => {
    const snap = await service.createSnapshot(makeInput());
    await service.addReference(snap.id, 'lifecycle_event', 99);

    const found = await service.findByReference('lifecycle_event', 99);

    expect(found).not.toBeNull();
    expect(found!.id).toBe(snap.id);
  });

  it('findByReference returns null when no match', async () => {
    const found = await service.findByReference('lifecycle_event', 999);

    expect(found).toBeNull();
  });

  it('rejects reference to non-existent snapshot', async () => {
    await expect(
      service.addReference(999, 'lifecycle_event', 1),
    ).rejects.toThrow('Snapshot 999 not found');
  });
});

// ─── SnapshotService — History ───────────────────────────

describe('SnapshotService — History', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('returns empty history for unknown version', async () => {
    const history = await service.getHistory(999);

    expect(history).toEqual([]);
  });

  it('returns all snapshots for a version', async () => {
    await service.createSnapshot(makeInput({
      templateVersionId: 1,
      variables: { name: 'أول' },
      renderedHtml: '<p>أول</p>',
      requestId: 'r1',
    }));
    await service.createSnapshot(makeInput({
      templateVersionId: 1,
      variables: { name: 'ثاني' },
      renderedHtml: '<p>ثاني</p>',
      requestId: 'r2',
    }));

    const history = await service.getHistory(1);

    expect(history.length).toBe(2);
  });

  it('filters history by version ID', async () => {
    await service.createSnapshot(makeInput({
      templateVersionId: 1,
      variables: { name: 'v1' },
      renderedHtml: '<p>v1</p>',
      requestId: 'r1',
    }));
    await service.createSnapshot(makeInput({
      templateVersionId: 2,
      variables: { name: 'v2' },
      renderedHtml: '<p>v2</p>',
      requestId: 'r2',
    }));

    const history = await service.getHistory(2);

    expect(history.length).toBe(1);
    expect(history[0].templateVersionId).toBe(2);
  });
});

// ─── SnapshotService — Edge Cases ────────────────────────

describe('SnapshotService — Edge Cases', () => {
  let service: SnapshotService;

  beforeEach(() => {
    service = new SnapshotService();
  });

  it('handles special characters in variables', async () => {
    const snap = await service.createSnapshot(makeInput({
      variables: { text: 'abc!@#$%^&*()_+{}:"><>?|' },
      renderedHtml: '<p>special</p>',
    }));

    expect(snap.snapshotHash).toBeTruthy();
    expect(snap.snapshotHash.length).toBe(64);
  });

  it('handles nested object variables', async () => {
    const snap = await service.createSnapshot(makeInput({
      variables: { user: { name: 'أحمد', role: 'admin' }, items: [1, 2, 3] },
      renderedHtml: '<p>nested</p>',
    }));

    expect(snap.snapshotHash).toBeTruthy();
  });

  it('handles very long rendered HTML', async () => {
    const longHtml = '<p>' + 'x'.repeat(10000) + '</p>';

    const snap = await service.createSnapshot(makeInput({
      renderedHtml: longHtml,
      variables: { name: 'long' },
    }));

    expect(snap.snapshotHash).toBeTruthy();
    expect(snap.snapshotHash.length).toBe(64);
  });

  it('getSnapshot returns null for non-existent id', async () => {
    const snap = await service.getSnapshot(999);

    expect(snap).toBeNull();
  });

  it('getSnapshotByHash returns null for unknown hash', async () => {
    const snap = await service.getSnapshotByHash('unknown');

    expect(snap).toBeNull();
  });

  it('snapshotCount tracks total', async () => {
    expect(await service.snapshotCount()).toBe(0);

    await service.createSnapshot(makeInput({ requestId: 'r1', renderedHtml: '<p>1</p>', variables: { name: '1' } }));
    expect(await service.snapshotCount()).toBe(1);

    await service.createSnapshot(makeInput({ requestId: 'r2', renderedHtml: '<p>2</p>', variables: { name: '2' } }));
    expect(await service.snapshotCount()).toBe(2);
  });

  it('correlationId links across multiple snapshots', async () => {
    const snap1 = await service.createSnapshot(makeInput({
      correlationId: 'common-corr',
      requestId: 'r1',
      renderedHtml: '<p>1</p>',
      variables: { name: '1' },
    }));
    const snap2 = await service.createSnapshot(makeInput({
      correlationId: 'common-corr',
      requestId: 'r2',
      renderedHtml: '<p>2</p>',
      variables: { name: '2' },
    }));

    expect(snap1.correlationId).toBe('common-corr');
    expect(snap2.correlationId).toBe('common-corr');
    expect(snap1.snapshotHash).not.toBe(snap2.snapshotHash);
  });
});
