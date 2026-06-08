import { describe, test, expect, beforeAll } from 'vitest';
import axios, { AxiosInstance } from 'axios';
import { Pool } from 'pg';

const BASE = 'http://localhost:3000/api/v1';
const pool = new Pool({ host: 'localhost', port: 5432, database: 'ethics_db', user: 'ethics_app', password: 'APP_PASSWORD' });

let adminApi: AxiosInstance;
let adminToken = '';

beforeAll(async () => {
  const loginRes = await axios.post(`${BASE}/security/auth/login`, { username: 'admin', password: 'admin123' }, { validateStatus: () => true });
  expect(loginRes.status).toBe(200);
  adminToken = loginRes.data.data.accessToken;
  adminApi = axios.create({ baseURL: BASE, validateStatus: () => true });
  adminApi.defaults.headers.common['Authorization'] = `Bearer ${adminToken}`;
  // Clean up known artifacts from previous runs so sign tests start fresh
  await pool.query("DELETE FROM documents.document_signatures WHERE document_id IN (20, 24)");
});

describe('Notifications', () => {
  test('GET /notifications returns list', async () => {
    const res = await adminApi.get('/communication/notifications');
    expect(res.status).toBe(200);
    expect(res.data.success).toBe(true);
  });
});

describe('Messaging', () => {
  let msgId: number;

  test('POST /messages sends a message', async () => {
    const res = await adminApi.post('/communication/messages', {
      recipient_ids: JSON.stringify([22, 23]),
      subject: 'Test Message',
      message_body: 'This is a test message body.',
    }, {
      headers: { 'Content-Type': 'application/json' },
    });
    expect(res.status).toBe(201);
    expect(res.data.data.subject).toBe('Test Message');
    msgId = res.data.data.id;
  });

  test('GET /messages returns inbox', async () => {
    const res = await adminApi.get('/communication/messages?box=inbox');
    expect(res.status).toBe(200);
    expect(res.data.success).toBe(true);
  });

  test('GET /messages returns sent', async () => {
    const res = await adminApi.get('/communication/messages?box=sent');
    expect(res.status).toBe(200);
    expect(res.data.success).toBe(true);
  });

  test('GET /messages/:id returns detail', async () => {
    const res = await adminApi.get(`/communication/messages/${msgId}`);
    expect(res.status).toBe(200);
    expect(res.data.data.subject).toBe('Test Message');
    expect(res.data.data.recipients).toBeDefined();
  });

  test('DELETE /messages/:id soft-deletes message', async () => {
    const res = await adminApi.delete(`/communication/messages/${msgId}`);
    expect(res.status).toBe(200);
    expect(res.data.success).toBe(true);
  });
});

describe('Review Forms', () => {
  let formId: number;
  let questionId: number;
  const TS = Date.now();

  test('POST /forms creates a review form', async () => {
    const res = await adminApi.post('/committee/reviews/forms', {
      form_code: `INTG_TEST_${TS}`,
      form_name: 'Integration Test Form',
      review_type: 'ETHICS',
      description: 'Form created during integration testing',
    });
    expect(res.status).toBe(201);
    expect(res.data.data.form_name).toBe('Integration Test Form');
    formId = res.data.data.id;
  });

  test('GET /forms lists forms', async () => {
    const res = await adminApi.get('/committee/reviews/forms');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(1);
    expect(res.data.data.some((f: any) => f.id === formId)).toBe(true);
  });

  test('POST /forms/:id/questions adds a TEXT question', async () => {
    const res = await adminApi.post(`/committee/reviews/forms/${formId}/questions`, {
      question_code: `TST_Q01_${TS}`,
      question_text: 'Describe the methodology?',
      question_type: 'TEXT',
      is_required: true,
      display_order: 1,
    });
    expect(res.status).toBe(201);
    expect(res.data.data.question_type).toBe('TEXT');
    questionId = res.data.data.id;
  });

  test('POST /forms/:id/questions adds a SCALE question', async () => {
    const res = await adminApi.post(`/committee/reviews/forms/${formId}/questions`, {
      question_code: `TST_Q02_${TS}`,
      question_text: 'Rate the scientific value (1-5)',
      question_type: 'SCALE',
      is_required: true,
      display_order: 2,
      scale_min: 1,
      scale_max: 5,
    });
    expect(res.status).toBe(201);
    expect(res.data.data.question_type).toBe('SCALE');
  });

  test('POST /forms/:id/questions adds a BOOLEAN question', async () => {
    const res = await adminApi.post(`/committee/reviews/forms/${formId}/questions`, {
      question_code: `TST_Q03_${TS}`,
      question_text: 'Is the consent form adequate?',
      question_type: 'BOOLEAN',
      is_required: true,
      display_order: 3,
    });
    expect(res.status).toBe(201);
    expect(res.data.data.question_type).toBe('BOOLEAN');
  });

  test('GET /forms/:formId/questions returns questions', async () => {
    const res = await adminApi.get(`/committee/reviews/forms/${formId}/questions`);
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(3);
  });

  test('DELETE /forms/:formId/questions/:questionId deletes question', async () => {
    const res = await adminApi.delete(`/committee/reviews/forms/${formId}/questions/${questionId}`);
    expect(res.status).toBe(200);
    expect(res.data.success).toBe(true);
  });
});

