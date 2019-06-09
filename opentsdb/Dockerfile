FROM alpine

ENV TINI_VERSION v0.18.0
ENV HBASE_VERSION 1.3.4
ENV TSDB_VERSION 2.3.1
ENV GNUPLOT_VERSION 5.2.4
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/bin/
ENV ALPINE_PACKAGES "rsyslog bash openjdk8 make wget libgd libpng libjpeg libwebp libjpeg-turbo cairo pango lua"
ENV BUILD_PACKAGES "build-base autoconf automake git python cairo-dev pango-dev gd-dev lua-dev readline-dev libpng-dev libjpeg-turbo-dev libwebp-dev"
ENV HBASE_OPTS "-XX:+UseConcMarkSweepGC -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap"
ENV JVMARGS "-XX:+UseConcMarkSweepGC -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap -enableassertions -enablesystemassertions"

# Tini is a tiny init that helps when a container is being culled to stop things nicely
RUN wget -O /tini https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64 \
  && chmod +x /tini

ENTRYPOINT ["/tini", "--"]

# Add the base packages we'll need
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
  && apk add --no-cache apk-tools \
  && apk add --no-cache ${ALPINE_PACKAGES} --repository http://mirrors.ustc.edu.cn/alpine/v3.0/testing/

WORKDIR /opt

# Add build deps, build opentsdb, and clean up afterwards.
RUN apk add --no-cache --virtual builddeps ${BUILD_PACKAGES} \
  && : Install OpenTSDB and scripts \
  && wget --no-check-certificate -O opentsdb-${TSDB_VERSION}.zip https://github.com/OpenTSDB/opentsdb/archive/v${TSDB_VERSION}.zip \
  && unzip opentsdb-${TSDB_VERSION}.zip \
  && rm opentsdb-${TSDB_VERSION}.zip \
  && cd opentsdb-${TSDB_VERSION} \
  && echo "tsd.http.request.enable_chunked = true" >> src/opentsdb.conf \
  && echo "tsd.http.request.max_chunk = 1000000" >> src/opentsdb.conf \
  && ./build.sh \
  && cp build-aux/install-sh build/build-aux \
  && cd build \
  && make install \
  && cd /opt \
  && rm -rf opentsdb-${TSDB_VERSION} \
  && : Install Gnuplot \
  && wget https://datapacket.dl.sourceforge.net/project/gnuplot/gnuplot/${GNUPLOT_VERSION}/gnuplot-${GNUPLOT_VERSION}.tar.gz \
  && tar xzf gnuplot-${GNUPLOT_VERSION}.tar.gz \
  && rm -f gnuplot-${GNUPLOT_VERSION}.tar.gz \
  && cd gnuplot-${GNUPLOT_VERSION} \
  && ./configure \
  && make install \
  && cd /opt && rm -rf gnuplot-${GNUPLOT_VERSION} \
  && apk del builddeps && rm -rf /var/cache/apk/*

# Install HBase and scripts
RUN wget http://www.apache.org/dist/hbase/${HBASE_VERSION}/hbase-${HBASE_VERSION}-bin.tar.gz \
  && tar xzvf hbase-${HBASE_VERSION}-bin.tar.gz \
  && mv hbase-${HBASE_VERSION} hbase \
  && rm -rf /opt/hbase/docs \
  && rm -f hbase-${HBASE_VERSION}-bin.tar.gz \
  && mkdir -p /data/hbase /root/.profile.d

# Add misc startup files
RUN ln -s /usr/local/share/openvitsdb/etc/opentsdb /etc/opentsdb \
    && rm -f /etc/opentsdb/opentsdb.conf \
    && mkdir /opentsdb-plugins

ADD files/opentsdb.conf /etc/opentsdb/opentsdb.conf.sample
ADD files/hbase-site.xml /opt/hbase/conf/hbase-site.xml.sample
ADD files/start_opentsdb.sh /opt/bin/
ADD files/create_tsdb_tables.sh /opt/bin/
ADD files/start_hbase.sh /opt/bin/
ADD files/entrypoint.sh /entrypoint.sh

# Fix ENV variables in installed scripts
RUN for i in /opt/bin/start_hbase.sh /opt/bin/start_opentsdb.sh /opt/bin/create_tsdb_tables.sh; \
    do \
        sed -i "s#::JAVA_HOME::#$JAVA_HOME#g; s#::PATH::#$PATH#g; s#::TSDB_VERSION::#$TSDB_VERSION#g;" $i; \
    done

RUN echo "export HBASE_OPTS=\"${HBASE_OPTS}\"" >> /opt/hbase/conf/hbase-env.sh

# 14242 is tsdb, rest are hbase ports
EXPOSE 14242 16010

# HBase is configured to store data in /data/hbase, vol-mount it to persist your data.
VOLUME ["/data/hbase", "/tmp", "/opentsdb-plugins"]

CMD ["/entrypoint.sh"]
