<h1><center>Docker Desktop 笔记</center></h1>

> 本文档为 Docker Desktop (Windows) 的使用记录  
> 当前环境已切换为原生 Docker, 本文档仅供参考

# Docker Desktop 的特殊机制

Docker Desktop 基于 WSL2 虚拟机进行封装, 与原生 Docker 有差异.

1. Docker Desktop 会自动为容器提供以下 DNS 解析:

| 域名                         | 解析到                 |
| ---------------------------- | ---------------------- |
| `host.docker.internal`       | 宿主机(Windows)IP      |
| `gateway.docker.internal`    | Docker 网关 IP         |
| `kubernetes.docker.internal` | Kubernetes API(如启用) |

2. 不支持 host 网络模式(`--network host`), 容器无法直接使用宿主机网络栈.

# WSL2 mirrored 模式下的注意事项

Docker Desktop 配合 WSL2 的 `networkingMode=mirrored` 时,  
容器端口直接映射到 Windows 的 localhost, 无需通过 WSL2 的 IP 访问, 很方便.  
但可能出现一些意外的网络行为.

## MySQL 的连接

Mirrored 网络模式下, Navicat 连接 MySQL 要勾选 SSL 参数, 不然连接速度很慢.  
原因可能和该网络模式下反向 DNS 解析超时有关.

另外, 使用命令分别启动主从模式的容器的话,  
从节点连接主节点要用 `host.docker.internal` + 宿主机映射端口. 比如:

```sql
CHANGE MASTER TO
  master_host = 'host.docker.internal',
  master_port = 13306,
  ...
```

原因: Docker Desktop 的 `docker run` 各自独立启动, 不在同一个 Docker 网络内, 无法通过容器名直接通信.  
只能走宿主机网络绕一圈: 从库 → 宿主机(13306) → 主库(3306)

## 集群通信

Mirrored 网络模式下, 集群节点间通信需要通过 `host.docker.internal`  
比如:

```conf
# redis.conf
cluster-announce-ip host.docker.internal
```

同时需要确认 Windows 的 hosts 文件 (`C:\Windows\System32\drivers\etc\hosts`) 包含:

```
127.0.0.1 host.docker.internal
127.0.0.1 gateway.docker.internal
127.0.0.1 kubernetes.docker.internal
```

# Mirrored 网络模式的 Redis 集群命令实践

Redis集群, 三主三从

```conf
# 基于官方默认配置文件, 修改以下的配置:
# 单节点配置
dir /data
logfile /data/redis.log
appendonly yes
protected-mode no
bind * -::*
# 多节点配置(在单节点基础上额外添加)
# 注意检查 Windows 的 hosts 文件有 "127.0.0.1 host.docker.internal"
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-announce-ip host.docker.internal
```

```bash
# bridge 默认模式, 带数据卷
docker run -itd --name redis-node1 -p 6379:6379 -p 16379:16379 -v ./redis-cluster.conf:/redis.conf -v ./data-6379:/data redis:7 redis-server /redis.conf --port 6379
docker run -itd --name redis-node2 -p 6380:6380 -p 16380:16380 -v ./redis-cluster.conf:/redis.conf -v ./data-6380:/data redis:7 redis-server /redis.conf --port 6380
docker run -itd --name redis-node3 -p 6381:6381 -p 16381:16381 -v ./redis-cluster.conf:/redis.conf -v ./data-6381:/data redis:7 redis-server /redis.conf --port 6381
docker exec -it redis-node1 sh
redis-cli --cluster create host.docker.internal:6379 host.docker.internal:6380 host.docker.internal:6381 --cluster-replicas 0

# bridge 自搭网络, 无数据卷
docker network create --driver=bridge --subnet=172.168.0.0/24 --gateway=172.168.0.1 sql-net
docker run -itd --name redis-node1 --net=sql-net --ip=172.168.0.11 -p 6379:6379 -p 16379:16379 -v ./redis-cluster.conf:/redis.conf redis:7 redis-server /redis.conf --cluster-announce-port 6379 --cluster-announce-bus-port 16379
docker run -itd --name redis-node2 --net=sql-net --ip=172.168.0.12 -p 6380:6379 -p 16380:16379 -v ./redis-cluster.conf:/redis.conf redis:7 redis-server /redis.conf --cluster-announce-port 6380 --cluster-announce-bus-port 16380
docker run -itd --name redis-node3 --net=sql-net --ip=172.168.0.13 -p 6381:6379 -p 16381:16379 -v ./redis-cluster.conf:/redis.conf redis:7 redis-server /redis.conf --cluster-announce-port 6381 --cluster-announce-bus-port 16381
docker exec -it redis-node1 sh
redis-cli --cluster create 172.168.0.11:6379 172.168.0.12:6379 172.168.0.13:6379 --cluster-replicas 0   # 用host.docker.internal加上暴露端口号也可以

# container 模式
docker run -itd --name redis-node1  -p 6379:6379 -p 6380:6380 -p 6381:6381 -v ./redis-cluster.conf:/redis.conf -v ./data-6379:/data redis:7 redis-server /redis.conf --port 6379
docker run -itd --name redis-node2  --net=container:redis-node1 -v ./redis-cluster.conf:/redis.conf -v ./data-6380:/data redis:7 redis-server /redis.conf --port 6380
docker run -itd --name redis-node3  --net=container:redis-node1 -v ./redis-cluster.conf:/redis.conf -v ./data-6381:/data redis:7 redis-server /redis.conf --port 6381
docker exec -it redis-node1 sh
redis-cli --cluster create 127.0.0.1:6379 127.0.0.1:6380 127.0.0.1:6381 --cluster-replicas 0

# host 模式不支持(Windows Docker Desktop 限制)
```

