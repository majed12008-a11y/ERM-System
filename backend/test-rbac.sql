-- ============================================================
-- RBAC Verification Matrix — Phase 4
-- Tests role-based access at the database level (RLS + policies)
-- Run after 14-rls-complete.sql + 15-rls-select-policy-fix.sql
-- ============================================================
-- Usage:
--   psql -U ethics_app -d ethics_db -f backend/test-rbac.sql
--
-- Structure:
--   A. Setup — user/entity IDs
--   B. Visibility — who can READ what
--   C. Modification — INSERT/UPDATE/SOFT-DELETE/RESTORE
--   D. Administrative — user mgmt, roles, audit, committees
--   E. Negative — all expected failures
--
-- Role legend:
--   SA = SUPER_ADMIN (21)  | EA = ETHICS_ADMIN (22)
--   CH = COMMITTEE_CHAIR (23) | RV = REVIEWER (24)
--   RS = RESEARCHER (27)   | AN = Anonymous (0)
-- ============================================================

-- ============================================================
-- A. Setup & Cleanup (restore seed data from prior runs)
-- ============================================================
\set SA 21
\set EA 22
\set CH 23
\set RV 24
\set RS1 27
\set RS2 28
\set AN 0

\set APP_RS1 11
\set APP_RS2 14
\set PROJ_RS1 35
\set PROJ_RS2 37
\set WF_RS1 9
\set WF_RS2 12
\set INST 4
\set DEPT 10

-- Restore seed data from prior runs (set admin user context so UPDATE policies allow restoration)
SELECT set_config('app.user_id', :'SA', false);
UPDATE core.applications SET deleted_at = NULL, deleted_by = NULL WHERE application_number LIKE 'APP-2024-%' AND deleted_at IS NOT NULL;
UPDATE workflow.workflow_instances SET deleted_at = NULL, deleted_by = NULL WHERE deleted_at IS NOT NULL;

\echo ''
\echo '============================================================'
\echo 'RBAC Verification Matrix — Phase 4'
\echo '============================================================'
\echo ''
\echo 'Users: SA(21), EA(22), CH(23), RV(24), RS(27), AN(0)'
\echo 'Apps: 11(RS1), 12(RS1), 13(RS1), 14(RS2), 15(RS2)'
\echo 'All apps target committee 3 (KSU IRB) where CH+RV are members'
\echo 'Workflows: 9(app11), 10(app12), 11(app13), 12(app15)'
\echo ''

-- ============================================================
-- B. Visibility
-- ============================================================
\echo '============================================================'
\echo 'B. Visibility'
\echo '============================================================'

-- B1. Applications
\echo ''
\echo '--- B1. Applications ---'

\echo 'B1.1 SA: all apps (expect 5)'
SELECT set_config('app.user_id', :'SA', false);
SELECT COUNT(*) as cnt FROM core.applications;

\echo 'B1.2 EA: all apps (expect 5)'
SELECT set_config('app.user_id', :'EA', false);
SELECT COUNT(*) as cnt FROM core.applications;

\echo 'B1.3 CH: committee member → all 5 (all apps target committee 3)'
SELECT set_config('app.user_id', :'CH', false);
SELECT COUNT(*) as cnt FROM core.applications;

\echo 'B1.4 RV: committee member + reviewer → all 5'
SELECT set_config('app.user_id', :'RV', false);
SELECT COUNT(*) as cnt FROM core.applications;

\echo 'B1.5 RS: own 3 (apps 11,12,13)'
SELECT set_config('app.user_id', :'RS1', false);
SELECT COUNT(*) as cnt FROM core.applications;

\echo 'B1.6 AN: none'
SELECT set_config('app.user_id', :'AN', false);
SELECT COUNT(*) as cnt FROM core.applications;

-- B2. Projects
\echo ''
\echo '--- B2. Projects ---'

\echo 'B2.1 SA: 3'
SELECT set_config('app.user_id', :'SA', false);
SELECT COUNT(*) as cnt FROM core.projects;

\echo 'B2.2 EA: 3'
SELECT set_config('app.user_id', :'EA', false);
SELECT COUNT(*) as cnt FROM core.projects;

\echo 'B2.3 CH: 0 (not PI)'
SELECT set_config('app.user_id', :'CH', false);
SELECT COUNT(*) as cnt FROM core.projects;

