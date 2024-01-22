# Maven build container..

FROM maven:3.8.5-openjdk-17-slim AS BUILD
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn package

#pull base image
FROM eclipse-temurin:17
#copy hello world to docker image from builder image
COPY --from=BUILD /tmp/target/rak-0.0.1-SNAPSHOT.jar /data/rak-0.0.1-SNAPSHOT.jar
#default command
CMD ["java", "-jar", "/data/rak-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080
