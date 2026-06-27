param([string]$Base = "http://localhost:8080/api/v1")

$global:passed = 0
$global:failed = 0
$global:errors = @()
$runId = (Get-Random -Min 1000 -Max 9999)

function Log($u, $p) {
  $req = [System.Net.HttpWebRequest]::Create("$Base/security/auth/login")
  $req.Method = "POST"; $req.ContentType = "application/json"
  $bytes = [System.Text.Encoding]::UTF8.GetBytes("{`"username`":`"$u`",`"password`":`"$p`"}")
  $req.ContentLength = $bytes.Length
  $stream = $req.GetRequestStream(); $stream.Write($bytes,0,$bytes.Length); $stream.Close()
  $resp = $req.GetResponse()
  $reader = New-Object System.IO.StreamReader($resp.GetResponseStream())
  return ($reader.ReadToEnd() | ConvertFrom-Json).data.accessToken
}

function Check($msg, $body) {
  if ($body -and $body.success) { Write-Output "  ✅ $msg"; $global:passed++ }
  else {
    $detail = if ($body -and $body.error) { " → $($body.error)" } else { "" }
    Write-Output "  ❌ $msg$detail"; $global:failed++; $global:errors += $msg
  }
}

function Get($u, $t) {
  try { return Invoke-RestMethod -Uri "$Base$u" -Method Get -Headers @{"Authorization"="Bearer $t"} -TimeoutSec 30 }
  catch { return $null }
}

function Post($u, $b, $t) {
  $to = if ($u -match 'backup') { 120 } else { 30 }
  try { return Invoke-RestMethod -Uri "$Base$u" -Method Post -Headers @{"Authorization"="Bearer $t";"Content-Type"="application/json"} -Body $b -TimeoutSec $to }
  catch { return $null }
}

function Put($u, $b, $t) {
  try { return Invoke-RestMethod -Uri "$Base$u" -Method Put -Headers @{"Authorization"="Bearer $t";"Content-Type"="application/json"} -Body $b -TimeoutSec 30 }
  catch { return $null }
}

function DelReq($u, $t) {
  try { return Invoke-RestMethod -Uri "$Base$u" -Method Delete -Headers @{"Authorization"="Bearer $t"} -TimeoutSec 30 }
  catch { return $null }
}

# ============================================================
# LOGIN ALL USERS
# ============================================================
$adminToken = Log "admin" "admin123"
$ethicsToken = Log "ethics_admin" "Test@1234"
$reviewerToken = Log "reviewer1" "test1234"
$researcherToken = Log "researcher1" "test1234"
$chairToken = Log "chairperson" "test1234"

Write-Output "`n=========================================="
Write-Output "PHASE 2: USERS, ROLES & PERMISSIONS"
Write-Output "=========================================="

$r = Get "/security/users?page=1&limit=5" $adminToken
Check "2.1 List users (paginated)" $r

$r = Get "/security/users/21" $adminToken
Check "2.2 Get user by ID" $r

$r = Post "/security/users" "{`"username`":`"test_e2e_p2_$runId`",`"email`":`"test_e2e_p2_$runId@test.com`",`"password`":`"Test@1234`",`"first_name_ar`":`"اختبار`",`"last_name_ar`":`"مرحلة2`",`"institution_id`":`"4`"}" $adminToken
Check "2.3 Create user" $r
if ($r) { $uid = $r.data.id }

$r = Put "/security/users/$uid" '{"first_name_en":"Phase2Updated"}' $adminToken
Check "2.4 Update user" $r

$r = Get "/security/roles" $adminToken
Check "2.5 List roles" $r

$r = Post "/security/roles" "{`"code`":`"TEST_E2E_P2_$runId`",`"name_ar`":`"دور اختبار المرحلة 2`",`"name_en`":`"Phase 2 Test Role`"}" $adminToken
Check "2.6 Create role" $r
if ($r) { $rid = $r.data.id }

$r = Put "/security/roles/$rid" '{"name_en":"Phase 2 Test Role Updated"}' $adminToken
Check "2.7 Update role" $r

$r = Get "/security/permissions" $adminToken
Check "2.8 List permissions" $r
if ($r) { $firstPid = $r.data[0].id; $permCount = $r.data.Count }

$r = Get "/security/permissions/role/1" $adminToken
Check "2.9 Get role permissions" $r

$r = Put "/security/permissions/role/$rid" "{`"permission_ids`":[$firstPid]}" $adminToken
Check "2.10 Set role permissions" $r

Write-Output "`n=========================================="
Write-Output "PHASE 3: PROJECTS & APPLICATIONS"
Write-Output "=========================================="

# 3.1 Create project (researcher)
$r = Post "/core/projects" "{`"title_ar`":`"مشروع اختبار شامل $runId`",`"title_en`":`"Comprehensive E2E Test Project $runId`",`"abstract_ar`":`"ملخص مشروع اختبار`",`"abstract_en`":`"Test project abstract`",`"objectives`":`"Test objectives`",`"research_category`":`"BIOMEDICAL`",`"risk_level`":`"MODERATE`",`"start_date`":`"2026-07-01`",`"expected_end_date`":`"2027-06-30`"}" $researcherToken
Check "3.1 Create project" $r
if ($r) { $projectId = $r.data.id }

# 3.2 Get project
$r = Get "/core/projects/$projectId" $researcherToken
Check "3.2 Get project by ID" $r

# 3.3 List projects
$r = Get "/core/projects" $researcherToken
Check "3.3 List projects" $r

# 3.4 Project stats
$r = Get "/core/projects/$projectId/stats" $researcherToken
Check "3.4 Project stats" $r

# 3.5 Create application (researcher) — NOTE: target_committee_id NOT committee_id
$r = Post "/core/applications" "{`"project_id`":$projectId,`"application_type`":`"INITIAL`",`"target_committee_id`":3}" $researcherToken
Check "3.5 Create application" $r
if ($r) { $appId = $r.data.id }

# 3.6 Get application
$r = Get "/core/applications/$appId" $researcherToken
Check "3.6 Get application" $r

# 3.7 List applications
$r = Get "/core/applications" $researcherToken
Check "3.7 List applications" $r

# 3.8 Submit application (status transition)
$r = Post "/workflow/execute-transition" "{`"entity_type`":`"Application`",`"entity_id`":$appId,`"transition_code`":`"SUBMIT`",`"comment`":`"Submitting for review`"}" $researcherToken
Check "3.8 Submit application (workflow)" $r

# 3.9 Assign reviewer (ethics_admin) — reviewer1 (id=4) with test1234
$r = Post "/committee/reviews/assign" "{`"application_id`":$appId,`"reviewer_id`":4,`"review_type`":`"SCIENTIFIC`"}" $ethicsToken
Check "3.9 Assign reviewer" $r
if ($r) { $assignId = $r.data.id }

# 3.10 Submit review (reviewer1 = id 4)
$r = Post "/committee/reviews/$assignId/submit" "{`"recommendation_type`":`"APPROVE`",`"justification`":`"Excellent research proposal`"}" $reviewerToken
Check "3.10 Submit review" $r

