-- ============================================================
-- 12-SOFT-DELETE
-- Adds unified audit columns + soft delete to 80 transaction tables
-- Excludes: history/log tables, audit tables, reference, junction, system
-- ============================================================
-- Migration Type: Additive (safe to run on production)
-- PostgreSQL 18.3 compatible
-- ============================================================

-- ============================================================
-- 1. Helper function for RLS policies
-- ============================================================

CREATE OR REPLACE FUNCTION system.is_active_row(
    p_deleted_at timestamptz
)
RETURNS boolean
LANGUAGE sql
IMMUTABLE
PARALLEL SAFE
AS $$
SELECT p_deleted_at IS NULL;
$$;

COMMENT ON FUNCTION system.is_active_row IS
  'Returns true if the row is not soft-deleted. Used in RLS policies.';

-- ============================================================
-- 2. Add audit columns to 80 transaction tables
--    Uses IF NOT EXISTS to handle tables that already have some columns
-- ============================================================

DO $$
DECLARE
    rec RECORD;
    col text;
    sql text;
BEGIN
    FOR rec IN (
        SELECT unnest(ARRAY[
            -- core (20)
            'core.applications','core.projects','core.project_team_members',
            'core.project_site_investigators','core.amendment_requests',
            'core.application_amendments','core.application_checklists',
            'core.application_sections','core.application_validations',
            'core.closure_requests','core.renewal_requests',
            'core.project_attachments','core.project_funding_sources',
            'core.project_keywords','core.project_sites','core.project_tags',
            'core.research_categories','core.research_population_links',
            'core.risk_classifications','core.vulnerable_populations',
            -- committee (22)
            'committee.committees','committee.committee_meetings',
            'committee.meeting_agendas','committee.agenda_items',
            'committee.meeting_minutes','committee.attendance_logs',
            'committee.ethics_reviews','committee.scientific_reviews',
            'committee.review_assignments','committee.review_forms',
            'committee.review_questions','committee.review_comments',
            'committee.review_scores','committee.review_recommendations',
            'committee.review_conflicts','committee.member_conflicts',
            'committee.member_terms','committee.member_qualifications',
            'committee.votes','committee.voting_sessions',
            'committee.quorum_logs',
            -- documents (7, excludes document_disposal_logs and document_audit)
            'documents.documents','documents.document_versions',
            'documents.document_access','documents.document_approvals',
            'documents.document_signatures','documents.generated_documents',
            'documents.templates',
            -- monitoring (9)
            'monitoring.monitoring_plans','monitoring.monitoring_visits',
            'monitoring.monitoring_findings','monitoring.inspections',
            'monitoring.inspection_reports','monitoring.compliance_reviews',
            'monitoring.deviations','monitoring.protocol_violations',
            'monitoring.preventive_actions',
            -- safety (11)
            'safety.adverse_events','safety.serious_adverse_events',
            'safety.risk_register','safety.risk_incidents',
            'safety.risk_assessments','safety.risk_mitigations',
            'safety.corrective_actions','safety.mitigation_actions',
            'safety.safety_reports','safety.safety_committee_reviews',
            'safety.safety_followups',
            -- communication (5)
            'communication.notifications','communication.messages',
            'communication.message_recipients','communication.message_attachments',
            'communication.announcements',
            -- integration (4)
            'integration.data_sync_jobs','integration.event_outbox',
            'integration.retry_queue','integration.webhooks',
            -- workflow (3)
            'workflow.workflows','workflow.workflow_instances',
            'workflow.workflow_tasks',
            -- security / system (3, missing from original list)
            'security.users','security.user_responsibilities',
            'system.saved_searches'
        ]) AS tbl
    ) LOOP
        -- Add created_at if missing
        sql := format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS created_at timestamptz NOT NULL DEFAULT now()',
                       rec.tbl);
        EXECUTE sql;

        -- Add created_by if missing
        sql := format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS created_by bigint', rec.tbl);
        EXECUTE sql;

        -- Add updated_at if missing
        sql := format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS updated_at timestamptz', rec.tbl);
        EXECUTE sql;

        -- Add updated_by if missing
        sql := format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS updated_by bigint', rec.tbl);
        EXECUTE sql;

        -- Add deleted_at if missing
        sql := format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS deleted_at timestamptz', rec.tbl);
        EXECUTE sql;

        -- Add deleted_by if missing
        sql := format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS deleted_by bigint', rec.tbl);
        EXECUTE sql;
    END LOOP;
