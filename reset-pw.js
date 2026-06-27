const { Pool } = require('pg');
const argon2 = require('argon2');
const pool = new Pool({ host: 'localhost', port: 5432, database: 'ethics_db', user: 'postgres', password: 'postgres' });
async function main() {
  const hash = await argon2.hash('admin123');
  console.log('Hash:', hash);
  await pool.query("UPDATE security.users SET password_hash =  WHERE username = 'admin'", [hash]);
  console.log('Updated');
  const r = await pool.query("SELECT username, password_hash FROM security.users WHERE username = 'admin'");
  console.log('Stored hash:', r.rows[0].password_hash);
  const r2 = await pool.query("UPDATE security.users SET password_hash =  WHERE username = 'admin' RETURNING username", [hash]);
  console.log('Update confirmed:', r2.rows[0].username);
  await pool.end();
}
main().catch(e => { console.error(e); process.exit(1); });