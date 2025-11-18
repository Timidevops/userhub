# DevOps User Portal (Fixed - v2)

Includes servlet sources and proper web.xml.

Build:
  mvn clean package

Docker:
  docker build -t userportal .
  docker run -p 8080:8080     -e DB_URL='jdbc:mysql://mysql:3306/userdb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC'     -e DB_USER='timi' -e DB_PASS='rootpass'     userportal


  
