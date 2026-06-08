import { describe, test, expect, beforeAll } from 'vitest';
import axios, { AxiosInstance } from 'axios';

const BASE = 'http://localhost:3000/api/v1';

let api: AxiosInstance;
let token = '';
let cookieJar: string[] = [];

function extractCookies(res: any) {
  const setCookie = res.headers?.['set-cookie'];
  if (setCookie) {
    cookieJar = setCookie.map((c: string) => c.split(';')[0]);
  }
}

beforeAll(async () => {
  api = axios.create({ baseURL: BASE, validateStatus: () => true, withCredentials: true });
  api.interceptors.request.use((config) => {
    if (cookieJar.length) {
      config.headers.Cookie = cookieJar.join('; ');
    }
    return config;
  });
  const loginRes = await api.post('/security/auth/login', {
    username: 'admin',
    password: 'admin123',
  });
  expect(loginRes.status).toBe(200);
  token = loginRes.data.data.accessToken;
  api.defaults.headers.common['Authorization'] = `Bearer ${token}`;
  extractCookies(loginRes);
});

describe('Integration Tests', () => {
  test('GET /me returns current user', async () => {
    const res = await api.get('/security/auth/me');
    expect(res.status).toBe(200);
    expect(res.data.data.username).toBe('admin');
  });

  test('GET /users returns users list', async () => {
    const res = await api.get('/security/users');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(4);
  });

  test('GET /projects returns projects list', async () => {
    const res = await api.get('/core/projects');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(2);
  });

  test('GET /applications returns applications list', async () => {
    const res = await api.get('/core/applications');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(2);
  });

  test('GET /applications/:id returns application detail', async () => {
    const res = await api.get('/core/applications/12');
    expect(res.status).toBe(200);
    expect(res.data.data.application_number).toBe('APP-2024-002');
  });

  test('GET /safety/risk-register returns risks', async () => {
    const res = await api.get('/safety/risk-register');
    expect(res.status).toBe(200);
  });

  test('GET /committee/committees returns committees', async () => {
    const res = await api.get('/committee/committees');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(1);
  });

  test('GET /security/responsibility-types returns types', async () => {
    const res = await api.get('/security/responsibility-types');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(6);
  });

  test('GET /session saved-searches returns searches', async () => {
    const res = await api.get('/system/saved-searches');
    expect(res.status).toBe(200);
  });

  test('GET /core/research-categories returns categories', async () => {
    const res = await api.get('/core/research-categories');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(5);
  });

  test('GET /reference/professions returns professions', async () => {
    const res = await api.get('/reference/professions');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(7);
  });

  test('GET /documents/classifications returns classifications', async () => {
    const res = await api.get('/documents/classifications');
    expect(res.status).toBe(200);
    expect(res.data.data.length).toBeGreaterThanOrEqual(4);
  });

  test('POST /core/projects creates a project', async () => {
    const res = await api.post('/core/projects', {
      title_ar: 'مشروع اختبار',
      title_en: 'Test Project',
      abstract_ar: 'وصف المشروع',
      objectives: 'اختبار أهداف المشروع',
      research_category: 'SOCIAL_SCIENCE',
      start_date: '2026-06-01',
      expected_end_date: '2026-12-31',
    });
    expect(res.status).toBe(201);
    expect(res.data.data.title_ar).toBe('مشروع اختبار');
  });

  test('GET /reference/institutions-registry returns institutions', async () => {
    const res = await api.get('/reference/institutions-registry');
    expect(res.status).toBe(200);
  });

  test('GET /committee/members/1/terms returns member terms', async () => {
    const res = await api.get('/committee/members/1/terms');
    expect(res.status).toBe(200);
  });

  test('GET /committee/members/2/qualifications returns qualifications', async () => {
    const res = await api.get('/committee/members/2/qualifications');
    expect(res.status).toBe(200);
  });
});
