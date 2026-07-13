import Handlebars from 'handlebars';
import { TemplateResolverService } from './template-resolver.service';
import {
  RenderRequest,
  RenderResult,
  CompiledTemplateEntry,
  RenderError,
  CacheStats,
  ContentSource,
} from '../shared/template-render.types';
import type { VersionData } from './template-version-lifecycle.service';

export interface IEngineVersionRepository {
  findByCodeAndVersion(code: string, version: string): Promise<VersionData | null>;
}

export class TemplateEngineService {
  private cache: Map<string, CompiledTemplateEntry> = new Map();
  private totalHits = 0;
  private totalMisses = 0;

  constructor(
    private versionRepo: IEngineVersionRepository,
    private resolver?: TemplateResolverService,
  ) {}

  async render(request: RenderRequest): Promise<RenderResult> {
    const start = Date.now();
    const locale = request.locale || 'ar';

    const versionData = await this.getVersionOrThrow(request.templateCode, request.version);
    const content = this.extractContent(versionData, locale);

    const resolvedVariables = await this.resolveVariables(
      content.variableDefinitions,
      request.variables,
      request.entityType,
      request.entityId,
      request.userContext,
    );

    await this.validateRequiredVariables(content.variableDefinitions, resolvedVariables);

    const cacheKey = `${versionData.id}:${versionData.content_hash}:${locale}`;
    const entry = this.getOrCompile(cacheKey, request.templateCode, request.version, versionData.id, content.body);

    const html = entry.compiled(resolvedVariables);
    const elapsed = Date.now() - start;

    return {
      html,
      templateCode: request.templateCode,
      version: request.version,
      locale,
      renderedAt: new Date(),
      resolutionTimeMs: elapsed,
      cacheHit: entry.hitCount > 1,
      versionId: versionData.id,
      contentHash: versionData.content_hash,
      variableCount: Object.keys(resolvedVariables).length,
    };
  }

  invalidateCache(templateCode: string, version: string, locale?: string): void {
    for (const [key, entry] of this.cache.entries()) {
      if (entry.templateCode === templateCode && entry.version === version) {
        this.cache.delete(key);
      }
    }
  }

  invalidateTemplateCache(templateCode: string): void {
    for (const [key, entry] of this.cache.entries()) {
      if (entry.templateCode === templateCode) {
        this.cache.delete(key);
      }
    }
  }

  clearCache(): void {
    this.cache.clear();
    this.totalHits = 0;
    this.totalMisses = 0;
  }

  getCacheStats(): CacheStats {
    return {
      size: this.cache.size,
      entries: Array.from(this.cache.entries()).map(([, entry]) => ({
        templateCode: entry.templateCode,
        version: entry.version,
        hitCount: entry.hitCount,
        cachedAt: entry.cachedAt,
      })),
      totalHits: this.totalHits,
      totalMisses: this.totalMisses,
    };
  }

  getCachedVersions(templateCode: string): string[] {
    const versions = new Set<string>();
    for (const [, entry] of this.cache.entries()) {
      if (entry.templateCode === templateCode) {
        versions.add(entry.version);
      }
    }
    return Array.from(versions);
  }

  // ─── Private: Variable Resolution ──────────────────────

  private async resolveVariables(
    definitions: { code: string; type: string; required?: boolean; default_value?: unknown; source_type?: string }[],
    provided: Record<string, unknown>,
    entityType?: string,
    entityId?: number,
    userContext?: any,
  ): Promise<Record<string, unknown>> {
    const merged: Record<string, unknown> = {};

    for (const def of definitions) {
      if (def.default_value !== undefined && !(def.code in provided)) {
        merged[def.code] = def.default_value;
      }
    }

    if (this.resolver && entityType && entityId) {
      const entityVariables = definitions.filter(
        d => d.source_type === 'entity' || d.source_type === 'computed',
      );

      if (entityVariables.length > 0) {
        const resolved = await this.resolver.resolveFromVariableDefinitions(
          entityType,
          entityId,
          entityVariables as any,
          userContext,
        );

        for (const [code, value] of resolved) {
          if (!(code in provided)) {
            merged[code] = value;
          }
        }
      }
    }

    for (const [code, value] of Object.entries(provided)) {
      merged[code] = value;
    }

    return merged;
  }

  // ─── Private: Cache ────────────────────────────────────

  private getOrCompile(
    cacheKey: string,
    templateCode: string,
    version: string,
    versionId: number,
    body: string,
  ): CompiledTemplateEntry {
    const existing = this.cache.get(cacheKey);
    if (existing) {
      existing.hitCount++;
      this.totalHits++;
      return existing;
    }

    this.totalMisses++;

    const compiled = Handlebars.compile(body);
    const hash = this.simpleHash(body);

    const entry: CompiledTemplateEntry = {
      compiled,
      templateCode,
      version,
      versionId,
      cachedAt: new Date(),
      hitCount: 1,
      hash,
    };

    if (this.cache.size >= 100) {
      this.evictLeastUsed();
    }

    this.cache.set(cacheKey, entry);
    return entry;
  }

  private evictLeastUsed(): void {
    let minHits = Infinity;
    let minKey = '';

    for (const [key, entry] of this.cache.entries()) {
      if (entry.hitCount < minHits) {
        minHits = entry.hitCount;
        minKey = key;
      }
    }

    if (minKey) {
      this.cache.delete(minKey);
    }
  }

  // ─── Private: Validation ───────────────────────────────

  private async validateRequiredVariables(
    definitions: { code: string; type: string; required?: boolean; default_value?: unknown }[],
    variables: Record<string, unknown>,
  ): Promise<void> {
    const errors: RenderError[] = [];

    for (const def of definitions) {
      if (def.required === true && !(def.code in variables)) {
        errors.push({
          code: 'RENDER_ERR_001',
          message: `Required variable "${def.code}" is missing`,
          affectedField: `variables.${def.code}`,
        });
      }
    }

    if (errors.length > 0) {
      throw Object.assign(
        new Error(`Rendering validation failed: ${errors.map(e => e.message).join('; ')}`),
        { status: 400, renderErrors: errors },
      );
    }
  }

  // ─── Private: Content ──────────────────────────────────

  private extractContent(
    versionData: VersionData,
    locale: string,
  ): ContentSource {
    const content = versionData.content as Record<string, Record<string, string>> | undefined;

    if (!content) {
      throw Object.assign(
        new Error(`Version ${versionData.version} has no content`),
        { status: 400 },
      );
    }

    const localeContent = content[locale] || content['ar'];
    if (!localeContent || !localeContent.body) {
      throw Object.assign(
        new Error(`No content body found for locale "${locale}" in version ${versionData.version}`),
        { status: 400 },
      );
    }

    return {
      body: localeContent.body,
      locale: content[locale] ? locale : 'ar',
      variableDefinitions: Array.isArray(versionData.variable_definitions)
        ? versionData.variable_definitions as any[]
        : [],
    };
  }

  private simpleHash(str: string): string {
    let hash = 0;
    for (let i = 0; i < str.length; i++) {
      const char = str.charCodeAt(i);
      hash = ((hash << 5) - hash) + char;
      hash |= 0;
    }
    return Math.abs(hash).toString(16);
  }

  private async getVersionOrThrow(
    templateCode: string,
    version: string,
  ): Promise<VersionData> {
    const ver = await this.versionRepo.findByCodeAndVersion(templateCode, version);
    if (!ver) {
      throw Object.assign(
        new Error(`Version ${version} of template "${templateCode}" not found`),
        { status: 404 },
      );
    }
    return ver;
  }
}
