# Use Maven image to build the project
FROM maven:3.9.8-eclipse-temurin-17 AS build

# Set working directory
WORKDIR /app

# Copy pom.xml and download dependencies
COPY pom.xml .
RUN mvn dependency:go-offline -B

# Copy the source code
COPY src ./src

# Build the project
RUN mvn clean package -DskipTests

# Use JDK runtime for final image
FROM eclipse-temurin:17-jdk

# Set working directory
WORKDIR /app

# Copy only the jar from build stage
COPY --from=build /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