# 3.11 Committee decision (ethics_admin)
$r = Post "/core/applications/$appId/committee-decision" "{`"decision`":`"APPROVED`",`"notes`":`"Approved with conditions`"}" $ethicsToken
Check "3.11 Committee decision" $r

# 3.12 Get project applications
$r = Get "/core/projects/$projectId/applications" $researcherToken
Check "3.12 Project applications" $r

Write-Output "`n=========================================="
Write-Output "PHASE 4: COMMITTEES & MEETINGS & VOTING"
Write-Output "=========================================="

# 4.1 Committee types
$r = Get "/committee/committees/committee-types" $adminToken
Check "4.1 Committee types" $r

# 4.2 Committee roles
$r = Get "/committee/committees/committee-roles" $adminToken
Check "4.2 Committee roles" $r

# 4.3 List committees
$r = Get "/committee/committees" $adminToken
Check "4.3 List committees" $r

# 4.4 Get committee by ID
$r = Get "/committee/committees/3" $adminToken
Check "4.4 Get committee" $r

# 4.5 Get committee members
$r = Get "/committee/committees/3/members" $adminToken
Check "4.5 Committee members" $r

# 4.6 Create meeting
$r = Post "/committee/meetings" "{`"committee_id`":3,`"meeting_date`":`"2026-07-15T09:00:00Z`",`"location`":`"Conference Room A`"}" $ethicsToken
Check "4.6 Create meeting" $r
if ($r) { $meetingId = $r.data.id }

