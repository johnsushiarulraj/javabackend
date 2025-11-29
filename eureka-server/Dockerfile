# Multi-stage build for Eureka Server

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
RUN mvn dependency:go-offline -pl eureka-server

# Copy source and build
COPY eureka-server/src eureka-server/src
RUN mvn clean package -pl eureka-server -am -DskipTests

# Stage 2: Create the runtime image
FROM eclipse-temurin:23-jre-alpine
WORKDIR /app

# Copy the JAR from build stage
COPY --from=build /app/eureka-server/target/eureka-server-*.jar app.jar

# Expose Eureka port
EXPOSE 8761

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
