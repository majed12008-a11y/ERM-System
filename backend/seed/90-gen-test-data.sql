-- Performance Test Data Generator (v3 - correct FK references)
-- Run: psql -U postgres -d ethics_db -f backend/seed/90-gen-test-data.sql

BEGIN;

-- Save state and disable everything temporarily
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT event_object_schema, event_object_table
        FROM information_schema.triggers
        WHERE trigger_name LIKE 'trigger_audit%'
        GROUP BY event_object_schema, event_object_table
    LOOP
        EXECUTE format('ALTER TABLE %I.%I DISABLE TRIGGER ALL', rec.event_object_schema, rec.event_object_table);
    END LOOP;

    FOR rec IN
        SELECT schemaname, tablename FROM pg_tables WHERE rowsecurity
    LOOP
        EXECUTE format('ALTER TABLE %I.%I DISABLE ROW LEVEL SECURITY', rec.schemaname, rec.tablename);
    END LOOP;
END;
$$;

-- 1. Generate ~1000 users
INSERT INTO security.users (institution_id, department_id, username, email, password_hash, status, first_name_ar, last_name_ar, created_at)
SELECT
    (i % 22) + 1,
    CASE WHEN i % 3 = 0 THEN (i % 35) + 1 ELSE NULL END,
    'perf_user_' || i,
    'user' || i || '@perf.test',
    '$argon2id$v=19$m=65536,t=3,p=4$FakeHashForPerfTesting',
    CASE WHEN i % 10 = 0 THEN 'INACTIVE' ELSE 'ACTIVE' END,
    'مستخدم', 'اختبار',
    now() - (i || ' minutes')::interval
FROM generate_series(1, 1000) i
ON CONFLICT (username) DO NOTHING;

-- Build a contiguous user_id mapping (1..1012 -> actual user ids)
CREATE TEMP TABLE user_map AS
SELECT ROW_NUMBER() OVER (ORDER BY id) AS idx, id
FROM security.users;

-- 2. Generate 10k projects
INSERT INTO core.projects (institution_id, project_code, title_ar, principal_investigator_id, research_category, risk_level, status_code, created_at)
SELECT
    (i % 22) + 1,
    'PERF-PRJ-' || LPAD(i::text, 7, '0'),
    'مشروع اختبار أداء رقم ' || i,
    (SELECT id FROM user_map WHERE idx = (i % (SELECT count(*) FROM user_map)) + 1),
    CASE (i % 5)
        WHEN 0 THEN 'BIOMEDICAL' WHEN 1 THEN 'SOCIAL'
        WHEN 2 THEN 'BEHAVIORAL' WHEN 3 THEN 'EPIDEMIOLOGICAL'
        ELSE 'GENETIC'
    END,
    CASE (i % 4)
        WHEN 0 THEN 'MINIMAL' WHEN 1 THEN 'LOW'
        WHEN 2 THEN 'MODERATE' ELSE 'HIGH'
    END,
    CASE (i % 6)
        WHEN 0 THEN 'DRAFT' WHEN 1 THEN 'SUBMITTED' WHEN 2 THEN 'UNDER_REVIEW'
        WHEN 3 THEN 'APPROVED' WHEN 4 THEN 'ACTIVE' ELSE 'CLOSED'
    END,
    now() - (i || ' hours')::interval
FROM generate_series(1, 10000) i
ON CONFLICT (project_code) DO NOTHING;

