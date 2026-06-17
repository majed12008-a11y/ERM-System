exports.up = (pgm) => {
  pgm.sql(`
    -- security.users: missing created_by, updated_by, deleted_at, deleted_by
    ALTER TABLE security.users
      ADD COLUMN IF NOT EXISTS created_by BIGINT REFERENCES security.users(id),
      ADD COLUMN IF NOT EXISTS updated_by BIGINT REFERENCES security.users(id),
      ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ,
      ADD COLUMN IF NOT EXISTS deleted_by BIGINT REFERENCES security.users(id);

    -- security.user_responsibilities: missing created_by, deleted_at, deleted_by
    ALTER TABLE security.user_responsibilities
      ADD COLUMN IF NOT EXISTS created_by BIGINT REFERENCES security.users(id),
      ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ,
      ADD COLUMN IF NOT EXISTS deleted_by BIGINT REFERENCES security.users(id);

    -- system.saved_searches: missing created_by, updated_by, deleted_at, deleted_by
    ALTER TABLE system.saved_searches
      ADD COLUMN IF NOT EXISTS created_by BIGINT REFERENCES security.users(id),
      ADD COLUMN IF NOT EXISTS updated_by BIGINT REFERENCES security.users(id),
      ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ,
      ADD COLUMN IF NOT EXISTS deleted_by BIGINT REFERENCES security.users(id);
  `);
};

exports.down = (pgm) => {
  pgm.sql(`
    ALTER TABLE security.users
      DROP COLUMN IF EXISTS created_by,
      DROP COLUMN IF EXISTS updated_by,
      DROP COLUMN IF EXISTS deleted_at,
      DROP COLUMN IF EXISTS deleted_by;

    ALTER TABLE security.user_responsibilities
      DROP COLUMN IF EXISTS created_by,
      DROP COLUMN IF EXISTS deleted_at,
      DROP COLUMN IF EXISTS deleted_by;

    ALTER TABLE system.saved_searches
      DROP COLUMN IF EXISTS created_by,
      DROP COLUMN IF EXISTS updated_by,
      DROP COLUMN IF EXISTS deleted_at,
      DROP COLUMN IF EXISTS deleted_by;
  `);
};