# 4.7 Update meeting status — NOTE: send actual data, not empty body
$r = Post "/committee/meetings/$meetingId" "{`"meeting_status`":`"IN_PROGRESS`"}" $ethicsToken
Check "4.7 Update meeting" $r

# 4.8 Get meeting
$r = Get "/committee/meetings/$meetingId" $adminToken
Check "4.8 Get meeting by ID" $r

# 4.9 Add agenda to meeting
$r = Post "/committee/meetings/$meetingId/agenda" "{`"title`":`"Test Agenda $runId`"}" $ethicsToken
Check "4.9 Create agenda" $r
if ($r) { $agendaId = $r.data.id }

# 4.10 Add agenda item
$r = Post "/committee/meetings/$meetingId/agenda/$agendaId/items" "{`"application_id`":$appId,`"title`":`"Review Application $appId`"}" $ethicsToken
Check "4.10 Add agenda item" $r

# 4.11 Get agenda
$r = Get "/committee/meetings/$meetingId/agenda" $adminToken
Check "4.11 Get agenda" $r

# 4.12 Get committee members (for attendance)
$r = Get "/committee/meetings/$meetingId/committee-members" $adminToken
Check "4.12 Committee members for meeting" $r

# 4.13 Get attendance
$r = Get "/committee/meetings/$meetingId/attendance" $adminToken
Check "4.13 Get attendance" $r

# 4.14 Get minutes
$r = Get "/committee/meetings/$meetingId/minutes" $adminToken
Check "4.14 Get minutes" $r

# 4.15 Get quorum
$r = Post "/committee/meetings/$meetingId/quorum" "{}" $adminToken
Check "4.15 Get quorum" $r

# 4.16 Create voting session
$r = Post "/committee/voting/sessions" "{`"meeting_id`":$meetingId,`"application_id`":$appId,`"voting_type`":`"STANDARD`"}" $ethicsToken
Check "4.16 Create voting session" $r
if ($r) { $sessionId = $r.data.id }

# 4.17 Get voting sessions
$r = Get "/committee/voting/meeting/$meetingId" $adminToken
Check "4.17 Voting sessions" $r

# 4.18 Get voting session
$r = Get "/committee/voting/sessions/$sessionId" $adminToken
Check "4.18 Get voting session" $r

# 4.19 Cast vote
$r = Post "/committee/voting/sessions/$sessionId/vote" "{`"vote_value`":`"APPROVE`",`"comments`":`"Approved`"}" $chairToken
Check "4.19 Cast vote" $r

# 4.20 Close voting session
$r = Post "/committee/voting/sessions/$sessionId/close" "{}" $ethicsToken
Check "4.20 Close voting session" $r

Write-Output "`n=========================================="
Write-Output "PHASE 5: REVIEWS & FORMS"
Write-Output "=========================================="

# 5.1 My reviews
$r = Get "/committee/reviews/my" $reviewerToken
Check "5.1 My reviews" $r

# 5.2 List review forms
$r = Get "/committee/reviews/forms" $adminToken
Check "5.2 List review forms" $r

# 5.3 Create review form — NOTE: unique form_code per run
$r = Post "/committee/reviews/forms" "{`"form_code`":`"TEST_E2E_FORM_$runId`",`"form_name`":`"E2E Test Form $runId`",`"review_type`":`"SCIENTIFIC`"}" $ethicsToken
Check "5.3 Create review form" $r
if ($r) { $formId = $r.data.id }

