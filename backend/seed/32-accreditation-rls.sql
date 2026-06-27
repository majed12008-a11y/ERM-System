SET app.user_id = '0';
BEGIN;

-- ============================================================
-- 32-ACCREDITATION-RLS.SQL
-- ============================================================
-- سياسات RLS لنظام الاعتماد المؤسسي. تحدد صلاحيات الوصول
-- لدورات وتقييمات وشروط وأدلة وقرارات الاعتماد.
-- P3 Committee Accreditation — Row-Level Security
-- Applied immediately after DDL, before any seed data
-- ============================================================

-- Helper: check if user has committee chair/admin role for a given committee
CREATE OR REPLACE FUNCTION committee.fn_is_committee_admin(p_user_id BIGINT, p_committee_id BIGINT)
RETURNS BOOLEAN LANGUAGE plpgsql STABLE AS $$
BEGIN
  RETURN EXISTS (
    SELECT 1 FROM committee.committee_members cm
    JOIN committee.committee_roles cr ON cr.id = cm.role_id
    WHERE cm.user_id = p_user_id
      AND cm.committee_id = p_committee_id
      AND cm.is_active = true
      AND cr.role_code IN ('CHAIR', 'SECRETARY', 'COORDINATOR')
  );
END;
$$;

-- SECURITY DEFINER helpers to break RLS recursion cycles between accreditation_cycles
-- and accreditation_assessments (each queries the other in their respective policies)

CREATE OR REPLACE FUNCTION committee.fn_is_assessor_for_cycle(p_user_id BIGINT, p_cycle_id BIGINT)
RETURNS BOOLEAN LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT EXISTS (
    SELECT 1 FROM committee.accreditation_assessments
    WHERE cycle_id = p_cycle_id AND assessed_by = p_user_id
  );
$$;

CREATE OR REPLACE FUNCTION committee.fn_get_cycle_committee_id(p_cycle_id BIGINT)
RETURNS BIGINT LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT committee_id FROM committee.accreditation_cycles WHERE id = p_cycle_id;
$$;

CREATE OR REPLACE FUNCTION committee.fn_cycle_created_by(p_cycle_id BIGINT)
RETURNS BIGINT LANGUAGE sql STABLE SECURITY DEFINER AS $$
  SELECT created_by FROM committee.accreditation_cycles WHERE id = p_cycle_id;
$$;

CREATE OR REPLACE FUNCTION committee.fn_is_admin_or_cycle_creator_or_committee_admin(p_user_id BIGINT, p_cycle_id BIGINT)
RETURNS BOOLEAN LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
DECLARE
  v_committee_id BIGINT;
  v_created_by BIGINT;
BEGIN
  IF system.fn_is_admin(p_user_id) THEN
    RETURN true;
  END IF;
  SELECT committee_id, created_by INTO v_committee_id, v_created_by
  FROM committee.accreditation_cycles WHERE id = p_cycle_id;
  IF v_created_by = p_user_id THEN
    RETURN true;
  END IF;
  IF committee.fn_is_committee_admin(p_user_id, v_committee_id) THEN
    RETURN true;
  END IF;
  RETURN false;
END;
$$;

CREATE OR REPLACE FUNCTION committee.fn_user_can_access_cycle(p_user_id BIGINT, p_cycle_id BIGINT)
RETURNS BOOLEAN LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
BEGIN
  IF system.fn_is_admin(p_user_id) THEN
    RETURN true;
  END IF;
  IF EXISTS (
    SELECT 1 FROM committee.accreditation_cycles
    WHERE id = p_cycle_id AND created_by = p_user_id
  ) THEN
    RETURN true;
  END IF;
  IF committee.fn_is_committee_admin(p_user_id, committee.fn_get_cycle_committee_id(p_cycle_id)) THEN
    RETURN true;
  END IF;
  IF committee.fn_is_assessor_for_cycle(p_user_id, p_cycle_id) THEN
    RETURN true;
  END IF;
  RETURN false;
END;
$$;

CREATE OR REPLACE FUNCTION committee.fn_user_can_access_assessment(p_user_id BIGINT, p_assessment_cycle_id BIGINT)
RETURNS BOOLEAN LANGUAGE plpgsql STABLE SECURITY DEFINER AS $$
BEGIN
  IF system.fn_is_admin(p_user_id) THEN
    RETURN true;
  END IF;
  IF committee.fn_is_committee_admin(p_user_id, committee.fn_get_cycle_committee_id(p_assessment_cycle_id)) THEN
    RETURN true;
  END IF;
  RETURN false;
