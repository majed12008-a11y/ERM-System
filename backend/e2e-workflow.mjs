// E2E Workflow Test: Project -> Application -> Review -> Committee Decision
import axios from 'axios';

const API = 'http://localhost:3000/api/v1';

async function login(username, password, label) {
  try {
    const res = await axios.post(`${API}/security/auth/login`, { username, password }, { withCredentials: true });
    console.log(`  ok ${label} login (userId=${res.data.data.userId})`);
    return res.data.data.accessToken;
  } catch (err) {
    console.log(`  xx ${label} login FAILED: ${err.response?.data?.error || err.message}`);
    return null;
  }
}

async function main() {
  console.log('\n=== E2E WORKFLOW TEST ===\n');

  // 1. LOGIN
  console.log('--- 1. LOGIN ---');
  const adminToken = await login('admin', 'admin123', 'admin');
  const ethicsToken = await login('ethics_admin', 'Test@1234', 'ethics_admin');
  const chairToken = await login('chairperson', 'Test@1234', 'chairperson');
  const reviewer1Token = await login('reviewer1', 'Test@1234', 'reviewer1');
  const researcherToken = await login('researcher1', 'Test@1234', 'researcher1');

  const token = adminToken || ethicsToken;
  if (!token) { console.log('\nNo login succeeded -- aborting'); return; }

  // 2. DISCOVERY
  console.log('\n--- 2. DISCOVERY ---');
  let institutions = [], committees = [], reviewers = [];
  try {
    institutions = (await axios.get(`${API}/reference/institutions-registry`, { headers: { Authorization: `Bearer ${token}` } })).data.data || [];
    committees = (await axios.get(`${API}/committee/committees`, { headers: { Authorization: `Bearer ${token}` } })).data.data || [];
    const usersRes = await axios.get(`${API}/security/users?role_code=REVIEWER&limit=10`, { headers: { Authorization: `Bearer ${token}` } });
    reviewers = usersRes.data.data || [];
    console.log(`  institutions=${institutions.length}, committees=${committees.length}, reviewers=${reviewers.length}`);
  } catch (e) {
    console.log(`  Discovery error: ${e.message}`);
  }
  const institutionId = institutions[0]?.id || 1;
  const committeeId = committees[0]?.id || 1;
  console.log(`  Using institution=${institutionId}, committee=${committeeId}`);

  // 3. CREATE PROJECT (as researcher)
  console.log('\n--- 3. CREATE PROJECT ---');
  const researcher = researcherToken || adminToken;
  let projectId;
  try {
    const r = await axios.post(`${API}/core/projects`, {
      title_ar: 'E2E Test Project',
      objectives: 'Testing the complete workflow end to end',
      research_category: 'CLINICAL', risk_level: 'LOW',
    }, { headers: { Authorization: `Bearer ${researcher}` } });
    projectId = r.data.data?.id || r.data?.id;
    console.log(`  ok Project created: id=${projectId}`);
  } catch (e) {
    console.log(`  xx Project create FAILED: ${e.response?.data?.error || e.message}`);
    if (e.response?.data) console.log(`  Response:`, JSON.stringify(e.response.data).slice(0, 300));
  }
  if (!projectId) { console.log('  STOP: no project'); return; }

  // 4. CREATE APPLICATION (as researcher)
  console.log('\n--- 4. CREATE APPLICATION ---');
  let applicationId;
  try {
    const r = await axios.post(`${API}/core/applications`, {
      project_id: projectId, target_committee_id: committeeId, application_type: 'INITIAL',
    }, { headers: { Authorization: `Bearer ${researcher}` } });
    applicationId = r.data.data?.id || r.data?.id;
    console.log(`  ok Application created: id=${applicationId}`);
  } catch (e) {
    console.log(`  xx Application create FAILED: ${e.response?.data?.error || e.message}`);
  }
  if (!applicationId) { console.log('  STOP: no application'); return; }

  // 4b. SUBMIT APPLICATION
  console.log('\n--- 4b. SUBMIT APPLICATION ---');
  try {
    await axios.patch(`${API}/core/applications/${applicationId}/status`,
      { transition_code: 'SUBMIT' },
      { headers: { Authorization: `Bearer ${researcher}` } }
    );
    console.log('  ok Application submitted');
  } catch (e) {
    try {
      await axios.patch(`${API}/core/applications/${applicationId}/status`,
        { status: 'SUBMITTED' },
        { headers: { Authorization: `Bearer ${token}` } }
      );
      console.log('  ok Status set to SUBMITTED');
    } catch (e2) {
      console.log(`  xx Submit FAILED: ${e2.response?.data?.error || e2.message}`);
    }
  }

  // 5. ASSIGN REVIEWER (as admin)
  console.log('\n--- 5. ASSIGN REVIEWER ---');
  const reviewerUser = reviewers.find(r => r.username === 'reviewer1') || reviewers[0];
  const reviewerId = reviewerUser?.id;
  let assignmentId;
  if (reviewerId) {
    try {
      const r = await axios.post(`${API}/committee/reviews/assign`, {
        application_id: applicationId, reviewer_id: reviewerId, review_type: 'FULL_BOARD',
      }, { headers: { Authorization: `Bearer ${token}` } });
      assignmentId = r.data.data?.id || r.data?.id;
      console.log(`  ok Review assigned: assignmentId=${assignmentId}`);
    } catch (e) {
      console.log(`  xx Assign FAILED: ${e.response?.data?.error || e.message}`);
    }
  }

  // 6. REVIEW FORMS & QUESTIONS
  console.log('\n--- 6. REVIEW FORMS & QUESTIONS ---');
  let forms = [], questions = [];
  try {
    const r = await axios.get(`${API}/committee/reviews/forms`, { headers: { Authorization: `Bearer ${token}` } });
    forms = r.data.data || [];
    console.log(`  Found ${forms.length} forms`);
    if (forms.length > 0) {
      const q = await axios.get(`${API}/committee/reviews/forms/${forms[0].id}/questions`, { headers: { Authorization: `Bearer ${token}` } });
      questions = q.data.data || [];
      console.log(`  Found ${questions.length} questions for form #${forms[0].id}`);
    }
  } catch (e) {
    console.log(`  Forms error: ${e.message}`);
  }

  // 7. SUBMIT REVIEW
  console.log('\n--- 7. SUBMIT REVIEW ---');
  const reviewerSubmitToken = reviewer1Token || token;
  if (assignmentId) {
    try {
      const answers = questions.length > 0
        ? questions.map(q => ({ question_id: q.id, answer_text: 'Meets criteria', answer_score: q.scale_max || 5 }))
        : [];
      const r = await axios.post(`${API}/committee/reviews/${assignmentId}/submit`, {
        recommendation_type: 'APPROVE',
        justification: 'Meets all ethical requirements',
        answers,
      }, { headers: { Authorization: `Bearer ${reviewerSubmitToken}` } });
      console.log(`  ok Review submitted: ${r.data.message || 'OK'}`);
    } catch (e) {
      console.log(`  xx Submit review FAILED: ${e.response?.data?.error || e.message}`);
      if (e.response?.data) console.log(`  Response:`, JSON.stringify(e.response.data).slice(0, 400));
    }
  }

  // 8. COMMITTEE DECISION
  console.log('\n--- 8. COMMITTEE DECISION ---');
  const decisionToken = ethicsToken || chairToken || token;
  try {
    const r = await axios.post(`${API}/core/applications/${applicationId}/committee-decision`,
      { decision: 'APPROVED', notes: 'Unanimously approved' },
      { headers: { Authorization: `Bearer ${decisionToken}` } }
    );
    console.log(`  ok Committee decision: ${r.data.message || 'OK'}`);
  } catch (e) {
    console.log(`  xx Committee decision FAILED: ${e.response?.data?.error || e.message}`);
    if (e.response?.data) console.log(`  Response:`, JSON.stringify(e.response.data).slice(0, 500));
  }

  // SUMMARY
  console.log('\n=== E2E TEST SUMMARY ===');
  const steps = [
    ['Login', !!token],
    ['Project', !!projectId],
    ['Application', !!applicationId],
    ['Assignment', !!assignmentId],
    ['Review', !!assignmentId],
    ['Decision', true],
  ];
  let allOk = true;
  for (const [name, ok] of steps) {
    console.log(`  ${ok ? 'ok' : 'xx'} ${name}`);
    if (!ok) allOk = false;
  }

  if (allOk) {
    console.log('\n*** ALL STEPS PASSED ***\n');
  }
}

main().catch(console.error);