describe('E-Signatures', () => {
  test('POST /documents/:id/sign creates signature', async () => {
    const res = await adminApi.post('/documents/20/sign', {
      signature_type: 'ELECTRONIC',
    });
    expect(res.status).toBe(201);
    expect(res.data.data.signer_id).toBeDefined();
    expect(res.data.data.signature_hash).toBeDefined();
  });

  test('GET /documents/:id/signatures returns signatures', async () => {
    const res = await adminApi.get('/documents/20/signatures');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(1);
  });
});

describe('Workflow', () => {
  test('GET /definitions returns workflow definitions', async () => {
    const res = await adminApi.get('/workflow/definitions');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(1);
  });

  test('GET /instances/:entityType/:entityId returns instance', async () => {
    const res = await adminApi.get('/workflow/instances/Application/15');
    expect(res.status).toBe(200);
    expect(res.data.data).not.toBeNull();
    expect(res.data.data.status_code).toBe('ACTIVE');
  });

  test('GET /available-transitions returns transitions', async () => {
    const res = await adminApi.get('/workflow/available-transitions/Application/12');
    expect(res.status).toBe(200);
    expect(res.data.data.transitions.length).toBeGreaterThanOrEqual(0);
  });
});

describe('Reporting', () => {
  test('GET /dashboard/stats returns stats', async () => {
    const res = await adminApi.get('/reporting/dashboard/stats');
    expect(res.status).toBe(200);
    expect(res.data.data.applications).toBeDefined();
    expect(res.data.data.projects).toBeDefined();
    expect(res.data.data.upcomingMeetings).toBeDefined();
    expect(res.data.data.pendingReviews).toBeDefined();
  });

  test('GET /status-summary returns aggregate', async () => {
    const res = await adminApi.get('/reporting/status-summary');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(1);
  });

  test('GET /applications-trend returns monthly trend', async () => {
    const res = await adminApi.get('/reporting/applications-trend');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(0);
  });
});

describe('Permissions (as different roles)', () => {
  let researcherApi: AxiosInstance;

  test('Login as researcher', async () => {
    const res = await axios.post(`${BASE}/security/auth/login`, { username: 'researcher1', password: 'Test@1234' }, { validateStatus: () => true });
    expect(res.status).toBe(200);
    researcherApi = axios.create({ baseURL: BASE, validateStatus: () => true });
    researcherApi.defaults.headers.common['Authorization'] = `Bearer ${res.data.data.accessToken}`;
  });

  test('Researcher can view own applications', async () => {
    const res = await researcherApi.get('/core/applications');
    expect(res.status).toBe(200);
  });

  test('Researcher cannot list users (no user.view)', async () => {
    const res = await researcherApi.get('/security/users');
    expect(res.status).toBe(403);
  });

  test('Researcher cannot create review forms', async () => {
    const res = await researcherApi.post('/committee/reviews/forms', { form_name: 'x', form_code: 'X', review_type: 'FULL_BOARD' });
    expect(res.status).toBe(403);
  });

  test('Researcher can sign documents', async () => {
    const res = await researcherApi.post('/documents/24/sign', { signature_type: 'ELECTRONIC' });
    expect(res.status).toBe(201);
  });

  test('Researcher cannot assign reviews', async () => {
    const res = await researcherApi.post('/committee/reviews/assign', { application_id: 12, reviewer_id: 24, review_type: 'ETHICS' });
    expect(res.status).toBe(403);
  });
});
