Set-Location "C:\code\projects\javabackend"
$Host.UI.RawUI.WindowTitle = "Gateway Server :8080"
Write-Host "=== Gateway Server (Port 8080) ===" -ForegroundColor Cyan
Write-Host "Waiting for all services..." -ForegroundColor Yellow
Start-Sleep -Seconds 50
Write-Host ""
mvn spring-boot:run -pl gateway-server
