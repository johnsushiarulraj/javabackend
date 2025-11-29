# JavaBackend.com Deployment Guide

This guide explains how to run your Spring Boot application and configure the Cloudflare tunnel to make it accessible via javabackend.com.

## Prerequisites

- Docker Desktop installed and running
- Docker Compose (included with Docker Desktop)
- Maven (for building the JAR)
- Your domain (javabackend.com) configured in Cloudflare with DNS routes

## Quick Start (Automated Docker Compose Scripts)

The easiest way to run the application is using the provided PowerShell scripts with Docker Compose. Both the Spring Boot application and Cloudflare tunnel run as Docker containers.

### Start Everything

```powershell
.\start.ps1
```

This script will:
1. Stop any running containers
2. Build the JAR with Maven (`mvn clean package`)
3. Build Docker images and start both containers using docker-compose:
   - `javabackend-container` (Spring Boot app on port 8080)
   - `cloudflared-tunnel` (Cloudflare tunnel)
4. Wait for the server to be ready

After running, your application will be available at:
- Local: `http://localhost:8080`
- Public: `https://javabackend.com`

### Stop Everything

```powershell
.\stop.ps1
```

This script will:
1. Stop and remove all containers using docker-compose
2. Clean up any fallback processes on port 8080

### View Logs

To view real-time logs from both containers:
```powershell
docker-compose logs -f
```

To view logs from a specific container:
```powershell
docker-compose logs -f javabackend
docker-compose logs -f cloudflared
```

### Notes About the Docker Compose Setup

- Both containers run in detached mode (background)
- The tunnel container automatically waits for the app to be healthy before starting
- Containers communicate over a dedicated Docker network
- The start script automatically checks if the server started successfully
- Always use `stop.ps1` to properly shut down and clean up containers
- Each run creates fresh containers with the latest build

## Manual Deployment (Alternative)

If you prefer to run the services manually or need more control:

## Running the Spring Boot Server

### Option 1: Using Maven

1. Open a terminal in the project directory
2. Run the following command:
   ```bash
   mvn spring-boot:run
   ```

3. The server will start on `http://localhost:8080`
4. You should see output indicating the application has started successfully

### Option 2: Building and Running the JAR

1. Build the application:
   ```bash
   mvn clean package
   ```

2. Run the generated JAR:
   ```bash
   java -jar target/javabackend-1.0-SNAPSHOT.jar
   ```

3. The server will start on `http://localhost:8080`

### Option 3: Using Docker (Recommended)

1. Build the JAR first:
   ```bash
   mvn clean package
   ```

2. Build the Docker image:
   ```bash
   docker build -t 1johnsushil/javabackend:latest .
   ```

3. Run the Docker container:
   ```bash
   docker run -d --name javabackend-container -p 8080:8080 1johnsushil/javabackend:latest
   ```

4. The server will start on `http://localhost:8080`

5. To stop and remove the container:
   ```bash
   docker stop javabackend-container
   docker rm javabackend-container
   ```

6. To view container logs:
   ```bash
   docker logs javabackend-container
   ```

7. To view running containers:
   ```bash
   docker ps
   ```

### Verify the Server is Running

Open a browser and navigate to:
- `http://localhost:8080`

You should see the "Hello World from JavaBackend.com!" page.

## Docker Compose Commands Reference

### Basic Commands

```bash
# Start all services (builds if needed)
docker-compose up -d

# Start and rebuild all services
docker-compose up -d --build

# Stop all services
docker-compose stop

# Stop and remove all containers
docker-compose down

# View logs from all services
docker-compose logs -f

# View logs from specific service
docker-compose logs -f javabackend
docker-compose logs -f cloudflared

# View running containers
docker-compose ps

# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart javabackend
```

### Advanced Commands

```bash
# Build images without starting
docker-compose build

# Remove stopped containers
docker-compose rm

# View resource usage
docker-compose top

# Execute command in running container
docker-compose exec javabackend sh

# Pull latest cloudflared image
docker-compose pull cloudflared
```

## Docker Commands Reference (Individual Containers)

```bash
# Build the Docker image
docker build -t 1johnsushil/javabackend:latest .

# Run the container
docker run -d --name javabackend-container -p 8080:8080 1johnsushil/javabackend:latest

# Stop the container
docker stop javabackend-container

# Remove the container
docker rm javabackend-container

# View logs
docker logs javabackend-container

# View running containers
docker ps

# View all containers (including stopped)
docker ps -a

# Push to Docker Hub (optional)
docker push 1johnsushil/javabackend:latest
```

## Setting Up Cloudflare Tunnel

### Step 1: Create the Tunnel (One-time setup)

If you haven't created the tunnel yet:

```bash
cloudflared tunnel create javabackend-tunnel
```

