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

function CheckCount($msg, $body, $expectedCount) {
  $actual = ($body.data | Measure-Object).Count
  if ($body -and $body.success -and $actual -eq $expectedCount) {
    Write-Output "  [PASS] $msg (count=$actual)"; $global:passed++
  } elseif ($body -and $body.success) {
    Write-Output "  [FAIL] $msg — expected $expectedCount items but got $actual"; $global:failed++; $global:errors += $msg
  } else {
    $detail = if ($body -and $body.error) { " → $($body.error)" } else { "" }
    Write-Output "  [FAIL] $msg$detail"; $global:failed++; $global:errors += $msg
  }
}

function CheckSummary($msg, $body, $expected) {
  $s = $body.data
  $ok = $body.success
  foreach ($key in $expected.Keys) {
    if ($s.$key -ne $expected[$key]) { $ok = $false }
  }
  if ($ok) {
    Write-Output "  [PASS] $msg"; $global:passed++
  } else {
    Write-Output "  [FAIL] $msg — expected $($expected | ConvertTo-Json -Compress) but got total=$($s.total) open=$($s.open) met=$($s.met) notMet=$($s.notMet) waived=$($s.waived) allSatisfied=$($s.allSatisfied) canApprove=$($s.canApprove)"
    $global:failed++; $global:errors += $msg
  }
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

Write-Output "=========================================="
Write-Output "CONDITIONS E2E — Conditional Approval Flow"
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
Write-Output "  [PASS] Logged in as admin (SUPER_ADMIN)"

# ============================================================
# PHASE 1: SETUP — Create project + application
# ============================================================
Write-Output "`n--- PHASE 1: Setup ---"

$r = Post "/core/projects" "{`"title_ar`":`"مشروع اختبار الشروط $runId`",`"title_en`":`"Conditions E2E Test Project $runId`",`"abstract_ar`":`"ملخص`",`"abstract_en`":`"Abstract`",`"objectives`":`"Test objectives`",`"research_category`":`"BIOMEDICAL`",`"risk_level`":`"MODERATE`",`"start_date`":`"2026-07-01`",`"expected_end_date`":`"2027-06-30`"}" $researcherToken
Check "1.1 Create project" $r
if (-not $r) { Write-Output "  [FAIL] Cannot proceed without project — aborting"; exit 1 }
$projectId = $r.data.id

$r = Post "/core/applications" "{`"project_id`":$projectId,`"application_type`":`"INITIAL`",`"target_committee_id`":3}" $researcherToken
Check "1.2 Create application" $r
if (-not $r) { Write-Output "  [FAIL] Cannot proceed without application — aborting"; exit 1 }
$appId = $r.data.id

# ============================================================
# PHASE 2: Navigate through workflow to COMMITTEE_REVIEW
# ============================================================
Write-Output "`n--- PHASE 2: Navigate to COMMITTEE_REVIEW ---"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"SUBMIT`",`"comment`":`"`"}" $researcherToken
CheckStatus "2.1 Submit (DRAFT → SUBMITTED)" $r "SUBMITTED"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"ACCEPT_INITIAL`",`"comment`":`"`"}" $ethicsToken
CheckStatus "2.2 Accept initial (SUBMITTED → INITIAL_REVIEW)" $r "INITIAL_REVIEW"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"SEND_TO_SCIENTIFIC`",`"comment`":`"`"}" $ethicsToken
CheckStatus "2.3 Send to scientific (INITIAL_REVIEW → SCIENTIFIC_REVIEW)" $r "SCIENTIFIC_REVIEW"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"SEND_TO_ETHICAL`",`"comment`":`"`"}" $ethicsToken
CheckStatus "2.4 Send to ethical (SCIENTIFIC_REVIEW → ETHICAL_REVIEW)" $r "ETHICAL_REVIEW"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"SEND_TO_COMMITTEE`",`"comment`":`"`"}" $ethicsToken
CheckStatus "2.5 Send to committee (ETHICAL_REVIEW → COMMITTEE_REVIEW)" $r "COMMITTEE_REVIEW"

# ============================================================
# PHASE 3: Create conditions while in COMMITTEE_REVIEW
# ============================================================
Write-Output "`n--- PHASE 3: Create Conditions ---"

$r = Post "/core/applications/$appId/conditions" "{`"condition_text`":`"Provide updated safety protocols`",`"severity`":`"CRITICAL`",`"category`":`"SAFETY`",`"due_date`":`"2026-12-31`"}" $ethicsToken
Check "3.1 Create condition 1 (CRITICAL)" $r
$cond1Id = if ($r) { $r.data.id } else { $null }

$r = Post "/core/applications/$appId/conditions" "{`"condition_text`":`"Submit informed consent forms`",`"severity`":`"MAJOR`",`"category`":`"ETHICAL`",`"due_date`":`"2026-10-15`"}" $ethicsToken
Check "3.2 Create condition 2 (MAJOR)" $r
$cond2Id = if ($r) { $r.data.id } else { $null }

