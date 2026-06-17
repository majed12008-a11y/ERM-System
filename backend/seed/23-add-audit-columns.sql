-- Add audit columns to tables that are missing them (safe for re-run)

-- security.users
ALTER TABLE security.users
  ADD COLUMN IF NOT EXISTS created_by BIGINT,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now(),
  ADD COLUMN IF NOT EXISTS updated_by BIGINT,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

-- committee.committee_members
ALTER TABLE committee.committee_members
  ADD COLUMN IF NOT EXISTS created_by BIGINT,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now(),
  ADD COLUMN IF NOT EXISTS updated_by BIGINT,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

-- security.user_responsibilities (used by deleteResponsibility)
ALTER TABLE security.user_responsibilities
  ADD COLUMN IF NOT EXISTS deleted_by BIGINT,
  ADD COLUMN IF NOT EXISTS deleted_at TIMESTAMPTZ;
