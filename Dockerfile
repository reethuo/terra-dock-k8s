# Use an official JDK runtime as base
FROM openjdk:17-jdk-slim

# Set workdir
WORKDIR /app

# Copy built jar
COPY target/my-app-1.0.0.jar app.jar

# Expose port
EXPOSE 8082

# Run the jar
ENTRYPOINT ["java", "-jar", "app.jar"]
