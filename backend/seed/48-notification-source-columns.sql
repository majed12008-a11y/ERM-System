/*
 * 48-notification-source-columns.sql
 * ====================================
 *
 * Phase 4 — Notification Expansion (Priority 1, Commit 1)
 *
 * يضيف أعمدة المصدر (source_entity_type/source_entity_id)
 * إلى جدول الإشعارات لتتبع مصدر كل إشعار، مع المؤشرات
 * المناسبة لتحسين أداء الاستعلامات ومنع التكرار.
 *
 * التغييرات:
 *   1. إضافة source_entity_type, source_entity_id
 *   2. مؤشر مركب للمستخدم + تاريخ الإنشاء (لشاشة الإشعارات)
 *   3. مؤشر للمصدر (للاستعلامات الإدارية)
 *   4. مؤشر فريد جزئي لشهادات الاعتماد (منع إشعار مكرر)
 */

-- ============================================================
-- 1. Add source entity columns
-- ============================================================
ALTER TABLE communication.notifications
  ADD COLUMN IF NOT EXISTS source_entity_type VARCHAR(50),
  ADD COLUMN IF NOT EXISTS source_entity_id   BIGINT;

COMMENT ON COLUMN communication.notifications.source_entity_type
  IS 'نوع الكيان المصدر (Application, Condition, Certificate)';
COMMENT ON COLUMN communication.notifications.source_entity_id
  IS 'معرف الكيان المصدر';

-- ============================================================
-- 2. Index: user notification feed query
-- ============================================================
-- يحسن استعلام جلب إشعارات المستخدم مع ترتيب زمني تنازلي
CREATE INDEX IF NOT EXISTS idx_notifications_user_created
  ON communication.notifications (user_id, created_at DESC)
  WHERE deleted_at IS NULL;

-- ============================================================
-- 3. Index: source entity lookups
-- ============================================================
-- للاستعلامات الإدارية والعمليات المجمعة حسب المصدر
CREATE INDEX IF NOT EXISTS idx_notifications_source
  ON communication.notifications (source_entity_type, source_entity_id);

-- ============================================================
-- 4. Partial unique index: certificate dedup
-- ============================================================
-- يمنع إنشاء إشعار مكرر لنفس الشهادة والمستخدم ونوع الإشعار
CREATE UNIQUE INDEX IF NOT EXISTS uq_cert_notif_dedup
  ON communication.notifications (notification_type, user_id, source_entity_id)
  WHERE source_entity_type = 'Certificate';
