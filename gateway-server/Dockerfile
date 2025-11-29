# Multi-stage build for Gateway Server

# Stage 1: Build the application
FROM maven:3.9-eclipse-temurin-23 AS build
WORKDIR /app

# Copy parent pom and all modules
COPY pom.xml .
COPY eureka-server/pom.xml eureka-server/
COPY config-server/pom.xml config-server/
COPY gateway-server/pom.xml gateway-server/
COPY hello-service/pom.xml hello-service/

# Download dependencies
RUN mvn dependency:go-offline -pl gateway-server

# Copy source and build
COPY gateway-server/src gateway-server/src
RUN mvn clean package -pl gateway-server -am -DskipTests

# Stage 2: Create the runtime image
FROM eclipse-temurin:23-jre-alpine
WORKDIR /app

# Copy the JAR from build stage
COPY --from=build /app/gateway-server/target/gateway-server-*.jar app.jar

# Expose Gateway port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