END;
$$;

-- 1. accreditation_standards
ALTER TABLE committee.accreditation_standards ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS standards_select ON committee.accreditation_standards;
CREATE POLICY standards_select ON committee.accreditation_standards FOR SELECT
  USING (true);

DROP POLICY IF EXISTS standards_insert ON committee.accreditation_standards;
CREATE POLICY standards_insert ON committee.accreditation_standards FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS standards_update ON committee.accreditation_standards;
CREATE POLICY standards_update ON committee.accreditation_standards FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS standards_delete ON committee.accreditation_standards;
CREATE POLICY standards_delete ON committee.accreditation_standards FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- 2. accreditation_standard_versions
ALTER TABLE committee.accreditation_standard_versions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS stdver_select ON committee.accreditation_standard_versions;
CREATE POLICY stdver_select ON committee.accreditation_standard_versions FOR SELECT
  USING (true);

DROP POLICY IF EXISTS stdver_insert ON committee.accreditation_standard_versions;
CREATE POLICY stdver_insert ON committee.accreditation_standard_versions FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS stdver_update ON committee.accreditation_standard_versions;
CREATE POLICY stdver_update ON committee.accreditation_standard_versions FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS stdver_delete ON committee.accreditation_standard_versions;
CREATE POLICY stdver_delete ON committee.accreditation_standard_versions FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- 3. accreditation_cycles
ALTER TABLE committee.accreditation_cycles ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS cycles_select ON committee.accreditation_cycles;
CREATE POLICY cycles_select ON committee.accreditation_cycles FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR created_by = (current_setting('app.user_id', true))::bigint
    OR committee.fn_is_committee_admin((current_setting('app.user_id', true))::bigint, committee_id)
    OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id', true))::bigint, id)
  );

DROP POLICY IF EXISTS cycles_insert ON committee.accreditation_cycles;
CREATE POLICY cycles_insert ON committee.accreditation_cycles FOR INSERT
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR committee.fn_is_committee_admin((current_setting('app.user_id', true))::bigint, committee_id)
  );

DROP POLICY IF EXISTS cycles_update ON committee.accreditation_cycles;
CREATE POLICY cycles_update ON committee.accreditation_cycles FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS cycles_delete ON committee.accreditation_cycles;
CREATE POLICY cycles_delete ON committee.accreditation_cycles FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- 4. accreditation_evidence
ALTER TABLE committee.accreditation_evidence ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS evidence_select ON committee.accreditation_evidence;
CREATE POLICY evidence_select ON committee.accreditation_evidence FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR uploaded_by = (current_setting('app.user_id', true))::bigint
    OR committee.fn_is_committee_admin((current_setting('app.user_id', true))::bigint, committee.fn_get_cycle_committee_id(cycle_id))
    OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id', true))::bigint, cycle_id)
  );

DROP POLICY IF EXISTS evidence_insert ON committee.accreditation_evidence;
CREATE POLICY evidence_insert ON committee.accreditation_evidence FOR INSERT
  WITH CHECK (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR (
      (uploaded_by = (current_setting('app.user_id', true))::bigint)
      AND committee.fn_is_committee_admin((current_setting('app.user_id', true))::bigint, committee.fn_get_cycle_committee_id(cycle_id))
    )
  );

DROP POLICY IF EXISTS evidence_update ON committee.accreditation_evidence;
CREATE POLICY evidence_update ON committee.accreditation_evidence FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- 5. accreditation_assessments
ALTER TABLE committee.accreditation_assessments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS assessments_select ON committee.accreditation_assessments;
CREATE POLICY assessments_select ON committee.accreditation_assessments FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR assessed_by = (current_setting('app.user_id', true))::bigint
    OR (
      committee.fn_cycle_created_by(cycle_id) = (current_setting('app.user_id', true))::bigint
      OR committee.fn_is_committee_admin((current_setting('app.user_id', true))::bigint, committee.fn_get_cycle_committee_id(cycle_id))
    )
  );

