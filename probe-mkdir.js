const http = require('http');
const fs = require('fs/promises');
const DIR = 'C:\\ERM-System\\backend\\uploads\\generated-documents';
const server = http.createServer(async (req, res) => {
  if (req.url === '/health') { res.end('ok'); return; }
  console.log('probe: starting mkdir');
  const t0 = Date.now();
  await fs.mkdir(DIR, { recursive: true });
  console.log('probe: mkdir done in', Date.now() - t0, 'ms');
  res.end('mkdir done');
});
server.listen(8099, () => console.log('probe server on 8099'));
