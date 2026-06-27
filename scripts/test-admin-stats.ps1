$base = "http://localhost:3000/api/v1"
$body = @{username="admin"; password="Admin@1234"} | ConvertTo-Json

Write-Output "=== Login ==="
$r = Invoke-RestMethod -Uri "$base/security/auth/login" -Method Post -ContentType "application/json" -Body $body -TimeoutSec 10
$t = $r.data.accessToken
Write-Output "Token: $($t.Substring(0,20))..."

Write-Output "=== Admin Stats (30s timeout) ==="
try {
  $r2 = Invoke-RestMethod -Uri "$base/admin/stats" -Method Get -Headers @{Authorization="Bearer $t"} -TimeoutSec 30
  Write-Output ($r2 | ConvertTo-Json -Depth 3)
} catch {
  Write-Output "ERROR: $($_.Exception.Message)"
  try {
    $sr = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream())
    Write-Output "BODY: $($sr.ReadToEnd())"
    $sr.Close()
  } catch {}
}