# 5.4 Get questions
$r = Get "/committee/reviews/forms/$formId/questions" $adminToken
Check "5.4 Get form questions" $r

# 5.5 Add question
$r = Post "/committee/reviews/forms/$formId/questions" "{`"question_code`":`"Q_TEST_$runId`",`"question_text`":`"Is this research ethical?`",`"question_type`":`"BOOLEAN`",`"is_required`":true}" $ethicsToken
Check "5.5 Add question" $r
if ($r) { $qId = $r.data.id }

# 5.6 Delete question
$r = DelReq "/committee/reviews/forms/$formId/questions/$qId" $ethicsToken
Check "5.6 Delete question" $r

# 5.7 Get application reviews
$r = Get "/committee/reviews/application/$appId" $adminToken
Check "5.7 Application reviews" $r

# 5.8 Get recommendations
$r = Get "/committee/reviews/application/$appId/recommendations" $adminToken
Check "5.8 Recommendations" $r

# 5.9 Get comments
$r = Get "/committee/reviews/application/$appId/comments" $adminToken
Check "5.9 Comments" $r

# 5.10 Get answers
if ($assignId) {
  $r = Get "/committee/reviews/assignment/$assignId/answers" $adminToken
  Check "5.10 Review answers" $r
  $r = Get "/committee/reviews/assignment/$assignId/score" $adminToken
  Check "5.11 Review score" $r
} else { Write-Output "  ⚠️ 5.10-5.11 Skipped (no assignment)" }

Write-Output "`n=========================================="
Write-Output "PHASE 6: DOCUMENTS & E-SIGNATURES"
Write-Output "=========================================="

# 6.1 Document types
$r = Get "/documents/types" $researcherToken
Check "6.1 Document types" $r

# 6.2 List documents
$r = Get "/documents" $researcherToken
Check "6.2 List documents" $r

# 6.3 Documents by entity
$r = Get "/documents/entity/Application/$appId" $researcherToken
Check "6.3 Documents by entity" $r

# 6.4 Get classifications
$r = Get "/documents/classifications" $researcherToken
Check "6.4 Document classifications" $r

# 6.5 Get pending signatures
$r = Get "/documents/pending-signatures" $researcherToken
Check "6.5 Pending signatures" $r

Write-Output "`n=========================================="
Write-Output "PHASE 7: SAFETY & RISK"
Write-Output "=========================================="

# 7.1 Create risk register entry — NOTE: field names match repository (risk_code, risk_title, etc.)
$r = Post "/safety/risk-register" "{`"risk_code`":`"RISK_E2E_$runId`",`"risk_title`":`"E2E Test Risk $runId`",`"risk_description`":`"Test risk description`",`"likelihood`":3,`"impact`":3,`"owner_id`":21}" $ethicsToken
Check "7.1 Create risk register" $r
if ($r) { $riskId = $r.data.id }

# 7.2 List risk register
$r = Get "/safety/risk-register" $adminToken
Check "7.2 List risk register" $r

# 7.3 Create risk mitigation
$r = Post "/safety/risk-register/$riskId/mitigations" "{`"mitigation_plan`":`"Test mitigation $runId`",`"responsible_party`":27,`"status`":`"ACTIVE`"}" $ethicsToken
Check "7.3 Create mitigation" $r

# 7.4 Report adverse event — NOTE: event_type (not type), outcome_status (not outcome)
$r = Post "/safety/adverse-events" "{`"application_id`":$appId,`"event_number`":`"AE-E2E-$runId`",`"event_date`":`"2026-06-20`",`"event_type`":`"MILD`",`"severity`":`"MILD`",`"expectedness`":`"EXPECTED`",`"relatedness`":`"POSSIBLE`",`"description`":`"Test adverse event $runId`",`"outcome_status`":`"RESOLVED`"}" $researcherToken
Check "7.4 Create adverse event" $r

