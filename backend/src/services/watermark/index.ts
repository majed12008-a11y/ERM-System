export { WatermarkEngine } from './engine';
export type {
  WatermarkTypeRenderer,
  WatermarkRepositoryLike,
} from './engine';
export { WatermarkRepository } from './repository';
export { TextWatermarkTypeRenderer } from './type-renderers';
export { HtmlWatermarkAdapter } from './adapters';
export type { WatermarkAdapter } from './adapters';
export { createWatermarkEngine, createWatermarkAdapters } from './registry';
export { WatermarkService } from './service';
export type {
  WatermarkPosition,
  WatermarkRenderTarget,
  WatermarkLanguage,
  WatermarkConditionOp,
  WatermarkConditionClause,
  WatermarkCondition,
  WatermarkConfigRow,
  WatermarkRenderContext,
  WatermarkTile,
  WatermarkLayout,
  WatermarkOverlay,
} from './types';
