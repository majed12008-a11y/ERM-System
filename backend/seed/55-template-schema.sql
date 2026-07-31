/*
 * 55-template-schema.sql
 * ======================
 *
 * إنشاء بنية محرك القوالب (Template Engine).
 * Template Engine Schema Creation.
 *
 * يتضمن هذا الملف:
 *   - إنشاء Schema (templates)
 *   - إنشاء جميع الجداول
 *   - إنشاء المعرفات المتسلسلة (Identity Sequences)
 *   - إنشاء القيود (Primary Keys, Foreign Keys, Unique, Check)
 *   - إنشاء الفهارس (بما في ذلك Partial Unique Index)
 *   - تفعيل RLS وإنشاء السياسات
 *   - إنشاء المشغلات (Triggers) للتدقيق
 *
 * الترتيب: يُطبَّق بعد 54-yemen-documents.sql
 */

-- ============================================================
-- SCHEMA
-- ============================================================
CREATE SCHEMA IF NOT EXISTS templates;

-- ============================================================
-- DOMAIN TYPES
-- ============================================================

-- ============================================================
-- TABLES
-- ============================================================

-- 1. CATEGORIES
CREATE TABLE templates.categories (
    id bigint NOT NULL,
    code character varying(50) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    description text,
    parent_category_id bigint,
    required_variables jsonb DEFAULT '[]'::jsonb NOT NULL,
    default_output_format character varying(20) DEFAULT 'PDF'::character varying NOT NULL,
    approval_required boolean DEFAULT true NOT NULL,
    sort_order integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_templates_categories_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);

-- 2. TEMPLATES
CREATE TABLE templates.templates (
    id bigint NOT NULL,
    category_id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    description text,
    engine character varying(50) DEFAULT 'handlebars'::character varying NOT NULL,
    default_locale character varying(10) DEFAULT 'ar'::character varying NOT NULL,
    default_output_format character varying(20),
    variable_sources jsonb DEFAULT '[]'::jsonb NOT NULL,
    tags text[] DEFAULT '{}'::text[] NOT NULL,
    usage_count integer DEFAULT 0 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_templates_templates_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);

-- 3. TEMPLATE VERSIONS
CREATE TABLE templates.template_versions (
    id bigint NOT NULL,
    template_id bigint NOT NULL,
    version character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'DRAFT'::character varying NOT NULL,
    content jsonb NOT NULL,
    content_hash character varying(64) NOT NULL,
    variable_definitions jsonb DEFAULT '[]'::jsonb NOT NULL,
    change_summary text,
    effective_from timestamp with time zone,
    effective_until timestamp with time zone,
    retired_at timestamp with time zone,
    approved_by bigint,
    approved_at timestamp with time zone,
    created_by bigint NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_template_versions_status CHECK (((status)::text = ANY ((ARRAY['DRAFT'::character varying, 'REVIEW'::character varying, 'APPROVED'::character varying, 'DEPRECATED'::character varying, 'ARCHIVED'::character varying])::text[])))
);

-- 4. TEMPLATE LOCALIZATIONS
CREATE TABLE templates.template_localizations (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    locale character varying(10) NOT NULL,
    content jsonb NOT NULL,
    content_hash character varying(64) NOT NULL,
    is_verified boolean DEFAULT false NOT NULL,
    verified_by bigint,
    verified_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);

-- 5. TEMPLATE VARIABLES (Registry)
CREATE TABLE templates.template_variables (
    id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    type character varying(50) NOT NULL,
    enum_values jsonb,
    source_type character varying(50) NOT NULL,
    resolver_path character varying(500),
    resolver_function character varying(100),
    resolver_function_args jsonb,
    entity_whitelist_root character varying(100),
    default_value jsonb,
    description_ar text,
    description_en text,
    required boolean DEFAULT false NOT NULL,
    validation_rules jsonb,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_templates_template_variables_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL))),
    CONSTRAINT chk_template_variables_type CHECK (((type)::text = ANY ((ARRAY['string'::character varying, 'number'::character varying, 'date'::character varying, 'boolean'::character varying, 'array'::character varying, 'object'::character varying, 'enum'::character varying])::text[]))),
    CONSTRAINT chk_template_variables_source_type CHECK (((source_type)::text = ANY ((ARRAY['manual'::character varying, 'entity'::character varying, 'computed'::character varying, 'context'::character varying])::text[])))
);

