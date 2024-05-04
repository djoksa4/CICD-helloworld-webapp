FROM tomcat:9-jdk11-openjdk-slim

# Remove existing ROOT webapp
RUN rm -rf /usr/local/tomcat/webapps/ROOT/*

# Copy the generated .war file into the webapps directory of Tomcat
COPY ./target/*.war /usr/local/tomcat/webapps/ROOT.war

# Expose port 8080 to access the Tomcat server
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]