import { describe, it, expect, vi } from 'vitest';
import { TextWatermarkTypeRenderer, WatermarkEngine } from '../services/watermark';
import type {
  WatermarkConfigRow,
  WatermarkRenderContext,
  WatermarkTile,
} from '../services/watermark';
import type { WatermarkTypeRenderer } from '../services/watermark';

function makeRow(overrides: Partial<WatermarkConfigRow> = {}): WatermarkConfigRow {
  return {
    id: 1,
    code: 'REVOKED',
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
    ...overrides,
  };
}

function makeRepo(rows: WatermarkConfigRow[]) {
  return {
    listActive: vi.fn(async () => rows),
    findByCode: vi.fn(async (code: string) =>
      rows.find((r) => r.code === code && r.is_active) || null
    ),
  };
}

function makeContext(overrides: Partial<WatermarkRenderContext> = {}): WatermarkRenderContext {
  return {
    language: 'ar',
    target: 'html',
    values: {},
    ...overrides,
  };
}

function makeEngine(rows: WatermarkConfigRow[], extraRenderers: WatermarkTypeRenderer[] = []) {
  return new WatermarkEngine(
    makeRepo(rows),
    [new TextWatermarkTypeRenderer(), ...extraRenderers]
  );
}

describe('WatermarkEngine', () => {
  it('renders a layout for a configured code with Arabic text', async () => {
    const engine = makeEngine([makeRow()]);
    const layout = await engine.render('REVOKED', makeContext({ language: 'ar' }));

    expect(layout).not.toBeNull();
    expect(layout!.type).toBe('TEXT');
    expect(layout!.tiles).toHaveLength(1);
    expect(layout!.tiles[0].text).toBe('ملغاة');
  });

  it('localizes text to English when requested and falls back to Arabic when empty', async () => {
    const engine = makeEngine([makeRow()]);
    const en = await engine.render('REVOKED', makeContext({ language: 'en' }));
    expect(en!.tiles[0].text).toBe('REVOKED');

    const engine2 = makeEngine([makeRow({ text_en: '' })]);
    const fallback = await engine2.render('REVOKED', makeContext({ language: 'en' }));
    expect(fallback!.tiles[0].text).toBe('ملغاة');
  });

  it('returns null for an unconfigured code', async () => {
    const engine = makeEngine([makeRow()]);
    expect(await engine.render('NOPE', makeContext())).toBeNull();
  });

  it('does not render an inactive config', async () => {
    const engine = makeEngine([makeRow({ is_active: false })]);
    expect(await engine.render('REVOKED', makeContext())).toBeNull();
  });

  it('flows font, size, color, opacity and rotation from config into the tile', async () => {
    const engine = makeEngine([makeRow({
      font_family: 'Amiri',
      font_size_pt: 42.5,
      color: '#0b3d2e',
      opacity: 0.1,
      rotation_deg: 15,
    })]);

    const layout = await engine.render('REVOKED', makeContext());
    const tile = layout!.tiles[0];
    expect(tile.fontFamily).toBe('Amiri');
    expect(tile.fontSizePt).toBe(42.5);
    expect(tile.color).toBe('#0b3d2e');
    expect(tile.opacity).toBe(0.1);
    expect(tile.rotationDeg).toBe(15);
  });

  describe('position mapping', () => {
    const cases: Array<[WatermarkConfigRow['position'], number, number]> = [
      ['CENTER', 0.5, 0.5],
      ['TOP_LEFT', 0.05, 0.05],
      ['TOP_RIGHT', 0.95, 0.05],
      ['BOTTOM_LEFT', 0.05, 0.95],
      ['BOTTOM_RIGHT', 0.95, 0.95],
    ];

    for (const [position, x, y] of cases) {
      it(`maps ${position} to x=${x} y=${y}`, async () => {
        const engine = makeEngine([makeRow({ position })]);
        const tile = (await engine.render('REVOKED', makeContext()))!.tiles[0];
        expect(tile.x).toBe(x);
        expect(tile.y).toBe(y);
      });
    }
  });

  describe('conditional rendering', () => {
    it('renders when the condition matches the context', async () => {
      const row = makeRow({
        condition: { all: [{ field: 'status', op: 'eq', value: 'REVOKED' }] },
      });
      const engine = makeEngine([row]);

      const hit = await engine.render('REVOKED', makeContext({ values: { status: 'REVOKED' } }));
      expect(hit).not.toBeNull();

      const miss = await engine.render('REVOKED', makeContext({ values: { status: 'ISSUED' } }));
      expect(miss).toBeNull();
    });

    it('returns null when values are absent', async () => {
      const row = makeRow({
        condition: { all: [{ field: 'status', op: 'eq', value: 'REVOKED' }] },
      });
      const engine = makeEngine([row]);
      expect(await engine.render('REVOKED', makeContext())).toBeNull();
    });

    it('supports neq, in and not_in operators with ALL semantics', async () => {
      const row = makeRow({
        condition: {
          all: [
            { field: 'status', op: 'neq', value: 'DRAFT' },
            { field: 'kind', op: 'in', value: ['OFFICIAL', 'APPROVAL'] },
            { field: 'origin', op: 'not_in', value: ['internal'] },
          ],
        },
      });
      const engine = makeEngine([row]);

      expect(await engine.render('REVOKED', makeContext({
        values: { status: 'ISSUED', kind: 'OFFICIAL', origin: 'external' },
      }))).not.toBeNull();

      expect(await engine.render('REVOKED', makeContext({
        values: { status: 'DRAFT', kind: 'OFFICIAL', origin: 'external' },
      }))).toBeNull();
    });
  });

  describe('custom watermark types', () => {
    it('delegates tile generation to a registered custom type renderer', async () => {
      const custom: WatermarkTypeRenderer = {
        type: 'CORNER',
        build: (def, text, _ctx): WatermarkTile[] => [
          {
            text: `[${text}]`,
            fontFamily: def.font_family,
            fontSizePt: def.font_size_pt,
            color: def.color,
            opacity: def.opacity,
            rotationDeg: 0,
            x: 0.02,
            y: 0.02,
            anchor: def.position,
          },
        ],
      };
      const engine = makeEngine([makeRow({ type: 'CORNER' })], [custom]);

      const layout = await engine.render('REVOKED', makeContext());
      expect(layout!.type).toBe('CORNER');
      expect(layout!.tiles[0].text).toBe('[ملغاة]');
      expect(layout!.tiles[0].rotationDeg).toBe(0);
    });

    it('falls back to the TEXT renderer for an unregistered custom type', async () => {
      const engine = makeEngine([makeRow({ type: 'UNKNOWN_CUSTOM' })]);
      const layout = await engine.render('REVOKED', makeContext());
      expect(layout!.type).toBe('UNKNOWN_CUSTOM');
      expect(layout!.tiles).toHaveLength(1);
      expect(layout!.tiles[0].text).toBe('ملغاة');
    });

    it('returns null when a renderer produces no tiles', async () => {
      const empty: WatermarkTypeRenderer = {
        type: 'EMPTY',
        build: () => [],
      };
      const engine = makeEngine([makeRow({ type: 'EMPTY' })], [empty]);
      expect(await engine.render('REVOKED', makeContext())).toBeNull();
    });
  });

  it('renderForTarget stamps the requested target into the layout', async () => {
    const engine = makeEngine([makeRow()]);
    const layout = await engine.renderForTarget('REVOKED', makeContext(), 'print');
    expect(layout!.target).toBe('print');
    expect(layout!.metadata).toEqual({ code: 'REVOKED', id: 1 });
  });
});
