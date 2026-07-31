# Theme Design — NERMS

## Supported Themes

| Theme | Variant | Status | Implementation |
|-------|---------|--------|----------------|
| **Light** | Default | ✅ Current | `@layer base` CSS variables |
| **Dark** | `class="dark"` | 🔄 Planned | Via `class` toggle on `<html>` |
| **High Contrast** | `data-theme="hc"` | ⏳ Planned | WCAG AAA variant |
| **RTL** | `dir="rtl"` on `<html>` | 🔄 Planned | CSS logical properties |

---

## Light Theme (Default)

Defined in `@layer base` via CSS custom properties (HSL format). See Components-Review.md for full variable mapping.

### Key Light Values

| Variable | HSL | Visual |
|----------|-----|--------|
| `--background` | `0 0% 100%` | White |
| `--foreground` | `220 39% 11%` | Navy-900 (text) |
| `--primary` | `210 73% 15%` | Navy-900 |
| `--primary-foreground` | `0 0% 100%` | White |
| `--secondary` | `140 68% 32%` | Medical Green-600 |
| `--secondary-foreground` | `0 0% 100%` | White |
| `--accent` | `175 84% 32%` | Teal-600 |
| `--accent-foreground` | `0 0% 100%` | White |
| `--muted` | `220 16% 95%` | Gray-100 |
| `--muted-foreground` | `220 9% 46%` | Gray-500 |
| `--border` | `220 18% 90%` | Gray-200 |
| `--input` | `220 18% 90%` | Gray-200 |
| `--ring` | `210 73% 15%` | Navy-900 (focus ring) |

---

## Dark Theme

### Approach

Toggle `class="dark"` on `<html>` via a `<ThemeProvider>` context. CSS variables in `:is(.dark *)` override light values.

### Dark Values

| Variable | HSL | Visual |
|----------|-----|--------|
| `--background` | `222 47% 5%` | Near-black navy |
| `--foreground` | `210 40% 96%` | Light gray |
| `--card` | `222 47% 8%` | Card bg |
| `--card-foreground` | `210 40% 96%` | Light gray |
| `--popover` | `222 47% 8%` | Popover bg |
| `--popover-foreground` | `210 40% 96%` | Light gray |
| `--primary` | `210 73% 35%` | Lighter navy |
| `--primary-foreground` | `0 0% 100%` | White |
| `--secondary` | `140 68% 40%` | Lighter green |
| `--secondary-foreground` | `0 0% 100%` | White |
| `--accent` | `175 84% 45%` | Lighter teal |
| `--accent-foreground` | `0 0% 100%` | White |
| `--muted` | `222 30% 12%` | Dark muted |
| `--muted-foreground` | `215 20% 55%` | Medium gray |
| `--destructive` | `0 70% 45%` | Darker red |
| `--destructive-foreground` | `0 0% 95%` | Near white |
| `--border` | `217 33% 17%` | Dark border |
| `--input` | `217 33% 17%` | Dark input |
| `--ring` | `210 73% 45%` | Lighter ring |

### Sidebar Dark

| Token | Value |
|-------|-------|
| Sidebar BG | `#0d1420` |
| Sidebar Hover | `#16223a` |
| Sidebar Active | `#2563eb` |
| Sidebar Text | `#9ca3b0` |
| Sidebar Heading | `#4b5563` |

---

## Theme Provider

```tsx
// ThemeProvider.tsx
type Theme = 'light' | 'dark' | 'system';

function ThemeProvider({ children }) {
  const [theme, setTheme] = useState<Theme>('light');
  // Toggle 'dark' class on <html>
  // Persist to localStorage
  // Listen for system preference change
}
```

---

## RTL Support

### Approach

Set `dir="rtl"` on `<html>` when user selects Arabic UI language.

### CSS Strategy

Use logical properties wherever possible:

```css
/* Instead of: */
margin-left: 1rem;
padding-right: 0.5rem;
border-left: 1px solid;

/* Use: */
margin-inline-start: 1rem;
padding-inline-end: 0.5rem;
border-inline-start: 1px solid;
```

### Component Adjustments

| Component | RTL Change |
|-----------|-----------|
| Sidebar | Icons after text, chevrons flip horizontally |
| DataTable | Sort indicators on left |
| Input group | Label on right, icon on right |
| Breadcrumb | Separator flips (`/` → `\`) |
| Dropdown | Opens to the left |
| Dialog | Close button on left |
| Pagination | Previous/Next swap |
| Form actions | Submit on right → submit on left |

---

## High Contrast Theme

For WCAG AAA compliance. Activated via `data-theme="hc"` on `<html>`.

### Key Changes

| Property | Light HC | Dark HC |
|----------|----------|---------|
| Text | `#000000` | `#ffffff` |
| Background | `#ffffff` | `#000000` |
| Links | Underlined | Underlined |
| Focus ring | 3px solid `#0000ff` | 3px solid `#00ffff` |
| Buttons | Bordered | Bordered |
| Border contrast | ≥ 3:1 | ≥ 3:1 |

---

## Theme Persistence

- Store user preference in `localStorage('nerms-theme')`
- Store language/direction in `localStorage('nerms-lang')`
- On page load, check `localStorage`, then `prefers-color-scheme`, then default to light
- Sync theme to `<html>` class before first paint (inline script in `index.html`)
