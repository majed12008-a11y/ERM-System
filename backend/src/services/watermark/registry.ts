/*
 * نقطة التكوين (Composition Root) لمحرك العلامة المائية:
 * المكان الوحيد الذي يعرف المستودع الحقيقي والمصيِّرات والمهايئات الملموسة.
 * إضافة نوع/هدف مستقبلي = تعديل هنا فقط.
 */
import { WatermarkEngine } from './engine';
import { WatermarkRepository } from './repository';
import { TextWatermarkTypeRenderer } from './type-renderers';
import { HtmlWatermarkAdapter } from './adapters';
import type { WatermarkAdapter } from './adapters';
import type { WatermarkRenderTarget } from './types';

export function createWatermarkEngine(): WatermarkEngine {
  return new WatermarkEngine(
    new WatermarkRepository(),
    [new TextWatermarkTypeRenderer()]
  );
}

export function createWatermarkAdapters(): Map<WatermarkRenderTarget, WatermarkAdapter> {
  const adapters = new Map<WatermarkRenderTarget, WatermarkAdapter>();
  adapters.set('html', new HtmlWatermarkAdapter());
  return adapters;
}
