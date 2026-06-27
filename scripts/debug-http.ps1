$base = "http://localhost:3000/api/v1"

function Login($u, $p) {
  $body = @{username=$u; password=$p} | ConvertTo-Json
  return (Invoke-RestMethod -Uri "$base/security/auth/login" -Method Post -ContentType "application/json" -Body $body -TimeoutSec 10).data.accessToken
}

function TestWeb($desc, $method, $path, $json, $token) {
  try {
    $h = @{Authorization="Bearer $token"}
    if ($json) { $h["Content-Type"] = "application/json" }
    $params = @{Uri="$base$path"; Method=$method; Headers=$h; TimeoutSec=15}
    if ($json) { $params["Body"] = $json }
    $r = Invoke-WebRequest @params
    Write-Output "  ✅ $desc [$($r.StatusCode)] $($r.Content)"
  } catch {
    $ex = $_.Exception
    $status = if ($ex.Response) { $ex.Response.StatusCode.value__ } else { "?" }
    $body = ""
    try { $sr = New-Object System.IO.StreamReader($ex.Response.GetResponseStream()); $body = $sr.ReadToEnd(); $sr.Close() } catch {}
    Write-Output "  ❌ $desc [HTTP $status] $body"
  }
}

$admin = Login "admin" "Admin@1234"
$researcher = Login "researcher1" "Test@1234"
$ethics = Login "ethics_admin" "Test@1234"

Write-Output "=== Debug POST endpoints ==="
TestWeb "Create project" POST "/core/projects" '{"title_ar":"مشروع تجريبي","title_en":"Debug Project","abstract_ar":"ملخص","abstract_en":"Abstract","objectives_ar":"أهداف","objectives_en":"Objectives","research_category_id":1,"risk_classification_id":1,"start_date":"2026-07-01","end_date":"2027-06-30"}' $researcher
TestWeb "Risk classifications" GET "/core/risk-classifications" $null $admin
TestWeb "Licenses" GET "/reference/licenses" $null $admin
TestWeb "Create review form" POST "/committee/reviews/forms" '{"code":"DEBUG_FORM2","name":"Debug Form","review_type":"SCIENTIFIC"}' $ethics
TestWeb "Set role perms" PUT "/security/permissions/role/8" '{"permissionIds":[1]}' $admin
