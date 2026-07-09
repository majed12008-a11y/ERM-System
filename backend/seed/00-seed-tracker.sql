/*
 * جدول تتبع تطبيق السيدات
 * Seed Tracker — records which seed files have been applied
 * and their checksums for idempotent application.
 *
 * This must be seed file 00 so it exists before any other seed runs.
 */
CREATE SCHEMA IF NOT EXISTS ops;

CREATE TABLE IF NOT EXISTS ops.seed_tracker (
  id            SERIAL PRIMARY KEY,
  filename      VARCHAR(255) NOT NULL UNIQUE,
  checksum      VARCHAR(64)  NOT NULL,
  applied_at    TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
  duration_ms   INTEGER,
  status        VARCHAR(20)  NOT NULL DEFAULT 'success'
                    CHECK (status IN ('success', 'failed', 'skipped')),
  error         TEXT
);

COMMENT ON TABLE  ops.seed_tracker IS 'Tracks which seed files have been applied and their integrity';
COMMENT ON COLUMN ops.seed_tracker.filename   IS 'Seed file name (e.g. 02-users.sql)';
COMMENT ON COLUMN ops.seed_tracker.checksum   IS 'SHA-256 hex digest of the file content';
COMMENT ON COLUMN ops.seed_tracker.applied_at IS 'When the seed was executed';
COMMENT ON COLUMN ops.seed_tracker.duration_ms IS 'Execution time in milliseconds';
COMMENT ON COLUMN ops.seed_tracker.status     IS 'success | failed | skipped';
COMMENT ON COLUMN ops.seed_tracker.error      IS 'Error message if status = failed';
