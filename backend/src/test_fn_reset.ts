import 'dotenv/config';
import { query } from './config/database';
import { userContext } from './middleware/context';

async function main() {
  userContext.enterWith({ userId: 0, requestId: 'test-reset' });
  console.log('Running fn_reset_password...');
  try {
    const result = await query(
      `SELECT security.fn_reset_password(
        encode(digest('direct-node-test', 'sha256'), 'hex')::text,
        'test_hash_' || gen_random_uuid()::text
      ) as r`
    );
    console.log('Result:', JSON.stringify(result.rows));
  } catch (err: any) {
    console.error('Error:', err.message);
    console.error('Stack:', err.stack?.split('\n').slice(0,3).join('\n'));
  }
  console.log('Done');
  process.exit(0);
}

main();