END $$;

-- ============================================================
-- 3. CHECK constraint: if deleted_at is set, deleted_by must too
-- ============================================================

DO $$
DECLARE
    rec RECORD;
    constraint_name text;
    sql text;
BEGIN
    FOR rec IN (
        SELECT unnest(ARRAY[
            'core.applications','core.projects','core.project_team_members',
            'core.project_site_investigators','core.amendment_requests',
            'core.application_amendments','core.application_checklists',
            'core.application_sections','core.application_validations',
            'core.closure_requests','core.renewal_requests',
            'core.project_attachments','core.project_funding_sources',
            'core.project_keywords','core.project_sites','core.project_tags',
            'core.research_categories','core.research_population_links',
            'core.risk_classifications','core.vulnerable_populations',
            'committee.committees','committee.committee_meetings',
            'committee.meeting_agendas','committee.agenda_items',
            'committee.meeting_minutes','committee.attendance_logs',
            'committee.ethics_reviews','committee.scientific_reviews',
            'committee.review_assignments','committee.review_forms',
            'committee.review_questions','committee.review_comments',
            'committee.review_scores','committee.review_recommendations',
            'committee.review_conflicts','committee.member_conflicts',
            'committee.member_terms','committee.member_qualifications',
            'committee.votes','committee.voting_sessions',
            'committee.quorum_logs',
            'documents.documents','documents.document_versions',
            'documents.document_access','documents.document_approvals',
            'documents.document_signatures','documents.generated_documents',
            'documents.templates',
            'monitoring.monitoring_plans','monitoring.monitoring_visits',
            'monitoring.monitoring_findings','monitoring.inspections',
            'monitoring.inspection_reports','monitoring.compliance_reviews',
            'monitoring.deviations','monitoring.protocol_violations',
            'monitoring.preventive_actions',
            'safety.adverse_events','safety.serious_adverse_events',
            'safety.risk_register','safety.risk_incidents',
            'safety.risk_assessments','safety.risk_mitigations',
            'safety.corrective_actions','safety.mitigation_actions',
            'safety.safety_reports','safety.safety_committee_reviews',
            'safety.safety_followups',
            'communication.notifications','communication.messages',
            'communication.message_recipients','communication.message_attachments',
            'communication.announcements',
            'integration.data_sync_jobs','integration.event_outbox',
            'integration.retry_queue','integration.webhooks',
            'workflow.workflows','workflow.workflow_instances',
            'workflow.workflow_tasks'
        ]) AS tbl
    ) LOOP
        constraint_name := 'chk_' || replace(replace(rec.tbl, '.', '_'), '-', '_') || '_soft_delete';
        sql := format(
            'ALTER TABLE %s ADD CONSTRAINT %I CHECK (deleted_at IS NULL OR deleted_by IS NOT NULL)',
            rec.tbl, constraint_name
        );
        BEGIN
            EXECUTE sql;
        EXCEPTION WHEN duplicate_object THEN
            NULL;
        END;
    END LOOP;
END $$;

-- ============================================================
-- 4. Backfill: set created_at for existing rows where NULL
-- ============================================================

DO $$
DECLARE
    rec RECORD;
    sql text;
