param([string]$Base = "http://localhost:3000/api/v1")

function Login($u, $p) {
  $body = @{username=$u; password=$p} | ConvertTo-Json
  $r = Invoke-RestMethod -Uri "$Base/security/auth/login" -Method Post -ContentType "application/json" -Body $body
  return $r.data.accessToken
}

function TryGet($path, $token) {
  try {
    $h = @{}
    if ($token) { $h["Authorization"] = "Bearer $token" }
    return Invoke-RestMethod -Uri "$Base$path" -Method Get -Headers $h
  } catch { return @{success=$false; error=$_.Exception.Message} }
}

function TryPost($path, $jsonBody, $token) {
  try {
    $h = @{"Content-Type"="application/json"}
    if ($token) { $h["Authorization"] = "Bearer $token" }
    return Invoke-RestMethod -Uri "$Base$path" -Method Post -Headers $h -Body $jsonBody
  } catch {
    $msg = $_.Exception.Message
    try { $e = $_.Exception.Response; $sr = New-Object System.IO.StreamReader($e.GetResponseStream()); $msg = $sr.ReadToEnd(); $sr.Close() } catch {}
    Write-Output "  Error Body: $msg"
    return @{success=$false}
  }
}

$adminToken = Login "admin" "Admin@2026"
$researcherToken = Login "researcher1" "Test@1234"

Write-Output "=== 2.3 Create user ==="
$r = TryPost "/security/users" '{"username":"test_db1","email":"test_db1@test.com","password":"Test@1234","first_name_ar":"اختبار","last_name_ar":"مستخدم","institution_id":"4"}' $adminToken
Write-Output ($r | ConvertTo-Json -Depth 3)

Write-Output "=== 3.1 Create project ==="
$r = TryPost "/core/projects" '{"title_ar":"مشروع اختبار","title_en":"Test Project","abstract_ar":"ملخص","abstract_en":"Abstract","objectives_ar":"أهداف","objectives_en":"Objectives","research_category_id":1,"risk_classification_id":1,"start_date":"2026-07-01","end_date":"2027-06-30"}' $researcherToken
Write-Output ($r | ConvertTo-Json -Depth 3)

Write-Output "=== 4.4 Get committee 1 ==="
$r = TryGet "/committee/committees/1" $adminToken
Write-Output ($r | ConvertTo-Json -Depth 3)

Write-Output "=== 9.1 Admin stats ==="
$r = TryGet "/admin/stats" $adminToken
Write-Output ($r | ConvertTo-Json -Depth 3)

Write-Output "=== 9.7 System config ==="
$r = TryGet "/system/config" $adminToken
Write-Output ($r | ConvertTo-Json -Depth 3)
