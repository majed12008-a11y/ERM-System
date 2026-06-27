import { describe, test, expect, beforeAll, afterAll } from 'vitest';
import axios, { AxiosInstance } from 'axios';

const BASE = 'http://localhost:8080/api/v1/committee/accreditation';

let adminApi: AxiosInstance;
let researcherApi: AxiosInstance;
let adminToken = '';
let researcherToken = '';
let adminId = 0;

let tempCycles: number[] = [];

beforeAll(async () => {
  const plain = axios.create({ validateStatus: () => true });

  const adminLogin = await plain.post('http://localhost:8080/api/v1/security/auth/login', {
    username: 'admin', password: 'admin123',
  });
  expect(adminLogin.status).toBe(200);
  adminToken = adminLogin.data.data.accessToken;
  adminId = adminLogin.data.data.user?.id || 1;

  const researcherLogin = await plain.post('http://localhost:8080/api/v1/security/auth/login', {
    username: 'researcher1', password: 'test1234',
  });
  expect(researcherLogin.status).toBe(200);
  researcherToken = researcherLogin.data.data.accessToken;

  adminApi = axios.create({ baseURL: BASE, validateStatus: () => true });
  adminApi.defaults.headers.common['Authorization'] = `Bearer ${adminToken}`;

  researcherApi = axios.create({ baseURL: BASE, validateStatus: () => true });
  researcherApi.defaults.headers.common['Authorization'] = `Bearer ${researcherToken}`;
});

afterAll(async () => {
  for (const id of tempCycles) {
    await adminApi.delete(`/cycles/${id}`);
  }
});

describe('Accreditation API — Cycles', () => {
  test('GET /cycles returns all cycles as admin', async () => {
    const res = await adminApi.get('/cycles');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(3);
  });

  test('GET /cycles/:id returns cycle detail with nested entities', async () => {
    const res = await adminApi.get('/cycles/1');
    expect(res.status).toBe(200);
    expect(res.data.data.status).toBe('ACCREDITED');
    expect(res.data.data.committee_name_ar).toBeTruthy();
    expect(res.data.data.institution_name).toBeTruthy();
    expect(Array.isArray(res.data.data.assessments)).toBe(true);
    expect(res.data.data.assessments.length).toBeGreaterThanOrEqual(1);
    expect(Array.isArray(res.data.data.decisions)).toBe(true);
  });

  test('GET /cycles/:id returns 404 for unknown cycle', async () => {
    const res = await adminApi.get('/cycles/99999');
    expect(res.status).toBe(404);
    expect(res.data.error).toMatch(/not found/i);
  });

  test('POST /cycles creates cycle for committee without active cycle', async () => {
    const res = await adminApi.post('/cycles', {
      committee_id: 4, standard_version_id: 1,
    });
    expect(res.status).toBe(201);
    expect(res.data.data.status).toBe('PENDING');
    expect(String(res.data.data.committee_id)).toBe('4');
    tempCycles.push(Number(res.data.data.id));
  });

  test('POST /cycles returns 409 for committee with active cycle', async () => {
    const res = await adminApi.post('/cycles', {
      committee_id: 1, standard_version_id: 1,
    });
    expect(res.status).toBe(409);
    expect(res.data.error).toMatch(/active cycle/i);
  });

  test('POST /cycles blocks researcher with 403', async () => {
    const res = await researcherApi.post('/cycles', {
      committee_id: 7, standard_version_id: 1,
    });
    expect(res.status).toBe(403);
  });

  test('PATCH /cycles/:id/status transitions PENDING -> UNDER_REVIEW -> ACCREDITED', async () => {
    const createRes = await adminApi.post('/cycles', {
      committee_id: 5, standard_version_id: 1,
    });
    expect(createRes.status).toBe(201);
    const cycleId = Number(createRes.data.data.id);
    tempCycles.push(cycleId);

    const submitRes = await adminApi.patch(`/cycles/${cycleId}/status`, {
      to_status: 'UNDER_REVIEW', decision: 'SUBMIT', decided_by: adminId,
    });
    expect(submitRes.status).toBe(200);
    expect(submitRes.data.data.cycle.status).toBe('UNDER_REVIEW');

    const approveRes = await adminApi.patch(`/cycles/${cycleId}/status`, {
      to_status: 'ACCREDITED', decision: 'APPROVE', decided_by: adminId,
      decision_reason: 'All standards met',
    });
    expect(approveRes.status).toBe(200);
    expect(approveRes.data.data.cycle.status).toBe('ACCREDITED');
    expect(approveRes.data.data.decision.decision).toBe('APPROVE');
    expect(approveRes.data.data.decision.decision_reason).toBe('All standards met');

    const decisionsRes = await adminApi.get(`/cycles/${cycleId}/decisions`);
    expect(decisionsRes.status).toBe(200);
    expect(decisionsRes.data.data.length).toBeGreaterThanOrEqual(2);
  });

  test('PATCH /cycles/:id/status rejects invalid transition', async () => {
    const createRes = await adminApi.post('/cycles', {
      committee_id: 7, standard_version_id: 1,
    });
    expect(createRes.status).toBe(201);
    const cycleId = Number(createRes.data.data.id);
    tempCycles.push(cycleId);

    const res = await adminApi.patch(`/cycles/${cycleId}/status`, {
      to_status: 'ACCREDITED', decision: 'APPROVE', decided_by: adminId,
    });
    expect(res.status).toBe(422);
  });

  test('PATCH /cycles/:id/status blocks researcher with 403', async () => {
    const res = await researcherApi.patch('/cycles/2/status', {
      to_status: 'ACCREDITED', decision: 'APPROVE', decided_by: 1,
    });
    expect(res.status).toBe(403);
  });
});

