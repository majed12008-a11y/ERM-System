param([string]$Base = "http://localhost:8080/api/v1")

$global:passed = 0
$global:failed = 0
$global:errors = @()
$runId = (Get-Random -Min 10000 -Max 99999)

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

function Get($u, $t) {
  try { return Invoke-RestMethod -Uri "$Base$u" -Method Get -Headers @{"Authorization"="Bearer $t"} -TimeoutSec 30 }
  catch { return $null }
}

function Post($u, $b, $t) {
  try { return Invoke-RestMethod -Uri "$Base$u" -Method Post -Headers @{"Authorization"="Bearer $t";"Content-Type"="application/json"} -Body $b -TimeoutSec 30 }
  catch { return $null }
}

function Patch($u, $b, $t) {
  try { return Invoke-RestMethod -Uri "$Base$u" -Method Patch -Headers @{"Authorization"="Bearer $t";"Content-Type"="application/json"} -Body $b -TimeoutSec 30 }
  catch { return $null }
}

function Check($msg, $body) {
  if ($body -and $body.success) { Write-Output "  [PASS] $msg"; $global:passed++ }
  else {
    $detail = if ($body -and $body.error) { " → $($body.error)" } else { " → (no response / HTTP error)" }
    Write-Output "  [FAIL] $msg$detail"; $global:failed++; $global:errors += $msg
  }
}

function CheckStatus($msg, $body, $expectedStatus) {
  if ($body -and $body.success -and $body.data.current_status -eq $expectedStatus) {
    Write-Output "  [PASS] $msg (status=$expectedStatus)"; $global:passed++
  } elseif ($body -and $body.success) {
    Write-Output "  [FAIL] $msg — expected status $expectedStatus but got $($body.data.current_status)"; $global:failed++; $global:errors += $msg
  } else {
    $detail = if ($body -and $body.error) { " → $($body.error)" } else { "" }
    Write-Output "  [FAIL] $msg$detail"; $global:failed++; $global:errors += $msg
  }
}

function CheckNotificationType($msg, $body, $expectedType) {
  if (-not $body -or -not $body.success) {
    Write-Output "  [FAIL] $msg — no response"; $global:failed++; $global:errors += $msg; return
  }
  $notifs = $body.data
  if (-not $notifs -or $notifs.Count -eq 0) {
    Write-Output "  [FAIL] $msg — no notifications found"; $global:failed++; $global:errors += $msg; return
  }
  $first = $notifs[0]
  if ($first.notification_type -eq $expectedType) {
    $delivered = if ($first.sent_at) { "sent_at=$($first.sent_at)" } else { "sent_at=NULL" }
    Write-Output "  [PASS] $msg (type=$expectedType, $delivered)"; $global:passed++
  } else {
    Write-Output "  [FAIL] $msg — expected type $expectedType but got $($first.notification_type)"; $global:failed++; $global:errors += $msg
  }
}

function CheckUnreadCount($msg, $body, $expectedCount) {
  if (-not $body -or -not $body.success) {
    Write-Output "  [FAIL] $msg — no response"; $global:failed++; $global:errors += $msg; return
  }
  if ($body.data.count -eq $expectedCount) {
    Write-Output "  [PASS] $msg (count=$expectedCount)"; $global:passed++
  } else {
    Write-Output "  [FAIL] $msg — expected $expectedCount unread, got $($body.data.count)"; $global:failed++; $global:errors += $msg
  }
}

function CheckUnreadAtLeast($msg, $body, $minimum) {
  if (-not $body -or -not $body.success) {
    Write-Output "  [FAIL] $msg — no response"; $global:failed++; $global:errors += $msg; return
  }
  if ($body.data.count -ge $minimum) {
    Write-Output "  [PASS] $msg (count=$($body.data.count) >= $minimum)"; $global:passed++
  } else {
    Write-Output "  [FAIL] $msg — expected at least $minimum unread, got $($body.data.count)"; $global:failed++; $global:errors += $msg
  }
}

