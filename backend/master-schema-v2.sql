-- ============================================================
-- Master Schema v2.0 — Enterprise Governance Architecture
-- Phases 16–25
-- ============================================================
-- This script adds ~30 new tables across all schemas
-- to transform a basic REC system into a National Ethics
-- & Research Governance Platform.
-- ============================================================

BEGIN;

-- ============================================================
-- Phase 16 — Governance Layer (security)
-- ============================================================

CREATE TABLE security.responsibility_types (
  id          BIGINT GENERATED ALWAYS AS IDENTITY,
  code        VARCHAR(50)  NOT NULL,
  name_ar     VARCHAR(200) NOT NULL,
  name_en     VARCHAR(200),
  description TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ,
  CONSTRAINT pk_responsibility_types PRIMARY KEY (id),
  CONSTRAINT uq_responsibility_types_code UNIQUE (code)
);

COMMENT ON TABLE  security.responsibility_types IS 'أنواع المسؤوليات / Responsibility Types';
COMMENT ON COLUMN security.responsibility_types.code IS 'الكود (Reviewer, Approver, Signer, Observer, Coordinator, Secretary)';

CREATE TABLE security.user_responsibilities (
  id                    BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid                  UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id               BIGINT NOT NULL,
  responsibility_type_id BIGINT NOT NULL,
  entity_type           VARCHAR(50) NOT NULL,
  entity_id             BIGINT NOT NULL,
  is_active             BOOLEAN NOT NULL DEFAULT true,
  assigned_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  assigned_by           BIGINT,
  revoked_at            TIMESTAMPTZ,
  revoked_by            BIGINT,
  created_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at            TIMESTAMPTZ,
  CONSTRAINT pk_user_responsibilities PRIMARY KEY (id),
  CONSTRAINT uq_user_responsibilities_uuid UNIQUE (uuid),
  CONSTRAINT fk_user_responsibilities_user FOREIGN KEY (user_id) REFERENCES security.users(id),
  CONSTRAINT fk_user_responsibilities_type FOREIGN KEY (responsibility_type_id) REFERENCES security.responsibility_types(id),
  CONSTRAINT fk_user_responsibilities_assigned_by FOREIGN KEY (assigned_by) REFERENCES security.users(id),
  CONSTRAINT fk_user_responsibilities_revoked_by FOREIGN KEY (revoked_by) REFERENCES security.users(id)
);

COMMENT ON TABLE  security.user_responsibilities IS 'مسؤوليات المستخدمين / User Responsibilities';
COMMENT ON COLUMN security.user_responsibilities.entity_type IS 'نوع الكيان (application, project, committee)';
COMMENT ON COLUMN security.user_responsibilities.entity_id IS 'معرف الكيان';

CREATE INDEX idx_user_responsibilities_user ON security.user_responsibilities(user_id);
CREATE INDEX idx_user_responsibilities_entity ON security.user_responsibilities(entity_type, entity_id);

-- ============================================================
-- Phase 17 — Committee Governance
-- ============================================================

CREATE TABLE committee.member_terms (
  id                      BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid                    UUID NOT NULL DEFAULT gen_random_uuid(),
  member_id               BIGINT NOT NULL,
  start_date              DATE NOT NULL,
  end_date                DATE,
  appointment_decision_no VARCHAR(100),
  appointment_decision_date DATE,
  termination_decision_no VARCHAR(100),
  termination_decision_date DATE,
  is_active               BOOLEAN NOT NULL DEFAULT true,
  created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at              TIMESTAMPTZ,
  CONSTRAINT pk_member_terms PRIMARY KEY (id),
  CONSTRAINT uq_member_terms_uuid UNIQUE (uuid),
  CONSTRAINT fk_member_terms_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id)
);

COMMENT ON TABLE committee.member_terms IS 'فترات عضوية اللجنة / Member Terms';

CREATE TABLE committee.member_qualifications (
  id                BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid              UUID NOT NULL DEFAULT gen_random_uuid(),
  member_id         BIGINT NOT NULL,
  specialization    VARCHAR(200) NOT NULL,
  academic_degree   VARCHAR(100) NOT NULL,
  institution_name  VARCHAR(300),
  experience_years  INTEGER,
  certificate_url   TEXT,
  is_verified       BOOLEAN NOT NULL DEFAULT false,
  verified_by       BIGINT,
  verified_at       TIMESTAMPTZ,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ,
  CONSTRAINT pk_member_qualifications PRIMARY KEY (id),
  CONSTRAINT uq_member_qualifications_uuid UNIQUE (uuid),
  CONSTRAINT fk_member_qualifications_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id),
  CONSTRAINT fk_member_qualifications_verified_by FOREIGN KEY (verified_by) REFERENCES security.users(id)
);

COMMENT ON TABLE committee.member_qualifications IS 'مؤهلات أعضاء اللجنة / Member Qualifications';

CREATE TABLE committee.member_conflicts (
  id              BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid            UUID NOT NULL DEFAULT gen_random_uuid(),
  member_id       BIGINT NOT NULL,
  entity_type     VARCHAR(50) NOT NULL,
  entity_id       BIGINT NOT NULL,
  conflict_type   VARCHAR(50) NOT NULL,
  description     TEXT,
  declared_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  resolved_at     TIMESTAMPTZ,
  resolution_notes TEXT,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ,
  CONSTRAINT pk_member_conflicts PRIMARY KEY (id),
  CONSTRAINT uq_member_conflicts_uuid UNIQUE (uuid),
  CONSTRAINT fk_member_conflicts_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id)
);

