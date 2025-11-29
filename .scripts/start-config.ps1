Set-Location "C:\code\projects\javabackend"
$Host.UI.RawUI.WindowTitle = "Config Server :8888"
Write-Host "=== Config Server (Port 8888) ===" -ForegroundColor Cyan
Write-Host "Waiting for Eureka..." -ForegroundColor Yellow
Start-Sleep -Seconds 20
Write-Host ""
mvn spring-boot:run -pl config-server