$r = Post "/core/applications/$appId/conditions" "{`"condition_text`":`"Update data privacy agreement`",`"severity`":`"MINOR`",`"category`":`"ADMINISTRATIVE`"}" $ethicsToken
Check "3.3 Create condition 3 (MINOR, no due date)" $r
$cond3Id = if ($r) { $r.data.id } else { $null }

$r = Get "/core/applications/$appId/conditions" $ethicsToken
CheckCount "3.4 List conditions" $r 3

$r = Get "/core/applications/$appId/conditions/summary" $ethicsToken
CheckSummary "3.5 Condition summary (3 OPEN)" $r @{total=3; open=3; met=0; notMet=0; waived=0; allSatisfied=$false; canApprove=$false; canReject=$false}

# ============================================================
# PHASE 4: Conditional approval — COMMITTEE_CONDITIONAL
# ============================================================
Write-Output "`n--- PHASE 4: Conditional Approval ---"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"COMMITTEE_CONDITIONAL`",`"comment`":`"Approved with 3 conditions`"}" $ethicsToken
CheckStatus "4.1 Conditional approval (COMMITTEE_REVIEW → AWAITING_CONDITIONS)" $r "AWAITING_CONDITIONS"

$r = Get "/core/applications/$appId/conditions/summary" $ethicsToken
CheckSummary "4.2 Summary after conditional (3 OPEN, canReject)" $r @{total=3; open=3; met=0; notMet=0; waived=0; allSatisfied=$false; canApprove=$false; canReject=$true}

# ============================================================
# PHASE 5: Resolve conditions
# ============================================================
Write-Output "`n--- PHASE 5: Resolve Conditions ---"

# Try CONDITIONS_MET before all resolved — should fail via validateTransition
$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"CONDITIONS_MET`",`"comment`":`"`"}" $ethicsToken
if (-not $r -or -not $r.success) {
  Write-Output "  [PASS] 5.1 CONDITIONS_MET rejected (conditions not all MET, as expected)"
  $global:passed++
} else {
  Write-Output "  [FAIL] 5.1 CONDITIONS_MET should have been rejected but was accepted"
  $global:failed++; $global:errors += "5.1"
}

# Resolve condition 1 as MET
$r = Patch "/core/applications/$appId/conditions/$cond1Id/resolve" "{`"status`":`"MET`"}" $ethicsToken
Check "5.2 Resolve condition 1 as MET" $r

$r = Get "/core/applications/$appId/conditions/summary" $ethicsToken
CheckSummary "5.3 Summary after 1 MET" $r @{total=3; open=2; met=1; notMet=0; waived=0; allSatisfied=$false; canApprove=$false; canReject=$true}

# Resolve condition 2 as MET
$r = Patch "/core/applications/$appId/conditions/$cond2Id/resolve" "{`"status`":`"MET`"}" $ethicsToken
Check "5.4 Resolve condition 2 as MET" $r

$r = Get "/core/applications/$appId/conditions/summary" $ethicsToken
CheckSummary "5.5 Summary after 2 MET" $r @{total=3; open=1; met=2; notMet=0; waived=0; allSatisfied=$false; canApprove=$false; canReject=$true}

# Resolve condition 3 as MET
$r = Patch "/core/applications/$appId/conditions/$cond3Id/resolve" "{`"status`":`"MET`"}" $ethicsToken
Check "5.6 Resolve condition 3 as MET" $r

$r = Get "/core/applications/$appId/conditions/summary" $ethicsToken
CheckSummary "5.7 Summary after all MET" $r @{total=3; open=0; met=3; notMet=0; waived=0; allSatisfied=$true; canApprove=$true; canReject=$false}

# ============================================================
# PHASE 6: CONDITIONS_MET → APPROVED
# ============================================================
Write-Output "`n--- PHASE 6: Final Approval ---"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"CONDITIONS_MET`",`"comment`":`"All conditions satisfied`"}" $ethicsToken
CheckStatus "6.1 Conditions met (AWAITING_CONDITIONS → APPROVED)" $r "APPROVED"

# ============================================================
# PHASE 7: Terminal state — CLOSE then ARCHIVE
# ============================================================
Write-Output "`n--- PHASE 7: Terminal States ---"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"CLOSE`",`"comment`":`"Study completed`"}" $ethicsToken
CheckStatus "7.1 Close study (APPROVED → CLOSED)" $r "CLOSED"

