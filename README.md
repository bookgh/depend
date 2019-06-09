## 使用方法

### 1. 使用已经生成的镜像

#### 1.1 pull 镜像

    docker pull bookgh/zookeeper:3.4.14
    docker pull bookgh/kafka:2.12-2.2.0
    docker pull bookgh/opentsdb:2.3.1
    docker pull bookgh/hazelcast:3.9.1

#### 1.2 创建容器启动文件

> 数据存储路径

    DATA=/data

> 创建启动文件

    cat <<EOF    >docker-compose.yml
    version: '3.1'
    services:
      zookeeper:
          image: bookgh/zookeeper:3.4.14
          hostname: zookeeper
          restart: always
          volumes:
              - ${DATA}/zookeeper:/opt/zookeeper-3.4.14/data
          ports:
              - 2181:2181
              - 2888:2888
              - 3888:3888

      kafka:
          image: bookgh/kafka:2.12-2.2.0
          hostname: kafka
          restart: always
          environment:
              KAFKA_ADVERTISED_HOST_NAME: kafka
              KAFKA_ADVERTISED_PORT: 9092
              KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
              KAFKA_CREATE_TOPICS: "topic-jhipster:1:1,calc:10:1"
          volumes:
              - ${DATA}/kafka:/kafka
          ports:
              - 9092:9092

      opentsdb:
          image: bookgh/opentsdb:2.3.1
          hostname: opentsdb
          restart: always
          environment:
              - WAITSECS=30    
          ports:
              - 14242:14242
              - 16010:16010
          volumes:  
              - ${DATA}/hbase:/data/hbase

      fastdfs:
          image: bookgh/fastdfs:alpine
          hostname: fastdfs
          restart: always
          environment:
              TRACKER_SERVER: fastdfs:22122 
          volumes:
              - ${DATA}/fastdfs:/home/fdfs
          ports:
              - 8888:8888
              - 22122:22122
       
      hazelcast:
          image: bookgh/hazelcast:3.9.1
          hostname: hazelcast
          restart: always
          environment:
              GROUP_NAME: mango-prod
          ports:
              - 5701:5701
    EOF

#### 1.3 启动容器

    docker-compose up -d
    docker-compose up logs -f

### 2. 生成本地镜像

> 注：此仓库Dockerfile文件中的软件源可能会失效

#### 2.1 下载解压 Dockerfile

    wget https://github.com/bookgh/depend/archive/master.zip
    unzip master.zip

#### 2.2 生成镜像

    cd depend
    docker build -t $(cat zookeeper/.VERSION) zookeeper
    docker build -t $(cat kafka/.VERSION) kafka
    docker build -t $(cat opentsdb/.VERSION) opentsdb
    docker build -t $(cat fastdfs/.VERSION) fastdfs
    docker build -t $(cat hazelcast/.VERSION) hazelcast

#### 2.3 创建容器启动文件

> 数据存储路径

    DATA=/data

> 创建启动文件

    cat <<EOF    >docker-compose.yml
    version: '3.1'
    services:
      zookeeper:
          image: zookeeper:3.4.14
          hostname: zookeeper
          restart: always
          volumes:
              - ${DATA}/zookeeper:/opt/zookeeper-3.4.14/data
          ports:
              - 2181:2181
              - 2888:2888
              - 3888:3888

      kafka:
          image: kafka:2.12-2.2.0
          hostname: kafka
          restart: always
          environment:
              KAFKA_ADVERTISED_HOST_NAME: kafka
              KAFKA_ADVERTISED_PORT: 9092
              KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
              KAFKA_CREATE_TOPICS: "topic-jhipster:1:1,calc:10:1"
          volumes:
              - ${DATA}/kafka:/kafka
          ports:
              - 9092:9092

      opentsdb:
          image: opentsdb:2.3.1
          hostname: opentsdb
          restart: always
          environment:
              - WAITSECS=30    
          ports:
              - 14242:14242
              - 16010:16010
          volumes:  
              - ${DATA}/hbase:/data/hbase

      fastdfs:
          image: fastdfs:alpine
          hostname: fastdfs
          restart: always
          environment:
              TRACKER_SERVER: fastdfs:22122 
          volumes:
              - ${DATA}/fastdfs:/home/fdfs
          ports:
              - 8888:8888
              - 22122:22122
       
      hazelcast:
          image: hazelcast:3.9.1
          hostname: hazelcast
          restart: always
          environment:
              GROUP_NAME: mango-prod
          ports:
              - 5701:5701
    EOF

#### 2.4 启动容器

    docker-compose up -d
    docker-compose logs -f
