# P3 Phase 1 — Database Layer Completion Report

## Overview

Phase 1 of the Committee Accreditation module covers the complete database layer: schema, indexes, constraints, RLS policies, helper functions, and seed data.

## Statistics

| Metric | Count |
|---|---|
| Tables | 9 |
| Indexes | 29 |
| Constraints (CHECK) | 7 |
| Constraints (UNIQUE) | 4 |
| Constraints (PK) | 9 |
| Constraints (FK) | 13 |
| RLS Policies | 29 |
| Helper Functions | 7 (1 regular + 6 SECURITY DEFINER) |
| Seed Standards | 12 |
| Seed Standard Versions | 12 (2027 edition) |
| Seed Cycles | 3 |
| Seed Assessments | 2 |
| Seed Assessment Items | 12 |
| Seed Decisions | 8 |
| Seed Conditions | 2 |

## Table Structure

### 1. `accreditation_standards`
- PK: `id`
- UNIQUE: `code`
- Indexes: `category`, `sort_order`
- RLS: SELECT (public), INSERT/UPDATE/DELETE (admin)

### 2. `accreditation_standard_versions`
- PK: `id`
- UNIQUE: (`standard_id`, `version_label`)
- FK: `standard_id` → `accreditation_standards(id)`
- Partial index: `is_active WHERE true`
- RLS: SELECT (public), INSERT/UPDATE/DELETE (admin)

### 3. `accreditation_cycles`
- PK: `id`
- CHECK: `chk_cycle_status` (7 states: PENDING → REVOKED)
- CHECK: `chk_valid_dates` (valid_until > valid_from)
- FK: `committee_id` → `committees(id)`
- FK: `standard_version_id` → `accreditation_standard_versions(id)`
- Partial UNIQUE: `committee_id WHERE status NOT IN ('EXPIRED','REVOKED')`
- RLS: SELECT (admin/creator/committee_admin/assessor), INSERT (admin/committee_admin), UPDATE/DELETE (admin)

### 4. `accreditation_evidence`
- PK: `id`
- CHECK: `chk_evidence_status` (5 states: PENDING → EXPIRED)
- FK: `cycle_id` → `accreditation_cycles(id)`
- FK: `standard_version_id` → `accreditation_standard_versions(id)`
- FK: `document_id` → `documents.documents(id)`
- RLS: SELECT (admin/uploader/committee_admin/assessor), INSERT (uploader + committee_admin), UPDATE (admin)

### 5. `accreditation_assessments`
- PK: `id`
- CHECK: `chk_assessment_decision` (4 values)
- CHECK: `chk_assessment_score` (NULL or 1-100)
- FK: `cycle_id` → `accreditation_cycles(id)`
- FK: `assessed_by` → `security.users(id)`
- RLS: SELECT (admin/assessor/committee_admin/cycle_creator), INSERT (admin), UPDATE (assessor)

### 6. `accreditation_assessment_items`
- PK: `id`
- UNIQUE: (`assessment_id`, `standard_version_id`)
- CHECK: `chk_item_score` (NULL or 1-5)
- FK: `assessment_id` → `accreditation_assessments(id)`
- RLS: SELECT (follows parent assessment), INSERT/UPDATE (assessor)

### 7. `accreditation_conditions`
- PK: `id`
- CHECK: `chk_condition_status` (4 states: OPEN/MET/OVERDUE/WAIVED)
- FK: `cycle_id` → `accreditation_cycles(id)`
- Partial index: `status WHERE IN ('OPEN','OVERDUE')`
- RLS: SELECT (admin/committee_admin/cycle_creator/assessor), INSERT/UPDATE (admin)

### 8. `accreditation_decisions`
- PK: `id`
- CHECK: `chk_decision_status` (8 decision types)
- FK: `cycle_id` → `accreditation_cycles(id)`
- FK: `decided_by` → `security.users(id)`
- Index: `created_at DESC`
- RLS: SELECT (admin/committee_admin/cycle_creator/assessor), INSERT (admin)
- Note: Append-only; no UPDATE/DELETE allowed

