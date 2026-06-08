-- SCHEMAS

CREATE SCHEMA IF NOT EXISTS security;
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS workflow;
CREATE SCHEMA IF NOT EXISTS committee;
CREATE SCHEMA IF NOT EXISTS documents;
CREATE SCHEMA IF NOT EXISTS monitoring;
CREATE SCHEMA IF NOT EXISTS safety;
CREATE SCHEMA IF NOT EXISTS communication;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS reporting;
CREATE SCHEMA IF NOT EXISTS integration;
CREATE SCHEMA IF NOT EXISTS reference;
CREATE SCHEMA IF NOT EXISTS system;

-- DATABASE

CREATE DATABASE ethics_db
    WITH
    OWNER = ethics_owner
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

\C ethics_db

-- EXTENSIONS

CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE EXTENSION IF NOT EXISTS citext;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";


GRANT CONNECT ON DATABASE ethics_db TO ethics_app;
GRANT CONNECT ON DATABASE ethics_db TO ethics_audit;
GRANT ALL ON DATABASE ethics_db TO ethics_owner;
GRANT CONNECT ON DATABASE ethics_db TO ethics_readonly;
GRANT CONNECT ON DATABASE ethics_db TO ethics_reporting;
GRANT CONNECT ON DATABASE ethics_db TO ethics_workflow;

-- [001] institution_types

CREATE TABLE IF NOT EXISTS security.institution_types (
id                  BIGINT GENERATED ALWAYS AS IDENTITY,
code                VARCHAR(50) NOT NULL,
name_ar             VARCHAR(200) NOT NULL,
name_en             VARCHAR(200),
description         TEXT,
is_active           BOOLEAN NOT NULL DEFAULT TRUE,
created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at          TIMESTAMPTZ,
created_by          BIGINT,
updated_by          BIGINT,
CONSTRAINT pk_institution_types PRIMARY KEY (id),
CONSTRAINT uq_institution_types_code UNIQUE (code),
CONSTRAINT chk_institution_types_code CHECK (length(trim(code)) > 0)
);

CREATE INDEX idx_institution_types_active ON security.institution_types(is_active);
CREATE INDEX idx_institution_types_name_ar ON security.institution_types(name_ar);

-- [002] institutions

CREATE TABLE IF NOT EXISTS security.institutions (
id                          BIGINT GENERATED ALWAYS AS IDENTITY,
institution_type_id         BIGINT NOT NULL,
code                        VARCHAR(50) NOT NULL,
name_ar                     VARCHAR(300) NOT NULL,
name_en                     VARCHAR(300),
license_number              VARCHAR(100),
registration_number         VARCHAR(100),
email                       VARCHAR(200),
phone                       VARCHAR(100),
address                     TEXT,
is_active                   BOOLEAN NOT NULL DEFAULT TRUE,
created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at                  TIMESTAMPTZ,
created_by                  BIGINT,
updated_by                  BIGINT,
CONSTRAINT pk_institutions  PRIMARY KEY (id),
CONSTRAINT uq_institutions_code  UNIQUE (code),
CONSTRAINT fk_institutions_type FOREIGN KEY (institution_type_id) REFERENCES security.institution_types(id) ON DELETE RESTRICT
);

CREATE INDEX idx_institutions_type ON security.institutions(institution_type_id);
CREATE INDEX idx_institutions_active ON security.institutions(is_active);
CREATE INDEX idx_institutions_name_ar ON security.institutions(name_ar);

-- [003] departments

CREATE TABLE IF NOT EXISTS security.departments (
id                      BIGINT GENERATED ALWAYS AS IDENTITY,
institution_id          BIGINT NOT NULL,
code                    VARCHAR(50) NOT NULL,
name_ar                 VARCHAR(200) NOT NULL,
name_en                 VARCHAR(200),
is_active               BOOLEAN NOT NULL DEFAULT TRUE,
created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at              TIMESTAMPTZ,
CONSTRAINT pk_departments   PRIMARY KEY (id),
CONSTRAINT uq_departments_code UNIQUE (institution_id, code),
CONSTRAINT fk_departments_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id) ON DELETE CASCADE
);

CREATE INDEX idx_departments_institution ON security.departments(institution_id);
CREATE INDEX idx_departments_active ON security.departments(is_active);

-- [004] users

CREATE TABLE IF NOT EXISTS security.users (
id                          BIGINT GENERATED ALWAYS AS IDENTITY,
uuid                        UUID NOT NULL DEFAULT gen_random_uuid(),
institution_id             BIGINT NOT NULL,
department_id              BIGINT,
username                   CITEXT NOT NULL,
email                      CITEXT NOT NULL,
password_hash              TEXT NOT NULL,
first_name_ar              VARCHAR(150),
last_name_ar               VARCHAR(150),
first_name_en              VARCHAR(150),
last_name_en               VARCHAR(150),
mobile                     VARCHAR(50),
status                     VARCHAR(30) NOT NULL DEFAULT 'ACTIVE',
last_login_at             TIMESTAMPTZ,
is_locked                  BOOLEAN NOT NULL DEFAULT FALSE,
is_email_verified          BOOLEAN NOT NULL DEFAULT FALSE,
created_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at                TIMESTAMPTZ,
CONSTRAINT pk_users       PRIMARY KEY (id),
CONSTRAINT uq_users_uuid  UNIQUE (uuid),
CONSTRAINT uq_users_username UNIQUE (username),
CONSTRAINT uq_users_email UNIQUE (email),
CONSTRAINT fk_users_institution FOREIGN KEY (institution_id) REFERENCES security.institutions(id),
CONSTRAINT fk_users_department FOREIGN KEY (department_id) REFERENCES security.departments(id),
CONSTRAINT chk_users_status  CHECK (status IN ('ACTIVE', 'INACTIVE','LOCKED','SUSPENDED'))
);

CREATE INDEX idx_users_institution ON security.users(institution_id);
CREATE INDEX idx_users_department ON security.users(department_id);
CREATE INDEX idx_users_status ON security.users(status);
CREATE INDEX idx_users_last_login ON security.users(last_login_at);

-- [005] user_profiles

CREATE TABLE IF NOT EXISTS security.user_profiles (
id                      BIGINT GENERATED ALWAYS AS IDENTITY,
user_id                 BIGINT NOT NULL,
national_id             VARCHAR(50),
passport_number         VARCHAR(50),
gender                  VARCHAR(20),
date_of_birth           DATE,
nationality_code        VARCHAR(10),
academic_title          VARCHAR(200),
specialization          VARCHAR(300),
biography               TEXT,
cv_document_id          BIGINT,
created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at              TIMESTAMPTZ,
CONSTRAINT pk_user_profiles PRIMARY KEY (id),
CONSTRAINT uq_user_profiles_user UNIQUE (user_id),
CONSTRAINT fk_user_profiles_user FOREIGN KEY (user_id) REFERENCES security.users(id) ON DELETE CASCADE,
CONSTRAINT chk_user_profiles_gender CHECK ( gender IS NULL OR gender IN ('MALE','FEMALE'))
);

CREATE INDEX idx_user_profiles_national_id ON security.user_profiles(national_id);
CREATE INDEX idx_user_profiles_specialization ON security.user_profiles(specialization);

-- [006] roles

CREATE TABLE IF NOT EXISTS security.roles (
id                  BIGINT GENERATED ALWAYS AS IDENTITY,
code                VARCHAR(100) NOT NULL,
name_ar             VARCHAR(200) NOT NULL,
name_en             VARCHAR(200),
description         TEXT,
is_system_role      BOOLEAN NOT NULL DEFAULT FALSE,
is_active           BOOLEAN NOT NULL DEFAULT TRUE,
created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
updated_at          TIMESTAMPTZ,
CONSTRAINT pk_roles PRIMARY KEY (id),
CONSTRAINT uq_roles_code UNIQUE (code)
);

CREATE INDEX idx_roles_active ON security.roles(is_active);

-- [007] permissions

CREATE TABLE IF NOT EXISTS security.permissions (
id                  BIGINT GENERATED ALWAYS AS IDENTITY,
permission_code     VARCHAR(150) NOT NULL,
module_name         VARCHAR(100) NOT NULL,
action_name         VARCHAR(100) NOT NULL,
description         TEXT,
created_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
CONSTRAINT pk_permissions PRIMARY KEY (id),
CONSTRAINT uq_permissions_code UNIQUE(permission_code)
);

CREATE INDEX idx_permissions_module ON security.permissions(module_name);

-- [008] role_permissions

CREATE TABLE IF NOT EXISTS security.role_permissions (
role_id             BIGINT NOT NULL,
permission_id       BIGINT NOT NULL,
granted_at          TIMESTAMPTZ NOT NULL DEFAULT now(),
CONSTRAINT pk_role_permissions PRIMARY KEY(role_id, permission_id),
CONSTRAINT fk_role_permissions_role FOREIGN KEY(role_id) REFERENCES security.roles(id) ON DELETE CASCADE,
CONSTRAINT fk_role_permissions_permission FOREIGN KEY(permission_id) REFERENCES security.permissions(id) ON DELETE CASCADE
);

CREATE INDEX idx_role_permissions_permission ON security.role_permissions(permission_id);

-- [009] user_roles

CREATE TABLE IF NOT EXISTS security.user_roles (
id                  BIGINT GENERATED ALWAYS AS IDENTITY,
user_id             BIGINT NOT NULL,
role_id             BIGINT NOT NULL,
assigned_at         TIMESTAMPTZ NOT NULL DEFAULT now(),
expires_at          TIMESTAMPTZ,
assigned_by         BIGINT,
CONSTRAINT pk_user_roles PRIMARY KEY(id),
CONSTRAINT uq_user_role  UNIQUE(user_id, role_id),
CONSTRAINT fk_user_roles_user FOREIGN KEY(user_id) REFERENCES security.users(id) ON DELETE CASCADE,
CONSTRAINT fk_user_roles_role FOREIGN KEY(role_id) REFERENCES security.roles(id) ON DELETE CASCADE
);

CREATE INDEX idx_user_roles_user ON security.user_roles(user_id);
CREATE INDEX idx_user_roles_role ON security.user_roles(role_id);

-- [010] sessions

CREATE TABLE IF NOT EXISTS security.sessions (
id                      BIGINT GENERATED ALWAYS AS IDENTITY,
user_id                 BIGINT NOT NULL,
session_token           UUID NOT NULL DEFAULT gen_random_uuid(),
ip_address              INET,
user_agent              TEXT,
login_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
expires_at              TIMESTAMPTZ NOT NULL,
revoked_at              TIMESTAMPTZ,
CONSTRAINT pk_sessions  PRIMARY KEY(id),
CONSTRAINT uq_session_token UNIQUE(session_token),
CONSTRAINT fk_sessions_user FOREIGN KEY(user_id) REFERENCES security.users(id) ON DELETE CASCADE
);

CREATE INDEX idx_sessions_user ON security.sessions(user_id);
CREATE INDEX idx_sessions_expiry ON security.sessions(expires_at);

-- [011] api_keys