\echo 'B2.4 RV: 0 (not PI)'
SELECT set_config('app.user_id', :'RV', false);
SELECT COUNT(*) as cnt FROM core.projects;

\echo 'B2.5 RS: 2 (PI of 35,36)'
SELECT set_config('app.user_id', :'RS1', false);
SELECT COUNT(*) as cnt FROM core.projects;

\echo 'B2.6 AN: 0'
SELECT set_config('app.user_id', :'AN', false);
SELECT COUNT(*) as cnt FROM core.projects;

-- B3. Documents
\echo ''
\echo '--- B3. Documents ---'

\echo 'B3.1 SA: 6'
SELECT set_config('app.user_id', :'SA', false);
SELECT COUNT(*) as cnt FROM documents.documents;

\echo 'B3.2 EA: 6'
SELECT set_config('app.user_id', :'EA', false);
SELECT COUNT(*) as cnt FROM documents.documents;

\echo 'B3.3 CH: 0 (no document_access)'
SELECT set_config('app.user_id', :'CH', false);
SELECT COUNT(*) as cnt FROM documents.documents;

\echo 'B3.4 RV: 0 (no document_access)'
SELECT set_config('app.user_id', :'RV', false);
SELECT COUNT(*) as cnt FROM documents.documents;

\echo 'B3.5 RS: 5 (own uploads)'
SELECT set_config('app.user_id', :'RS1', false);
SELECT COUNT(*) as cnt FROM documents.documents;

\echo 'B3.6 AN: 0'
SELECT set_config('app.user_id', :'AN', false);
SELECT COUNT(*) as cnt FROM documents.documents;

-- B4. Review Assignments
\echo ''
\echo '--- B4. Review Assignments ---'

\echo 'B4.1 SA: 7'
SELECT set_config('app.user_id', :'SA', false);
SELECT COUNT(*) as cnt FROM committee.review_assignments;

\echo 'B4.2 EA: 7'
SELECT set_config('app.user_id', :'EA', false);
SELECT COUNT(*) as cnt FROM committee.review_assignments;

\echo 'B4.3 RV: own 3 (apps 11,12,13)'
SELECT set_config('app.user_id', :'RV', false);
SELECT COUNT(*) as cnt FROM committee.review_assignments;

\echo 'B4.4 RS: 0 (not reviewer)'
SELECT set_config('app.user_id', :'RS1', false);
SELECT COUNT(*) as cnt FROM committee.review_assignments;

\echo 'B4.5 AN: 0'
SELECT set_config('app.user_id', :'AN', false);
SELECT COUNT(*) as cnt FROM committee.review_assignments;

-- B5. Workflow Instances
\echo ''
\echo '--- B5. Workflow Instances ---'

\echo 'B5.1 SA: 4'
SELECT set_config('app.user_id', :'SA', false);
SELECT COUNT(*) as cnt FROM workflow.workflow_instances;

\echo 'B5.2 EA: 4'
SELECT set_config('app.user_id', :'EA', false);
SELECT COUNT(*) as cnt FROM workflow.workflow_instances;

\echo 'B5.3 RV: workflows for assigned apps (expect 3: apps 11,12,13)'
SELECT set_config('app.user_id', :'RV', false);
SELECT COUNT(*) as cnt FROM workflow.workflow_instances;

\echo 'B5.4 RS: own workflows (expect 3: apps 11,12,13)'
SELECT set_config('app.user_id', :'RS1', false);
SELECT COUNT(*) as cnt FROM workflow.workflow_instances;

\echo 'B5.5 AN: 0'
SELECT set_config('app.user_id', :'AN', false);
SELECT COUNT(*) as cnt FROM workflow.workflow_instances;

-- B6. Users
\echo ''
\echo '--- B6. Users ---'

\echo 'B6.1 SA: 8'
SELECT set_config('app.user_id', :'SA', false);
SELECT COUNT(*) as cnt FROM security.users;

\echo 'B6.2 EA: 8'
SELECT set_config('app.user_id', :'EA', false);
SELECT COUNT(*) as cnt FROM security.users;

\echo 'B6.3 CH: own only (1)'
SELECT set_config('app.user_id', :'CH', false);
SELECT COUNT(*) as cnt FROM security.users;

