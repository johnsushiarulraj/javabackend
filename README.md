# JavaBackend - Spring Cloud Microservices

A complete microservices architecture using Spring Cloud, Docker, and Cloudflare Tunnel.

## Architecture

- **Eureka Server** - Service Discovery (Port 8761)
- **Config Server** - Centralized Configuration (Port 8888)
- **Gateway Server** - API Gateway (Port 8080)
- **Hello Service** - Sample Microservice (Port 8081)
- **Cloudflare Tunnel** - Public Access via javabackend.com

## Quick Start

### Start All Services
```powershell
.\start.ps1
```

### Stop All Services
```powershell
.\stop.ps1
```

### Build Only
```bash
mvn clean package
```

## Access Points

- **Eureka Dashboard:** http://localhost:8761
- **Config Server:** http://localhost:8888
- **Gateway:** http://localhost:8080/hello
- **Hello Service:** http://localhost:8081
- **Public:** https://javabackend.com/hello

## Project Structure

```
javabackend/
├── eureka-server/      # Service Discovery
├── config-server/      # Configuration Management
├── gateway-server/     # API Gateway
├── hello-service/      # Sample Microservice
├── docker-compose.yml  # Container Orchestration
├── start.ps1           # Start Script
├── stop.ps1            # Stop Script
└── deploy.md           # Full Documentation
```

## Technologies

- Spring Boot 3.2.1
- Spring Cloud 2023.0.0
- Docker & Docker Compose
- Netflix Eureka
- Spring Cloud Gateway
- Spring Cloud Config
- Cloudflare Tunnel

## Documentation

See [deploy.md](deploy.md) for complete deployment guide and troubleshooting.

## Docker Images

All services are built as Docker images:
- `1johnsushil/eureka-server:latest`
- `1johnsushil/config-server:latest`
- `1johnsushil/gateway-server:latest`
- `1johnsushil/hello-service:latest`