-- 6. TEMPLATE PARTIALS
CREATE TABLE templates.template_partials (
    id bigint NOT NULL,
    template_id bigint,
    code character varying(100) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    engine character varying(50) DEFAULT 'handlebars'::character varying NOT NULL,
    content text NOT NULL,
    content_hash character varying(64) NOT NULL,
    version character varying(20) DEFAULT '1.0.0'::character varying NOT NULL,
    depends_on character varying(100)[] DEFAULT '{}'::character varying[] NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_templates_template_partials_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);

-- 7. TEMPLATE PACKAGES
CREATE TABLE templates.template_packages (
    id bigint NOT NULL,
    code character varying(100) NOT NULL,
    name_ar character varying(500) NOT NULL,
    name_en character varying(500) NOT NULL,
    description text,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    deleted_at timestamp with time zone,
    deleted_by bigint,
    CONSTRAINT chk_templates_template_packages_soft_delete CHECK (((deleted_at IS NULL) OR (deleted_by IS NOT NULL)))
);

-- 8. TEMPLATE PACKAGE MEMBERS
CREATE TABLE templates.template_package_members (
    id bigint NOT NULL,
    package_id bigint NOT NULL,
    template_code character varying(100) NOT NULL,
    slot_order integer NOT NULL,
    output_format character varying(20) DEFAULT 'PDF'::character varying NOT NULL,
    required boolean DEFAULT true NOT NULL,
    depends_on_slot integer
);

-- 9. TEMPLATE OUTPUTS
CREATE TABLE templates.template_outputs (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    locale character varying(10) NOT NULL,
    output_format character varying(20) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    storage_path character varying(1000) NOT NULL,
    file_name character varying(500) NOT NULL,
    file_size_bytes bigint,
    checksum_sha256 character varying(64) NOT NULL,
    variables_hash character varying(64) NOT NULL,
    rendered_html_hash character varying(64),
    digital_signature_ref character varying(500),
    generated_by bigint NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL,
    generation_duration_ms integer,
    status character varying(20) DEFAULT 'SUCCESS'::character varying NOT NULL,
    error_message text,
    CONSTRAINT chk_template_outputs_status CHECK (((status)::text = ANY ((ARRAY['SUCCESS'::character varying, 'FAILED'::character varying, 'PARTIAL'::character varying])::text[])))
);

-- 10. TEMPLATE RENDER JOBS
CREATE TABLE templates.template_render_jobs (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    locale character varying(10) NOT NULL,
    output_format character varying(20) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    variables jsonb,
    priority integer DEFAULT 0 NOT NULL,
    status character varying(20) DEFAULT 'QUEUED'::character varying NOT NULL,
    output_id bigint,
    error_message text,
    queued_at timestamp with time zone DEFAULT now() NOT NULL,
    started_at timestamp with time zone,
    completed_at timestamp with time zone,
    created_by bigint NOT NULL,
    CONSTRAINT chk_template_render_jobs_status CHECK (((status)::text = ANY ((ARRAY['QUEUED'::character varying, 'PROCESSING'::character varying, 'COMPLETED'::character varying, 'FAILED'::character varying])::text[])))
);

