-- ============================================================
-- 25-RLS-MONITORING-REPORTING.SQL
-- RLS policies for monitoring.* and reporting.* schemas
-- Run AFTER: 24-prod-readiness-fixes.sql
-- ============================================================
-- سياسات RLS لجدول المراقبة والتقارير. دوال مساعدة:
-- fn_is_admin() بدون معاملات و fn_current_user_id().

BEGIN;

SET session_replication_role = replica;

-- ============================================================
-- Helper: no-arg overload of fn_is_admin using session setting
CREATE OR REPLACE FUNCTION system.fn_is_admin()
RETURNS boolean
LANGUAGE sql
STABLE SECURITY DEFINER
AS $$
  SELECT EXISTS (
    SELECT 1 FROM security.user_roles ur
    JOIN security.roles r ON ur.role_id = r.id
    WHERE ur.user_id = current_setting('app.user_id')::bigint
      AND r.code IN ('SUPER_ADMIN', 'SYS_ADMIN', 'ADMIN', 'ETHICS_ADMIN')
  );
$$;

-- Helper: fn_current_user_id returns the current user from session
CREATE OR REPLACE FUNCTION system.fn_current_user_id()
RETURNS bigint
LANGUAGE sql
STABLE SECURITY DEFINER
AS $$
  SELECT current_setting('app.user_id')::bigint;
$$;

-- ============================================================
-- MONITORING SCHEMA RLS
-- ============================================================

-- Enable RLS on all monitoring tables
DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'compliance_reviews', 'corrective_actions', 'deviations',
    'inspection_reports', 'inspections', 'monitoring_findings',
    'monitoring_plans', 'monitoring_visits', 'preventive_actions',
    'protocol_violations'
  ])
  LOOP
    EXECUTE format('ALTER TABLE monitoring.%I ENABLE ROW LEVEL SECURITY;', tbl);
  END LOOP;
END $$;

-- SELECT: admins see all; others see all (no institution_id on these tables)
DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'compliance_reviews', 'corrective_actions', 'deviations',
    'inspection_reports', 'inspections', 'monitoring_findings',
    'monitoring_plans', 'monitoring_visits', 'preventive_actions',
    'protocol_violations'
  ])
  LOOP
    EXECUTE format('
      DROP POLICY IF EXISTS %I ON monitoring.%I;
      CREATE POLICY %I ON monitoring.%I FOR SELECT
      USING (
        system.fn_is_admin()
        OR EXISTS (
          SELECT 1 FROM security.users u
          WHERE u.id = system.fn_current_user_id()
        )
      );
    ', concat(tbl, '_select_policy'), tbl,
       concat(tbl, '_select_policy'), tbl);
  END LOOP;
END $$;

-- INSERT/UPDATE/DELETE: only admins
DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'compliance_reviews', 'corrective_actions', 'deviations',
    'inspection_reports', 'inspections', 'monitoring_findings',
    'monitoring_plans', 'monitoring_visits', 'preventive_actions',
    'protocol_violations'
  ])
  LOOP
    EXECUTE format('
      DROP POLICY IF EXISTS %I ON monitoring.%I;
      CREATE POLICY %I ON monitoring.%I FOR INSERT
      WITH CHECK (system.fn_is_admin());
    ', concat(tbl, '_insert_policy'), tbl,
       concat(tbl, '_insert_policy'), tbl);

    EXECUTE format('
      DROP POLICY IF EXISTS %I ON monitoring.%I;
      CREATE POLICY %I ON monitoring.%I FOR UPDATE
      USING (system.fn_is_admin())
      WITH CHECK (system.fn_is_admin());
    ', concat(tbl, '_update_policy'), tbl,
       concat(tbl, '_update_policy'), tbl);

    EXECUTE format('
      DROP POLICY IF EXISTS %I ON monitoring.%I;
      CREATE POLICY %I ON monitoring.%I FOR DELETE
      USING (system.fn_is_admin());
    ', concat(tbl, '_delete_policy'), tbl,
       concat(tbl, '_delete_policy'), tbl);
  END LOOP;
END $$;

-- ============================================================
-- REPORTING SCHEMA RLS
-- ============================================================

DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'analytics_snapshots', 'dashboard_widgets', 'kpi_results',
    'report_definitions', 'report_executions'
  ])
  LOOP
    EXECUTE format('ALTER TABLE reporting.%I ENABLE ROW LEVEL SECURITY;', tbl);
  END LOOP;
END $$;

-- SELECT: admins see all; others see all (no institution_id on these tables)
DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'analytics_snapshots', 'dashboard_widgets', 'kpi_results',
    'report_definitions', 'report_executions'
  ])
  LOOP
    EXECUTE format('
      DROP POLICY IF EXISTS %I ON reporting.%I;
      CREATE POLICY %I ON reporting.%I FOR SELECT
      USING (
        system.fn_is_admin()
        OR EXISTS (
          SELECT 1 FROM security.users u
          WHERE u.id = system.fn_current_user_id()
        )
      );
    ', concat(tbl, '_select_policy'), tbl,
       concat(tbl, '_select_policy'), tbl);
  END LOOP;
END $$;

-- INSERT/UPDATE/DELETE: only admins
DO $$
DECLARE
  tbl text;
BEGIN
  FOR tbl IN SELECT unnest(ARRAY[
    'analytics_snapshots', 'dashboard_widgets', 'kpi_results',
    'report_definitions', 'report_executions'
  ])
  LOOP
    EXECUTE format('
      DROP POLICY IF EXISTS %I ON reporting.%I;
      CREATE POLICY %I ON reporting.%I FOR INSERT
      WITH CHECK (system.fn_is_admin());
    ', concat(tbl, '_insert_policy'), tbl,
       concat(tbl, '_insert_policy'), tbl);

    EXECUTE format('
      DROP POLICY IF EXISTS %I ON reporting.%I;
      CREATE POLICY %I ON reporting.%I FOR UPDATE
      USING (system.fn_is_admin())
      WITH CHECK (system.fn_is_admin());
    ', concat(tbl, '_update_policy'), tbl,
       concat(tbl, '_update_policy'), tbl);

    EXECUTE format('
      DROP POLICY IF EXISTS %I ON reporting.%I;
      CREATE POLICY %I ON reporting.%I FOR DELETE
      USING (system.fn_is_admin());
    ', concat(tbl, '_delete_policy'), tbl,
       concat(tbl, '_delete_policy'), tbl);
  END LOOP;
END $$;

SET session_replication_role = origin;

COMMIT;