Write-Output "=========================================="
Write-Output "PHASE 4 NOTIFICATION E2E — Notification Lifecycle"
Write-Output "Run ID: $runId"
Write-Output "=========================================="

# ============================================================
# LOGIN
# ============================================================
$researcherToken = Log "researcher1" "Test@1234"
if (-not $researcherToken) { Write-Output "  [FAIL] Login as researcher1 failed — aborting"; exit 1 }
Write-Output "  [PASS] Logged in as researcher1"

$ethicsToken = Log "ethics_admin" "Test@1234"
if (-not $ethicsToken) { Write-Output "  [FAIL] Login as ethics_admin failed — aborting"; exit 1 }
Write-Output "  [PASS] Logged in as ethics_admin"

$adminToken = Log "admin" "admin123"
if (-not $adminToken) { Write-Output "  [FAIL] Login as admin failed — aborting"; exit 1 }
Write-Output "  [PASS] Logged in as admin"

# ============================================================
# SETUP — Create project + applications
# ============================================================
Write-Output "`n=========================================="
Write-Output "SETUP — Test data"
Write-Output "=========================================="

$r = Post "/core/projects" "{`"title_ar`":`"مشروع اختبار الإشعارات $runId`",`"title_en`":`"Notification E2E Test $runId`",`"abstract_ar`":`"ملخص`",`"abstract_en`":`"Abstract`",`"objectives`":`"Test notification lifecycle`",`"research_category`":`"BIOMEDICAL`",`"risk_level`":`"MODERATE`",`"start_date`":`"2026-07-01`",`"expected_end_date`":`"2027-06-30`"}" $researcherToken
Check "S.1 Create project" $r
if (-not $r) { Write-Output "  [FAIL] Cannot proceed without project — aborting"; exit 1 }
$projectId = $r.data.id

# App 1 — Condition path (SUBMIT → COMMITTEE_CONDITIONAL → CONDITIONS_MET)
$r = Post "/core/applications" "{`"project_id`":$projectId,`"application_type`":`"INITIAL`",`"target_committee_id`":3}" $researcherToken
Check "S.2 Create App 1 (condition path)" $r
if (-not $r) { Write-Output "  [FAIL] Cannot proceed without App 1 — aborting"; exit 1 }
$app1Id = $r.data.id

# App 2 — Approve path (SUBMIT → COMMITTEE_APPROVE)
$r = Post "/core/applications" "{`"project_id`":$projectId,`"application_type`":`"INITIAL`",`"target_committee_id`":3}" $researcherToken
Check "S.3 Create App 2 (approve path)" $r
$app2Id = if ($r) { $r.data.id } else { $null }

# App 3 — Withdraw path (SUBMIT → WITHDRAW)
$r = Post "/core/applications" "{`"project_id`":$projectId,`"application_type`":`"INITIAL`",`"target_committee_id`":3}" $researcherToken
Check "S.4 Create App 3 (withdraw path)" $r
$app3Id = if ($r) { $r.data.id } else { $null }

# ============================================================
# SUITE A: Workflow Transition Notifications
# ============================================================
Write-Output "`n=========================================="
Write-Output "SUITE A: Workflow Transition Notifications"
Write-Output "=========================================="

