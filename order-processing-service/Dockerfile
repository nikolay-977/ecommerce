FROM openjdk:17-jdk-slim
COPY target/*.jar /order-processing-service.jar
ENTRYPOINT ["java", "-jar", "/order-processing-service.jar"]