-- 11. TEMPLATE RENDER HISTORY (append-only, never deleted)
CREATE TABLE templates.template_render_history (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    template_code character varying(100) NOT NULL,
    version character varying(20) NOT NULL,
    locale character varying(10) NOT NULL,
    output_format character varying(20) NOT NULL,
    entity_type character varying(100) NOT NULL,
    entity_id bigint NOT NULL,
    generated_by bigint NOT NULL,
    generated_at timestamp with time zone DEFAULT now() NOT NULL,
    variables_hash character varying(64) NOT NULL,
    rendered_html_hash character varying(64),
    output_id bigint NOT NULL,
    storage_path character varying(1000) NOT NULL,
    checksum_sha256 character varying(64) NOT NULL,
    duration_ms integer,
    status character varying(20) NOT NULL,
    CONSTRAINT chk_template_render_history_status CHECK (((status)::text = ANY ((ARRAY['SUCCESS'::character varying, 'FAILED'::character varying, 'PARTIAL'::character varying, 'PERMISSION_DENIED'::character varying, 'SUCCESS_WITH_WARNING'::character varying, 'EVENT_FAILED'::character varying])::text[])))
);

-- 12. TEMPLATE APPROVAL WORKFLOW
CREATE TABLE templates.template_approval_workflow (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    step_order integer NOT NULL,
    approver_role character varying(100) NOT NULL,
    approver_id bigint,
    status character varying(20) DEFAULT 'PENDING'::character varying NOT NULL,
    comments text,
    acted_by bigint,
    acted_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_template_approval_workflow_status CHECK (((status)::text = ANY ((ARRAY['PENDING'::character varying, 'APPROVED'::character varying, 'REJECTED'::character varying])::text[])))
);

-- 13. TEMPLATE USAGE STATISTICS
CREATE TABLE templates.template_usage_statistics (
    id bigint NOT NULL,
    template_id bigint NOT NULL,
    date date NOT NULL,
    generation_count integer DEFAULT 0 NOT NULL,
    unique_users integer DEFAULT 0 NOT NULL,
    avg_duration_ms integer,
    total_size_bytes bigint DEFAULT 0 NOT NULL,
    by_format jsonb DEFAULT '{}'::jsonb NOT NULL,
    by_locale jsonb DEFAULT '{}'::jsonb NOT NULL
);

-- 14. TEMPLATE VERSION AUDIT
CREATE TABLE templates.template_version_audit (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    action character varying(20) NOT NULL,
    actor_id bigint NOT NULL,
    previous_status character varying(20),
    new_status character varying(20),
    comment text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_template_version_audit_action CHECK (((action)::text = ANY ((ARRAY['CREATED'::character varying, 'SUBMITTED'::character varying, 'APPROVED'::character varying, 'REJECTED'::character varying, 'DEPRECATED'::character varying, 'ARCHIVED'::character varying, 'ROLLED_BACK'::character varying, 'SUPERSEDED'::character varying, 'DELETED'::character varying])::text[])))
);

-- 15. TEMPLATE VALIDATION TESTS
CREATE TABLE templates.template_validation_tests (
    id bigint NOT NULL,
    template_version_id bigint NOT NULL,
    test_data jsonb,
    expected_output_hash character varying(64),
    expected_html_hash character varying(64),
    test_description text,
    last_run_at timestamp with time zone,
    last_result character varying(10),
    last_error text,
    last_output_hash character varying(64),
    CONSTRAINT chk_template_validation_tests_result CHECK (((last_result)::text = ANY ((ARRAY['PASS'::character varying, 'FAIL'::character varying, 'ERROR'::character varying])::text[])))
);

-- ============================================================
-- EVENT-TEMPLATE MAPPING (for §4.7 Event-Driven Generation)
-- ============================================================
CREATE TABLE templates.event_template_mapping (
    id bigint NOT NULL,
    event_type character varying(100) NOT NULL,
    template_code character varying(100) NOT NULL,
    locale character varying(10) DEFAULT 'ar'::character varying NOT NULL,
    output_format character varying(20) DEFAULT 'PDF'::character varying NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint,
    updated_at timestamp with time zone,
    updated_by bigint,
    CONSTRAINT uq_event_template_mapping UNIQUE (event_type, template_code)
);

