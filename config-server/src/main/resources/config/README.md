# Config Server Configuration Files

This directory contains centralized configuration for all microservices.

## File Structure

```
config/
├── application.yml              # Common config for ALL services
├── eureka-server.yml           # Eureka Server specific config
├── config-server.yml           # Config Server specific config
├── gateway-server.yml          # Gateway Server specific config
└── hello-service.yml           # Hello Service specific config
```

## Configuration Priority (Highest to Lowest)

1. `{service-name}.yml` (e.g., hello-service.yml)
2. `application.yml` (common for all)

## How to Access Configurations

### Default Profile
```
http://localhost:8888/hello-service/default
http://localhost:8888/gateway-server/default
http://localhost:8888/config-server/default
http://localhost:8888/eureka-server/default
```

### As YAML
```
http://localhost:8888/hello-service-default.yml
http://localhost:8888/gateway-server-default.yml
```

### As Properties
```
http://localhost:8888/hello-service-default.properties
http://localhost:8888/gateway-server-default.properties
```

### As JSON
```
http://localhost:8888/hello-service/default
http://localhost:8888/gateway-server/default
```

## Environment Variables

- `EUREKA_URL` - Eureka Server URL (default: http://localhost:8761/eureka/)
- `ENVIRONMENT` - Current environment (default: local)

## What's Configured

### application.yml (Common)
- Eureka client configuration
- Actuator endpoints (health, info, metrics, env, configprops)
- Common logging patterns

### hello-service.yml
- Server port: 8081
- Custom hello message and version
- Thymeleaf settings

### gateway-server.yml
- Server port: 8080
- Routes configuration for all services
- Gateway timeout settings

### config-server.yml
- Server port: 8888
- Config server native mode
- Refresh enabled

### eureka-server.yml
- Server port: 8761
- Eureka server settings
- Self-preservation and eviction settings
