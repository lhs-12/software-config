# <center>Redis-Dokcer命令行</center>

# 事前准备

1. 安装WSL2, 配置使用mirrored网络
2. 安装Docker Desktop
3. 检查windows下hosts文件, `host.docker.internal` 映射到 `127.0.0.1`

# Redis单节点

```
docker pull redis

docker run -itd ^
--name redis ^
-p 6379:6379 ^
-v D:/ProgramData/redis/redis.conf:/redis.conf ^
-v D:/ProgramData/redis/data:/data ^
redis:7.2.4-alpine3.19 ^
redis-server /redis.conf

以下是redis.conf配置
去官方找默认配置文件,修改以下的配置:

dir /data
logfile /data/redis.log
appendonly yes
protected-mode no
bind * -::*
```

# Redis集群

Redis集群, 三主无从
```
注意: 检查windows的hosts文件(C:\Windows\System32\drivers\etc\hosts), 确认有以下配置
127.0.0.1 host.docker.internal
127.0.0.1 gateway.docker.internal
127.0.0.1 kubernetes.docker.internal

配置文件在单节点的基础上增加以下配置:
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-announce-ip host.docker.internal

# bridge默认模式(可用), 有数据卷
docker run -itd --name redis-node1 -p 6379:6379 -p 16379:16379 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf -v D:/ProgramData/redis/data-6379:/data redis:7.2.4-alpine3.19 redis-server /redis.conf --port 6379
docker run -itd --name redis-node2 -p 6380:6380 -p 16380:16380 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf -v D:/ProgramData/redis/data-6380:/data redis:7.2.4-alpine3.19 redis-server /redis.conf --port 6380
docker run -itd --name redis-node3 -p 6381:6381 -p 16381:16381 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf -v D:/ProgramData/redis/data-6381:/data redis:7.2.4-alpine3.19 redis-server /redis.conf --port 6381
docker exec -it redis-node1 sh
redis-cli --cluster create host.docker.internal:6379 host.docker.internal:6380 host.docker.internal:6381 --cluster-replicas 0

# bridge自搭网络(可用), 无数据卷
docker network create --driver=bridge --subnet=172.168.0.0/24 --gateway 172.168.0.1 sql-net
docker run -itd --name redis-node1 --net=sql-net --ip=172.168.0.11 -p 6379:6379 -p 16379:16379 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf redis:7.2.4-alpine3.19 redis-server /redis.conf --cluster-announce-port 6379 --cluster-announce-bus-port 16379
docker run -itd --name redis-node2 --net=sql-net --ip=172.168.0.12 -p 6380:6379 -p 16380:16379 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf redis:7.2.4-alpine3.19 redis-server /redis.conf --cluster-announce-port 6380 --cluster-announce-bus-port 16380
docker run -itd --name redis-node3 --net=sql-net --ip=172.168.0.13 -p 6381:6379 -p 16381:16379 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf redis:7.2.4-alpine3.19 redis-server /redis.conf --cluster-announce-port 6381 --cluster-announce-bus-port 16381
docker exec -it redis-node1 sh
redis-cli --cluster create 172.168.0.11:6379 172.168.0.12:6379 172.168.0.13:6379 --cluster-replicas 0   # 用host.docker.internal加上暴露端口号也可以

# container模式(可用)
docker run -itd --name redis-node1  -p 6379:6379 -p 6380:6380 -p 6381:6381 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf -v D:/ProgramData/redis/data-6379:/data redis:7.2.4-alpine3.19 redis-server /redis.conf --port 6379
docker run -itd --name redis-node2  --net=container:redis-node1 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf -v D:/ProgramData/redis/data-6380:/data redis:7.2.4-alpine3.19 redis-server /redis.conf --port 6380
docker run -itd --name redis-node3  --net=container:redis-node1 -v D:/ProgramData/redis/redis-cluster.conf:/redis.conf -v D:/ProgramData/redis/data-6381:/data redis:7.2.4-alpine3.19 redis-server /redis.conf --port 6381
docker exec -it redis-node1 sh
redis-cli --cluster create 127.0.0.1:6379 127.0.0.1:6380 127.0.0.1:6381 --cluster-replicas 0

# host模式, windows docker desktop不支持
```