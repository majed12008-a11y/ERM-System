import { describe, it, expect } from 'vitest';
import { HtmlWatermarkAdapter } from '../services/watermark';
import type { WatermarkLayout } from '../services/watermark';

function makeLayout(overrides: Partial<WatermarkLayout> = {}): WatermarkLayout {
  return {
    type: 'TEXT',
    target: 'html',
    tiles: [
      {
        text: 'ملغاة',
        fontFamily: 'Tahoma',
        fontSizePt: 60,
        color: '#B71C1C',
        opacity: 0.16,
        rotationDeg: -30,
        x: 0.5,
        y: 0.5,
        anchor: 'CENTER',
      },
    ],
    metadata: { code: 'REVOKED', id: 1 },
    ...overrides,
  };
}

describe('HtmlWatermarkAdapter', () => {
  const adapter = new HtmlWatermarkAdapter();

  it('produces overlay markup with the wm-overlay container', () => {
    const { html } = adapter.render(makeLayout());
    expect(html).toContain('wm-overlay');
    expect(html).toContain('ملغاة');
  });

  it('renders style tokens derived from the layout, not hardcoded values', () => {
    const { css } = adapter.render(makeLayout({
      tiles: [{ ...makeLayout().tiles[0], color: '#0b3d2e', opacity: 0.1, rotationDeg: 15, fontSizePt: 42.5 }],
    }));
    expect(css).toContain('wm-overlay');
    expect(css).toContain('wm-tile');
  });

  it('translates tile geometry into left/top percentages', () => {
    const { html } = adapter.render(makeLayout({
      tiles: [{ ...makeLayout().tiles[0], x: 0.95, y: 0.05 }],
    }));
    expect(html).toContain('left:95.00%');
    expect(html).toContain('top:5.00%');
    expect(html).toContain('rotate(-30deg)');
  });

  it('escapes user-controlled text and metadata', () => {
    const { html } = adapter.render(makeLayout({
      tiles: [{ ...makeLayout().tiles[0], text: '<script>alert(1)</script>' }],
    }));
    expect(html).not.toContain('<script>');
    expect(html).toContain('&lt;script&gt;');
  });

  it('renders custom layout types generically from metadata', () => {
    const { html } = adapter.render(makeLayout({ type: 'CORNER' }));
    expect(html).toContain('data-wm-type="CORNER"');
  });
});