This will:
- Create a tunnel named `javabackend-tunnel`
- Generate a credentials file (usually in `C:\Users\YOUR_USERNAME\.cloudflared\`)
- Display the tunnel ID

### Step 2: Update the Configuration File

1. Open `cloudflare-tunnel-config.yml` in this directory
2. Update the `credentials-file` path with your actual:
   - Username
   - Tunnel ID (from the credentials file name)

Example:
```yaml
credentials-file: C:\Users\JohnDoe\.cloudflared\12345678-1234-1234-1234-123456789abc.json
```

### Step 3: Configure DNS (One-time setup)

Create DNS records pointing to your tunnel:

```bash
cloudflared tunnel route dns javabackend-tunnel javabackend.com
cloudflared tunnel route dns javabackend-tunnel www.javabackend.com
```

This creates CNAME records in Cloudflare pointing your domain to the tunnel.

## Running the Cloudflare Tunnel

### Start the tunnel with the configuration file:

```bash
cloudflared tunnel --config cloudflare-tunnel-config.yml run javabackend-tunnel
```

Or, if you prefer to run it from anywhere, use the full path:

```bash
cloudflared tunnel --config C:\code\projects\javabackend\cloudflare-tunnel-config.yml run javabackend-tunnel
```

### Verify the Tunnel is Running

1. The terminal should show:
   - Connection established
   - Tunnel running
   - Registered routes

2. Open a browser and navigate to:
   - `https://javabackend.com`
   - `https://www.javabackend.com`

You should see your Hello World page served through Cloudflare!

## Complete Deployment Process

To deploy your application and make it accessible:

### Terminal 1 - Run the Spring Boot Server:
```bash
cd C:\code\projects\javabackend
mvn spring-boot:run
```

Wait for the server to start (you'll see "Started Main in X seconds")

### Terminal 2 - Run the Cloudflare Tunnel:
```bash
cd C:\code\projects\javabackend
cloudflared tunnel --config cloudflare-tunnel-config.yml run javabackend-tunnel
```

Wait for the tunnel to connect

### Access Your Site:
- Locally: `http://localhost:8080`
- Publicly: `https://javabackend.com`

## Running as a Service (Optional)

### Windows Service (Cloudflare Tunnel)

To run the tunnel as a background service:

```bash
cloudflared service install
```

Then start the service from Windows Services or:
```bash
cloudflared service start
```

### Spring Boot as a Windows Service

You can configure Spring Boot to run as a Windows service using tools like:
- WinSW (Windows Service Wrapper)
- NSSM (Non-Sucking Service Manager)

## Troubleshooting

### Docker Container Won't Start
- Ensure Docker Desktop is running
- Check if port 8080 is already in use: `docker ps`
- View container logs: `docker logs javabackend-container`
- Remove any existing containers: `docker rm -f javabackend-container`
- Check Docker version: `docker --version`

### Server Won't Start (Non-Docker)
- Check if port 8080 is already in use
- Verify Java is installed: `java -version`
- Check Maven is installed: `mvn -version`

### Tunnel Won't Connect
- Verify cloudflared is installed: `cloudflared --version`
- Check the credentials file path in `cloudflare-tunnel-config.yml`
- Ensure you're logged in: `cloudflared tunnel login`
- Verify the tunnel exists: `cloudflared tunnel list`

### Domain Not Accessible
- Check DNS records in Cloudflare dashboard
- Wait a few minutes for DNS propagation
- Verify both server and tunnel are running
- Check Cloudflare dashboard for tunnel status

## Stopping the Services

### Stop the Spring Boot Server
- Press `Ctrl+C` in the terminal running Maven

### Stop the Cloudflare Tunnel
- Press `Ctrl+C` in the terminal running cloudflared

## Useful Commands

```bash
# List all tunnels
cloudflared tunnel list

# Delete a tunnel (if needed)
cloudflared tunnel delete javabackend-tunnel

# Check tunnel info
cloudflared tunnel info javabackend-tunnel

# Test the configuration
cloudflared tunnel ingress validate --config cloudflare-tunnel-config.yml

# Test which rule matches a URL
cloudflared tunnel ingress rule https://javabackend.com --config cloudflare-tunnel-config.yml
```

## Project Structure

```
javabackend/
├── src/
│   └── main/
│       ├── java/org/johnprasad/
│       │   ├── Main.java                    # Spring Boot application entry point
│       │   └── HelloController.java         # Controller for the web page
│       └── resources/
│           ├── templates/
│           │   └── index.html               # Hello World HTML page
│           └── application.properties       # Spring Boot configuration
├── pom.xml                                  # Maven dependencies
├── Dockerfile                               # Docker image configuration for Spring Boot app
├── docker-compose.yml                       # Orchestrates both containers
├── .dockerignore                            # Docker ignore file
├── start.ps1                                # Automated start script (Docker Compose)
├── stop.ps1                                 # Automated stop script (Docker Compose)
├── cloudflare-tunnel-config.yml            # Cloudflare tunnel configuration
└── deploy.md                               # This file
```

## Notes

- Docker Compose orchestrates both the Spring Boot app and Cloudflare tunnel as containers
- The tunnel container automatically waits for the app to be healthy before connecting
- Both containers run in the background (detached mode)
- Containers communicate over a private Docker network named `javabackend-network`
- Use `stop.ps1` to properly clean up all containers
- Each fresh start builds new containers with the latest code changes
- The Cloudflare credentials file is mounted read-only into the tunnel container
- Health checks ensure the app is ready before the tunnel starts routing traffic
