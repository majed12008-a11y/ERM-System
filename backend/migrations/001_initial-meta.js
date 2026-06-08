/** @type { import('node-pg-migrate').MigrationBuilder } */
exports.up = (pgm) => {
  pgm.sql(`
    COMMENT ON DATABASE ethics_db IS 'National Ethics & Medical Research Governance Platform — v1.0.0';
  `);
};

exports.down = (pgm) => {
  pgm.sql(`
    COMMENT ON DATABASE ethics_db IS NULL;
  `);
};
