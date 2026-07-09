# Implementation Plan — NERMS Brand System

## Execution Order

Implementation follows a **top-down dependency order**: theme tokens first, then layout, then pages, then fine-tuning.

Each module file must be read before editing.

---

## Phase 15.1 — Theme Foundation (`index.css`)

**Objective**: Apply all brand tokens to the Tailwind v4 `@theme` block and shadcn CSS variables.

### Steps

1. Update `@theme` block in `frontend/src/index.css`:
   - `--color-primary` → `#0a2540` (Navy-900)
   - `--color-primary-hover` → `#0f3b6a`
   - `--color-primary-light` → `#e0edf5`
   - `--color-secondary` → `#1a8a3f` (Medical Green-600)
   - `--color-secondary-hover` → `#22ad52`
   - `--color-secondary-light` → `#e8f5ed`
   - `--color-accent` → `#0d9488` (Teal-600)
   - `--color-accent-hover` → `#14b8a6`
   - `--color-accent-light` → `#ccfbf1`
   - `--color-success` → `#16a34a`
   - `--color-success-light` → `#dcfce7`
   - `--color-warning` → `#d97706`
   - `--color-warning-light` → `#fef3c7`
   - `--color-danger` → `#dc2626`
   - `--color-danger-light` → `#fee2e2`
   - `--color-info` → `#2563eb`
   - `--color-info-light` → `#dbeafe`
   - `--color-sidebar` → `#0f1a2e`
   - `--color-sidebar-hover` → `#1a2d4a`
   - `--color-sidebar-active` → `#1e40af`
   - `--color-sidebar-foreground` → `#c5cad4`
   - `--color-sidebar-heading` → `#6b7280`

2. Update shadcn CSS variables (`@layer base`):
   - `--foreground` → `220 39% 11%`
   - `--card-foreground` → `220 39% 11%`
   - `--popover-foreground` → `220 39% 11%`
   - `--primary` → `210 73% 15%`
   - `--primary-foreground` → `0 0% 100%`
   - `--secondary` → `140 68% 32%`
   - `--secondary-foreground` → `0 0% 100%`
   - `--muted` → `220 16% 95%`
   - `--muted-foreground` → `220 9% 46%`
   - `--accent` → `175 84% 32%`
   - `--accent-foreground` → `0 0% 100%`
   - `--destructive` → `0 72% 51%`
   - `--destructive-foreground` → `0 0% 100%`
   - `--border` → `220 18% 90%`
   - `--input` → `220 18% 90%`
   - `--ring` → `210 73% 15%`
   - `--radius` → `0.625rem`

3. Add the existing font-sans config (already has Cairo).

4. **Verify**: `npm run lint` (backend tsc) + `cd frontend && npm run lint` + `npm run build`

**Files changed**: `frontend/src/index.css`

---

## Phase 15.2 — Brand Assets (`frontend/public/branding/`)

**Objective**: Copy logo SVGs to public directory.

### Steps

1. Create `frontend/public/branding/` directory
2. Copy all `docs/ui/logo-*.svg` files
3. Add `favicon.ico` reference to `index.html`

**Files changed**: `frontend/index.html` (favicon + manifest)

---

## Phase 15.3 — Sidebar Layout (`RootLayout.tsx`)

**Objective**: Replace hardcoded slate colors with brand tokens. Componentize sidebar.

### Steps

1. Read `frontend/src/layouts/RootLayout.tsx`
2. Replace sidebar colors:
   - `bg-slate-950` → `bg-sidebar`
   - `bg-slate-900` → `bg-sidebar`
   - `text-slate-400` → `text-sidebar-foreground`
   - `text-slate-500` → `text-sidebar-heading`
   - `hover:bg-slate-800` → `hover:bg-sidebar-hover`
   - `bg-slate-800` (active) → `bg-sidebar-active`
   - `text-white` (active text) stays `text-white`
3. Replace sidebar module icons using Iconography.md mapping
4. Add skip-to-content link
5. **Verify**: `npm run build`

**Files changed**: `frontend/src/layouts/RootLayout.tsx`

---

## Phase 15.4 — Login Page (`LoginPage.tsx`)

**Objective**: Redesign with hero section + brand.

### Steps

1. Read `frontend/src/pages/LoginPage.tsx`
2. Add hero section (left side, navy gradient)
3. Move login card to right side
4. Add NERMS logo to hero and card
5. Update form with proper labels, `aria-describedby`, error association
6. Add loading state with spinner
7. RTL support via `dir` attribute
8. **Verify**: `npm run build`

**Files changed**: `frontend/src/pages/LoginPage.tsx`

---

## Phase 15.5 — Dashboard (`Dashboard.tsx`)

**Objective**: Redesign with KPI cards, charts, quick actions, activity list.

### Steps

1. Read `frontend/src/pages/Dashboard.tsx`
2. Replace KPI cards with `KpiCard` component pattern (brand-colored bg, icons, white text)
3. Add chart section (Recharts BarChart for monthly trends)
4. Add Quick Actions grid
5. Add Recent Activity list
6. Add Pending Reviews section
7. Handle loading (skeleton), error (alert), empty states per section
8. **Verify**: `npm run build`

**Files changed**: `frontend/src/pages/Dashboard.tsx`

---

## Phase 15.6 — Empty State Component

**Objective**: Create reusable EmptyState component.

### Steps

1. Create `frontend/src/components/composite/EmptyState.tsx`
2. Implement variants: `empty`, `error`, `search`
3. Implement with Lucide icon, title, description, optional action button
4. **Verify**: `npm run build`

**Files created**: `frontend/src/components/composite/EmptyState.tsx`

---

## Phase 15.7 — Component Hardcoded Color Audit

**Objective**: Scan all `@/components/ui/` for remaining hardcoded colors.

### Steps

1. Use grep to find `bg-`, `text-`, `border-`, `ring-` hardcoded color values
2. Replace with CSS variable usage where applicable
3. **Verify**: `npm run build`

**Files changed**: Various `@/components/ui/` files

---

## Phase 15.8 — Dark Theme

**Objective**: Implement dark mode CSS variables + theme provider.

### Steps

1. Add `@layer base` dark overrides in `index.css`
2. Create `ThemeProvider` context with toggle
3. Add theme toggle to header/settings
4. Persist to localStorage
5. **Verify**: `npm run build`

**Files changed**: `frontend/src/index.css`, `frontend/src/main.tsx`, `frontend/src/context/`
**Files created**: ThemeProvider

---

## Phase 15.9 — RTL Support

**Objective**: Ensure RTL works with CSS logical properties.

### Steps

1. Set `dir="rtl"` on `<html>` based on language preference
2. Audit hardcoded `left`/`right` properties → `inline-start`/`inline-end`
3. Audit icon ordering (before/after text)
4. **Verify**: `npm run build`, visual check

---

## Phase 15.10 — Accessibility Improvements

**Objective**: Fix all discovered accessibility issues.

### Steps

1. Skip-to-content link (already in 15.3)
2. Focus ring styling in `index.css`
3. Form error association (already in 15.4)
4. Icon-only button `aria-label` audit
5. Live region for status announcements
6. **Verify**: `npm run build`

---

## Verification After Each Change

```bash
cd frontend && npm run lint && npm run build
```

## Rollout Order (Recommended)

1. `index.css` (foundation)
2. Brand assets (favicon, logos)
3. Sidebar layout (visual impact)
4. Login page (high-visibility)
5. Dashboard (high-visibility)
6. Empty states (low risk)
7. Component audit (safety check)
8. Dark theme (risk: high)
9. RTL (risk: medium)
10. Accessibility (risk: low)