describe('Accreditation API — Standards', () => {
  test('GET /standards returns all 12 standards with version details', async () => {
    const res = await adminApi.get('/standards');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(12);
    expect(res.data.data[0].code).toBeTruthy();
    expect(res.data.data[0].name_ar).toBeTruthy();
    expect(res.data.data[0].version_label).toBeTruthy();
  });

  test('GET /standards?active_only=true returns only active', async () => {
    const res = await adminApi.get('/standards?active_only=true');
    expect(res.status).toBe(200);
    expect(res.data.data.every((s: any) => s.is_active === true)).toBe(true);
  });
});

describe('Accreditation API — Assessments', () => {
  let assessmentId: number;

  test('GET /cycles/:cycleId/assessments returns assessments with items', async () => {
    const res = await adminApi.get('/cycles/1/assessments');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(1);
    const assessment = res.data.data[0];
    expect(assessment.assessor_name).toBeTruthy();
    expect(Array.isArray(assessment.items)).toBe(true);
    expect(assessment.items.length).toBeGreaterThanOrEqual(1);
    expect(assessment.items[0].code).toBeTruthy();
    assessmentId = Number(assessment.id);
  });

  test('GET /assessments/:id returns single assessment with items', async () => {
    const res = await adminApi.get(`/assessments/${assessmentId}`);
    expect(res.status).toBe(200);
    expect(Number(res.data.data.id)).toBe(assessmentId);
    expect(res.data.data.overall_decision).toBe('RECOMMEND_APPROVE');
    expect(Array.isArray(res.data.data.items)).toBe(true);
  });

  test('GET /assessments/:id returns 404 for unknown', async () => {
    const res = await adminApi.get('/assessments/99999');
    expect(res.status).toBe(404);
  });

  test('POST /cycles/:cycleId/assessments creates assessment for UNDER_REVIEW cycle', async () => {
    const createRes = await adminApi.post('/cycles', {
      committee_id: 8, standard_version_id: 1,
    });
    expect(createRes.status).toBe(201);
    const cycleId = Number(createRes.data.data.id);
    tempCycles.push(cycleId);

    const submitRes = await adminApi.patch(`/cycles/${cycleId}/status`, {
      to_status: 'UNDER_REVIEW', decision: 'SUBMIT', decided_by: adminId,
    });
    expect(submitRes.status).toBe(200);

    const assessmentRes = await adminApi.post(`/cycles/${cycleId}/assessments`, {
      cycle_id: cycleId, overall_decision: 'DEFER',
      overall_justification: 'Awaiting additional documents',
      items: [{ standard_version_id: 1, is_met: false, findings: 'Missing SOP docs', score: 2 }],
    });
    expect(assessmentRes.status).toBe(201);
    expect(assessmentRes.data.data.overall_decision).toBe('DEFER');
    expect(String(assessmentRes.data.data.cycle_id)).toBe(String(cycleId));
  });

  test('POST /cycles/:cycleId/assessments blocks for non-UNDER_REVIEW cycle', async () => {
    const res = await adminApi.post('/cycles/1/assessments', {
      cycle_id: 1, overall_decision: 'DEFER',
    });
    expect(res.status).toBe(422);
    expect(res.data.error).toMatch(/UNDER_REVIEW/i);
  });

  test('PUT /assessments/:id/items replaces assessment items', async () => {
    const res = await adminApi.put(`/assessments/${assessmentId}/items`, {
      items: [
        { standard_version_id: 1, is_met: true, findings: 'Updated finding', score: 4 },
        { standard_version_id: 2, is_met: true, findings: 'All good', score: 5 },
      ],
    });
    expect(res.status).toBe(200);

    const getRes = await adminApi.get(`/assessments/${assessmentId}`);
    expect(getRes.data.data.items.length).toBe(2);
  });

  test('POST /assessments blocks researcher with 403', async () => {
    const res = await researcherApi.post('/cycles/2/assessments', {
      cycle_id: 2, overall_decision: 'DEFER',
    });
    expect(res.status).toBe(403);
  });
});

