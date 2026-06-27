يوصي بشدة بعدم استخدام مستخدم قاعدة بيانات واحد للتطبيق بالكامل، بل اعتماد نموذج متعدد الأدوار على مستوى PostgreSQL نفسه.
ويجب التفريق بين:

1. Application Roles (RBAC داخل النظام)
مثل: Researcher, Reviewer, Committee Chair...
2. Database Roles (PostgreSQL Roles)
مثل: app_rw, app_ro, audit_reader...
عادةً لا ننشئ مستخدم PostgreSQL لكل باحث أو عضو لجنة، لأن هذا سيصبح كابوسًا إداريًا. بل يتم:
• إدارة المستخدمين داخل النظام (users table)
• استخدام PostgreSQL Roles للخدمات والتطبيقات فقط
• تطبيق RBAC + RLS داخل قاعدة البيانات
الهيكلية المقترحة
postgres
│
├── ethics_owner
│
├── ethics_migration
│
├── ethics_app
│
├── ethics_workflow
│
├── ethics_reporting
│
├── ethics_audit
│
└── ethics_readonly

3. إنشاء قاعدة البيانات
CREATE DATABASE ethics_db
WITH
OWNER = ethics_owner
ENCODING = 'UTF8'
LC_COLLATE = 'en_US.UTF-8'
LC_CTYPE = 'en_US.UTF-8'
TEMPLATE = template0;

4. إنشاء Roles الأساسية
Owner Role
يمتلك كل شيء.
CREATE ROLE ethics_owner
LOGIN
PASSWORD 'OWNER_PASSWORD'
CREATEDB
CREATEROLE;

-- Migration Role
-- لتشغيل DDL و Migrations فقط.
CREATE ROLE ethics_migration
LOGIN
PASSWORD 'MIGRATION_PASSWORD';

Application Role
يستخدمه Backend API.
CREATE ROLE ethics_app
LOGIN
PASSWORD 'APP_PASSWORD';

Workflow Service
CREATE ROLE ethics_workflow
LOGIN
PASSWORD 'WORKFLOW_PASSWORD';

-- Reporting Service
CREATE ROLE ethics_reporting
LOGIN
PASSWORD 'REPORTING_PASSWORD';

-- Audit Service
CREATE ROLE ethics_audit
LOGIN
PASSWORD 'AUDIT_PASSWORD';

-- Read Only
CREATE ROLE ethics_readonly
LOGIN
PASSWORD 'READONLY_PASSWORD';

-- 1. ربط قاعدة البيانات
-- بعد إنشاء قاعدة البيانات:
ALTER DATABASE ethics_db OWNER TO ethics_owner;

-- 2. منع الوصول العام
REVOKE ALL ON DATABASE ethics_db FROM PUBLIC;

--3. منح صلاحيات الاتصال
GRANT CONNECT ON DATABASE ethics_db TO ethics_app;

GRANT CONNECT ON DATABASE ethics_db TO ethics_workflow;

GRANT CONNECT ON DATABASE ethics_db TO ethics_reporting;

GRANT CONNECT ON DATABASE ethics_db TO ethics_audit;

GRANT CONNECT ON DATABASE ethics_db TO ethics_readonly;

-- 1. Schema Strategy
-- أنصح باستخدام عدة Schemas:
core
workflow
committee
monitoring
safety
documents
communication
audit
reporting
integration
security
reference
system

-- إنشاء Schemas
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

-- 1. صلاحيات Migration
GRANT USAGE, CREATE ON SCHEMA core TO ethics_migration;
GRANT USAGE, CREATE ON SCHEMA workflow TO ethics_migration;
GRANT USAGE, CREATE ON SCHEMA committee TO ethics_migration;
GRANT USAGE, CREATE ON SCHEMA safety TO ethics_migration;
GRANT USAGE, CREATE ON SCHEMA documents TO ethics_migration;
GRANT USAGE, CREATE ON SCHEMA audit TO ethics_migration;
GRANT USAGE, CREATE ON SCHEMA reporting TO ethics_migration;
GRANT USAGE, CREATE ON SCHEMA security TO ethics_migration;
-- 2. صلاحيات التطبيق
GRANT USAGE ON SCHEMA core TO ethics_app;
GRANT USAGE ON SCHEMA workflow TO ethics_app;
GRANT USAGE ON SCHEMA committee TO ethics_app;
GRANT USAGE ON SCHEMA safety TO ethics_app;
GRANT USAGE ON SCHEMA documents TO ethics_app;

-- 3. صلاحيات CRUD للتطبيق
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA core TO ethics_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA workflow TO ethics_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA committee TO ethics_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA safety TO ethics_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA documents TO ethics_app;

-- 4. صلاحيات Audit
-- مهمة جداً.
GRANT USAGE ON SCHEMA audit TO ethics_audit;
GRANT SELECT ON ALL TABLES IN SCHEMA audit TO ethics_audit;
-- 5. صلاحيات التقارير
GRANT USAGE ON SCHEMA reporting TO ethics_reporting;
GRANT SELECT ON ALL TABLES IN SCHEMA reporting TO ethics_reporting;
GRANT SELECT ON ALL TABLES IN SCHEMA core TO ethics_reporting;

-- 6. مستخدم القراءة فقط
GRANT USAGE ON SCHEMA core TO ethics_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA core TO ethics_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA reporting TO ethics_readonly;

-- 7. Default Privileges
-- حتى تحصل الجداول الجديدة تلقائياً على الصلاحيات.
ALTER DEFAULT PRIVILEGES IN SCHEMA core GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ethics_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA workflow GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO ethics_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA audit GRANT SELECT ON TABLES TO ethics_audit;

-- 8. Role Hierarchy
CREATE ROLE ethics_service;

GRANT ethics_service TO ethics_app;
GRANT ethics_service TO ethics_workflow;
GRANT ethics_service TO ethics_reporting;

-- 1. تفعيل Row-Level Security
-- مثال على جدول applications:
ALTER TABLE core.applications ENABLE ROW LEVEL SECURITY;
CREATE POLICY applications_policy ON core.applications
FOR SELECT
USING (
    institution_id =
    current_setting('app.institution_id')::BIGINT
);

النتيجة النهائية
أوصي بالاعتماد على 7 مستخدمين PostgreSQL فقط:
PostgreSQL Role الاستخدام
ethics_owner مالك النظام
ethics_migration تنفيذ DDL و Migrations
ethics_app Backend API الرئيسي
ethics_workflow Workflow Engine
ethics_reporting التقارير ولوحات المؤشرات
ethics_audit التدقيق والامتثال
ethics_readonly الاستعلامات والقراءة فقط
أما أدوار:
• Researcher
• Reviewer
• Committee Member
• Committee Chair
• Ministry Supervisor
• Auditor
فيجب أن تبقى داخل جداول RBAC الخاصة بالنظام، وليس كمستخدمي PostgreSQL منفصلين. هذا هو النموذج المستخدم عادة في الأنظمة الحكومية والمؤسسية الكبيرة.
