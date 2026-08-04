import { describe, it, expect, vi } from 'vitest';
import { WatermarkService } from '../services/watermark';
import type { WatermarkConfigRow } from '../services/watermark';

function makeRow(code: string): WatermarkConfigRow {
  return {
    id: 1,
    code,
    text_ar: 'ملغاة',
    text_en: 'REVOKED',
    font_family: 'Tahoma',
    font_size_pt: 60,
    color: '#B71C1C',
    opacity: 0.16,
    rotation_deg: -30,
    position: 'CENTER',
    is_active: true,
    type: 'TEXT',
    condition: null,
  };
}

function makeEngine(rows: WatermarkConfigRow[]) {
  return {
    listConfigs: vi.fn(async () => rows),
    render: vi.fn(async (code: string) => {
      if (!rows.some((r) => r.code === code)) return null;
      return { type: 'TEXT', target: 'html', tiles: [], metadata: {} };
    }),
  };
}

describe('WatermarkService', () => {
  it('lists active configs', async () => {
    const engine = makeEngine([makeRow('DRAFT'), makeRow('CUSTOM')]);
    const service = new WatermarkService(engine as any);
    const configs = await service.listConfigs();
    expect(configs.map((c) => c.code)).toEqual(['DRAFT', 'CUSTOM']);
  });

  it('returns localized overlay HTML for a configured code', async () => {
    const service = new WatermarkService(makeEngine([makeRow('REVOKED')]) as any);
    const html = await service.overlayHtml('REVOKED', 'ar');
    expect(html).not.toBeNull();
    expect(html).toContain('wm-overlay');
  });

  it('returns null for an unconfigured code', async () => {
    const service = new WatermarkService(makeEngine([makeRow('REVOKED')]) as any);
    expect(await service.overlayHtml('NOPE', 'en')).toBeNull();
  });

  it('resolves no overlay when the engine condition fails', async () => {
    const engine = {
      listConfigs: vi.fn(async () => [makeRow('REVOKED')]),
      render: vi.fn(async () => null),
    };
    const service = new WatermarkService(engine as any);
    expect(await service.renderOverlay('REVOKED', 'ar', 'html', { status: 'ISSUED' })).toBeNull();
  });

  it('renders to a registered target adapter', async () => {
    const engine = {
      listConfigs: vi.fn(async () => [makeRow('REVOKED')]),
      render: vi.fn(async (code: string, context: any) => ({
        type: 'TEXT',
        target: context.target,
        tiles: [{ text: 'ملغاة', fontFamily: 'Tahoma', fontSizePt: 60, color: '#B71C1C', opacity: 0.16, rotationDeg: -30, x: 0.5, y: 0.5, anchor: 'CENTER' }],
        metadata: {},
      })),
    };
    const service = new WatermarkService(engine as any);
    const overlay = await service.renderOverlay('REVOKED', 'en', 'html', {});
    expect(overlay).not.toBeNull();
    expect(overlay!.html).toContain('wm-overlay');
    expect(overlay!.css).toContain('wm-overlay');
  });
});