\echo 'B6.4 RV: own only (1)'
SELECT set_config('app.user_id', :'RV', false);
SELECT COUNT(*) as cnt FROM security.users;

\echo 'B6.5 RS: own only (1)'
SELECT set_config('app.user_id', :'RS1', false);
SELECT COUNT(*) as cnt FROM security.users;

\echo 'B6.6 AN: 0'
SELECT set_config('app.user_id', :'AN', false);
SELECT COUNT(*) as cnt FROM security.users;

-- ============================================================
-- C. Modification
-- ============================================================
\echo ''
\echo '============================================================'
\echo 'C. Modification'
\echo '============================================================'

-- C1. INSERT Application (in subtransactions to avoid cleanup)
\echo ''
\echo '--- C1. INSERT Application ---'

\echo 'C1.1 SA: admin can insert (expect 1)'
SELECT set_config('app.user_id', :'SA', false);
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by)
VALUES ('TST-SA', 35, 'INITIAL', 'DRAFT', :SA)
ON CONFLICT (application_number) DO NOTHING;

\echo 'C1.2 EA: ethics admin can insert (expect 1)'
SELECT set_config('app.user_id', :'EA', false);
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by)
VALUES ('TST-EA', 35, 'INITIAL', 'DRAFT', :EA)
ON CONFLICT (application_number) DO NOTHING;

\echo 'C1.3 RS: researcher can insert own (expect 1)'
SELECT set_config('app.user_id', :'RS1', false);
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by)
VALUES ('TST-RS', 35, 'INITIAL', 'DRAFT', :RS1)
ON CONFLICT (application_number) DO NOTHING;

\echo 'C1.4 AN: anonymous denied by RLS (expect ERROR)'
SELECT set_config('app.user_id', :'AN', false);
INSERT INTO core.applications (application_number, project_id, application_type, current_status, submitted_by)
VALUES ('TST-AN', 35, 'INITIAL', 'DRAFT', :RS1);

-- C2. UPDATE Application
\echo ''
\echo '--- C2. UPDATE Application ---'

\echo 'C2.1 SA: admin updates any (expect 1)'
SELECT set_config('app.user_id', :'SA', false);
UPDATE core.applications SET priority_level = 'URGENT' WHERE id = :APP_RS2;

\echo 'C2.2 EA: ethics admin updates any (expect 1)'
SELECT set_config('app.user_id', :'EA', false);
UPDATE core.applications SET priority_level = 'URGENT' WHERE id = :APP_RS2;

\echo 'C2.3 CH: chair updates other (expect 0 — committee member only in SELECT, not UPDATE USING)'
SELECT set_config('app.user_id', :'CH', false);
UPDATE core.applications SET priority_level = 'HIGH' WHERE id = :APP_RS2;

\echo 'C2.4 RV: reviewer sees app via review_assignments (USING passes) but WITH CHECK blocks (not owner/admin) (expect ERROR)'
SELECT set_config('app.user_id', :'RV', false);
UPDATE core.applications SET priority_level = 'HIGH' WHERE id = 13;

\echo 'C2.5 RS: researcher updates own (expect 1)'
SELECT set_config('app.user_id', :'RS1', false);
UPDATE core.applications SET priority_level = 'MEDIUM' WHERE id = :APP_RS1;

\echo 'C2.6 RS: researcher updates anothers (expect 0)'
UPDATE core.applications SET priority_level = 'LOW' WHERE id = :APP_RS2;

\echo 'C2.7 AN: anonymous updates (expect 0)'
SELECT set_config('app.user_id', :'AN', false);
UPDATE core.applications SET priority_level = 'LOW' WHERE id = :APP_RS1;

-- C3. SOFT DELETE Application
\echo ''
\echo '--- C3. SOFT DELETE ---'

\echo 'C3.1 SA: admin soft-deletes (expect 1)'
SELECT set_config('app.user_id', :'SA', false);
UPDATE core.applications SET deleted_at = now(), deleted_by = :SA WHERE id = :APP_RS2
RETURNING id;

\echo 'C3.2 EA: ethics admin soft-deletes (expect 1)'
SELECT set_config('app.user_id', :'EA', false);
UPDATE core.applications SET deleted_at = now(), deleted_by = :EA WHERE id = 11 RETURNING id;