DROP POLICY IF EXISTS assessments_insert ON committee.accreditation_assessments;
CREATE POLICY assessments_insert ON committee.accreditation_assessments FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS assessments_update ON committee.accreditation_assessments;
CREATE POLICY assessments_update ON committee.accreditation_assessments FOR UPDATE
  USING (assessed_by = (current_setting('app.user_id', true))::bigint)
  WITH CHECK (assessed_by = (current_setting('app.user_id', true))::bigint);

-- 6. accreditation_assessment_items
ALTER TABLE committee.accreditation_assessment_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS assessment_items_select ON committee.accreditation_assessment_items;
CREATE POLICY assessment_items_select ON committee.accreditation_assessment_items FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM committee.accreditation_assessments aa
      WHERE aa.id = accreditation_assessment_items.assessment_id
        AND (
          system.fn_is_admin((current_setting('app.user_id', true))::bigint)
          OR aa.assessed_by = (current_setting('app.user_id', true))::bigint
          OR committee.fn_is_admin_or_cycle_creator_or_committee_admin((current_setting('app.user_id', true))::bigint, aa.cycle_id)
        )
    )
  );

DROP POLICY IF EXISTS assessment_items_insert ON committee.accreditation_assessment_items;
CREATE POLICY assessment_items_insert ON committee.accreditation_assessment_items FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM committee.accreditation_assessments aa
      WHERE aa.id = accreditation_assessment_items.assessment_id
        AND aa.assessed_by = (current_setting('app.user_id', true))::bigint
    )
  );

DROP POLICY IF EXISTS assessment_items_update ON committee.accreditation_assessment_items;
CREATE POLICY assessment_items_update ON committee.accreditation_assessment_items FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM committee.accreditation_assessments aa
      WHERE aa.id = accreditation_assessment_items.assessment_id
        AND aa.assessed_by = (current_setting('app.user_id', true))::bigint
    )
  );

DROP POLICY IF EXISTS assessment_items_delete ON committee.accreditation_assessment_items;
CREATE POLICY assessment_items_delete ON committee.accreditation_assessment_items FOR DELETE
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR EXISTS (
      SELECT 1 FROM committee.accreditation_assessments aa
      WHERE aa.id = accreditation_assessment_items.assessment_id
        AND aa.assessed_by = (current_setting('app.user_id', true))::bigint
    )
  );

-- 7. accreditation_conditions
ALTER TABLE committee.accreditation_conditions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS conditions_select ON committee.accreditation_conditions;
CREATE POLICY conditions_select ON committee.accreditation_conditions FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR committee.fn_is_admin_or_cycle_creator_or_committee_admin((current_setting('app.user_id', true))::bigint, cycle_id)
    OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id', true))::bigint, cycle_id)
  );

DROP POLICY IF EXISTS conditions_insert ON committee.accreditation_conditions;
CREATE POLICY conditions_insert ON committee.accreditation_conditions FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS conditions_update ON committee.accreditation_conditions;
CREATE POLICY conditions_update ON committee.accreditation_conditions FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- 8. accreditation_decisions (append-only: INSERT only)
ALTER TABLE committee.accreditation_decisions ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS decisions_select ON committee.accreditation_decisions;
CREATE POLICY decisions_select ON committee.accreditation_decisions FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR committee.fn_is_admin_or_cycle_creator_or_committee_admin((current_setting('app.user_id', true))::bigint, cycle_id)
    OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id', true))::bigint, cycle_id)
  );

DROP POLICY IF EXISTS decisions_insert ON committee.accreditation_decisions;
CREATE POLICY decisions_insert ON committee.accreditation_decisions FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- 9. accreditation_cycle_metrics
ALTER TABLE committee.accreditation_cycle_metrics ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS metrics_select ON committee.accreditation_cycle_metrics;
CREATE POLICY metrics_select ON committee.accreditation_cycle_metrics FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR committee.fn_is_admin_or_cycle_creator_or_committee_admin((current_setting('app.user_id', true))::bigint, cycle_id)
    OR committee.fn_is_assessor_for_cycle((current_setting('app.user_id', true))::bigint, cycle_id)
  );

DROP POLICY IF EXISTS metrics_insert ON committee.accreditation_cycle_metrics;
CREATE POLICY metrics_insert ON committee.accreditation_cycle_metrics FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS metrics_update ON committee.accreditation_cycle_metrics;
CREATE POLICY metrics_update ON committee.accreditation_cycle_metrics FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

COMMIT;
