import type { ResolveContext, ResolveRequest } from './template-resolver.types';

export interface RenderRequest {
  templateCode: string;
  version: string;
  variables: Record<string, unknown>;
  locale?: string;
  asOfDate?: Date;
  entityType?: string;
  entityId?: number;
  userContext?: ResolveContext;
}

export interface RenderResult {
  html: string;
  templateCode: string;
  version: string;
  locale: string;
  renderedAt: Date;
  resolutionTimeMs: number;
  cacheHit: boolean;
  versionId: number;
  contentHash: string;
  variableCount: number;
}

export interface CompiledTemplateEntry {
  compiled: HandlebarsTemplateDelegate;
  templateCode: string;
  version: string;
  versionId: number;
  cachedAt: Date;
  hitCount: number;
  hash: string;
}

export interface RenderError {
  code: string;
  message: string;
  affectedField?: string;
}

export interface CacheStats {
  size: number;
  entries: { templateCode: string; version: string; hitCount: number; cachedAt: Date }[];
  totalHits: number;
  totalMisses: number;
}

export interface ContentSource {
  body: string;
  locale: string;
  variableDefinitions: { code: string; type: string; required?: boolean; default_value?: unknown }[];
}
