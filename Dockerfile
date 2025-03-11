# Step 1: Build stage (애플리케이션을 빌드할 때 사용할 이미지)
FROM gradle:7.4-jdk17 as build

# 작업 디렉토리 설정
WORKDIR /app

# Gradle Wrapper 및 설정 파일 복사
COPY gradlew gradlew
COPY gradle gradle
COPY build.gradle settings.gradle ./
RUN chmod +x gradlew
# Gradle 의존성 다운로드
RUN ./gradlew build --no-daemon

# 소스 코드를 복사하고 빌드
COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Run stage (실제로 애플리케이션을 실행할 환경)
FROM openjdk:17-ea-slim-buster

# 애플리케이션 작업 디렉토리 설정
WORKDIR /app

# 빌드 단계에서 생성된 JAR 파일 복사
COPY --from=build /app/target/*.jar app.jar

# 컨테이너가 8080 포트를 사용할 것임을 지정
EXPOSE 8080

# 애플리케이션 실행
ENTRYPOINT ["java", "-jar", "app.jar"]
