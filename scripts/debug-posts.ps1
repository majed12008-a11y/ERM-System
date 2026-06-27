$base = "http://localhost:3000/api/v1"

function Login($u, $p) {
  $body = @{username=$u; password=$p} | ConvertTo-Json
  return (Invoke-RestMethod -Uri "$base/security/auth/login" -Method Post -ContentType "application/json" -Body $body -TimeoutSec 10).data.accessToken
}

function TestPost($desc, $path, $json, $token) {
  try {
    $r = Invoke-RestMethod -Uri "$base$path" -Method Post -Headers @{Authorization="Bearer $token";"Content-Type"="application/json"} -Body $json -TimeoutSec 10
    Write-Output "  ✅ $desc -> $($r.message)"
    return $r.data
  } catch {
    $msg = $_.Exception.Message
    try { $e = $_.Exception.Response; $sr = New-Object System.IO.StreamReader($e.GetResponseStream()); $msg = $sr.ReadToEnd(); $sr.Close() } catch {}
    Write-Output "  ❌ $desc -> $msg"
    return $null
  }
}

function TestGet($desc, $path, $token) {
  try {
    $r = Invoke-RestMethod -Uri "$base$path" -Method Get -Headers @{Authorization="Bearer $token"} -TimeoutSec 10
    Write-Output "  ✅ $desc"
    return $r.data
  } catch {
    $msg = $_.Exception.Message
    try { $e = $_.Exception.Response; $sr = New-Object System.IO.StreamReader($e.GetResponseStream()); $msg = $sr.ReadToEnd(); $sr.Close() } catch {}
    Write-Output "  ❌ $desc -> $msg"
    return $null
  }
}

$admin = Login "admin" "Admin@1234"
$researcher = Login "researcher1" "Test@1234"
$ethics = Login "ethics_admin" "Test@1234"

Write-Output "=== Phase 2 Debug ==="
TestPost "Create user" "/security/users" '{"username":"debug_test1","email":"debug_test1@test.com","password":"Test@1234","first_name_ar":"اختبار","last_name_ar":"فحص","institution_id":"4"}' $admin
TestPost "Create role" "/security/roles" '{"code":"DEBUG_ROLE","name_ar":"دور اختبار","name_en":"Debug Role"}' $admin
TestPost "Set role perms" "/security/permissions/role/2" '{"permissionIds":[1]}' $admin

Write-Output "=== Phase 3 Debug ==="
TestPost "Create project" "/core/projects" '{"title_ar":"مشروع تجريبي","title_en":"Debug Project","abstract_ar":"ملخص","abstract_en":"Abstract","objectives_ar":"أهداف","objectives_en":"Objectives","research_category_id":1,"risk_classification_id":1,"start_date":"2026-07-01","end_date":"2027-06-30"}' $researcher
TestGet "Research categories" "/core/research-categories" $researcher
TestGet "Risk classifications" "/core/risk-classifications" $researcher

Write-Output "=== Phase 5 Debug ==="
TestPost "Create review form" "/committee/reviews/forms" '{"code":"DEBUG_FORM","name":"Debug Form","review_type":"SCIENTIFIC"}' $ethics

Write-Output "=== Reference debug ==="
TestGet "Licenses" "/reference/licenses" $admin
TestGet "Risk classifications (ref)" "/core/risk-classifications" $admin
