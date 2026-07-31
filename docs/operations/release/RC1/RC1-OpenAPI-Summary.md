# RC1 — OpenAPI 3.1 Contract Summary

## Spec Location

- Root: `backend/openapi/openapi.yaml`
- Shared Components: `backend/openapi/components.yaml`
- Security Schema: `backend/openapi/security.schema.yaml`
- 15 Module Files: `backend/openapi/modules/*.yaml`

## Metrics

| Metric | Value |
|--------|-------|
| OpenAPI Version | 3.1.0 |
| Total Paths | 112 |
| Module Files | 15 |
| Total $ref Pointers | 163 |
| Shared Component Schemas | 9 |
| Security Schema Entries | 11 |
| Tags | 21 |

## Module Breakdown

| Module | Paths |
|--------|-------|
| Security | 18 |
| Committee | 30 |
| Communication | 9 |
| Documents | 8 |
| Safety | 8 |
| Reporting | 7 |
| Admin | 5 |
| Applications | 4 |
| Projects | 4 |
| Lookups | 4 |
| Workflow | 4 |
| Monitoring | 3 |
| System | 3 |
| Reference | 3 |
| Integration | 2 |

## Global Security

- `bearerAuth` (JWT) on all endpoints by default
- 7 public routes explicitly opt out with `security: []`
- `x-security-matrix` maps every route to required permissions

## Public Routes

| Method | Path |
|--------|------|
| POST | `/api/v1/security/auth/login` |
| POST | `/api/v1/security/auth/register` |
| POST | `/api/v1/security/auth/refresh` |
| GET | `/api/v1/health` |
| GET | `/api/v1/docs` (Swagger UI) |
| GET | `/api/v1/docs.json` |
| GET | `/api/v1/reference/institutions-registry` |

## Validation Status: ✅ PASS

- 112 path `$ref`s all resolve correctly
- 163 total `$ref` pointers across all files
- No broken references
- All shared schemas defined and referenced correctly
