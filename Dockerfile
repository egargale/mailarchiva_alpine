FROM anapsix/alpine-java

MAINTAINER Enrico Gargale <enrico.gargale@gmail.com>

ENV JAVA_VERSION=7  \
    MALLOC_ARENA_MAX=2 \
    MALLOC_MMAP_THRESHOLD_=131072 \
    MALLOC_TRIM_THRESHOLD_=131072 \
    MALLOC_TOP_PAD_=131072 \
    MALLOC_MMAP_MAX_=65536 \
    LC_ALL=en_US.UTF-8 \
    C_CTYPE="en_US.UTF-8" \
    JAVA_UPDATE=80 \
    JAVA_BUILD=15 \
    JAVA_HOME="/opt/jdk/jre" \
    LANG=C.UTF-8 \
    GLIBC_VERSION=2.23-r3 \
    CATALINA_HOME=/opt/apache-tomcat-7.0.100 \
    PATH=$CATALINA_HOME/bin:$PATH

RUN apk upgrade --update && \
    apk add curl apr && \
    mkdir -p /opt && \
    mkdir -p /data && \
    curl -jksSL -o /tmp/tomcat.tar.gz https://mirror.ibcp.fr/pub/apache/tomcat/tomcat-7/v7.0.100/bin/apache-tomcat-7.0.100.tar.gz && \
    gunzip /tmp/tomcat.tar.gz && \
    tar -C /opt -xf /tmp/tomcat.tar && \
    rm -rf $CATALINA_HOME/webapps/* && \
    curl -o $CATALINA_HOME/webapps/mailarchiva.war https://d3tlkwz0u312l3.cloudfront.net/download?id=2251 && \
    mkdir -p /var/opt/mailarchiva/tomcat/ROOT && \
    unzip $CATALINA_HOME/webapps/mailarchiva.war -d /var/opt/mailarchiva/tomcat/ROOT && \
    rm -rf /tmp/* /var/cache/apk/*

COPY ./server.xml $CATALINA_HOME/conf/server.xml 

# Define working directory.
EXPOSE 80

WORKDIR $CATALINA_HOME

#Set default argument for entry point
CMD ["run"] 

#Defining what our container runs
ENTRYPOINT ["/opt/apache-tomcat-7.0.100/bin/catalina.sh"]
