# ---------- Build stage ----------
FROM docker.io/library/maven:3.9.9-eclipse-temurin-17 AS build
WORKDIR /app

# 의존성 캐시 활용
COPY pom.xml .
RUN mvn -B dependency:go-offline

# 소스 복사 후 빌드
COPY src ./src
RUN mvn -B clean package -DskipTests


# ---------- Run stage ----------
FROM docker.io/eclipse-temurin:17-jre-alpine
WORKDIR /app

# 빌드된 jar 복사
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","app.jar"]
