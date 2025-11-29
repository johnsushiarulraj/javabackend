Set-Location "C:\code\projects\javabackend"
$Host.UI.RawUI.WindowTitle = "Hello Service :8081"
Write-Host "=== Hello Service (Port 8081) ===" -ForegroundColor Cyan
Write-Host "Waiting for Eureka and Config..." -ForegroundColor Yellow
Start-Sleep -Seconds 35
Write-Host ""
mvn spring-boot:run -pl hello-service