COMMENT ON TABLE committee.member_conflicts IS 'تضارب مصالح الأعضاء (مستقل عن المراجعات) / Member Conflicts';

CREATE INDEX idx_member_conflicts_member ON committee.member_conflicts(member_id);
CREATE INDEX idx_member_conflicts_entity ON committee.member_conflicts(entity_type, entity_id);

-- [member_roles] junction table: committee_members <-> committee_roles
CREATE TABLE committee.member_roles (
  id         BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid       UUID NOT NULL DEFAULT gen_random_uuid(),
  member_id  BIGINT NOT NULL,
  role_id    BIGINT NOT NULL,
  start_date DATE NOT NULL DEFAULT CURRENT_DATE,
  end_date   DATE,
  is_primary BOOLEAN NOT NULL DEFAULT false,
  is_active  BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ,
  CONSTRAINT pk_member_roles PRIMARY KEY (id),
  CONSTRAINT uq_member_roles_uuid UNIQUE (uuid),
  CONSTRAINT uq_member_role UNIQUE (member_id, role_id),
  CONSTRAINT fk_member_roles_member FOREIGN KEY (member_id) REFERENCES committee.committee_members(id) ON DELETE CASCADE,
  CONSTRAINT fk_member_roles_role FOREIGN KEY (role_id) REFERENCES committee.committee_roles(id)
);

CREATE INDEX idx_member_roles_member ON committee.member_roles(member_id);
CREATE INDEX idx_member_roles_role ON committee.member_roles(role_id);

COMMENT ON TABLE committee.member_roles IS 'أدوار أعضاء اللجنة / Committee Member Roles';

-- ============================================================
-- Phase 18 — Research Governance
-- ============================================================

CREATE TABLE core.research_categories (
  id          BIGINT GENERATED ALWAYS AS IDENTITY,
  code        VARCHAR(50)  NOT NULL,
  name_ar     VARCHAR(200) NOT NULL,
  name_en     VARCHAR(200),
  description TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ,
  CONSTRAINT pk_research_categories PRIMARY KEY (id),
  CONSTRAINT uq_research_categories_code UNIQUE (code)
);

COMMENT ON TABLE core.research_categories IS 'تصنيفات البحث العلمي / Research Categories';

CREATE TABLE core.risk_classifications (
  id              BIGINT GENERATED ALWAYS AS IDENTITY,
  code            VARCHAR(50)  NOT NULL,
  name_ar         VARCHAR(200) NOT NULL,
  name_en         VARCHAR(200),
  severity_level  INTEGER NOT NULL DEFAULT 1,
  description     TEXT,
  is_active       BOOLEAN NOT NULL DEFAULT true,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ,
  CONSTRAINT pk_risk_classifications PRIMARY KEY (id),
  CONSTRAINT uq_risk_classifications_code UNIQUE (code)
);

COMMENT ON TABLE core.risk_classifications IS 'تصنيفات المخاطر / Risk Classifications';

CREATE TABLE core.vulnerable_populations (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY,
  code                VARCHAR(50)  NOT NULL,
  name_ar             VARCHAR(200) NOT NULL,
  name_en             VARCHAR(200),
  description         TEXT,
  safeguards_required TEXT,
  is_active           BOOLEAN NOT NULL DEFAULT true,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ,
  CONSTRAINT pk_vulnerable_populations PRIMARY KEY (id),
  CONSTRAINT uq_vulnerable_populations_code UNIQUE (code)
);

COMMENT ON TABLE core.vulnerable_populations IS 'الفئات الحساسة في الأبحاث / Vulnerable Populations';

CREATE TABLE core.research_population_links (
  id                       BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid                     UUID NOT NULL DEFAULT gen_random_uuid(),
  project_id               BIGINT NOT NULL,
  vulnerable_population_id BIGINT NOT NULL,
  safeguard_measures       TEXT,
  created_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_research_population_links PRIMARY KEY (id),
  CONSTRAINT uq_research_population_links_uuid UNIQUE (uuid),
  CONSTRAINT fk_research_population_links_project FOREIGN KEY (project_id) REFERENCES core.projects(id),
  CONSTRAINT fk_research_population_links_population FOREIGN KEY (vulnerable_population_id) REFERENCES core.vulnerable_populations(id)
);

COMMENT ON TABLE core.research_population_links IS 'ربط المشاريع بالفئات الحساسة / Research-Population Links';

CREATE INDEX idx_research_population_links_project ON core.research_population_links(project_id);

-- ============================================================
-- Phase 19 — Document Governance
-- ============================================================

CREATE TABLE documents.document_classifications (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY,
  code                VARCHAR(50)  NOT NULL,
  name_ar             VARCHAR(200) NOT NULL,
  name_en             VARCHAR(200),
  description         TEXT,
  clearance_required  VARCHAR(50),
  is_active           BOOLEAN NOT NULL DEFAULT true,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ,
  CONSTRAINT pk_document_classifications PRIMARY KEY (id),
  CONSTRAINT uq_document_classifications_code UNIQUE (code)
);