BEGIN
    FOR rec IN (
        SELECT unnest(ARRAY[
            'core.applications','core.projects','core.project_team_members',
            'core.project_site_investigators','core.amendment_requests',
            'core.application_amendments','core.application_checklists',
            'core.application_sections','core.application_validations',
            'core.closure_requests','core.renewal_requests',
            'core.project_attachments','core.project_funding_sources',
            'core.project_keywords','core.project_sites','core.project_tags',
            'core.research_categories','core.research_population_links',
            'core.risk_classifications','core.vulnerable_populations',
            'committee.committees','committee.committee_meetings',
            'committee.meeting_agendas','committee.agenda_items',
            'committee.meeting_minutes','committee.attendance_logs',
            'committee.ethics_reviews','committee.scientific_reviews',
            'committee.review_assignments','committee.review_forms',
            'committee.review_questions','committee.review_comments',
            'committee.review_scores','committee.review_recommendations',
            'committee.review_conflicts','committee.member_conflicts',
            'committee.member_terms','committee.member_qualifications',
            'committee.votes','committee.voting_sessions',
            'committee.quorum_logs',
            'documents.documents','documents.document_versions',
            'documents.document_access','documents.document_approvals',
            'documents.document_signatures','documents.generated_documents',
            'documents.templates',
            'monitoring.monitoring_plans','monitoring.monitoring_visits',
            'monitoring.monitoring_findings','monitoring.inspections',
            'monitoring.inspection_reports','monitoring.compliance_reviews',
            'monitoring.deviations','monitoring.protocol_violations',
            'monitoring.preventive_actions',
            'safety.adverse_events','safety.serious_adverse_events',
            'safety.risk_register','safety.risk_incidents',
            'safety.risk_assessments','safety.risk_mitigations',
            'safety.corrective_actions','safety.mitigation_actions',
            'safety.safety_reports','safety.safety_committee_reviews',
            'safety.safety_followups',
            'communication.notifications','communication.messages',
            'communication.message_recipients','communication.message_attachments',
            'communication.announcements',
            'integration.data_sync_jobs','integration.event_outbox',
            'integration.retry_queue','integration.webhooks',
            'workflow.workflows','workflow.workflow_instances',
            'workflow.workflow_tasks'
        ]) AS tbl
    ) LOOP
        -- Only backfill tables that existed before this migration
        sql := format('UPDATE %s SET created_at = now() WHERE created_at IS NULL', rec.tbl);
        EXECUTE sql;
    END LOOP;
END $$;

-- ============================================================
-- 5. Partial indexes on high-read tables
-- ============================================================

-- core
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_applications_active
    ON core.applications(id) WHERE deleted_at IS NULL;
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_projects_active
    ON core.projects(id) WHERE deleted_at IS NULL;

-- committee
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_committees_active
    ON committee.committees(id) WHERE deleted_at IS NULL;
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_ethics_reviews_active
    ON committee.ethics_reviews(id) WHERE deleted_at IS NULL;
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_scientific_reviews_active
    ON committee.scientific_reviews(id) WHERE deleted_at IS NULL;

-- workflow
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_workflow_instances_active
    ON workflow.workflow_instances(id) WHERE deleted_at IS NULL;
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_workflow_tasks_active
    ON workflow.workflow_tasks(id) WHERE deleted_at IS NULL;

-- documents
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_documents_active
    ON documents.documents(id) WHERE deleted_at IS NULL;

-- communication
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_notifications_active
    ON communication.notifications(id) WHERE deleted_at IS NULL;

-- safety
CREATE INDEX CONCURRENTLY IF NOT EXISTS idx_adverse_events_active
    ON safety.adverse_events(id) WHERE deleted_at IS NULL;

-- ============================================================
-- 6. Update RLS policies to include deleted_at IS NULL
--    Preserves existing business logic, adds active-row filter
-- ============================================================

-- 6a. core.applications
DROP POLICY IF EXISTS applications_select_policy ON core.applications;
CREATE POLICY applications_select_policy ON core.applications FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = submitted_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
        OR EXISTS (SELECT 1 FROM committee.review_assignments ra
                   WHERE ra.application_id = applications.id
                     AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint)
        OR EXISTS (SELECT 1 FROM committee.committee_members cm
                   JOIN committee.committees c ON cm.committee_id = c.id
                   WHERE cm.user_id = (current_setting('app.user_id', true))::bigint
                     AND c.id = applications.target_committee_id)
    ));

