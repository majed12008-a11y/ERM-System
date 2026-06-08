import { performance } from 'node:perf_hooks';

const BASE = 'http://localhost:3000/api/v1';
const SCENARIO_ITERATIONS = 15;
const CONCURRENCY = 5;

const endpointStats = new Map();
const errorStats = { total: 0, byStatus: new Map() };

function record(name, duration, status, err) {
  if (!endpointStats.has(name)) endpointStats.set(name, []);
  endpointStats.get(name).push({ duration, status, err });
  if (status >= 400) {
    errorStats.total++;
    errorStats.byStatus.set(status, (errorStats.byStatus.get(status) || 0) + 1);
  }
}

function p(arr, percentile) {
  if (arr.length === 0) return 0;
  const sorted = [...arr].sort((a, b) => a - b);
  const idx = Math.ceil((percentile / 100) * sorted.length) - 1;
  return sorted[Math.max(0, idx)];
}

async function req(method, path, body, token) {
  const headers = { 'Content-Type': 'application/json' };
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const start = performance.now();
  let res;
  try {
    res = await fetch(`${BASE}${path}`, { method, headers, body: body ? JSON.stringify(body) : void 0 });
    const data = await res.json();
    const dur = performance.now() - start;
    return { status: res.status, duration: dur, data };
  } catch (err) {
    const dur = performance.now() - start;
    return { status: 0, duration: dur, data: null, error: err.message };
  }
}

async function login(username, password) {
  const r = await req('POST', '/security/auth/login', { username, password });
  if (r.status !== 200) throw new Error(`Login failed for ${username}: ${r.status}`);
  return { token: r.data.data.accessToken, userId: parseInt(r.data.data.userId) };
}

async function runConcurrent(tasks, concurrency) {
  const results = [];
  const queue = [...tasks];
  const workers = Array.from({ length: Math.min(concurrency, queue.length) }, async () => {
    while (queue.length > 0) {
      const task = queue.shift();
      try { results.push(await task()); } catch (e) { results.push({ error: e }); }
    }
  });
  await Promise.all(workers);
  return results;
}

function printReport() {
  console.log('\n============================================================');
  console.log('  H3 — LOAD TEST BASELINE REPORT');
  console.log('============================================================\n');

  const allDurations = [];
  for (const [, measurements] of endpointStats) {
    for (const m of measurements) {
      if (m.status < 400) allDurations.push(m.duration);
    }
  }

  console.log('  GLOBAL METRICS');
  console.log('  ─────────────────────────────────────────────────────────');
  console.log(`  Total requests:        ${allDurations.length + errorStats.total}`);
  console.log(`  Successful:            ${allDurations.length}`);
  console.log(`  Errors (4xx+):         ${errorStats.total}`);
  const errorRate = allDurations.length + errorStats.total > 0
    ? (errorStats.total / (allDurations.length + errorStats.total) * 100).toFixed(2)
    : '0.00';
  console.log(`  Error rate:            ${errorRate}%`);
  console.log(`  Global P50:            ${p(allDurations, 50).toFixed(1)} ms`);
  console.log(`  Global P95:            ${p(allDurations, 95).toFixed(1)} ms`);
  console.log(`  Global P99:            ${p(allDurations, 99).toFixed(1)} ms`);

  if (errorStats.byStatus.size > 0) {
    console.log('\n  ERROR BREAKDOWN');
    for (const [status, count] of errorStats.byStatus) {
      console.log(`    HTTP ${status}:         ${count}`);
    }
  }

  console.log('\n  PER-ENDPOINT METRICS');
  console.log('  ─────────────────────────────────────────────────────────');
  console.log(`  ${'Endpoint'.padEnd(50)} ${'Count'.padEnd(6)} ${'P50'.padEnd(8)} ${'P95'.padEnd(8)} ${'P99'.padEnd(8)} ${'Errors'}`);
  console.log('  ' + '─'.repeat(90));

  for (const [name, measurements] of endpointStats) {
    const ok = measurements.filter(m => m.status < 400);
    const errs = measurements.filter(m => m.status >= 400);
    const times = ok.map(m => m.duration);
    console.log(
      `  ${name.padEnd(50)} ${String(times.length).padEnd(6)} ${p(times, 50).toFixed(1).padEnd(8)} ${p(times, 95).toFixed(1).padEnd(8)} ${p(times, 99).toFixed(1).padEnd(8)} ${errs.length}`
    );
  }

  console.log('\n============================================================');
  console.log('  END OF REPORT');
  console.log('============================================================\n');
}