COMMENT ON TABLE documents.document_classifications IS 'تصنيفات المستندات / Document Classifications';

CREATE TABLE documents.document_retention_rules (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY,
  document_type_id    BIGINT NOT NULL,
  retention_period_days INTEGER NOT NULL,
  disposition_action  VARCHAR(50) NOT NULL DEFAULT 'ARCHIVE',
  legal_basis         TEXT,
  is_active           BOOLEAN NOT NULL DEFAULT true,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ,
  CONSTRAINT pk_document_retention_rules PRIMARY KEY (id),
  CONSTRAINT fk_document_retention_rules_type FOREIGN KEY (document_type_id) REFERENCES documents.document_types(id)
);

COMMENT ON TABLE documents.document_retention_rules IS 'قواعد الاحتفاظ بالمستندات / Document Retention Rules';

CREATE TABLE documents.document_disposal_logs (
  id                BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid              UUID NOT NULL DEFAULT gen_random_uuid(),
  document_id       BIGINT NOT NULL,
  disposed_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  disposed_by       BIGINT NOT NULL,
  disposal_method   VARCHAR(50) NOT NULL,
  authorization_ref VARCHAR(100),
  notes             TEXT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_document_disposal_logs PRIMARY KEY (id),
  CONSTRAINT uq_document_disposal_logs_uuid UNIQUE (uuid),
  CONSTRAINT fk_document_disposal_logs_document FOREIGN KEY (document_id) REFERENCES documents.documents(id),
  CONSTRAINT fk_document_disposal_logs_disposed_by FOREIGN KEY (disposed_by) REFERENCES security.users(id)
);

COMMENT ON TABLE documents.document_disposal_logs IS 'سجل إتلاف المستندات / Document Disposal Logs';

-- ============================================================
-- Phase 20 — Enterprise Risk Management
-- ============================================================

CREATE TABLE safety.risk_register (
  id                BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid              UUID NOT NULL DEFAULT gen_random_uuid(),
  risk_code         VARCHAR(50) NOT NULL,
  risk_title        VARCHAR(300) NOT NULL,
  risk_description  TEXT,
  risk_category_id  BIGINT,
  likelihood        INTEGER NOT NULL DEFAULT 1,
  impact            INTEGER NOT NULL DEFAULT 1,
  risk_score        INTEGER GENERATED ALWAYS AS (likelihood * impact) STORED,
  risk_level        VARCHAR(20),
  owner_id          BIGINT,
  status            VARCHAR(30) NOT NULL DEFAULT 'IDENTIFIED',
  identified_at     TIMESTAMPTZ NOT NULL DEFAULT now(),
  identified_by     BIGINT,
  reviewed_at       TIMESTAMPTZ,
  reviewed_by       BIGINT,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ,
  CONSTRAINT pk_risk_register PRIMARY KEY (id),
  CONSTRAINT uq_risk_register_uuid UNIQUE (uuid),
  CONSTRAINT uq_risk_register_code UNIQUE (risk_code),
  CONSTRAINT fk_risk_register_category FOREIGN KEY (risk_category_id) REFERENCES safety.risk_categories(id),
  CONSTRAINT fk_risk_register_owner FOREIGN KEY (owner_id) REFERENCES security.users(id),
  CONSTRAINT fk_risk_register_identified_by FOREIGN KEY (identified_by) REFERENCES security.users(id),
  CONSTRAINT fk_risk_register_reviewed_by FOREIGN KEY (reviewed_by) REFERENCES security.users(id)
);

COMMENT ON TABLE safety.risk_register IS 'سجل المخاطر المؤسسي / Enterprise Risk Register';

CREATE TABLE safety.risk_mitigations (
  id                   BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid                 UUID NOT NULL DEFAULT gen_random_uuid(),
  risk_id              BIGINT NOT NULL,
  mitigation_plan      TEXT NOT NULL,
  responsible_party    BIGINT,
  target_date          DATE,
  status               VARCHAR(30) NOT NULL DEFAULT 'PLANNED',
  effectiveness_score  INTEGER,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at           TIMESTAMPTZ,
  CONSTRAINT pk_risk_mitigations PRIMARY KEY (id),
  CONSTRAINT uq_risk_mitigations_uuid UNIQUE (uuid),
  CONSTRAINT fk_risk_mitigations_risk FOREIGN KEY (risk_id) REFERENCES safety.risk_register(id),
  CONSTRAINT fk_risk_mitigations_responsible FOREIGN KEY (responsible_party) REFERENCES security.users(id)
);

COMMENT ON TABLE safety.risk_mitigations IS 'إجراءات معالجة المخاطر / Risk Mitigations';

CREATE TABLE safety.risk_incidents (
  id            BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid          UUID NOT NULL DEFAULT gen_random_uuid(),
  risk_id       BIGINT,
  incident_code VARCHAR(50) NOT NULL,
  incident_date TIMESTAMPTZ NOT NULL,
  description   TEXT NOT NULL,
  severity      VARCHAR(30),
  root_cause    TEXT,
  reported_by   BIGINT NOT NULL,
  status        VARCHAR(30) NOT NULL DEFAULT 'REPORTED',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ,
  CONSTRAINT pk_risk_incidents PRIMARY KEY (id),
  CONSTRAINT uq_risk_incidents_uuid UNIQUE (uuid),
  CONSTRAINT uq_risk_incidents_code UNIQUE (incident_code),
  CONSTRAINT fk_risk_incidents_risk FOREIGN KEY (risk_id) REFERENCES safety.risk_register(id),
  CONSTRAINT fk_risk_incidents_reported_by FOREIGN KEY (reported_by) REFERENCES security.users(id)
);

