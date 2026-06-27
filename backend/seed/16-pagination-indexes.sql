-- ============================================================
-- 16-pagination-indexes.sql
-- Pagination performance indexes for ORDER BY + LIMIT/OFFSET
-- ينشئ فهارس Cover لدعم استعلامات التصفح بالترتيب الزمني
-- ============================================================

-- ============================================================
-- 1. core schema
-- ============================================================

-- core.applications: ORDER BY a.created_at DESC (قوائم الطلبات)
CREATE INDEX IF NOT EXISTS idx_applications_created_desc
    ON core.applications(created_at DESC);

-- core.projects: ORDER BY p.created_at DESC (قوائم المشاريع)
CREATE INDEX IF NOT EXISTS idx_projects_created_desc
    ON core.projects(created_at DESC);

-- ============================================================
-- 2. security schema
-- ============================================================

-- security.users: ORDER BY u.created_at DESC (قائمة المستخدمين)
CREATE INDEX IF NOT EXISTS idx_users_created_desc
    ON security.users(created_at DESC);

-- ============================================================
-- 3. documents schema
-- ============================================================

-- documents.documents: ORDER BY d.uploaded_at DESC (قائمة المستندات)
CREATE INDEX IF NOT EXISTS idx_documents_uploaded_desc
    ON documents.documents(uploaded_at DESC);

-- ============================================================
-- 4. communication schema
-- ============================================================

-- communication.messages: ORDER BY m.created_at DESC (البريد الوارد/الصادر)
CREATE INDEX IF NOT EXISTS idx_messages_created_desc
    ON communication.messages(created_at DESC);

-- communication.message_recipients: ORDER BY mr.created_at DESC (ترتيب البريد)
CREATE INDEX IF NOT EXISTS idx_message_recipients_created_desc
    ON communication.message_recipients(created_at DESC);

-- communication.notifications: ORDER BY created_at DESC LIMIT 50
CREATE INDEX IF NOT EXISTS idx_notifications_created_desc
    ON communication.notifications(created_at DESC);

-- ============================================================
-- 5. committee schema
-- ============================================================

-- committee.review_assignments: ORDER BY ra.assigned_at DESC
CREATE INDEX IF NOT EXISTS idx_review_assignments_assigned_desc
    ON committee.review_assignments(assigned_at DESC);

-- committee.member_terms: ORDER BY mt.start_date DESC
CREATE INDEX IF NOT EXISTS idx_member_terms_start_desc
    ON committee.member_terms(start_date DESC);

-- committee.committee_meetings: ORDER BY meeting_date DESC
CREATE INDEX IF NOT EXISTS idx_committee_meetings_date_desc
    ON committee.committee_meetings(meeting_date DESC);

-- ============================================================
-- 6. system schema
-- ============================================================

-- system.audit_log: ORDER BY al.created_at DESC (سجل التدقيق)
CREATE INDEX IF NOT EXISTS idx_audit_log_created_desc
    ON system.audit_log(created_at DESC);

-- ============================================================
-- 7. safety schema
-- ============================================================

-- safety.adverse_events: ORDER BY ae.created_at DESC
CREATE INDEX IF NOT EXISTS idx_adverse_events_created_desc
    ON safety.adverse_events(created_at DESC);

-- ============================================================
-- 8. integration schema
-- ============================================================

-- integration.event_outbox: ORDER BY created_at DESC LIMIT 100
CREATE INDEX IF NOT EXISTS idx_event_outbox_created_desc
    ON integration.event_outbox(created_at DESC);

-- integration.integration_logs: ORDER BY created_at DESC LIMIT 100
CREATE INDEX IF NOT EXISTS idx_integration_logs_created_desc
    ON integration.integration_logs(created_at DESC);
