# Step 1: Build stage (Gradle 빌드)
FROM gradle:7.4-jdk17 as build

WORKDIR /app

# Gradle Wrapper 및 설정 파일 복사
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle settings.gradle ./

# 실행 권한 부여
RUN chmod +x gradlew

# 의존성 다운로드
RUN ./gradlew dependencies --no-daemon

# 소스 코드 복사
COPY src src

# JAR 파일 빌드
RUN ./gradlew clean build -x test --no-daemon

# Step 2: Run stage (실행 환경)
FROM openjdk:17-ea-slim-buster

WORKDIR /app

# 빌드된 JAR 파일 복사 (경로 정확하게 수정)
COPY --from=build /app/build/libs/*.jar /app/app.jar

# 포트 설정
EXPOSE 8080

# JAR 실행
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