COMMENT ON TABLE safety.risk_incidents IS 'سجل الحوادث / Risk Incidents';

CREATE TABLE safety.corrective_actions (
  id            BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid          UUID NOT NULL DEFAULT gen_random_uuid(),
  incident_id   BIGINT,
  action_code   VARCHAR(50) NOT NULL,
  description   TEXT NOT NULL,
  assigned_to   BIGINT,
  priority      VARCHAR(20) NOT NULL DEFAULT 'MEDIUM',
  due_date      DATE,
  completed_at  TIMESTAMPTZ,
  status        VARCHAR(30) NOT NULL DEFAULT 'OPEN',
  closure_notes TEXT,
  created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at    TIMESTAMPTZ,
  CONSTRAINT pk_corrective_actions PRIMARY KEY (id),
  CONSTRAINT uq_corrective_actions_uuid UNIQUE (uuid),
  CONSTRAINT uq_corrective_actions_code UNIQUE (action_code),
  CONSTRAINT fk_corrective_actions_incident FOREIGN KEY (incident_id) REFERENCES safety.risk_incidents(id),
  CONSTRAINT fk_corrective_actions_assigned_to FOREIGN KEY (assigned_to) REFERENCES security.users(id)
);

COMMENT ON TABLE safety.corrective_actions IS 'الإجراءات التصحيحية / Corrective Actions';

CREATE INDEX idx_risk_register_owner ON safety.risk_register(owner_id);
CREATE INDEX idx_risk_register_status ON safety.risk_register(status);
CREATE INDEX idx_risk_mitigations_risk ON safety.risk_mitigations(risk_id);
CREATE INDEX idx_risk_incidents_risk ON safety.risk_incidents(risk_id);
CREATE INDEX idx_corrective_actions_incident ON safety.corrective_actions(incident_id);

-- ============================================================
-- Phase 21 — National Registry Layer
-- ============================================================

CREATE TABLE reference.institutions_registry (
  id                 BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid               UUID NOT NULL DEFAULT gen_random_uuid(),
  national_id        VARCHAR(50) NOT NULL,
  name_ar            VARCHAR(300) NOT NULL,
  name_en            VARCHAR(300),
  type               VARCHAR(100) NOT NULL,
  address            TEXT,
  city               VARCHAR(100),
  country            VARCHAR(100) NOT NULL DEFAULT 'Saudi Arabia',
  phone              VARCHAR(50),
  email              VARCHAR(200),
  website            VARCHAR(200),
  is_accredited      BOOLEAN NOT NULL DEFAULT false,
  accreditation_body VARCHAR(200),
  license_number     VARCHAR(100),
  is_active          BOOLEAN NOT NULL DEFAULT true,
  created_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at         TIMESTAMPTZ,
  CONSTRAINT pk_institutions_registry PRIMARY KEY (id),
  CONSTRAINT uq_institutions_registry_uuid UNIQUE (uuid),
  CONSTRAINT uq_institutions_registry_national_id UNIQUE (national_id)
);

COMMENT ON TABLE reference.institutions_registry IS 'سجل المؤسسات الوطني / National Institutions Registry';

CREATE TABLE reference.professions_registry (
  id          BIGINT GENERATED ALWAYS AS IDENTITY,
  code        VARCHAR(50)  NOT NULL,
  name_ar     VARCHAR(200) NOT NULL,
  name_en     VARCHAR(200),
  category    VARCHAR(100),
  description TEXT,
  is_active   BOOLEAN NOT NULL DEFAULT true,
  created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at  TIMESTAMPTZ,
  CONSTRAINT pk_professions_registry PRIMARY KEY (id),
  CONSTRAINT uq_professions_registry_code UNIQUE (code)
);

COMMENT ON TABLE reference.professions_registry IS 'سجل المهن الوطني / National Professions Registry';

CREATE TABLE reference.licenses_registry (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid                UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id             BIGINT,
  profession_id       BIGINT,
  license_number      VARCHAR(100) NOT NULL,
  issuing_body        VARCHAR(200),
  issued_date         DATE,
  expiry_date         DATE,
  license_document_url TEXT,
  verification_status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
  verified_by         BIGINT,
  verified_at         TIMESTAMPTZ,
  is_active           BOOLEAN NOT NULL DEFAULT true,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ,
  CONSTRAINT pk_licenses_registry PRIMARY KEY (id),
  CONSTRAINT uq_licenses_registry_uuid UNIQUE (uuid),
  CONSTRAINT uq_licenses_registry_license_number UNIQUE (license_number),
  CONSTRAINT fk_licenses_registry_user FOREIGN KEY (user_id) REFERENCES security.users(id),
  CONSTRAINT fk_licenses_registry_profession FOREIGN KEY (profession_id) REFERENCES reference.professions_registry(id),
  CONSTRAINT fk_licenses_registry_verified_by FOREIGN KEY (verified_by) REFERENCES security.users(id)
);

