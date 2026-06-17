import { createHash } from 'crypto';
import { Client } from 'pg';
import express from 'express';

const app = express();
app.use(express.json());

app.post('/reset-password', async (req, res) => {
  let client;
  try {
    const { token, password } = req.body;
    const tokenHash = createHash('sha256').update(token).digest('hex');
    const hash = 'hardcoded_hash_value';
    client = new Client({
      host: 'localhost', port: 5432, database: 'ethics_db',
      user: 'ethics_app', password: 'postgres'
    });
    await client.connect();
    await client.query("SELECT set_config('app.user_id', '0', false)");
    console.log('A: pre-query');
    const result = await client.query(
      'SELECT security.fn_reset_password($1, $2) as r',
      [tokenHash, hash]
    );
    console.log('B: post-query, result:', result.rows[0]?.r);
    const success = result.rows[0]?.r === true;
    if (!success) return res.status(400).json({ error: 'Invalid token' });
    res.json({ success: true });
    console.log('C: response sent');
  } catch (err: any) {
    console.error('ERROR:', err.message);
    res.status(500).json({ error: err.message });
  } finally {
    if (client) {
      try { await client.end(); } catch {}
    }
  }
});

app.listen(3001, () => console.log('MIN on 3001'));
