#!/bin/bash
set -e
docker pull saieerla/mavan-app-qa:maven-web-application
docker run -d -p 8080:8080 --name mavenwebapp  saieerla/mavan-app-qa:maven-web-application
