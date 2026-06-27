-- ============================================================
-- 24-PROD-READINESS-FIXES.SQL — Critical DB fixes for UAT
-- Run AFTER: 23-add-audit-columns.sql
-- ============================================================
-- إصلاحات الاستعداد للإنتاج: إضافة فهارس (indexes) لتحسين الأداء،
-- قيود (constraints)، وتصحيحات هيكلية استعداداً لاختبارات UAT.

BEGIN;

SET session_replication_role = replica;

-- ============================================================
-- FIX C4: Missing FK on core.applications.target_committee_id
-- ============================================================
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.table_constraints
    WHERE constraint_name = 'fk_applications_committee'
      AND table_schema = 'core' AND table_name = 'applications'
  ) THEN
    ALTER TABLE core.applications
      ADD CONSTRAINT fk_applications_committee
      FOREIGN KEY (target_committee_id) REFERENCES committee.committees(id);
    RAISE NOTICE 'FK fk_applications_committee added';
  ELSE
    RAISE NOTICE 'FK fk_applications_committee already exists';
  END IF;
END $$;

-- ============================================================
-- FIX H10: Missing FK indexes on critical columns
-- ============================================================

CREATE INDEX IF NOT EXISTS idx_applications_project ON core.applications(project_id);
CREATE INDEX IF NOT EXISTS idx_applications_submitted_by ON core.applications(submitted_by);
CREATE INDEX IF NOT EXISTS idx_applications_committee ON core.applications(target_committee_id);
CREATE INDEX IF NOT EXISTS idx_projects_institution ON core.projects(institution_id);
CREATE INDEX IF NOT EXISTS idx_projects_pi ON core.projects(principal_investigator_id);
CREATE INDEX IF NOT EXISTS idx_review_assignments_app ON committee.review_assignments(application_id);
CREATE INDEX IF NOT EXISTS idx_review_assignments_reviewer ON committee.review_assignments(reviewer_id);
CREATE INDEX IF NOT EXISTS idx_committee_members_user ON committee.committee_members(user_id);
CREATE INDEX IF NOT EXISTS idx_committee_members_committee ON committee.committee_members(committee_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON communication.notifications(user_id);
CREATE INDEX IF NOT EXISTS idx_message_recipients_recipient ON communication.message_recipients(recipient_id);
CREATE INDEX IF NOT EXISTS idx_messages_sender ON communication.messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_adverse_events_application ON safety.adverse_events(application_id);
CREATE INDEX IF NOT EXISTS idx_workflow_instances_entity ON workflow.workflow_instances(entity_type, entity_id);
CREATE INDEX IF NOT EXISTS idx_documents_entity ON documents.documents(entity_type, entity_id);

-- Composite indexes for common filtered+sort queries
CREATE INDEX IF NOT EXISTS idx_applications_submitted_by_created ON core.applications(submitted_by, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_notifications_user_created ON communication.notifications(user_id, created_at DESC);
CREATE INDEX IF NOT EXISTS idx_review_assignments_reviewer_assigned ON committee.review_assignments(reviewer_id, assigned_at DESC);
CREATE INDEX IF NOT EXISTS idx_message_recipients_recipient_created ON communication.message_recipients(recipient_id, created_at DESC);

-- ============================================================
-- FIX H10: Convert question_options to JSONB
-- ============================================================
DO $$
BEGIN
  IF EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_schema = 'committee' AND table_name = 'review_questions'
      AND column_name = 'question_options' AND data_type = 'text'
  ) THEN
    ALTER TABLE committee.review_questions
      ALTER COLUMN question_options TYPE JSONB USING question_options::JSONB;
    RAISE NOTICE 'question_options converted to JSONB';
  ELSE
    RAISE NOTICE 'question_options already JSONB or not found';
  END IF;
END $$;

SET session_replication_role = origin;

COMMIT;
