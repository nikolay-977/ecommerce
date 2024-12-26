FROM openjdk:17-jdk-slim
COPY target/*.jar /payment-service.jar
ENTRYPOINT ["java", "-jar", "/payment-service.jar"]