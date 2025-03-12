FROM openjdk:17-ea-slim-buster As build

WORKDIR /app

# 빌드된 JAR 파일 복사 (경로 정확하게 확인)
COPY /home/ubuntu/actions-runner/_work/mini/mini/build/libs/*.jar /app/

# 포트 설정
EXPOSE 8080

# JAR 실행
ENTRYPOINT ["java", "-jar", "/app/myapp-0.0.1-SNAPSHOT.jar"]