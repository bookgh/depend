## [Fork](https://github.com/31z4/zookeeper-docker/blob/master/3.4.14/Dockerfile)

> 单个示例

```
docker run --name some-zookeeper --restart always -d bookgh/zookeeper:3.4.14
```

> 3节点集群

```
cat <<'EOF'   >docker-compose.yml
version: '3.1'

services:
    zoo1:
        image: bookgh/zookeeper:3.4.14
        restart: always
        hostname: zoo1
        ports:
            - 2181:2181
        environment:
            ZOO_MY_ID: 1
            ZOO_SERVERS: server.1=0.0.0.0:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=zoo3:2888:3888;2181

    zoo2:
        image: bookgh/zookeeper:3.4.14
        restart: always
        hostname: zoo2
        ports:
            - 2182:2181
        environment:
            ZOO_MY_ID: 2
            ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=0.0.0.0:2888:3888;2181 server.3=zoo3:2888:3888;2181

    zoo3:
        image: bookgh/zookeeper:3.4.14
        restart: always
        hostname: zoo3
        ports:
            - 2183:2181
        environment:
            ZOO_MY_ID: 3
            ZOO_SERVERS: server.1=zoo1:2888:3888;2181 server.2=zoo2:2888:3888;2181 server.3=0.0.0.0:2888:3888;2181
EOF


docker-compose up -d
```
