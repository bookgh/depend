> 单示例

```
DATA=/data

cat <<EOF   >docker-compose.yml
version: '3.1'
services:

    fastdfs:
        image: fastdfs:alpine
        restart: always
        hostname: fastdfs
        environment:
            TRACKER_SERVER: fastdfs:22122 
        volumes:
            - /data/fastdfs:/home/fdfs
        ports:
            - 8888:8888
            - 22122:22122
EOF
