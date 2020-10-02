ARG TOMCAT_VERSION
FROM tomcat:${TOMCAT_VERSION}
MAINTAINER Antonio Anzivino (antonio.anzivino@csttech.it)
ARG POSTGRES_JDBC_VERSION="42.2.16"
ARG ORACLE_JDBC_VERSION="19.7.0.0"
ARG LIFECYCLE_LISTENER_VERSION="1.0.1"
ENV MAX_MEMORY_SIZE 4096
ARG CONTEXT_NAME

ADD https://repo1.maven.org/maven2/net/aschemann/tomcat/tomcat-lifecyclelistener/${LIFECYCLE_LISTENER_VERSION}/tomcat-lifecyclelistener-${LIFECYCLE_LISTENER_VERSION}.jar /usr/local/tomcat/lib
ADD https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_JDBC_VERSION}/postgresql-${POSTGRES_JDBC_VERSION}.jar /usr/local/tomcat/lib
ADD https://repo1.maven.org/maven2/com/oracle/database/jdbc/ojdbc8/${ORACLE_JDBC_VERSION}/ojdbc8-${ORACLE_JDBC_VERSION}.jar /usr/local/tomcat/lib
COPY tomcat-${TOMCAT_MAJOR}/server.xml /usr/local/tomcat/conf/

EXPOSE 8009
EXPOSE 8080

ENV PHOENIX_CONFIG_LOCATION /home/tomcat
ENV PHOENIX_LOGS_DIR /mnt/logs
ENV FILE_REPOSITORY_DIR /mnt/fileRepository
ENV CATALINA_OPTS  -Xmx${MAX_MEMORY_SIZE}m -Duser.language=it \
                   -Dfile.encoding=UTF-8 \
                   -Dphoenix.config.location=${PHOENIX_CONFIG_LOCATION} \
                   -Dphoenix.logs.dir=${PHOENIX_LOGS_DIR} \
                   -Dorg.apache.catalina.startup.EXIT_ON_INIT_FAILURE=true

VOLUME /mnt/fileRepository
VOLUME /mnt/phoenix-logs
VOLUME /usr/local/tomcat/logs

HEALTHCHECK --interval=60s --timeout=10s --start-period=120s --retries=3 CMD ["curl -sS http://127.0.0.1:8080/${CONTEXT_NAME} || exit 1"]
