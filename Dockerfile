# Step 1: Build stage (Gradle 빌드)
FROM gradle:8.12.1-jdk17 AS build
WORKDIR /app

# Gradle 설정 파일만 먼저 복사하여 캐시 활용
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle settings.gradle ./

# 실행 권한 부여
RUN chmod +x gradlew

# Gradle 캐시를 활용하여 종속성 다운로드
RUN ./gradlew dependencies

# 소스 코드 복사 후 빌드
COPY src src
RUN ./gradlew bootJar


# Step 2: Run stage (실행 환경)
FROM openjdk:17-ea-slim-buster

WORKDIR /app

# 빌드된 JAR 파일 복사 (경로 정확하게 확인)
COPY --from=build /app/build/libs/*.jar /app/

# 포트 설정
EXPOSE 8080

# JAR 실행
ENTRYPOINT ["java", "-jar", "/app/myapp-0.0.1-SNAPSHOT.jar"]