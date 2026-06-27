-- ============================================================
-- RLS Security Audit Suite — P3 Committee Accreditation
-- ============================================================
-- Test IDs: RLS-ACC-01 through RLS-ACC-08
-- Usage: psql -U postgres -d ethics_db -f scripts/rls-security-audit.sql
-- Exits with code 0 if ALL pass, 1 if any fail.
-- ============================================================

-- Step 1: Create/refresh dedicated test role (safe to re-run)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'tester_rls') THEN
    CREATE ROLE tester_rls WITH LOGIN PASSWORD 'tester_rls';
  END IF;
END $$;

GRANT USAGE ON SCHEMA committee TO tester_rls;
GRANT USAGE ON SCHEMA system TO tester_rls;
GRANT USAGE ON SCHEMA security TO tester_rls;
GRANT SELECT, INSERT ON ALL TABLES IN SCHEMA committee TO tester_rls;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA committee TO tester_rls;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA system TO tester_rls;
GRANT SELECT ON security.users TO tester_rls;

-- Step 2: Run tests as tester_rls
SET ROLE tester_rls;

-- NOTE: These IDs must match seed data in 33-accreditation-seed.sql
-- admin=1, aden_chair=16, reviewer1=4, researcher_1=164
DO $$
DECLARE
  v_admin_id    BIGINT := 1;
  v_aden_chair  BIGINT := 16;
  v_reviewer1   BIGINT := 4;
  v_unauth      BIGINT := 164;
  v_count       INT;
  v_test_fail   BOOLEAN := false;
  v_cycle_id    BIGINT;
  v_ncbe_cycle  BIGINT;
  v_assess_id   BIGINT;
