import pg from 'pg';
const pool = new pg.Pool({
  user: 'postgres',
  password: 'ethics_owner',
  host: 'localhost',
  port: 5432,
  database: 'ethics_db'
});
const r = await pool.query(
  `SELECT column_name, data_type, is_nullable, column_default
   FROM information_schema.columns
   WHERE table_schema = 'core' AND table_name = 'projects'
   ORDER BY ordinal_position`
);
r.rows.forEach(c => console.log(c.column_name + '\t' + c.data_type + '\t' + c.is_nullable + '\t' + (c.column_default || '')));
await pool.end();
