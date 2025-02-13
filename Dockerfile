# Etapa de build
FROM eclipse-temurin:23-jdk-alpine AS build

# Instalação do Maven 3.9.9
ENV MAVEN_VERSION=3.9.9
RUN apk add --no-cache curl tar bash \
    && mkdir -p /usr/share/maven /usr/share/maven/ref \
    && curl -fsSL -o /tmp/apache-maven.tar.gz https://archive.apache.org/dist/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
    && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
    && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

COPY . .
RUN mvn clean package -DskipTests

# Etapa de pacote
FROM eclipse-temurin:23-jdk-alpine
COPY --from=build /target/*.jar app.jar
ENTRYPOINT ["java", "-jar", "app.jar"]