# 7.5 List adverse events
$r = Get "/safety/adverse-events" $adminToken
Check "7.5 List adverse events" $r

# 7.6 Report incident (needs risk_id from 7.1 + incident_code)
$r = Post "/safety/risk-incidents" "{`"risk_id`":$riskId,`"incident_code`":`"INC-E2E-$runId`",`"incident_date`":`"2026-06-20`",`"description`":`"Test incident $runId`",`"severity`":`"LOW`",`"root_cause`":`"Test cause`"}" $researcherToken
Check "7.6 Create incident" $r
if ($r) { $incidentId = $r.data.id }

# 7.7 List incidents
$r = Get "/safety/risk-incidents" $adminToken
Check "7.7 List incidents" $r

# 7.8 Create corrective action (needs incident_id from 7.6)
$r = Post "/safety/corrective-actions" "{`"incident_id`":$incidentId,`"action_code`":`"CA-E2E-$runId`",`"description`":`"Test corrective action $runId`",`"assigned_to`":21,`"priority`":`"MEDIUM`",`"due_date`":`"2026-07-20`"}" $ethicsToken
Check "7.8 Create corrective action" $r

# 7.9 List corrective actions
$r = Get "/safety/corrective-actions" $adminToken
Check "7.9 List corrective actions" $r

Write-Output "`n=========================================="
Write-Output "PHASE 8: REPORTS"
Write-Output "=========================================="

# 8.1 Dashboard stats
$r = Get "/reporting/dashboard/stats" $adminToken
Check "8.1 Dashboard stats" $r

# 8.2 Applications report
$r = Get "/reporting/applications?page=1&limit=5" $adminToken
Check "8.2 Applications report" $r

# 8.3 Committee stats
$r = Get "/reporting/committees" $adminToken
Check "8.3 Committee stats" $r

# 8.4 Status summary
$r = Get "/reporting/status-summary" $adminToken
Check "8.4 Status summary" $r

# 8.5 Applications trend
$r = Get "/reporting/applications-trend" $adminToken
Check "8.5 Applications trend" $r

# 8.6 Export CSV
try {
  $csv = Invoke-WebRequest -Uri "$Base/reporting/export/applications" -Method Get -Headers @{"Authorization"="Bearer $adminToken"} -TimeoutSec 60 -UseBasicParsing
  if ($csv.StatusCode -eq 200) { Write-Output "  ✅ 8.6 Export CSV"; $global:passed++ } else { throw }
} catch { Write-Output "  ❌ 8.6 Export CSV"; $global:failed++; $global:errors += "8.6 Export CSV" }

Write-Output "`n=========================================="
Write-Output "PHASE 9: ADMINISTRATION"
Write-Output "=========================================="

# 9.1 Admin stats
$r = Get "/admin/stats" $adminToken
Check "9.1 Admin stats" $r

# 9.2 Audit log
$r = Get "/admin/audit-log?page=1&limit=5" $adminToken
Check "9.2 Audit log" $r

# 9.3 Distinct actions
$r = Get "/admin/audit-log/actions" $adminToken
Check "9.3 Distinct actions" $r

# 9.4 Online users
$r = Get "/admin/online-users" $adminToken
Check "9.4 Online users" $r

# 9.5 Recent activity
$r = Get "/admin/recent-activity" $adminToken
Check "9.5 Recent activity" $r

# 9.6 Email config list
$r = Get "/admin/email-config" $adminToken
Check "9.6 Email config list" $r

# 9.7 System config
$r = Get "/system/config" $adminToken
Check "9.7 System config" $r

# 9.8 Backup list
$r = Get "/admin/backup" $adminToken
Check "9.8 Backup list" $r

# 9.9 Create backup
$r = Post "/admin/backup" "{}" $adminToken
Check "9.9 Create backup" $r
if ($r) { $backupName = $r.data.name }

