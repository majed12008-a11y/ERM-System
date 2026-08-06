import 'dotenv/config';
import { runWithUserId } from './src/middleware/context';
import { FormService } from './src/services/form.service';
import { AuthUser } from './src/shared/types';

(async () => {
  const user: AuthUser = { id: 105, username: 'smoke_researcher_2', role: 'researcher' } as any;
  const started = Date.now();
  console.log('starting generateDocument(22) as user 105...');
  try {
    const result = await runWithUserId(105, () =>
      new FormService().generateDocument(22, { language: 'ar' }, user)
    );
    console.log(`DONE in ${Date.now() - started}ms:`, JSON.stringify(result).slice(0, 300));
  } catch (e: any) {
    console.log(`FAILED in ${Date.now() - started}ms: ${e.message}${e.status ? ' (status ' + e.status + ')' : ''}`);
  }
  process.exit(0);
})();
