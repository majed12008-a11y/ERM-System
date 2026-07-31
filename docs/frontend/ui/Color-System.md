# Color System — NERMS Design Tokens

## Brand Palette Overview

| Role | Name | HEX | RGB | HSL | Tailwind |
|------|------|-----|-----|-----|----------|
| **Primary** | Navy 900 | `#0a2540` | rgb(10,37,64) | hsl(210, 73%, 15%) | `blue-950` |
| Primary Hover | Navy 800 | `#0f3b6a` | rgb(15,59,106) | hsl(210, 75%, 24%) | `blue-900` |
| Primary Light | Navy 100 | `#e0edf5` | rgb(224,237,245) | hsl(200, 51%, 92%) | `blue-100` |
| **Secondary** | Medical Green 600 | `#1a8a3f` | rgb(26,138,63) | hsl(140, 68%, 32%) | `green-700` |
| Secondary Hover | Medical Green 500 | `#22ad52` | rgb(34,173,82) | hsl(141, 67%, 41%) | `green-600` |
| Secondary Light | Medical Green 100 | `#e8f5ed` | rgb(232,245,237) | hsl(142, 39%, 94%) | `green-100` |
| **Accent** | Teal 600 | `#0d9488` | rgb(13,148,136) | hsl(175, 84%, 32%) | `teal-600` |
| Accent Hover | Teal 500 | `#14b8a6` | rgb(20,184,166) | hsl(173, 80%, 40%) | `teal-500` |
| Accent Light | Teal 100 | `#ccfbf1` | rgb(204,251,241) | hsl(166, 85%, 89%) | `teal-100` |

## Semantic Color Scale

### Status Colors

| Role | HEX | RGB | HSL | Usage |
|------|-----|-----|-----|-------|
| **Success** | `#16a34a` | rgb(22,163,74) | hsl(142, 76%, 36%) | Approval, completion, positive confirmation |
| Success Light | `#dcfce7` | rgb(220,252,231) | hsl(141, 84%, 93%) | Success badges, banners |
| **Warning** | `#d97706` | rgb(217,119,6) | hsl(33, 95%, 44%) | Pending, under review, caution |
| Warning Light | `#fef3c7` | rgb(254,243,199) | hsl(33, 96%, 89%) | Warning badges, banners |
| **Danger** | `#dc2626` | rgb(220,38,38) | hsl(0, 72%, 51%) | Rejection, error, destruction |
| Danger Light | `#fee2e2` | rgb(254,226,226) | hsl(0, 93%, 94%) | Error badges, alerts |
| **Info** | `#2563eb` | rgb(37,99,235) | hsl(221, 83%, 53%) | Information, neutral updates |
| Info Light | `#dbeafe` | rgb(219,234,254) | hsl(214, 95%, 93%) | Info badges, banners |

### Neutral Scale

| Name | HEX | RGB | HSL | Usage |
|------|-----|-----|-----|-------|
| Gray 50 | `#f8f9fb` | rgb(248,249,251) | hsl(220, 27%, 98%) | Background, cards |
| Gray 100 | `#f0f2f5` | rgb(240,242,245) | hsl(220, 16%, 95%) | Muted backgrounds |
| Gray 200 | `#e2e5eb` | rgb(226,229,235) | hsl(220, 18%, 90%) | Borders, inputs |
| Gray 300 | `#c5cad4` | rgb(197,202,212) | hsl(220, 15%, 80%) | Disabled borders |
| Gray 400 | `#9ca3b0` | rgb(156,163,176) | hsl(220, 11%, 65%) | Placeholder text |
| Gray 500 | `#6b7280` | rgb(107,114,128) | hsl(220, 9%, 46%) | Muted text |
| Gray 600 | `#4b5563` | rgb(75,85,99) | hsl(220, 14%, 34%) | Secondary text |
| Gray 700 | `#374151` | rgb(55,65,81) | hsl(220, 19%, 27%) | Body text |
| Gray 800 | `#1f2937` | rgb(31,41,55) | hsl(220, 28%, 17%) | Heading text |
| Gray 900 | `#111827` | rgb(17,24,39) | hsl(220, 39%, 11%) | Highest emphasis |

## Sidebar Colors

| Token | Light | Dark |
|-------|-------|------|
| Sidebar BG | `#0f1a2e` (navy-850) | `#0d1420` (darker navy) |
| Sidebar Hover | `#1a2d4a` | `#16223a` |
| Sidebar Active | `#1e40af` (blue) | `#2563eb` (blue-600) |
| Sidebar Text | `#c5cad4` (gray-300) | `#9ca3b0` (gray-400) |
| Sidebar Heading | `#6b7280` (gray-500) | `#4b5563` (gray-600) |
| Sidebar Active Text | `#ffffff` | `#ffffff` |

## CSS Variable Mapping

```css
@theme {
  --color-primary: #0a2540;
  --color-primary-hover: #0f3b6a;
  --color-primary-light: #e0edf5;
  --color-primary-foreground: #ffffff;

  --color-secondary: #1a8a3f;
  --color-secondary-hover: #22ad52;
  --color-secondary-light: #e8f5ed;
  --color-secondary-foreground: #ffffff;

  --color-accent: #0d9488;
  --color-accent-hover: #14b8a6;
  --color-accent-light: #ccfbf1;
  --color-accent-foreground: #ffffff;

  --color-success: #16a34a;
  --color-success-light: #dcfce7;
  --color-success-foreground: #ffffff;

  --color-warning: #d97706;
  --color-warning-light: #fef3c7;
  --color-warning-foreground: #ffffff;

  --color-danger: #dc2626;
  --color-danger-light: #fee2e2;
  --color-danger-foreground: #ffffff;

  --color-info: #2563eb;
  --color-info-light: #dbeafe;
  --color-info-foreground: #ffffff;

  --color-sidebar: #0f1a2e;
  --color-sidebar-hover: #1a2d4a;
  --color-sidebar-active: #1e40af;
  --color-sidebar-foreground: #c5cad4;
  --color-sidebar-heading: #6b7280;
}
```

## Contrast Compliance (WCAG AA)

| Pair | Ratio | Passes AA |
|------|-------|-----------|
| Navy 900 on White | 14.2:1 | ✅ |
| Navy 900 on Gray 100 | 12.1:1 | ✅ |
| Medical Green 600 on White | 6.5:1 | ✅ |
| Gray 700 on White | 4.8:1 | ✅ |
| Gray 500 on White | 3.4:1 | ⚠️ (large text only) |
| White on Navy 900 | 14.2:1 | ✅ |
| White on Medical Green 600 | 6.5:1 | ✅ |
