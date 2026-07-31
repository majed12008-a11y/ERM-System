# Typography Design — NERMS

## Font Stack

| Usage | Font | Fallback | Status |
|-------|------|----------|--------|
| **UI (Arabic)** | Cairo | "Segoe UI", sans-serif | ✅ Integrated |
| **UI (English)** | Cairo | "Segoe UI", sans-serif | ✅ Integrated (Latin subset) |
| **Official Documents** | Noto Sans Arabic | sans-serif | ⏳ Planned |
| **English Code / Technical** | IBM Plex Sans | sans-serif | ⏳ Planned |

## Cairo Variable Font

- **Format**: WOFF2 variable font (weight 100–900)
- **Files**: 3 unicode-range subsets (Arabic, Latin Extended, Latin)
- **Display**: `swap` (fallback text renders immediately)
- **Source**: Local (`/fonts/` in `public/`)

## Font Family Configuration

```css
@theme {
  --font-sans: "Cairo", "Segoe UI", sans-serif;
}
```

Applied globally via Tailwind v4 `html { font-family: var(--default-font-family); }`.

## Font Size Scale

All sizes in `rem` (relative to 16px browser default).

| Token | Value | px | Line Height | Usage |
|-------|-------|----|-------------|-------|
| `text-xs` | 0.75rem | 12px | 1 (16px) | Captions, meta, timestamps, status badges |
| `text-sm` | 0.875rem | 14px | 1.25 (17.5px) | **Base text**, inputs, buttons, sidebar, DataTable |
| `text-base` | 1rem | 16px | 1.5 (24px) | Card titles, emphasis, larger labels |
| `text-lg` | 1.125rem | 18px | 1.5 (27px) | Section titles, dialog titles |
| `text-xl` | 1.25rem | 20px | 1.5 (30px) | Page subtitles |
| `text-2xl` | 1.5rem | 24px | 1.5 (36px) | Page titles |

## Font Weight Scale

| Token | Value | Usage |
|-------|-------|-------|
| `font-normal` | 400 | Body text, paragraph content |
| `font-medium` | 500 | Inputs, labels, table headers, buttons |
| `font-semibold` | 600 | Section titles, card titles, nav items |
| `font-bold` | 700 | Page titles, emphasis, KPI values |

## Line Height Guidelines

| Context | Line Height | Rationale |
|---------|-------------|-----------|
| Body text | 1.5 (24px at 16px) | Standard readability |
| Dense data (tables) | 1.25 | Compact, scanable |
| Headings | 1.25 | Tight, impactful |
| Small text (captions) | 1.0 | No extra spacing needed |

## Letter Spacing

| Context | Tracking | Usage |
|---------|----------|-------|
| Normal | `0` | All body text, headings |
| Tight | `-0.025em` | Large headings (24px+) |
| Wide | `0.05em` | Uppercase labels, section headers in sidebar |

## Text Transformation

| Context | Transform | Usage |
|---------|-----------|-------|
| Status badges | `capitalize` | Application status, review status |
| Section headers (sidebar) | `uppercase` | Sidebar section labels |
| Regular text | none | Everything else |

## Color Contrast for Typography

| Text Type | Color | Contrast on White |
|-----------|-------|-------------------|
| Primary heading | `#111827` (gray-900) | 17:1 |
| Body text | `#374151` (gray-700) | 4.8:1 |
| Muted text | `#6b7280` (gray-500) | 3.4:1 (AA large only) |
| Disabled text | `#9ca3b0` (gray-400) | 2.3:1 |

## Implementation Notes

- The existing `text-sm` (0.875rem) serves as the de facto base text size (14px) for inputs, buttons, DataTable, sidebar, and most content.
- `text-base` (1rem) aligns with card titles and emphasized content — NOT the default paragraph size.
- Setting `html { font-size: 14px }` is **not recommended** because `text-sm` would become 12.25px (too small for inputs).