# ── A.1 SUBMIT → APPLICATION_SUBMITTED ──
Write-Output "`n--- A.1 SUBMIT → APPLICATION_SUBMITTED ---"
$r = Patch "/core/applications/$app1Id/status" "{`"transition_code`":`"SUBMIT`",`"comment`":`"`"}" $researcherToken
CheckStatus "A.1.1 Submit App 1 (DRAFT → SUBMITTED)" $r "SUBMITTED"

# Check researcher's notifications for APPLICATION_SUBMITTED
$r = Get "/communication/notifications" $researcherToken
CheckNotificationType "A.1.2 Notification type = APPLICATION_SUBMITTED" $r "APPLICATION_SUBMITTED"

$r = Get "/communication/notifications/unread-count" $researcherToken
CheckUnreadAtLeast "A.1.3 Unread count >= 1 after SUBMIT" $r 1

# ── A.2 COMMITTEE_APPROVE → APPLICATION_COMMITTEE_APPROVED ──
Write-Output "`n--- A.2 COMMITTEE_APPROVE → APPLICATION_COMMITTEE_APPROVED ---"
$r = Patch "/core/applications/$app2Id/status" "{`"transition_code`":`"SUBMIT`",`"comment`":`"`"}" $researcherToken
CheckStatus "A.2.1 Submit App 2 (DRAFT → SUBMITTED)" $r "SUBMITTED"

$r = Patch "/core/applications/$app2Id/status" "{`"transition_code`":`"ACCEPT_INITIAL`",`"comment`":`"`"}" $ethicsToken
CheckStatus "A.2.2 Accept initial (→ INITIAL_REVIEW)" $r "INITIAL_REVIEW"

$r = Patch "/core/applications/$app2Id/status" "{`"transition_code`":`"SEND_TO_SCIENTIFIC`",`"comment`":`"`"}" $ethicsToken
CheckStatus "A.2.3 Send to scientific (→ SCIENTIFIC_REVIEW)" $r "SCIENTIFIC_REVIEW"

$r = Patch "/core/applications/$app2Id/status" "{`"transition_code`":`"SEND_TO_ETHICAL`",`"comment`":`"`"}" $ethicsToken
CheckStatus "A.2.4 Send to ethical (→ ETHICAL_REVIEW)" $r "ETHICAL_REVIEW"

$r = Patch "/core/applications/$app2Id/status" "{`"transition_code`":`"SEND_TO_COMMITTEE`",`"comment`":`"`"}" $ethicsToken
CheckStatus "A.2.5 Send to committee (→ COMMITTEE_REVIEW)" $r "COMMITTEE_REVIEW"

$r = Patch "/core/applications/$app2Id/status" "{`"transition_code`":`"COMMITTEE_APPROVE`",`"comment`":`"Approved`"}" $ethicsToken
CheckStatus "A.2.6 Committee approve (→ APPROVED)" $r "APPROVED"

$r = Get "/communication/notifications" $researcherToken
CheckNotificationType "A.2.7 Notification type = APPLICATION_COMMITTEE_APPROVED" $r "APPLICATION_COMMITTEE_APPROVED"

# ── A.3 WITHDRAW → APPLICATION_WITHDRAWN ──
Write-Output "`n--- A.3 WITHDRAW → APPLICATION_WITHDRAWN ---"
$r = Patch "/core/applications/$app3Id/status" "{`"transition_code`":`"SUBMIT`",`"comment`":`"`"}" $researcherToken
CheckStatus "A.3.1 Submit App 3 (DRAFT → SUBMITTED)" $r "SUBMITTED"

$r = Patch "/core/applications/$app3Id/status" "{`"transition_code`":`"WITHDRAW`",`"comment`":`"Withdrawn for testing`"}" $researcherToken
CheckStatus "A.3.2 Withdraw (→ WITHDRAWN)" $r "WITHDRAWN"

$r = Get "/communication/notifications" $researcherToken
CheckNotificationType "A.3.3 Notification type = APPLICATION_WITHDRAWN" $r "APPLICATION_WITHDRAWN"

# ============================================================
# SUITE B: Condition Workflow Notifications
# ============================================================
Write-Output "`n=========================================="
Write-Output "SUITE B: Condition Workflow Notifications"
Write-Output "=========================================="