CREATE TABLE IF NOT EXISTS security.api_keys (
id                      BIGINT GENERATED ALWAYS AS IDENTITY,
user_id                 BIGINT NOT NULL,
key_name                VARCHAR(200) NOT NULL,
api_key_hash            TEXT NOT NULL,
expires_at              TIMESTAMPTZ,
is_active               BOOLEAN NOT NULL DEFAULT TRUE,
created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
CONSTRAINT pk_api_keys  PRIMARY KEY(id),
CONSTRAINT fk_api_keys_user FOREIGN KEY(user_id) REFERENCES security.users(id) ON DELETE CASCADE
);

CREATE INDEX idx_api_keys_user ON security.api_keys(user_id);
CREATE INDEX idx_api_keys_active ON security.api_keys(is_active);

-- [012] password_history

CREATE TABLE IF NOT EXISTS security.password_history (
id                      BIGINT GENERATED ALWAYS AS IDENTITY,
user_id                 BIGINT NOT NULL,
password_hash           TEXT NOT NULL,
changed_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
CONSTRAINT pk_password_history PRIMARY KEY(id),
CONSTRAINT fk_password_history_user FOREIGN KEY(user_id) REFERENCES security.users(id) ON DELETE CASCADE
);

CREATE INDEX idx_password_history_user ON security.password_history(user_id);

-- [013] login_audit

CREATE TABLE IF NOT EXISTS security.login_audit(
id                      BIGINT GENERATED ALWAYS AS IDENTITY,
user_id                 BIGINT,
username_attempt        VARCHAR(255),
login_time              TIMESTAMPTZ NOT NULL DEFAULT now(),
success                 BOOLEAN NOT NULL,
ip_address              INET,
failure_reason          VARCHAR(500),
CONSTRAINT pk_login_audit PRIMARY KEY(id),
CONSTRAINT fk_login_audit_user FOREIGN KEY(user_id) REFERENCES security.users(id) ON DELETE SET NULL
);

CREATE INDEX idx_login_audit_time ON security.login_audit(login_time DESC);
CREATE INDEX idx_login_audit_success ON security.login_audit(success);

-- [014] access_policies

CREATE TABLE IF NOT EXISTS security.access_policies (
id                      BIGINT GENERATED ALWAYS AS IDENTITY,
policy_code             VARCHAR(100) NOT NULL,
policy_name             VARCHAR(200) NOT NULL,
target_resource         VARCHAR(200) NOT NULL,
policy_expression       JSONB NOT NULL,
is_active               BOOLEAN NOT NULL DEFAULT TRUE,
created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
CONSTRAINT pk_access_policies PRIMARY KEY(id),
CONSTRAINT uq_access_policy_code UNIQUE(policy_code)
);

CREATE INDEX idx_access_policy_active ON security.access_policies(is_active); 
CREATE INDEX idx_access_policy_expression ON security.access_policies USING GIN(policy_expression);

-- [015] security_events

CREATE TABLE IF NOT EXISTS security.security_events (
id                      BIGINT GENERATED ALWAYS AS IDENTITY,
event_type              VARCHAR(100) NOT NULL,
severity                VARCHAR(20) NOT NULL,
user_id                 BIGINT,
source_ip               INET,
details                 JSONB,
event_time              TIMESTAMPTZ NOT NULL DEFAULT now(),
CONSTRAINT pk_security_events PRIMARY KEY(id),
CONSTRAINT fk_security_events_user FOREIGN KEY(user_id) REFERENCES security.users(id) ON DELETE SET NULL,
CONSTRAINT chk_security_events_severity CHECK ( severity IN ('LOW','MEDIUM','HIGH','CRITICAL'))
);

CREATE INDEX idx_security_events_time ON security.security_events(event_time DESC);
CREATE INDEX idx_security_events_severity ON security.security_events(severity);
CREATE INDEX idx_security_events_details ON security.security_events USING GIN(details);


-- [016] projects

CREATE TABLE IF NOT EXISTS core.projects(
    id                         BIGINT GENERATED ALWAYS AS IDENTITY,
    institution_id             BIGINT NOT NULL,
    project_code               VARCHAR(100) NOT NULL,
    title_ar                   VARCHAR(1000) NOT NULL,
    title_en                   VARCHAR(1000),
    abstract_ar                TEXT,
    abstract_en                TEXT,
    objectives                 TEXT,
    principal_investigator_id  BIGINT NOT NULL,
    research_category          VARCHAR(100),
    risk_level                 VARCHAR(50),
    status_code                VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    start_date                 DATE,
    expected_end_date          DATE,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                 TIMESTAMPTZ,
    CONSTRAINT pk_projects PRIMARY KEY(id),
    CONSTRAINT uq_projects_code UNIQUE(project_code),
    CONSTRAINT fk_projects_institution FOREIGN KEY(institution_id) REFERENCES security.institutions(id),
    CONSTRAINT fk_projects_pi FOREIGN KEY(principal_investigator_id) REFERENCES security.users(id)
);

CREATE INDEX idx_projects_institution ON core.projects(institution_id);
CREATE INDEX idx_projects_status ON core.projects(status_code);
CREATE INDEX idx_projects_pi ON core.projects(principal_investigator_id);

-- [017] project_versions

