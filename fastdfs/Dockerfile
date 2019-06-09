FROM alpine:latest

ENV HOME /root
ENV NGINX_PORT 8888
ENV FDFS_PORT 22122

# 安装准备
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
   && apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers libxslt-dev gd-dev geoip-dev perl-dev libedit-dev mercurial bash alpine-sdk findutils \
# 下载libfastcommon、fastdfs、fastdfs-nginx-module、nginx插件的源码
   && cd ${HOME} \
   && curl -L https://github.com/happyfish100/libfastcommon/archive/master.tar.gz -o libfastcommon-master.tar.gz \
   && curl -L https://github.com/happyfish100/fastdfs/archive/master.tar.gz -o fastdfs-master.tar.gz \
   && curl -L https://github.com/happyfish100/fastdfs-nginx-module/archive/master.tar.gz -o fastdfs-nginx-module-master.tar.gz \
   && curl -L http://nginx.org/download/nginx-1.15.3.tar.gz -o nginx-1.15.3.tar.gz \
   && tar xvf libfastcommon-master.tar.gz \
   && tar xvf fastdfs-master.tar.gz \
   && tar xvf fastdfs-nginx-module-master.tar.gz \
   && tar xvf nginx-1.15.3.tar.gz \
# 安装libfastcommon
   && cd ${HOME}/libfastcommon-master/ \
   && ./make.sh \
   && ./make.sh install \
# 安装fastdfs
   && cd ${HOME}/fastdfs-master/ \
   && ./make.sh \
   && ./make.sh install \
# 配置fastdfs: base_dir
   && cd /etc/fdfs/ \
   && cp storage.conf.sample storage.conf \
   && cp tracker.conf.sample tracker.conf \
   && cp client.conf.sample client.conf \
   && sed -i "s|/home/yuqing/fastdfs|/home/fdfs/tracker|g" /etc/fdfs/tracker.conf \
   && sed -i "s|/home/yuqing/fastdfs|/home/fdfs/storage|g" /etc/fdfs/storage.conf \
   && sed -i "s|/home/yuqing/fastdfs|/home/fdfs/storage|g" /etc/fdfs/client.conf \
# 获取nginx源码，与fastdfs插件一起编译
   && chmod u+x ${HOME}/fastdfs-nginx-module-master/src/config \
   && cd ${HOME}/nginx-1.15.3 \
   && ./configure --add-module=${HOME}/fastdfs-nginx-module-master/src \
   && make && make install \
# 设置nginx和fastdfs联合环境，并配置nginx
   && cp ${HOME}/fastdfs-nginx-module-master/src/mod_fastdfs.conf /etc/fdfs/ \
   && sed -i "s|^store_path0.*$|store_path0=/home/fdfs/storage|g" /etc/fdfs/mod_fastdfs.conf \
   && sed -i "s|^url_have_group_name =.*$|url_have_group_name = true|g" /etc/fdfs/mod_fastdfs.conf \
   && cd ${HOME}/fastdfs-master/conf/ \
   && cp http.conf mime.types anti-steal.jpg /etc/fdfs/ \
   && cd ${HOME} && rm -rf ${HOME}/* \
   && apk del .build-deps \
   && apk add --no-cache bash pcre

ADD entrypoint.sh /entrypoint.sh
ADD nginx.conf /usr/local/nginx/conf/nginx.conf

RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/local/nginx/sbin/nginx", "-g", "daemon off;"]
