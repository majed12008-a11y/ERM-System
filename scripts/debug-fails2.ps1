param([string]$Base = "http://localhost:3000/api/v1")

function Login($u, $p) {
  $body = @{username=$u; password=$p} | ConvertTo-Json
  return (Invoke-RestMethod -Uri "$Base/security/auth/login" -Method Post -ContentType "application/json" -Body $body).data.accessToken
}

$admin = Login "admin" "Admin@2026"
$researcher = Login "researcher1" "Test@1234"

# Committees
Write-Output "=== Committees ==="
try {
  $r = Invoke-RestMethod -Uri "$Base/committee/committees" -Method Get -Headers @{Authorization="Bearer $admin"}
  Write-Output ($r | ConvertTo-Json -Depth 3)
} catch { Write-Output "Error: $($_.Exception.Message)" }

# Admin stats body
Write-Output "=== Admin Stats (Response body from 500) ==="
try {
  $r = Invoke-WebRequest -Uri "$Base/admin/stats" -Method Get -Headers @{Authorization="Bearer $admin"}
  Write-Output $r.Content
} catch { Write-Output "Status: $($_.Exception.Response.StatusCode.value__)"; try { $s = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream()); Write-Output $s.ReadToEnd(); $s.Close() } catch {} }

# System config
Write-Output "=== System Config (Response body from 500) ==="
try {
  $r = Invoke-WebRequest -Uri "$Base/system/config" -Method Get -Headers @{Authorization="Bearer $admin"}
  Write-Output $r.Content
} catch { Write-Output "Status: $($_.Exception.Response.StatusCode.value__)"; try { $s = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream()); Write-Output $s.ReadToEnd(); $s.Close() } catch {} }

# Create project (get more info)
Write-Output "=== Create project (detailed error) ==="
try {
  $r = Invoke-WebRequest -Uri "$Base/core/projects" -Method Post -Headers @{Authorization="Bearer $researcher";"Content-Type"="application/json"} -Body '{"title_ar":"مشروع اختبار","title_en":"Test Project","abstract_ar":"ملخص","abstract_en":"Abstract","objectives_ar":"أهداف","objectives_en":"Objectives","research_category_id":1,"risk_classification_id":1,"start_date":"2026-07-01","end_date":"2027-06-30"}'
  Write-Output $r.Content
} catch { Write-Output "Status: $($_.Exception.Response.StatusCode.value__)"; try { $s = New-Object System.IO.StreamReader($_.Exception.Response.GetResponseStream()); Write-Output $s.ReadToEnd(); $s.Close() } catch {} }
