-- ============================================================
-- 13-DATA-DICTIONARY
-- Document the 6 standard audit columns on all 80 transaction tables
-- ============================================================

DO $$
DECLARE
    rec RECORD;
    parts text[];
    cols text[] := ARRAY['created_at','created_by','updated_at','updated_by','deleted_at','deleted_by'];
    col_desc text[];
    i int;
BEGIN
    col_desc := ARRAY[
        'Timestamp when the record was created. Set automatically via DEFAULT now().',
        'User ID who created the record. NULL allowed for system-imported records.',
        'Timestamp when the record was last modified. Set by application layer.',
        'User ID who last modified the record. Set by application layer.',
        'Timestamp when the record was soft-deleted. NULL = active (not deleted).',
        'User ID who soft-deleted the record. Must be non-NULL if deleted_at is set.'
    ];

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
        parts := string_to_array(rec.tbl, '.');
        FOR i IN 1..6 LOOP
            EXECUTE format(
                'COMMENT ON COLUMN %I.%I.%I IS %L',
                parts[1], parts[2], cols[i], col_desc[i]
            );
        END LOOP;
    END LOOP;

    RAISE NOTICE 'Data dictionary: 480 COMMENTS added (80 tables x 6 columns)';
END $$;