-- ============================================================
-- IDENTITY SEQUENCES
-- ============================================================
ALTER TABLE templates.categories ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.categories_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.templates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.templates_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_versions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_versions_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_localizations ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_localizations_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_variables ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_variables_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_partials ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_partials_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_packages ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_packages_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_package_members ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_package_members_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_outputs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_outputs_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_render_jobs ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_render_jobs_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_render_history ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_render_history_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_approval_workflow ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_approval_workflow_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_usage_statistics ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_usage_statistics_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_version_audit ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_version_audit_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.template_validation_tests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.template_validation_tests_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

ALTER TABLE templates.event_template_mapping ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME templates.event_template_mapping_id_seq
    START WITH 1 INCREMENT BY 1 NO MINVALUE NO MAXVALUE CACHE 1
);

-- ============================================================
-- PRIMARY KEY CONSTRAINTS
-- ============================================================
ALTER TABLE ONLY templates.categories ADD CONSTRAINT pk_categories PRIMARY KEY (id);
ALTER TABLE ONLY templates.templates ADD CONSTRAINT pk_templates PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_versions ADD CONSTRAINT pk_template_versions PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_localizations ADD CONSTRAINT pk_template_localizations PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_variables ADD CONSTRAINT pk_template_variables PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_partials ADD CONSTRAINT pk_template_partials PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_packages ADD CONSTRAINT pk_template_packages PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_package_members ADD CONSTRAINT pk_template_package_members PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_outputs ADD CONSTRAINT pk_template_outputs PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_render_jobs ADD CONSTRAINT pk_template_render_jobs PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_render_history ADD CONSTRAINT pk_template_render_history PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_approval_workflow ADD CONSTRAINT pk_template_approval_workflow PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_usage_statistics ADD CONSTRAINT pk_template_usage_statistics PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_version_audit ADD CONSTRAINT pk_template_version_audit PRIMARY KEY (id);
ALTER TABLE ONLY templates.template_validation_tests ADD CONSTRAINT pk_template_validation_tests PRIMARY KEY (id);
ALTER TABLE ONLY templates.event_template_mapping ADD CONSTRAINT pk_event_template_mapping PRIMARY KEY (id);

-- ============================================================
-- UNIQUE CONSTRAINTS
-- ============================================================
ALTER TABLE ONLY templates.categories ADD CONSTRAINT uq_categories_code UNIQUE (code);
ALTER TABLE ONLY templates.templates ADD CONSTRAINT uq_templates_code UNIQUE (code);
ALTER TABLE ONLY templates.template_versions ADD CONSTRAINT uq_template_versions_version UNIQUE (template_id, version);
ALTER TABLE ONLY templates.template_localizations ADD CONSTRAINT uq_template_localizations_version_locale UNIQUE (template_version_id, locale);
ALTER TABLE ONLY templates.template_variables ADD CONSTRAINT uq_template_variables_code UNIQUE (code);
ALTER TABLE ONLY templates.template_partials ADD CONSTRAINT uq_template_partials_code UNIQUE (code);
ALTER TABLE ONLY templates.template_packages ADD CONSTRAINT uq_template_packages_code UNIQUE (code);
ALTER TABLE ONLY templates.template_usage_statistics ADD CONSTRAINT uq_template_usage_statistics_date UNIQUE (template_id, date);

-- ============================================================
-- FOREIGN KEY CONSTRAINTS
-- ============================================================
ALTER TABLE ONLY templates.templates ADD CONSTRAINT fk_templates_category
    FOREIGN KEY (category_id) REFERENCES templates.categories(id);

ALTER TABLE ONLY templates.template_versions ADD CONSTRAINT fk_template_versions_template
    FOREIGN KEY (template_id) REFERENCES templates.templates(id);

ALTER TABLE ONLY templates.template_localizations ADD CONSTRAINT fk_template_localizations_version
    FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);

ALTER TABLE ONLY templates.template_partials ADD CONSTRAINT fk_template_partials_template
    FOREIGN KEY (template_id) REFERENCES templates.templates(id);

ALTER TABLE ONLY templates.template_package_members ADD CONSTRAINT fk_template_package_members_package
    FOREIGN KEY (package_id) REFERENCES templates.template_packages(id);

