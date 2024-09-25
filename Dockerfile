FROM eclipse-temurin:11-jdk-jammy as builder
WORKDIR /opt/app


COPY .mvn/ .mvn
COPY mvnw pom.xml ./
RUN chmod +x mvnw

RUN ./mvnw dependency:go-offline
COPY ./src ./src
RUN ./mvnw clean install -DskipTests

FROM eclipse-temurin:11-jre-jammy
WORKDIR /opt/app
EXPOSE 8080

COPY --from=builder /opt/app/target/*.jar /opt/app/app.jar  # Renamed to app.jar for clarity
ENTRYPOINT ["java", "-Dspring.profiles.active=prod", "-jar", "/opt/app/app.jar"]
