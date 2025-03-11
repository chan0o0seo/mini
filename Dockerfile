# Step 1: Build stage (Gradle 빌드)
FROM gradle:7.4-jdk17 as build

# 작업 디렉토리 설정
WORKDIR /app

# Gradle Wrapper 및 설정 파일 복사
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle settings.gradle ./

# 실행 권한 부여 (Gradle Wrapper 실행을 위해)
RUN chmod +x gradlew

# 의존성 다운로드 및 빌드 (테스트 제외)
RUN ./gradlew build -x test --no-daemon

# 소스 코드 복사
COPY src ./src

# JAR 파일 빌드 (빌드 후 JAR 위치는 build/libs에 저장됨)
RUN ./gradlew build -x test --no-daemon

# Step 2: Run stage (실행 환경 설정)
FROM openjdk:17-ea-slim-buster

# 애플리케이션 작업 디렉토리 설정
WORKDIR /app

# 빌드된 JAR 파일 복사 (디렉토리로 복사)
COPY --from=build /app/build/libs/*.jar /app/app.jar

# 컨테이너가 8080 포트를 사용할 것임을 지정
EXPOSE 8080

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
