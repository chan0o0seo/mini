# Step 1: Build stage (애플리케이션을 빌드할 때 사용할 이미지)
FROM maven:3.8.4-openjdk-11 as build

# 작업 디렉토리 설정
WORKDIR /app

# pom.xml 파일을 먼저 복사하여 의존성 다운로드
COPY pom.xml .
RUN mvn dependency:go-offline -B

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
