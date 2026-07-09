# Brand Assets — NERMS

## Directory Structure

```
frontend/public/branding/
├── logo-primary.svg          # Horizontal lockup (primary)
├── logo-horizontal.svg       # Horizontal (English)
├── logo-vertical.svg         # Vertical lockup
├── logo-icon.svg             # Shield icon only (square)
├── logo-favicon.svg          # Simplified shield + check
├── logo-monochrome.svg       # Single color black
├── logo-white.svg            # White on transparent
├── logo-dark.svg             # Navy on transparent
├── favicon.ico               # Generated from logo-favicon.svg
├── favicon-16x16.png         # 16px favicon
├── favicon-32x32.png         # 32px favicon
├── apple-touch-icon.png      # 180px Apple touch icon (for PWA)
├── og-image.png              # Open Graph 1200×630
└── manifest.json             # PWA manifest
```

---

## Logo Usage Rules

| Variant | Background | Use Case |
|---------|------------|----------|
| `logo-primary.svg` | Any (transparent) | Login page hero, page headers, documentation |
| `logo-horizontal.svg` | Light backgrounds | Header, print materials |
| `logo-vertical.svg` | Light backgrounds | Sidebar, signatures |
| `logo-icon.svg` | Any | Favicon, app icon, loading screen |
| `logo-favicon.svg` | Any (simplified) | Small sizes (favicon, avatar) |
| `logo-monochrome.svg` | White/light | Monochrome printing, B&W contexts |
| `logo-white.svg` | Dark backgrounds (navy, black) | Hero dark sections, dark mode |
| `logo-dark.svg` | Light/white backgrounds | Light mode |

---

## Logo Clear Space

- Minimum clear space around logo: equal to the height of the shield icon
- Never place text, other logos, or graphic elements inside this space
- Never rotate, stretch, distort, or recolor the logo
- Never apply effects (dropshadow, gradient, glow) to the logo

---

## Logo Minimum Sizes

| Variant | Digital (px) | Print (mm) |
|---------|-------------|------------|
| Horizontal | 200px width | 30mm width |
| Vertical | 120px width | 20mm width |
| Icon only | 32px width | 10mm width |
| Favicon | 16px width | — |

---

## Color Specifics

| Variant | Colors Used |
|---------|-------------|
| `logo-primary.svg` | Navy-900, Medical Green-600, White |
| `logo-horizontal.svg` | Navy-900, Medical Green-600 |
| `logo-vertical.svg` | Navy-900, Medical Green-600 |
| `logo-icon.svg` | Navy-900, Medical Green-600, White |
| `logo-favicon.svg` | Navy-900, White |
| `logo-monochrome.svg` | Black |
| `logo-white.svg` | White |
| `logo-dark.svg` | Navy-900 |

---

## Incorrect Usage

- ❌ Do not use the icon without the check mark
- ❌ Do not outline or redraw the shield
- ❌ Do not use colored logo on a colored background (use monochrome or white)
- ❌ Do not change proportions
- ❌ Do not add drop shadows or other effects
- ❌ Do not place on busy/noisy backgrounds
- ❌ Do not use the favicon variant at large sizes

---

## File Generation

All SVG files are created in Phase 3 (Logo Design) and copied to `frontend/public/branding/` during Phase 15 (Implementation):

```bash
Copy-Item -Path "docs/ui/logo-*.svg" -Destination "frontend/public/branding/"
```

Favicon ICO and PNG files should be generated with a tool like `sharp` or `pnpmx svg-to-ico` when the logo is finalized.
