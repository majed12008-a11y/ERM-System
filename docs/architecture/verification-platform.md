# Verification Platform — Architecture

**Status**: Implemented (2026-08-04) — Task 6 (user roadmap), maps to plan Tasks 5 + 9
**Scope**: Backend domain engine + providers/resolvers, thin HTTP transports, public portal UI
**Quality gate**: A second provider (approval certificates) registers against the engine **without any engine change**.

---

## 1. Overview

The verification platform is a domain service that answers one question:

> Given a reference string, is the artifact authentic, and in what lifecycle state?

It is deliberately **not** tied to HTTP, the documents module, or the certificates
module. Artifact-specific behavior lives in *providers*; reference classification
lives in *resolvers*; the engine only orchestrates. This makes the platform
extensible to future artifact types (QR codes, PKI certificates, external
government identifiers, ...) by registering new resolvers/providers.

### Dependency flow

```
Transport (HTTP route)
   → Verification Resolver   (classifies raw reference → VerificationRequest)
      → VerificationEngine   (orchestration only, no I/O)
         → VerificationProvider  (owns artifact behavior, retrieves + translates)
            → VerificationResult (stable public DTO)
```

Resolvers and providers never import Express. The engine performs no I/O;
retrieval happens inside providers so each provider can optimize independently.

---

## 2. Engine responsibilities

File: `backend/src/services/verification/engine.ts`

- Maintains a **resolver registry** and a **provider registry** (insertion ordered).
- `resolve(input)` — returns the first resolver whose `canResolve(input)` is true;
  its `resolve(input)` yields a normalized `VerificationRequest`.
- `verify(input | request, { ip })`:
  1. If given a string, resolves it to a `VerificationRequest`.
  2. Finds the first provider whose `canHandle(request)` is true.
  3. Calls `provider.verify(request)`.
  4. Throws `VerificationNotFoundError` when no resolver matches, no provider
     matches, or the provider returns `null`.
- `registerResolver()` / `registerProvider()` allow runtime extension. The engine
  has **zero knowledge** of concrete artifact types.

### Engine invariants

- First-match-wins for both resolvers and providers (registration order matters).
- The engine never throws domain/provider exceptions to callers other than
  `VerificationNotFoundError`; providers must normalize their own failures.
- IP/context flows through `VerificationRequest.context`, never through globals.

---

## 3. Interfaces

### VerificationResolver — `resolver.ts`

```ts
interface VerificationResolver {
  id: string;
  canResolve(input: string): boolean;
  resolve(input: string): VerificationRequest;
}
```

Example — `ReferenceResolver`:

| Input prefix | artifactType            |
|--------------|-------------------------|
| `CERT-*`/`ERC-*` | `approval-certificate` |
| anything else (incl. UUID) | `generated-document` |

### VerificationProvider — `provider.ts`

```ts
interface VerificationProvider {
  id: string;
  artifactTypes: string[];
  canHandle(request: VerificationRequest): boolean;
  verify(request: VerificationRequest): Promise<VerificationResult | null>;
}
```

`verify()` returns `null` when the reference is not found (the provider also logs
`NOT_FOUND` to its audit log). Providers translate internal DB rows into the public
DTO — **raw rows never escape a provider**.

---

## 4. Versioned DTO contracts — `types.ts`

`VerificationRequest` and `VerificationResult` are **stable public contracts**,
versioned independently from HTTP APIs. `schemaVersion: '1.0'` identifies the DTO
shape in the payload.

```ts
VerificationResult {
  schemaVersion: string;        // '1.0'
  artifactType: string;         // e.g. 'generated-document'
  reference: string;
  verifiedAt: string;           // ISO-8601
  identity:    { documentNumber?, serialNumber?, title?, subject?, type?,
                 language?, issuerName?, templateCode?, templateVersion?,
                 documentVersion?, entityType?, entityId? };
  lifecycle:   { status?, issuedAt?, effectiveAt?, expiresAt?, revokedAt?,
                 revocationReason?, supersededBy?, archivedAt? };
  verification:{ status, method, timestamp };   // status = VerificationStatus
  integrity?:  { checksumAlgorithm?, checksumValue?, checksumVerified?, qrStatus? };
  signatures?: { status: COMPLETE|INCOMPLETE|NONE, requiredCount, completedCount,
                 timeline: [{ signerName?, signatureType?, isRequired?,
                              status?, signedAt?, signatureHash? }] };
  history?:    { supersededBy?, previousVersion?,
                 versions?: [{ versionNo, status?, issuedAt? }],
                 audit?: [{ actionType?, actorName?, timestamp?, details? }] };
  metadata?:   Record<string, unknown>;  // provider-specific, always translated
  links?:      { self?, supersededBy?, download? };
}
```

### VerificationStatus values

| Status       | Meaning                                                    |
|--------------|------------------------------------------------------------|
| `VALID`      | Issued/current artifact                                    |
| `MODIFIED`   | Content hash differs from the stored record (file check)   |
| `INVALID`    | Artifact known but not valid (e.g. VOID)                   |
| `UNKNOWN`    | Reference not resolvable, or artifact in a pre-issue state |
| `REVOKED`    | Explicitly revoked                                         |
| `SUPERSEDED` | Replaced by a newer version                                |
| `EXPIRED`    | Past expiry date (available; no current artifact expires)  |