> Docker Compose 支持用 `.env` 文件定义变量,  
> 可在 `compose.yml` 中用 `${VAR_NAME}` 引用. 简化重复字段. 举例:  
> .env 文件: `HOST=host.docker.internal`  
> 引用处: `command: redis-cli --cluster create ${HOST}:7001 ${HOST}:7002 ...`

# Redis Cluster 在 Docker 中的网络机制

## cluster-announce-ip 的作用

`cluster-announce-ip` 告诉其他节点和客户端: 别人应该怎样找到我

这个地址用于:

1. 节点间通信: 其他节点用这个地址来连接你(心跳, Gossip)
2. 客户端重定向: 客户端拿到拓扑后,用这个地址访问各节点

## 地址选择原则

必须是所有 Redis 节点都能互相访问的地址.

假设网络结构:

```
Docker 容器:172.17.x.x(内网)
宿主机:192.168.x.x(中网)
堡垒机:10.x.x.x(外网)
```

| 填写        | 节点间通信            | 外部客户端 | 结论   |
| ----------- | --------------------- | ---------- | ------ |
| 172.17.x.x  | 其他机器访问不到      | 否         | 不可用 |
| 192.168.x.x | 同网段可互通          | 取决于网络 | 推荐   |
| 10.x.x.x    | Redis节点可能访问不到 | 是         | 不可用 |

## 堡垒机访问的方案

如果客户端在堡垒机(10网段), 无法直接访问 Redis 节点(192网段):

1. 打通网络: 让堡垒机能直接访问 192 网段
2. Redis Proxy: 客户端访问 Proxy(10网段), Proxy 访问 Redis 集群(192网段), 常用: Twemproxy, Codis, Redis Cluster Proxy

## cluster-announce-hostname 的区别

- `cluster-announce-ip`: 影响节点间通信和客户端访问
- `cluster-announce-hostname`: 不影响节点间通信, 只影响客户端拿到的地址(配合 `cluster-preferred-endpoint-type hostname`)

节点间通信始终用 `node->ip`(内部 IP 或 `cluster-announce-ip`), 不会用 hostname.

## cluster-announce-hostname 的实践

在 Docker bridge 网络模式下, `cluster-announce-ip` 无法同时满足节点间通信和外部客户端访问. 替代方案:

```conf
cluster-announce-hostname localhost
cluster-preferred-endpoint-type hostname
```

工作原理:

- 节点间通信用 Docker 内部 IP(自动检测), 不受影响
- `cluster-preferred-endpoint-type hostname` 让 Redis 返回拓扑时优先用 hostname 而不是 IP
- 外部客户端拿到 `localhost:7001`, 通过端口映射访问容器

实际测试结果:

- 集群构建: 正常
- 外部客户端(GUI): 正常
- 容器内部集群模式(`redis-cli -c`): 失败, 因为容器内部的 `localhost` 指向自己, 重定向时连不到其他节点

这个限制在实际开发中影响不大, 因为客户端通常在宿主机上运行.

更优方案是使用 host 网络模式, 所有节点共享宿主机网络栈, 彻底避免此问题.