COMMENT ON TABLE reference.licenses_registry IS 'سجل التراخيص المهنية / Professional Licenses Registry';

CREATE INDEX idx_licenses_registry_user ON reference.licenses_registry(user_id);
CREATE INDEX idx_licenses_registry_verification ON reference.licenses_registry(verification_status);

-- ============================================================
-- Phase 22 — Enterprise Search
-- ============================================================

CREATE TABLE system.search_indexes (
  id           BIGINT GENERATED ALWAYS AS IDENTITY,
  entity_type  VARCHAR(100) NOT NULL,
  entity_id    BIGINT NOT NULL,
  search_text  TEXT NOT NULL,
  search_vector tsvector,
  weight       INTEGER NOT NULL DEFAULT 1,
  language     VARCHAR(10) NOT NULL DEFAULT 'arabic',
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at   TIMESTAMPTZ,
  CONSTRAINT pk_search_indexes PRIMARY KEY (id)
);

COMMENT ON TABLE system.search_indexes IS 'فهارس البحث النصي / Search Indexes';

CREATE INDEX idx_search_indexes_vector ON system.search_indexes USING GIN(search_vector);
CREATE INDEX idx_search_indexes_entity ON system.search_indexes(entity_type, entity_id);

CREATE TABLE system.saved_searches (
  id              BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid            UUID NOT NULL DEFAULT gen_random_uuid(),
  user_id         BIGINT NOT NULL,
  search_name     VARCHAR(200) NOT NULL,
  search_criteria JSONB NOT NULL,
  entity_type     VARCHAR(100),
  is_shared       BOOLEAN NOT NULL DEFAULT false,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ,
  CONSTRAINT pk_saved_searches PRIMARY KEY (id),
  CONSTRAINT uq_saved_searches_uuid UNIQUE (uuid),
  CONSTRAINT fk_saved_searches_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE
);

COMMENT ON TABLE system.saved_searches IS 'عمليات البحث المحفوظة / Saved Searches';

CREATE TABLE system.search_audit (
  id                BIGINT GENERATED ALWAYS AS IDENTITY,
  user_id           BIGINT,
  search_query      TEXT NOT NULL,
  entity_type       VARCHAR(100),
  result_count      INTEGER,
  search_duration_ms INTEGER,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_search_audit PRIMARY KEY (id),
  CONSTRAINT fk_search_audit_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE SET NULL
);

COMMENT ON TABLE system.search_audit IS 'سجل عمليات البحث / Search Audit Log';

CREATE INDEX idx_search_audit_user ON system.search_audit(user_id);
CREATE INDEX idx_search_audit_created ON system.search_audit(created_at);

-- ============================================================
-- Phase 23 — Business Rules Engine
-- ============================================================

CREATE TABLE system.rule_conditions (
  id              BIGINT GENERATED ALWAYS AS IDENTITY,
  rule_id         BIGINT NOT NULL,
  condition_group VARCHAR(50) NOT NULL DEFAULT 'AND',
  field_name      VARCHAR(200) NOT NULL,
  operator        VARCHAR(30) NOT NULL,
  field_value     TEXT NOT NULL,
  value_type      VARCHAR(30) NOT NULL DEFAULT 'STRING',
  order_index     INTEGER NOT NULL DEFAULT 0,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_rule_conditions PRIMARY KEY (id),
  CONSTRAINT fk_rule_conditions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE
);

COMMENT ON TABLE system.rule_conditions IS 'شروط قواعد الأعمال / Rule Conditions';

CREATE TABLE system.rule_actions (
  id           BIGINT GENERATED ALWAYS AS IDENTITY,
  rule_id      BIGINT NOT NULL,
  action_type  VARCHAR(100) NOT NULL,
  action_params JSONB NOT NULL DEFAULT '{}',
  order_index  INTEGER NOT NULL DEFAULT 0,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_rule_actions PRIMARY KEY (id),
  CONSTRAINT fk_rule_actions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE
);

COMMENT ON TABLE system.rule_actions IS 'إجراءات قواعد الأعمال / Rule Actions';

CREATE TABLE system.rule_executions (
  id                   BIGINT GENERATED ALWAYS AS IDENTITY,
  rule_id              BIGINT NOT NULL,
  entity_type          VARCHAR(100) NOT NULL,
  entity_id            BIGINT NOT NULL,
  conditions_met       BOOLEAN NOT NULL,
  execution_result     JSONB,
  execution_duration_ms INTEGER,
  triggered_by         BIGINT,
  executed_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_rule_executions PRIMARY KEY (id),
  CONSTRAINT fk_rule_executions_rule FOREIGN KEY (rule_id) REFERENCES system.business_rules(id) ON DELETE CASCADE,
  CONSTRAINT fk_rule_executions_triggered_by FOREIGN KEY (triggered_by) REFERENCES security.users(id) ON DELETE SET NULL
);

COMMENT ON TABLE system.rule_executions IS 'سجل تنفيذ قواعد الأعمال / Rule Executions';