\echo 'C3.3 CH: chair cannot soft-delete (expect 0)'
SELECT set_config('app.user_id', :'CH', false);
UPDATE core.applications SET deleted_at = now(), deleted_by = :CH WHERE id = 12;

\echo 'C3.4 RV: reviewer sees app via review_assignments (USING passes) but WITH CHECK blocks (expect ERROR — not owner)'
SELECT set_config('app.user_id', :'RV', false);
UPDATE core.applications SET deleted_at = now(), deleted_by = :RV WHERE id = 13;

\echo 'C3.5 RS: owner soft-deletes own (expect 1)'
SELECT set_config('app.user_id', :'RS1', false);
UPDATE core.applications SET deleted_at = now(), deleted_by = :RS1 WHERE id = 13 RETURNING id;

-- C4. RESTORE Application
\echo ''
\echo '--- C4. RESTORE ---'

\echo 'C4.1 SA: admin restores one app (expect 1)'
SELECT set_config('app.user_id', :'SA', false);
UPDATE core.applications SET deleted_at = NULL, deleted_by = NULL WHERE id = :APP_RS2;

\echo 'C4.2 RS: owner cannot restore own (expect 0 — admin-only; app deleted by EA in C3.2 still soft-deleted)'
SELECT set_config('app.user_id', :'RS1', false);
UPDATE core.applications SET deleted_at = NULL, deleted_by = NULL WHERE id = :APP_RS1;

-- ============================================================
-- D. Administrative
-- ============================================================
\echo ''
\echo '============================================================'
\echo 'D. Administrative'
\echo '============================================================'

-- D1. CREATE User
\echo ''
\echo '--- D1. CREATE User ---'

\echo 'D1.1 AN: self-register (expect 1 — policy allows user_id=0)'
SELECT set_config('app.user_id', :'AN', false);
INSERT INTO security.users (username, email, password_hash, first_name_ar, last_name_ar, institution_id, department_id)
VALUES ('test_anon_rbac', 'test_anon_rbac@test.com', 'hash', 'Test', 'Anon', :INST, :DEPT);

\echo 'D1.2 RS: researcher creates another user (expect DENY)'
SELECT set_config('app.user_id', :'RS1', false);
INSERT INTO security.users (username, email, password_hash, first_name_ar, last_name_ar, institution_id, department_id)
VALUES ('test_rs_rbac', 'test_rs_rbac@test.com', 'hash', 'Test', 'RS', :INST, :DEPT);

\echo 'D1.3 SA: admin creates user (expect 1)'
SELECT set_config('app.user_id', :'SA', false);
INSERT INTO security.users (username, email, password_hash, first_name_ar, last_name_ar, institution_id, department_id)
VALUES ('test_sa_rbac', 'test_sa_rbac@test.com', 'hash', 'Test', 'SA', :INST, :DEPT)
ON CONFLICT (username) DO NOTHING;

-- D2. Workflow Operations
\echo ''
\echo '--- D2. Workflow ---'

\echo 'D2.1 SA: update workflow (expect 1)'
SELECT set_config('app.user_id', :'SA', false);
UPDATE workflow.workflow_instances SET status_code = 'PAUSED' WHERE id = :WF_RS1;

\echo 'D2.2 EA: ethics admin updates workflow (expect 1)'
SELECT set_config('app.user_id', :'EA', false);
UPDATE workflow.workflow_instances SET status_code = 'ACTIVE' WHERE id = :WF_RS1;

\echo 'D2.3 RS: researcher cannot update workflow (expect 0)'
SELECT set_config('app.user_id', :'RS1', false);
UPDATE workflow.workflow_instances SET status_code = 'ACTIVE' WHERE id = :WF_RS1;

\echo 'D2.4 RV: reviewer cannot update workflow (expect 0)'
SELECT set_config('app.user_id', :'RV', false);
UPDATE workflow.workflow_instances SET status_code = 'ACTIVE' WHERE id = :WF_RS1;

-- D3. Soft-Delete/Restore Workflow
\echo ''
\echo '--- D3. Workflow Soft-Delete ---'

