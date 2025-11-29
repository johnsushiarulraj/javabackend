# Multi-stage build for Hello Service

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
RUN mvn dependency:go-offline -pl hello-service

# Copy source and build
COPY hello-service/src hello-service/src
RUN mvn clean package -pl hello-service -am -DskipTests

# Stage 2: Create the runtime image
FROM eclipse-temurin:23-jre-alpine
WORKDIR /app

# Copy the JAR from build stage
COPY --from=build /app/hello-service/target/hello-service-*.jar app.jar

# Expose port 8081
EXPOSE 8081

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