CREATE INDEX idx_rule_conditions_rule ON system.rule_conditions(rule_id);
CREATE INDEX idx_rule_actions_rule ON system.rule_actions(rule_id);
CREATE INDEX idx_rule_executions_rule ON system.rule_executions(rule_id);
CREATE INDEX idx_rule_executions_entity ON system.rule_executions(entity_type, entity_id);

-- ============================================================
-- Phase 24 — Workflow Automation
-- ============================================================

CREATE TABLE workflow.workflow_events (
  id                   BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid                 UUID NOT NULL DEFAULT gen_random_uuid(),
  workflow_instance_id BIGINT,
  event_type           VARCHAR(100) NOT NULL,
  event_data           JSONB DEFAULT '{}',
  source               VARCHAR(100),
  created_by           BIGINT,
  created_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_workflow_events PRIMARY KEY (id),
  CONSTRAINT uq_workflow_events_uuid UNIQUE (uuid),
  CONSTRAINT fk_workflow_events_instance FOREIGN KEY (workflow_instance_id) REFERENCES workflow.workflow_instances(id) ON DELETE SET NULL,
  CONSTRAINT fk_workflow_events_created_by FOREIGN KEY (created_by) REFERENCES security.users(id) ON DELETE SET NULL
);

COMMENT ON TABLE workflow.workflow_events IS 'أحداث سير العمل / Workflow Events';

CREATE TABLE workflow.workflow_triggers (
  id                BIGINT GENERATED ALWAYS AS IDENTITY,
  code              VARCHAR(50) NOT NULL,
  name_ar           VARCHAR(200) NOT NULL,
  name_en           VARCHAR(200),
  trigger_event     VARCHAR(100) NOT NULL,
  trigger_conditions JSONB DEFAULT '{}',
  target_workflow_id BIGINT,
  is_active         BOOLEAN NOT NULL DEFAULT true,
  created_at        TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at        TIMESTAMPTZ,
  CONSTRAINT pk_workflow_triggers PRIMARY KEY (id),
  CONSTRAINT uq_workflow_triggers_code UNIQUE (code),
  CONSTRAINT fk_workflow_triggers_workflow FOREIGN KEY (target_workflow_id) REFERENCES workflow.workflows(id)
);

COMMENT ON TABLE workflow.workflow_triggers IS 'مشغلات سير العمل / Workflow Triggers';

CREATE TABLE workflow.workflow_schedulers (
  id              BIGINT GENERATED ALWAYS AS IDENTITY,
  code            VARCHAR(50) NOT NULL,
  name_ar         VARCHAR(200) NOT NULL,
  cron_expression VARCHAR(100) NOT NULL,
  workflow_id     BIGINT NOT NULL,
  action_params   JSONB DEFAULT '{}',
  is_active       BOOLEAN NOT NULL DEFAULT true,
  last_run_at     TIMESTAMPTZ,
  next_run_at     TIMESTAMPTZ,
  created_at      TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at      TIMESTAMPTZ,
  CONSTRAINT pk_workflow_schedulers PRIMARY KEY (id),
  CONSTRAINT uq_workflow_schedulers_code UNIQUE (code),
  CONSTRAINT fk_workflow_schedulers_workflow FOREIGN KEY (workflow_id) REFERENCES workflow.workflows(id)
);

COMMENT ON TABLE workflow.workflow_schedulers IS 'مجَدولات سير العمل / Workflow Schedulers';

CREATE INDEX idx_workflow_events_instance ON workflow.workflow_events(workflow_instance_id);
CREATE INDEX idx_workflow_events_type ON workflow.workflow_events(event_type);
CREATE INDEX idx_workflow_triggers_event ON workflow.workflow_triggers(trigger_event);

-- ============================================================
-- Phase 25 — Enterprise Integration Layer
-- ============================================================

CREATE TABLE integration.external_systems (
  id               BIGINT GENERATED ALWAYS AS IDENTITY,
  code             VARCHAR(50) NOT NULL,
  name_ar          VARCHAR(200) NOT NULL,
  name_en          VARCHAR(200),
  system_type      VARCHAR(100) NOT NULL,
  base_url         VARCHAR(500),
  is_active        BOOLEAN NOT NULL DEFAULT true,
  supports_webhook BOOLEAN NOT NULL DEFAULT false,
  supports_api     BOOLEAN NOT NULL DEFAULT true,
  created_at       TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at       TIMESTAMPTZ,
  CONSTRAINT pk_external_systems PRIMARY KEY (id),
  CONSTRAINT uq_external_systems_code UNIQUE (code)
);

COMMENT ON TABLE integration.external_systems IS 'الأنظمة الخارجية المتصلة / External Systems';

CREATE TABLE integration.integration_credentials (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY,
  external_system_id  BIGINT NOT NULL,
  credential_type     VARCHAR(50) NOT NULL DEFAULT 'API_KEY',
  credential_key      VARCHAR(200) NOT NULL,
  credential_value    TEXT NOT NULL,
  is_active           BOOLEAN NOT NULL DEFAULT true,
  expires_at          TIMESTAMPTZ,
  last_used_at        TIMESTAMPTZ,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at          TIMESTAMPTZ,
  CONSTRAINT pk_integration_credentials PRIMARY KEY (id),
  CONSTRAINT fk_integration_credentials_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE CASCADE
);

