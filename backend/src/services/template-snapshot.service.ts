import { createHash } from 'crypto';
import {
  RenderSnapshot,
  SnapshotReference,
  SnapshotEntityType,
  CreateSnapshotInput,
  VerifyResult,
  CompareResult,
} from '../shared/template-snapshot.types';

export class SnapshotService {
  private snapshots: Map<number, RenderSnapshot> = new Map();
  private hashIndex: Map<string, number> = new Map();
  private references: SnapshotReference[] = [];
  private nextId = 1;
  private nextRefId = 1;

  async createSnapshot(input: CreateSnapshotInput): Promise<RenderSnapshot> {
    const resolvedVariablesHash = computeVariablesHash(input.variables);

    const snapshotHash = computeSnapshotHash({
      templateVersionId: input.templateVersionId,
      contentHash: input.contentHash,
      resolvedVariablesHash,
      locale: input.locale,
      renderedHtml: input.renderedHtml,
    });

    const existingId = this.hashIndex.get(snapshotHash);
    if (existingId !== undefined) {
      return this.snapshots.get(existingId)!;
    }

    const id = this.nextId++;

    const snapshot: RenderSnapshot = {
      id,
      snapshotHash,
      templateVersionId: input.templateVersionId,
      contentHash: input.contentHash,
      resolvedVariablesHash,
      locale: input.locale,
      renderedHtml: input.renderedHtml,
      renderedAt: new Date(),
      renderedBy: input.renderedBy,
      correlationId: input.correlationId,
      requestId: input.requestId,
      metadata: { ...input.metadata },
    };

    this.snapshots.set(id, snapshot);
    this.hashIndex.set(snapshotHash, id);

    return snapshot;
  }

  async verifySnapshot(hash: string): Promise<VerifyResult> {
    const id = this.hashIndex.get(hash);
    if (id === undefined) {
      return {
        valid: false,
        snapshotHash: hash,
        verifiedAt: new Date(),
        match: false,
      };
    }

    const snapshot = this.snapshots.get(id)!;

    const recomputedHash = computeSnapshotHash({
      templateVersionId: snapshot.templateVersionId,
      contentHash: snapshot.contentHash,
      resolvedVariablesHash: snapshot.resolvedVariablesHash,
      locale: snapshot.locale,
      renderedHtml: snapshot.renderedHtml,
    });

    const match = recomputedHash === hash;

    return {
      valid: match,
      snapshotHash: hash,
      verifiedAt: new Date(),
      match,
    };
  }

  async getSnapshot(id: number): Promise<RenderSnapshot | null> {
    return this.snapshots.get(id) ?? null;
  }

  async getSnapshotByHash(hash: string): Promise<RenderSnapshot | null> {
    const id = this.hashIndex.get(hash);
    if (id === undefined) return null;
    return this.snapshots.get(id) ?? null;
  }

  async compareSnapshots(hash1: string, hash2: string): Promise<CompareResult> {
    const id1 = this.hashIndex.get(hash1);
    const id2 = this.hashIndex.get(hash2);

    if (id1 === undefined || id2 === undefined) {
      const missing: string[] = [];
      if (id1 === undefined) missing.push('hash1');
      if (id2 === undefined) missing.push('hash2');
      throw Object.assign(
        new Error(`Snapshot not found: ${missing.join(', ')}`),
        { status: 404 },
      );
    }

    const snap1 = this.snapshots.get(id1)!;
    const snap2 = this.snapshots.get(id2)!;

    const differences: string[] = [];

    if (snap1.templateVersionId !== snap2.templateVersionId)
      differences.push('templateVersionId');
    if (snap1.contentHash !== snap2.contentHash)
      differences.push('contentHash');
    if (snap1.resolvedVariablesHash !== snap2.resolvedVariablesHash)
      differences.push('resolvedVariablesHash');
    if (snap1.locale !== snap2.locale)
      differences.push('locale');
    if (snap1.renderedHtml !== snap2.renderedHtml)
      differences.push('renderedHtml');

    return {
      identical: differences.length === 0 && hash1 === hash2,
      hash1,
      hash2,
      differences,
    };
  }

  async getHistory(templateVersionId: number): Promise<RenderSnapshot[]> {
    const history: RenderSnapshot[] = [];
    for (const snap of this.snapshots.values()) {
      if (snap.templateVersionId === templateVersionId) {
        history.push(snap);
      }
    }
    return history.sort((a, b) => b.renderedAt.getTime() - a.renderedAt.getTime());
  }

  async addReference(
    snapshotId: number,
    entityType: SnapshotEntityType,
    entityId: number,
  ): Promise<SnapshotReference> {
    const snapshot = this.snapshots.get(snapshotId);
    if (!snapshot) {
      throw Object.assign(
        new Error(`Snapshot ${snapshotId} not found`),
        { status: 404 },
      );
    }

    const ref: SnapshotReference = {
      id: this.nextRefId++,
      snapshotId,
      entityType,
      entityId,
      linkedAt: new Date(),
    };

    this.references.push(ref);
    return ref;
  }

  async getReferences(snapshotId: number): Promise<SnapshotReference[]> {
    return this.references.filter(r => r.snapshotId === snapshotId);
  }

  async findByReference(
    entityType: SnapshotEntityType,
    entityId: number,
  ): Promise<RenderSnapshot | null> {
    const ref = this.references.find(
      r => r.entityType === entityType && r.entityId === entityId,
    );
    if (!ref) return null;
    return this.snapshots.get(ref.snapshotId) ?? null;
  }

  async snapshotCount(): Promise<number> {
    return this.snapshots.size;
  }
}

export function computeVariablesHash(variables: Record<string, unknown>): string {
  const canonical = JSON.stringify(variables, Object.keys(variables).sort());
  return createHash('sha256').update(canonical, 'utf8').digest('hex');
}

export function computeSnapshotHash(components: {
  templateVersionId: number;
  contentHash: string;
  resolvedVariablesHash: string;
  locale: string;
  renderedHtml: string;
}): string {
  const payload = [
    String(components.templateVersionId),
    components.contentHash,
    components.resolvedVariablesHash,
    components.locale,
    components.renderedHtml,
  ].join('::');
  return createHash('sha256').update(payload, 'utf8').digest('hex');
}
