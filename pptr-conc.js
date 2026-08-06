const puppeteer = require('puppeteer-core');
(async () => {
  const t0 = Date.now();
  console.log('pptr: launching...');
  const browser = await puppeteer.launch({
    headless: true,
    executablePath: 'C:\\Program Files (x86)\\Google\\Chrome\\Application\\chrome.exe',
    args: ['--no-sandbox', '--disable-setuid-sandbox', '--disable-dev-shm-usage'],
  });
  console.log('pptr: launched in', Date.now() - t0, 'ms');
  const page = await browser.newPage();
  await page.setContent('<h1 dir="rtl">test</h1>', { waitUntil: 'load' });
  await page.pdf({ format: 'A4', path: 'C:\\Users\\ADM\\AppData\\Local\\Temp\\opencode\\pptr-conc.pdf', printBackground: true });
  console.log('pptr: pdf done in', Date.now() - t0, 'ms');
  await browser.close();
  process.exit(0);
})().catch((e) => { console.error('pptr: ERR', e.message); process.exit(1); });
