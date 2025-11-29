# JavaBackend Microservices Deployment Guide

This guide explains how to run your Spring Cloud microservices architecture with Eureka Server, Config Server, Gateway Server, and Hello Service, all accessible via javabackend.com through Cloudflare Tunnel.

## Architecture Overview

This is a complete microservices architecture using Spring Cloud:

- **Eureka Server** (Port 8761) - Service Discovery and Registration
- **Config Server** (Port 8888) - Centralized Configuration Management
- **Gateway Server** (Port 8080) - API Gateway and Routing
- **Hello Service** (Port 8081) - Sample Microservice
- **Cloudflare Tunnel** - Secure public access via javabackend.com

All services are containerized with Docker and orchestrated using Docker Compose.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)
- Maven (for building JARs)
- Your domain (javabackend.com) configured in Cloudflare with DNS routes

## Quick Start

### Start All Microservices

```powershell
.\start.ps1
```

This script will:
1. Stop any running containers
2. Build all JARs with Maven (`mvn clean package`)
3. Build Docker images for all services
4. Start containers in the correct order:
   - Eureka Server first (service discovery)
   - Config Server second (configuration)
   - Hello Service third (microservice)
   - Gateway Server fourth (API gateway)
   - Cloudflare Tunnel last (public access)

**Startup time:** 2-3 minutes for all services to be healthy and registered.

### Stop All Microservices

```powershell
.\stop.ps1
```

This script will stop and remove all containers cleanly.

## Accessing the Services

Once started, you can access:

### Internal Services (Development)
- **Eureka Dashboard:** http://localhost:8761
- **Config Server:** http://localhost:8888
- **Hello Service:** http://localhost:8081
- **Gateway Server:** http://localhost:8080

### Via API Gateway
- **Gateway:** http://localhost:8080/hello
  - Routes to Hello Service through the gateway

### Public Access
- **Public URL:** https://javabackend.com/hello
  - Accessed via Cloudflare Tunnel → Gateway → Hello Service

## Service Descriptions

### 1. Eureka Server
Service discovery server where all microservices register themselves.

- **Port:** 8761
- **Dashboard:** http://localhost:8761
- **Purpose:** Service registration and discovery
- **Dependencies:** None (starts first)

### 2. Config Server
Centralized configuration management for all microservices.

- **Port:** 8888
- **Purpose:** Manage configurations across environments
- **Dependencies:** Eureka Server
- **Configuration:** Uses native file system (`src/main/resources/config`)

### 3. Hello Service
Sample microservice that serves the Hello World page.

- **Port:** 8081
- **Purpose:** Example microservice with Thymeleaf frontend
- **Dependencies:** Eureka Server, Config Server
- **Features:**
  - Spring Boot web application
  - Thymeleaf templates
  - Registers with Eureka

### 4. Gateway Server
API Gateway that routes requests to microservices.

- **Port:** 8080
- **Purpose:** Single entry point for all microservices
- **Dependencies:** All other services
- **Features:**
  - Spring Cloud Gateway
  - Load balancing via Eureka
  - Route: `/hello/**` → hello-service

### 5. Cloudflare Tunnel
Secure tunnel to expose gateway to the internet.

- **Purpose:** Public access without opening ports
- **Configuration:** Routes javabackend.com to gateway-server:8080
- **Dependencies:** Gateway Server

## Docker Compose Configuration

### Service Startup Order

Docker Compose manages the startup order using health checks:

1. **Eureka Server** starts first
2. **Config Server** waits for Eureka to be healthy
3. **Hello Service** waits for Eureka and Config Server
4. **Gateway Server** waits for all backend services
5. **Cloudflare Tunnel** waits for Gateway

### Health Checks

All services have health checks using Spring Boot Actuator:
```yaml
healthcheck:
  test: ["CMD", "wget", "--quiet", "--tries=1", "--spider", "http://localhost:PORT/actuator/health"]
  interval: 10s
  timeout: 5s
  retries: 10
  start_period: 40s
```

## Viewing Logs

### All Services
```powershell
docker-compose logs -f
```

### Specific Service
```powershell
docker-compose logs -f eureka-server
docker-compose logs -f config-server
docker-compose logs -f hello-service
docker-compose logs -f gateway-server
docker-compose logs -f cloudflared
```

### Service Status
```powershell
docker-compose ps
```

## Docker Compose Commands

### Basic Commands

```bash
# Start all services
docker-compose up -d

# Start and rebuild
docker-compose up -d --build

# Stop all services
docker-compose stop

# Stop and remove containers
docker-compose down

# View logs
docker-compose logs -f [service-name]

# Check service status
docker-compose ps

# Restart a service
docker-compose restart [service-name]
```

### Individual Service Management

```bash
# Restart specific service
docker-compose restart hello-service

# Rebuild specific service
docker-compose up -d --build hello-service

# Scale a service (multiple instances)
docker-compose up -d --scale hello-service=3
```

## Project Structure