describe('Accreditation API — Evidence', () => {
  let evidenceId: number;

  test('POST /cycles/:cycleId/evidence creates evidence entry', async () => {
    const res = await adminApi.post('/cycles/2/evidence', {
      cycle_id: 2, standard_version_id: 1, notes: 'SOP document v3',
    });
    expect(res.status).toBe(201);
    expect(res.data.data.status).toBe('PENDING');
    expect(res.data.data.notes).toBe('SOP document v3');
    evidenceId = Number(res.data.data.id);
  });

  test('GET /cycles/:cycleId/evidence returns evidence list with uploader', async () => {
    const res = await adminApi.get('/cycles/2/evidence');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(1);
    expect(res.data.data.some((e: any) => Number(e.id) === evidenceId)).toBe(true);
    expect(res.data.data[0].uploader_name).toBeTruthy();
  });

  test('GET /evidence/:id returns single evidence', async () => {
    const res = await adminApi.get(`/evidence/${evidenceId}`);
    expect(res.status).toBe(200);
    expect(Number(res.data.data.id)).toBe(evidenceId);
  });

  test('PATCH /evidence/:id/status updates evidence status', async () => {
    const res = await adminApi.patch(`/evidence/${evidenceId}/status`, {
      status: 'ACCEPTED',
    });
    expect(res.status).toBe(200);
    expect(res.data.data.status).toBe('ACCEPTED');
  });

  test('PATCH /evidence/:id/status blocks researcher with 403', async () => {
    const res = await researcherApi.patch(`/evidence/${evidenceId}/status`, {
      status: 'ACCEPTED',
    });
    expect(res.status).toBe(403);
  });
});

describe('Accreditation API — Decisions', () => {
  test('GET /cycles/:cycleId/decisions returns decision history', async () => {
    const res = await adminApi.get('/cycles/1/decisions');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(3);
    expect(res.data.data[0].decider_name).toBeTruthy();
    expect(res.data.data[0].decision).toBeTruthy();
  });

  test('GET /decisions/:id returns single decision', async () => {
    const res = await adminApi.get('/decisions/1');
    expect(res.status).toBe(200);
    expect(res.data.data.decision).toBe('APPLY');
  });

  test('POST /cycles/:cycleId/decisions creates decision with reason (immutable audit trail)', async () => {
    const res = await adminApi.post('/cycles/2/decisions', {
      cycle_id: 2, from_status: 'UNDER_REVIEW', to_status: 'ACCREDITED',
      decision: 'APPROVE', decided_by: adminId,
      decision_reason: 'Final approval after full assessment',
    });
    expect(res.status).toBe(201);
    expect(res.data.data.decision).toBe('APPROVE');
    expect(res.data.data.to_status).toBe('ACCREDITED');
    expect(res.data.data.decision_reason).toBe('Final approval after full assessment');
  });

  test('POST /decisions blocks researcher with 403', async () => {
    const res = await researcherApi.post('/cycles/2/decisions', {
      cycle_id: 2, from_status: 'UNDER_REVIEW', to_status: 'ACCREDITED',
      decision: 'APPROVE', decided_by: 1,
    });
    expect(res.status).toBe(403);
  });
});

describe('Accreditation API — Authorization & Auth', () => {
  test('returns 401 without token', async () => {
    const plain = axios.create({ baseURL: BASE, validateStatus: () => true });
    const res = await plain.get('/cycles');
    expect(res.status).toBe(401);
  });

  test('researcher cannot POST cycle (403)', async () => {
    const res = await researcherApi.post('/cycles', {
      committee_id: 9, standard_version_id: 1,
    });
    expect(res.status).toBe(403);
  });

  test('researcher cannot PATCH cycle status (403)', async () => {
    const res = await researcherApi.patch('/cycles/2/status', {
      to_status: 'ACCREDITED', decision: 'APPROVE', decided_by: 1,
    });
    expect(res.status).toBe(403);
  });

  test('admin can GET all cycles (200)', async () => {
    const res = await adminApi.get('/cycles');
    expect(res.status).toBe(200);
  });
});
