/*
 * مهايئات أهداف العرض: تحول تخطيطاً موحداً (WatermarkLayout) إلى شكل هدف
 * محدد (HTML/PDF/صورة/طباعة). إضافة هدف جديد = تسجيل مهايئ جديد فقط.
 * المهايئ لا يعرف أي شيء عن "معنى" العلامة — بل يرسم الرموز الواردة من التخطيط.
 */
import type {
  WatermarkLayout,
  WatermarkOverlay,
  WatermarkRenderTarget,
} from './types';

export interface WatermarkAdapter {
  readonly target: WatermarkRenderTarget;
  render(layout: WatermarkLayout): WatermarkOverlay;
}

export class HtmlWatermarkAdapter implements WatermarkAdapter {
  readonly target: WatermarkRenderTarget = 'html';

  render(layout: WatermarkLayout): WatermarkOverlay {
    const tilesHtml = layout.tiles
      .map((tile) => {
        const left = (tile.x * 100).toFixed(2);
        const top = (tile.y * 100).toFixed(2);
        const style = [
          `left:${left}%`,
          `top:${top}%`,
          `font-family:${this.cssValue(tile.fontFamily)},Tahoma,sans-serif`,
          `font-size:${this.number(tile.fontSizePt)}pt`,
          `color:${this.cssValue(tile.color)}`,
          `opacity:${this.number(tile.opacity)}`,
          `transform:translate(-50%,-50%) rotate(${this.number(tile.rotationDeg)}deg)`,
        ].join(';');
        return `<div class="wm-tile" style="${style}">${this.escapeHtml(tile.text)}</div>`;
      })
      .join('\n');

    const css = [
      `.wm-overlay{position:fixed;inset:0;pointer-events:none;z-index:1000;overflow:hidden;}`,
      `.wm-tile{position:absolute;font-weight:700;white-space:nowrap;}`,
    ].join('\n');

    const html = `<div class="wm-overlay" data-wm-type="${this.cssValue(layout.type)}">\n${tilesHtml}\n</div>`;

    return { html, css };
  }

  private escapeHtml(value: string): string {
    return String(value)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;')
      .replace(/'/g, '&#39;');
  }

  private cssValue(value: string): string {
    return String(value).replace(/"/g, '&quot;');
  }

  private number(value: number): string {
    return Number.isFinite(value) ? String(value) : '0';
  }
}