COMMENT ON TABLE integration.integration_credentials IS 'بيانات اعتماد التكامل / Integration Credentials';

CREATE TABLE integration.integration_failures (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY,
  external_system_id  BIGINT,
  endpoint            VARCHAR(500) NOT NULL,
  error_message       TEXT NOT NULL,
  error_code          VARCHAR(100),
  request_payload     TEXT,
  response_payload    TEXT,
  retry_count         INTEGER NOT NULL DEFAULT 0,
  max_retries         INTEGER NOT NULL DEFAULT 3,
  status              VARCHAR(30) NOT NULL DEFAULT 'NEW',
  resolved_at         TIMESTAMPTZ,
  resolved_by         BIGINT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_integration_failures PRIMARY KEY (id),
  CONSTRAINT fk_integration_failures_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE SET NULL,
  CONSTRAINT fk_integration_failures_resolved_by FOREIGN KEY (resolved_by) REFERENCES security.users(id) ON DELETE SET NULL
);

COMMENT ON TABLE integration.integration_failures IS 'سجل فشل التكامل / Integration Failures';

CREATE TABLE integration.data_sync_jobs (
  id                  BIGINT GENERATED ALWAYS AS IDENTITY,
  uuid                UUID NOT NULL DEFAULT gen_random_uuid(),
  external_system_id  BIGINT NOT NULL,
  sync_direction      VARCHAR(10) NOT NULL DEFAULT 'BIDIRECTIONAL',
  entity_type         VARCHAR(100) NOT NULL,
  started_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  completed_at        TIMESTAMPTZ,
  records_processed   INTEGER DEFAULT 0,
  records_failed      INTEGER DEFAULT 0,
  status              VARCHAR(30) NOT NULL DEFAULT 'RUNNING',
  error_log           TEXT,
  created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
  CONSTRAINT pk_data_sync_jobs PRIMARY KEY (id),
  CONSTRAINT uq_data_sync_jobs_uuid UNIQUE (uuid),
  CONSTRAINT fk_data_sync_jobs_system FOREIGN KEY (external_system_id) REFERENCES integration.external_systems(id) ON DELETE CASCADE
);

COMMENT ON TABLE integration.data_sync_jobs IS 'وظائف مزامنة البيانات / Data Sync Jobs';

CREATE INDEX idx_data_sync_jobs_system ON integration.data_sync_jobs(external_system_id);
CREATE INDEX idx_data_sync_jobs_status ON integration.data_sync_jobs(status);

-- ============================================================
-- Seed Data — Lookup Tables
-- ============================================================

-- Responsibility Types
INSERT INTO security.responsibility_types (code, name_ar, name_en) VALUES
  ('REVIEWER',    'مراجع',        'Reviewer'),
  ('APPROVER',    'معتمد',        'Approver'),
  ('SIGNER',      'موقع',         'Signer'),
  ('OBSERVER',    'مراقب',        'Observer'),
  ('COORDINATOR', 'منسق',         'Coordinator'),
  ('SECRETARY',   'سكرتير',       'Secretary')
ON CONFLICT (code) DO NOTHING;

-- Research Categories
INSERT INTO core.research_categories (code, name_ar, name_en) VALUES
  ('CLINICAL',   'سريري',      'Clinical'),
  ('BEHAVIORAL', 'سلوكي',      'Behavioral'),
  ('SOCIAL',     'اجتماعي',    'Social'),
  ('LABORATORY', 'مختبري',     'Laboratory'),
  ('ANIMAL',     'حيواني',     'Animal')
ON CONFLICT (code) DO NOTHING;

-- Risk Classifications
INSERT INTO core.risk_classifications (code, name_ar, name_en, severity_level) VALUES
  ('LOW',      'منخفض',    'Low',      1),
  ('MEDIUM',   'متوسط',    'Medium',   2),
  ('HIGH',     'عالٍ',     'High',     3),
  ('CRITICAL', 'خطير',     'Critical', 4)
ON CONFLICT (code) DO NOTHING;

-- Vulnerable Populations
INSERT INTO core.vulnerable_populations (code, name_ar, name_en, safeguards_required) VALUES
  ('CHILDREN',         'أطفال',           'Children',         'موافقة ولي الأمر'),
  ('PREGNANT_WOMEN',   'حوامل',           'Pregnant Women',   'تقييم المخاطر على الجنين'),
  ('PRISONERS',        'سجناء',           'Prisoners',        'موافقة مستقلة'),
  ('DISABLED_PERSONS', 'أشخاص ذوي إعاقة', 'Disabled Persons', 'وسائل تواصل ملائمة')
ON CONFLICT (code) DO NOTHING;

-- Document Classifications
INSERT INTO documents.document_classifications (code, name_ar, name_en, clearance_required) VALUES
  ('PUBLIC',       'عام',        'Public',       'NONE'),
  ('INTERNAL',     'داخلي',      'Internal',     'USER'),
  ('CONFIDENTIAL', 'سري',        'Confidential', 'REVIEWER'),
  ('SECRET',       'سري جداً',   'Secret',       'ADMIN')
ON CONFLICT (code) DO NOTHING;

