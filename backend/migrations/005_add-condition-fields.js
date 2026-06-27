exports.up = (pgm) => {
  pgm.sql(`
    ALTER TABLE committee.accreditation_conditions
      ADD COLUMN IF NOT EXISTS severity VARCHAR(10) NOT NULL DEFAULT 'MAJOR',
      ADD COLUMN IF NOT EXISTS assessment_id BIGINT REFERENCES committee.accreditation_assessments(id),
      ADD COLUMN IF NOT EXISTS assessment_item_id BIGINT REFERENCES committee.accreditation_assessment_items(id),
      ADD COLUMN IF NOT EXISTS standard_version_id BIGINT REFERENCES committee.accreditation_standard_versions(id);

    ALTER TABLE committee.accreditation_conditions
      ADD CONSTRAINT chk_condition_severity CHECK (severity IN ('MINOR','MAJOR','CRITICAL'));

    CREATE INDEX IF NOT EXISTS idx_conditions_assessment ON committee.accreditation_conditions(assessment_id);
    CREATE INDEX IF NOT EXISTS idx_conditions_standard ON committee.accreditation_conditions(standard_version_id);
  `);
};

exports.down = (pgm) => {
  pgm.sql(`
    DROP INDEX IF EXISTS committee.idx_conditions_standard;
    DROP INDEX IF EXISTS committee.idx_conditions_assessment;
    ALTER TABLE committee.accreditation_conditions
      DROP CONSTRAINT IF EXISTS chk_condition_severity,
      DROP COLUMN IF EXISTS severity,
      DROP COLUMN IF EXISTS assessment_id,
      DROP COLUMN IF EXISTS assessment_item_id,
      DROP COLUMN IF EXISTS standard_version_id;
  `);
};
