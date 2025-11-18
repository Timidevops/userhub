FROM tomcat:9.0.74-jdk17
RUN rm -rf /usr/local/tomcat/webapps/ROOT
COPY target/devops-userportal.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
