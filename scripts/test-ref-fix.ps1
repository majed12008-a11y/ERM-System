$base = "http://localhost:3000/api/v1"
$body = @{username="admin"; password="Admin@1234"} | ConvertTo-Json
$r = Invoke-RestMethod -Uri "$base/security/auth/login" -Method Post -ContentType "application/json" -Body $body -TimeoutSec 10
$t = $r.data.accessToken
Write-Output "=== Risk classifications ==="
$r2 = Invoke-RestMethod -Uri "$base/core/risk-classifications" -Method Get -Headers @{Authorization="Bearer $t"} -TimeoutSec 10
Write-Output ($r2 | ConvertTo-Json -Depth 2)
Write-Output "=== Licenses ==="
try {
  $r3 = Invoke-RestMethod -Uri "$base/reference/licenses" -Method Get -Headers @{Authorization="Bearer $t"} -TimeoutSec 10
  Write-Output ($r3 | ConvertTo-Json -Depth 2)
} catch {
  $msg = $_.Exception.Message
  try { $e = $_.Exception.Response; $sr = New-Object System.IO.StreamReader($e.GetResponseStream()); $msg = $sr.ReadToEnd(); $sr.Close() } catch {}
  Write-Output "ERROR: $msg"
}