ALTER TABLE ONLY templates.template_outputs ADD CONSTRAINT fk_template_outputs_version
    FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);

ALTER TABLE ONLY templates.template_render_jobs ADD CONSTRAINT fk_template_render_jobs_version
    FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);

ALTER TABLE ONLY templates.template_render_jobs ADD CONSTRAINT fk_template_render_jobs_output
    FOREIGN KEY (output_id) REFERENCES templates.template_outputs(id);

ALTER TABLE ONLY templates.template_approval_workflow ADD CONSTRAINT fk_template_approval_workflow_version
    FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);

ALTER TABLE ONLY templates.template_usage_statistics ADD CONSTRAINT fk_template_usage_statistics_template
    FOREIGN KEY (template_id) REFERENCES templates.templates(id);

ALTER TABLE ONLY templates.template_validation_tests ADD CONSTRAINT fk_template_validation_tests_version
    FOREIGN KEY (template_version_id) REFERENCES templates.template_versions(id);

-- Parent category self-reference
ALTER TABLE ONLY templates.categories ADD CONSTRAINT fk_categories_parent
    FOREIGN KEY (parent_category_id) REFERENCES templates.categories(id);

-- ============================================================
-- PARTIAL UNIQUE INDEX: One APPROVED version per template
-- ============================================================
CREATE UNIQUE INDEX one_approved_version
    ON templates.template_versions (template_id)
    WHERE (status = 'APPROVED'::character varying);

-- ============================================================
-- OTHER INDEXES
-- ============================================================
CREATE INDEX idx_template_versions_template_id ON templates.template_versions (template_id);
CREATE INDEX idx_template_versions_status ON templates.template_versions (status);
CREATE INDEX idx_template_versions_effective ON templates.template_versions (effective_from, effective_until);
CREATE INDEX idx_template_outputs_entity ON templates.template_outputs (entity_type, entity_id);
CREATE INDEX idx_template_outputs_version ON templates.template_outputs (template_version_id);
CREATE INDEX idx_template_render_jobs_status ON templates.template_render_jobs (status);
CREATE INDEX idx_template_render_jobs_priority ON templates.template_render_jobs (priority, queued_at);
CREATE INDEX idx_template_render_history_entity ON templates.template_render_history (entity_type, entity_id);
CREATE INDEX idx_template_render_history_generated_at ON templates.template_render_history (generated_at);
CREATE INDEX idx_template_variables_resolver_path ON templates.template_variables (resolver_path);
CREATE INDEX idx_template_variables_code ON templates.template_variables (code);
CREATE INDEX idx_template_partials_code ON templates.template_partials (code);
CREATE INDEX idx_template_package_members_package ON templates.template_package_members (package_id);
CREATE INDEX idx_template_package_members_slot ON templates.template_package_members (package_id, slot_order);
CREATE INDEX idx_template_version_audit_version ON templates.template_version_audit (template_version_id);
CREATE INDEX idx_template_version_audit_created ON templates.template_version_audit (created_at);
CREATE INDEX idx_template_approval_workflow_version ON templates.template_approval_workflow (template_version_id);
CREATE INDEX idx_template_localizations_version ON templates.template_localizations (template_version_id);
CREATE INDEX idx_template_usage_statistics_date ON templates.template_usage_statistics (template_id, date);
CREATE INDEX idx_event_template_mapping_event ON templates.event_template_mapping (event_type);
CREATE INDEX idx_categories_parent ON templates.categories (parent_category_id);
CREATE INDEX idx_templates_category ON templates.templates (category_id);
CREATE INDEX idx_templates_code ON templates.templates (code);

-- ============================================================
-- ROW-LEVEL SECURITY
-- ============================================================

-- Enable RLS on all tables
ALTER TABLE templates.categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_versions ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_localizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_variables ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_partials ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_packages ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_package_members ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_outputs ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_render_jobs ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_render_history ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_approval_workflow ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_usage_statistics ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_version_audit ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.template_validation_tests ENABLE ROW LEVEL SECURITY;
ALTER TABLE templates.event_template_mapping ENABLE ROW LEVEL SECURITY;

