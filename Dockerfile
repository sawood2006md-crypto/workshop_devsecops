# ---- Hardened Dockerfile for workshop-app ----

# 1. Small, maintained base image: Java 21 *runtime only* (JRE) on Alpine Linux
FROM eclipse-temurin:21-jre-alpine

# 2. Create an unprivileged system user and group called "app"
RUN addgroup -S app && adduser -S -G app app

WORKDIR /app

# 3. Copy the jar and make "app" its owner (no chmod 777!)
COPY --chown=app:app target/workshop-app.jar app.jar

# 4. Drop root privileges — everything below runs as "app"
USER app

EXPOSE 8081

# 5. Let Docker check that the application is really healthy
HEALTHCHECK --interval=30s --timeout=5s --start-period=40s --retries=3 \
  CMD wget -qO- http://localhost:8081/actuator/health || exit 1

ENTRYPOINT ["java", "-jar", "app.jar"]
