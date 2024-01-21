# Maven build container 

FROM maven:3.8.5-openjdk-11-slim AS BUILD
COPY pom.xml /tmp/
COPY src /tmp/src/
WORKDIR /tmp/
RUN mvn package


FROM openjdk:11-jdk
COPY --from=BUILD /tmp/target/rak-0.0.1-SNAPSHOT.jar /data/rak-0.0.1-SNAPSHOT.jar
CMD ["java", "-jar", "/data/rak-0.0.1-SNAPSHOT.jar"]
EXPOSE 8080
