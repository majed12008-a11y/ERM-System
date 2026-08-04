/*
 * أنواع محرك العلامة المائية. جميع الأنواع مستقلة عن الهدف (HTML/PDF/صورة/طباعة)
 * وعن تقنية العرض: المحرك ينتج تخطيطاً موحداً (WatermarkLayout) من إعدادات
 * قابلة للتكوين، والمهايئات تحوله إلى شكل الهدف المطلوب.
 * لا توجد قيم مكتوبة يدوياً للأنماط أو الأنواع هنا.
 */

export type WatermarkPosition =
  | 'CENTER'
  | 'TOP_LEFT'
  | 'TOP_RIGHT'
  | 'BOTTOM_LEFT'
  | 'BOTTOM_RIGHT';

export type WatermarkRenderTarget = 'html' | 'pdf' | 'image' | 'print';

export type WatermarkLanguage = 'ar' | 'en';

export type WatermarkConditionOp = 'eq' | 'neq' | 'in' | 'not_in';

export interface WatermarkConditionClause {
  field: string;
  op: WatermarkConditionOp;
  value: string | string[];
}

/** شرط العرض: يجب أن تنطبق كل البنود (ALL) حتى تُرسم العلامة المائية. */
export interface WatermarkCondition {
  all: WatermarkConditionClause[];
}

/**
 * صف إعداد العلامة المائية كما يقرأ من قاعدة البيانات.
 * `type` يميز نوع العلامة (النصي الافتراضي TEXT أو أنواع مخصصة مسجلة)،
 * و `condition` شرط اختياري للعرض المشروط.
 */
export interface WatermarkConfigRow {
  id: number;
  code: string;
  text_ar: string;
  text_en: string;
  font_family: string;
  font_size_pt: number;
  color: string;
  opacity: number;
  rotation_deg: number;
  position: WatermarkPosition;
  is_active: boolean;
  type: string;
  condition: WatermarkCondition | null;
}

export interface WatermarkRenderContext {
  language: WatermarkLanguage;
  target: WatermarkRenderTarget;
  /** قيم الحقول المتاحة لتقييم شروط العرض (مثل status, entityType). */
  values?: Record<string, string>;
}

/** بلاطة علامة مائية واحدة بإحداثيات معيارية (0..1). */
export interface WatermarkTile {
  text: string;
  fontFamily: string;
  fontSizePt: number;
  color: string;
  opacity: number;
  rotationDeg: number;
  x: number;
  y: number;
  anchor: WatermarkPosition;
}

/** تخطيط مستقل عن الهدف ينتجه المحرك. */
export interface WatermarkLayout {
  type: string;
  target: WatermarkRenderTarget;
  tiles: WatermarkTile[];
  metadata: Record<string, unknown>;
}

/** مخرجات مهايئ HTML: ترميز + أنماط منفصلة. */
export interface WatermarkOverlay {
  html: string;
  css: string;
}
