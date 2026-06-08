-- ============================================================
-- RLS Isolation Tests — Direct SQL Level (Phase 2)
-- Run after 14-rls-complete.sql has been applied
-- ============================================================
-- Usage:
--   psql -U postgres -d ethics_db -f test-rls-isolation.sql
-- ============================================================

-- Configuration: replace these with actual user IDs from your database
-- (run: SELECT id, username FROM security.users)
\set ADMIN_ID 21
\set ETHICS_ADMIN_ID 22
\set RESEARCHER1_ID 27
\set RESEARCHER2_ID 28

\echo ''
\echo '=== Phase 2: RLS Isolation Tests ==='
\echo ''

-- ============================================================
-- 1. Cross-User Data Access
-- ============================================================

\echo '--- 1.1 Cross-User Data Access ---'

-- 1.1.1: Researcher reads another's application
SELECT set_config('app.user_id', :'RESEARCHER1_ID', false);

\echo '1.1.1 - Researcher1 tries to see Researcher2 applications (expect 0 rows)'
SELECT id, application_number, submitted_by
FROM core.applications
WHERE submitted_by = :RESEARCHER2_ID;

-- 1.1.2: Researcher updates another's application
\echo '1.1.2 - Researcher1 tries to update Researcher2 application (expect 0 affected)'
UPDATE core.applications
SET title_ar = 'Hacked'
WHERE submitted_by = :RESEARCHER2_ID;

-- 1.1.3: Researcher reads another's project
\echo '1.1.3 - Researcher1 tries to see Researcher2 projects (expect 0 rows)'
SELECT id, title_ar, principal_investigator_id
FROM core.projects
WHERE principal_investigator_id = :RESEARCHER2_ID;

-- 1.1.7: User reads another user's profile (own-only policy)
\echo '1.1.7 - Researcher1 tries to see Researcher2 profile (expect 0 rows)'
SELECT id, username, email
FROM security.users
WHERE id = :RESEARCHER2_ID;

-- 1.1.8: User reads another's risk entry
\echo '1.1.8 - Researcher1 tries to see Researcher2 risk (expect 0 rows)'
SELECT id, title_ar, owner_id
FROM safety.risk_register
WHERE owner_id = :RESEARCHER2_ID;

-- ============================================================
-- 2. Anonymous / Unauthenticated Access
-- ============================================================

\echo '--- 1.2 Anonymous Access ---'

SELECT set_config('app.user_id', '0', false);

-- 1.2.1: Anonymous reads applications
\echo '1.2.1 - Anonymous reads applications (expect 0 rows)'
SELECT count(*) as app_count FROM core.applications;

-- 1.2.3: Anonymous reads documents
\echo '1.2.3 - Anonymous reads documents (expect 0 rows)'
SELECT count(*) as doc_count FROM documents.documents;

-- 1.2.4: Anonymous reads projects
\echo '1.2.4 - Anonymous reads projects (expect 0 rows)'
SELECT count(*) as proj_count FROM core.projects;

-- ============================================================
-- 3. Admin Access
-- ============================================================

\echo '--- 1.3 Admin Access ---'

SELECT set_config('app.user_id', :'ADMIN_ID', false);

-- 1.3.1: Admin reads any application
\echo '1.3.1 - Admin reads applications (expect > 0 rows)'
SELECT count(*) as app_count FROM core.applications;

-- 1.3.3: Admin reads any document
\echo '1.3.3 - Admin reads documents (expect > 0 rows)'
SELECT count(*) as doc_count FROM documents.documents;

-- 1.3.4: Admin reads any review
\echo '1.3.4 - Admin reads reviews (expect > 0 rows)'
SELECT count(*) as review_count FROM committee.ethics_reviews;

-- 1.3.5: Admin reads integration credentials
\echo '1.3.5 - Admin reads integration credentials (expect > 0 rows)'
SELECT count(*) as cred_count FROM integration.integration_credentials;

-- 1.3.6: Admin reads saved searches
\echo '1.3.6 - Admin reads saved searches (expect 0+ rows)'
SELECT count(*) as search_count FROM system.saved_searches;

-- ============================================================
-- 4. Workflow Isolation Tests (NEW in 14-rls-complete)
-- ============================================================

\echo '--- 1.4 Workflow Isolation ---'

-- 1.4.1: Researcher reads workflow instance for own application
SELECT set_config('app.user_id', :'RESEARCHER1_ID', false);

\echo '1.4.1 - Researcher1 reads workflow for own app (expect > 0 rows)'
SELECT wi.id, wi.entity_type, wi.entity_id, wi.status_code
FROM workflow.workflow_instances wi
WHERE wi.entity_type = 'Application'
  AND wi.entity_id IN (
    SELECT id FROM core.applications WHERE submitted_by = :RESEARCHER1_ID
  );

-- 1.4.2: Researcher reads another's workflow instance (expect denied)
\echo '1.4.2 - Researcher1 reads another workflow instance (expect 0 rows)'
SELECT wi.id, wi.entity_type, wi.entity_id
FROM workflow.workflow_instances wi
WHERE wi.entity_type = 'Application'
  AND wi.entity_id IN (
    SELECT id FROM core.applications WHERE submitted_by = :RESEARCHER2_ID
  );

-- 1.4.3: Admin reads all workflow instances
SELECT set_config('app.user_id', :'ADMIN_ID', false);

\echo '1.4.3 - Admin reads all workflow instances (expect > 0 rows)'
SELECT count(*) as inst_count FROM workflow.workflow_instances;

\echo ''
\echo '=== Phase 2 Complete ==='
\echo ''
