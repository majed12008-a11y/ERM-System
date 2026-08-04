/*
 * مصيِّرات أنواع العلامة المائية. كل نوع يحوّل الإعداد إلى بلاطات
 * بإحداثيات معيارية. النوع الافتراضي TEXT ينشئ بلاطة واحدة حسب الموضع.
 * الأنواع المخصصة تسجَّل في المحرك دون تعديله.
 */
import type {
  WatermarkConfigRow,
  WatermarkPosition,
  WatermarkRenderContext,
  WatermarkTile,
} from './types';
import type { WatermarkTypeRenderer } from './engine';

const POSITION_TO_COORD: Record<WatermarkPosition, { x: number; y: number }> = {
  CENTER: { x: 0.5, y: 0.5 },
  TOP_LEFT: { x: 0.05, y: 0.05 },
  TOP_RIGHT: { x: 0.95, y: 0.05 },
  BOTTOM_LEFT: { x: 0.05, y: 0.95 },
  BOTTOM_RIGHT: { x: 0.95, y: 0.95 },
};

export class TextWatermarkTypeRenderer implements WatermarkTypeRenderer {
  readonly type = 'TEXT';

  build(
    definition: WatermarkConfigRow,
    text: string,
    _context: WatermarkRenderContext
  ): WatermarkTile[] {
    const coord = POSITION_TO_COORD[definition.position] || POSITION_TO_COORD.CENTER;
    return [
      {
        text,
        fontFamily: definition.font_family,
        fontSizePt: definition.font_size_pt,
        color: definition.color,
        opacity: definition.opacity,
        rotationDeg: definition.rotation_deg,
        x: coord.x,
        y: coord.y,
        anchor: definition.position,
      },
    ];
  }
}
