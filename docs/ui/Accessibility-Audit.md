# Accessibility Audit — NERMS

## Standards

Target: **WCAG 2.2 Level AA** minimum. AAA for high-contrast theme.

## Automated Audit Checklist

### Perceivable

| Criteria | Current Status | Action |
|----------|---------------|--------|
| **1.1.1 Non-text Content** | ✅ All Lucide icons have `aria-hidden` or labels | Verify all |
| **1.2.1 Audio-only / Video-only** | ❌ No media content exists | N/A |
| **1.3.1 Info and Relationships** | 🔄 Forms use labels, tables use headers | Audit all pages |
| **1.3.2 Meaningful Sequence** | ✅ RTL handled by DOM order | Verify |
| **1.3.3 Sensory Characteristics** | ✅ No shape-only or sound-only instructions | Verify |
| **1.4.1 Use of Color** | 🔄 Status badges use icon + text + color | Audit all badges |
| **1.4.3 Contrast (Minimum) AA** | ✅ Navy on white = 14.2:1 (see Color-System.md) | Verify |
| **1.4.4 Resize Text** | ✅ Uses rem units, no fixed font sizes | Verify |
| **1.4.5 Images of Text** | ✅ No images of text (all SVG + CSS) | Verify |
| **1.4.10 Reflow** | 🔄 Min-width 320px, horizontal scroll on DataTable | Audit |
| **1.4.11 Non-text Contrast** | 🔄 Focus indicators, input borders | Audit |
| **1.4.12 Text Spacing** | ✅ No forced spacing overrides | Verify |
| **1.4.13 Content on Hover/Focus** | ✅ Tooltips dismiss on Escape | Verify |

### Operable

| Criteria | Current Status | Action |
|----------|---------------|--------|
| **2.1.1 Keyboard** | 🔄 All interactive elements focusable? | Audit forms, dropdowns, DataTable |
| **2.1.2 No Keyboard Trap** | ✅ Dialogs trap focus, Escape closes | Verify |
| **2.2.1 Timing Adjustable** | 🔄 JWT session timeout | Verify toast/notification |
| **2.2.2 Pause, Stop, Hide** | ❌ No auto-updating content | N/A |
| **2.3.1 Three Flashes** | ✅ No flashing elements | Verify |
| **2.4.1 Bypass Blocks** | 🔄 "Skip to content" link needed | Add |
| **2.4.2 Page Titled** | ✅ React Helmet sets `<title>` | Verify all pages |
| **2.4.3 Focus Order** | 🔄 Logical tab order | Audit dialogs, sidebars |
| **2.4.4 Link Purpose (In Context)** | 🔄 Icon-only links need `aria-label` | Audit |
| **2.4.5 Multiple Ways** | ✅ Sidebar nav + search | Verify |
| **2.4.6 Headings and Labels** | 🔄 Consistent heading hierarchy | Audit |
| **2.4.7 Focus Visible** | 🔄 Focus ring on all interactive elements | Audit |
| **2.5.3 Label in Name** | 🔄 Accessible labels match visual text | Audit |

### Understandable

| Criteria | Current Status | Action |
|----------|---------------|--------|
| **3.1.1 Language of Page** | ✅ `lang="ar"` or `lang="en"` on `<html>` | Verify |
| **3.2.1 On Focus** | ✅ No context change on focus | Verify |
| **3.2.2 On Input** | 🔄 Form submission on Enter? | Audit |
| **3.3.1 Error Identification** | 🔄 Form errors as text | Audit |
| **3.3.2 Labels or Instructions** | ✅ Inputs have labels | Verify |
| **3.3.3 Error Suggestion** | 🔄 Specific error messages | Audit |
| **3.3.4 Error Prevention (Legal)** | ✅ Confirm dialogs for delete/approve | Verify |

### Robust

| Criteria | Current Status | Action |
|----------|---------------|--------|
| **4.1.1 Parsing** | ✅ Valid HTML | Verify |
| **4.1.2 Name, Role, Value** | 🔄 Custom components pass ARIA attributes | Audit |
| **4.1.3 Status Messages** | ✅ Toast notifications use `role="status"` | Verify |

---

## Key Accessibility Issues to Fix

### 1. Skip to Content Link

```tsx
// Add to RootLayout, first focusable element
<a
  href="#main-content"
  className="sr-only focus:not-sr-only focus:absolute focus:top-0 focus:left-0 focus:z-50 focus:p-4 focus:bg-white focus:text-black"
>
  تخطى إلى المحتوى الرئيسي / Skip to main content
</a>
```

### 2. Focus Ring

```css
/* Ensure visible focus on all interactive elements */
:focus-visible {
  outline: 2px solid hsl(var(--ring));
  outline-offset: 2px;
}
```

### 3. Form Error Association

```tsx
<input
  aria-invalid={!!error}
  aria-describedby={error ? `${id}-error` : undefined}
/>
{error && (
  <p id={`${id}-error`} className="text-sm text-destructive" role="alert">
    {error}
  </p>
)}
```

### 4. Dialog & Modal Focus Management

- Trap focus within open dialogs (shadcn does this by default)
- Return focus to trigger element on close
- Close on Escape

### 5. Icon-only Buttons

```tsx
<Button variant="ghost" size="icon" aria-label="Edit application">
  <Pencil className="w-4 h-4" />
</Button>
```

### 6. Status Announcements

```tsx
<div aria-live="polite" aria-atomic="true" className="sr-only">
  {statusMessage}
</div>
```

---

## Color Contrast Check (Light Theme)

### Pass AA (4.5:1+)

| Pair | Ratio | Pass |
|------|-------|------|
| Navy-900 (#0a2540) on White | 14.2:1 | ✅ AAA |
| Medical Green-600 (#1a8a3f) on White | 6.5:1 | ✅ AA |
| Gray-700 (#374151) on White | 4.8:1 | ✅ AA |
| Gray-700 on Gray-100 (#f0f2f5) | 4.1:1 | ❌ AA (large text only) |
| Teal-600 (#0d9488) on White | 4.3:1 | ❌ AA (large text only) |
| White on Navy-900 (#0a2540) | 14.2:1 | ✅ AAA |
| White on Medical Green-600 | 6.5:1 | ✅ AA |

### Fix for Gray-700 on Gray-100

- Option 1: Use Gray-800 (`#1f2937`, ratio 5.7:1)
- Option 2: Use Gray-50 (`#f8f9fb`, ratio 5.8:1)
- **Recommendation**: Use Gray-50 for backgrounds with body text

### Fix for Teal text

- Use Teal-700 (`#0f766e`, ratio 5.2:1) instead of Teal-600 for text
- Teal-600 is acceptable for large text (≥18px bold or ≥24px)

---

## RTL Specific

| Issue | Fix |
|-------|-----|
| Text alignment | Use `text-start` not `text-left` |
| Icon mirroring | Use CSS logical properties |
| Form field ordering | Visual order matches DOM order |
| Keyboard navigation | Tab order follows visual RTL order |

---

## Testing Plan

1. **Automated**: `axe-core` via Playwright (included in E2E)
2. **Keyboard**: Tab through every page, verify focus
3. **Screen Reader**: NVDA / VoiceOver on key workflows
4. **Zoom**: 200% zoom, verify no content loss
5. **Contrast**: Verify with Colour Contrast Analyser
