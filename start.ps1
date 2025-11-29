# JavaBackend Start Script (Docker Compose Version)
# This script stops any running instances, builds the JAR, and starts both containers using docker-compose

Write-Host "=== JavaBackend Startup Script (Docker Compose) ===" -ForegroundColor Cyan
Write-Host ""

# Stop any existing instances first
Write-Host "Stopping any running instances..." -ForegroundColor Yellow
& "$PSScriptRoot\stop.ps1"
Start-Sleep -Seconds 2

# Clean and build the JAR
Write-Host ""
Write-Host "Building JAR with Maven..." -ForegroundColor Green
mvn clean package
if ($LASTEXITCODE -ne 0) {
    Write-Host "Maven build failed! Exiting..." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "JAR build successful!" -ForegroundColor Green
Start-Sleep -Seconds 1

# Build and start containers using docker-compose
Write-Host ""
Write-Host "Building Docker images and starting containers..." -ForegroundColor Green
docker-compose up -d --build
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker Compose failed! Exiting..." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Containers started successfully!" -ForegroundColor Green

# Wait for the server to start
Write-Host "Waiting for server to start up..." -ForegroundColor Yellow
Start-Sleep -Seconds 20

# Check if server is running
$serverRunning = $false
try {
    $response = Invoke-WebRequest -Uri "http://localhost:8080" -TimeoutSec 5 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        $serverRunning = $true
    }
} catch {
    # Server might not be ready yet
}

if ($serverRunning) {
    Write-Host "Server is running successfully at http://localhost:8080" -ForegroundColor Green
} else {
    Write-Host "Warning: Server may still be starting up. Check manually at http://localhost:8080" -ForegroundColor Yellow
}

# Check container status
Write-Host ""
Write-Host "Checking container status..." -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "=== Startup Complete ===" -ForegroundColor Cyan
Write-Host "Local URL: http://localhost:8080" -ForegroundColor White
Write-Host "Public URL: https://javabackend.com" -ForegroundColor White
Write-Host ""
Write-Host "Running containers:" -ForegroundColor White
Write-Host "  - javabackend-container (Spring Boot app)" -ForegroundColor Gray
Write-Host "  - cloudflared-tunnel (Cloudflare tunnel)" -ForegroundColor Gray
Write-Host ""
Write-Host "To view logs: docker-compose logs -f" -ForegroundColor Yellow
Write-Host "To stop the services, run: .\stop.ps1" -ForegroundColor Yellow
Write-Host ""
