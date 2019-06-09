#!/bin/sh

NGINX_PORT=${NGINX_PORT:-8888}
TRACKER_SERVER=${TRACKER_SERVER:-fastdfs:22122}

mkdir -p /home/fdfs/storage/data /home/fdfs/tracker /home/nginx/logs
sed -i "s#listen .*#listen $NGINX_PORT;#g" /usr/local/nginx/conf/nginx.conf;
sed -i "s#http.server_port=.*#http.server_port=$NGINX_PORT#g" /etc/fdfs/storage.conf;
sed -i "s/^tracker_server=.*/tracker_server=$TRACKER_SERVER/g" /etc/fdfs/client.conf;
sed -i "s/^tracker_server=.*/tracker_server=$TRACKER_SERVER/g" /etc/fdfs/storage.conf;
sed -i "s/^tracker_server=.*/tracker_server=$TRACKER_SERVER/g" /etc/fdfs/mod_fastdfs.conf;

# start fdfs
/etc/init.d/fdfs_trackerd start;
sleep 3
/etc/init.d/fdfs_storaged start;

exec "$@"
