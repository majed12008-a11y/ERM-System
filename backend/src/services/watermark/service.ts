/*
 * واجهة خدمية رفيعة لمحرك العلامة المائية تُستخدم من نقاط النهاية:
 * listConfigs + توليد طبقة HTML/CSS للهدف المحدد. كل المنطق في المحرك
 * والمهايئات — لا منطق عرض هنا.
 */
import { createWatermarkAdapters, createWatermarkEngine } from './registry';
import type { WatermarkAdapter } from './adapters';
import type { WatermarkEngine } from './engine';
import type {
  WatermarkConfigRow,
  WatermarkLanguage,
  WatermarkOverlay,
  WatermarkRenderContext,
  WatermarkRenderTarget,
} from './types';

export class WatermarkService {
  constructor(
    private engine: Pick<WatermarkEngine, 'listConfigs' | 'render'> = createWatermarkEngine(),
    private adapters: ReadonlyMap<WatermarkRenderTarget, WatermarkAdapter> = createWatermarkAdapters()
  ) {}

  async listConfigs(): Promise<WatermarkConfigRow[]> {
    return this.engine.listConfigs();
  }

  async renderOverlay(
    code: string,
    language: WatermarkLanguage = 'ar',
    target: WatermarkRenderTarget = 'html',
    values: Record<string, string> = {}
  ): Promise<WatermarkOverlay | null> {
    const adapter = this.adapters.get(target);
    if (!adapter) return null;
    const context: WatermarkRenderContext = { language, target, values };
    const layout = await this.engine.render(code, context);
    if (!layout) return null;
    return adapter.render(layout);
  }

  async overlayHtml(
    code: string,
    language: WatermarkLanguage = 'ar',
    values: Record<string, string> = {}
  ): Promise<string | null> {
    const overlay = await this.renderOverlay(code, language, 'html', values);
    return overlay ? overlay.html : null;
  }

  async overlayCss(
    code: string,
    language: WatermarkLanguage = 'ar',
    values: Record<string, string> = {}
  ): Promise<string | null> {
    const overlay = await this.renderOverlay(code, language, 'html', values);
    return overlay ? overlay.css : null;
  }
}