DROP POLICY IF EXISTS applications_update_policy ON core.applications;
CREATE POLICY applications_update_policy ON core.applications FOR UPDATE
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = submitted_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
        OR EXISTS (SELECT 1 FROM committee.review_assignments ra
                   WHERE ra.application_id = applications.id
                     AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint)
    ))
    WITH CHECK (
        (current_setting('app.user_id', true))::bigint = submitted_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    );

-- 6b. core.projects
DROP POLICY IF EXISTS projects_select_policy ON core.projects;
CREATE POLICY projects_select_policy ON core.projects FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = principal_investigator_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
        OR EXISTS (SELECT 1 FROM core.project_team_members ptm
                   WHERE ptm.project_id = projects.id
                     AND ptm.user_id = (current_setting('app.user_id', true))::bigint)
    ));

DROP POLICY IF EXISTS projects_update_policy ON core.projects;
CREATE POLICY projects_update_policy ON core.projects FOR UPDATE
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = principal_investigator_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ))
    WITH CHECK (
        (current_setting('app.user_id', true))::bigint = principal_investigator_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    );

-- 6c. documents.documents
DROP POLICY IF EXISTS documents_select_policy ON documents.documents;
CREATE POLICY documents_select_policy ON documents.documents FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = uploaded_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
        OR EXISTS (SELECT 1 FROM documents.document_access da
                   WHERE da.document_id = documents.id
                     AND (da.user_id = (current_setting('app.user_id', true))::bigint
                       OR da.role_id IN (SELECT ur.role_id FROM security.user_roles ur
                                          WHERE ur.user_id = (current_setting('app.user_id', true))::bigint)))
    ));

-- 6d. committee.committee_meetings (was a single SELECT policy)
DROP POLICY IF EXISTS committee_meetings_policy ON committee.committee_meetings;
CREATE POLICY committee_meetings_policy ON committee.committee_meetings FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        EXISTS (SELECT 1 FROM committee.committee_members cm
                WHERE cm.committee_id = committee_meetings.committee_id
                  AND cm.user_id = (current_setting('app.user_id', true))::bigint
                  AND cm.is_active = true)
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));

-- 6e. committee.ethics_reviews (was ALL policy - split into SELECT, INSERT, UPDATE)
DROP POLICY IF EXISTS ethics_reviews_policy ON committee.ethics_reviews;
CREATE POLICY ethics_reviews_select ON committee.ethics_reviews FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));
CREATE POLICY ethics_reviews_insert ON committee.ethics_reviews FOR INSERT
    WITH CHECK (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    );
CREATE POLICY ethics_reviews_update ON committee.ethics_reviews FOR UPDATE
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ))
    WITH CHECK (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    );

-- 6f. committee.scientific_reviews (was ALL policy)
DROP POLICY IF EXISTS scientific_reviews_policy ON committee.scientific_reviews;
CREATE POLICY scientific_reviews_select ON committee.scientific_reviews FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));
CREATE POLICY scientific_reviews_insert ON committee.scientific_reviews FOR INSERT
    WITH CHECK (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    );
CREATE POLICY scientific_reviews_update ON committee.scientific_reviews FOR UPDATE
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ))
    WITH CHECK (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    );

-- 6g. committee.review_assignments (was ALL policy)
DROP POLICY IF EXISTS review_assignments_policy ON committee.review_assignments;
CREATE POLICY review_assignments_select ON committee.review_assignments FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR (current_setting('app.user_id', true))::bigint = assigned_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));
CREATE POLICY review_assignments_insert ON committee.review_assignments FOR INSERT
    WITH CHECK (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR (current_setting('app.user_id', true))::bigint = assigned_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    );
CREATE POLICY review_assignments_update ON committee.review_assignments FOR UPDATE
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR (current_setting('app.user_id', true))::bigint = assigned_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ))
    WITH CHECK (
        (current_setting('app.user_id', true))::bigint = reviewer_id
        OR (current_setting('app.user_id', true))::bigint = assigned_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    );