-- 3. Generate 50k applications
INSERT INTO core.applications (application_number, project_id, submitted_by, application_type, current_status, target_committee_id, submission_date, created_at)
SELECT
    'PERF-APP-' || LPAD(i::text, 7, '0'),
    (i % 10000) + 1,
    (SELECT id FROM user_map WHERE idx = (i % (SELECT count(*) FROM user_map)) + 1),
    CASE (i % 4) WHEN 0 THEN 'INITIAL' WHEN 1 THEN 'AMENDMENT' WHEN 2 THEN 'RENEWAL' ELSE 'EXPEDITED' END,
    CASE (i % 7)
        WHEN 0 THEN 'DRAFT' WHEN 1 THEN 'SUBMITTED' WHEN 2 THEN 'UNDER_REVIEW'
        WHEN 3 THEN 'APPROVED' WHEN 4 THEN 'REJECTED' WHEN 5 THEN 'CONDITIONAL' ELSE 'WITHDRAWN'
    END,
    3 + (i % 2),
    now() - ((i % 1000) || ' hours')::interval,
    now() - ((i % 1000) || ' hours')::interval
FROM generate_series(1, 50000) i
ON CONFLICT (application_number) DO NOTHING;

-- 4. Generate 100k messages
INSERT INTO communication.messages (sender_id, subject, message_body, created_at)
SELECT
    (SELECT id FROM user_map WHERE idx = (i % (SELECT count(*) FROM user_map)) + 1),
    'Performance test message subject #' || i,
    'This is a performance test message body for testing #' || i,
    now() - ((i % 2000) || ' minutes')::interval
FROM generate_series(1, 100000) i;

-- 4b. Message recipients (avg 2 per message)
INSERT INTO communication.message_recipients (message_id, recipient_id, is_read, created_at)
SELECT
    m.id,
    (SELECT id FROM user_map WHERE idx = ((m.id + r.offst) % (SELECT count(*) FROM user_map)) + 1),
    m.id % 3 <> 0,
    m.created_at
FROM communication.messages m
CROSS JOIN (VALUES (0), (1)) AS r(offst)
WHERE m.id <= 100000;

-- 5. Generate 100k notifications
INSERT INTO communication.notifications (user_id, notification_type, subject, message_body, is_read, created_at)
SELECT
    (SELECT id FROM user_map WHERE idx = (i % (SELECT count(*) FROM user_map)) + 1),
    CASE (i % 5)
        WHEN 0 THEN 'APPLICATION_STATUS' WHEN 1 THEN 'REVIEW_ASSIGNMENT'
        WHEN 2 THEN 'MEETING_REMINDER' WHEN 3 THEN 'DOCUMENT_UPLOAD' ELSE 'SYSTEM_ALERT'
    END,
    'Notification subject #' || i,
    'Notification body for testing #' || i,
    i % 3 <> 0,
    now() - ((i % 500) || ' minutes')::interval
FROM generate_series(1, 100000) i;

-- 5b. Generate 10k adverse events
INSERT INTO safety.adverse_events (application_id, event_number, event_date, event_type, severity, expectedness, relatedness, description, outcome_status, reported_by, reported_at)
SELECT
    (i % 50000) + 1,
    'AE-PERF-' || LPAD(i::text, 6, '0'),
    current_date - ((i % 365) || ' days')::interval,
    CASE (i % 5) WHEN 0 THEN 'AE' WHEN 1 THEN 'SAE' WHEN 2 THEN 'SUSAR' WHEN 3 THEN 'DEATH' ELSE 'OTHER' END,
    CASE (i % 4) WHEN 0 THEN 'MILD' WHEN 1 THEN 'MODERATE' WHEN 2 THEN 'SEVERE' ELSE 'LIFE_THREATENING' END,
    CASE (i % 3) WHEN 0 THEN 'EXPECTED' WHEN 1 THEN 'UNEXPECTED' ELSE 'UNCLASSIFIED' END,
    CASE (i % 3) WHEN 0 THEN 'RELATED' WHEN 1 THEN 'POSSIBLY_RELATED' ELSE 'UNRELATED' END,
    'Performance test AE description #' || i,
    CASE (i % 4) WHEN 0 THEN 'RECOVERED' WHEN 1 THEN 'RECOVERING' WHEN 2 THEN 'NOT_RECOVERED' ELSE 'FATAL' END,
    (SELECT id FROM user_map WHERE idx = (i % (SELECT count(*) FROM user_map)) + 1),
    now() - ((i % 500) || ' minutes')::interval
