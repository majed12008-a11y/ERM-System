import http from 'http';
import fs from 'fs/promises';

const DIR = 'C:\\ERM-System\\backend\\uploads\\generated-documents';

const server = http.createServer(async (req, res) => {
  if (req.url === '/health') { res.end('ok'); return; }
  console.log('probe-tsx: starting mkdir');
  const t0 = Date.now();
  await fs.mkdir(DIR, { recursive: true });
  console.log('probe-tsx: mkdir done in', Date.now() - t0, 'ms');
  res.end('mkdir done');
});
server.listen(8098, () => console.log('probe-tsx server on 8098'));
