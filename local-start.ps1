# JavaBackend Local Start Script (Separate Windows)
# This script starts all microservices locally in separate PowerShell windows
# Use this if you don't have Windows Terminal installed

Write-Host "=== JavaBackend Local Startup Script (Separate Windows) ===" -ForegroundColor Cyan
Write-Host "Starting all services locally in separate windows..." -ForegroundColor White
Write-Host ""

# Stop any existing instances first
Write-Host "Checking for running services..." -ForegroundColor Yellow
& "$PSScriptRoot\local-stop.ps1"
Start-Sleep -Seconds 2

# Build all services
Write-Host ""
Write-Host "Building all services with Maven..." -ForegroundColor Green
mvn clean package -DskipTests
if ($LASTEXITCODE -ne 0) {
    Write-Host "Maven build failed! Exiting..." -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Build successful! Starting services..." -ForegroundColor Green
Write-Host ""

# Start Eureka Server (Service Discovery)
Write-Host "Starting Eureka Server on port 8761..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot'; Write-Host 'Eureka Server' -ForegroundColor Cyan; mvn spring-boot:run -pl eureka-server"
Start-Sleep -Seconds 20

# Start Config Server
Write-Host "Starting Config Server on port 8888..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot'; Write-Host 'Config Server' -ForegroundColor Cyan; mvn spring-boot:run -pl config-server"
Start-Sleep -Seconds 15

# Start Hello Service
Write-Host "Starting Hello Service on port 8081..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot'; Write-Host 'Hello Service' -ForegroundColor Cyan; mvn spring-boot:run -pl hello-service"
Start-Sleep -Seconds 15

# Start Gateway Server
Write-Host "Starting Gateway Server on port 8080..." -ForegroundColor Cyan
Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$PSScriptRoot'; Write-Host 'Gateway Server' -ForegroundColor Cyan; mvn spring-boot:run -pl gateway-server"
Start-Sleep -Seconds 10

Write-Host ""
Write-Host "=== All Services Started ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Services are starting in separate windows. Please wait 1-2 minutes for all services to be fully ready." -ForegroundColor Yellow
Write-Host ""
Write-Host "Service URLs:" -ForegroundColor White
Write-Host "  - Eureka Dashboard:  http://localhost:8761" -ForegroundColor Gray
Write-Host "  - Config Server:     http://localhost:8888" -ForegroundColor Gray
Write-Host "  - Hello Service:     http://localhost:8081" -ForegroundColor Gray
Write-Host "  - Gateway Server:    http://localhost:8080" -ForegroundColor Gray
Write-Host ""
Write-Host "Access your application via:" -ForegroundColor White
Write-Host "  - Direct:   http://localhost:8081" -ForegroundColor Cyan
Write-Host "  - Gateway:  http://localhost:8080/hello" -ForegroundColor Cyan
Write-Host ""
Write-Host "To stop all services, run: .\local-stop.ps1" -ForegroundColor Yellow
Write-Host ""
Write-Host "Each service is running in its own window - you can monitor the logs there." -ForegroundColor Gray
Write-Host ""
