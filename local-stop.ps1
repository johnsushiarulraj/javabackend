# JavaBackend Local Stop Script (Without Docker)
# This script stops all locally running Spring Boot services

Write-Host "=== JavaBackend Local Shutdown Script ===" -ForegroundColor Cyan
Write-Host ""

# Function to stop processes on a specific port
function Stop-ProcessOnPort {
    param (
        [int]$Port,
        [string]$ServiceName
    )

    Write-Host "Stopping $ServiceName on port $Port..." -ForegroundColor Yellow

    $process = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue |
               Select-Object -ExpandProperty OwningProcess -Unique

    if ($process) {
        foreach ($processId in $process) {
            try {
                $proc = Get-Process -Id $processId -ErrorAction Stop
                Write-Host "  Killing process: $($proc.ProcessName) (PID: $processId)" -ForegroundColor Gray
                Stop-Process -Id $processId -Force
                Write-Host "  $ServiceName stopped!" -ForegroundColor Green
            } catch {
                Write-Host "  Could not stop process with PID: $processId" -ForegroundColor Red
            }
        }
    } else {
        Write-Host "  No process found on port $Port" -ForegroundColor Gray
    }
}

# Stop all services
Stop-ProcessOnPort -Port 8761 -ServiceName "Eureka Server"
Write-Host ""

Stop-ProcessOnPort -Port 8888 -ServiceName "Config Server"
Write-Host ""

Stop-ProcessOnPort -Port 8081 -ServiceName "Hello Service"
Write-Host ""

Stop-ProcessOnPort -Port 8080 -ServiceName "Gateway Server"
Write-Host ""

# Also kill any Maven processes that might be running
Write-Host "Cleaning up any remaining Maven processes..." -ForegroundColor Yellow
$mavenProcesses = Get-Process -Name "java" -ErrorAction SilentlyContinue |
                  Where-Object { $_.CommandLine -like "*spring-boot*" -or $_.CommandLine -like "*maven*" }

if ($mavenProcesses) {
    foreach ($proc in $mavenProcesses) {
        try {
            Write-Host "  Stopping Maven process (PID: $($proc.Id))" -ForegroundColor Gray
            Stop-Process -Id $proc.Id -Force
        } catch {
            # Process might have already stopped
        }
    }
    Write-Host "Maven processes cleaned up!" -ForegroundColor Green
} else {
    Write-Host "No Maven processes found" -ForegroundColor Gray
}

Write-Host ""
Write-Host "=== Shutdown Complete ===" -ForegroundColor Cyan
Write-Host ""
