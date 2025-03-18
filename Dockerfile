FROM openjdk:17-ea-slim-buster

WORKDIR /app

COPY ./build/libs/*.jar /app/

# 포트 설정
EXPOSE 8080

# JAR 실행
ENTRYPOINT ["java", "-jar", "/app/myapp-0.0.1-SNAPSHOT.jar"]