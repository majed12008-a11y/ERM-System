-- Add role_id and audit columns to committee.committee_members
ALTER TABLE committee.committee_members
  ADD COLUMN IF NOT EXISTS role_id BIGINT REFERENCES committee.committee_roles(id),
  ADD COLUMN IF NOT EXISTS created_by BIGINT,
  ADD COLUMN IF NOT EXISTS created_at TIMESTAMPTZ DEFAULT now(),
  ADD COLUMN IF NOT EXISTS updated_by BIGINT,
  ADD COLUMN IF NOT EXISTS updated_at TIMESTAMPTZ;

-- Update existing members with role from member_roles (if any were seeded)
UPDATE committee.committee_members cm
  SET role_id = mr.role_id
  FROM committee.member_roles mr
  WHERE mr.member_id = cm.id AND cm.role_id IS NULL;
