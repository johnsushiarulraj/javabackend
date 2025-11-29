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

# Wait for services to start
Write-Host "Waiting for microservices to start up..." -ForegroundColor Yellow
Write-Host "This may take a few minutes as services start in order:" -ForegroundColor Gray
Write-Host "  1. Eureka Server (Service Discovery)" -ForegroundColor Gray
Write-Host "  2. Config Server (Configuration)" -ForegroundColor Gray
Write-Host "  3. Hello Service (Microservice)" -ForegroundColor Gray
Write-Host "  4. Gateway Server (API Gateway)" -ForegroundColor Gray
Write-Host "  5. Cloudflare Tunnel" -ForegroundColor Gray
Start-Sleep -Seconds 30

# Check container status
Write-Host ""
Write-Host "Checking container status..." -ForegroundColor Yellow
docker-compose ps

Write-Host ""
Write-Host "=== Startup Complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Service URLs:" -ForegroundColor White
Write-Host "  - Eureka Dashboard:  http://localhost:8761" -ForegroundColor Gray
Write-Host "  - Config Server:     http://localhost:8888" -ForegroundColor Gray
Write-Host "  - Hello Service:     http://localhost:8081" -ForegroundColor Gray
Write-Host "  - Gateway Server:    http://localhost:8080" -ForegroundColor Gray
Write-Host "  - Public URL:        https://javabackend.com" -ForegroundColor Gray
Write-Host ""
Write-Host "Access your application via:" -ForegroundColor White
Write-Host "  - Gateway: http://localhost:8080/hello" -ForegroundColor Cyan
Write-Host "  - Public:  https://javabackend.com/hello" -ForegroundColor Cyan
Write-Host ""
Write-Host "Useful Commands:" -ForegroundColor White
Write-Host "  - View all logs:         docker-compose logs -f" -ForegroundColor Yellow
Write-Host "  - View specific service: docker-compose logs -f [service-name]" -ForegroundColor Yellow
Write-Host "  - Stop all services:     .\stop.ps1" -ForegroundColor Yellow
Write-Host ""