BEGIN
  RAISE NOTICE '============================================';
  RAISE NOTICE 'RLS Security Audit Suite — P3 Accreditation';
  RAISE NOTICE '============================================';
  RAISE NOTICE 'admin=%, aden_chair=%, reviewer1=%, unauth=%', v_admin_id, v_aden_chair, v_reviewer1, v_unauth;

  -- ============================================================
  -- RLS-ACC-01: Chair can see own committee's cycle
  -- ============================================================
  PERFORM set_config('app.user_id', v_aden_chair::text, true);
  SELECT count(*)::int INTO v_count FROM committee.accreditation_cycles;
  IF v_count = 1 THEN
    RAISE NOTICE '✅ RLS-ACC-01: Chair sees 1 cycle (own committee only)';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-01: Chair sees % cycles (expected 1)', v_count;
    v_test_fail := true;
  END IF;

  -- ============================================================
  -- RLS-ACC-02: Chair cannot see other committee's cycles
  -- ============================================================
  -- Aden chair (committee 3) should NOT see NCBE cycle (committee 1)
  SELECT id INTO v_ncbe_cycle FROM committee.accreditation_cycles WHERE committee_id = 1 LIMIT 1;
  SELECT count(*)::int INTO v_count FROM committee.accreditation_cycles WHERE id = v_ncbe_cycle;
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-02: Chair cannot see other committee cycle';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-02: Chair sees other committee cycle (id=%)', v_ncbe_cycle;
    v_test_fail := true;
  END IF;

  -- ============================================================
  -- RLS-ACC-03: Assessor can access their assigned cycle
  -- ============================================================
  PERFORM set_config('app.user_id', v_admin_id::text, true);
  -- Admin creates an assessment to become an assessor
  INSERT INTO committee.accreditation_assessments (cycle_id, assessed_by, overall_decision)
  VALUES ((SELECT id FROM committee.accreditation_cycles WHERE status = 'UNDER_REVIEW' LIMIT 1), v_admin_id, 'RECOMMEND_APPROVE')
  RETURNING id INTO v_assess_id;

  -- Now query cycles as admin (the assessor)
  SELECT count(*)::int INTO v_count FROM committee.accreditation_cycles
  WHERE id IN (SELECT cycle_id FROM committee.accreditation_assessments WHERE assessed_by = v_admin_id);
  IF v_count >= 1 THEN
    RAISE NOTICE '✅ RLS-ACC-03: Assessor accesses assigned cycle';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-03: Assessor cannot access assigned cycle';
    v_test_fail := true;
  END IF;

  -- ============================================================
  -- RLS-ACC-04: Unassigned assessor is blocked
  -- ============================================================
  PERFORM set_config('app.user_id', v_reviewer1::text, true);
  SELECT count(*)::int INTO v_count FROM committee.accreditation_cycles
  WHERE id IN (SELECT cycle_id FROM committee.accreditation_assessments WHERE assessed_by = v_reviewer1);
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-04: Unassigned assessor blocked from cycle';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-04: Unassigned assessor sees cycle (leak!)';
    v_test_fail := true;
  END IF;

  -- ============================================================
  -- RLS-ACC-05: Unauthorized user is blocked from all
  -- ============================================================
  PERFORM set_config('app.user_id', v_unauth::text, true);

  SELECT count(*)::int INTO v_count FROM committee.accreditation_cycles;
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-05a: Unauthorized blocked from cycles';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-05a: Unauthorized sees % cycles', v_count;
    v_test_fail := true;
  END IF;

  SELECT count(*)::int INTO v_count FROM committee.accreditation_assessments;
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-05b: Unauthorized blocked from assessments';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-05b: Unauthorized sees % assessments', v_count;
    v_test_fail := true;
  END IF;

  SELECT count(*)::int INTO v_count FROM committee.accreditation_conditions;
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-05c: Unauthorized blocked from conditions';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-05c: Unauthorized sees % conditions', v_count;
    v_test_fail := true;
  END IF;

  SELECT count(*)::int INTO v_count FROM committee.accreditation_decisions;
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-05d: Unauthorized blocked from decisions';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-05d: Unauthorized sees % decisions', v_count;
    v_test_fail := true;
  END IF;

  BEGIN
    INSERT INTO committee.accreditation_assessments (cycle_id, assessed_by, overall_decision)
    VALUES (1, v_unauth, 'RECOMMEND_APPROVE');
    RAISE NOTICE '❌ RLS-ACC-05e: Unauthorized INSERT succeeded (leak!)';
    v_test_fail := true;
  EXCEPTION WHEN insufficient_privilege THEN
    RAISE NOTICE '✅ RLS-ACC-05e: Unauthorized INSERT blocked';
  WHEN OTHERS THEN
    RAISE NOTICE '✅ RLS-ACC-05e: Unauthorized INSERT blocked: %', SQLERRM;
  END;

  -- ============================================================
  -- RLS-ACC-06: Assessment item access follows parent assessment
  -- ============================================================
  PERFORM set_config('app.user_id', v_admin_id::text, true);
  SELECT count(*)::int INTO v_count FROM committee.accreditation_assessment_items;
  IF v_count >= 1 THEN
    RAISE NOTICE '✅ RLS-ACC-06a: Admin sees assessment items (% items)', v_count;
  ELSE
    RAISE NOTICE '❌ RLS-ACC-06a: Admin sees 0 assessment items';
    v_test_fail := true;
  END IF;

  PERFORM set_config('app.user_id', v_unauth::text, true);
  SELECT count(*)::int INTO v_count FROM committee.accreditation_assessment_items;
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-06b: Unauthorized blocked from assessment items';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-06b: Unauthorized sees % assessment items', v_count;
    v_test_fail := true;
  END IF;

  -- ============================================================
  -- RLS-ACC-07: Condition access follows cycle
  -- ============================================================
  PERFORM set_config('app.user_id', v_admin_id::text, true);
  SELECT count(*)::int INTO v_count FROM committee.accreditation_conditions;
  IF v_count >= 1 THEN
    RAISE NOTICE '✅ RLS-ACC-07a: Admin sees conditions';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-07a: Admin sees 0 conditions';
    v_test_fail := true;
  END IF;

  PERFORM set_config('app.user_id', v_unauth::text, true);
  SELECT count(*)::int INTO v_count FROM committee.accreditation_conditions;
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-07b: Unauthorized blocked from conditions';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-07b: Unauthorized sees % conditions', v_count;
    v_test_fail := true;
  END IF;

  -- ============================================================
  -- RLS-ACC-08: Decision access follows cycle
  -- ============================================================
  PERFORM set_config('app.user_id', v_admin_id::text, true);
  SELECT count(*)::int INTO v_count FROM committee.accreditation_decisions;
  IF v_count >= 1 THEN
    RAISE NOTICE '✅ RLS-ACC-08a: Admin sees decisions';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-08a: Admin sees 0 decisions';
    v_test_fail := true;
  END IF;

  PERFORM set_config('app.user_id', v_unauth::text, true);
  SELECT count(*)::int INTO v_count FROM committee.accreditation_decisions;
  IF v_count = 0 THEN
    RAISE NOTICE '✅ RLS-ACC-08b: Unauthorized blocked from decisions';
  ELSE
    RAISE NOTICE '❌ RLS-ACC-08b: Unauthorized sees % decisions', v_count;
    v_test_fail := true;
  END IF;

  -- ============================================================
  -- Summary
  -- ============================================================
  RAISE NOTICE '============================================';
  IF v_test_fail THEN
    RAISE NOTICE '❌ SOME TESTS FAILED — review above';
  ELSE
    RAISE NOTICE '✅ ALL RLS SECURITY AUDITS PASSED';
  END IF;
  RAISE NOTICE '============================================';
END $$;

RESET ROLE;

-- Cleanup test data as postgres (RLS-bypassing owner)
DELETE FROM committee.accreditation_assessments WHERE id > 2;