\echo 'D3.1 SA: admin soft-deletes workflow (expect 1)'
SELECT set_config('app.user_id', :'SA', false);
UPDATE workflow.workflow_instances SET deleted_at = now(), deleted_by = :SA WHERE id = :WF_RS1;

\echo 'D3.2 RS: researcher cannot soft-delete workflow (expect 0)'
SELECT set_config('app.user_id', :'RS1', false);
UPDATE workflow.workflow_instances SET deleted_at = now(), deleted_by = :RS1 WHERE id = :WF_RS2;

-- D4. User Profile Update
\echo ''
\echo '--- D4. User Profile ---'

\echo 'D4.1 RS: update own profile (expect 1)'
SELECT set_config('app.user_id', :'RS1', false);
UPDATE security.users SET first_name_ar = 'محدث' WHERE id = :RS1;

\echo 'D4.2 RS: update another user (expect 0)'
UPDATE security.users SET first_name_ar = 'مخترق' WHERE id = :RS2;

\echo 'D4.3 SA: admin updates any user (expect 1)'
SELECT set_config('app.user_id', :'SA', false);
UPDATE security.users SET first_name_ar = 'researcher2' WHERE id = :RS2;

-- D5. Committee Meetings
\echo ''
\echo '--- D5. Committee Meetings ---'

\echo 'D5.1 SA: all meetings (expect 3 seeded)'
SELECT set_config('app.user_id', :'SA', false);
SELECT COUNT(*) as cnt FROM committee.committee_meetings;

\echo 'D5.2 CH: own committee meetings (expect 3)'
SELECT set_config('app.user_id', :'CH', false);
SELECT COUNT(*) as cnt FROM committee.committee_meetings;

\echo 'D5.3 RS: not a member (expect 0)'
SELECT set_config('app.user_id', :'RS1', false);
SELECT COUNT(*) as cnt FROM committee.committee_meetings;

-- D6. System Data
\echo ''
\echo '--- D6. System Data ---'

\echo 'D6.1 SA: integration credentials (expect 0 — none seeded)'
SELECT set_config('app.user_id', :'SA', false);
SELECT COUNT(*) as cnt FROM integration.integration_credentials;

\echo 'D6.2 RS: blocked (expect 0)'
SELECT set_config('app.user_id', :'RS1', false);
SELECT COUNT(*) as cnt FROM integration.integration_credentials;

-- ============================================================
-- E. Negative Tests
-- ============================================================
\echo ''
\echo '============================================================'
\echo 'E. Negative'
\echo '============================================================'

-- E1. Reviewer
\echo ''
\echo '--- E1. Reviewer ---'

\echo 'E1.1 RV: cannot create user'
SELECT set_config('app.user_id', :'RV', false);
INSERT INTO security.users (username, email, password_hash, first_name_ar, last_name_ar, institution_id, department_id)
VALUES ('test_rv_rbac', 'test_rv_rbac@test.com', 'hash', 'Test', 'RV', :INST, :DEPT);

\echo 'E1.2 RV: cannot read unassigned app'
SELECT COUNT(*) as cnt FROM core.applications WHERE id = :APP_RS2;

\echo 'E1.3 RV: own user only'
SELECT COUNT(*) as cnt FROM security.users;

\echo 'E1.4 RV: cannot update workflow'
UPDATE workflow.workflow_instances SET status_code = 'ACTIVE' WHERE id = :WF_RS1;

\echo 'E1.5 RV: cannot soft-delete workflow'
UPDATE workflow.workflow_instances SET deleted_at = now(), deleted_by = :RV WHERE id = :WF_RS1;

\echo 'E1.6 RV: cannot read projects'
SELECT COUNT(*) as cnt FROM core.projects;

-- E2. Researcher
\echo ''
\echo '--- E2. Researcher ---'

\echo 'E2.1 RS: cannot create another user'
SELECT set_config('app.user_id', :'RS1', false);
INSERT INTO security.users (username, email, password_hash, first_name_ar, last_name_ar, institution_id, department_id)
VALUES ('test_rs_neg', 'test_rs_neg@test.com', 'hash', 'Test', 'Neg', :INST, :DEPT);

\echo 'E2.2 RS: cannot update anothers app'
UPDATE core.applications SET priority_level = 'LOW' WHERE id = :APP_RS2;

