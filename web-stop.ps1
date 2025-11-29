# JavaBackend Stop Script (Docker Compose Version)
# This script stops all containers using docker-compose

Write-Host "=== JavaBackend Shutdown Script (Docker Compose) ===" -ForegroundColor Cyan
Write-Host ""

# Stop and remove containers using docker-compose
Write-Host "Stopping all containers..." -ForegroundColor Yellow
docker-compose down

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "All containers stopped and removed successfully!" -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "Warning: docker-compose down encountered an issue" -ForegroundColor Yellow
}

# Fallback: Stop any other processes on port 8080
$port8080Process = Get-NetTCPConnection -LocalPort 8080 -ErrorAction SilentlyContinue | Select-Object -ExpandProperty OwningProcess -Unique

if ($port8080Process) {
    Write-Host ""
    Write-Host "Found additional processes on port 8080, stopping them..." -ForegroundColor Yellow
    foreach ($processId in $port8080Process) {
        try {
            $process = Get-Process -Id $processId -ErrorAction Stop
            Write-Host "Stopping process: $($process.ProcessName) (PID: $processId)" -ForegroundColor Yellow
            Stop-Process -Id $processId -Force
        } catch {
            Write-Host "Could not stop process with PID: $processId" -ForegroundColor Red
        }
    }
}

# Fallback: Stop any standalone cloudflared processes
$cloudflaredProcesses = Get-Process -Name "cloudflared" -ErrorAction SilentlyContinue

if ($cloudflaredProcesses) {
    Write-Host ""
    Write-Host "Found standalone cloudflared processes, stopping them..." -ForegroundColor Yellow
    foreach ($process in $cloudflaredProcesses) {
        Write-Host "Stopping cloudflared (PID: $($process.Id))" -ForegroundColor Yellow
        Stop-Process -Id $process.Id -Force
    }
}

Write-Host ""
Write-Host "=== Shutdown Complete ===" -ForegroundColor Cyan
Write-Host ""
