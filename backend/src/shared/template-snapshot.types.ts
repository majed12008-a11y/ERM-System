export interface RenderSnapshot {
  id: number;
  snapshotHash: string;
  templateVersionId: number;
  contentHash: string;
  resolvedVariablesHash: string;
  locale: string;
  renderedHtml: string;
  renderedAt: Date;
  renderedBy: number;
  correlationId: string;
  requestId: string;
  metadata: SnapshotMetadata;
}

export interface SnapshotMetadata {
  templateCode: string;
  version: string;
  variableCount: number;
  resolutionTimeMs: number;
  cacheHit: boolean;
}

export interface SnapshotHash {
  hash: string;
  algorithm: 'SHA-256';
  components: {
    templateVersionId: number;
    contentHash: string;
    resolvedVariablesHash: string;
    locale: string;
    renderedHtmlLength: number;
  };
}

export interface SnapshotReference {
  id: number;
  snapshotId: number;
  entityType: SnapshotEntityType;
  entityId: number;
  linkedAt: Date;
}

export type SnapshotEntityType =
  | 'lifecycle_event'
  | 'approval_step'
  | 'rollback'
  | 'pdf_generation'
  | 'docx_generation';

export interface CreateSnapshotInput {
  templateVersionId: number;
  contentHash: string;
  locale: string;
  renderedHtml: string;
  renderedBy: number;
  correlationId: string;
  requestId: string;
  metadata: SnapshotMetadata;
  variables: Record<string, unknown>;
}

export interface VerifyResult {
  valid: boolean;
  snapshotHash: string;
  verifiedAt: Date;
  match: boolean;
}

export interface CompareResult {
  identical: boolean;
  hash1: string;
  hash2: string;
  differences: string[];
}
