# Login Experience — NERMS

## Current State

### Issues
1. **Plain white card on gray background** — no visual hierarchy, no energy
2. **No logo** — plain title text
3. **Generic "Sign in" header** — no institutional context
4. **RTL placeholder mismatch** — `البريد الإلكتروني` but field ordering not adapted
5. **No hero/imagery** — empty space beside form
6. **No accessibility enhancements** — no role=alert for errors, no aria-describedby
7. **No account recovery flow** — single "forgot password?" link is minimal

---

## Proposed Design

### Layout (Desktop ≥ md)

```
┌──────────────────────────────────────────────────────────┐
│ ┌────────────────────────┐ ┌──────────────────────────┐ │
│ │                        │ │                          │ │
│ │    Hero Section        │ │    Login Card            │ │
│ │                        │ │    ┌────────────────┐   │ │
│ │    ┌─────┐             │ │    │ NERMS Shield   │   │ │
│ │    │Logo │             │ │    │ Logo (small)    │   │ │
│ │    └─────┘             │ │    │                │   │ │
│ │                        │ │    │ Sign in to     │   │ │
│ │    النظام الوطني       │ │    │ NERMS          │   │ │
│ │    لإدارة الموافقات    │ │    │                │   │ │
│ │    الأخلاقية           │ │    │ ┌────────────┐ │   │ │
│ │                        │ │    │ │ Email      │ │   │ │
│ │    National Ethics     │ │    │ └────────────┘ │   │ │
│ │    Research            │ │    │ ┌────────────┐ │   │ │
│ │    Management System   │ │    │ │ Password   │ │   │ │
│ │                        │ │    │ └────────────┘ │   │ │
│ │    {illustration}      │ │    │                │   │ │
│ │                        │ │    │ [Sign In]      │   │ │
│ │                        │ │    │                │   │ │
│ │                        │ │    │ Forgot?        │   │ │
│ │                        │ │    └────────────────┘   │ │
│ └────────────────────────┘ └──────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

### Transition

Left hero scales down and shifts right as viewport narrows. At `< md`, hero disappears, login card takes full width.

---

## Hero Section

| Element | Detail |
|---------|--------|
| **Background** | Navy-900 (`#0a2540`) → Navy-800 (`#0f3b6a`) gradient |
| **NERMS Logo** | `logo-icon.svg`, 80×80, centered |
| **Arabic Title** | النظام الوطني لإدارة الموافقات الأخلاقية للأبحاث والدراسات |
| **English Title** | National Ethics Research Management System |
| **Subtitle** | Ministry of Health — Republic of Yemen |
| **Subtle watermark** | NERMS shield watermark at 5% opacity, positioned bottom-right |

### Hero Content

```jsx
<div className="hidden md:flex w-1/2 bg-gradient-to-br from-navy-900 to-navy-800 items-center justify-center relative overflow-hidden">
  {/* Watermark */}
  <LogoIcon className="absolute -bottom-20 -right-20 w-96 h-96 opacity-5" />
  {/* Branding */}
  <div className="text-center space-y-6 max-w-md">
    <LogoIcon className="w-20 h-20 mx-auto" />
    <h1 className="text-3xl font-bold text-white leading-snug">
      النظام الوطني لإدارة<br />
      الموافقات الأخلاقية
    </h1>
    <p className="text-white/70 text-sm">
      National Ethics Research Management System
    </p>
    <p className="text-white/50 text-xs">
      Ministry of Health & Environment — Republic of Yemen
    </p>
  </div>
</div>
```

---

## Login Card

| Element | Detail |
|---------|--------|
| **Width** | `max-w-md` (28rem / 448px) |
| **Background** | White (`#ffffff`) |
| **Border radius** | `xl` (0.75rem / 12px) |
| **Shadow** | `shadow-lg` |
| **Logo** | `logo-icon.svg` mini version (w-10 h-10) |

### Form Fields

| Field | Type | Icon | Validation |
|-------|------|------|------------|
| Email | `email` input | `Mail` | Required, email format |
| Password | `password` input | `Lock` | Required, min 6 chars |
| Remember me | checkbox | — | Optional |

### Actions

| Action | Type | Detail |
|--------|------|--------|
| Sign In | Primary button | Full width, `bg-primary` |
| Forgot Password | Link | Text: "نسيت كلمة المرور؟" / "Forgot password?" |
| Need Help? | Link | Text: "تحتاج مساعدة؟" / "Need help?" |

### Error States

```jsx
// Top-level error (wrong credentials)
<div role="alert" className="bg-danger-light text-danger rounded-lg p-3 text-sm">
  {error}
</div>

// Field-level error
<p className="text-sm text-destructive mt-1">{error}</p>
```

### Accessibility

- All inputs have `<label>` with `htmlFor`
- Error messages use `aria-describedby` pointing to the input
- Submit button has `aria-label="Sign in to NERMS"`
- Password field has `autoComplete="current-password"`
- Email field has `autoComplete="email"`
- Form has `noValidate={false}` (browser validation + custom)

---

## Loading State

While submitting:
- Button text changes to "جاري تسجيل الدخول..." / "Signing in..."
- Button shows a spinner icon (Lucide `Loader2` with `animate-spin`)
- Button is disabled
- Fields are disabled

---

## RTL Layout

```
┌──────────────────────────────────────────────────────────┐
│ ┌──────────────────────────┐ ┌────────────────────────┐ │
│ │    Login Card            │ │                        │ │
│ │    ┌────────────────┐    │ │    Hero Section        │ │
│ │    │ NERMS Shield   │    │ │                        │ │
│ │    │ Logo (small)   │    │ │    (mirrored)          │ │
│ │    │                │    │ │                        │ │
│ │    │ تسجيل الدخول   │    │ │                        │ │
│ │    │ إلى النظام     │    │ │                        │ │
│ │    │                │    │ │                        │ │
│ │    │ ┌────────────┐ │    │ │                        │ │
│ │    │ │ البريد     │ │    │ │                        │ │
│ │    │ └────────────┘ │    │ │                        │ │
│ │    │ ┌────────────┐ │    │ │                        │ │
│ │    │ │ كلمة المرور│ │    │ │                        │ │
│ │    │ └────────────┘ │    │ │                        │ │
│ │    │                │    │ │                        │ │
│ │    │ [تسجيل الدخول] │    │ │                        │ │
│ │    │                │    │ │                        │ │
│ │    │ نسيت كلمة      │    │ │                        │ │
│ │    │ المرور؟        │    │ │                        │ │
│ │    └────────────────┘    │ │                        │ │
│ └──────────────────────────┘ └────────────────────────┘ │
└──────────────────────────────────────────────────────────┘
```

---

## Implementation Note

- Current `LoginPage.tsx` uses `react-router-dom` navigation after login
- Must preserve: `AuthContext` integration, token storage, redirect logic
- Hero section added as sibling, not replacement
- All existing `.env` and `api/client.ts` auth flow unchanged
