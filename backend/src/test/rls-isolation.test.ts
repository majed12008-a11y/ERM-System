import { describe, test, expect, beforeAll } from 'vitest';
import axios, { AxiosInstance } from 'axios';

const BASE = 'http://localhost:3000/api/v1';

let adminApi: AxiosInstance;
let researcherApi: AxiosInstance;
let adminToken = '';
let researcherToken = '';

beforeAll(async () => {
  adminApi = axios.create({ baseURL: BASE, validateStatus: () => true, withCredentials: true });
  const adminLogin = await adminApi.post('/security/auth/login', {
    username: 'admin',
    password: 'admin123',
  });
  expect(adminLogin.status).toBe(200);
  adminToken = adminLogin.data.data.accessToken;
  adminApi.defaults.headers.common['Authorization'] = `Bearer ${adminToken}`;

  researcherApi = axios.create({ baseURL: BASE, validateStatus: () => true, withCredentials: true });
  const researcherLogin = await researcherApi.post('/security/auth/login', {
    username: 'researcher1',
    password: 'Test@1234',
  });
  expect(researcherLogin.status).toBe(200);
  researcherToken = researcherLogin.data.data.accessToken;
  researcherApi.defaults.headers.common['Authorization'] = `Bearer ${researcherToken}`;
});

describe('RLS Isolation — Admin Access', () => {
  test('admin can list all users', async () => {
    const res = await adminApi.get('/security/users');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(6);
  });

  test('admin can see user detail of another user', async () => {
    const res = await adminApi.get('/security/users/2');
    expect(res.status).toBe(200);
    expect(res.data.data.username).toBe('ethics_admin');
  });

  test('admin can list all applications', async () => {
    const res = await adminApi.get('/core/applications');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(2);
  });

  test('admin can read workflow instances', async () => {
    const res = await adminApi.get('/workflow/instances');
    expect(res.status).toBe(200);
  });

  test('admin can read workflow tasks', async () => {
    const res = await adminApi.get('/workflow/tasks');
    expect(res.status).toBe(200);
  });

  test('admin can list saved searches', async () => {
    const res = await adminApi.get('/system/saved-searches');
    expect(res.status).toBe(200);
  });
});

describe('RLS Isolation — Researcher Restrictions', () => {
  test('researcher can list users but only sees own record', async () => {
    const res = await researcherApi.get('/security/users');
    expect(res.status).toBe(200);
    for (const user of res.data.data) {
      expect(user.id).toBe(researcherLoginUserId(researcherToken));
    }
  });

  test('researcher cannot see another user profile directly', async () => {
    const res = await researcherApi.get('/security/users/1');
    expect(res.status).toBe(404);
  });

  test('researcher can see own applications but not others', async () => {
    const res = await researcherApi.get('/core/applications');
    expect(res.status).toBe(200);
    for (const app of res.data.data) {
      expect(app.submitted_by).toBe(researcherLoginUserId(researcherToken));
    }
  });

  test('researcher cannot access admin-only risk endpoints', async () => {
    const res = await researcherApi.post('/safety/risk-register', {
      title: 'test',
      risk_level: 'LOW',
      description: 'test',
    });
    expect(res.status).toBe(403);
  });

  test('researcher cannot create workflow instances', async () => {
    const res = await researcherApi.post('/workflow/instances', {
      workflow_id: 1,
      entity_type: 'Application',
      entity_id: 999,
    });
    expect(res.status).toBe(403);
  });
});

function researcherLoginUserId(token: string): number | null {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]));
    return payload.userId ?? payload.sub ?? null;
  } catch {
    return null;
  }
}
