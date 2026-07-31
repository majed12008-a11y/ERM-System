const fs = require('fs');
const en = JSON.parse(fs.readFileSync('./frontend/src/locales/en.json', 'utf8'));
const ar = JSON.parse(fs.readFileSync('./frontend/src/locales/ar.json', 'utf8'));

function flat(obj, prefix, results) {
  for (const [k, v] of Object.entries(obj)) {
    const key = prefix ? `${prefix}.${k}` : k;
    if (typeof v === 'object' && v !== null) flat(v, key, results);
    else results.push([key, v]);
  }
}

const allEn = [];
flat(en, '', allEn);
const allAr = [];
flat(ar, '', allAr);

// Find generate/preview/document/template/audit/snapshot/history related keys
const patterns = ['generat', 'preview', 'document', 'template', 'audit', 'snapshot', 'history', 'render', 'variable', 'inspector', 'version'];
for (const [k, v] of allEn) {
  const kl = k.toLowerCase();
  if (patterns.some(p => kl.includes(p))) {
    const arEntry = allAr.find(([ak]) => ak === k);
    console.log(`EN: ${k} = ${v}`);
    if (arEntry) console.log(`AR: ${k} = ${arEntry[1]}`);
    console.log('');
  }
}
