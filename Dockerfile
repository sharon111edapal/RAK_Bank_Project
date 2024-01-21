# Maven build container 

#FROM maven:3.8.5-openjdk-11 AS maven_build
FROM adoptopenjdk:17-jdk AS BUILD

COPY pom.xml /tmp/

COPY src /tmp/src/

WORKDIR /tmp/

RUN ./mvnw clean package

#pull base image

FROM adoptopenjdk:11-jre

#copy hello world to docker image from builder image

COPY --from=BUILD /tmp/target/rak-0.0.1-SNAPSHOT.jar /data/rak-0.0.1-SNAPSHOT.jar

#default command
CMD ["java", "-jar", "/data/rak-0.0.1-SNAPSHOT.jar"]

EXPOSE 8080

