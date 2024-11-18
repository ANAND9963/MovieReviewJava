# Stage 1: Build the application
FROM maven:3.9.4-eclipse-temurin-21 AS build

WORKDIR /app

# Copy the pom.xml file to download dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline

# Copy the rest of the application source code
COPY src ./src

# Build the application without running tests
RUN mvn clean package -DskipTests

# Stage 2: Create a lightweight runtime image
FROM openjdk:21-slim


WORKDIR /app

# Copy the built JAR from the build stage
COPY --from=build /app/target/movies-0.0.1-SNAPSHOT.jar ./movies-0.0.1-SNAPSHOT.jar

# Expose port 8080 for the application
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["java", "-jar", "/app/movies-0.0.1-SNAPSHOT.jar"]