-- Professions Registry
INSERT INTO reference.professions_registry (code, name_ar, name_en, category) VALUES
  ('RESEARCHER', 'باحث',    'Researcher',    'Academic'),
  ('PHYSICIAN',  'طبيب',    'Physician',     'Medical'),
  ('PHARMACIST', 'صيدلي',   'Pharmacist',    'Medical'),
  ('STATISTICIAN', 'إحصائي', 'Statistician', 'Academic'),
  ('NURSE',      'ممرض',    'Nurse',         'Medical'),
  ('ETHICIST',   'أخلاقي',  'Bioethicist',   'Academic'),
  ('LEGAL',      'قانوني',  'Legal Expert',  'Legal')
ON CONFLICT (code) DO NOTHING;

-- ============================================================
-- Permissions — Grant to app roles
-- ============================================================

DO $$
DECLARE
  r TEXT;
  tables TEXT[][] := ARRAY[
    ARRAY['security', 'responsibility_types'],
    ARRAY['security', 'user_responsibilities'],
    ARRAY['committee', 'member_terms'],
    ARRAY['committee', 'member_qualifications'],
    ARRAY['committee', 'member_conflicts'],
    ARRAY['core', 'research_categories'],
    ARRAY['core', 'risk_classifications'],
    ARRAY['core', 'vulnerable_populations'],
    ARRAY['core', 'research_population_links'],
    ARRAY['documents', 'document_classifications'],
    ARRAY['documents', 'document_retention_rules'],
    ARRAY['documents', 'document_disposal_logs'],
    ARRAY['safety', 'risk_register'],
    ARRAY['safety', 'risk_mitigations'],
    ARRAY['safety', 'risk_incidents'],
    ARRAY['safety', 'corrective_actions'],
    ARRAY['reference', 'institutions_registry'],
    ARRAY['reference', 'professions_registry'],
    ARRAY['reference', 'licenses_registry'],
    ARRAY['system', 'search_indexes'],
    ARRAY['system', 'saved_searches'],
    ARRAY['system', 'search_audit'],
    ARRAY['system', 'rule_conditions'],
    ARRAY['system', 'rule_actions'],
    ARRAY['system', 'rule_executions'],
    ARRAY['workflow', 'workflow_events'],
    ARRAY['workflow', 'workflow_triggers'],
    ARRAY['workflow', 'workflow_schedulers'],
    ARRAY['integration', 'external_systems'],
    ARRAY['integration', 'integration_credentials'],
    ARRAY['integration', 'integration_failures'],
    ARRAY['integration', 'data_sync_jobs']
  ];
BEGIN
  FOREACH r IN ARRAY ARRAY['ethics_app', 'ethics_audit', 'ethics_reporting', 'ethics_readonly', 'ethics_workflow'] LOOP
    FOR i IN 1..array_length(tables, 1) LOOP
      EXECUTE format('GRANT ALL PRIVILEGES ON TABLE %I.%I TO %I', tables[i][1], tables[i][2], r);
      IF r != 'ethics_readonly' THEN
        EXECUTE format('GRANT USAGE ON SEQUENCE %I.%I_id_seq TO %I', tables[i][1], tables[i][2], r);
      END IF;
    END LOOP;
  END LOOP;
END $$;

-- ============================================================
-- updated_at triggers
-- ============================================================

CREATE OR REPLACE FUNCTION system.fn_update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  tables TEXT[][] := ARRAY[
    ARRAY['security', 'responsibility_types'],
    ARRAY['security', 'user_responsibilities'],
    ARRAY['committee', 'member_terms'],
    ARRAY['committee', 'member_qualifications'],
    ARRAY['committee', 'member_conflicts'],
    ARRAY['core', 'research_categories'],
    ARRAY['core', 'risk_classifications'],
    ARRAY['core', 'vulnerable_populations'],
    ARRAY['documents', 'document_classifications'],
    ARRAY['documents', 'document_retention_rules'],
    ARRAY['safety', 'risk_register'],
    ARRAY['safety', 'risk_mitigations'],
    ARRAY['safety', 'risk_incidents'],
    ARRAY['safety', 'corrective_actions'],
    ARRAY['reference', 'institutions_registry'],
    ARRAY['reference', 'professions_registry'],
    ARRAY['reference', 'licenses_registry'],
    ARRAY['system', 'search_indexes'],
    ARRAY['system', 'saved_searches'],
    ARRAY['workflow', 'workflow_triggers'],
    ARRAY['workflow', 'workflow_schedulers'],
    ARRAY['integration', 'external_systems'],
    ARRAY['integration', 'integration_credentials']
  ];
  tbl TEXT;
BEGIN
  FOR i IN 1..array_length(tables, 1) LOOP
    tbl := format('%I.%I', tables[i][1], tables[i][2]);
    IF NOT EXISTS (
      SELECT 1 FROM pg_trigger
      WHERE tgname = format('trigger_updated_at_%s_%s', tables[i][1], tables[i][2])
      AND tgrelid = tbl::regclass
    ) THEN
      EXECUTE format(
        'CREATE TRIGGER trigger_updated_at_%s_%s BEFORE UPDATE ON %s FOR EACH ROW EXECUTE FUNCTION system.fn_update_updated_at()',
        tables[i][1], tables[i][2], tbl
      );
    END IF;
  END LOOP;
END $$;

COMMIT;
