const { Pool } = require('pg');
const crypto = require('crypto');

const pool = new Pool({
  host: 'localhost', port: 5432, database: 'ethics_db',
  user: 'ethics_app', password: 'postgres', max: 3,
});

async function main() {
  const client = await pool.connect();
  await client.query("SELECT set_config('app.user_id', '0', false)");
  const tokenHash = crypto.createHash('sha256').update('crash-test-2').digest('hex');
  console.log('Token hash:', tokenHash);
  const result = await client.query(
    'SELECT security.fn_reset_password($1, $2) as r',
    [tokenHash, 'test_hash_value']
  );
  console.log('Result:', JSON.stringify(result.rows[0]));
  client.release();
  await pool.end();
  console.log('DONE');
}

main().catch(e => { console.error('FATAL:', e.message, e.stack?.split('\n')[1]); process.exit(1); });
