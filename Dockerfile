FROM anapsix/alpine-java

MAINTAINER Enrico Gargale <enrico.gargale@gmail.com>

ENV JAVA_VERSION=7  \
    JAVA_UPDATE=80 \
    JAVA_BUILD=15 \
    JAVA_HOME="/opt/jdk/jre" \
    LANG=C.UTF-8 \
    GLIBC_VERSION=2.23-r3 \
    CATALINA_HOME=/opt/apache-tomcat-7.0.100 \
    PATH=$CATALINA_HOME/bin:$PATH

COPY ./mailarchiva.war /tmp/mailarchiva.war

RUN apk upgrade --update && \
    apk add curl && \
    mkdir -p /opt && \
    mkdir -p /data && \
    curl -jksSL -o /tmp/tomcat.tar.gz https://mirror.ibcp.fr/pub/apache/tomcat/tomcat-7/v7.0.100/bin/apache-tomcat-7.0.100.tar.gz && \
    gunzip /tmp/tomcat.tar.gz && \
    tar -C /opt -xf /tmp/tomcat.tar && \
    rm -rf $CATALINA_HOME/webapps/* && \
#    wget -O $CATALINA_HOME/webapps/mailarchiva.war https://www.mailarchiva.com/download?id=2246 && \
#    wget -O $CATALINA_HOME/webapps/mailarchiva.war https://d3tlkwz0u312l3.cloudfront.net/download?id=2246 && \
    cp /tmp/mailarchiva.war $CATALINA_HOME/webapps/ && \
    mkdir -p /var/opt/mailarchiva/tomcat/ROOT && \
    unzip $CATALINA_HOME/webapps/mailarchiva.war -d /var/opt/mailarchiva/tomcat/ROOT && \
    sed -i 's@port=\"8080\" protocol\=\"HTTP\/1.1@port=\"80\" protocol\=\"org.apache.coyote.http11.Http11NioProtocol@g' $CATALINA_HOME/conf/server.xml && \
    rm -rf /tmp/* /var/cache/apk/*

# Define working directory.
EXPOSE 80

WORKDIR $CATALINA_HOME

#Set default argument for entry point
CMD ["run"] 

#Defining what our container runs
ENTRYPOINT ["/opt/apache-tomcat-7.0.100/bin/catalina.sh"]