```
javabackend/
├── pom.xml                                   # Parent POM (multi-module)
├── docker-compose.yml                        # Orchestrates all containers
├── start.ps1                                 # Automated startup script
├── stop.ps1                                  # Automated shutdown script
├── cloudflare-tunnel-config.yml             # Cloudflare tunnel config
├── deploy.md                                # This file
│
├── eureka-server/
│   ├── pom.xml
│   ├── Dockerfile
│   └── src/main/
│       ├── java/org/johnprasad/eureka/
│       │   └── EurekaServerApplication.java
│       └── resources/
│           └── application.yml
│
├── config-server/
│   ├── pom.xml
│   ├── Dockerfile
│   └── src/main/
│       ├── java/org/johnprasad/config/
│       │   └── ConfigServerApplication.java
│       └── resources/
│           └── application.yml
│
├── gateway-server/
│   ├── pom.xml
│   ├── Dockerfile
│   └── src/main/
│       ├── java/org/johnprasad/gateway/
│       │   └── GatewayServerApplication.java
│       └── resources/
│           └── application.yml
│
└── hello-service/
    ├── pom.xml
    ├── Dockerfile
    └── src/main/
        ├── java/org/johnprasad/
        │   ├── Main.java
        │   └── HelloController.java
        └── resources/
            ├── application.yml
            └── templates/
                └── index.html
```

## Building Individual Services

### Build All Services
```bash
mvn clean package
```

### Build Specific Service
```bash
mvn clean package -pl eureka-server -am
mvn clean package -pl config-server -am
mvn clean package -pl gateway-server -am
mvn clean package -pl hello-service -am
```

## Troubleshooting

### Services Won't Start

1. **Check Docker Desktop** is running
2. **View logs** for specific service:
   ```bash
   docker-compose logs [service-name]
   ```
3. **Check Eureka Dashboard** at http://localhost:8761
   - All services should be registered
4. **Verify health checks**:
   ```bash
   docker-compose ps
   ```

### Gateway Can't Find Services

1. Check Eureka Dashboard - services must be registered
2. Wait 30-60 seconds after startup for registration
3. Check gateway logs:
   ```bash
   docker-compose logs -f gateway-server
   ```

### Service Registration Issues

1. Verify Eureka Server is running and healthy
2. Check service application.yml for correct Eureka URL:
   ```yaml
   eureka:
     client:
       service-url:
         defaultZone: http://eureka-server:8761/eureka/
   ```
3. Ensure services are on the same Docker network

### Cloudflare Tunnel Issues

1. Check credentials file path in docker-compose.yml
2. Verify tunnel is running:
   ```bash
   docker-compose logs cloudflared
   ```
3. Check Cloudflare dashboard for tunnel status

### Port Conflicts

If ports are already in use:
1. Stop conflicting services
2. Or modify ports in docker-compose.yml:
   ```yaml
   ports:
     - "NEW_PORT:INTERNAL_PORT"
   ```

### Build Failures

1. Clean Maven cache:
   ```bash
   mvn clean
   ```
2. Update dependencies:
   ```bash
   mvn dependency:purge-local-repository
   ```
3. Rebuild from root:
   ```bash
   mvn clean install -DskipTests
   ```

## Adding New Microservices

To add a new microservice:

1. Create new module directory
2. Create pom.xml with parent reference:
   ```xml
   <parent>
       <groupId>org.johnprasad</groupId>
       <artifactId>javabackend-parent</artifactId>
       <version>1.0-SNAPSHOT</version>
   </parent>
   ```
3. Add Eureka Client dependency
4. Create Dockerfile
5. Add service to docker-compose.yml
6. Add module to parent pom.xml
7. Configure application.yml with Eureka settings

## Production Considerations

For production deployment:

1. **Environment Variables**: Externalize all configurations
2. **Secrets Management**: Don't commit credentials
3. **Resource Limits**: Add CPU/memory limits in docker-compose.yml
4. **Logging**: Configure centralized logging (ELK stack)
5. **Monitoring**: Add Spring Boot Admin or Prometheus
6. **High Availability**: Run multiple instances of services
7. **Load Balancing**: Use Ribbon or Spring Cloud LoadBalancer
8. **Circuit Breakers**: Implement Resilience4j
9. **Distributed Tracing**: Add Sleuth and Zipkin
10. **API Documentation**: Use Swagger/OpenAPI

## Notes

- Services start in dependency order managed by Docker Compose
- Health checks ensure services are ready before dependents start
- All services communicate over the `microservices-network` Docker network
- Eureka handles service discovery - no hardcoded URLs needed
- Gateway provides a single entry point for all microservices
- Cloudflare Tunnel provides secure public access without port forwarding

## Useful URLs

After starting all services:

- **Eureka:** http://localhost:8761 (view all registered services)
- **Config:** http://localhost:8888 (configuration endpoint)
- **Hello Service:** http://localhost:8081 (direct access)
- **Gateway:** http://localhost:8080/hello (via gateway)
- **Public:** https://javabackend.com/hello (via Cloudflare)