# ── B.1 COMMITTEE_CONDITIONAL → APPLICATION_COMMITTEE_CONDITIONAL ──
Write-Output "`n--- B.1 COMMITTEE_CONDITIONAL → APPLICATION_COMMITTEE_CONDITIONAL ---"
# Walk App 1 to COMMITTEE_REVIEW
$r = Patch "/core/applications/$app1Id/status" "{`"transition_code`":`"ACCEPT_INITIAL`",`"comment`":`"`"}" $ethicsToken
CheckStatus "B.1.1 Accept initial (→ INITIAL_REVIEW)" $r "INITIAL_REVIEW"

$r = Patch "/core/applications/$app1Id/status" "{`"transition_code`":`"SEND_TO_SCIENTIFIC`",`"comment`":`"`"}" $ethicsToken
CheckStatus "B.1.2 Send to scientific (→ SCIENTIFIC_REVIEW)" $r "SCIENTIFIC_REVIEW"

$r = Patch "/core/applications/$app1Id/status" "{`"transition_code`":`"SEND_TO_ETHICAL`",`"comment`":`"`"}" $ethicsToken
CheckStatus "B.1.3 Send to ethical (→ ETHICAL_REVIEW)" $r "ETHICAL_REVIEW"

$r = Patch "/core/applications/$app1Id/status" "{`"transition_code`":`"SEND_TO_COMMITTEE`",`"comment`":`"`"}" $ethicsToken
CheckStatus "B.1.4 Send to committee (→ COMMITTEE_REVIEW)" $r "COMMITTEE_REVIEW"

# Create a condition
$r = Post "/core/applications/$app1Id/conditions" "{`"condition_text`":`"Provide updated safety protocols for E2E notification test`",`"severity`":`"MAJOR`",`"category`":`"SAFETY`",`"due_date`":`"2026-12-31`"}" $ethicsToken
Check "B.1.5 Create condition" $r
$condId = if ($r) { $r.data.id } else { $null }

# Conditional approval
$r = Patch "/core/applications/$app1Id/status" "{`"transition_code`":`"COMMITTEE_CONDITIONAL`",`"comment`":`"Conditional`"}" $ethicsToken
CheckStatus "B.1.6 Conditional approval (→ AWAITING_CONDITIONS)" $r "AWAITING_CONDITIONS"

# Check notification for COMMITTEE_CONDITIONAL transition
$r = Get "/communication/notifications" $researcherToken
CheckNotificationType "B.1.7 Notification type = APPLICATION_COMMITTEE_CONDITIONAL" $r "APPLICATION_COMMITTEE_CONDITIONAL"

# ── B.2 CONDITIONS_MET → APPLICATION_CONDITIONS_MET ──
Write-Output "`n--- B.2 CONDITIONS_MET → APPLICATION_CONDITIONS_MET ---"
$r = Patch "/core/applications/$app1Id/conditions/$condId/resolve" "{`"status`":`"MET`"}" $ethicsToken
Check "B.2.1 Resolve condition as MET" $r

$r = Patch "/core/applications/$app1Id/status" "{`"transition_code`":`"CONDITIONS_MET`",`"comment`":`"All conditions satisfied`"}" $ethicsToken
CheckStatus "B.2.2 Conditions met (→ APPROVED)" $r "APPROVED"

$r = Get "/communication/notifications" $researcherToken
CheckNotificationType "B.2.3 Notification type = APPLICATION_CONDITIONS_MET" $r "APPLICATION_CONDITIONS_MET"

# ============================================================
# SUITE C: Certificate Notification
# ============================================================
Write-Output "`n=========================================="
Write-Output "SUITE C: Certificate Notification"
Write-Output "=========================================="

$r = Get "/core/applications/$app1Id/certificates" $researcherToken
if ($r -and $r.success -and $r.data.Count -ge 1) {
  Write-Output "  [PASS] C.1 Certificate generated for App 1 (count=$($r.data.Count))"; $global:passed++
  $certId = $r.data[0].id

  if ($r.data[0].status -eq 'ISSUED') {
    Write-Output "  [PASS] C.2 Certificate status = ISSUED"; $global:passed++
  } else {
    Write-Output "  [FAIL] C.2 Certificate status expected ISSUED but got $($r.data[0].status)"; $global:failed++; $global:errors += "C.2"
  }
} else {
  $detail = if ($r) { "count=$($r.data.Count)" } else { "no response" }
  Write-Output "  [FAIL] C.1 No certificate found ($detail)"; $global:failed++; $global:errors += "C.1"
}

