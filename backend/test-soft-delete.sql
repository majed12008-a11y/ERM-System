-- ============================================================
-- Soft Delete Enforcement Tests — Phase 3
-- Run after 14-rls-complete.sql and 15-rls-select-policy-fix.sql
-- ============================================================
-- Usage:
--   psql -U ethics_app -d ethics_db -f backend/test-soft-delete.sql
-- ============================================================
-- NOTE: After 15-rls-select-policy-fix:
--   - Admins see ALL rows (including soft-deleted)
--   - Row owners see own rows (including own soft-deleted)
--   - Others only see active rows they have access to
--   - is_active_row() is enforced only for non-owner, non-admin users
-- ============================================================

\set ADMIN_ID 21
\set RESEARCHER1_ID 27
\set RESEARCHER2_ID 28

-- ============================================================
-- 2.1: Soft-Deleted Row Visibility
-- ============================================================

\echo ''
\echo '=== Phase 3: Soft Delete Tests ==='
\echo ''

\echo '--- 2.1 Soft-Deleted Row Visibility ---'
\echo ''

-- 2.1.1: Admin can see soft-deleted rows
\echo '2.1.1 - Admin sees soft-deleted rows (expect rows)'
SELECT set_config('app.user_id', :'ADMIN_ID', false);

UPDATE core.applications
SET deleted_at = now(), deleted_by = :ADMIN_ID
WHERE id = (SELECT id FROM core.applications ORDER BY id LIMIT 1)
RETURNING id, deleted_at IS NOT NULL as is_deleted;

SELECT id, application_number
FROM core.applications
WHERE deleted_at IS NOT NULL;

-- 2.1.2: Non-owner user cannot see deleted rows
\echo '2.1.2 - Non-owner user sees soft-deleted app (expect 0 rows)'
SELECT set_config('app.user_id', :'RESEARCHER2_ID', false);

SELECT id, application_number
FROM core.applications
WHERE deleted_at IS NOT NULL;

-- 2.1.3: UPDATE on soft-deleted application (as admin — allowed)
\echo '2.1.3 - Admin UPDATE on soft-deleted app (expect 1 affected)'
SELECT set_config('app.user_id', :'ADMIN_ID', false);

UPDATE core.applications
SET current_status = 'ARCHIVED'
WHERE deleted_at IS NOT NULL;

-- 2.1.4: UPDATE on soft-deleted application (as non-owner — blocked by USING)
\echo '2.1.4 - Non-owner UPDATE on soft-deleted app (expect 0 affected)'
SELECT set_config('app.user_id', :'RESEARCHER2_ID', false);

UPDATE core.applications
SET current_status = 'HACKED'
WHERE deleted_at IS NOT NULL;

-- 2.1.5: Admin can restore soft-deleted row
\echo '2.1.5 - Admin restores soft-deleted app (expect 1 affected)'
SELECT set_config('app.user_id', :'ADMIN_ID', false);

UPDATE core.applications
SET deleted_at = NULL, deleted_by = NULL
WHERE deleted_at IS NOT NULL;

-- 2.1.6: Owner sees own soft-deleted row
\echo '2.1.6 - Owner sees own soft-deleted app (expect 1 row)'
SELECT set_config('app.user_id', :'RESEARCHER1_ID', false);

UPDATE core.applications
SET deleted_at = now(), deleted_by = :RESEARCHER1_ID
WHERE id = (SELECT id FROM core.applications WHERE submitted_by = :RESEARCHER1_ID ORDER BY id LIMIT 1)
RETURNING id;

SELECT id, application_number
FROM core.applications
WHERE submitted_by = :RESEARCHER1_ID AND deleted_at IS NOT NULL;

-- 2.1.7: Owner CANNOT un-delete own row (blocked by is_active_row in USING clause)
-- Only admins can un-delete rows. This is intentional: once soft-deleted,
-- the row must be restored by an admin.
\echo '2.1.7 - Owner restores own app (expect 0 affected — admin only)'
UPDATE core.applications
SET deleted_at = NULL, deleted_by = NULL
WHERE deleted_at IS NOT NULL AND submitted_by = :RESEARCHER1_ID;

-- ============================================================
-- 2.2: Soft Delete CHECK Constraint
-- ============================================================

\echo ''
\echo '--- 2.2 Soft Delete CHECK Constraint ---'
\echo ''

-- 2.2.1: Set deleted_at without deleted_by (should fail)
\echo '2.2.1 - Set deleted_at without deleted_by (expect constraint violation)'
SELECT set_config('app.user_id', :'ADMIN_ID', false);

UPDATE core.applications
SET deleted_at = now()
WHERE id = (SELECT id FROM core.applications WHERE deleted_at IS NULL ORDER BY id LIMIT 1);

-- 2.2.2: Set deleted_at with deleted_by (should succeed)
\echo '2.2.2 - Set deleted_at with deleted_by (expect 1 affected)'
UPDATE core.applications
SET deleted_at = now(), deleted_by = :ADMIN_ID
WHERE id = (SELECT id FROM core.applications WHERE deleted_at IS NULL ORDER BY id LIMIT 1);

-- Cleanup
UPDATE core.applications SET deleted_at = NULL, deleted_by = NULL WHERE deleted_at IS NOT NULL;

\echo ''
\echo '=== Phase 3 Complete ==='
\echo ''