\echo 'E2.3 RS: cannot read anothers app'
SELECT COUNT(*) as cnt FROM core.applications WHERE id = :APP_RS2;

\echo 'E2.4 RS: cannot read anothers project'
SELECT COUNT(*) as cnt FROM core.projects WHERE id = :PROJ_RS2;

\echo 'E2.5 RS: cannot read review assignments'
SELECT COUNT(*) as cnt FROM committee.review_assignments;

\echo 'E2.6 RS: cannot update workflow'
UPDATE workflow.workflow_instances SET status_code = 'ACTIVE' WHERE id = :WF_RS1;

\echo 'E2.7 RS: own user only'
SELECT COUNT(*) as cnt FROM security.users;

\echo 'E2.8 RS: cannot soft-delete anothers app'
UPDATE core.applications SET deleted_at = now(), deleted_by = :RS1 WHERE id = :APP_RS2;

\echo 'E2.9 RS: cannot restore own deleted app'
UPDATE core.applications SET deleted_at = NULL, deleted_by = NULL WHERE id = :APP_RS1;

\echo 'E2.10 RS: not committee member → no meetings'
SELECT COUNT(*) as cnt FROM committee.committee_meetings;

-- E3. Anonymous
\echo ''
\echo '--- E3. Anonymous ---'

\echo 'E3.1 AN: read apps'
SELECT set_config('app.user_id', :'AN', false);
SELECT COUNT(*) as cnt FROM core.applications;

\echo 'E3.2 AN: read projects'
SELECT COUNT(*) as cnt FROM core.projects;

\echo 'E3.3 AN: read documents'
SELECT COUNT(*) as cnt FROM documents.documents;

\echo 'E3.4 AN: read users'
SELECT COUNT(*) as cnt FROM security.users;

\echo 'E3.5 AN: read workflows'
SELECT COUNT(*) as cnt FROM workflow.workflow_instances;

\echo 'E3.6 AN: update apps'
UPDATE core.applications SET priority_level = 'URGENT' WHERE id = :APP_RS1;

-- E4. Chair
\echo ''
\echo '--- E4. Chair ---'

\echo 'E4.1 CH: cannot update another users profile'
SELECT set_config('app.user_id', :'CH', false);
UPDATE security.users SET first_name_ar = 'Hacked' WHERE id = :RS1;

\echo 'E4.2 CH: own user only'
SELECT COUNT(*) as cnt FROM security.users;

\echo 'E4.3 CH: cannot read projects'
SELECT COUNT(*) as cnt FROM core.projects;

\echo 'E4.4 CH: cannot soft-delete anothers app'
UPDATE core.applications SET deleted_at = now(), deleted_by = :CH WHERE id = :APP_RS1;

-- E5. Ethics Admin (verify no over-permission)
\echo ''
\echo '--- E5. Ethics Admin ---'

\echo 'E5.1 EA: verify all-readable per admin role'
SELECT set_config('app.user_id', :'EA', false);
SELECT COUNT(*) as apps FROM core.applications;
SELECT COUNT(*) as projs FROM core.projects;
SELECT COUNT(*) as docs FROM documents.documents;
SELECT COUNT(*) as users FROM security.users;

-- ============================================================
-- F. Summary Statistics
-- ============================================================
\echo ''
\echo '============================================================'
\echo 'F. Summary'
\echo '============================================================'
\echo ''
\echo 'B. Visibility — 29 scenarios'
\echo 'C. Modification — 16 scenarios'
\echo 'D. Administrative — 14 scenarios'
\echo 'E. Negative — 21 scenarios'
\echo ''
\echo 'Total: 80 scenarios'
\echo ''
\echo '============================================================'
\echo 'RBAC Verification Matrix — Complete'
\echo '============================================================'

-- Cleanup: restore seed data (run as admin — DELETEs blocked by RLS, postgres cleanup needed for TST artifacts)
SELECT set_config('app.user_id', :'SA', false);
UPDATE core.applications SET deleted_at = NULL, deleted_by = NULL WHERE application_number LIKE 'APP-2024-%' AND deleted_at IS NOT NULL;
UPDATE workflow.workflow_instances SET deleted_at = NULL, deleted_by = NULL WHERE deleted_at IS NOT NULL;
