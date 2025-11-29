Set-Location "C:\code\projects\javabackend"
$Host.UI.RawUI.WindowTitle = "Eureka Server :8761"
Write-Host "=== Eureka Server (Port 8761) ===" -ForegroundColor Cyan
Write-Host ""
mvn spring-boot:run -pl eureka-server
