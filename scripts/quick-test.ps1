$base = "http://localhost:3000/api/v1"
$body = @{username="admin"; password="Admin@1234"} | ConvertTo-Json
$r = Invoke-RestMethod -Uri "$base/security/auth/login" -Method Post -ContentType "application/json" -Body $body -TimeoutSec 5
$t = $r.data.accessToken

Write-Output "=== Admin Stats ==="
$r2 = Invoke-RestMethod -Uri "$base/admin/stats" -Method Get -Headers @{Authorization="Bearer $t"} -TimeoutSec 5
Write-Output ($r2 | ConvertTo-Json -Depth 3)

Write-Output "=== System Config ==="
$r3 = Invoke-RestMethod -Uri "$base/system/config" -Method Get -Headers @{Authorization="Bearer $t"} -TimeoutSec 5
Write-Output ($r3.data | ConvertTo-Json -Depth 2)

Write-Output "=== Committee 3 ==="
$r4 = Invoke-RestMethod -Uri "$base/committee/committees/3" -Method Get -Headers @{Authorization="Bearer $t"} -TimeoutSec 5
Write-Output ($r4 | ConvertTo-Json -Depth 2)
