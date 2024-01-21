# Stage 1: Build the application
FROM maven:3.8.1-openjdk-11 AS BUILD
WORKDIR /tmp
COPY pom.xml .
COPY src ./src
RUN mvn package

# Stage 2: Create a minimal JRE image
FROM openjdk:11-jre-slim
WORKDIR /tmp
COPY --from=BUILD /tmp/target/rak-0.0.1-SNAPSHOT.jar /data/rak-0.0.1-SNAPSHOT.jar
EXPOSE 8080
CMD ["java", "-jar", "/data/rak-0.0.1-SNAPSHOT.jar"]
