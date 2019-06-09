FROM openjdk:8-jre-alpine

ARG kafka_version=2.2.0
ARG scala_version=2.12
ARG glibc_version=2.29-r0
ARG vcs_ref=unspecified
ARG build_date=unspecified

ENV KAFKA_VERSION=$kafka_version \
  SCALA_VERSION=$scala_version \
  KAFKA_HOME=/opt/kafka \
  GLIBC_VERSION=$glibc_version

ENV PATH=${PATH}:${KAFKA_HOME}/bin

COPY start-kafka.sh broker-list.sh create-topics.sh versions.sh /tmp/

RUN wget -O /tmp/waitforit https://github.com/maxcnunes/waitforit/releases/download/v2.4.1/waitforit-linux_amd64 \
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
  && apk add --no-cache bash \
  && chmod a+x /tmp/*.sh /tmp/waitforit \
  && mv /tmp/start-kafka.sh /tmp/broker-list.sh /tmp/create-topics.sh /tmp/versions.sh /tmp/waitforit /usr/bin \
  && FILENAME="kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz" \
  && wget https://www.apache.org/dist/kafka/${KAFKA_VERSION}/${FILENAME} -O /tmp/${FILENAME} \
  && tar xfz /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz -C /opt \
  && rm /tmp/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz \
  && ln -s /opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} \
  && sed -i -e '/^listeners=/d' "$KAFKA_HOME/config/server.properties" \ 
  && rm -rf /tmp/* \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && apk add --no-cache --allow-untrusted glibc-${GLIBC_VERSION}.apk \
  && rm glibc-${GLIBC_VERSION}.apk

VOLUME ["/kafka"]

# Use "exec" form so that it runs as PID 1 (useful for graceful shutdown)
CMD ["start-kafka.sh"]