### 9. `accreditation_cycle_metrics`
- PK: `id`
- UNIQUE: `cycle_id`
- FK: `cycle_id` → `accreditation_cycles(id)`
- RLS: SELECT (admin/committee_admin/cycle_creator/assessor), INSERT/UPDATE (admin)

## RLS Architecture

### Bug Fixes Applied
1. **`fn_is_committee_admin` JOIN fix**: Changed `committee_member_roles cmr ON cmr.id = cm.role_id` → `committee_roles cr ON cr.id = cm.role_id` with `cr.role_code`. The old join matched primary keys across unrelated tables.
2. **Mutual recursion eliminated**: `cycles_select` and `assessments_select` subqueried each other (through their respective policies), causing `infinite recursion detected` at runtime for non-owner users.

### SECURITY DEFINER Helpers (6 functions)
- `fn_is_assessor_for_cycle` — breaks recursion by bypassing RLS on assessments
- `fn_get_cycle_committee_id` — bypasses RLS on cycles for committee_id lookup
- `fn_cycle_created_by` — bypasses RLS on cycles for created_by lookup
- `fn_is_admin_or_cycle_creator_or_committee_admin` — composite check for items/conditions/decisions/metrics
- `fn_user_can_access_cycle` — composite check (reserved for future use)
- `fn_user_can_access_assessment` — composite check (reserved for future use)

### Policy Distribution (29 total)
- Standards: 4 (SELECT/INSERT/UPDATE/DELETE)
- Standard Versions: 4
- Cycles: 4
- Evidence: 3
- Assessments: 3
- Assessment Items: 3
- Conditions: 3
- Decisions: 2 (SELECT/INSERT only)
- Cycle Metrics: 3

### Access Patterns by Role
| Role | Cycles | Assessments | Evidence | Conditions | Decisions |
|---|---|---|---|---|---|
| Admin | ALL | ALL | ALL | ALL | ALL |
| Committee Chair | Own committee | Own committee | Own committee | Own committee | Own committee |
| Assessor | Assigned | Own | Own | Own | Own |
| Cycle Creator | Own | Own | — | Own | Own |
| Uploader | — | — | Own | — | — |
| Unauthorized | — | — | — | — | — |

## RLS Security Audit Suite

A permanent test suite is at `scripts/rls-security-audit.sql` with 15 test assertions across 8 test IDs (RLS-ACC-01 through RLS-ACC-08):
- RLS-ACC-01: Chair sees own committee cycle
- RLS-ACC-02: Chair cannot see other committee cycle
- RLS-ACC-03: Assessor accesses assigned cycle
- RLS-ACC-04: Unassigned assessor blocked
- RLS-ACC-05: Unauthorized user blocked from all tables
- RLS-ACC-06: Assessment item access follows parent assessment
- RLS-ACC-07: Condition access follows cycle
- RLS-ACC-08: Decision access follows cycle

Run with: `psql -U postgres -d ethics_db -f scripts/rls-security-audit.sql`

## Seed Data
- 12 standards spanning 4 categories (GOVERNANCE, ETHICS_REVIEW, SCIENTIFIC, COMPLIANCE)
- 12 standard versions (2027 edition, all active)
- 3 cycles: NCBE ACCREDITED, Aden UNDER_REVIEW, Sanaa CONDITIONAL
- 2 assessments (admin for Sanaa, sanaa_chair for Sanaa — both RECOMMEND_APPROVE)
- 12 assessment items across the 2 assessments
- 8 decisions covering the ACCREDITATION lifecycle
- 2 conditions on Sanaa's CONDITIONAL cycle

## Status

**P3 Phase 1 — Database Layer: COMPLETE ✅**

Next: P3 Phase 2 — Repositories + API Layer
