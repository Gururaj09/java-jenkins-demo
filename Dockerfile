# Stage 1: Runtime Environment
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Copy the built jar file from the Maven target directory
COPY target/java-jenkins-demo-1.0-SNAPSHOT.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]