CREATE TABLE IF NOT EXISTS core.project_versions(
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    project_id                  BIGINT NOT NULL,
    version_no                  INTEGER NOT NULL,
    version_notes               TEXT,
    snapshot_data               JSONB NOT NULL,
    created_by                  BIGINT NOT NULL,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_project_versions PRIMARY KEY(id),
    CONSTRAINT uq_project_version UNIQUE(project_id, version_no),
    CONSTRAINT fk_project_versions_project FOREIGN KEY(project_id) REFERENCES core.projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_project_versions_project ON core.project_versions(project_id);

-- [018] project_team_members

CREATE TABLE IF NOT EXISTS core.project_team_members(
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    project_id                  BIGINT NOT NULL,
    user_id                     BIGINT NOT NULL,
    role_name                   VARCHAR(200) NOT NULL,
    is_active                   BOOLEAN NOT NULL DEFAULT TRUE,
    assigned_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_project_team_members  PRIMARY KEY(id),
    CONSTRAINT uq_project_member UNIQUE(project_id, user_id),
    CONSTRAINT fk_project_member_project FOREIGN KEY(project_id) REFERENCES core.projects(id) ON DELETE CASCADE,
    CONSTRAINT fk_project_member_user FOREIGN KEY(user_id) REFERENCES security.users(id)
);

CREATE INDEX idx_project_team_project ON core.project_team_members(project_id);

-- [019] project_funding_sources

CREATE TABLE IF NOT EXISTS core.project_funding_sources(
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    project_id                  BIGINT NOT NULL,
    funding_source_name         VARCHAR(500) NOT NULL,
    funding_type                VARCHAR(100),
    amount                      NUMERIC(18,2),
    currency_code               VARCHAR(10),
    funding_reference           VARCHAR(200),
    CONSTRAINT pk_project_funding_sources  PRIMARY KEY(id),
    CONSTRAINT fk_project_funding_project FOREIGN KEY(project_id) REFERENCES core.projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_project_funding_project ON core.project_funding_sources(project_id);

-- [020] project_sites

CREATE TABLE IF NOT EXISTS core.project_sites(
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    project_id                  BIGINT NOT NULL,
    site_name                   VARCHAR(500) NOT NULL,
    governorate                 VARCHAR(100),
    address                     TEXT,
    expected_participants       INTEGER,
    CONSTRAINT pk_project_sites  PRIMARY KEY(id),
    CONSTRAINT fk_project_sites_project FOREIGN KEY(project_id) REFERENCES core.projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_project_sites_project ON core.project_sites(project_id);

-- [021] project_site_investigators

CREATE TABLE IF NOT EXISTS core.project_site_investigators (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    site_id                     BIGINT NOT NULL,
    investigator_id             BIGINT NOT NULL,
    is_site_lead                BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_project_site_investigators  PRIMARY KEY(id),
    CONSTRAINT fk_site_inv_site FOREIGN KEY(site_id) REFERENCES core.project_sites(id) ON DELETE CASCADE,
    CONSTRAINT fk_site_inv_user FOREIGN KEY(investigator_id) REFERENCES security.users(id)
);

CREATE INDEX idx_site_investigator_site ON core.project_site_investigators(site_id);

-- [022] project_keywords

CREATE TABLE IF NOT EXISTS core.project_keywords (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    project_id                  BIGINT NOT NULL,
    keyword                     VARCHAR(200) NOT NULL,
    CONSTRAINT pk_project_keywords  PRIMARY KEY(id),
    CONSTRAINT fk_project_keywords_project FOREIGN KEY(project_id) REFERENCES core.projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_project_keywords_project ON core.project_keywords(project_id);

-- [023] project_attachments

CREATE TABLE IF NOT EXISTS core.project_attachments (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    project_id                  BIGINT NOT NULL,
    document_name               VARCHAR(500) NOT NULL,
    file_path                   TEXT NOT NULL,
    file_size                   BIGINT,
    mime_type                   VARCHAR(200),
    uploaded_by                 BIGINT,
    uploaded_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_project_attachments  PRIMARY KEY(id),
    CONSTRAINT fk_project_attachment_project FOREIGN KEY(project_id) REFERENCES core.projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_project_attachments_project ON core.project_attachments(project_id);

-- [024] project_status_history

CREATE TABLE IF NOT EXISTS core.project_status_history(
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    project_id                  BIGINT NOT NULL,
    old_status                  VARCHAR(50),
    new_status                  VARCHAR(50) NOT NULL,
    changed_by                  BIGINT,
    changed_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    remarks                     TEXT,
    CONSTRAINT pk_project_status_history  PRIMARY KEY(id),
    CONSTRAINT fk_project_status_history_project FOREIGN KEY(project_id) REFERENCES core.projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_project_status_history_project ON core.project_status_history(project_id);

-- [025] project_tags

CREATE TABLE IF NOT EXISTS core.project_tags(
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    project_id                  BIGINT NOT NULL,
    tag_name                    VARCHAR(100) NOT NULL,
    CONSTRAINT pk_project_tags  PRIMARY KEY(id),
    CONSTRAINT fk_project_tags_project FOREIGN KEY(project_id) REFERENCES core.projects(id) ON DELETE CASCADE
);

CREATE INDEX idx_project_tags_project ON core.project_tags(project_id);



-- [026] applications

CREATE TABLE IF NOT EXISTS core.applications (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_number              VARCHAR(100) NOT NULL,
    project_id                       BIGINT NOT NULL,
    application_type                VARCHAR(50) NOT NULL,
    current_status                  VARCHAR(50) NOT NULL DEFAULT 'DRAFT',
    submission_date                 TIMESTAMPTZ,
    submitted_by                    BIGINT,
    priority_level                  VARCHAR(50),
    target_committee_id             BIGINT,
    remarks                         TEXT,
    created_at                      TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at                      TIMESTAMPTZ,
    CONSTRAINT pk_applications PRIMARY KEY(id),
    CONSTRAINT uq_applications_number UNIQUE(application_number),
    CONSTRAINT fk_applications_project FOREIGN KEY(project_id) REFERENCES core.projects(id)  ON DELETE CASCADE,
    CONSTRAINT fk_applications_user FOREIGN KEY(submitted_by) REFERENCES security.users(id)
);

CREATE INDEX idx_applications_project ON core.applications(project_id);
CREATE INDEX idx_applications_status ON core.applications(current_status);
CREATE INDEX idx_applications_submission_date ON core.applications(submission_date);

-- [027] application_versions

CREATE TABLE IF NOT EXISTS core.application_versions (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id                  BIGINT NOT NULL,
    version_no                      INTEGER NOT NULL,
    snapshot_data                   JSONB NOT NULL,
    created_by                      BIGINT NOT NULL,
    created_at                      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_application_versions PRIMARY KEY(id),
    CONSTRAINT uq_application_versions UNIQUE(application_id, version_no),
    CONSTRAINT fk_application_versions_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_application_versions_application ON core.application_versions(application_id);

-- [028] application_sections

CREATE TABLE IF NOT EXISTS core.application_sections (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id                  BIGINT NOT NULL,
    section_code                    VARCHAR(100) NOT NULL,
    section_name                    VARCHAR(300) NOT NULL,
    completion_percentage           NUMERIC(5,2) DEFAULT 0,
    status_code                     VARCHAR(50) DEFAULT 'INCOMPLETE',
    created_at                      TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_application_sections PRIMARY KEY(id),
    CONSTRAINT fk_application_sections_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_application_sections_application ON core.application_sections(application_id);

-- [029] application_amendments

CREATE TABLE IF NOT EXISTS core.application_amendments (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id                  BIGINT NOT NULL,
    amendment_number                VARCHAR(100) NOT NULL,
    amendment_reason                TEXT NOT NULL,
    amendment_description           TEXT,
    submitted_by                    BIGINT,
    submitted_at                    TIMESTAMPTZ,
    status_code                     VARCHAR(50) DEFAULT 'DRAFT',
    CONSTRAINT pk_application_amendments PRIMARY KEY(id),
    CONSTRAINT fk_application_amendments_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_application_amendments_application ON core.application_amendments(application_id);

-- [030] amendment_requests

CREATE TABLE IF NOT EXISTS core.amendment_requests (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    amendment_id                    BIGINT NOT NULL,
    request_date                    TIMESTAMPTZ NOT NULL DEFAULT now(),
    request_status                  VARCHAR(50) NOT NULL,
    decision_date                   TIMESTAMPTZ,
    comments                        TEXT,
    CONSTRAINT pk_amendment_requests PRIMARY KEY(id),
    CONSTRAINT fk_amendment_requests_amendment FOREIGN KEY(amendment_id) REFERENCES core.application_amendments(id)  ON DELETE CASCADE
);

CREATE INDEX idx_amendment_requests_status ON core.amendment_requests(request_status);

-- [031] renewal_requests

CREATE TABLE IF NOT EXISTS core.renewal_requests (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id                  BIGINT NOT NULL,
    renewal_period_months           INTEGER,
    justification                   TEXT,
    submitted_at                    TIMESTAMPTZ,
    status_code                     VARCHAR(50),
    CONSTRAINT pk_renewal_requests PRIMARY KEY(id),
    CONSTRAINT fk_renewal_requests_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_renewal_requests_application ON core.renewal_requests(application_id);

-- [032] closure_requests

CREATE TABLE IF NOT EXISTS core.closure_requests (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id                  BIGINT NOT NULL,
    closure_reason                  TEXT NOT NULL,
    closure_summary                 TEXT,
    submitted_at                    TIMESTAMPTZ,
    status_code                     VARCHAR(50),
    CONSTRAINT pk_closure_requests PRIMARY KEY(id),
    CONSTRAINT fk_closure_requests_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_closure_requests_application ON core.closure_requests(application_id);

-- [033] application_checklists

CREATE TABLE IF NOT EXISTS core.application_checklists (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id                  BIGINT NOT NULL,
    checklist_item                  VARCHAR(500) NOT NULL,
    is_completed                    BOOLEAN NOT NULL DEFAULT FALSE,
    completed_at                    TIMESTAMPTZ,
    completed_by                    BIGINT,
    CONSTRAINT pk_application_checklists PRIMARY KEY(id),
    CONSTRAINT fk_application_checklists_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_application_checklists_application ON core.application_checklists(application_id);

-- [034] application_validations

CREATE TABLE IF NOT EXISTS core.application_validations (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id                  BIGINT NOT NULL,
    validation_rule                 VARCHAR(300) NOT NULL,
    validation_result               BOOLEAN NOT NULL,
    validation_message              TEXT,
    validated_at                    TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_application_validations PRIMARY KEY(id),
    CONSTRAINT fk_application_validations_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_application_validations_application ON core.application_validations(application_id);

-- [035] application_history

CREATE TABLE IF NOT EXISTS core.application_history (
    id                              BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id                  BIGINT NOT NULL,
    action_type                     VARCHAR(100) NOT NULL,
    old_value                       TEXT,
    new_value                       TEXT,
    action_by                       BIGINT,
    action_at                       TIMESTAMPTZ NOT NULL DEFAULT now(),
    remarks                         TEXT,
    CONSTRAINT pk_application_history PRIMARY KEY(id),
    CONSTRAINT fk_application_history_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_application_history_application ON core.application_history(application_id);
CREATE INDEX idx_application_history_action_at ON core.application_history(action_at);

/*ممتاز. قبل الاستمرار، هناك ملاحظة معمارية مهمة:
 في الجداول السابقة استخدمنا بعض الحقول النصية مثل:
application_type
status_code
priority_level
research_category
risk_level


وفي النسخة الإنتاجية النهائية سنقوم باستبدالها لاحقاً بـ FK إلى جداول Reference Data (الجداول 115–130). سأستمر حالياً حتى لا نكسر تسلسل البناء.
*/
-- [036] scientific_reviews

CREATE TABLE IF NOT EXISTS committee.scientific_reviews (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    reviewer_id                BIGINT NOT NULL,
    review_status              VARCHAR(50) NOT NULL DEFAULT 'ASSIGNED',
    recommendation             VARCHAR(100),
    summary                    TEXT,
    started_at                 TIMESTAMPTZ,
    completed_at               TIMESTAMPTZ,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_scientific_reviews PRIMARY KEY(id),
    CONSTRAINT fk_scientific_reviews_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE,
    CONSTRAINT fk_scientific_reviews_reviewer FOREIGN KEY(reviewer_id) REFERENCES security.users(id)
);

CREATE INDEX idx_scientific_reviews_application ON committee.scientific_reviews(application_id);
CREATE INDEX idx_scientific_reviews_reviewer ON committee.scientific_reviews(reviewer_id);

-- [037] ethics_reviews

CREATE TABLE IF NOT EXISTS committee.ethics_reviews (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    reviewer_id                BIGINT NOT NULL,
    review_status              VARCHAR(50) NOT NULL DEFAULT 'ASSIGNED',
    recommendation             VARCHAR(100),
    ethical_risk_assessment    TEXT,
    summary                    TEXT,
    started_at                 TIMESTAMPTZ,
    completed_at               TIMESTAMPTZ,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_ethics_reviews PRIMARY KEY(id),
    CONSTRAINT fk_ethics_reviews_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE,
    CONSTRAINT fk_ethics_reviews_reviewer FOREIGN KEY(reviewer_id) REFERENCES security.users(id)
);

CREATE INDEX idx_ethics_reviews_application ON committee.ethics_reviews(application_id);
CREATE INDEX idx_ethics_reviews_reviewer ON committee.ethics_reviews(reviewer_id);

-- [038] review_assignments

CREATE TABLE IF NOT EXISTS committee.review_assignments (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    reviewer_id                BIGINT NOT NULL,
    review_type                VARCHAR(50) NOT NULL,
    assigned_by                BIGINT,
    assigned_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    due_date                   TIMESTAMPTZ,
    status_code                VARCHAR(50) DEFAULT 'ASSIGNED',
    CONSTRAINT pk_review_assignments PRIMARY KEY(id),
    CONSTRAINT fk_review_assignments_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE,
    CONSTRAINT fk_review_assignments_reviewer FOREIGN KEY(reviewer_id) REFERENCES security.users(id)
);

CREATE INDEX idx_review_assignments_application ON committee.review_assignments(application_id);
CREATE INDEX idx_review_assignments_reviewer ON committee.review_assignments(reviewer_id);

-- [039] review_forms

CREATE TABLE IF NOT EXISTS committee.review_forms (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    form_code                  VARCHAR(100) NOT NULL,
    form_name                  VARCHAR(300) NOT NULL,
    review_type                VARCHAR(50) NOT NULL,
    version_no                 INTEGER NOT NULL DEFAULT 1,
    is_active                  BOOLEAN NOT NULL DEFAULT TRUE,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_review_forms PRIMARY KEY(id),
    CONSTRAINT uq_review_forms_code UNIQUE(form_code, version_no)
);

-- [040] review_questions

CREATE TABLE IF NOT EXISTS committee.review_questions (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    form_id                     BIGINT NOT NULL,
    question_code               VARCHAR(100) NOT NULL,
    question_text               TEXT NOT NULL,
    question_type               VARCHAR(50) NOT NULL,
    display_order               INTEGER NOT NULL,
    is_required                 BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_review_questions PRIMARY KEY(id),
    CONSTRAINT fk_review_questions_form FOREIGN KEY(form_id) REFERENCES committee.review_forms(id)  ON DELETE CASCADE
);

CREATE INDEX idx_review_questions_form ON committee.review_questions(form_id);

-- [041] review_answers

CREATE TABLE IF NOT EXISTS committee.review_answers (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    review_id                   BIGINT NOT NULL,
    review_type                 VARCHAR(50) NOT NULL,
    question_id                 BIGINT NOT NULL,
    answer_text                 TEXT,
    answer_score                NUMERIC(10,2),
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_review_answers PRIMARY KEY(id),
    CONSTRAINT fk_review_answers_question FOREIGN KEY(question_id) REFERENCES committee.review_questions(id)  ON DELETE CASCADE
);

CREATE INDEX idx_review_answers_question ON committee.review_answers(question_id);

-- [042] review_scores

CREATE TABLE IF NOT EXISTS committee.review_scores (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    reviewer_id                BIGINT NOT NULL,
    review_type                VARCHAR(50) NOT NULL,
    score                      NUMERIC(10,2) NOT NULL,
    calculated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_review_scores PRIMARY KEY(id),
    CONSTRAINT fk_review_scores_application FOREIGN KEY(application_id) REFERENCES core.applications(id)
);

CREATE INDEX idx_review_scores_application ON committee.review_scores(application_id);

-- [043] review_comments

CREATE TABLE IF NOT EXISTS committee.review_comments (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    reviewer_id                BIGINT NOT NULL,
    comment_text               TEXT NOT NULL,
    is_internal                BOOLEAN NOT NULL DEFAULT TRUE,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_review_comments PRIMARY KEY(id),
    CONSTRAINT fk_review_comments_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_review_comments_application ON committee.review_comments(application_id);

-- [044] review_recommendations

CREATE TABLE IF NOT EXISTS committee.review_recommendations (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    reviewer_id                BIGINT NOT NULL,
    recommendation_type        VARCHAR(100) NOT NULL,
    justification              TEXT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_review_recommendations PRIMARY KEY(id),
    CONSTRAINT fk_review_recommendations_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_review_recommendations_application ON committee.review_recommendations(application_id);

-- [045] review_conflicts

CREATE TABLE IF NOT EXISTS committee.review_conflicts (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    reviewer_id                BIGINT NOT NULL,
    conflict_type              VARCHAR(100) NOT NULL,
    description                TEXT,
    declared_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    approved_by                BIGINT,
    CONSTRAINT pk_review_conflicts PRIMARY KEY(id),
    CONSTRAINT fk_review_conflicts_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_review_conflicts_application ON committee.review_conflicts(application_id);
CREATE INDEX idx_review_conflicts_reviewer ON committee.review_conflicts(reviewer_id);


/* ملاحظة هندسية مهمة جداً
أثناء كتابة هذه المجموعة ظهر أن جدول:
sql
committee.review_answers
يحتوي على:
sql
review_id
review_type

وهذا تصميم مؤقت (Polymorphic Relation).
في النسخة الإنتاجية الأفضل أن ننشئ لاحقاً:
text
scientific_review_answers
ethics_review_answers
أو جدول موحد:
text
reviews
review_answers

لتجنب فقدان التكامل المرجعي FK Integrity.
سأقوم بمعالجة ذلك أثناء مرحلة Refactoring النهائية.
*/


-- [046] committees

CREATE TABLE IF NOT EXISTS committee.committees (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    institution_id             BIGINT NOT NULL,
    committee_code             VARCHAR(100) NOT NULL,
    committee_name_ar          VARCHAR(500) NOT NULL,
    committee_name_en          VARCHAR(500),
    committee_type_id          BIGINT,
    establishment_date         DATE,
    is_active                  BOOLEAN NOT NULL DEFAULT TRUE,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_committees PRIMARY KEY(id),
    CONSTRAINT uq_committees_code UNIQUE(committee_code),
    CONSTRAINT fk_committees_institution FOREIGN KEY(institution_id) REFERENCES security.institutions(id)
);

CREATE INDEX idx_committees_institution ON committee.committees(institution_id);

-- [047] committee_types

CREATE TABLE IF NOT EXISTS committee.committee_types (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    type_code                  VARCHAR(100) NOT NULL,
    type_name                  VARCHAR(300) NOT NULL,
    description                TEXT,
    CONSTRAINT pk_committee_types PRIMARY KEY(id),
    CONSTRAINT uq_committee_types_code UNIQUE(type_code)
);

-- [048] committee_members

CREATE TABLE IF NOT EXISTS committee.committee_members (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    committee_id               BIGINT NOT NULL,
    user_id                    BIGINT NOT NULL,
    membership_start_date      DATE NOT NULL,
    membership_end_date        DATE,
    is_active                  BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_committee_members PRIMARY KEY(id),
    CONSTRAINT uq_committee_member UNIQUE(committee_id, user_id),
    CONSTRAINT fk_committee_members_committee FOREIGN KEY(committee_id) REFERENCES committee.committees(id)  ON DELETE CASCADE,
    CONSTRAINT fk_committee_members_user FOREIGN KEY(user_id) REFERENCES security.users(id)
);

CREATE INDEX idx_committee_members_committee ON committee.committee_members(committee_id);

-- [049] committee_roles

CREATE TABLE IF NOT EXISTS committee.committee_roles (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    role_code                  VARCHAR(100) NOT NULL,
    role_name                  VARCHAR(200) NOT NULL,
    description                TEXT,
    CONSTRAINT pk_committee_roles PRIMARY KEY(id),
    CONSTRAINT uq_committee_roles_code UNIQUE(role_code)
);

-- [050] committee_meetings

CREATE TABLE IF NOT EXISTS committee.committee_meetings (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    committee_id               BIGINT NOT NULL,
    meeting_number             VARCHAR(100) NOT NULL,
    meeting_date               TIMESTAMPTZ NOT NULL,
    location                   VARCHAR(500),
    meeting_status             VARCHAR(50) NOT NULL DEFAULT 'SCHEDULED',
    chairperson_id             BIGINT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_committee_meetings PRIMARY KEY(id),
    CONSTRAINT fk_committee_meetings_committee FOREIGN KEY(committee_id) REFERENCES committee.committees(id)  ON DELETE CASCADE
);

CREATE INDEX idx_committee_meetings_committee ON committee.committee_meetings(committee_id);
CREATE INDEX idx_committee_meetings_date ON committee.committee_meetings(meeting_date);

-- [051] meeting_agendas

CREATE TABLE IF NOT EXISTS committee.meeting_agendas (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    meeting_id                 BIGINT NOT NULL,
    title                      VARCHAR(500) NOT NULL,
    description                TEXT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_meeting_agendas PRIMARY KEY(id),
    CONSTRAINT fk_meeting_agendas_meeting FOREIGN KEY(meeting_id) REFERENCES committee.committee_meetings(id)  ON DELETE CASCADE
);

CREATE INDEX idx_meeting_agendas_meeting ON committee.meeting_agendas(meeting_id);

-- [052] agenda_items

CREATE TABLE IF NOT EXISTS committee.agenda_items (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    agenda_id                  BIGINT NOT NULL,
    application_id             BIGINT,
    item_order                 INTEGER NOT NULL,
    title                      VARCHAR(500) NOT NULL,
    discussion_notes           TEXT,
    CONSTRAINT pk_agenda_items PRIMARY KEY(id),
    CONSTRAINT fk_agenda_items_agenda FOREIGN KEY(agenda_id) REFERENCES committee.meeting_agendas(id)  ON DELETE CASCADE,
    CONSTRAINT fk_agenda_items_application FOREIGN KEY(application_id) REFERENCES core.applications(id)
);

CREATE INDEX idx_agenda_items_agenda ON committee.agenda_items(agenda_id);

-- [053] meeting_minutes

CREATE TABLE IF NOT EXISTS committee.meeting_minutes (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    meeting_id                 BIGINT NOT NULL,
    minutes_text               TEXT NOT NULL,
    approved_by                BIGINT,
    approved_at                TIMESTAMPTZ,
    CONSTRAINT pk_meeting_minutes PRIMARY KEY(id),
    CONSTRAINT fk_meeting_minutes_meeting FOREIGN KEY(meeting_id) REFERENCES committee.committee_meetings(id)  ON DELETE CASCADE
);

CREATE INDEX idx_meeting_minutes_meeting ON committee.meeting_minutes(meeting_id);

-- [054] voting_sessions

CREATE TABLE IF NOT EXISTS committee.voting_sessions (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    meeting_id                 BIGINT NOT NULL,
    voting_type                VARCHAR(50) NOT NULL,
    voting_start               TIMESTAMPTZ,
    voting_end                 TIMESTAMPTZ,
    status_code                VARCHAR(50) NOT NULL DEFAULT 'OPEN',
    CONSTRAINT pk_voting_sessions PRIMARY KEY(id),
    CONSTRAINT fk_voting_sessions_application FOREIGN KEY(application_id) REFERENCES core.applications(id),
    CONSTRAINT fk_voting_sessions_meeting FOREIGN KEY(meeting_id) REFERENCES committee.committee_meetings(id)
);

CREATE INDEX idx_voting_sessions_meeting ON committee.voting_sessions(meeting_id);

-- [055] votes

CREATE TABLE IF NOT EXISTS committee.votes (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    voting_session_id          BIGINT NOT NULL,
    voter_id                   BIGINT NOT NULL,
    vote_value                 VARCHAR(50) NOT NULL,
    vote_time                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    comments                   TEXT,
    CONSTRAINT pk_votes PRIMARY KEY(id),
    CONSTRAINT uq_vote_once UNIQUE(voting_session_id, voter_id),
    CONSTRAINT fk_votes_session FOREIGN KEY(voting_session_id) REFERENCES committee.voting_sessions(id)  ON DELETE CASCADE,
    CONSTRAINT fk_votes_voter FOREIGN KEY(voter_id) REFERENCES security.users(id)
);

CREATE INDEX idx_votes_session ON committee.votes(voting_session_id);

-- [056] quorum_logs

CREATE TABLE IF NOT EXISTS committee.quorum_logs (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    meeting_id                 BIGINT NOT NULL,
    total_members              INTEGER NOT NULL,
    present_members            INTEGER NOT NULL,
    quorum_required            INTEGER NOT NULL,
    quorum_achieved            BOOLEAN NOT NULL,
    calculated_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_quorum_logs PRIMARY KEY(id),
    CONSTRAINT fk_quorum_logs_meeting FOREIGN KEY(meeting_id) REFERENCES committee.committee_meetings(id)  ON DELETE CASCADE
);

CREATE INDEX idx_quorum_logs_meeting ON committee.quorum_logs(meeting_id);

-- [057] attendance_logs

CREATE TABLE IF NOT EXISTS committee.attendance_logs (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    meeting_id                 BIGINT NOT NULL,
    user_id                    BIGINT NOT NULL,
    attendance_status          VARCHAR(50) NOT NULL,
    check_in_time              TIMESTAMPTZ,
    remarks                    TEXT,
    CONSTRAINT pk_attendance_logs PRIMARY KEY(id),
    CONSTRAINT fk_attendance_logs_meeting FOREIGN KEY(meeting_id) REFERENCES committee.committee_meetings(id)  ON DELETE CASCADE,
    CONSTRAINT fk_attendance_logs_user FOREIGN KEY(user_id) REFERENCES security.users(id)
);

CREATE INDEX idx_attendance_logs_meeting ON committee.attendance_logs(meeting_id);
CREATE INDEX idx_attendance_logs_user ON committee.attendance_logs(user_id);


/*
ملاحظات هندسية يجب معالجتها لاحقاً
أثناء المراجعة ظهرت نقاط ستدخل ضمن **Refactoring Phase**:
1. علاقة committee_type
في جدول: committee.committees
لدينا: committee_type_id لكن لم نربطه بعد بـ FK.
يجب إضافة:

ALTER TABLE committee.committees
ADD CONSTRAINT fk_committees_type FOREIGN KEY (committee_type_id) REFERENCES committee.committee_types(id);

2. أدوار أعضاء اللجنة

حالياً لدينا:
committee_roles, committee_members

لكن لا يوجد جدول ربط.

سنضيف لاحقاً:
committee_member_roles

3. التصويت
القيم الحالية:
APPROVE
CONDITIONAL_APPROVAL
DEFER
REJECT
ABSTAIN
يجب نقلها لاحقاً إلى Reference Data.
*/

ALTER TABLE committee.committees
ADD CONSTRAINT fk_committees_type FOREIGN KEY (committee_type_id) REFERENCES committee.committee_types(id);


-- [058] workflows

CREATE TABLE IF NOT EXISTS workflow.workflows (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_code           VARCHAR(100) NOT NULL,
    workflow_name           VARCHAR(300) NOT NULL,
    entity_type             VARCHAR(100) NOT NULL,
    version_no              INTEGER NOT NULL DEFAULT 1,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_workflows PRIMARY KEY(id),
    CONSTRAINT uq_workflows_code_version UNIQUE(workflow_code, version_no)
);

CREATE INDEX idx_workflows_entity ON workflow.workflows(entity_type);

-- [059] workflow_states

CREATE TABLE IF NOT EXISTS workflow.workflow_states (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_id             BIGINT NOT NULL,
    state_code              VARCHAR(100) NOT NULL,
    state_name              VARCHAR(300) NOT NULL,
    is_initial              BOOLEAN NOT NULL DEFAULT FALSE,
    is_terminal             BOOLEAN NOT NULL DEFAULT FALSE,
    display_order           INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT pk_workflow_states PRIMARY KEY(id),
    CONSTRAINT uq_workflow_state UNIQUE(workflow_id, state_code),
    CONSTRAINT fk_workflow_states_workflow FOREIGN KEY(workflow_id) REFERENCES workflow.workflows(id)  ON DELETE CASCADE
);

CREATE INDEX idx_workflow_states_workflow ON workflow.workflow_states(workflow_id);

-- [060] workflow_transitions

CREATE TABLE IF NOT EXISTS workflow.workflow_transitions (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_id             BIGINT NOT NULL,
    from_state_id           BIGINT NOT NULL,
    to_state_id             BIGINT NOT NULL,
    transition_code         VARCHAR(100) NOT NULL,
    transition_name         VARCHAR(300) NOT NULL,
    requires_comment        BOOLEAN NOT NULL DEFAULT FALSE,
    requires_vote           BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_workflow_transitions PRIMARY KEY(id),
    CONSTRAINT fk_transition_workflow FOREIGN KEY(workflow_id) REFERENCES workflow.workflows(id),
    CONSTRAINT fk_transition_from_state FOREIGN KEY(from_state_id) REFERENCES workflow.workflow_states(id),
    CONSTRAINT fk_transition_to_state FOREIGN KEY(to_state_id) REFERENCES workflow.workflow_states(id)
);

CREATE INDEX idx_workflow_transitions_workflow ON workflow.workflow_transitions(workflow_id);

-- [061] workflow_instances

CREATE TABLE IF NOT EXISTS workflow.workflow_instances (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_id             BIGINT NOT NULL,
    entity_type             VARCHAR(100) NOT NULL,
    entity_id               BIGINT NOT NULL,
    current_state_id        BIGINT NOT NULL,
    started_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    completed_at            TIMESTAMPTZ,
    status_code             VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    CONSTRAINT pk_workflow_instances PRIMARY KEY(id),
    CONSTRAINT fk_workflow_instances_workflow FOREIGN KEY(workflow_id) REFERENCES workflow.workflows(id),
    CONSTRAINT fk_workflow_instances_state FOREIGN KEY(current_state_id) REFERENCES workflow.workflow_states(id)
);

CREATE INDEX idx_workflow_instances_entity ON workflow.workflow_instances(entity_type, entity_id);
CREATE INDEX idx_workflow_instances_state ON workflow.workflow_instances(current_state_id);

-- [062] workflow_tasks

CREATE TABLE IF NOT EXISTS workflow.workflow_tasks (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_instance_id    BIGINT NOT NULL,
    task_code               VARCHAR(100) NOT NULL,
    task_name               VARCHAR(300) NOT NULL,
    assigned_to             BIGINT,
    due_date                TIMESTAMPTZ,
    completed_at            TIMESTAMPTZ,
    task_status             VARCHAR(50) NOT NULL DEFAULT 'OPEN',
    CONSTRAINT pk_workflow_tasks PRIMARY KEY(id),
    CONSTRAINT fk_workflow_tasks_instance FOREIGN KEY(workflow_instance_id) REFERENCES workflow.workflow_instances(id)  ON DELETE CASCADE,
    CONSTRAINT fk_workflow_tasks_user FOREIGN KEY(assigned_to) REFERENCES security.users(id)
);

CREATE INDEX idx_workflow_tasks_instance ON workflow.workflow_tasks(workflow_instance_id);
CREATE INDEX idx_workflow_tasks_user ON workflow.workflow_tasks(assigned_to);

-- [063] workflow_actions

CREATE TABLE IF NOT EXISTS workflow.workflow_actions (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_instance_id    BIGINT NOT NULL,
    transition_id           BIGINT NOT NULL,
    action_by               BIGINT NOT NULL,
    action_comment          TEXT,
    action_date             TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_workflow_actions PRIMARY KEY(id),
    CONSTRAINT fk_workflow_actions_instance FOREIGN KEY(workflow_instance_id) REFERENCES workflow.workflow_instances(id)  ON DELETE CASCADE,
    CONSTRAINT fk_workflow_actions_transition FOREIGN KEY(transition_id) REFERENCES workflow.workflow_transitions(id),
    CONSTRAINT fk_workflow_actions_user FOREIGN KEY(action_by) REFERENCES security.users(id)
);

CREATE INDEX idx_workflow_actions_instance ON workflow.workflow_actions(workflow_instance_id);

-- [064] workflow_history

CREATE TABLE IF NOT EXISTS workflow.workflow_history (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_instance_id    BIGINT NOT NULL,
    from_state_id           BIGINT,
    to_state_id             BIGINT,
    transition_id           BIGINT,
    action_by               BIGINT,
    action_date             TIMESTAMPTZ NOT NULL DEFAULT now(),
    comments                TEXT,
    CONSTRAINT pk_workflow_history PRIMARY KEY(id),
    CONSTRAINT fk_workflow_history_instance FOREIGN KEY(workflow_instance_id) REFERENCES workflow.workflow_instances(id)  ON DELETE CASCADE
);

CREATE INDEX idx_workflow_history_instance ON workflow.workflow_history(workflow_instance_id);

-- [065] workflow_escalations

CREATE TABLE IF NOT EXISTS workflow.workflow_escalations (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_task_id        BIGINT NOT NULL,
    escalation_level        INTEGER NOT NULL,
    escalated_to            BIGINT,
    escalation_reason       TEXT,
    escalated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_workflow_escalations PRIMARY KEY(id),
    CONSTRAINT fk_workflow_escalations_task FOREIGN KEY(workflow_task_id) REFERENCES workflow.workflow_tasks(id)  ON DELETE CASCADE
);

CREATE INDEX idx_workflow_escalations_task ON workflow.workflow_escalations(workflow_task_id);

-- [066] workflow_sla

CREATE TABLE IF NOT EXISTS workflow.workflow_sla (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_id             BIGINT NOT NULL,
    state_id                BIGINT NOT NULL,
    max_duration_hours      INTEGER NOT NULL,
    warning_hours           INTEGER,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_workflow_sla PRIMARY KEY(id),
    CONSTRAINT fk_workflow_sla_workflow FOREIGN KEY(workflow_id) REFERENCES workflow.workflows(id),
    CONSTRAINT fk_workflow_sla_state FOREIGN KEY(state_id) REFERENCES workflow.workflow_states(id)
);

CREATE INDEX idx_workflow_sla_workflow ON workflow.workflow_sla(workflow_id);

-- [067] workflow_comments

CREATE TABLE IF NOT EXISTS workflow.workflow_comments (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_instance_id    BIGINT NOT NULL,
    user_id                 BIGINT NOT NULL,
    comment_text            TEXT NOT NULL,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_workflow_comments PRIMARY KEY(id),
    CONSTRAINT fk_workflow_comments_instance FOREIGN KEY(workflow_instance_id) REFERENCES workflow.workflow_instances(id)  ON DELETE CASCADE,
    CONSTRAINT fk_workflow_comments_user FOREIGN KEY(user_id) REFERENCES security.users(id)
);

CREATE INDEX idx_workflow_comments_instance ON workflow.workflow_comments(workflow_instance_id);

-- [068] workflow_variables

CREATE TABLE IF NOT EXISTS workflow.workflow_variables (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    workflow_instance_id    BIGINT NOT NULL,
    variable_name           VARCHAR(200) NOT NULL,
    variable_value          JSONB,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_workflow_variables PRIMARY KEY(id),
    CONSTRAINT fk_workflow_variables_instance FOREIGN KEY(workflow_instance_id) REFERENCES workflow.workflow_instances(id)  ON DELETE CASCADE
);

CREATE INDEX idx_workflow_variables_instance ON workflow.workflow_variables(workflow_instance_id);
CREATE INDEX idx_workflow_variables_json ON workflow.workflow_variables USING GIN(variable_value);

/*
ملاحظات معمارية قبل المتابعة

أثناء البناء ظهرت عدة تحسينات سننفذها لاحقاً في مرحلة **Database Refactoring**:

1. إضافة `workflow_conditions`.
2. إضافة `workflow_role_assignments`.
3. إضافة `workflow_notifications`.
4. إضافة `workflow_deadlines`.
5. إضافة `workflow_parallel_branches`.
6. إضافة `workflow_decision_rules`.

هذه غالباً ستزيد عدد الجداول النهائية إلى أكثر من 135 جدولاً.
*/

-- [069] document_types

CREATE TABLE IF NOT EXISTS documents.document_types (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    type_code               VARCHAR(100) NOT NULL,
    type_name_ar            VARCHAR(300) NOT NULL,
    type_name_en            VARCHAR(300),
    description             TEXT,
    is_required             BOOLEAN NOT NULL DEFAULT FALSE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_document_types PRIMARY KEY(id),
    CONSTRAINT uq_document_types_code UNIQUE(type_code)
);

CREATE INDEX idx_document_types_code ON documents.document_types(type_code);

-- [070] documents

CREATE TABLE IF NOT EXISTS documents.documents (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    document_type_id        BIGINT NOT NULL,
    entity_type             VARCHAR(100) NOT NULL,
    entity_id               BIGINT NOT NULL,
    document_title          VARCHAR(1000) NOT NULL,
    file_name               VARCHAR(1000) NOT NULL,
    original_file_name      VARCHAR(1000),
    mime_type               VARCHAR(255),
    file_size_bytes         BIGINT,
    storage_provider        VARCHAR(100),
    storage_path            TEXT NOT NULL,
    checksum_sha256         VARCHAR(128),
    uploaded_by             BIGINT NOT NULL,
    uploaded_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_documents PRIMARY KEY(id),
    CONSTRAINT fk_documents_type FOREIGN KEY(document_type_id) REFERENCES documents.document_types(id),
    CONSTRAINT fk_documents_uploaded_by FOREIGN KEY(uploaded_by) REFERENCES security.users(id)
);

CREATE INDEX idx_documents_entity ON documents.documents(entity_type, entity_id);
CREATE INDEX idx_documents_type ON documents.documents(document_type_id);
CREATE INDEX idx_documents_active ON documents.documents(is_active);

-- [071] document_versions

CREATE TABLE IF NOT EXISTS documents.document_versions (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    document_id             BIGINT NOT NULL,
    version_no              INTEGER NOT NULL,
    file_name               VARCHAR(1000) NOT NULL,
    storage_path            TEXT NOT NULL,
    checksum_sha256         VARCHAR(128),
    uploaded_by             BIGINT NOT NULL,
    uploaded_at             TIMESTAMPTZ NOT NULL DEFAULT now(),
    version_notes           TEXT,
    CONSTRAINT pk_document_versions PRIMARY KEY(id),
    CONSTRAINT uq_document_versions UNIQUE(document_id, version_no),
    CONSTRAINT fk_document_versions_document FOREIGN KEY(document_id) REFERENCES documents.documents(id)  ON DELETE CASCADE,
    CONSTRAINT fk_document_versions_user FOREIGN KEY(uploaded_by) REFERENCES security.users(id)
);

CREATE INDEX idx_document_versions_document ON documents.document_versions(document_id);

-- [072] document_signatures

CREATE TABLE IF NOT EXISTS documents.document_signatures (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    document_id             BIGINT NOT NULL,
    signer_id               BIGINT NOT NULL,
    signature_type          VARCHAR(100) NOT NULL,
    signature_hash          TEXT,
    signed_at               TIMESTAMPTZ NOT NULL,
    certificate_serial      VARCHAR(500),
    CONSTRAINT pk_document_signatures PRIMARY KEY(id),
    CONSTRAINT fk_document_signatures_document FOREIGN KEY(document_id) REFERENCES documents.documents(id)  ON DELETE CASCADE,
    CONSTRAINT fk_document_signatures_signer FOREIGN KEY(signer_id) REFERENCES security.users(id)
);

CREATE INDEX idx_document_signatures_document ON documents.document_signatures(document_id);

-- [073] document_approvals

CREATE TABLE IF NOT EXISTS documents.document_approvals (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    document_id             BIGINT NOT NULL,
    approver_id             BIGINT NOT NULL,
    approval_status         VARCHAR(50) NOT NULL,
    approval_comments       TEXT,
    approved_at             TIMESTAMPTZ,
    CONSTRAINT pk_document_approvals PRIMARY KEY(id),
    CONSTRAINT fk_document_approvals_document FOREIGN KEY(document_id) REFERENCES documents.documents(id)  ON DELETE CASCADE,
    CONSTRAINT fk_document_approvals_approver FOREIGN KEY(approver_id) REFERENCES security.users(id)
);

CREATE INDEX idx_document_approvals_document ON documents.document_approvals(document_id);

-- [074] document_access

CREATE TABLE IF NOT EXISTS documents.document_access (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    document_id             BIGINT NOT NULL,
    user_id                 BIGINT,
    role_id                 BIGINT,
    access_type             VARCHAR(50) NOT NULL,
    granted_by              BIGINT,
    granted_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    expires_at              TIMESTAMPTZ,
    CONSTRAINT pk_document_access PRIMARY KEY(id),
    CONSTRAINT fk_document_access_document FOREIGN KEY(document_id) REFERENCES documents.documents(id)  ON DELETE CASCADE,
    CONSTRAINT fk_document_access_user FOREIGN KEY(user_id) REFERENCES security.users(id),
    CONSTRAINT fk_document_access_role FOREIGN KEY(role_id) REFERENCES security.roles(id)
);

CREATE INDEX idx_document_access_document ON documents.document_access(document_id);
CREATE INDEX idx_document_access_user ON documents.document_access(user_id);

-- [075] document_audit

CREATE TABLE IF NOT EXISTS documents.document_audit (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    document_id             BIGINT NOT NULL,
    action_type             VARCHAR(100) NOT NULL,
    action_by               BIGINT,
    action_timestamp        TIMESTAMPTZ NOT NULL DEFAULT now(),
    source_ip               INET,
    details                 JSONB,
    CONSTRAINT pk_document_audit PRIMARY KEY(id),
    CONSTRAINT fk_document_audit_document FOREIGN KEY(document_id) REFERENCES documents.documents(id)  ON DELETE CASCADE
);

CREATE INDEX idx_document_audit_document ON documents.document_audit(document_id);
CREATE INDEX idx_document_audit_details ON documents.document_audit USING GIN(details);

-- [076] templates

CREATE TABLE IF NOT EXISTS documents.templates (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    template_code           VARCHAR(100) NOT NULL,
    template_name           VARCHAR(500) NOT NULL,
    template_type           VARCHAR(100) NOT NULL,
    template_content        TEXT NOT NULL,
    version_no              INTEGER NOT NULL DEFAULT 1,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_templates PRIMARY KEY(id),
    CONSTRAINT uq_templates_code_version UNIQUE(template_code, version_no)
);

CREATE INDEX idx_templates_type ON documents.templates(template_type);

-- [077] generated_documents

CREATE TABLE IF NOT EXISTS documents.generated_documents (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    template_id             BIGINT NOT NULL,
    entity_type             VARCHAR(100) NOT NULL,
    entity_id               BIGINT NOT NULL,
    generated_document_id   BIGINT,
    generated_by            BIGINT NOT NULL,
    generated_at            TIMESTAMPTZ NOT NULL DEFAULT now(),
    generation_parameters   JSONB,
    CONSTRAINT pk_generated_documents PRIMARY KEY(id),
    CONSTRAINT fk_generated_documents_template FOREIGN KEY(template_id) REFERENCES documents.templates(id),
    CONSTRAINT fk_generated_documents_document FOREIGN KEY(generated_document_id) REFERENCES documents.documents(id),
    CONSTRAINT fk_generated_documents_user FOREIGN KEY(generated_by) REFERENCES security.users(id)
);

CREATE INDEX idx_generated_documents_entity ON documents.generated_documents(entity_type, entity_id);
CREATE INDEX idx_generated_documents_parameters ON documents.generated_documents USING GIN(generation_parameters);

/*
 ملاحظات معمارية مهمة

ظهرت بعض الجداول الإضافية التي أوصي بإضافتها لاحقاً أثناء مرحلة التحسين النهائي:

document_folders
document_categories
document_retention_policies
document_archives
document_watermarks
document_classifications
document_shares
document_download_logs
*/

-- [078] monitoring_plans

CREATE TABLE IF NOT EXISTS monitoring.monitoring_plans (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    plan_code                  VARCHAR(100) NOT NULL,
    monitoring_type            VARCHAR(100) NOT NULL,
    frequency_type             VARCHAR(100),
    planned_start_date         DATE,
    planned_end_date           DATE,
    status_code                VARCHAR(50) NOT NULL DEFAULT 'ACTIVE',
    created_by                 BIGINT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_monitoring_plans PRIMARY KEY(id),
    CONSTRAINT uq_monitoring_plan_code UNIQUE(plan_code),
    CONSTRAINT fk_monitoring_plan_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_monitoring_plans_application ON monitoring.monitoring_plans(application_id);

-- [079] monitoring_visits

CREATE TABLE IF NOT EXISTS monitoring.monitoring_visits (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    monitoring_plan_id         BIGINT NOT NULL,
    visit_date                 DATE NOT NULL,
    monitor_id                 BIGINT,
    visit_status               VARCHAR(50) NOT NULL,
    observations               TEXT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_monitoring_visits PRIMARY KEY(id),
    CONSTRAINT fk_monitoring_visits_plan FOREIGN KEY(monitoring_plan_id) REFERENCES monitoring.monitoring_plans(id)  ON DELETE CASCADE,
    CONSTRAINT fk_monitoring_visits_monitor FOREIGN KEY(monitor_id) REFERENCES security.users(id)
);

CREATE INDEX idx_monitoring_visits_plan ON monitoring.monitoring_visits(monitoring_plan_id);

-- [080] monitoring_findings

CREATE TABLE IF NOT EXISTS monitoring.monitoring_findings (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    monitoring_visit_id        BIGINT NOT NULL,
    finding_type               VARCHAR(100) NOT NULL,
    severity                   VARCHAR(50) NOT NULL,
    description                TEXT NOT NULL,
    recommendation             TEXT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_monitoring_findings PRIMARY KEY(id),
    CONSTRAINT fk_monitoring_findings_visit FOREIGN KEY(monitoring_visit_id) REFERENCES monitoring.monitoring_visits(id)  ON DELETE CASCADE
);

CREATE INDEX idx_monitoring_findings_visit ON monitoring.monitoring_findings(monitoring_visit_id);

-- [081] corrective_actions

CREATE TABLE IF NOT EXISTS monitoring.corrective_actions (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    finding_id                 BIGINT NOT NULL,
    action_description         TEXT NOT NULL,
    responsible_user_id        BIGINT,
    target_completion_date     DATE,
    completion_date            DATE,
    status_code                VARCHAR(50) NOT NULL DEFAULT 'OPEN',
    CONSTRAINT pk_corrective_actions PRIMARY KEY(id),
    CONSTRAINT fk_corrective_actions_finding FOREIGN KEY(finding_id) REFERENCES monitoring.monitoring_findings(id)  ON DELETE CASCADE
);

CREATE INDEX idx_corrective_actions_finding ON monitoring.corrective_actions(finding_id);

-- [082] preventive_actions

CREATE TABLE IF NOT EXISTS monitoring.preventive_actions (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    finding_id                 BIGINT NOT NULL,
    action_description         TEXT NOT NULL,
    responsible_user_id        BIGINT,
    target_completion_date     DATE,
    completion_date            DATE,
    status_code                VARCHAR(50) NOT NULL DEFAULT 'OPEN',
    CONSTRAINT pk_preventive_actions PRIMARY KEY(id),
    CONSTRAINT fk_preventive_actions_finding FOREIGN KEY(finding_id) REFERENCES monitoring.monitoring_findings(id)  ON DELETE CASCADE
);

CREATE INDEX idx_preventive_actions_finding ON monitoring.preventive_actions(finding_id);

-- [083] compliance_reviews

CREATE TABLE IF NOT EXISTS monitoring.compliance_reviews (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    reviewer_id                BIGINT NOT NULL,
    review_date                DATE NOT NULL,
    compliance_score           NUMERIC(5,2),
    summary                    TEXT,
    status_code                VARCHAR(50),
    CONSTRAINT pk_compliance_reviews PRIMARY KEY(id),
    CONSTRAINT fk_compliance_reviews_application FOREIGN KEY(application_id) REFERENCES core.applications(id),
    CONSTRAINT fk_compliance_reviews_reviewer FOREIGN KEY(reviewer_id) REFERENCES security.users(id)
);

CREATE INDEX idx_compliance_reviews_application ON monitoring.compliance_reviews(application_id);

-- [084] deviations

CREATE TABLE IF NOT EXISTS monitoring.deviations (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    deviation_code             VARCHAR(100),
    deviation_date             DATE NOT NULL,
    deviation_type             VARCHAR(100),
    description                TEXT NOT NULL,
    reported_by                BIGINT,
    reported_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_deviations PRIMARY KEY(id),
    CONSTRAINT fk_deviations_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_deviations_application ON monitoring.deviations(application_id);

-- [085] protocol_violations

CREATE TABLE IF NOT EXISTS monitoring.protocol_violations (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    violation_date             DATE NOT NULL,
    severity                   VARCHAR(50) NOT NULL,
    description                TEXT NOT NULL,
    corrective_action_required BOOLEAN NOT NULL DEFAULT TRUE,
    status_code                VARCHAR(50) NOT NULL DEFAULT 'OPEN',
    CONSTRAINT pk_protocol_violations PRIMARY KEY(id),
    CONSTRAINT fk_protocol_violations_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_protocol_violations_application ON monitoring.protocol_violations(application_id);

-- [086] inspections

CREATE TABLE IF NOT EXISTS monitoring.inspections (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    inspection_type            VARCHAR(100) NOT NULL,
    inspection_date            DATE NOT NULL,
    inspector_id               BIGINT,
    status_code                VARCHAR(50),
    summary                    TEXT,
    CONSTRAINT pk_inspections PRIMARY KEY(id),
    CONSTRAINT fk_inspections_application FOREIGN KEY(application_id) REFERENCES core.applications(id),
    CONSTRAINT fk_inspections_inspector FOREIGN KEY(inspector_id) REFERENCES security.users(id)
);

CREATE INDEX idx_inspections_application ON monitoring.inspections(application_id);

-- [087] inspection_reports

CREATE TABLE IF NOT EXISTS monitoring.inspection_reports (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    inspection_id              BIGINT NOT NULL,
    report_number              VARCHAR(100),
    findings_summary           TEXT,
    recommendations            TEXT,
    submitted_at               TIMESTAMPTZ,
    approved_at                TIMESTAMPTZ,
    CONSTRAINT pk_inspection_reports PRIMARY KEY(id),
    CONSTRAINT fk_inspection_reports_inspection FOREIGN KEY(inspection_id) REFERENCES monitoring.inspections(id)  ON DELETE CASCADE
);

CREATE INDEX idx_inspection_reports_inspection ON monitoring.inspection_reports(inspection_id);


/*
 ملاحظات معمارية مهمة

أثناء بناء هذا الجزء ظهرت جداول إضافية سأضيفها في مرحلة التحسين المؤسسي النهائية، منها:

text
monitoring_checklists
monitoring_observations
monitoring_followups
compliance_requirements
compliance_evidence
inspection_findings
inspection_actions
inspection_followups


وهي ضرورية إذا كان النظام سيستخدم على مستوى وطني لإدارة مئات الدراسات سنوياً.
*/
-- [088] adverse_events

CREATE TABLE IF NOT EXISTS safety.adverse_events (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    event_number               VARCHAR(100) NOT NULL,
    participant_reference      VARCHAR(200),
    event_date                 DATE NOT NULL,
    event_type                 VARCHAR(100) NOT NULL,
    severity                   VARCHAR(50) NOT NULL,
    expectedness               VARCHAR(50),
    relatedness                VARCHAR(50),
    description                TEXT NOT NULL,
    outcome_status             VARCHAR(100),
    reported_by                BIGINT,
    reported_at                TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_adverse_events PRIMARY KEY(id),
    CONSTRAINT uq_adverse_events_number UNIQUE(event_number),
    CONSTRAINT fk_adverse_events_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE,
    CONSTRAINT fk_adverse_events_reported_by FOREIGN KEY(reported_by) REFERENCES security.users(id)
);

CREATE INDEX idx_adverse_events_application ON safety.adverse_events(application_id);
CREATE INDEX idx_adverse_events_date ON safety.adverse_events(event_date);

-- [089] serious_adverse_events

CREATE TABLE IF NOT EXISTS safety.serious_adverse_events (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    adverse_event_id           BIGINT NOT NULL,
    seriousness_reason         VARCHAR(200) NOT NULL,
    hospitalization_required   BOOLEAN NOT NULL DEFAULT FALSE,
    life_threatening           BOOLEAN NOT NULL DEFAULT FALSE,
    death_occurred             BOOLEAN NOT NULL DEFAULT FALSE,
    disability_occurred        BOOLEAN NOT NULL DEFAULT FALSE,
    reported_to_committee_at   TIMESTAMPTZ,
    CONSTRAINT pk_serious_adverse_events PRIMARY KEY(id),
    CONSTRAINT fk_serious_adverse_events_event FOREIGN KEY(adverse_event_id) REFERENCES safety.adverse_events(id)  ON DELETE CASCADE
);

CREATE INDEX idx_serious_adverse_events_event ON safety.serious_adverse_events(adverse_event_id);

-- [090] safety_reports
CREATE TABLE IF NOT EXISTS safety.safety_reports (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    report_number              VARCHAR(100) NOT NULL,
    report_type                VARCHAR(100) NOT NULL,
    reporting_period_start     DATE,
    reporting_period_end       DATE,
    report_summary             TEXT,
    submitted_by               BIGINT,
    submitted_at               TIMESTAMPTZ,
    CONSTRAINT pk_safety_reports PRIMARY KEY(id),
    CONSTRAINT uq_safety_reports_number UNIQUE(report_number),
    CONSTRAINT fk_safety_reports_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE,
    CONSTRAINT fk_safety_reports_user FOREIGN KEY(submitted_by) REFERENCES security.users(id)
);

CREATE INDEX idx_safety_reports_application ON safety.safety_reports(application_id);

-- [091] safety_followups
CREATE TABLE IF NOT EXISTS safety.safety_followups (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    adverse_event_id           BIGINT NOT NULL,
    followup_date              DATE NOT NULL,
    followup_notes             TEXT NOT NULL,
    outcome_status             VARCHAR(100),
    created_by                 BIGINT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_safety_followups PRIMARY KEY(id),
    CONSTRAINT fk_safety_followups_event FOREIGN KEY(adverse_event_id) REFERENCES safety.adverse_events(id)  ON DELETE CASCADE
);

CREATE INDEX idx_safety_followups_event ON safety.safety_followups(adverse_event_id);

-- [092] risk_assessments
CREATE TABLE IF NOT EXISTS safety.risk_assessments (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    assessment_date            DATE NOT NULL,
    overall_risk_level         VARCHAR(50) NOT NULL,
    assessment_summary         TEXT,
    assessed_by                BIGINT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_risk_assessments PRIMARY KEY(id),
    CONSTRAINT fk_risk_assessments_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE,
    CONSTRAINT fk_risk_assessments_user FOREIGN KEY(assessed_by) REFERENCES security.users(id)
);

CREATE INDEX idx_risk_assessments_application ON safety.risk_assessments(application_id);

-- [093] risk_categories
CREATE TABLE IF NOT EXISTS safety.risk_categories (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    category_code              VARCHAR(100) NOT NULL,
    category_name              VARCHAR(300) NOT NULL,
    description                TEXT,
    is_active                  BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_risk_categories PRIMARY KEY(id),
    CONSTRAINT uq_risk_categories_code UNIQUE(category_code)
);

-- [094] mitigation_actions
CREATE TABLE IF NOT EXISTS safety.mitigation_actions (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    risk_assessment_id         BIGINT NOT NULL,
    risk_category_id           BIGINT,
    action_description         TEXT NOT NULL,
    responsible_user_id        BIGINT,
    target_date                DATE,
    completion_date            DATE,
    status_code                VARCHAR(50) DEFAULT 'OPEN',
    CONSTRAINT pk_mitigation_actions PRIMARY KEY(id),
    CONSTRAINT fk_mitigation_actions_assessment FOREIGN KEY(risk_assessment_id) REFERENCES safety.risk_assessments(id)  ON DELETE CASCADE,
    CONSTRAINT fk_mitigation_actions_category FOREIGN KEY(risk_category_id) REFERENCES safety.risk_categories(id),
    CONSTRAINT fk_mitigation_actions_user FOREIGN KEY(responsible_user_id) REFERENCES security.users(id)
);

CREATE INDEX idx_mitigation_actions_assessment ON safety.mitigation_actions(risk_assessment_id);

-- [095] safety_committee_reviews
CREATE TABLE IF NOT EXISTS safety.safety_committee_reviews (
    id                          BIGINT GENERATED ALWAYS AS IDENTITY,
    application_id             BIGINT NOT NULL,
    committee_id               BIGINT NOT NULL,
    review_date                DATE NOT NULL,
    review_outcome             VARCHAR(100) NOT NULL,
    recommendations            TEXT,
    reviewed_by                BIGINT,
    created_at                 TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_safety_committee_reviews PRIMARY KEY(id),
    CONSTRAINT fk_safety_committee_reviews_application FOREIGN KEY(application_id) REFERENCES core.applications(id)  ON DELETE CASCADE,
    CONSTRAINT fk_safety_committee_reviews_committee FOREIGN KEY(committee_id) REFERENCES committee.committees(id),
    CONSTRAINT fk_safety_committee_reviews_user FOREIGN KEY(reviewed_by) REFERENCES security.users(id)
);

CREATE INDEX idx_safety_committee_reviews_application ON safety.safety_committee_reviews(application_id);
CREATE INDEX idx_safety_committee_reviews_committee ON safety.safety_committee_reviews(committee_id);


/*
 ملاحظات معمارية مهمة

عند المراجعة المؤسسية النهائية سأضيف جداول متقدمة مثل:

text
risk_factors
risk_controls
risk_reassessment_history
participant_safety_alerts
safety_notifications
dsmb_committees
dsmb_reviews
safety_signal_detection

وهي مطلوبة غالباً إذا كان النظام سيدعم التجارب السريرية الدوائية وفق معايير ICH-GCP.
*/

-- [096] notifications
CREATE TABLE IF NOT EXISTS communication.notifications (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id                 BIGINT NOT NULL,
    notification_type       VARCHAR(100) NOT NULL,
    channel_id              BIGINT,
    subject                 VARCHAR(500),
    message_body            TEXT NOT NULL,
    priority_level          VARCHAR(50) DEFAULT 'NORMAL',
    is_read                 BOOLEAN NOT NULL DEFAULT FALSE,
    sent_at                 TIMESTAMPTZ,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_notifications PRIMARY KEY(id),
    CONSTRAINT fk_notifications_user FOREIGN KEY(user_id) REFERENCES security.users(id)
);

CREATE INDEX idx_notifications_user ON communication.notifications(user_id);
CREATE INDEX idx_notifications_read ON communication.notifications(is_read);

-- [097] notification_templates
CREATE TABLE IF NOT EXISTS communication.notification_templates (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    template_code           VARCHAR(100) NOT NULL,
    template_name           VARCHAR(300) NOT NULL,
    channel_type            VARCHAR(50) NOT NULL,
    subject_template        TEXT,
    body_template           TEXT NOT NULL,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_notification_templates PRIMARY KEY(id),
    CONSTRAINT uq_notification_templates_code UNIQUE(template_code)
);

-- [098] notification_channels
CREATE TABLE IF NOT EXISTS communication.notification_channels (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    channel_code            VARCHAR(50) NOT NULL,
    channel_name            VARCHAR(200) NOT NULL,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_notification_channels PRIMARY KEY(id),
    CONSTRAINT uq_notification_channels UNIQUE(channel_code)
);

-- [099] notification_logs
CREATE TABLE IF NOT EXISTS communication.notification_logs (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    notification_id         BIGINT NOT NULL,
    delivery_status         VARCHAR(50) NOT NULL,
    provider_reference      VARCHAR(500),
    error_message           TEXT,
    logged_at               TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_notification_logs PRIMARY KEY(id),
    CONSTRAINT fk_notification_logs_notification FOREIGN KEY(notification_id) REFERENCES communication.notifications(id)  ON DELETE CASCADE
);

CREATE INDEX idx_notification_logs_notification ON communication.notification_logs(notification_id);

-- [100] announcements
CREATE TABLE IF NOT EXISTS communication.announcements (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    title                   VARCHAR(500) NOT NULL,
    announcement_body       TEXT NOT NULL,
    start_date              DATE,
    end_date                DATE,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    created_by              BIGINT,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_announcements PRIMARY KEY(id),
    CONSTRAINT fk_announcements_user FOREIGN KEY(created_by) REFERENCES security.users(id)
);

CREATE INDEX idx_announcements_active ON communication.announcements(is_active);


-- AUDIT & REPORTING DOMAIN
-- [101] audit_logs
CREATE TABLE IF NOT EXISTS audit.audit_logs (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    user_id                 BIGINT,
    entity_name             VARCHAR(200) NOT NULL,
    entity_id               BIGINT,
    operation_type          VARCHAR(50) NOT NULL,
    source_ip               INET,
    event_timestamp         TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_audit_logs PRIMARY KEY(id),
    CONSTRAINT fk_audit_logs_user FOREIGN KEY(user_id) REFERENCES security.users(id)
);

CREATE INDEX idx_audit_logs_entity ON audit.audit_logs(entity_name, entity_id);
CREATE INDEX idx_audit_logs_timestamp ON audit.audit_logs(event_timestamp);

-- [102] audit_details
CREATE TABLE IF NOT EXISTS audit.audit_details (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    audit_log_id            BIGINT NOT NULL,
    field_name              VARCHAR(200) NOT NULL,
    old_value               TEXT,
    new_value               TEXT,
    CONSTRAINT pk_audit_details PRIMARY KEY(id),
    CONSTRAINT fk_audit_details_log FOREIGN KEY(audit_log_id) REFERENCES audit.audit_logs(id)  ON DELETE CASCADE
);

CREATE INDEX idx_audit_details_log ON audit.audit_details(audit_log_id);

-- [103] entity_changes
CREATE TABLE IF NOT EXISTS audit.entity_changes (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    entity_name             VARCHAR(200) NOT NULL,
    entity_id               BIGINT NOT NULL,
    change_type             VARCHAR(50) NOT NULL,
    changed_by              BIGINT,
    changed_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    details                 JSONB,
    CONSTRAINT pk_entity_changes PRIMARY KEY(id),
    CONSTRAINT fk_entity_changes_user FOREIGN KEY(changed_by) REFERENCES security.users(id)
);

CREATE INDEX idx_entity_changes_entity ON audit.entity_changes(entity_name, entity_id);
CREATE INDEX idx_entity_changes_json ON audit.entity_changes USING GIN(details);

-- [104] report_definitions
CREATE TABLE IF NOT EXISTS reporting.report_definitions (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    report_code             VARCHAR(100) NOT NULL,
    report_name             VARCHAR(300) NOT NULL,
    report_category         VARCHAR(100),
    sql_definition          TEXT,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_report_definitions PRIMARY KEY(id),
    CONSTRAINT uq_report_definitions UNIQUE(report_code)
);

-- [105] report_executions
CREATE TABLE IF NOT EXISTS reporting.report_executions (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    report_id               BIGINT NOT NULL,
    executed_by             BIGINT,
    execution_start         TIMESTAMPTZ,
    execution_end           TIMESTAMPTZ,
    execution_status        VARCHAR(50),
    output_file             TEXT,
    CONSTRAINT pk_report_executions PRIMARY KEY(id),
    CONSTRAINT fk_report_executions_report FOREIGN KEY(report_id) REFERENCES reporting.report_definitions(id),
    CONSTRAINT fk_report_executions_user FOREIGN KEY(executed_by) REFERENCES security.users(id)
);

CREATE INDEX idx_report_executions_report ON reporting.report_executions(report_id);

-- [106] dashboard_widgets
CREATE TABLE IF NOT EXISTS reporting.dashboard_widgets (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    widget_code             VARCHAR(100) NOT NULL,
    widget_name             VARCHAR(300) NOT NULL,
    widget_type             VARCHAR(100),
    configuration           JSONB,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT pk_dashboard_widgets PRIMARY KEY(id),
    CONSTRAINT uq_dashboard_widgets UNIQUE(widget_code)
);

CREATE INDEX idx_dashboard_widgets_json ON reporting.dashboard_widgets USING GIN(configuration);

-- [107] analytics_snapshots
CREATE TABLE IF NOT EXISTS reporting.analytics_snapshots (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    snapshot_date           DATE NOT NULL,
    snapshot_type           VARCHAR(100) NOT NULL,
    metrics                 JSONB NOT NULL,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_analytics_snapshots PRIMARY KEY(id)
);

CREATE INDEX idx_analytics_snapshots_json ON reporting.analytics_snapshots USING GIN(metrics);

-- [108] kpi_results
CREATE TABLE IF NOT EXISTS reporting.kpi_results (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    kpi_code                VARCHAR(100) NOT NULL,
    measurement_date        DATE NOT NULL,
    kpi_value               NUMERIC(18,4),
    target_value            NUMERIC(18,4),
    calculated_at           TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_kpi_results PRIMARY KEY(id)
);

CREATE INDEX idx_kpi_results_code ON reporting.kpi_results(kpi_code);



-- [109] lookup_categories
CREATE TABLE IF NOT EXISTS reference.lookup_categories (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    category_code           VARCHAR(100) NOT NULL,
    category_name_ar        VARCHAR(300) NOT NULL,
    category_name_en        VARCHAR(300),
    description             TEXT,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_lookup_categories PRIMARY KEY(id),
    CONSTRAINT uq_lookup_categories UNIQUE(category_code)
);

CREATE INDEX idx_lookup_categories_active ON reference.lookup_categories(is_active);


-- [110] lookup_values
CREATE TABLE IF NOT EXISTS reference.lookup_values (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    category_id             BIGINT NOT NULL,
    value_code              VARCHAR(100) NOT NULL,
    value_name_ar           VARCHAR(500) NOT NULL,
    value_name_en           VARCHAR(500),
    display_order           INTEGER DEFAULT 1,
    is_default              BOOLEAN NOT NULL DEFAULT FALSE,
    is_active               BOOLEAN NOT NULL DEFAULT TRUE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT pk_lookup_values PRIMARY KEY(id),
    CONSTRAINT uq_lookup_values UNIQUE(category_id, value_code),
    CONSTRAINT fk_lookup_values_category FOREIGN KEY(category_id) REFERENCES reference.lookup_categories(id)  ON DELETE CASCADE
);

CREATE INDEX idx_lookup_values_category ON reference.lookup_values(category_id);


-- [111] status_types
CREATE TABLE IF NOT EXISTS reference.status_types (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    status_type_code        VARCHAR(100) NOT NULL,
    status_type_name        VARCHAR(300) NOT NULL,
    description             TEXT,
    CONSTRAINT pk_status_types PRIMARY KEY(id),
    CONSTRAINT uq_status_types UNIQUE(status_type_code)
);


-- [112] application_statuses
CREATE TABLE IF NOT EXISTS reference.application_statuses (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    status_code             VARCHAR(100) NOT NULL,
    status_name_ar          VARCHAR(300) NOT NULL,
    status_name_en          VARCHAR(300),
    display_order           INTEGER DEFAULT 1,
    is_terminal             BOOLEAN DEFAULT FALSE,
    CONSTRAINT pk_application_statuses PRIMARY KEY(id),
    CONSTRAINT uq_application_statuses UNIQUE(status_code)
);


-- [113] review_statuses
CREATE TABLE IF NOT EXISTS reference.review_statuses (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    status_code             VARCHAR(100) NOT NULL,
    status_name             VARCHAR(300) NOT NULL,
    is_terminal             BOOLEAN DEFAULT FALSE,
    CONSTRAINT pk_review_statuses PRIMARY KEY(id),
    CONSTRAINT uq_review_statuses UNIQUE(status_code)
);


-- [114] workflow_statuses
CREATE TABLE IF NOT EXISTS reference.workflow_statuses (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    status_code             VARCHAR(100) NOT NULL,
    status_name             VARCHAR(300) NOT NULL,
    CONSTRAINT pk_workflow_statuses PRIMARY KEY(id),
    CONSTRAINT uq_workflow_statuses UNIQUE(status_code)
);


-- [115] risk_levels
CREATE TABLE IF NOT EXISTS reference.risk_levels (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    risk_code               VARCHAR(50) NOT NULL,
    risk_name               VARCHAR(200) NOT NULL,
    severity_score          INTEGER NOT NULL,
    CONSTRAINT pk_risk_levels PRIMARY KEY(id),
    CONSTRAINT uq_risk_levels UNIQUE(risk_code)
);


-- [116] priority_levels
CREATE TABLE IF NOT EXISTS reference.priority_levels (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    priority_code           VARCHAR(50) NOT NULL,
    priority_name           VARCHAR(200) NOT NULL,
    priority_order          INTEGER NOT NULL,
    CONSTRAINT pk_priority_levels PRIMARY KEY(id),
    CONSTRAINT uq_priority_levels UNIQUE(priority_code)
);


-- [117] document_statuses
CREATE TABLE IF NOT EXISTS reference.document_statuses (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    status_code             VARCHAR(50) NOT NULL,
    status_name             VARCHAR(200) NOT NULL,
    CONSTRAINT pk_document_statuses PRIMARY KEY(id),
    CONSTRAINT uq_document_statuses UNIQUE(status_code)
);


-- [118] notification_statuses
CREATE TABLE IF NOT EXISTS reference.notification_statuses (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    status_code             VARCHAR(50) NOT NULL,
    status_name             VARCHAR(200) NOT NULL,
    CONSTRAINT pk_notification_statuses PRIMARY KEY(id),
    CONSTRAINT uq_notification_statuses UNIQUE(status_code)
);


-- [119] committee_decision_types
CREATE TABLE IF NOT EXISTS reference.committee_decision_types (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    decision_code           VARCHAR(100) NOT NULL,
    decision_name           VARCHAR(300) NOT NULL,
    is_approval             BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT pk_committee_decision_types PRIMARY KEY(id),
    CONSTRAINT uq_committee_decision_types UNIQUE(decision_code)
);


-- [120] vote_types
CREATE TABLE IF NOT EXISTS reference.vote_types (
    id                      BIGINT GENERATED ALWAYS AS IDENTITY,
    vote_code               VARCHAR(100) NOT NULL,
    vote_name               VARCHAR(300) NOT NULL,
    display_order           INTEGER NOT NULL DEFAULT 1,
    CONSTRAINT pk_vote_types PRIMARY KEY(id),
    CONSTRAINT uq_vote_types UNIQUE(vote_code)
);

