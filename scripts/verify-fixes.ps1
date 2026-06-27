param([string]$Base = "http://localhost:3000/api/v1")

function Login($u, $p) {
  $body = @{username=$u; password=$p} | ConvertTo-Json
  return (Invoke-RestMethod -Uri "$Base/security/auth/login" -Method Post -ContentType "application/json" -Body $body).data.accessToken
}

function TryGet($path, $token) {
  try {
    $h = @{}
    if ($token) { $h["Authorization"] = "Bearer $token" }
    $r = Invoke-RestMethod -Uri "$Base$path" -Method Get -Headers $h
    return @{success=$r.success; status="OK"}
  } catch {
    $status = $_.Exception.Response.StatusCode.value__
    return @{success=$false; status=$status}
  }
}

$at = Login "admin" "Admin@2026"
$rt = Login "researcher1" "Test@1234"

Write-Output "=== Testing fixed endpoints ==="
$tests = @(
  @{path="/admin/stats"; desc="Admin stats (was 500)"},
  @{path="/system/config"; desc="System config (was 500)"},
  @{path="/committee/committees/3"; desc="Committee 3 (exists)"},
  @{path="/committee/committees/1"; desc="Committee 1 (deleted, expect 404)"},
  @{path="/assignment/:assignmentId/answers"; desc="Skip placeholder"}
)

foreach ($t in $tests) {
  $r = TryGet $t.path $at
  $icon = if ($r.success -or ($r.status -eq 404)) { "✅" } else { "❌" }
  Write-Output "  $icon $($t.desc) -> HTTP $($r.status)"
}

Write-Output "=== Core workflow (create user, project, app) ==="
Write-Output "  Creating user..."
try {
  $r = Invoke-RestMethod -Uri "$Base/security/users" -Method Post -Headers @{Authorization="Bearer $at";"Content-Type"="application/json"} -Body '{"username":"test_fix1","email":"test_fix1@test.com","password":"Test@1234","first_name_ar":"اختبار","last_name_ar":"إصلاح","institution_id":"4"}'
  Write-Output "  ✅ Create user: $($r.data.id)"
  $uid = $r.data.id
  $r = Invoke-RestMethod -Uri "$Base/security/users/$uid" -Method Put -Headers @{Authorization="Bearer $at";"Content-Type"="application/json"} -Body '{"first_name_en":"FixTest"}'
  Write-Output "  ✅ Update user"
} catch { Write-Output "  ❌ User op failed" }

Write-Output "  Creating project (researcher)..."
try {
  $r = Invoke-RestMethod -Uri "$Base/core/projects" -Method Post -Headers @{Authorization="Bearer $rt";"Content-Type"="application/json"} -Body '{"title_ar":"اختبار","title_en":"Fix Test","abstract_ar":"ملخص","abstract_en":"Abstract","objectives_ar":"أهداف","objectives_en":"Objectives","research_category_id":1,"risk_classification_id":1,"start_date":"2026-07-01","end_date":"2027-06-30"}'
  Write-Output "  ✅ Create project: $($r.data.id)"
} catch { Write-Output "  ❌ Create project failed: $($_.Exception.Message)" }
