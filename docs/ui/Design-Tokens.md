# Design Tokens — NERMS

## Spacing Scale

Based on Tailwind v4 default spacing (4px base unit).

| Token | Value | px | Usage |
|-------|-------|----|-------|
| `spacing-0` | 0px | 0 | No spacing |
| `spacing-1` | 0.25rem | 4px | Minimal, tight icons |
| `spacing-2` | 0.5rem | 8px | Input padding, icon gaps |
| `spacing-3` | 0.75rem | 12px | Card padding (tight) |
| `spacing-4` | 1rem | 16px | **Default spacing** — cards, sections |
| `spacing-5` | 1.25rem | 20px | Section spacing |
| `spacing-6` | 1.5rem | 24px | Card header padding, form spacing |
| `spacing-8` | 2rem | 32px | Page section gaps |
| `spacing-10` | 2.5rem | 40px | Large component gaps |
| `spacing-12` | 3rem | 48px | Page margins |

### Spacing Guidelines

| Context | Token | Rationale |
|---------|-------|-----------|
| Card content padding | `p-6` | Standard card padding |
| Card header bottom | `space-y-1.5` | Title-description gap |
| Form field gap | `space-y-4` | Between input groups |
| Button padding (default) | `px-4 py-2` | Comfortable click area |
| Button padding (sm) | `px-3 py-1.5` | Dense layouts |
| Table cell padding | `p-2` | Dense data display |
| Page section gap | `mb-6` or `gap-6` | Between major sections |
| Sidebar nav item | `px-3 py-2` | Comfortable nav touch |

---

## Border Radius

| Token | Value | Usage |
|-------|-------|-------|
| `radius-sm` | 0.25rem (4px) | Smaller secondary elements |
| `radius-md` | 0.375rem (6px) | Inputs, selects, textareas |
| `radius-lg` | 0.5rem (8px) | Buttons, badges |
| `radius-xl` | 0.75rem (12px) | Cards, dialogs |
| `radius-2xl` | 1rem (16px) | Modals, large containers |

### Current Implementation

```css
--radius: 0.625rem;  /* 10px — default shadcn radius */
```

---

## Elevation / Shadow

| Token | Value | Usage |
|-------|-------|-------|
| `shadow-sm` | `0 1px 2px 0 rgb(0 0 0 / 0.05)` | Cards, small elevated elements |
| `shadow` | `0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)` | Default card elevation |
| `shadow-md` | `0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)` | Dropdown menus, dialogs |
| `shadow-lg` | `0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)` | Modals, notifications |
| `shadow-xl` | `0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)` | Large overlays |

### Usage Rules

- Cards: `shadow` (default) + `hover:shadow-md` for interactive cards
- Dialogs: `shadow-lg`
- Dropdown menus: `shadow-md`
- Notifications: `shadow-lg`
- Sidebar: no shadow (flat)
- Never use shadows on form elements

---

## Transition

| Token | Duration | Timing | Usage |
|-------|----------|--------|-------|
| Default | 150ms | `cubic-bezier(0.4, 0, 0.2, 1)` | Standard transitions |
| Fast | 100ms | Same | Hover states, micro-interactions |
| Slow | 300ms | Same | Panel slide-in, modal overlay |

### Transition Properties

| Property | Token | Usage |
|----------|-------|-------|
| Colors | `transition-colors` | Button bg, link hover |
| All | `transition-all` | Card hover (color + shadow) |
| Opacity | `transition-opacity` | Dialog overlay, disabled states |
| Transform | `transition-transform` | Accordion, panel slide |

---

## Animation

| Name | Keyframe | Usage |
|------|----------|-------|
| `spin` | `360deg rotate` | Loading spinners |
| `pulse` | `50% opacity 0.5` | Skeleton loading |
| `fade-in` | `0→1 opacity` | Dialog entrance |
| `fade-out` | `1→0 opacity` | Dialog exit |
| `slide-in` | `-100%→0 translate-x` | Mobile sidebar |
| `slide-out` | `0→-100% translate-x` | Mobile sidebar close |

---

## Breakpoints

| Breakpoint | Min Width | Usage |
|------------|-----------|-------|
| `sm` | 640px | Large mobile, compact layouts |
| `md` | 768px | **Default breakpoint** — sidebar toggle |
| `lg` | 1024px | Multi-column grids |
| `xl` | 1280px | Wide desktop layouts |
| `2xl` | 1536px | Large monitors |

### Current Layout Behavior

- **Mobile (< md)**: Off-canvas sidebar (overlay), single column content
- **Desktop (≥ md)**: Fixed sidebar, multi-column grids

---

## Container Width

| Token | Max Width | Usage |
|-------|-----------|-------|
| `container-xs` | 20rem (320px) | Narrow forms |
| `container-sm` | 24rem (384px) | Login card |
| `container-md` | 28rem (448px) | Register form |
| `container-lg` | 32rem (512px) | Dialogs |
| `container-2xl` | 42rem (672px) | Wide dialogs |
| `container-3xl` | 48rem (768px) | Content areas |
| `container-4xl` | 56rem (896px) | Page max-width |

---

## Grid

| Layout | Columns | Gap |
|--------|---------|-----|
| KPI Cards | 1 (mobile) → 5 (desktop) | 4 |
| Form Fields | 1 (mobile) → 2-3 (desktop) | 4-6 |
| Dashboard | 1 (mobile) → 2-3 (desktop) | 6 |
| Data Table | Full width | — |

---

## Z-Index Scale

| Layer | Value | Usage |
|-------|-------|-------|
| Base | 0 | Default content |
| Sticky | 10 | Sticky headers |
| Dropdown | 40 | Select dropdowns |
| Sidebar (mobile) | 40 | Off-canvas sidebar |
| Modal overlay | 50 | Dialog backgrounds |
| Modal | 50 | Dialog content |
| Toast | 60 | Notification toasts |
| Tooltip | 70 | Tooltips |
