FROM openjdk:17-jdk-slim
COPY target/*.jar /order-status-service.jar
ENTRYPOINT ["java", "-jar", "/order-status-service.jar"]