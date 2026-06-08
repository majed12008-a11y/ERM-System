# Ethics ERM System — Production Startup Script
# Usage: .\start-prod.ps1
# Requires: Node.js 22+, PostgreSQL 18+

$ErrorActionPreference = 'Stop'

# ---- Configuration ----
$BACKEND_DIR = Join-Path $PSScriptRoot "backend"
$FRONTEND_DIR = Join-Path $PSScriptRoot "frontend"
$LOG_DIR = Join-Path $PSScriptRoot "logs"
$BACKEND_PORT = 3000
$FRONTEND_PORT = 5173

# ---- Validate Environment ----
if (-not (Test-Path "$BACKEND_DIR\.env")) {
  Write-Error ".env file not found at $BACKEND_DIR\.env"
  exit 1
}

# ---- Create Log Directory ----
New-Item -ItemType Directory -Path $LOG_DIR -Force | Out-Null

# ---- Install Dependencies ----
Write-Host "Installing backend dependencies..." -ForegroundColor Cyan
Set-Location $BACKEND_DIR
npm ci --omit=dev 2>&1 | Out-Null

Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
Set-Location $FRONTEND_DIR
npm ci --omit=dev 2>&1 | Out-Null

# ---- Build Frontend ----
Write-Host "Building frontend..." -ForegroundColor Cyan
npm run build 2>&1 | Out-Null

# ---- Serve Frontend via Backend ----
# Copy frontend dist to backend for production serving
$BACKEND_PUBLIC = Join-Path $BACKEND_DIR "public"
if (Test-Path $BACKEND_PUBLIC) { Remove-Item -Recurse -Force $BACKEND_PUBLIC }
Copy-Item -Recurse (Join-Path $FRONTEND_DIR "dist") $BACKEND_PUBLIC

# ---- Start Backend ----
Write-Host "Starting backend on port $BACKEND_PORT..." -ForegroundColor Green
Set-Location $BACKEND_DIR

$env:NODE_ENV = "production"

$process = Start-Process -FilePath "node" -ArgumentList "dist/index.js" -NoNewWindow -PassThru -RedirectStandardOutput "$LOG_DIR\app.log" -RedirectStandardError "$LOG_DIR\error.log"

Write-Host "Backend PID: $($process.Id)" -ForegroundColor Green
Write-Host "API: http://localhost:$BACKEND_PORT/api/v1" -ForegroundColor Yellow
Write-Host "Docs: http://localhost:$BACKEND_PORT/api/v1/docs" -ForegroundColor Yellow

# Save PID for later
Set-Content -Path "$LOG_DIR\app.pid" -Value $process.Id

Write-Host "Production started successfully." -ForegroundColor Green