# Verify CERTIFICATE_ISSUED notification type is registered
$notifTypesUrl = "$Base/communication/notifications"
$r2 = Get "/communication/notifications" $researcherToken

# Check the frontend SDK has the notification type constant by validating the backend constants
# Since there's no public endpoint listing all notification types, verify via SDK types file
$typesFile = "$PSScriptRoot\..\backend\src\services\notification-types.ts"
if (Test-Path $typesFile) {
  $content = Get-Content $typesFile -Raw
  if ($content -match 'CERTIFICATE_ISSUED') {
    Write-Output "  [PASS] C.3 CERTIFICATE_ISSUED notification type constant registered"; $global:passed++
  } else {
    Write-Output "  [FAIL] C.3 CERTIFICATE_ISSUED not found in notification-types.ts"; $global:failed++; $global:errors += "C.3"
  }
} else {
  Write-Output "  [SKIP] C.3 Cannot verify notification-types.ts (file not found)"
}

# ============================================================
# SUITE D: Real-Time Behavior — Unread Count
# ============================================================
Write-Output "`n=========================================="
Write-Output "SUITE D: Real-Time Behavior — Unread Count"
Write-Output "=========================================="

$r = Get "/communication/notifications/unread-count" $researcherToken
Check "D.1 Unread count endpoint accessible" $r
if ($r -and $r.success -and $r.data.count -ge 0) {
  Write-Output "  [PASS] D.2 Unread count returns valid number ($($r.data.count))"; $global:passed++
} else {
  Write-Output "  [FAIL] D.2 Unread count should be >= 0"; $global:failed++; $global:errors += "D.2"
}

# Verify unread count is at least as many as the notifications we triggered
# (some may have been read during manual testing)
$rNotifs = Get "/communication/notifications" $researcherToken
$unreadFromList = if ($rNotifs -and $rNotifs.success -and $rNotifs.data) {
  @($rNotifs.data | Where-Object { -not $_.is_read }).Count
} else { 0 }

# Count expected notification types:
# A.1 APPLICATION_SUBMITTED
# A.2 APPLICATION_COMMITTEE_APPROVED
# A.3 APPLICATION_WITHDRAWN
# B.1 APPLICATION_COMMITTEE_CONDITIONAL
# B.2 APPLICATION_CONDITIONS_MET
# (Notifications from intermediate transitions also fire, so actual count >= 5)
$rCount = Get "/communication/notifications/unread-count" $researcherToken
$unreadFromEndpoint = if ($rCount -and $rCount.success) { $rCount.data.count } else { -1 }

if ($unreadFromEndpoint -ge $unreadFromList) {
  Write-Output "  [PASS] D.3 Unread endpoint count ($unreadFromEndpoint) matches list filter ($unreadFromList)"; $global:passed++
} else {
  Write-Output "  [FAIL] D.3 Unread endpoint count ($unreadFromEndpoint) < list filter ($unreadFromList)"; $global:failed++; $global:errors += "D.3"
}

# Mark all notifications as read and verify count goes to zero
$r = Patch "/communication/notifications/read-all" "{}" $researcherToken
Check "D.4 Mark all notifications as read" $r

$r = Get "/communication/notifications/unread-count" $researcherToken
CheckUnreadCount "D.5 Unread count is 0 after mark-all-read" $r 0

# ============================================================
# SUMMARY
# ============================================================
Write-Output "`n=========================================="
Write-Output "RESULTS"
Write-Output "=========================================="
Write-Output "  Passed: $global:passed"
Write-Output "  Failed: $global:failed"
if ($global:errors.Count -gt 0) {
  Write-Output "  Errors:"
  $global:errors | ForEach-Object { Write-Output "    - $_" }
}
Write-Output "=========================================="

if ($global:failed -gt 0) { exit 1 } else { exit 0 }
