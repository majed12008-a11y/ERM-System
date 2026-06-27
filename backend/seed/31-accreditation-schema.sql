SET app.user_id = '0';
BEGIN;

-- ============================================================
-- 31-ACCREDITATION-SCHEMA.SQL
-- ============================================================
-- هيكل نظام الاعتماد المؤسسي للجنة الأخلاقيات:
-- الدورات، التقييمات، الشروط، الأدلة، القرارات.
-- P3 Committee Accreditation — Database Schema
-- Design v1.0 Approved
-- ============================================================

-- 1. STANDARDS MASTER LIST
CREATE TABLE IF NOT EXISTS committee.accreditation_standards (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  code        VARCHAR(100) NOT NULL,
  name_ar     VARCHAR(300) NOT NULL,
  name_en     VARCHAR(300) NOT NULL,
  description_ar TEXT,
  description_en TEXT,
  category    VARCHAR(50) NOT NULL DEFAULT 'DOCUMENT',
  sort_order  INT NOT NULL DEFAULT 0,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ
);

ALTER TABLE committee.accreditation_standards ADD CONSTRAINT uq_standards_code UNIQUE (code);
CREATE INDEX idx_standards_category ON committee.accreditation_standards(category);
CREATE INDEX idx_standards_sort ON committee.accreditation_standards(sort_order);