-- ============================================================
-- RLS POLICIES
-- ============================================================

-- All tables: admin full access
CREATE POLICY admin_all ON templates.categories
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.templates
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_versions
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_localizations
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_variables
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_partials
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_packages
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_package_members
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_outputs
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_render_jobs
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_render_history
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_approval_workflow
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_usage_statistics
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_version_audit
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.template_validation_tests
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));
CREATE POLICY admin_all ON templates.event_template_mapping
    FOR ALL USING (system.fn_is_admin((current_setting('app.user_id'::text))::bigint));

-- Read: all authenticated users can read template library data
CREATE POLICY read_all ON templates.categories
    FOR SELECT USING (true);
CREATE POLICY read_all ON templates.templates
    FOR SELECT USING (true);
CREATE POLICY read_all ON templates.template_versions
    FOR SELECT USING (true);
CREATE POLICY read_all ON templates.template_localizations
    FOR SELECT USING (true);
CREATE POLICY read_all ON templates.template_variables
    FOR SELECT USING (true);
CREATE POLICY read_all ON templates.template_partials
    FOR SELECT USING (true);

-- Read own outputs and render history (applicant access)
CREATE POLICY read_own_outputs ON templates.template_outputs
    FOR SELECT USING ((generated_by = (current_setting('app.user_id'::text, true))::bigint));
CREATE POLICY read_own_jobs ON templates.template_render_jobs
    FOR SELECT USING ((created_by = (current_setting('app.user_id'::text, true))::bigint));
CREATE POLICY read_own_history ON templates.template_render_history
    FOR SELECT USING ((generated_by = (current_setting('app.user_id'::text, true))::bigint));

-- No physical delete on any template table
CREATE POLICY no_physical_delete ON templates.categories
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.templates
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_versions
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_localizations
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_variables
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_partials
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_packages
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_package_members
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_outputs
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_render_jobs
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_render_history
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_approval_workflow
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_usage_statistics
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_version_audit
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.template_validation_tests
    FOR DELETE USING (false);
CREATE POLICY no_physical_delete ON templates.event_template_mapping
    FOR DELETE USING (false);

-- ============================================================
-- TRIGGERS: Audit Logging
-- ============================================================
CREATE TRIGGER trg_audit_categories AFTER INSERT OR DELETE OR UPDATE ON templates.categories
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_templates AFTER INSERT OR DELETE OR UPDATE ON templates.templates
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_versions AFTER INSERT OR DELETE OR UPDATE ON templates.template_versions
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_localizations AFTER INSERT OR DELETE OR UPDATE ON templates.template_localizations
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_variables AFTER INSERT OR DELETE OR UPDATE ON templates.template_variables
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_partials AFTER INSERT OR DELETE OR UPDATE ON templates.template_partials
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_packages AFTER INSERT OR DELETE OR UPDATE ON templates.template_packages
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_package_members AFTER INSERT OR DELETE OR UPDATE ON templates.template_package_members
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_outputs AFTER INSERT OR DELETE OR UPDATE ON templates.template_outputs
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_render_jobs AFTER INSERT OR DELETE OR UPDATE ON templates.template_render_jobs
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_render_history AFTER INSERT OR DELETE OR UPDATE ON templates.template_render_history
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_approval_workflow AFTER INSERT OR DELETE OR UPDATE ON templates.template_approval_workflow
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_usage_statistics AFTER INSERT OR DELETE OR UPDATE ON templates.template_usage_statistics
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_version_audit AFTER INSERT OR DELETE OR UPDATE ON templates.template_version_audit
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_template_validation_tests AFTER INSERT OR DELETE OR UPDATE ON templates.template_validation_tests
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
CREATE TRIGGER trg_audit_event_template_mapping AFTER INSERT OR DELETE OR UPDATE ON templates.event_template_mapping
    FOR EACH ROW EXECUTE FUNCTION system.fn_log_audit();
