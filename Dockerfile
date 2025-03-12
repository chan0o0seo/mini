# Step 1: Build stage (Gradle 빌드)
FROM gradle:7.4-jdk17 AS build

WORKDIR /app

# Gradle Wrapper 및 설정 파일 복사
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle settings.gradle ./

# 실행 권한 부여
RUN chmod +x gradlew

# Gradle 캐시 활용을 위해 먼저 종속성 다운로드
RUN ./gradlew dependencies --no-daemon

# 소스 코드 복사
COPY src src

# JAR 파일 빌드 (테스트 제외)
RUN ./gradlew bootjar

# Step 2: Run stage (실행 환경)
FROM openjdk:17-slim

WORKDIR /app

# 빌드된 JAR 파일 복사 (경로 정확하게 확인)
COPY --from=build /app/build/libs/*.jar /app/

# 포트 설정
EXPOSE 8080

# JAR 실행
ENTRYPOINT ["java", "-jar", "/app/app.jar"]