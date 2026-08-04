/*
 * محرك العلامة المائية — تنسيق خالص بدون منطق عرض:
 *   - يقرأ الإعداد من المستودع.
 *   - يقيم شرط العرض (conditional rendering) مقابل سياق العرض.
 *   - يفوض توليد البلاطات إلى مسجّل نوع مخصص (WatermarkTypeRenderer).
 *   - ينتج تخطيطاً موحداً مستقلاً عن الهدف (WatermarkLayout).
 * إضافة نوع جديد = تسجيل مُصيِّر (Renderer)، وليس تعديل المحرك.
 */
import type {
  WatermarkConfigRow,
  WatermarkCondition,
  WatermarkLayout,
  WatermarkRenderContext,
  WatermarkRenderTarget,
  WatermarkTile,
} from './types';

export interface WatermarkTypeRenderer {
  readonly type: string;
  build(
    definition: WatermarkConfigRow,
    text: string,
    context: WatermarkRenderContext
  ): WatermarkTile[];
}

export interface WatermarkRepositoryLike {
  listActive(): Promise<WatermarkConfigRow[]>;
  findByCode(code: string): Promise<WatermarkConfigRow | null>;
}

export class WatermarkEngine {
  private readonly typeRenderers = new Map<string, WatermarkTypeRenderer>();

  constructor(
    private readonly repo: WatermarkRepositoryLike,
    typeRenderers: WatermarkTypeRenderer[] = []
  ) {
    for (const renderer of typeRenderers) {
      this.registerTypeRenderer(renderer);
    }
  }

  registerTypeRenderer(renderer: WatermarkTypeRenderer): void {
    this.typeRenderers.set(renderer.type, renderer);
  }

  async listConfigs(): Promise<WatermarkConfigRow[]> {
    return this.repo.listActive();
  }

  async getDefinition(code: string): Promise<WatermarkConfigRow | null> {
    return this.repo.findByCode(code);
  }

  async renderForTarget(
    code: string,
    context: WatermarkRenderContext,
    target: WatermarkRenderTarget
  ): Promise<WatermarkLayout | null> {
    return this.render(code, { ...context, target });
  }

  async render(code: string, context: WatermarkRenderContext): Promise<WatermarkLayout | null> {
    const definition = await this.repo.findByCode(code);
    if (!definition) return null;
    if (!this.matchesCondition(definition.condition, context)) return null;

    const renderer = this.typeRenderers.get(definition.type) || this.typeRenderers.get('TEXT');
    if (!renderer) return null;

    const text = context.language === 'en'
      ? (definition.text_en || definition.text_ar)
      : definition.text_ar;

    const tiles = renderer.build(definition, text, context);
    if (tiles.length === 0) return null;

    return {
      type: definition.type,
      target: context.target,
      tiles,
      metadata: { code: definition.code, id: definition.id },
    };
  }

  matchesCondition(condition: WatermarkCondition | null, context: WatermarkRenderContext): boolean {
    if (!condition || !Array.isArray(condition.all) || condition.all.length === 0) return true;
    return condition.all.every((clause) => {
      const actual = context.values?.[clause.field];
      switch (clause.op) {
        case 'eq':
          return actual === clause.value;
        case 'neq':
          return actual !== clause.value;
        case 'in':
          return actual !== undefined && Array.isArray(clause.value) && clause.value.includes(actual);
        case 'not_in':
          return actual !== undefined && Array.isArray(clause.value) && !clause.value.includes(actual);
        default:
          return true;
      }
    });
  }
}
