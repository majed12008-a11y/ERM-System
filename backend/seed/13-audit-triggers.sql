-- Audit triggers for all domain tables
-- Uses existing system.fn_log_audit() function
-- Run: psql -U postgres -d ethics_db -f backend/seed/13-audit-triggers.sql
-- مشغّلات تدقيق لجميع جداول النظام. تسجل تلقائياً عمليات
-- INSERT/UPDATE/DELETE في جدول audit_logs.

DO $$
DECLARE
    rec RECORD;
BEGIN
    FOR rec IN
        SELECT c.table_schema, c.table_name
        FROM information_schema.tables c
        WHERE c.table_type = 'BASE TABLE'
          AND c.table_schema NOT IN ('pg_catalog', 'information_schema', 'topology', 'audit', 'public')
          AND NOT EXISTS (
              SELECT 1 FROM information_schema.triggers t
              WHERE t.event_object_schema = c.table_schema
                AND t.event_object_table = c.table_name
                AND t.trigger_name LIKE 'trigger_audit%'
          )
          AND c.table_name NOT IN (
              'login_audit', 'sessions', 'password_history', 'security_events',
              'search_audit', 'search_indexes', 'audit_log', 'audit_config',
              'pgmigrations'
          )
        ORDER BY c.table_schema, c.table_name
    LOOP
        EXECUTE format(
            'DROP TRIGGER IF EXISTS trigger_audit_%I ON %I.%I;
             CREATE TRIGGER trigger_audit_%I
             AFTER INSERT OR UPDATE OR DELETE ON %I.%I
             FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();',
            rec.table_name, rec.table_schema, rec.table_name,
            rec.table_name, rec.table_schema, rec.table_name
        );
    END LOOP;
END;
$$;