### Status mapping

- Documents: `OFFICIAL|ISSUED|APPROVED → VALID`; `SUPERSEDED → SUPERSEDED`;
  `REVOKED → REVOKED`; `VOID → INVALID`; else `UNKNOWN`.
- Certificates: `ISSUED → VALID`; `REVOKED → REVOKED`; `SUPERSEDED → SUPERSEDED`;
  `DRAFT|GENERATING|FAILED → UNKNOWN`.

---

## 5. Providers

### DocumentVerificationProvider — `providers/document-provider.ts`

Wraps `DocumentRenderRepository`. Retrieval:

1. `getVerificationData(reference)` → `documents.fn_verify_generated_document` (SECURITY DEFINER).
2. `findDocumentByReference(reference)` → document row (for signatures/audit/versions).
3. `getDocumentSignatures` / `getDocumentAudit` / `getDocumentVersions` → history + signatures sections.
4. `logVerification(...)` → `documents.document_verification_log`.

Integrity section is populated from the stored `checksum_sha256` and the
configured `env.CHECKSUM_ALGORITHM`; `checksumVerified: true` reflects that the
record carries a self-consistent stored hash.

### CertificateVerificationProvider — `providers/certificate-provider.ts`

Wraps `CertificateRepository`. Retrieval: `getVerificationData(serial)` →
`documents.fn_get_certificate_verification` (SECURITY DEFINER), plus
`logVerification(...)` → `documents.certificate_verification_log`.

This provider is the **quality-gate proof**: it was registered against the same
engine (via `registry.ts`) with zero engine modifications.

### Composition root — `registry.ts`

```ts
createVerificationEngine() =>
  new VerificationEngine(
    [ new ReferenceResolver() ],
    [ new DocumentVerificationProvider(), new CertificateVerificationProvider() ]
  );
```

The composition root is the only place that knows concrete providers.

---

## 6. HTTP surface (transports)

All transports are thin: they extract the raw reference + IP and hand them to the
engine. No business logic in routes.

| Route (all under `/api/v1/public`) | Purpose                                  |
|------------------------------------|------------------------------------------|
| `GET /verification/verify/:reference` | Platform entry point (auto-resolves)   |
| `GET /documents/verify/:reference`    | Legacy URL, pinned to `generated-document` |
| `GET /certificates/verify/:serial`    | Legacy URL, pinned to `approval-certificate` |

All three are rate-limited (`RATE_LIMIT_VERIFY_MAX`) and unauthenticated. Unknown
references → `404` with `VerificationNotFoundError` mapping.

---

## 7. Sequence diagram

```
 Browser                     Express route           Engine                Provider                DB
    |  GET /verify/:ref          |                     |                       |                    |
    |---------------------------->|                     |                       |                    |
    |                             | engine.verify(ref)  |                       |                    |
    |                             |-------------------->|                       |                    |
    |                             |                     | resolve(ref)         |                    |
    |                             |                     |-- first resolver ---->|                    |
    |                             |                     |<-- VerificationRequest|                    |
    |                             |                     | find provider         |                    |
    |                             |                     |-- first canHandle --->|                    |
    |                             |                     |                       | provider.verify()  |
    |                             |                     |---------------------->|                    |
    |                             |                     |                       | getVerificationData|
    |                             |                     |                       |-- fn_* (SD) ------>|
    |                             |                     |                       |<-- row ------------|
    |                             |                     |                       | (signatures/audit) |
    |                             |                     |                       | logVerification    |
    |                             |                     |                       | translate -> DTO   |
    |                             |                     |<-- VerificationResult |                    |
    |                             |<-- 200 successResponse(result)                |                    |
    |<----------------------------|                     |                       |                    |
```

---

## 8. Provider registration & resolver selection strategy

### 8.1 Provider registration strategy

Files: `engine.ts`, `registry.ts`.

**Registration lifecycle**
- The composition root (`registry.ts`) is the only place that knows concrete
  providers. It constructs the engine with the initial arrays:
  `new VerificationEngine([new ReferenceResolver()], [documentProvider, certificateProvider])`.
- The engine is permanently open — `registerProvider(provider)` appends a provider
  at any time. There is no sealed/locked phase; late registration is legal and
  affects only subsequent lookups.
- Registration is **not idempotent** and has **no identity check**: registering the
  same instance twice inserts two entries.

**Lookup order**
- Lookup is strictly **array order = registration order**:
  `this.providers.find((p) => p.canHandle(request))` (`engine.ts:59`). The first
  provider whose `canHandle(request)` returns `true` is selected; the engine never
  scans past it.
- The engine does not sort, group, or de-duplicate. `artifactTypes` is advisory
  metadata (used by `listArtifactTypes()` and tests) — **not** a lookup key.
- Consequence: order in the composition root IS priority. `DocumentVerificationProvider`
  is consulted before `CertificateVerificationProvider`.

