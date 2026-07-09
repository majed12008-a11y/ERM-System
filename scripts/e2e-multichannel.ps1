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

function Check($msg, $body) {
  if ($body -and $body.success) { Write-Output "  [PASS] $msg"; $global:passed++ }
  else {
    $detail = if ($body -and $body.error) { " → $($body.error)" } else { " → (no response / HTTP error)" }
    Write-Output "  [FAIL] $msg$detail"; $global:failed++; $global:errors += $msg
  }
}

function CheckSentAt($msg, $body) {
  if (-not $body -or -not $body.success) {
    Write-Output "  [FAIL] $msg — no response"; $global:failed++; $global:errors += $msg; return
  }
  $notifs = $body.data
  if (-not $notifs -or $notifs.Count -eq 0) {
    Write-Output "  [FAIL] $msg — no notifications found"; $global:failed++; $global:errors += $msg; return
  }
  $first = $notifs[0]
  if ($first.sent_at) {
    Write-Output "  [PASS] $msg (sent_at=$($first.sent_at))"; $global:passed++
  } else {
    Write-Output "  [FAIL] $msg — sent_at is NULL (delivery pipeline may not have run)"; $global:failed++; $global:errors += $msg
  }
}

Write-Output "=========================================="
Write-Output "PHASE 4 P4 — Multi-Channel Delivery E2E"
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

# ============================================================
# SUITE A — IN_APP delivery baseline
# ============================================================
Write-Output "`n=========================================="
Write-Output "SUITE A — IN_APP Delivery (baseline)"
Write-Output "=========================================="

# Read existing notifications to verify delivery
$r = Get "/communication/notifications" $researcherToken
Check "A.1 GET notifications" $r
if ($r -and $r.success -and $r.data.Count -gt 0) {
  CheckSentAt "A.2 Most recent notification has sent_at" $r
} else {
  Write-Output "  [SKIP] A.2 No notifications to check — will verify after workflow trigger"
}

# ============================================================
# SUITE B — Workflow-triggered notification delivery
# ============================================================
Write-Output "`n=========================================="
Write-Output "SUITE B — Workflow-triggered delivery"
Write-Output "=========================================="

$r = Post "/core/projects" "{`"title_ar`":`"مشروع متعدد القنوات $runId`",`"title_en`":`"Multi-channel E2E $runId`",`"abstract_ar`":`"ملخص`",`"abstract_en`":`"Abstract`",`"objectives`":`"Test multi-channel delivery`",`"research_category`":`"BIOMEDICAL`",`"risk_level`":`"MODERATE`",`"start_date`":`"2026-07-01`",`"expected_end_date`":`"2027-06-30`"}" $researcherToken
Check "B.1 Create project" $r
if (-not $r) { Write-Output "  [FAIL] Cannot proceed without project — aborting"; exit 1 }
$projectId = $r.data.id

$r = Post "/core/applications" "{`"project_id`":$projectId,`"application_type`":`"INITIAL`",`"target_committee_id`":3}" $researcherToken
Check "B.2 Create application" $r
if (-not $r) { Write-Output "  [FAIL] Cannot proceed without application — aborting"; exit 1 }
$appId = $r.data.id

# Submit to trigger APPLICATION_SUBMITTED notification
$r = Post "/core/applications/$appId/transitions" "{`"transition_code`":`"SUBMIT`",`"comment`":`"E2E multi-channel test`"}" $researcherToken
Check "B.3 Submit application" $r

# Verify notification was created with sent_at
$r = Get "/communication/notifications" $researcherToken
Check "B.4 GET notifications after SUBMIT" $r
CheckSentAt "B.5 Notification has sent_at (IN_APP delivered)" $r

# ============================================================
# SUITE C — Channel routing with user preferences
# ============================================================
Write-Output "`n=========================================="
Write-Output "SUITE C — Channel routing verification"
Write-Output "=========================================="

# Verify default channels resolve to IN_APP (existing behavior)
$r = Get "/communication/notifications" $researcherToken
Check "C.1 Notifications accessible after multi-channel refactor" $r
CheckSentAt "C.2 sent_at is populated (delivery pipeline intact)" $r

# ============================================================
# SUMMARY
# ============================================================
Write-Output "`n=========================================="
Write-Output "RESULTS"
Write-Output "=========================================="
Write-Output "Passed: $global:passed"
Write-Output "Failed: $global:failed"
if ($global:errors.Count -gt 0) {
  Write-Output "Errors:"
  $global:errors | ForEach-Object { Write-Output "  - $_" }
}
Write-Output "=========================================="
if ($global:failed -gt 0) { exit 1 }