FROM generate_series(1, 10000) i
ON CONFLICT (event_number) DO NOTHING;

-- 5c. Generate 10k corrective actions
INSERT INTO safety.corrective_actions (action_code, description, assigned_to, due_date, status, created_at)
SELECT
    'CA-PERF-' || LPAD(i::text, 6, '0'),
    'Performance test corrective action #' || i,
    (SELECT id FROM user_map WHERE idx = (i % (SELECT count(*) FROM user_map)) + 1),
    current_date + ((i % 90) || ' days')::interval,
    CASE (i % 4) WHEN 0 THEN 'OPEN' WHEN 1 THEN 'IN_PROGRESS' WHEN 2 THEN 'COMPLETED' ELSE 'VERIFIED' END,
    now() - ((i % 500) || ' minutes')::interval
FROM generate_series(1, 10000) i
ON CONFLICT (action_code) DO NOTHING;

-- 6. Generate 500k audit log entries
INSERT INTO audit.audit_logs (user_id, entity_name, entity_id, operation_type, event_timestamp)
SELECT
    (SELECT id FROM user_map WHERE idx = (i % (SELECT count(*) FROM user_map)) + 1),
    CASE (i % 10)
        WHEN 0 THEN 'core.applications' WHEN 1 THEN 'core.projects'
        WHEN 2 THEN 'security.users' WHEN 3 THEN 'communication.messages'
        WHEN 4 THEN 'communication.notifications' WHEN 5 THEN 'committee.ethics_reviews'
        WHEN 6 THEN 'documents.documents' WHEN 7 THEN 'safety.adverse_events'
        WHEN 8 THEN 'workflow_instances' ELSE 'committee_members'
    END,
    (i % 10000) + 1,
    CASE (i % 3) WHEN 0 THEN 'CREATE' WHEN 1 THEN 'UPDATE' ELSE 'DELETE' END,
    now() - ((i % 1000) || ' minutes')::interval
FROM generate_series(1, 500000) i;

-- Re-enable everything
DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT event_object_schema, event_object_table
        FROM information_schema.triggers
        WHERE trigger_name LIKE 'trigger_audit%'
        GROUP BY event_object_schema, event_object_table
    LOOP
        EXECUTE format('ALTER TABLE %I.%I ENABLE TRIGGER ALL', rec.event_object_schema, rec.event_object_table);
    END LOOP;

    FOR rec IN
        SELECT n.nspname AS schemaname, c.relname AS tablename
        FROM pg_class c
        JOIN pg_namespace n ON n.oid = c.relnamespace
        WHERE EXISTS (SELECT 1 FROM pg_policy p WHERE p.polrelid = c.oid)
          AND NOT c.relrowsecurity
    LOOP
        EXECUTE format('ALTER TABLE %I.%I ENABLE ROW LEVEL SECURITY', rec.schemaname, rec.tablename);
    END LOOP;
END;
$$;

COMMIT;

-- Report final counts
SELECT entity, cnt FROM (
    SELECT 'users' AS entity, count(*)::int AS cnt FROM security.users
    UNION ALL SELECT 'projects', count(*)::int FROM core.projects
    UNION ALL SELECT 'applications', count(*)::int FROM core.applications
    UNION ALL SELECT 'messages', count(*)::int FROM communication.messages
    UNION ALL SELECT 'msg_recipients', count(*)::int FROM communication.message_recipients
    UNION ALL SELECT 'notifications', count(*)::int FROM communication.notifications
    UNION ALL SELECT 'adverse_events', count(*)::int FROM safety.adverse_events
    UNION ALL SELECT 'corrective_actions', count(*)::int FROM safety.corrective_actions
    UNION ALL SELECT 'audit_logs', count(*)::int FROM audit.audit_logs
) sub ORDER BY entity;
