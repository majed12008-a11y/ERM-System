SET app.user_id = '0';
BEGIN;

-- ============================================================
-- 30-RLS-ETHICS-RISK.SQL
-- ============================================================
-- سياسات RLS لتقييم المخاطر الأخلاقية: الموافقات، التصنيفات،
-- التقييمات. يضمن عزل بيانات المخاطر بين المستخدمين.
-- Adds Row-Level Security for P2 ethics_risk_assessments + items
-- ============================================================

-- 1. Ethics Risk Assessments
ALTER TABLE committee.ethics_risk_assessments ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS ethics_risk_assessments_select ON committee.ethics_risk_assessments;
CREATE POLICY ethics_risk_assessments_select ON committee.ethics_risk_assessments FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR assessed_by = (current_setting('app.user_id', true))::bigint
    OR EXISTS (
      SELECT 1 FROM core.applications a
      WHERE a.id = ethics_risk_assessments.application_id
        AND (
          a.submitted_by = (current_setting('app.user_id', true))::bigint
          OR EXISTS (
            SELECT 1 FROM committee.review_assignments ra
            WHERE ra.application_id = a.id
              AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
          )
        )
    )
  );

DROP POLICY IF EXISTS ethics_risk_assessments_insert ON committee.ethics_risk_assessments;
CREATE POLICY ethics_risk_assessments_insert ON committee.ethics_risk_assessments FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS ethics_risk_assessments_update ON committee.ethics_risk_assessments;
CREATE POLICY ethics_risk_assessments_update ON committee.ethics_risk_assessments FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS ethics_risk_assessments_delete ON committee.ethics_risk_assessments;
CREATE POLICY ethics_risk_assessments_delete ON committee.ethics_risk_assessments FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

-- 2. Ethics Risk Items (child table, cascading from parent)
ALTER TABLE committee.ethics_risk_items ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS ethics_risk_items_select ON committee.ethics_risk_items;
CREATE POLICY ethics_risk_items_select ON committee.ethics_risk_items FOR SELECT
  USING (
    system.fn_is_admin((current_setting('app.user_id', true))::bigint)
    OR EXISTS (
      SELECT 1 FROM committee.ethics_risk_assessments era
      WHERE era.id = ethics_risk_items.assessment_id
        AND (era.assessed_by = (current_setting('app.user_id', true))::bigint
             OR EXISTS (
               SELECT 1 FROM core.applications a
               WHERE a.id = era.application_id
                 AND (
                   a.submitted_by = (current_setting('app.user_id', true))::bigint
                   OR EXISTS (
                     SELECT 1 FROM committee.review_assignments ra
                     WHERE ra.application_id = a.id
                       AND ra.reviewer_id = (current_setting('app.user_id', true))::bigint
                   )
                 )
             ))
    )
  );

DROP POLICY IF EXISTS ethics_risk_items_insert ON committee.ethics_risk_items;
CREATE POLICY ethics_risk_items_insert ON committee.ethics_risk_items FOR INSERT
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS ethics_risk_items_update ON committee.ethics_risk_items;
CREATE POLICY ethics_risk_items_update ON committee.ethics_risk_items FOR UPDATE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint))
  WITH CHECK (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

DROP POLICY IF EXISTS ethics_risk_items_delete ON committee.ethics_risk_items;
CREATE POLICY ethics_risk_items_delete ON committee.ethics_risk_items FOR DELETE
  USING (system.fn_is_admin((current_setting('app.user_id', true))::bigint));

COMMIT;