-- 6h. remaining committee tables (SELECT-only policies)
DROP POLICY IF EXISTS member_conflicts_select ON committee.member_conflicts;
CREATE POLICY member_conflicts_select ON committee.member_conflicts FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        member_id IN (SELECT cm.id FROM committee.committee_members cm
                      WHERE cm.user_id = (current_setting('app.user_id', true))::bigint)
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));

DROP POLICY IF EXISTS member_qualifications_select ON committee.member_qualifications;
CREATE POLICY member_qualifications_select ON committee.member_qualifications FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        member_id IN (SELECT cm.id FROM committee.committee_members cm
                      WHERE cm.user_id = (current_setting('app.user_id', true))::bigint)
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));

DROP POLICY IF EXISTS member_terms_select ON committee.member_terms;
CREATE POLICY member_terms_select ON committee.member_terms FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        member_id IN (SELECT cm.id FROM committee.committee_members cm
                      WHERE cm.user_id = (current_setting('app.user_id', true))::bigint)
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));

-- 6i. safety tables (SELECT-only policies)
DROP POLICY IF EXISTS corrective_actions_select ON safety.corrective_actions;
CREATE POLICY corrective_actions_select ON safety.corrective_actions FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = assigned_to
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));

DROP POLICY IF EXISTS risk_incidents_select ON safety.risk_incidents;
CREATE POLICY risk_incidents_select ON safety.risk_incidents FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = reported_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));

DROP POLICY IF EXISTS risk_mitigations_select ON safety.risk_mitigations;
CREATE POLICY risk_mitigations_select ON safety.risk_mitigations FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = responsible_party
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));

DROP POLICY IF EXISTS risk_register_select ON safety.risk_register;
CREATE POLICY risk_register_select ON safety.risk_register FOR SELECT
    USING (system.is_active_row(deleted_at) AND (
        (current_setting('app.user_id', true))::bigint = owner_id
        OR (current_setting('app.user_id', true))::bigint = identified_by
        OR system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    ));

-- 6j. Drop DELETE policies on all transaction tables to prevent hard deletes
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN (
        SELECT schemaname, tablename, policyname
        FROM pg_policies
        WHERE cmd = 'DELETE'
          AND (schemaname, tablename) IN (
            ('core','applications'),('core','projects'),
            ('committee','committee_meetings'),('committee','ethics_reviews'),
            ('committee','scientific_reviews'),('committee','review_assignments'),
            ('documents','documents'),
            ('safety','corrective_actions'),('safety','risk_incidents'),
            ('safety','risk_mitigations'),('safety','risk_register')
          )
    ) LOOP
        EXECUTE format('DROP POLICY IF EXISTS %I ON %I.%I', rec.policyname, rec.schemaname, rec.tablename);
    END LOOP;
END $$;

-- ============================================================
-- 7. Update audit trigger to log soft deletes
--    (The existing fn_log_audit already handles UPDATE operations
--     via trigger_audit_users. For soft deletes via UPDATE, the
--     existing trigger on the target tables will log the change.)
-- ============================================================

-- ============================================================
-- 8. Verify migration
-- ============================================================

DO $$
DECLARE
    total_cols bigint;
    total_checks bigint;
    total_indexes bigint;
BEGIN
    SELECT COUNT(*) INTO total_cols
    FROM information_schema.columns
    WHERE (table_schema, table_name, column_name) IN (
        SELECT table_schema, table_name, 'deleted_at'
        FROM information_schema.tables
        WHERE table_type = 'BASE TABLE'
          AND table_schema NOT IN ('pg_catalog','information_schema')
    );

    SELECT COUNT(*) INTO total_checks
    FROM information_schema.check_constraints
    WHERE constraint_name LIKE 'chk_%_soft_delete';

    SELECT COUNT(*) INTO total_indexes
    FROM pg_indexes
    WHERE indexname LIKE 'idx_%_active';

    RAISE NOTICE 'Migration 12-soft-delete complete:';
    RAISE NOTICE '  Tables with deleted_at column: %', total_cols;
    RAISE NOTICE '  CHECK constraints added: %', total_checks;
    RAISE NOTICE '  Partial indexes created: %', total_indexes;
END $$;