-- 2. STANDARD VERSIONS (per published edition)
CREATE TABLE IF NOT EXISTS committee.accreditation_standard_versions (
  id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  standard_id     BIGINT NOT NULL REFERENCES committee.accreditation_standards(id),
  version_label   VARCHAR(50) NOT NULL,
  is_mandatory    BOOLEAN NOT NULL DEFAULT true,
  is_active       BOOLEAN NOT NULL DEFAULT true,
  effective_from  DATE NOT NULL,
  effective_until DATE,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE committee.accreditation_standard_versions
  ADD CONSTRAINT uq_standard_version UNIQUE (standard_id, version_label);
CREATE INDEX idx_stdver_active ON committee.accreditation_standard_versions(is_active) WHERE is_active = true;

-- 3. ACCREDITATION CYCLES (core entity)
CREATE TABLE IF NOT EXISTS committee.accreditation_cycles (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  committee_id        BIGINT NOT NULL REFERENCES committee.committees(id),
  standard_version_id BIGINT NOT NULL REFERENCES committee.accreditation_standard_versions(id),
  cycle_number        INT NOT NULL,
  status              VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  valid_from          TIMESTAMPTZ,
  valid_until         TIMESTAMPTZ,
  notes               TEXT,
  decided_by          BIGINT REFERENCES security.users(id),
  decided_at          TIMESTAMPTZ,
  created_by          BIGINT NOT NULL REFERENCES security.users(id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ,
  deleted_at          TIMESTAMPTZ
);

CREATE UNIQUE INDEX uq_active_cycle_per_committee ON committee.accreditation_cycles(committee_id)
  WHERE status NOT IN ('EXPIRED', 'REVOKED');
ALTER TABLE committee.accreditation_cycles
  ADD CONSTRAINT chk_valid_dates CHECK (valid_until IS NULL OR valid_from IS NULL OR valid_until > valid_from);
ALTER TABLE committee.accreditation_cycles
  ADD CONSTRAINT chk_cycle_status CHECK (status IN ('PENDING','UNDER_REVIEW','ACCREDITED','CONDITIONAL','SUSPENDED','EXPIRED','REVOKED'));
CREATE INDEX idx_cycles_committee ON committee.accreditation_cycles(committee_id);
CREATE INDEX idx_cycles_status ON committee.accreditation_cycles(status);
CREATE INDEX idx_cycles_expiry ON committee.accreditation_cycles(valid_until) WHERE status = 'ACCREDITED';

-- 4. EVIDENCE (documents submitted by committee)
CREATE TABLE IF NOT EXISTS committee.accreditation_evidence (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cycle_id            BIGINT NOT NULL REFERENCES committee.accreditation_cycles(id),
  standard_version_id BIGINT NOT NULL REFERENCES committee.accreditation_standard_versions(id),
  document_id         BIGINT REFERENCES documents.documents(id),
  status              VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  notes               TEXT,
  uploaded_by         BIGINT NOT NULL REFERENCES security.users(id),
  uploaded_at         TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE committee.accreditation_evidence
  ADD CONSTRAINT chk_evidence_status CHECK (status IN ('PENDING','SUBMITTED','ACCEPTED','REJECTED','EXPIRED'));
CREATE INDEX idx_evidence_cycle ON committee.accreditation_evidence(cycle_id);
CREATE INDEX idx_evidence_status ON committee.accreditation_evidence(status);

-- 5. ASSESSMENTS (one per NCBE assessor per cycle)
CREATE TABLE IF NOT EXISTS committee.accreditation_assessments (
  id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cycle_id           BIGINT NOT NULL REFERENCES committee.accreditation_cycles(id),
  assessed_by        BIGINT NOT NULL REFERENCES security.users(id),
  overall_decision   VARCHAR(30) NOT NULL DEFAULT 'DEFER',
  overall_justification TEXT,
  overall_score      INT,
  assessed_at        TIMESTAMPTZ,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at         TIMESTAMPTZ
);

ALTER TABLE committee.accreditation_assessments
  ADD CONSTRAINT chk_assessment_decision CHECK (overall_decision IN ('RECOMMEND_APPROVE','RECOMMEND_CONDITIONAL','RECOMMEND_REJECT','DEFER'));
ALTER TABLE committee.accreditation_assessments
  ADD CONSTRAINT chk_assessment_score CHECK (overall_score IS NULL OR (overall_score >= 1 AND overall_score <= 100));
CREATE INDEX idx_assessments_cycle ON committee.accreditation_assessments(cycle_id);
CREATE INDEX idx_assessments_assessor ON committee.accreditation_assessments(assessed_by);

-- 6. ASSESSMENT ITEMS (per-standard evaluation within an assessment)
CREATE TABLE IF NOT EXISTS committee.accreditation_assessment_items (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  assessment_id       BIGINT NOT NULL REFERENCES committee.accreditation_assessments(id),
  standard_version_id BIGINT NOT NULL REFERENCES committee.accreditation_standard_versions(id),
  is_met              BOOLEAN NOT NULL DEFAULT false,
  findings            TEXT,
  score               INT
);

ALTER TABLE committee.accreditation_assessment_items
  ADD CONSTRAINT chk_item_score CHECK (score IS NULL OR (score >= 1 AND score <= 5));
ALTER TABLE committee.accreditation_assessment_items
  ADD CONSTRAINT uq_assessment_item UNIQUE (assessment_id, standard_version_id);
CREATE INDEX idx_assessment_items_assessment ON committee.accreditation_assessment_items(assessment_id);

-- 7. CONDITIONS (for CONDITIONAL status)
CREATE TABLE IF NOT EXISTS committee.accreditation_conditions (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cycle_id            BIGINT NOT NULL REFERENCES committee.accreditation_cycles(id),
  condition_text      TEXT NOT NULL,
  due_date            TIMESTAMPTZ NOT NULL,
  status              VARCHAR(30) NOT NULL DEFAULT 'OPEN',
  severity            VARCHAR(10) NOT NULL DEFAULT 'MAJOR',
  assessment_id       BIGINT REFERENCES committee.accreditation_assessments(id),
  assessment_item_id  BIGINT REFERENCES committee.accreditation_assessment_items(id),
  standard_version_id BIGINT REFERENCES committee.accreditation_standard_versions(id),
  resolved_at         TIMESTAMPTZ,
  resolved_by         BIGINT REFERENCES security.users(id),
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE committee.accreditation_conditions
  ADD CONSTRAINT chk_condition_status CHECK (status IN ('OPEN','MET','OVERDUE','WAIVED'));
ALTER TABLE committee.accreditation_conditions
  ADD CONSTRAINT chk_condition_severity CHECK (severity IN ('MINOR','MAJOR','CRITICAL'));
CREATE INDEX idx_conditions_cycle ON committee.accreditation_conditions(cycle_id);
CREATE INDEX idx_conditions_status ON committee.accreditation_conditions(status) WHERE status IN ('OPEN','OVERDUE');
CREATE INDEX idx_conditions_assessment ON committee.accreditation_conditions(assessment_id);
CREATE INDEX idx_conditions_standard ON committee.accreditation_conditions(standard_version_id);

-- 8. DECISIONS (immutable audit trail)
CREATE TABLE IF NOT EXISTS committee.accreditation_decisions (
  id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cycle_id    BIGINT NOT NULL REFERENCES committee.accreditation_cycles(id),
  from_status VARCHAR(30),
  to_status   VARCHAR(30) NOT NULL,
  decision    VARCHAR(30) NOT NULL,
  decided_by  BIGINT NOT NULL REFERENCES security.users(id),
  decision_reason TEXT,
  notes       TEXT,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

ALTER TABLE committee.accreditation_decisions
  ADD CONSTRAINT chk_decision_status CHECK (decision IN ('APPLY','SUBMIT','APPROVE','CONDITIONAL','SUSPEND','REVOKE','EXPIRE','RESUME'));
CREATE INDEX idx_decisions_cycle ON committee.accreditation_decisions(cycle_id);
CREATE INDEX idx_decisions_created ON committee.accreditation_decisions(created_at DESC);

-- 9. CYCLE METRICS (optional capacity data)
CREATE TABLE IF NOT EXISTS committee.accreditation_cycle_metrics (
  id                            BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  cycle_id                      BIGINT NOT NULL UNIQUE REFERENCES committee.accreditation_cycles(id),
  meetings_last_12_months       INT,
  protocols_reviewed_last_12_months INT,
  average_review_days           NUMERIC(5,1),
  quorum_percentage             NUMERIC(5,1),
  members_count                 INT,
  updated_at                    TIMESTAMPTZ
);

-- Grant access
GRANT USAGE ON SCHEMA committee TO ethics_app, ethics_owner;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA committee TO ethics_app, ethics_owner;
GRANT USAGE ON ALL SEQUENCES IN SCHEMA committee TO ethics_app, ethics_owner;

COMMIT;
