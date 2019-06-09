FROM openjdk:8-jre-alpine 

ENV HZ_VERSION 3.9.1
ENV HZ_HOME /opt/hazelcast
ENV JAVA_OPTS="-Dhazelcast.config=${HZ_HOME}/bin/hazelcast.xml -Xmx1g -Xms1g -Duser.timezone=GMT+8"

ADD entrypoint.sh /entrypoint.sh
ADD server.sh $HZ_HOME/bin/server.sh
ADD hazelcast-${HZ_VERSION}.tar.gz /opt

RUN chmod +x $HZ_HOME/bin/*.sh /entrypoint.sh 

EXPOSE 5701

WORKDIR $HZ_HOME

ENTRYPOINT ["/entrypoint.sh"]

CMD [ "sh", "./bin/server.sh"]