$r = Patch "/core/applications/$appId/status" "{`"transition_code`":`"ARCHIVE`",`"comment`":`"`"}" $adminToken
CheckStatus "7.2 Archive study (CLOSED → ARCHIVED)" $r "ARCHIVED"

# Verify no transitions available from ARCHIVED
$r = Get "/workflow/available-transitions/Application/$appId" $adminToken
if ($r -and $r.success -and $r.data.transitions.Count -eq 0) {
  Write-Output "  [PASS] 7.3 No transitions available from ARCHIVED"
  $global:passed++
} else {
  $count = if ($r.data) { $r.data.transitions.Count } else { "null" }
  Write-Output "  [FAIL] 7.3 Expected 0 transitions from ARCHIVED but got $count"
  $global:failed++; $global:errors += "7.3"
}

# ============================================================
# PHASE 8: Edge cases — NOT_MET/WAIVED resolution path
# ============================================================
Write-Output "`n--- PHASE 8: Edge Cases (new application) ---"

# Create another application for NOT_MET flow
$r = Post "/core/applications" "{`"project_id`":$projectId,`"application_type`":`"INITIAL`",`"target_committee_id`":3}" $researcherToken
Check "8.0 Create edge test application" $r
$edgeAppId = if ($r) { $r.data.id } else { $null }

$r = Patch "/core/applications/$edgeAppId/status" "{`"transition_code`":`"SUBMIT`",`"comment`":`"`"}" $researcherToken
CheckStatus "8.1 Submit edge app" $r "SUBMITTED"

$r = Patch "/core/applications/$edgeAppId/status" "{`"transition_code`":`"ACCEPT_INITIAL`",`"comment`":`"`"}" $ethicsToken
CheckStatus "8.2 Accept initial" $r "INITIAL_REVIEW"

$r = Patch "/core/applications/$edgeAppId/status" "{`"transition_code`":`"SEND_TO_SCIENTIFIC`",`"comment`":`"`"}" $ethicsToken
CheckStatus "8.3 Send to scientific" $r "SCIENTIFIC_REVIEW"

$r = Patch "/core/applications/$edgeAppId/status" "{`"transition_code`":`"SEND_TO_ETHICAL`",`"comment`":`"`"}" $ethicsToken
CheckStatus "8.4 Send to ethical" $r "ETHICAL_REVIEW"

$r = Patch "/core/applications/$edgeAppId/status" "{`"transition_code`":`"SEND_TO_COMMITTEE`",`"comment`":`"`"}" $ethicsToken
CheckStatus "8.5 Send to committee" $r "COMMITTEE_REVIEW"

$r = Post "/core/applications/$edgeAppId/conditions" "{`"condition_text`":`"Edge case condition`",`"severity`":`"MAJOR`",`"category`":`"GENERAL`"}" $ethicsToken
Check "8.6 Create edge condition" $r
$edgeCondId = if ($r) { $r.data.id } else { $null }

$r = Patch "/core/applications/$edgeAppId/status" "{`"transition_code`":`"COMMITTEE_CONDITIONAL`",`"comment`":`"Conditional`"}" $ethicsToken
CheckStatus "8.7 Conditional approval (→ AWAITING_CONDITIONS)" $r "AWAITING_CONDITIONS"

# Resolve as NOT_MET
$r = Patch "/core/applications/$edgeAppId/conditions/$edgeCondId/resolve" "{`"status`":`"NOT_MET`"}" $ethicsToken
Check "8.8 Resolve as NOT_MET" $r

$r = Get "/core/applications/$edgeAppId/conditions/summary" $ethicsToken
CheckSummary "8.9 Summary after NOT_MET" $r @{total=1; open=0; met=0; notMet=1; waived=0; allSatisfied=$false; canApprove=$false; canReject=$true}

# Try CONDITIONS_MET with a NOT_MET condition — should fail
$r = Patch "/core/applications/$edgeAppId/status" "{`"transition_code`":`"CONDITIONS_MET`",`"comment`":`"`"}" $ethicsToken
if (-not $r -or -not $r.success) {
  Write-Output "  [PASS] 8.10 CONDITIONS_MET rejected (condition NOT_MET, as expected)"
  $global:passed++
} else {
  Write-Output "  [FAIL] 8.10 CONDITIONS_MET should have been rejected but was accepted"
  $global:failed++; $global:errors += "8.10"
}

# Resolve as WAIVED
$r = Patch "/core/applications/$edgeAppId/conditions/$edgeCondId/resolve" "{`"status`":`"WAIVED`"}" $ethicsToken
Check "8.11 Resolve as WAIVED" $r

$r = Get "/core/applications/$edgeAppId/conditions/summary" $ethicsToken
CheckSummary "8.12 Summary after WAIVED" $r @{total=1; open=0; met=0; notMet=0; waived=1; allSatisfied=$true; canApprove=$true; canReject=$false}

# CONDITIONS_MET should now succeed
$r = Patch "/core/applications/$edgeAppId/status" "{`"transition_code`":`"CONDITIONS_MET`",`"comment`":`"Waived condition accepted`"}" $ethicsToken
CheckStatus "8.13 Conditions met (waived → APPROVED)" $r "APPROVED"

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
