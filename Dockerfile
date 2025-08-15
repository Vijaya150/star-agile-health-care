FROM openjdk:17-jdk-slim

# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Create app directory
RUN mkdir /app

# Download the artifact from Nexus
RUN curl -o /app/app.jar \
    http://100.26.183.71:30081/repository/maven-snapshots/com/project/staragile/medicure/0.0.1-SNAPSHOT/medicure-0.0.1-SNAPSHOT.jar

# Set the entrypoint
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