async function main() {
  console.log('--- H3 LOAD TEST ---');
  console.log(`Target: ${BASE}`);
  console.log(`Iterations per scenario: ${SCENARIO_ITERATIONS}`);
  console.log(`Concurrency: ${CONCURRENCY}`);
  console.log('');

  const startTime = Date.now();

  // ── Login users once ──────────────────────────────────────────────
  console.log('[SETUP] Logging in users...');
  const admin = await login('admin', 'admin123');
  const researcher = await login('researcher1', 'Test@1234');
  const chairperson = await login('chairperson', 'Test@1234');
  let ethicsAdmin = admin;
  try { ethicsAdmin = await login('ethics_admin', 'Test@1234'); } catch { ethicsAdmin = admin; }
  console.log('[SETUP] Users logged in.');

  // ═══════════════════════════════════════════════════════════════════
  // SCENARIO 1 — Authentication Flow
  // ═══════════════════════════════════════════════════════════════════
  console.log('\n[SCENARIO 1] Authentication Flow...');
  const s1Tasks = [];
  for (let i = 0; i < SCENARIO_ITERATIONS; i++) {
    s1Tasks.push(async () => {
      const r1 = await req('POST', '/security/auth/login', { username: 'admin', password: 'admin123' });
      record('S1: POST /auth/login', r1.duration, r1.status, r1.error);
      if (r1.status === 200) {
        const t = r1.data.data.accessToken;
        const r2 = await req('GET', '/security/auth/me', null, t);
        record('S1: GET /security/auth/me', r2.duration, r2.status, r2.error);
      }
    });
  }
  await runConcurrent(s1Tasks, CONCURRENCY);

  // ═══════════════════════════════════════════════════════════════════
  // SCENARIO 2 — Project Lifecycle
  // ═══════════════════════════════════════════════════════════════════
  console.log('[SCENARIO 2] Project Lifecycle...');
  const s2Tasks = [];
  for (let i = 0; i < SCENARIO_ITERATIONS; i++) {
    s2Tasks.push(async () => {
      const r1 = await req('POST', '/core/projects', {
        title_ar: `مشروع اختبار ${Date.now()}`,
        title_en: `Test Project ${Date.now()}`,
        project_code: `TP-${Date.now()}`,
        institution_id: 1,
        principal_investigator_id: 27,
        objectives: `Objectives for project ${Date.now()}`,
        approval_status: 'DRAFT',
      }, researcher.token);
      record('S2: POST /core/projects', r1.duration, r1.status, r1.error);
      if (r1.status === 201 && r1.data?.data?.id) {
        const pid = r1.data.data.id;
        const r2 = await req('GET', `/core/projects`, null, researcher.token);
        record('S2: GET /core/projects', r2.duration, r2.status, r2.error);
        const r3 = await req('GET', `/core/projects/${pid}`, null, researcher.token);
        record('S2: GET /core/projects/:id', r3.duration, r3.status, r3.error);
        // No project update endpoint exists in routes; skip PUT
      }
    });
  }
  await runConcurrent(s2Tasks, CONCURRENCY);

  // ═══════════════════════════════════════════════════════════════════
  // SCENARIO 3 — Application Workflow
  // ═══════════════════════════════════════════════════════════════════
  console.log('[SCENARIO 3] Application Workflow...');
  // Use existing seed applications (ids 11-15 from seed) + newly created ones
  const seedAppIds = [11, 12, 13, 14, 15];

  const s3Tasks = [];
  for (let i = 0; i < SCENARIO_ITERATIONS; i++) {
    const aid = seedAppIds[i % seedAppIds.length];
    s3Tasks.push(async () => {
      const r1 = await req('GET', '/core/applications', null, researcher.token);
      record('S3: GET /core/applications (list)', r1.duration, r1.status, r1.error);

      const r2 = await req('GET', `/core/applications/${aid}`, null, researcher.token);
      record('S3: GET /core/applications/:id', r2.duration, r2.status, r2.error);

      const r3 = await req('GET', `/core/applications/${aid}`, null, chairperson.token);
      record('S3: GET /core/applications/:id (chair)', r3.duration, r3.status, r3.error);

      const r4 = await req('PATCH', `/core/applications/${aid}/status`, { status: 'SUBMITTED' }, ethicsAdmin.token);
      record('S3: PATCH /applications/:id/status', r4.duration, r4.status, r4.error);
    });
  }
  await runConcurrent(s3Tasks, CONCURRENCY);

  // ═══════════════════════════════════════════════════════════════════
  // SCENARIO 4 — Committee Operations
  // ═══════════════════════════════════════════════════════════════════
  console.log('[SCENARIO 4] Committee Operations...');
  const s4Tasks = [];
  for (let i = 0; i < SCENARIO_ITERATIONS; i++) {
    s4Tasks.push(async () => {
      const futureDate = new Date(Date.now() + 7 * 24 * 60 * 60 * 1000).toISOString();
      const r1 = await req('POST', '/committee/meetings', {
        committee_id: 3,
        meeting_date: futureDate,
        location: 'Room A',
        meeting_type: 'REGULAR',
      }, ethicsAdmin.token);
      record('S4: POST /committee/meetings', r1.duration, r1.status, r1.error);

      const r2 = await req('GET', '/committee/committees', null, ethicsAdmin.token);
      record('S4: GET /committee/committees', r2.duration, r2.status, r2.error);

      const r3 = await req('GET', '/committee/members/1/terms', null, ethicsAdmin.token);
      record('S4: GET /committee/members/:id/terms', r3.duration, r3.status, r3.error);
    });
  }
  await runConcurrent(s4Tasks, CONCURRENCY);

  // ═══════════════════════════════════════════════════════════════════
  // SCENARIO 5 — Communication
  // ═══════════════════════════════════════════════════════════════════
  console.log('[SCENARIO 5] Communication...');
  const s5Tasks = [];
  for (let i = 0; i < SCENARIO_ITERATIONS; i++) {
    s5Tasks.push(async () => {
      const r1 = await req('POST', '/messages', {
        recipient_ids: [22, 23, 24, 25, 26, 27, 28, 21],
        subject: `Load Test Message ${Date.now()}`,
        message_body: `This is a test message with batch recipients. Iteration ${i}.`,
      }, admin.token);
      record('S5: POST /messages (8 recipients)', r1.duration, r1.status, r1.error);

      const r2 = await req('GET', '/messages?box=inbox', null, admin.token);
      record('S5: GET /messages (inbox)', r2.duration, r2.status, r2.error);

      const r3 = await req('GET', '/messages?box=sent', null, admin.token);
      record('S5: GET /messages (sent)', r3.duration, r3.status, r3.error);

      const r4 = await req('GET', '/notifications', null, admin.token);
      record('S5: GET /notifications', r4.duration, r4.status, r4.error);

      const r5 = await req('GET', '/notifications/unread-count', null, admin.token);
      record('S5: GET /notifications/unread-count', r5.duration, r5.status, r5.error);
    });
  }
  await runConcurrent(s5Tasks, CONCURRENCY);

  // ═══════════════════════════════════════════════════════════════════
  // SCENARIO 6 — Dashboard & Reporting
  // ═══════════════════════════════════════════════════════════════════
  console.log('[SCENARIO 6] Dashboard & Reporting...');
  const s6Tasks = [];
  for (let i = 0; i < SCENARIO_ITERATIONS; i++) {
    s6Tasks.push(async () => {
      const r1 = await req('GET', '/admin/stats', null, admin.token);
      record('S6: GET /admin/stats', r1.duration, r1.status, r1.error);

      const r2 = await req('GET', '/reporting/dashboard/stats', null, admin.token);
      record('S6: GET /reporting/dashboard/stats', r2.duration, r2.status, r2.error);

      const r3 = await req('GET', '/reporting/applications?page=1&limit=10', null, admin.token);
      record('S6: GET /reporting/applications', r3.duration, r3.status, r3.error);

      const r4 = await req('GET', '/reporting/status-summary', null, admin.token);
      record('S6: GET /reporting/status-summary', r4.duration, r4.status, r4.error);

      const r5 = await req('GET', '/reporting/applications-trend', null, admin.token);
      record('S6: GET /reporting/applications-trend', r5.duration, r5.status, r5.error);

      const r6 = await req('GET', '/admin/audit-log?page=1&limit=20', null, admin.token);
      record('S6: GET /admin/audit-log', r6.duration, r6.status, r6.error);
    });
  }
  await runConcurrent(s6Tasks, CONCURRENCY);

  const elapsed = ((Date.now() - startTime) / 1000).toFixed(1);
  console.log(`\n[DONE] All scenarios completed in ${elapsed}s`);
  printReport();
}

main().catch(err => {
  console.error('Load test failed:', err);
  process.exit(1);
});
