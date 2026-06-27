-- 17-rls-cud-policies.sql
-- Adds INSERT, UPDATE, DELETE policies for committee tables that only had SELECT policies.
-- Run: psql -U postgres -d ethics_db -f seed/17-rls-cud-policies.sql
-- سياسات RLS لعمليات INSERT/UPDATE/DELETE لجداول اللجان
-- التي كانت تملك سياسات SELECT فقط.

BEGIN;

-- ============================================================
-- committee.member_qualifications
-- ============================================================
DROP POLICY IF EXISTS member_qualifications_insert ON committee.member_qualifications;
CREATE POLICY member_qualifications_insert ON committee.member_qualifications
  FOR INSERT
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

DROP POLICY IF EXISTS member_qualifications_update ON committee.member_qualifications;
CREATE POLICY member_qualifications_update ON committee.member_qualifications
  FOR UPDATE
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  )
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

DROP POLICY IF EXISTS member_qualifications_delete ON committee.member_qualifications;
CREATE POLICY member_qualifications_delete ON committee.member_qualifications
  FOR DELETE
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- ============================================================
-- committee.member_terms
-- ============================================================
DROP POLICY IF EXISTS member_terms_insert ON committee.member_terms;
CREATE POLICY member_terms_insert ON committee.member_terms
  FOR INSERT
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

DROP POLICY IF EXISTS member_terms_update ON committee.member_terms;
CREATE POLICY member_terms_update ON committee.member_terms
  FOR UPDATE
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  )
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

DROP POLICY IF EXISTS member_terms_delete ON committee.member_terms;
CREATE POLICY member_terms_delete ON committee.member_terms
  FOR DELETE
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- ============================================================
-- committee.member_conflicts
-- Members can declare their own conflicts; admins can manage all.
-- ============================================================
DROP POLICY IF EXISTS member_conflicts_insert ON committee.member_conflicts;
CREATE POLICY member_conflicts_insert ON committee.member_conflicts
  FOR INSERT
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR member_id IN (
      SELECT cm.id FROM committee.committee_members cm
      WHERE cm.user_id = (current_setting('app.user_id', true))::bigint
    )
  );

DROP POLICY IF EXISTS member_conflicts_update ON committee.member_conflicts;
CREATE POLICY member_conflicts_update ON committee.member_conflicts
  FOR UPDATE
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR member_id IN (
      SELECT cm.id FROM committee.committee_members cm
      WHERE cm.user_id = (current_setting('app.user_id', true))::bigint
    )
  )
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR member_id IN (
      SELECT cm.id FROM committee.committee_members cm
      WHERE cm.user_id = (current_setting('app.user_id', true))::bigint
    )
  );

DROP POLICY IF EXISTS member_conflicts_delete ON committee.member_conflicts;
CREATE POLICY member_conflicts_delete ON committee.member_conflicts
  FOR DELETE
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
  );

-- ============================================================
-- Verify
-- ============================================================
DO $$
DECLARE
    v_total BIGINT;
BEGIN
    SELECT COUNT(*) INTO v_total
    FROM pg_policies
    WHERE schemaname = 'committee'
      AND cmd IN ('INSERT', 'UPDATE', 'DELETE');

    RAISE NOTICE 'Migration 17-rls-cud-policies complete:';
    RAISE NOTICE '  Total CUD policies in committee schema: %', v_total;
END $$;

COMMIT;
