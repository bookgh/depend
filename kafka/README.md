## [Fork](https://github.com/wurstmeister/kafka-docker)

> 单示例

```
DATA=/data

cat <<EOF    > docker-compose.yml
version: '3.1'
services:

    zookeeper:
        image: bookgh/zookeeper:3.4.14
        restart: always
        volumes:
            - ${DATA}/zookeeper/data:/data
            - ${DATA}/zookeeper/logs:/logs
            - ${DATA}/zookeeper/datalog:/datalog
        ports:
            - 2181:2181

    kafka:
        image: bookgh/kafka:2.12-2.2.0
        restart: always
        environment:
            KAFKA_ADVERTISED_HOST_NAME: kafka
            KAFKA_ADVERTISED_PORT: 9092
            KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
            KAFKA_CREATE_TOPICS: "topic-jhipster:1:1,calc:10:1"
        volumes:
            - ${data}/kafka:/kafka
        ports:
            - 9092:9092
EOF

docker-compose up -d
```
