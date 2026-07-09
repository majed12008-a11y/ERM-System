-- ============================================================
-- 38-WORKFLOW-ADD-CONSTRAINTS
-- ============================================================
-- إضافة قيود أمان وحيدة لجدول workflow.workflow_instances.
--
-- 1. تنظيف أي سجلات مكررة لـ workflow instances النشطة
-- 2. إنشاء فهرس فريد جزئي يضمن عدم وجود أكثر من instance
--    نشط واحد لكل entity (يمنع التكرار في fn_init_workflow)
-- ============================================================

BEGIN;

-- ============================================================
-- الخطوة 1: تنظيف السجلات المكررة
-- في حال وجود أكثر من workflow instance نشط لنفس entity
-- (نادر الحدوث)، نحتفظ بأحدثها وننهي الباقي.
-- ============================================================
WITH duplicate_instances AS (
    SELECT entity_type, entity_id
    FROM workflow.workflow_instances
    WHERE status_code = 'ACTIVE' AND deleted_at IS NULL
    GROUP BY entity_type, entity_id
    HAVING COUNT(*) > 1
),
ranked_instances AS (
    SELECT
        wi.id,
        wi.entity_type,
        wi.entity_id,
        ROW_NUMBER() OVER (
            PARTITION BY wi.entity_type, wi.entity_id
            ORDER BY wi.started_at DESC, wi.id DESC
        ) AS rn
    FROM workflow.workflow_instances wi
    JOIN duplicate_instances d
      ON d.entity_type = wi.entity_type AND d.entity_id = wi.entity_id
    WHERE wi.status_code = 'ACTIVE' AND wi.deleted_at IS NULL
)
UPDATE workflow.workflow_instances wi
SET
    status_code = 'COMPLETED',
    completed_at = now()
FROM ranked_instances ri
WHERE wi.id = ri.id AND ri.rn > 1;

-- ============================================================
-- الخطوة 2: إنشاء فهرس فريد جزئي
-- يضمن وجود instance نشط واحد فقط لكل (entity_type, entity_id).
-- الشرط: status_code = 'ACTIVE' AND deleted_at IS NULL
-- هذا يمنع إنشاء instance مكرر في fn_init_workflow عند إعادة المحاولة.
-- ============================================================
CREATE UNIQUE INDEX IF NOT EXISTS uq_workflow_instance_active
    ON workflow.workflow_instances (entity_type, entity_id)
    WHERE status_code = 'ACTIVE' AND deleted_at IS NULL;

COMMIT;
