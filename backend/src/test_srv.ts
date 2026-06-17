import 'dotenv/config';
import express from 'express';
import { query } from './config/database';
import { userContext } from './middleware/context';

process.on('uncaughtException', (err) => {
  console.error('UNCAUGHT EXCEPTION:', err.message, err.stack?.split('\n')[1]);
});
process.on('unhandledRejection', (err: any) => {
  console.error('UNHANDLED REJECTION:', err.message, err.stack?.split('\n')[1]);
});

const app = express();
app.use(express.json());
app.use((req: any, res: any, next) => {
  userContext.run({ userId: 0, requestId: 'test' }, () => next());
});

app.post('/reset-password', async (req, res) => {
  try {
    const { token, password } = req.body;
    const crypto = await import('crypto');
    const tokenHash = crypto.createHash('sha256').update(token).digest('hex');
    const hash = 'test_static_hash_12345';
    const result = await query(
      'SELECT security.fn_reset_password($1, $2) as r',
      [tokenHash, hash]
    );
    const success = result.rows[0]?.r === true;
    if (!success) {
      return res.status(400).json({ error: 'Invalid token' });
    }
    res.json({ success: true });
  } catch (err: any) {
    console.error('CRASH:', err.message);
    res.status(500).json({ error: err.message });
  }
});

app.listen(3001, () => { console.log('Test server on 3001'); });