**Duplicate handling**
- No de-duplication: no `id` uniqueness check, no artifact-type exclusivity check.
- If two registered providers both `canHandle(request)` for the same request, the
  **first wins** and the later one is permanently shadowed — its `verify()` is never
  invoked (a silent dead provider).
- `listArtifactTypes()` flat-maps every provider's `artifactTypes`, so a declared
  type shared by two providers appears twice.
- Rule (convention, not enforced in code): providers MUST keep `canHandle`
  predicates mutually exclusive — normally by `artifactType` — otherwise
  registration order silently decides which artifact is served.

### 8.2 Resolver selection strategy

Files: `engine.ts`, `resolver.ts`.

**Priority**
- Resolvers are consulted in **array order = registration order**
  (`engine.resolve`, `engine.ts:40-47`). Registration is via the constructor array
  or `registerResolver()`. Order is the only priority mechanism — there is no
  score, weight, or configuration.
- `ReferenceResolver.canResolve` returns `true` for **any non-empty trimmed
  string**, making it a terminal catch-all: it claims every non-empty input. Any
  resolver registered after it can never be consulted. A new resolver MUST be
  registered **before** `ReferenceResolver` (or the catch-all predicate tightened)
  to gain priority.
- Legacy transport routes (`/documents/verify/:reference`,
  `/certificates/verify/:serial`) bypass resolution entirely: they pass a
  pre-built `VerificationRequest` with a pinned `artifactType`.

**First-match policy**
- First-match-wins: the engine calls `canResolve(input)` sequentially and uses the
  first resolver returning `true`; that resolver's `resolve(input)` produces the
  `VerificationRequest`. No aggregation, no fallback to a second resolver.
- If no resolver matches (only possible for empty/whitespace input given the
  catch-all), the engine throws `VerificationNotFoundError` → HTTP 404.

**Conflict handling**
- Inside the built-in resolver, classification is a single regex with mutually
  exclusive branches — `^(CERT|ERC)-` → `approval-certificate`, otherwise →
  `generated-document`. No branch can match the same input, so there is no
  internal conflict.
- Cross-resolver conflicts (two resolvers matching one input) resolve
  deterministically by order: the earlier-registered resolver wins — the same
  shadowing rule as providers. New resolvers SHOULD use narrow predicates (a
  specific prefix/format) so precedence is unambiguous.

---

## 9. Extension guide

### Add a new artifact type (e.g. PKI certificate)

1. **Provider**: create `providers/pki-provider.ts` implementing `VerificationProvider`
   with `artifactTypes: ['pki-certificate']`. Translate internal rows into the DTO
   (reuse existing sections; extend `metadata` freely).
2. **Resolver** (optional): if references need classification, add a resolver that
   `canResolve`s the new format before `ReferenceResolver`, or extend the reference
   heuristic.
3. **Register**: add the provider to `registry.ts`. **Do not modify the engine.**
4. **UI**: the portal renders any `VerificationResult` generically — new sections
   appear automatically via the `metadata`/section renderers.

### Add a resolver (e.g. QR code scanning)

Implement `VerificationResolver` and register it **before** the prefix resolver so
it wins. The engine's first-match rule already covers precedence.

### Add data to an existing artifact

Populate additional `identity`/`lifecycle`/`metadata` fields inside the provider.
The DTO is additive — new optional fields are backward compatible.

---

## 10. Contract-versioning strategy

- `VerificationResult.schemaVersion` is a **semantic version** of the DTO.
- Additive changes (new optional sections/fields) are **minor** — old consumers keep
  working, no negotiation required.
- Breaking changes (renames, removed fields, new required fields) are **major** —
  bump `schemaVersion`, and keep a translation layer until all consumers migrate.
- Transport endpoints are versioned independently (`/api/v1/...`); a DTO major bump
  does **not** require a new endpoint.
- Internal DB entities are never exposed; providers translate, so DB schema changes
  never ripple into the DTO.

---

## 11. Files

| Path | Role |
|------|------|
| `backend/src/services/verification/types.ts` | Versioned DTO contracts |
| `backend/src/services/verification/resolver.ts` | Resolver interface + `ReferenceResolver` |
| `backend/src/services/verification/provider.ts` | Provider interface |
| `backend/src/services/verification/engine.ts` | Orchestration engine |
| `backend/src/services/verification/registry.ts` | Composition root |
| `backend/src/services/verification/providers/document-provider.ts` | Documents provider |
| `backend/src/services/verification/providers/certificate-provider.ts` | Certificates provider |
| `backend/src/modules/public/verification.routes.ts` | Platform transport |
| `backend/src/modules/public/documents.routes.ts` / `certificate.routes.ts` | Legacy transports |
| `frontend/src/sdk/public/verification.sdk.ts` | Public portal SDK |
| `frontend/src/pages/Verify/VerifyPage.tsx` | Generic public portal UI |

Tests: `backend/src/test/verification.engine.test.ts`,
`verification.document-provider.test.ts`, `verification.certificate-provider.test.ts`
(19 tests, no DB/HTTP required).
