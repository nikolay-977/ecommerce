FROM openjdk:17-jdk-slim
COPY target/*.jar /review-service.jar
ENTRYPOINT ["java", "-jar", "/review-service.jar"]