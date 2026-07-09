# Brand Audit Report — National Research Ethics Management System

## 1. Current System Analysis

### 1.1 Official Name & Title

| Element | Current Value | Notes |
|---------|--------------|-------|
| HTML `<title>` | `frontend` | Placeholder, never customized |
| English locale (`app.title`) | `Ethics ERM System` | Used on Login page |
| Arabic locale (`app.title`) | `نظام إدارة أخلاقيات البحث` | Used on Login page |
| English locale (`app.titleShort`) | `Ethics ERM` | Used in sidebar header |
| Arabic locale (`app.titleShort`) | `إدارة أخلاقيات البحث` | Used in sidebar header |

**Issue**: No consistent official name. Three different names in use (`frontend`, `Ethics ERM System`, `نظام إدارة أخلاقيات البحث`).

### 1.2 Logo

| Element | Current State |
|---------|--------------|
| Favicon | `frontend/public/favicon.svg` — Purple gradient (#863bff / #7e14ff) abstract "E" shape |
| Logo image | **None** — No logo SVG, PNG, or any image file exists |
| Brand colors in favicon | Purple (#863bff) — **completely different** from the app's primary blue (#1e40af) |

**Issue**: No official logo. The only visual identity element (favicon) uses a purple color scheme that contradicts the app's blue primary color.

### 1.3 Color System

| Color Role | Light Mode | Dark Mode | Consistency |
|------------|-----------|-----------|-------------|
| Primary | `#1e40af` (blue-800 HEX) | `oklch(0.546 0.245 262.881)` (medium blue) | OK |
| Sidebar BG | Hardcoded `#1e293b` (slate-800) | Same | NOT a CSS variable |
| Sidebar Hover | Hardcoded `#334155` (slate-700) | Same | NOT a CSS variable |
| Background | `oklch(1 0 0)` = white | `oklch(0.145 0 0)` = near-black | OK |
| Secondary | `oklch(0.965 0.01 240)` = light gray-blue | `oklch(0.269 0.04 240)` = dark gray-blue | OK |
| Destructive | `oklch(0.577 0.245 27.325)` = red | Same | OK |
| Favicon/Logo | Purple (#863bff) | — | **INCONSISTENT** with primary |

**Issues**:
- Sidebar colors are hardcoded Tailwind classes (`bg-slate-800`, `text-slate-300`, `hover:bg-slate-700`, `bg-blue-600`) instead of CSS variables
- Primary blue `#1e40af` is very dark (blue-800) for a government healthcare app — not modern
- No secondary accent color for highlights and calls to action
- Missing semantic colors: success green, warning amber, info blue, teal accent
- Favicon purple is completely unrelated to the app's blue theme

### 1.4 Typography

| Font | Current Status |
|------|---------------|
| Cairo (UI) | ✅ Integrated via `fonts.css` + `@theme --font-sans` |
| Noto Sans Arabic (PDF) | ❌ Not referenced anywhere |
| IBM Plex Sans (English) | ❌ Not referenced anywhere |
| Font sizes | ✅ Defined in `@theme` (xs: 12px through 2xl: 24px) |
| Font weights | ✅ Defined in `@theme` (normal: 400 through bold: 700) |

**Strength**: Cairo variable font is already fully integrated with proper unicode-range subsets.

### 1.5 Icons

| Library | Current Status |
|---------|---------------|
| Lucide React v1.17 | ✅ Installed and used across components |
| Custom SVG sprite | `frontend/public/icons.svg` contains generic social media icons (Bluesky, Discord, GitHub, X/Twitter) — **leftover template, not ERM-related** |

**Issue**: `icons.svg` contains social media icons that are irrelevant to the ERM system — appears to be leftover from a template.

### 1.6 Layout

#### Sidebar (`RootLayout.tsx`)
- **Style**: Dark sidebar (`bg-slate-800 text-white`) with blue active states (`bg-blue-600`)
- **Width**: Fixed `w-64` (256px)
- **Sections**: 8 navigation groups (Main, Applications, Committee, Safety & Risk, Communication, Tools, Administration, User)
- **Responsive**: Off-canvas overlay on mobile (`md:hidden`), fixed on desktop (`md:flex`)
- **Weakness**: No animation for mobile sidebar open/close; no collapsed/expandable mode
- **Weakness**: All colors hardcoded, not themeable via CSS variables

#### Header
- **Style**: Mobile-only header bar (white bg, bottom border)
- **Content**: Hamburger menu + app title
- **Desktop**: No header — sidebar handles all navigation
- **Weakness**: No desktop header means no breadcrumbs, no user menu, no notification bell in the header area

#### Main Content Area
- **Style**: Scrollable area with padding (standard layout)
- **Weakness**: No consistent page heading pattern, no breadcrumb component

### 1.7 Login Page (`LoginPage.tsx`)

- **Style**: Minimal centered card on muted background
- **Content**: App title (blue), username/password inputs, submit button, links to register/forgot password
- **Weakness**: No hero illustration, no logo, no ministry branding, no version info, no accessibility features
- **Weakness**: Plain card with no visual hierarchy or professional government feel

### 1.8 Dashboard (`Dashboard.tsx`)

- **Style**: 5 KPI cards in a grid (applications, projects, meetings, reviews, notifications)
- **Content**: Application status breakdown, quick actions
- **Weakness**: No charts (recharts is installed but unused), no SLA tracking, no committee performance, no monthly statistics
- **Weakness**: Basic card layout with icon backgrounds (`bg-blue-500`, `bg-green-500`, `bg-purple-500`, etc.) — no consistent pattern
- **Weakness**: All 5 cards have different colored icon backgrounds (blue, green, purple, amber, rose) — visually inconsistent

### 1.9 Missing Components

| Component | Status |
|-----------|--------|
| Breadcrumb | ❌ Not implemented |
| Pagination | ❌ Not implemented (DataTable uses its own) |
| Empty State | ❌ Not implemented |
| Error State | ❌ Not implemented (ErrorBoundary exists but basic) |
| No Results | ❌ Not implemented |
| Loading Skeleton | ⚠️ Basic `LoadingSkeleton.tsx` exists |
| Toast | ✅ Sonner integrated |
| Alert | ❌ Not implemented |
| Avatar | ❌ Not implemented |
| Dropdown Menu | ❌ Not implemented |
| Tabs | ❌ Not implemented |
| Tooltip | ❌ Not implemented |
| Progress | ❌ Not implemented |
| Accordion | ❌ Not implemented |
| Separator | ❌ Not implemented |
| Checkbox | ❌ Not implemented |
| Radio Group | ❌ Not implemented |

### 1.10 Theme Support

| Theme | Status |
|-------|--------|
| Light | ✅ Working |
| Dark | ✅ Working (`.dark` class) |
| RTL | ✅ Working (`dir="rtl"`) |
| LTR | ❌ Not tested/configured |
| High Contrast | ❌ Not implemented |

### 1.11 Accessibility

| Requirement | Status |
|-------------|--------|
| WCAG AA | ❌ Not audited |
| Keyboard Navigation | ⚠️ Basic (Radix primitives handle their own) |
| Screen Readers | ❌ Not tested |
| Contrast | ❌ Not verified |
| Focus States | ⚠️ Basic (Radix defaults) |
| Zoom 150% | ❌ Not tested |

## 2. Strengths

1. **RTL-first design**: Arabic-first with `dir="rtl"` default layout — correct for the Saudi context
2. **Dark mode**: Fully implemented with `.dark` class variant and OKLCH color values
3. **Modern CSS**: Tailwind v4 with CSS-first configuration (`@theme` block) — maintainable and extensible
4. **Variable font**: Cairo variable font (weight 100-900) already integrated with proper unicode-range subsets
5. **Semantic color tokens**: `--color-primary`, `--color-secondary`, `--color-destructive`, etc. — follows shadcn/ui best practices
6. **Solid component base**: Radix UI primitives (Dialog, Select) + hand-crafted shadcn-style components
7. **i18n**: Full Arabic/English support via i18next with locale JSON files
8. **Icon library**: Lucide React already installed and used consistently
9. **Modern tooling**: Vite + React 19 + TypeScript + React Query
10. **Permission-based navigation**: Sidebar items conditionally shown based on user permissions

## 3. Weaknesses

1. **No official brand identity**: No logo, inconsistent naming, placeholder `<title>`
2. **Color inconsistency**: Favicon is purple, primary is blue, sidebar is slate — three different color systems
3. **Sidebar hardcoded**: Colors are inline Tailwind classes, not CSS variables — impossible to theme
4. **Login page too basic**: No visual hierarchy, no hero, no branding, no ministry identity
5. **Dashboard underdeveloped**: No charts, no SLA, no performance metrics, inconsistent card styling
6. **No desktop header**: Missing breadcrumbs, user menu, notification access in a top bar
7. **Missing design tokens**: No shadow scale, no spacing scale documentation, no animation tokens
8. **No empty/error states**: Missing per-module empty and error state components
9. **Accessibility not addressed**: No WCAG audit, no focus state design, no screen reader testing
10. **Stale assets**: `icons.svg` contains social media icons (Bluesky, Discord, GitHub, X) — leftover template artifacts

## 4. Improvement Suggestions

1. **Create a unified brand** with official name (NERMS), logo, and consistent color palette
2. **Switch primary color** to a more modern navy blue or medical teal — `#1e40af` is too dark and dated
3. **Extract sidebar colors** to CSS variables for themability
4. **Add desktop header** with breadcrumbs, user dropdown, and notification access
5. **Redesign login** with hero illustration, ministry branding, and professional layout
6. **Enhance dashboard** with real charts, SLA tracking, and committee performance metrics
7. **Create empty states** for all modules
8. **Implement accessibility** (WCAG AA minimum)
9. **Remove stale assets** (`icons.svg` social media icons)
10. **Add design tokens** documentation for spacing, shadows, animations, and transitions
