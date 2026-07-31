# RC1 Frontend Architecture Guide

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | React 19 + TypeScript 6 |
| Build | Vite 8 |
| Routing | react-router-dom v7 |
| Data Fetching | TanStack Query v5 |
| Forms | react-hook-form + Zod v4 |
| Styling | Tailwind CSS v4 |
| UI Library | Radix UI primitives (dialog, select) + custom components |
| i18n | i18next + react-i18next (Arabic-first RTL, English LTR fallback) |
| Notifications | sonner (toasts) + recharts (charts) |
| Icons | lucide-react |
| Testing | Vitest + jsdom + @testing-library/react |

## Application Shell

```
<QueryClientProvider>        ← TanStack Query cache & defaults
  <ErrorBoundary>            ← Catches render errors globally
    <BrowserRouter>          ← Client-side routing
      <AuthProvider>         ← Auth context (user, token, login/logout)
        <Toaster />          ← Toast notifications (sonner)
        <Suspense>           ← Lazy-loaded page fallback
          <Routes>
            Public: /login, /register, /forgot-password, /reset-password, /verify-email
            Protected: <ProtectedRoute> → <RootLayout> →
              Dashboard, Applications, Projects, Users, Roles, ...
```

### Key Components

| Component | Role |
|---|---|
| `AuthProvider` | Exposes `{ user, token, login, logout, hasPermission }` via context. Stores token in sessionStorage. |
| `ProtectedRoute` | Redirects unauthenticated users to `/login`. Checks token expiry. |
| `RootLayout` | Sidebar navigation (collapsible), header bar, RTL direction toggle. Reads user role for menu visibility. |
| `ErrorBoundary` | Catches unhandled render errors, shows fallback UI. |
| `PageLoader` | Spinner shown during lazy-loaded page suspense. |

### QueryClient Defaults

```typescript
queries: { staleTime: 30s, retry: 1, refetchOnWindowFocus: false }
mutations: { onError: toast.error (except 401/403) }
```

## API Client (`src/api/client.ts`)

- Axios instance with `baseURL: /api/v1`, `withCredentials: true`
- **Request interceptor:** Attaches `Bearer <token>` from sessionStorage
- **Response interceptor:**
  - 401: Single-flight token refresh via `/security/auth/refresh`. On failure → redirect to `/login`.
  - 403: Shows toast "You do not have permission"
  - Other errors: Handled by mutation `onError` default

## SDK Layer (`src/sdk/`)

16 domain modules exporting ~110+ methods, all using the shared Axios client:

```
src/sdk/
├── core/
│   ├── config.ts          ← configureSdk({ baseURL })
│   ├── types.ts           ← 30+ TypeScript interfaces (User, Project, Application, etc.)
│   └── index.ts           ← empty
├── domains/
│   ├── security.sdk.ts    ← auth, users, roles, permissions, responsibilities
│   ├── projects.sdk.ts
│   ├── applications.sdk.ts
│   ├── committee.sdk.ts   ← committees, meetings, members
│   ├── reviews.sdk.ts     ← reviews, voting
│   ├── safety.sdk.ts
│   ├── documents.sdk.ts
│   ├── communication.sdk.ts ← notifications, messages
│   ├── reporting.sdk.ts
│   ├── admin.sdk.ts
│   ├── monitoring.sdk.ts
│   ├── integration.sdk.ts
│   ├── reference.sdk.ts
│   ├── lookups.sdk.ts
│   ├── system.sdk.ts
│   └── workflow.sdk.ts
└── index.ts               ← Re-exports all domains
```

**Usage in pages:**
```typescript
import { useQuery } from '@tanstack/react-query'
import { safety } from '../../sdk'
const { data } = useQuery({ queryKey: ['risk-register'], queryFn: () => safety.getRiskRegister() })
```

## RBAC & Permissions

- **Roles:** SUPER_ADMIN, SYS_ADMIN, ADMIN, ETHICS_ADMIN, COMMITTEE_CHAIR, REVIEWER, RESEARCHER, GUEST
- **Frontend enforcement:** `<ProtectedRoute>` wraps all authenticated routes. Individual pages/components use `usePermission()` hook (checking `user.roleCodes`).
- **Backend enforcement:** Row-Level Security (RLS) on all tables + `authorize()` middleware on routes referencing `x-security-matrix` in OpenAPI spec.
- **Public routes (no auth):** Login, Register, Forgot/Reset Password, Verify Email + 2 reference lookups (institutions-registry, professions).

## i18n & RTL

- **Primary:** Arabic (RTL) — `i18n.language.startsWith('ar')` → `dir="rtl"`
- **Fallback:** English (LTR)
- **Files:** `src/locales/ar.json`, `src/locales/en.json` — loaded via `i18next-http-backend`
- **Direction:** Updated in `App.tsx` on language change event
- **Usage:** `const { t } = useTranslation()` → `t('common.save')`

## SSE / Real-Time

- **`useNotificationStream.ts`** — EventSource connection to `/api/v1/notifications/stream?token=<jwt>`
- **`useDashboardStream.ts`** — EventSource connection to `/api/v1/reports/dashboard-stats/stream?token=<jwt>`
- SSE auth passes JWT as query param (not header — EventSource limitation)

## Form Validation

- Zod schemas in `src/lib/schemas.ts` (register, login, project, application, etc.)
- `react-hook-form` + `@hookform/resolvers` for binding
- Error messages rendered per-field; field-level `errors` object from `formState`

## Component Library (8 custom + 4 Radix)

| Component | Location | Description |
|---|---|---|
| `Button` | `components/ui/button.tsx` | Variants: default, outline, ghost, danger; sizes: sm, md, lg |
| `Card` | `components/ui/card.tsx` | Card, CardHeader, CardTitle, CardContent |
| `Input` | `components/ui/input.tsx` | Styled text input |
| `Textarea` | `components/ui/textarea.tsx` | Styled textarea |
| `Label` | `components/ui/label.tsx` | Form label |
| `Dialog` | `components/ui/dialog.tsx` | Radix dialog wrapper (dialog, trigger, content, header, title, description) |
| `Select` | `components/ui/select.tsx` | Radix select wrapper (native-like) |
| `Switch` | `components/ui/switch.tsx` | Toggle switch |
| `DataTable` | `components/DataTable.tsx` | Generic sortable/filterable table with pagination |
| `StatusBadge` | `components/StatusBadge.tsx` | Color-coded status indicators |
| `ConfirmDialog` | `components/ConfirmDialog.tsx` | Delete/action confirmation modal |
| `PageSkeleton` | `components/LoadingSkeleton.tsx` | Loading skeleton placeholder |
