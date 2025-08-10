FROM openjdk:17-jdk-slim

RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

RUN mkdir /app && \
    curl -o /app/app.jar \
    http://13.220.201.91:30081/repository/maven-snapshots/com/project/staragile/medicure/0.0.1-SNAPSHOT/medicure-0.0.1-SNAPSHOT.

ENTRYPOINT ["java", "-jar", "/app/app.jar"] can we simplify ths? 