# 9.10 Verify backup (if created)
if ($backupName) {
  $r = Post "/admin/backup/$([System.Uri]::EscapeDataString($backupName))/verify" "{}" $adminToken
  Check "9.10 Verify backup" $r
  $r = DelReq "/admin/backup/$([System.Uri]::EscapeDataString($backupName))" $adminToken
  Check "9.11 Delete backup" $r
}

Write-Output "`n=========================================="
Write-Output "PHASE 10: COMMUNICATIONS"
Write-Output "=========================================="

# 10.1 Notifications
$r = Get "/communication/notifications" $adminToken
Check "10.1 List notifications" $r

# 10.2 Search users
$r = Get "/communication/users/search?q=admin" $adminToken
Check "10.2 Search users" $r

# 10.3 Messages - unread count
$r = Get "/communication/messages/unread-count" $adminToken
Check "10.3 Unread count" $r

# 10.4 Messages inbox
$r = Get "/communication/messages?box=inbox" $adminToken
Check "10.4 Messages inbox" $r

# 10.5 Messages sent
$r = Get "/communication/messages?box=sent" $adminToken
Check "10.5 Messages sent" $r

# 10.6 Create message
$r = Post "/communication/messages" "{`"subject`":`"E2E Test Message $runId`",`"body`":`"This is a test message from E2E testing`",`"recipient_ids`":[24]}" $adminToken
Check "10.6 Create message" $r
if ($r) { $msgId = $r.data.id }

# 10.7 Get message
if ($msgId) {
  $r = Get "/communication/messages/$msgId" $adminToken
  Check "10.7 Get message" $r
  $r = DelReq "/communication/messages/$msgId" $adminToken
  Check "10.8 Delete message" $r
}

Write-Output "`n=========================================="
Write-Output "PHASE 11: WORKFLOW"
Write-Output "=========================================="

# 11.1 Workflow definitions
$r = Get "/workflow/definitions" $adminToken
Check "11.1 Workflow definitions" $r

# 11.2 Workflow instance for application
$r = Get "/workflow/instances/Application/$appId" $adminToken
Check "11.2 Workflow instance" $r

# 11.3 Available transitions
$r = Get "/workflow/available-transitions/Application/$appId" $adminToken
Check "11.3 Available transitions" $r

# 11.4 Execute transition (if available)
if ($r -and $r.data -and $r.data.Count -gt 0) {
  $tc = $r.data[0].transition_code
  $r2 = Post "/workflow/execute-transition" "{`"entity_type`":`"Application`",`"entity_id`":$appId,`"transition_code`":`"$tc`",`"comment`":`"E2E test transition`"}" $adminToken
  Check "11.4 Execute transition ($tc)" $r2
}

Write-Output "`n=========================================="
Write-Output "REFERENCE & LOOKUPS"
Write-Output "=========================================="

# Reference data
$r = Get "/reference/institutions-registry" $null
Check "R1 Institutions registry" $r

$r = Get "/reference/professions" $adminToken
Check "R2 Professions" $r

$r = Get "/reference/licenses" $adminToken
Check "R3 Licenses" $r

$r = Get "/core/research-categories" $adminToken
Check "R4 Research categories" $r

$r = Get "/core/risk-classifications" $adminToken
Check "R5 Risk classifications" $r

$r = Get "/core/vulnerable-populations" $adminToken
Check "R6 Vulnerable populations" $r

# Logout test
$r = Post "/security/auth/logout" "{}" $adminToken
Check "12.1 Logout" $r

# ============================================================
# SUMMARY
# ============================================================
Write-Output "`n=========================================="
Write-Output "TEST SUMMARY"
Write-Output "=========================================="
Write-Output "Passed: $global:passed"
Write-Output "Failed: $global:failed"
$total = $global:passed + $global:failed
Write-Output "Total:  $total"
if ($global:failed -eq 0) { Write-Output "RESULT: ALL TESTS PASSED ✅" }
else {
  Write-Output "RESULT: $global:failed TEST(S) FAILED ❌"
  Write-Output "Failed tests:"
  $global:errors | ForEach-Object { Write-Output "  - $_" }
}
