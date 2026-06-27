$base = "http://localhost:3000/api/v1"
$body = @{username="admin"; password="Admin@1234"} | ConvertTo-Json
$r = Invoke-RestMethod -Uri "$base/security/auth/login" -Method Post -ContentType "application/json" -Body $body -TimeoutSec 10
$t = $r.data.accessToken

function TestWeb($desc, $method, $path, $json) {
  try {
    $h = @{Authorization="Bearer $t"}
    if ($json) { $h["Content-Type"] = "application/json" }
    $params = @{Uri="$base$path"; Method=$method; Headers=$h; TimeoutSec=15}
    if ($json) { $params["Body"] = $json }
    $resp = Invoke-WebRequest @params
    Write-Output "  ✅ $desc [$($resp.StatusCode)]"
  } catch {
    $ex = $_.Exception
    $status = if ($ex.Response) { $ex.Response.StatusCode.value__ } else { "?" }
    $body = ""
    try { $sr = New-Object System.IO.StreamReader($ex.Response.GetResponseStream()); $body = $sr.ReadToEnd(); $sr.Close() } catch {}
    Write-Output "  ❌ $desc [HTTP $status] $body"
  }
}

Write-Output "=== Reporting ==="
TestWeb "Applications report" GET "/reporting/applications?page=1&limit=3" $null
TestWeb "Committee stats" GET "/reporting/committees" $null
TestWeb "Export CSV" GET "/reporting/export/applications" $null

Write-Output "=== Documents ==="
TestWeb "Document types" GET "/documents/types" $null
TestWeb "Documents by entity" GET "/documents/entity/Application/1" $null

Write-Output "=== Meetings ==="
TestWeb "Create meeting" POST "/committee/meetings" '{"committee_id":3,"title":"Test","meeting_date":"2026-07-15T09:00:00Z","location":"Room A"}'

Write-Output "=== Workflow ==="
TestWeb "Workflow instance" GET "/workflow/instances/Application/1" $null
TestWeb "Available transitions" GET "/workflow/available-transitions/Application/1" $null
