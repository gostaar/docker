FROM mariadb:10.1
COPY schema.sql /schema.sql

FROM openjdk:8-alpine
COPY *.jar /app.jar
COPY application.properties /config/application.properties
EXPOSE 8080
ENTRYPOINT java -jar app.jar -Dspring.config.location=/config

FROM python:3-slim-stretch
RUN apt-get update && apt-get install -y cron
ENV PYTHONIOENCODING=utf-8
RUN echo "* * * * * root /usr/local/bin/python /main.py" > /etc/cron.d/backend
COPY config.json /config.json
COPY main.py /main.py
ENTRYPOINT /usr/sbin/cron -f